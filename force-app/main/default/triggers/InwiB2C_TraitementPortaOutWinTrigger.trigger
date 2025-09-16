trigger InwiB2C_TraitementPortaOutWinTrigger on InwiB2C_TraitementPortaOutWin__e (after insert) {
    
    
    for (InwiB2C_TraitementPortaOutWin__e event : Trigger.New){
        if(event.InwiB2C_TraceId__c != null){
            String IP_ExecutePortaOut = 'inwib2c_InwiB2C_TraitementPortaOutWin';
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('TraceId',event.InwiB2C_TraceId__c);
            Map <String, Object> Params = new Map <String, Object> ();
            Params.put('Name',IP_ExecutePortaOut);
            Params.put('ipInput',inputMap);
            Params.put('ipOptions',optionsMap);
            
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
            
        }
    }
    }