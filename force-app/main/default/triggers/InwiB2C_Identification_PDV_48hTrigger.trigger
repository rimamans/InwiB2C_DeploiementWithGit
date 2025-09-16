trigger InwiB2C_Identification_PDV_48hTrigger on InwiB2C_Identification_PDV_48h__e (after insert) {

    for (InwiB2C_Identification_PDV_48h__e event : Trigger.New ){

        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('SubscriptionId', event.InwiB2C_SubscriptionId__c);
        inputMap.put('isCinExist', event.InwiB2C_isCinExist__c);
        inputMap.put('isClientMonoligne', event.InwiB2C_isClientMonoligne__c);
        inputMap.put('idContact', event.InwiB2C_ContactId__c);
        inputMap.put('jsonToUpdateClient', event.InwiB2C_json_To_Update_Client__c);
        inputMap.put('jsonToUpdateContract', event.InwiB2C_json_To_Update_Contract__c);
        inputMap.put('AccountId', event.InwiB2C_AccountId__c);
        inputMap.put('jsonToUpdateAdresse', event.InwiB2C_jsonToUpdateAdresse__c);
        inputMap.put('MDN', event.InwiB2C_MDN__c);
        inputMap.put('IdDemande', event.InwiB2C_IdDemande__c);
        inwib2c_Identifi_pdv_call48h.callVIP(json.serialize(inputMap));
}}