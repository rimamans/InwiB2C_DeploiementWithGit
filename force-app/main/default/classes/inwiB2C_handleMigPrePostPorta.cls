public with sharing class inwiB2C_handleMigPrePostPorta {
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {
        if (methodName.equals('cloneOrder')) {
            cloneOrder((String)inputMap.get('panierId'));
        } else if (methodName.equals('updateAttributes')) {
            updateAttributes((String)inputMap.get('panierId'));
        }
        return true;
    }
    public void cloneOrder(String panierId) {
        // recuperer le panier eshop
        inwib2c_TraceDemandeEshop__c panier  = [select inwib2c_MDN__c, inwib2c_Request_body__c, inwib2c_Statut__c, InwiB2C_Operator__c, InwiB2C_CodeRio__c, InwiB2C_PordtedMDN__c, InwiB2C_submite__c, inwib2c_FMS_Total__c, inwib2cReference_Paiement_FMS__c, inwib2c_FMD_Total__c, inwib2cReference_Paiement_FMD__c, inwib2c_Mode_de_paiement__c from inwib2c_TraceDemandeEshop__c where Id = :panierId];
        // recuperer le corps de la requete depuis le panier
        Map<String,Object> JsonReqMap = (Map<String,Object>) JSON.deserializeUntyped(panier.InwiB2C_request_body__c);
        // recuperer le Id du compte client et compte de facturation
        String buyerId = (String)JsonReqMap.get('buyerId');
        String customerId = (String)JsonReqMap.get('customerId');
        //recuperer les produits depuis le corps de la requete
        List<Object> products = (List<Object>)JsonReqMap.get('products');
        System.debug('products ' + products);
        Map<String,Object> product = (Map<String,Object>) products[0];
        // recuperer le code offre
        String codeOffre = (String) product.get('code');
        // recuperer le metadata avec le code offre l'utiliser a cloner le order
        inwib2c_OrderTemplateEshop__mdt Obj = [select OrderId__c, CodeProduct__c from inwib2c_OrderTemplateEshop__mdt where  CodeProduct__c= :codeOffre];
        System.debug('obj ' + Obj.OrderId__c);
        // recuperer les champ necessaire pour cloner le order
        Order OrderOriginal= [select Pricebook2Id, vlocity_cmt__FulfilmentStatus__c, vlocity_cmt__IsChangesAllowed__c, vlocity_cmt__PriceListId__c, vlocity_cmt__SubmittedToOmDate__c,inwib2c_TypeDeLaCommande__c,inwib2c_Partenaire__c, inwib2c_Distributeur__c, inwib2c_ModeDePaiement__c, inwiB2C_Statut__c, AccountId, status, EffectiveDate,inwib2c_ModeDeLivraison__c, inwiB2C_Canal__c,vlocity_cmt__CartIdentifier__c,InwiB2C_Offre__c,vlocity_cmt__DefaultBillingAccountId__c,inwib2c_CodeDeTransaction__c from order where id = :Obj.OrderId__c limit 1];
        // cloner le order
        Order newOrder =  OrderOriginal.clone(false, true, false, true);
        newOrder.EffectiveDate = date.today();
        newOrder.InwiB2C_New_Account_Id__c = customerId;
        // recuperer le product avec code offre
        Product2 typeoffre =[select id , vlocity_cmt__Type__c,ProductCode,  vlocity_cmt__SpecificationType__c from product2 where vlocity_cmt__SpecificationType__c ='Offer' AND ProductCode =:codeOffre AND IsActive=true limit 1] ;
        System.debug('typeOffre ' + typeoffre);
        String offerType = '';
        offerType=typeoffre.vlocity_cmt__Type__c;
        System.debug('offertype ' + offerType);
        // update les champ de la order
        newOrder.InwiB2C_Type_Offer__c = offerType;
        newOrder.inwiB2C_Canal__c='InwiB2C_MyInwi';
        // B-25813 M-Dj laisser vide on pas recu begin
        if (buyerId != null && buyerId != '') {
            newOrder.vlocity_cmt__DefaultBillingAccountId__c = buyerId;
        }
        // B-25813 M-Dj laisser vide on pas recu begin
        if (panier.InwiB2C_submite__c) {
            newOrder.inwiB2C_Statut__c='inwiB2C_Activation';
        } else {
            newOrder.inwiB2C_Statut__c='inwiB2C_EnCours';
        }

        // M-DJ 19/12/24 ajouter l'insertion des info de payment FMS et FMD begin

        String payMode = '';
        if (panier.inwib2c_Mode_de_paiement__c == 'En Espece') {
            payMode = 'inwiB2C_EnEspece';
        } else if (panier.inwib2c_Mode_de_paiement__c == 'E-paiement') {
            payMode = 'inwiB2C_E-paiement';
        } else if (panier.inwib2c_Mode_de_paiement__c == 'Fatourati') {
            payMode = 'inwiB2C_Fatourati';
        } else if (panier.inwib2c_Mode_de_paiement__c == 'TPE') {
            payMode = 'inwiB2C_TPE';
        }


        if (panier.inwib2c_FMS_Total__c > 0) {
            newOrder.InwiB2C_Code_de_transaction_FMS__c = panier.inwib2cReference_Paiement_FMS__c;
            newOrder.InwiB2C_Mode_de_paiement_FMS__c = payMode;
        }
        if (panier.InwiB2C_FMD_Total__c > 0) {
            newOrder.InwiB2C_CodeTransactionFMD__c = panier.inwib2cReference_Paiement_FMD__c;
            newOrder.Mode_de_paiement_FMD__c = payMode;
        }

        // M-DJ 19/12/24 ajouter l'insertion des info de payment FMS et FMD end

        // recuperer la souscription avec le mdn pour le post OrderSubscription
        vlocity_cmt__Subscription__c subs = [select Id, vlocity_cmt__AccountId__c, InwiB2C_Partenaire__c, InwiB2C_Distributeur__c from vlocity_cmt__Subscription__c where Inwib2c_Num_ro_de_la_ligne__c = :panier.inwib2c_MDN__c limit 1];
        System.debug('subs ' + subs);

        newOrder.inwib2c_TypeDeLaCommande__c='inwiB2C_Migration';
        newOrder.inwiB2C_TypeDeMigration__c='InwiB2C_MigrationPrePostpayéPorta'; 
        newOrder.AccountId = subs.vlocity_cmt__AccountId__c;
        newOrder.InwiB2C_Subscription_Migration__c = subs.Id;
        newOrder.inwib2c_Partenaire__c = subs.InwiB2C_Partenaire__c;
        newOrder.inwib2c_Distributeur__c = subs.InwiB2C_Distributeur__c;

        System.debug('order ' + newOrder);
        insert newOrder;

        // ajouer le order au panier
        panier.inwib2c_OrderId__c=newOrder.Id;
        update panier;

    
        // inserer le OrderSubscription
        inwiB2C_OrderSubscription__c orderSub = new inwiB2C_OrderSubscription__c();
        orderSub.inwiB2C_Subscription__c=subs.Id;
        orderSub.inwiB2C_Order__c=newOrder.Id;
        insert orderSub;

        // appeler la VIP pour creer une contract
        String createContractProdcedure = 'inwib2c_InwiB2C_CreateContractAPIPrePost';

        Map < String, Object > outputCC = new Map < String, Object >();
        Map < String, Object > inputCC = new Map < String, Object >();
        Map < String, Object > optionsCC = new Map < String, Object >();

        inputCC.put('CanalIdentification', 'InwiB2C_MyInwi');
        inputCC.put('idClient', customerId);

        outputCC = (Map < String, Object > ) vlocity_cmt.IntegrationProcedureService.runIntegrationService(createContractProdcedure, inputCC, optionsCC);
        System.debug('contract out '+ outputCC);


        panier.inwiB2C_Contract__c = (Id) outputCC.get('idContract');
        update panier;
        
        List<String> productItemId = new List<String>();
        List<OrderItem> NewOrderItems= new List<OrderItem>();
        // recuperer les orderItem avec parent non null 
        List<OrderItem> OrderItemsWhereParentNotNull =[select id, InwiB2C_MDN__c,vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c,OrderId,Product2Id, Product2.ProductCode, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__PricingLogData__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :Obj.OrderId__c AND vlocity_cmt__ParentItemId__c !=null  limit 20];  
        // parcourir les orderItem avec parent non null pour stocker les product dans une map
        for (OrderItem orderItem : OrderItemsWhereParentNotNull) {
              productItemId.add(orderItem.Product2Id);
        }
        // recuperer les orderItem de la order cloner
        List<OrderItem> OrderItemsFromOrderBase =[select id, InwiB2C_MDN__c,vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c,OrderId, Product2Id, Product2.ProductCode, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__PricingLogData__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :Obj.OrderId__c  limit 20];        
        Map<String,String> ProductCodeByItemIdMap= new Map<String,String>();
        // stocker les product dans map avec leur order item
        for (OrderItem Item :OrderItemsFromOrderBase){
            ProductCodeByItemIdMap.put(item.id, item.Product2Id);
        }
        System.debug('orderItems ' + ProductCodeByItemIdMap);
        if (codeOffre!='INWIB2C_OFFERING_TERMINAL' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast' && codeOffre!='InwiB2C_TELEPHONE_FIXE') {
            // parcourir les orderItem du order
            for (OrderItem Item :OrderItemsFromOrderBase) {
                OrderItem newOrderItem;
                // recuperer le produit parent dans la map le orderItem courant
                String parentProductId = ProductCodeByItemIdMap.get(Item.vlocity_cmt__ParentItemId__c);
                system.debug('Id de Produit Parent: ' +  parentProductId);
                system.debug('Id de Produit Parent2: ' +  item.Product2Id);
                vlocity_cmt__ProductChildItem__c childItemDef = new vlocity_cmt__ProductChildItem__c();
                if (parentProductId != null){
                    // on recupere le product child si le parent n'est pas null
                    childItemDef = [select vlocity_cmt__MinQuantity__c,vlocity_cmt__Quantity__c from vlocity_cmt__ProductChildItem__c where vlocity_cmt__ParentProductId__c = :parentProductId and vlocity_cmt__ChildProductId__c  = :Item.Product2Id limit 1];
                }
                if (Item.vlocity_cmt__ParentItemId__c == null ||  (parentProductId != null && childItemDef.vlocity_cmt__Quantity__c == 1)) {
                    // cloner le orderItem si le parent = null ou si parent diff de null et la quantity du child est 1 
                    newOrderItem = Item.clone(false, true, false, true);
                    // update des champ du orderItem
                    newOrderItem.OrderId = newOrder.Id;
                    // B-25813 M-Dj laisser vide on pas recu begin
                    if (buyerId != null && buyerId != '') {
                        newOrderItem.vlocity_cmt__BillingAccountId__c = buyerId;
                    }
                    // B-25813 M-Dj laisser vide on pas recu begin
                    NewOrderItems.add(newOrderItem);
                }
            }
        }
        System.debug('orderId ' + newOrder.Id );
        System.debug('orderItems ' + NewOrderItems);
        insert NewOrderItems;

        // appeler la VIP pour update les Orderitem depuis les asset de la souscription
        Map < String, Object > outputOI = new Map < String, Object >();
        Map < String, Object > inputOI = new Map < String, Object >();
        Map < String, Object > optionsOI = new Map < String, Object >();

        String orderitemProcedure = 'inwib2c_InwiB2C_OrderItem';
        inputOI.put('OrderId', newOrder.Id);
        inputOI.put('SubcriptionId', subs.Id);

        outputOI = (Map < String, Object > ) vlocity_cmt.IntegrationProcedureService.runIntegrationService(orderitemProcedure, inputOI, optionsOI);
        System.debug('output ' + outputOI);

        Account customer  = [select InwiB2C_Type_pi_ce_identit__c, Inwib2c_CIN__c from Account where Id = :customerId ];
        OrderItem orderitemParent = [select id, vlocity_cmt__RootItemId__c, Product2.Family from OrderItem where OrderId = :newOrder.Id and vlocity_cmt__ParentItemId__c = null];
        String CinTypeMap = '';
        String natureOffre = orderitemParent.Product2.Family;
        String rootorderitem = orderitemParent.vlocity_cmt__RootItemId__c;
        String newRoute = '';
        Date portaDate = Date.today();

        if (natureOffre == 'Mobile') {
            natureOffre = 'MOBILE';
            newRoute = 'D66';
        } else if (natureOffre == 'FIXE') {
            newRoute = 'D2101';
        } 

        if (customer.InwiB2C_Type_pi_ce_identit__c == 'Carte d\'Identité Nationale') {
            CinTypeMap = '01';
        } else if (customer.InwiB2C_Type_pi_ce_identit__c == 'Passeport') {
            CinTypeMap = '02';
        } else if (customer.InwiB2C_Type_pi_ce_identit__c == 'Carte de séjour') {
            CinTypeMap = '03';
        }

        INWIB2C_PORTABILITE_REQ__c newreqporta = new INWIB2C_PORTABILITE_REQ__c(
                INWIB2C_PORTEDNUMBER__c = panier.InwiB2C_PordtedMDN__c,
                INWIB2C_TEMPNUMBER__c = panier.inwib2c_MDN__c,
                INWIB2C_ORDERID__c = newOrder.Id,
                INWIB2C_ORIGINE_OPERATOR__c = panier.InwiB2C_Operator__c,
                INWIB2C_CLIENT_PORTA__c = customerId,
                INWIB2C_DATE_PORTA__c = portaDate ,
                INWIB2C_REJECT_REASON__c = '',
                INWIB2C_NATIONAL_ID__c = customer.Inwib2c_CIN__c,
                INWIB2C_NATURE_OFFRE__c = natureOffre,
                INWIB2C_NEWROUTE__c = newRoute,
                INWIB2C_STATUT_PORTA__c = 'Nouveau',
                INWIB2C_TYPE_CIN__c = CinTypeMap,
                InwiB2C_Order_Root_Id__c = rootorderitem,
                INWIB2C_RIO__c= panier.InwiB2C_CodeRio__c
            );
        insert newreqporta;
        System.debug(newreqporta);

        // B-29386 29/05/2025 insertion des fms et fmd au niveau du oiparent et order begin
        OrderItem OiParent = [SELECT Id, InwiB2C_FMS__c, InwiB2C_TransactionCode_FMS__c, InwiB2C_FMD__c, InwiB2C_TransactionCode_FMD__c FROM OrderItem WHERE orderId = :newOrder.Id AND vlocity_cmt__ParentItemId__c = null];
        System.debug('OiParent : ' + OiParent);
        System.debug('fms panier : ' + panier.inwib2c_FMS_Total__c);
        System.debug('fmd panier : ' + panier.InwiB2C_FMD_Total__c);
        if (panier.inwib2c_FMS_Total__c != null) {
            OiParent.InwiB2C_FMS__c = panier.inwib2c_FMS_Total__c;
            OiParent.InwiB2C_TransactionCode_FMS__c = panier.inwib2cReference_Paiement_FMS__c;
        }
        if (panier.InwiB2C_FMD_Total__c != null) {
            OiParent.InwiB2C_FMD__c = panier.inwib2c_FMD_Total__c;
            OiParent.InwiB2C_TransactionCode_FMD__c = panier.inwib2cReference_Paiement_FMD__c;
        }
        update OiParent;
        // B-29386 29/05/2025 insertion des fms et fmd au niveau du oiparent et order begin

        // B-25479 ajouter insertion du event pour suivi de commande begin
        Map<String,Object> inputSuivi = new Map<String,Object>();
        Map<String,Object> outputSuivi = new Map<String,Object>();
        Map<String,Object> optionsSuivi = new Map<String,Object>();
        inputSuivi.put('orderId', newOrder.Id);
        inputSuivi.put('externalOrderId', panierId);
        inputSuivi.put('parentStep', 'EVENT_1');
        inputSuivi.put('step', 'SUB_EVENT_1A');
        InwiB2C_ManageSuiviCommEvent.createEvent(inputSuivi, outputSuivi, optionsSuivi);
        // B-25479 ajouter insertion du event pour suivi de commande begin

        // publier l'event pour lancer l'update des attributes

        inwiB2C_MigrPrePostPorta__e event = new inwiB2C_MigrPrePostPorta__e();

        event.inwiB2C_panierId__c = panierId;
        event.inwiB2C_step__c = 'updateAttributes';


        // Call method to publish events
        Database.SaveResult results = EventBus.publish(event);
    }
    public void updateAttributes(String panierId) {

        // recuperer le panier
        inwib2c_TraceDemandeEshop__c panier = [select inwib2c_OrderId__c, inwib2c_MDN__c, inwib2c_Request_body__c, inwib2c_Statut__c, InwiB2C_submite__c from inwib2c_TraceDemandeEshop__c where Id = :panierId];

        // recuperer les orderItem 
        List<OrderItem> orderItems = [select id, Product2.ProductCode, vlocity_cmt__Action__c, vlocity_cmt__JSONAttribute__c  from OrderItem  where OrderId = :panier.inwib2c_OrderId__c];
        
        // stocker les orderitem avec le codeProduct dans une map 
        Map<String,OrderItem> orderItemByProductCode = new Map<String,Orderitem>();
        for (OrderItem orderItem : orderItems) {
            orderItemByProductCode.put(orderItem.Product2.ProductCode, orderItem);
        }

        // recuperer le corps de la requete depuis le panier
        Map<String,Object> jsoncastMap = (Map<String,Object>) JSON.deserializeUntyped(panier.InwiB2C_request_body__c);
        //Map<String,Object> jsoncastMap = (Map<String,Object>)jsonMap[0];
        System.debug(jsoncastMap);
        
        // recuperer les produit depuis le corps de 
        List<Object> products = (List<Object>)jsoncastMap.get('products');
        System.debug(products);

        // parcourir tout les produit
        for (Object product: products) {

            Map<String,Object> productObj = (Map<String,Object>) product;
            // recuperer le orderitem avec le current product 
            OrderItem currentOrderItem = (OrderItem)orderItemByProductCode.get((String)productObj.get('code'));

            // recuperer les attributes
            List<Object> attributs = (List<Object>)productObj.get('attributes');
            System.debug(attributs);
            if (attributs != null) {
                Map<String,String> inputAttributes = new Map<String,String>();
                // parcourir sur les attribues les stocker sur une map
                for ( Object attributObjInp: attributs) {
                    Map<String,Object> attributMapInp = (Map<String,Object>)attributObjInp;
                    System.debug(attributMapInp);
                    inputAttributes.put((String)attributMapInp.get('code'), (String)attributMapInp.get('value'));
                }
                // ajouter les attributs et l'action a change
                String resultOrderItem = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentOrderItem.vlocity_cmt__JSONAttribute__c, inputAttributes);
                currentOrderItem.vlocity_cmt__JSONAttribute__c=resultOrderItem;
                currentOrderItem.vlocity_cmt__Action__c='change';
            }
            
            // recuper les sous-produit
            List<Object> subProducts = (List<Object>)productObj.get('subProducts');
            System.debug(subProducts);
            if (subProducts != null) {
                // parcourir les sous-produit
                for (Object subProduct: subProducts) {
                    Map<String,Object> subProductObj = (Map<String,Object>) subProduct;
                    OrderItem subOrderItem = orderItemByProductCode.get((String)subProductObj.get('code'));
                    if (subOrderItem != null) {
                        // recuperer les attrinuts depuis le sous-produits
                        List<Object> subProdAttributes = (List<Object>)subProductObj.get('attributes');
                        System.debug('Att ' + subProdAttributes);
                        if (subProdAttributes != null && subOrderItem != null) {
                            Map<String,String> subProdAttInp = new Map<String,String>();
                            // parcourir les attributes et les stocker dans un map
                            for (Object subProdAttributeObj: subProdAttributes) {
                                Map<String,Object> subProdAttribute = (Map<String,Object>) subProdAttributeObj;
                                System.debug(subProdAttribute);
                                subProdAttInp.put((String)subProdAttribute.get('code'), (String)subProdAttribute.get('value'));
                            }
                            // ajouter les attributs au current orderitem
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

                
            inputMap.put('Id',panier.inwib2c_OrderId__c);
            optionsMap.put('useQueueableApexRemoting',true);
            
            Params.put('Name',IP_CheckoutOrderAPI);
            Params.put('ipInput',inputMap);
            Params.put('ipOptions',optionsMap);
            system.debug('Params'+(String)JSON.serialize(Params));

            //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
            // appeler la vip pour le checkout
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        }
    }
}