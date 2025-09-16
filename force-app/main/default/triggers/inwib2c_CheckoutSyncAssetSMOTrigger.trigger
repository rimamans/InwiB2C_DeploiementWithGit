trigger inwib2c_CheckoutSyncAssetSMOTrigger on inwiB2C_CheckoutSyncAssetSMO__e (after insert) {


   for (inwiB2C_CheckoutSyncAssetSMO__e event : Trigger.New) {
              if (event.OrderId__c != null && event.Step__c.equals('checkout')){
              
             /*   Map<String, Object> inputMapCh = new Map<String, Object> ();
                Map<String, Object> outputMapCh = new Map<String, Object> ();
                Map<String, Object> optionsMapCh = new Map<String, Object> ();
                
                inputMapCh.put('Id',event.OrderId__c);
                //inputMapCh.put('synchro',true);
                optionsMapCh.put('useQueueableApexRemoting',true);

              outputMapCh = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_CheckoutOrderAPI', inputMapCh, optionsMapCh);
              */
                //////////////////////////////////////////////////////////////////////////::
            
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('Id',event.OrderId__c);
            inputMap.put('TraceId',event.TraceId__c);
            inputMap.put('Source',event.Source__c);
            
            optionsMap.put('useQueueableApexRemoting',true);
         
            outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_inwiB2C_CheckoutSyncAssetSMO', inputMap, optionsMap);
           /*
            Map<String, Object> inputMap2 = new Map<String, Object> ();
            Map<String, Object> outputMap2 = new Map<String, Object> ();
            Map<String, Object> optionsMap2 = new Map<String, Object> ();
            inputMap2.put('TraceId',event.TraceId__c);
            inputMap2.put('Source',event.Source__c);
            outputMap2 = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_inwiB2C_CallExecuteTraitementSMOEvent', inputMap2, optionsMap2);*/
           /*
            inwiB2C_ExecuteTraitementSMO__e apiEvent = new inwiB2C_ExecuteTraitementSMO__e();
            apiEvent.TraceId__c=event.TraceId__c;
            EventBus.publish(apiEvent);*/
          }
         }

}