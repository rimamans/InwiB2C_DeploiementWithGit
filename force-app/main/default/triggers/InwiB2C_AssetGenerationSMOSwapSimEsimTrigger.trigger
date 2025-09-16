trigger InwiB2C_AssetGenerationSMOSwapSimEsimTrigger on INWIB2C_Asset_Generation_SWAP_SIM_ESIM__e (after insert) {
for (INWIB2C_Asset_Generation_SWAP_SIM_ESIM__e  event : Trigger.New) {
    
          if (event.AssetId__c != null && event.Step__c.equals('CreateOrder') ){
             Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            Map<String, Object> data = new Map<String, Object> ();
         
            data.put('accountId', (Id)event.AccountId__c);
            data.put('subaction', 'assetToOrder');
            data.put('id', (Id)event.AssetId__c );

            inputMap.put('inputMap',(Map<String, Object>)data);
            inputMap.put('TraceId',event.TraceId__c);

         
             inputMap.put('PanierId',event.PanierId__c);
             inputMap.put('Canal',event.Canal__c);
            optionsMap.put('useQueueableApexRemoting',true); 
            
            outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_CreateSMODigitalSynchAsset', inputMap, optionsMap);
          
           
           }
              if (event.OrderId__c != null && event.Step__c.equals('checkout') ){
               Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> outputMap = new Map<String, Object>();
            Map<String, Object> optionsMap = new Map<String, Object>();

            inputMap.put('Id',event.OrderId__c); 
            inputMap.put('TraceId',event.TraceId__c);
            inputMap.put('PanierId',event.PanierId__c);
            inwib2cSMOSwapSimEsimCheckout.inwib2cSMOSwapSimEsimCheckout(json.serialize(inputMap));
              }
              
              }   
}