public with sharing class inwiB2C_HandleChNumPorta {
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {
        
        if (methodName.equals('updateAttributes')) {
            updateAttributes((String)inputMap.get('traceApiId'));
        }
        return true;
    }
    public void  updateAttributes(String traceApiId) {
        // recuperer le panier et les orderItems
        inwib2c_TraceDemandeEshop__c panier = [select inwib2c_OrderId__c, inwib2c_MDN__c, inwib2c_Request_body__c, inwib2c_Statut__c, InwiB2C_submite__c, InwiB2C_PordtedMDN__c from inwib2c_TraceDemandeEshop__c where IdTraceAPI__c = :traceApiId];
        List<OrderItem> orderItems = [select id, Product2.ProductCode, vlocity_cmt__Action__c, vlocity_cmt__JSONAttribute__c  from OrderItem  where OrderId = :panier.inwib2c_OrderId__c];
        
        // stocker les orderItems dans un map par leur codeProduct
        Map<String,OrderItem> orderItemByProductCode = new Map<String,Orderitem>();
        for (OrderItem orderItem : orderItems) {
            orderItemByProductCode.put(orderItem.Product2.ProductCode, orderItem);
        }
        /* recuperer l'orderItem INWIB2C_OFFERING_MSISDN_STANDARD pour update les attributes INWIB2C_ATT_RT_MSISDN 
        et INWIB2C_ATT_RT_MSISDN_PROVISIONAL avec la valeur du mdn d'origin et l'action a change */
        // OrderItem msisdnOrderItem = orderItemByProductCode.get('INWIB2C_OFFERING_MSISDN_STANDARD');
        OrderItem msisdnOrderItem;
        for (OrderItem orderItem: orderItems) {
            if (orderItem.Product2.ProductCode.contains('OFFERING_MSISDN_STANDARD')) {
                msisdnOrderItem = orderItem;
            }
        }
        if (msisdnOrderItem != null) {
            System.debug('msisdn ' + msisdnOrderItem);
            Map<String,String> msisdnOrderItemAttr = new Map<String,String>();
            msisdnOrderItemAttr.put('INWIB2C_ATT_RT_MSISDN', (String)panier.InwiB2C_PordtedMDN__c);
            System.debug('msisdnAtt' + msisdnOrderItemAttr);
            String msisdnOrderItemResult = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON((String)msisdnOrderItem.vlocity_cmt__JSONAttribute__c, msisdnOrderItemAttr);
            msisdnOrderItem.vlocity_cmt__JSONAttribute__c=msisdnOrderItemResult;
            msisdnOrderItem.vlocity_cmt__Action__c='change';
            update msisdnOrderItem;
        }
        // Object inputJsonMap = JSON.deserializeUntyped(panier.InwiB2C_request_body__c);
        // recuperer le corps de la requete depuis le panier 
        Map<String,Object> jsoncastMap = (Map<String,Object>) JSON.deserializeUntyped(panier.InwiB2C_request_body__c);
        //Map<String,Object> jsoncastMap = (Map<String,Object>)jsonMap[0];
        System.debug(jsoncastMap);
        
        List<Object> products = (List<Object>)jsoncastMap.get('products');
        System.debug(products);
        // parcourir la list des product de la requete
        for (Object product: products) {
            
            // stocker le produit dans une map
            Map<String,Object> productObj = (Map<String,Object>) product;
            // recuperer l'orderItem du current product
            OrderItem currentOrderItem = (OrderItem)orderItemByProductCode.get((String)productObj.get('code'));

            // recuperer les attributs depuis la requete
            List<Object> attributs = (List<Object>)productObj.get('attributes');
            System.debug(attributs);
            if (attributs != null) {
                Map<String,String> inputAttributes = new Map<String,String>();
                // parcourir tout les attributs, les stocker dans une map
                for ( Object attributObjInp: attributs) {
                    Map<String,Object> attributMapInp = (Map<String,Object>)attributObjInp;
                    System.debug(attributMapInp);
                    inputAttributes.put((String)attributMapInp.get('code'), (String)attributMapInp.get('value'));
                }
                // ajouter les attribut stocker dans la map au current orderitem
                String resultOrderItem = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentOrderItem.vlocity_cmt__JSONAttribute__c, inputAttributes);
                currentOrderItem.vlocity_cmt__JSONAttribute__c=resultOrderItem;
            }
            
            // recuperer les sous-produit 
            List<Object> subProducts = (List<Object>)productObj.get('subProducts');
            System.debug(subProducts);
            if (subProducts != null) {
                // parcourir sur les sous-produit 
                for (Object subProduct: subProducts) {
                    Map<String,Object> subProductObj = (Map<String,Object>) subProduct;
                    //recuperer l'orderitem du sous-produit
                    OrderItem subOrderItem = orderItemByProductCode.get((String)subProductObj.get('code'));
                    System.debug('suborderitem '+ subOrderItem);
                    if (subOrderItem != null) {
                        // recuperer les attributes du sous-produit
                        List<Object> subProdAttributes = (List<Object>)subProductObj.get('attributes');
                        System.debug('Att ' + subProdAttributes);
                        if (subProdAttributes != null && subOrderItem != null) {
                            Map<String,String> subProdAttInp = new Map<String,String>();
                            // parcourir les attributs, les stocker dans map
                            for (Object subProdAttributeObj: subProdAttributes) {
                                Map<String,Object> subProdAttribute = (Map<String,Object>) subProdAttributeObj;
                                System.debug(subProdAttribute);
                                subProdAttInp.put((String)subProdAttribute.get('code'), (String)subProdAttribute.get('value'));
                            }
                            //ajouter les attributs a l'orderItem du sous-produit
                            String resultSubOrderItem = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON((String)subOrderItem.vlocity_cmt__JSONAttribute__c, subProdAttInp);
                            subOrderItem.vlocity_cmt__JSONAttribute__c = resultSubOrderItem;
                        }
                    }                    
                }
            }
        }
        System.debug(orderItems);
        update orderItems;

        if (panier.InwiB2C_submite__c) {
            Map <String, Object> Params = new Map <String, Object> ();
            String IP_CheckoutOrderAPI = 'inwib2c_CheckoutOrderAPI';
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();

            
            inputMap.put('Id',panier.inwiB2C_OrderId__c);
            optionsMap.put('useQueueableApexRemoting',true);
                
            Params.put('Name',IP_CheckoutOrderAPI);
            Params.put('ipInput',inputMap);
            Params.put('ipOptions',optionsMap);
            system.debug('Params'+(String)JSON.serialize(Params));

            //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
            //appeler la VIP en Async pour faire le checkOut
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        }
    }
}