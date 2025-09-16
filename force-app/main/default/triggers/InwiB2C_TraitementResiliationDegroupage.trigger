trigger InwiB2C_TraitementResiliationDegroupage on InwiB2C_TraitementResiliationDegroupage__e (after insert) {
for (InwiB2C_TraitementResiliationDegroupage__e event : Trigger.New) {
       if (event.InwiB2C_subscriptionId__c != null){
       
     
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('subscriptionId',event.InwiB2C_subscriptionId__c);
            optionsMap.put('useQueueableApexRemoting',true);

           outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_CreateResiliationDegroupageOrder', inputMap, optionsMap);
         
         }
         }

}