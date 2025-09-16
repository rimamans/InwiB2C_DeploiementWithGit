trigger inwiB2C_ExecuteTraitemeSMOSwapEsimTrigger on InwiB2C_CreateSMOSwapEsimAsynchrone__e (after insert) {
for (InwiB2C_CreateSMOSwapEsimAsynchrone__e event : Trigger.New) {
       if (event.InwiB2C_PanierId__c!= null){
       
     
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('TraceId',event.InwiB2C_TraceId__c);
            inputMap.put('PanierId',event.InwiB2C_PanierId__c);
            optionsMap.put('useQueueableApexRemoting',true);

           outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('Inwi_InwiB2C_CreateSMODigitalAsynchrone', inputMap, optionsMap);
         
         }
         
      }

}