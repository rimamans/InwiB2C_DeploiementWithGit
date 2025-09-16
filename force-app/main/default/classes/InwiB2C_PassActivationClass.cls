global class InwiB2C_PassActivationClass implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;

        outMap.put('result',  ActivatePassMyINWI(inputMap));

        return result;
    }

    Map<String, Object> ActivatePassMyINWI(Map<String,Object> inputMap) {

        String IP_ActivatePass = 'inwib2c_InwiB2C_ActivatePassMyInwi';
        map<String,Object> Params = new Map<String,Object>();
        map<String,Object> ipInput = new Map<String,Object>();
        map<String,Object> ipOptions = new Map<String,Object>();
        
        ipInput.put('mdn',(String)inputMap.get('mdn'));
        ipInput.put('subscriptionId',(String)inputMap.get('subId'));
        ipInput.put('accountId',(String)inputMap.get('accId'));
  
        Params.put('Name',IP_ActivatePass);
        Params.put('ipInput',ipInput);
        Params.put('ipOptions',ipOptions);
        system.debug('Params'+(String)JSON.serialize(Params));
        
        //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
        inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        inputMap.put('Status','Success');
        return inputMap;
    }
}