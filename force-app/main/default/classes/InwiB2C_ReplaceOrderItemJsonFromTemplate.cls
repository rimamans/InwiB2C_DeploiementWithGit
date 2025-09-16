/**
 * @description       : Remplace le JSON des SIM d'une commande par celui d'un template basé sur le produit parent
 * @author            : Mise à jour
 * @last modified on  : 07-13-2025
**/
global without sharing class InwiB2C_ReplaceOrderItemJsonFromTemplate implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {
        Boolean result = true;
        try {
            if (methodName == 'replaceOrderItemJson') {
                Id orderId = (Id) inputMap.get('orderId');
                Boolean success = replaceOrderItemJson(orderId);
                outputMap.put('status', success ? 'OK' : 'KO');
            } else {
                outputMap.put('status', 'KO');
                outputMap.put('message', 'Méthode inconnue : ' + methodName);
                result = false;
            }
        } catch (Exception e) {
            System.debug('Erreur dans invokeMethod : ' + e.getMessage());
            result = false;
            outputMap.put('status', 'ERROR');
            outputMap.put('message', e.getMessage());
        }
        return result;
    }

    public static Boolean replaceOrderItemJson(Id orderId) {
        //  Récupérer tous les OrderItem de la commande
        List<OrderItem> allOrderItems = [
            SELECT Id, vlocity_cmt__JSONAttribute__c, Product2Id, Product2.Name, Product2.ProductCode, vlocity_cmt__ParentItemId__c
            FROM OrderItem
            WHERE OrderId = :orderId
        ];

      System.debug('==> Nombre d\'OrderItem récupérés : ' + allOrderItems.size());

        if (allOrderItems.isEmpty()) return false;

        //  Trouver le product code de parent OrderItem
        OrderItem parentItem = null;
        for (OrderItem item : allOrderItems) {
            if (item.vlocity_cmt__ParentItemId__c == null) {
                parentItem = item;
                break;
            }
        }

        if (parentItem == null || String.isBlank(parentItem.Product2.ProductCode)) {
            return false;
        }

        System.debug('==> Code produit du parent : ' + parentItem.Product2.ProductCode);
        String parentProductCode = parentItem.Product2.ProductCode;

        // Récupérer OrderTemplate avec product code 
        List<inwib2c_OrderTemplateEshop__mdt> templates = [SELECT OrderId__c FROM inwib2c_OrderTemplateEshop__mdt WHERE CodeProduct__c = :parentProductCode LIMIT 1];
       
        System.debug('==> Nombre de templates trouvés : ' + templates.size());

        if (templates.isEmpty()) return false;

        Id templateOrderId = templates[0].OrderId__c;

        //  Récupérer le JSON du SIM depuis la commande template
        List<OrderItem> templateSimItems = [SELECT vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE OrderId = :templateOrderId AND Product2.Name = 'SIM' LIMIT 1];

        System.debug('==> Nombre de SIM dans la commande template : ' + templateSimItems.size());

        if (templateSimItems.isEmpty()) return false;

        String templateJson = templateSimItems[0].vlocity_cmt__JSONAttribute__c;

        //  Mettre à jour les OrderItem SIM de la commande
        List<OrderItem> simItemsToUpdate = new List<OrderItem>();
        for (OrderItem item : allOrderItems) {
            if (item.Product2 != null && item.Product2.Name == 'SIM') {
             String typeSim = INWIB2C_INWIJSONAttributeUtilities.getAttributeValueFromJSON(item.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_TYPESIM');
             System.debug('==> TypeSIM pour l\'OrderItem ' + item.Id + ' : ' + typeSim);
                if( String.isBlank(typeSim) ){ 
                item.vlocity_cmt__JSONAttribute__c = templateJson;
                simItemsToUpdate.add(item);
            }else{
               System.debug('==> TypeSIM existe déjà, on ne remplace pas');

            }
              }
              
        }
        System.debug('==> Nombre de SIM à mettre à jour : ' + simItemsToUpdate.size());

        if (simItemsToUpdate.isEmpty()) return false;

        update simItemsToUpdate;

        return true;
    }
}