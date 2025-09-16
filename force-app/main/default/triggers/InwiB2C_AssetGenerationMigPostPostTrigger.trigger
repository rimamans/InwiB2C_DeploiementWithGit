trigger InwiB2C_AssetGenerationMigPostPostTrigger on InwiB2C_AssetGenerationMigPostPost__e (after insert) {
for (InwiB2C_AssetGenerationMigPostPost__e event : Trigger.New) {
    
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

            optionsMap.put('useQueueableApexRemoting',true);

          //  System.debug('AssetToOrderRequest');
          //  System.debug(JSON.serialize(inputMap));  
            
            outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_ExecuteSynchAssetPostPost', inputMap, optionsMap);
           // System.debug('AssetToOrderResponse');
           // System.debug(JSON.serialize(outputMap));
            
           
           }
              if (event.OrderId__c != null && event.Step__c.equals('checkout') ){
               Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> outputMap = new Map<String, Object>();
            Map<String, Object> optionsMap = new Map<String, Object>();

            inputMap.put('Id',event.OrderId__c); 
            inputMap.put('TraceId',event.TraceId__c);
            //optionsMap.put('useFutureApexRemoting',true);
            inwiB2C_MigPostPostCallcheckout.callVIP(json.serialize(inputMap));
           /* outputMap = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_CheckoutForMigPostPost', inputMap, optionsMap);
           //Appel Event pr CreateSMO PostPost
            inwiB2C_ExecuteTraitementMigPostPostSMO__e apiEvent = new inwiB2C_ExecuteTraitementMigPostPostSMO__e();
            apiEvent.InwiB2C_TraceId__c=event.TraceId__c;
            EventBus.publish(apiEvent);*/
              }
              }   
}