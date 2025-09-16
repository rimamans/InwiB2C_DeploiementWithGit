/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-05-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class InwiB2C_ApplyFMSCalculator implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap) {
        Boolean result = true; 
        try {
            if (methodName == 'ApplyFMSByOrderId') {
                ApplyFMSByOrderId(inputMap, outputMap, optionsMap);
            }
        } catch(Exception e) {
            outputMap.put('CSGetFMSResultInfo', new Map<String, Object>{
                'errorCode' => 'INVOKE-500',
                'errorMessage' => 'Exception dans invokeMethod: ' + e.getMessage()
            });
            return false;
        }
        return result;
    }

    private void ApplyFMSByOrderId(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            String orderItemId = (String) inputMap.get('orderItemId');
            Decimal FMS = (Decimal) inputMap.get('MontantFMS');

            if (String.isBlank(orderItemId)) {
                response.put('errorCode', 'INVOKE-400');
                response.put('errorMessage', 'Champ Obligatoire manquant : orderItemId');
                outputMap.put('CSGetFMSResultInfo', response);
                return;
            }

            OrderItem orderItem = [
                SELECT Id, InwiB2C_FMS__c, InwiB2C_FMS_Catalogue__c
                FROM OrderItem
                WHERE Id = :orderItemId
                LIMIT 1
            ];

            orderItem.InwiB2C_FMS__c = FMS;
            orderItem.InwiB2C_FMS_Catalogue__c = FMS;

            update orderItem;

            response.put('errorCode', 'INVOKE-200');
            response.put('errorMessage', 'OK');
            outputMap.put('CSGetFMSResultInfo', response);

        } catch (Exception e) {
            response.put('errorCode', 'INVOKE-500');
            response.put('errorMessage', 'Erreur lors de la mise à jour des FMS : ' + e.getMessage());
            outputMap.put('CSGetFMSResultInfo', response);
        }
    }
}