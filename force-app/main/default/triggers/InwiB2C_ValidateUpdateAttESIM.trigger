trigger InwiB2C_ValidateUpdateAttESIM on InwiB2C_ValidateUpdateAttESIM__e (after insert) {
    for (InwiB2C_ValidateUpdateAttESIM__e event : trigger.New) {
        if (event.InwiB2C_OrderId__c != '' && event.InwiB2C_PanierId__c != '') {
            Map <String, Object> Params = new Map <String, Object> ();
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outputMap = new Map<String,Object>();
            Map<String,Object> optionsMap = new Map<String,Object>();

            inputMap.put('PanierId', event.InwiB2C_PanierId__c);
            inputMap.put('OrderId', event.InwiB2C_OrderId__c);
            System.debug('Trigger - invoking createOrder method');

             Params.put('Name','inwib2c_InwiB2C_ValidateUpdateAttributesSIMSMODigitale');
            Params.put('ipInput',inputMap);
            Params.put('ipOptions',optionsMap);
            system.debug('Params'+(String)JSON.serialize(Params));
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        }
    }
}