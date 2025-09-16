trigger inwiB2C_changementNumPorta on inwiB2C_changementNumPorta__e (after insert) {

    for (inwiB2C_changementNumPorta__e event : Trigger.New) {
       system.debug('step: '+ event.inwiB2C_step__c);
       Map <String, Object> Params = new Map <String, Object> ();
       if (event.inwiB2C_traceApiId__c != '' && event.inwiB2C_step__c.equals('createOrder')) {
            String IP_CreateOrderChNumPorta = 'Inwi_InwiB2C_CreateOrderChNumPorta';
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('traceApiId',event.inwiB2C_traceApiId__c);
            optionsMap.put('useQueueableApexRemoting',true);
            system.debug('inputVIP ' + inputMap);
            
            Params.put('Name',IP_CreateOrderChNumPorta);
            Params.put('ipInput',inputMap);
            Params.put('ipOptions',optionsMap);
            system.debug('Params'+(String)JSON.serialize(Params));
            
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
           
       }
       if (event.inwiB2C_traceApiId__c != '' && event.inwiB2C_step__c.equals('updateAttributes')) {
           Map<String,Object> inputMap = new Map<String,Object>();
           Map<String,Object> outputMap = new Map<String,Object>();
           Map<String,Object> options = new Map<String,Object>();
           inputMap.put('traceApiId', event.inwiB2C_traceApiId__c);
           (new inwiB2C_HandleChNumPorta()).invokeMethod('updateAttributes', inputMap, outputMap, options); 
       }
    }

}