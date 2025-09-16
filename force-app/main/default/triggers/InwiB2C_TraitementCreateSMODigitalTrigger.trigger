trigger InwiB2C_TraitementCreateSMODigitalTrigger on InwiB2C_TraitementCreateSMODigital__e (after insert) {
for (InwiB2C_TraitementCreateSMODigital__e  event : Trigger.New) {
                Map <String, Object> Params = new Map <String, Object> ();
    
          if (event.InwiB2C_PanierId__c!= null && event.InwiB2C_Step__c.equals('AddProduct') ){
             Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            Map<String, Object> data = new Map<String, Object> ();

            inputMap.put('inputMap',(Map<String, Object>)data);
            inputMap.put('TraceId',event.InwiB2C_TraceId__c);
            inputMap.put('PanierId',event.InwiB2C_PanierId__c);
            inputMap.put('OrderId',event.inwiB2C_OrderId__c);
            optionsMap.put('useQueueableApexRemoting',true); 
            
            outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('Inwi_InwiB2C_TraitementCreateSMODigita', inputMap, optionsMap);
          
           
           }
             
              }  
}