/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-12-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class Inwib2c_GetCanalFromOrder implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try {
            if (methodName.equals('getCanalToOrder')) {
                getCanalToOrder(inputMap, outMap, options); // Appel de la méthode pour récupérer le canal
            } else {
                result = false;
                System.debug('Unknown methodName: ' + methodName);
            }
        } catch (Exception e) {
            result = false;
            System.debug('Error in invokeMethod: ' + e.getMessage());
        }
        return result;
    }

    public static void getCanalToOrder(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            // Récupération de l'OrderId à partir du inputMap
            String orderId = (String) inputMap.get('orderId');
            
            if (orderId == null) {
                throw new IllegalArgumentException('OrderId cannot be null.');
            }

            // Requête pour récupérer le champ InwiB2C_Canal__c à partir de l'objet Order
            Order ord = [SELECT Id, InwiB2C_Canal__c FROM Order WHERE Id = :orderId LIMIT 1];

            // Mettre le canal dans le outMap pour l'utiliser ailleurs
            outMap.put('InwiB2C_Canal__c', ord.InwiB2C_Canal__c);

            System.debug('Canal retrieved: ' + ord.InwiB2C_Canal__c);
        } catch (Exception e) {
            System.debug('Error in getCanalToOrder: ' + e.getMessage());
            throw new AuraHandledException('Error retrieving order canal.');
        }
    }
}