trigger InwiB2C_AttachDocuments on InwiB2C_Attach_Documents__e (after insert) {
        system.debug('In trigger');
        String IP_AttachDoc = 'inwib2c_IndexListDocuments';
    
        
        for (InwiB2C_Attach_Documents__e event : Trigger.New) {
            
                     Map <String, Object> ipInput = new Map <String, Object> ();
                     Map <String, Object> ipOutput = new Map <String, Object> ();
                     Map <String, Object> ipOptions = new Map <String, Object> ();
    
                     ipInput.put('oldBusinessReference', event.InwiB2C_OldOrder__c);
                     ipInput.put('newBusinessReference', event.InwiB2C_New_Order__c);
                     ipInput.put('indexingType', event.InwiB2C_Index_Type__c);

    
                     
                     Map <String, Object> Params = new Map <String, Object> ();
                     Params.put('Name',IP_AttachDoc);
                     Params.put('ipInput',ipInput);
                     Params.put('ipOptions',ipOptions);
    
                     
                     //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
                     inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
    
            }  
            
    
        }