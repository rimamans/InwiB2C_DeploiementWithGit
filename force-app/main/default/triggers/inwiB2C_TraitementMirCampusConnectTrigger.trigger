trigger inwiB2C_TraitementMirCampusConnectTrigger on InwiB2C_TraitementMirCampusConnectEvent__e (after insert) {
 for (InwiB2C_TraitementMirCampusConnectEvent__e event : Trigger.New) {
           if(event.InwiB2C_TraceId__c!= null ){         
                Map<String, Object> inputMap = new Map<String, Object> ();
                Map<String, Object> outputMap = new Map<String, Object> ();
                Map<String, Object> optionsMap = new Map<String, Object> ();               
                inputMap.put('TraceId',event.InwiB2C_TraceId__c);         
                optionsMap.put('useQueueableApexRemoting',true);
    
               outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_TraitementMirCampusConnect', inputMap, optionsMap);
             
             }
             
          }
}