trigger InwiB2C_ExecuteTransfertTrigger on InwiB2C_ExecuteTransfer__e (after insert) {
    //SOB WS93 - Start
    for (InwiB2C_ExecuteTransfer__e event : Trigger.New) {
        if (event.InwiB2C_TraceId__c != null) {
            Map<String, Object> Params = new Map<String, Object>();
            Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> optionsMap = new Map<String, Object>();
            
            inputMap.put('TraceId', event.InwiB2C_TraceId__c);
            
            Params.put('Name', 'inwib2c_InwiB2C_TraitementTransferVulaOI');
            Params.put('ipInput', inputMap);
            Params.put('ipOptions', optionsMap);
            
            system.debug('Params' + (String) JSON.serialize(Params));
            
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String) JSON.serialize(Params));
        }
    }
    //SOB WS93 - End
}