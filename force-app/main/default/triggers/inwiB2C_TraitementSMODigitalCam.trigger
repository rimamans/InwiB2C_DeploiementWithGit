trigger inwiB2C_TraitementSMODigitalCam on InwiB2C_TraitementSMODigitalCam__e (after insert) {
    for (InwiB2C_TraitementSMODigitalCam__e event: trigger.New) {
        if (event.InwiB2C_panierId__c != '') {
            Map <String, Object> Params = new Map <String, Object> ();
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outputMap = new Map<String,Object>();
            Map<String,Object> optionsMap = new Map<String,Object>();
            
            inputMap.put('panierId', event.InwiB2C_panierId__c);
            
            Params.put('Name','inwib2c_InwiB2C_TraitementSMODigitalCAM');
            Params.put('ipInput',inputMap);
            Params.put('ipOptions',optionsMap);
            system.debug('Params'+(String)JSON.serialize(Params));
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        }
    }
}