trigger InwiB2C_ResiliationSuiteAnnulationPartag on InwiB2C_ResiliationSuiteAnnulationPartag__e (after insert) {
for (InwiB2C_ResiliationSuiteAnnulationPartag__e event : Trigger.New) {
       if (event.inwiB2C_Subscription__c!= null && event.inwiB2C_Subscription__c!=''){
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            inputMap.put('SubId',event.inwiB2C_Subscription__c);
            optionsMap.put('useQueueableApexRemoting',true);
           outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_LiberationRessourcesSMO', inputMap, optionsMap);
         }
}
}