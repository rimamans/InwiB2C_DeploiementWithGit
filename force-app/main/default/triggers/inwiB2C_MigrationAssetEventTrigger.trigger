trigger inwiB2C_MigrationAssetEventTrigger on InwiB2C_Asset_Migration_Event__e(after insert ){

    System.debug('In Event');
    for (InwiB2C_Asset_Migration_Event__e event : Trigger.new ){
        System.debug(event);

        if (event.AssetId__c != null && event.Step__c.equals('CreateOrder')){

            Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> outputMap = new Map<String, Object>();
            Map<String, Object> optionsMap = new Map<String, Object>();

            //inputMap.put('accountId', (Id) event.AccountId__c);
            inputMap.put('assetIdSynch', (Id) event.AssetId__c);
            inputMap.put('MigrationAssetId__c', (Id) event.MigrationAssetId__c);
            optionsMap.put('useFutureApexRemoting',true);


            Map <String, Object> Params = new Map <String, Object> ();
             Params.put('Name','inwib2c_InwiB2C_MigrationAsset');
             Params.put('ipInput',inputMap);
             Params.put('ipOptions',optionsMap);
             system.debug('Params'+(String)JSON.serialize(Params));
             
             //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
             inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
           
            //outputMap = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_MigrationAsset', inputMap, optionsMap);
			//System.debug(outputMap);
        } else if (event.AssetId__c != null && event.Step__c.equals('checkOut')){

            Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> outputMap = new Map<String, Object>();
            Map<String, Object> optionsMap = new Map<String, Object>();

            inputMap.put('Id',event.OrderId__c);

            //{"isDebug":true, "chainable":false, "resetCache":false, "ignoreCache":true, "queueableChainable":false, "useQueueableApexRemoting":false}
            
            optionsMap.put('useFutureApexRemoting',true);

            Map <String, Object> Params = new Map <String, Object> ();
             Params.put('Name','inwib2c_CheckoutOrderAPI');
             Params.put('ipInput',inputMap);
             Params.put('ipOptions',optionsMap);
             system.debug('Params'+(String)JSON.serialize(Params));
             
             //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
             inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));

           
            //outputMap = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_CheckoutOrderAPI', inputMap, optionsMap);
			//System.debug(outputMap);
        }

    }
}