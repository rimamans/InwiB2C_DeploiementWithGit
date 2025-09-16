trigger InwiB2C_TraitementNotificationDegroupage on InwiB2C_Notification_degroupage_Event__e (after insert) {
for (InwiB2C_Notification_degroupage_Event__e event : Trigger.New) {
       if (event.InwiB2C_trace_Id__c != null){
       
     
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('traceId',event.InwiB2C_trace_Id__c );
            optionsMap.put('useQueueableApexRemoting',true);

           outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_pushSMSAnnulationDeg', inputMap, optionsMap);
         
         }

}
}