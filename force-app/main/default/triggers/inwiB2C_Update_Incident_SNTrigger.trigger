trigger inwiB2C_Update_Incident_SNTrigger on inwiB2C_Update_Incident_SN__e (after insert) {
 for (inwiB2C_Update_Incident_SN__e event : Trigger.New) {
 
                 Map <String, Object> ipInput = new Map <String, Object> ();
                 Map <String, Object> ipOutput = new Map <String, Object> ();
                 Map <String, Object> ipOptions = new Map <String, Object> ();

                 ipInput.put('CaseId', event.inwiB2C_CaseId__c);
                 ipInput.put('Step', 'CreateCase');
                 
                 Map <String, Object> Params = new Map <String, Object> ();
                 Params.put('Name','inwib2c_InwiB2C_CreateCaseSN');
                 Params.put('ipInput',ipInput);
                 Params.put('ipOptions',ipOptions);
                 //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
                 inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        
}
}