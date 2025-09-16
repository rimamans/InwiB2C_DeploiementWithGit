trigger inwiB2C_CallAnnulDmdDegroupage on inwiB2C_CallAnnulDmdDegroupage__e (after insert) {
    system.debug('In trigger');
    String vipName = 'InwiB2C_DemandeDegIAMParcours';

    
    for (inwiB2C_CallAnnulDmdDegroupage__e event : Trigger.New) {
        
                 Map <String, Object> ipInput = new Map <String, Object> ();
                 Map <String, Object> ipOutput = new Map <String, Object> ();
                 Map <String, Object> ipOptions = new Map <String, Object> ();

                 ipInput.put('action', event.InwiB2C_Action__c);
                 ipInput.put('commandeDeg', event.inwiB2C_DemandeDeg__c);
                 ipInput.put('type', event.inwiB2C_Type__c);

                 
                 Map <String, Object> Params = new Map <String, Object> ();
                 Params.put('Name',vipName);
                 Params.put('ipInput',ipInput);
                 Params.put('ipOptions',ipOptions);

                 
                 //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
                 inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));

        }  
        

    }