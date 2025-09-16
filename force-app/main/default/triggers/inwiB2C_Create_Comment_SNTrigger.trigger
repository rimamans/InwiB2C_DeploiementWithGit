trigger inwiB2C_Create_Comment_SNTrigger on InwiB2C_Create_Comment_SN__e (after insert) {
    for (InwiB2C_Create_Comment_SN__e event : Trigger.New) {
 
                 Map <String, Object> ipInput = new Map <String, Object> ();
                 Map <String, Object> ipOutput = new Map <String, Object> ();
                 Map <String, Object> ipOptions = new Map <String, Object> ();

                 ipInput.put('CaseCommentId', event.inwiB2C_CommentId__c);
                 ipInput.put('Step', 'CreateComment');
                 
                 Map <String, Object> Params = new Map <String, Object> ();
                 Params.put('Name','inwib2c_InwiB2C_CreateCaseCommentSN');
                 Params.put('ipInput',ipInput);
                 Params.put('ipOptions',ipOptions);
                 //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
                 inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        
}
}