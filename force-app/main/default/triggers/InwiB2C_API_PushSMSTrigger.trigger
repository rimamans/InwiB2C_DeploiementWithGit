trigger InwiB2C_API_PushSMSTrigger on inwiB2C_API_PushSMS__e(after insert ){
    //List<String> mdnList= new List<String>();

    for (inwiB2C_API_PushSMS__e event : Trigger.New ){

        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('mdn', event.InwiB2C_MDN__c);
        inputMap.put('message', event.InwiB2C_message__c);
        inwib2c_push_sms_callout.callVIP(json.serialize(inputMap));

        // Map<String, Object> outputMap = new Map<String, Object>();
        // Map<String, Object> optionsMap = new Map<String, Object>();
        // // optionsMap.put('useQueueableApexRemoting',true);
        // system.debug('inputMap' + inputMap);
        // outputMap = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_PushSMSStudientNotification', inputMap, optionsMap);
        // system.debug('outputMap' + outputMap);


    }
}