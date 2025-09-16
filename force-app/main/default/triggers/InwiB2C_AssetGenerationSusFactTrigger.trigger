trigger InwiB2C_AssetGenerationSusFactTrigger on InwiB2C_generate_asset_susfact__e (after insert) {
    for (InwiB2C_generate_asset_susfact__e event : Trigger.New) {
    // generate synchro order
      if (event.InwiB2C_AssetId__c != null && event.InwiB2C_Operation__c.equals('createOrder') ){
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('AccountId',event.InwiB2C_AccountId__c);
            inputMap.put('AssetId',event.InwiB2C_AssetId__c);
            inputMap.put('SubscriptionId',event.InwiB2C_subscriptionId__c);

             Map <String, Object> Params = new Map <String, Object> ();
             Params.put('Name','inwib2c_InwiB2C_ExecuteSynchAssetSusfact');
             Params.put('ipInput',inputMap);
             Params.put('ipOptions',optionsMap);
             
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));  
      }
      
      //checkout synchro asset 
      if (event.InwiB2C_orderId__c!= null && event.InwiB2C_Operation__c.equals('checkout') ){
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();

            inputMap.put('OrderId',event.InwiB2C_orderId__c);
            inputMap.put('SubscriptionId',event.InwiB2C_subscriptionId__c);
            
             Map <String, Object> Params = new Map <String, Object> ();
             Params.put('Name','inwib2c_inwib2c_checkoutAPISusFact');
             Params.put('ipInput',inputMap);
             Params.put('ipOptions',optionsMap);
             
             inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));  
    }
    
    //generate smo suspension facturation et reseau
    if (event.InwiB2C_subscriptionId__c!= null && event.InwiB2C_Operation__c.equals('SuspensionFacturation') ){
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();

            inputMap.put('SubscriptionId',event.InwiB2C_subscriptionId__c);
            
             Map <String, Object> Params = new Map <String, Object> ();
             Params.put('Name','inwib2c_InwiB2C_SuspendSubscription2');
             Params.put('ipInput',inputMap);
             Params.put('ipOptions',optionsMap);
             
             inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params)); 
    }
 }
}