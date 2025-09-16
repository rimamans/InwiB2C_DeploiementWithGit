trigger inwiB2C_DesconnectServiceTrigger on InwiB2C_VulaDesconnectService__e (after insert) {
for (InwiB2C_VulaDesconnectService__e event: trigger.New ){
 if (event.Trace_Id__c != '' && event.Step__c == 'SetGeneration'){
     //YMH WS95 - BEGIN
 Map<String, Object> Params = new Map<String, Object>();
            Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> optionsMap = new Map<String, Object>();
            
            inputMap.put('TraceId', event.Trace_Id__c);
            
            Params.put('Name', 'inwib2c_InwiB2C_TraitementDesconnectResilVula');
            Params.put('ipInput', inputMap);
            Params.put('ipOptions', optionsMap);
            
            system.debug('Params' + (String) JSON.serialize(Params));
            
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String) JSON.serialize(Params));
 }}
}
//YMH WS95 - END