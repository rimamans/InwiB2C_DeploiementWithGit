trigger InwiB2C_AnnulationOLDBC on InwiB2C_Annulation_du_Old_BC__e (after insert) {
    system.debug('In trigger');
    String InwiB2C_CancelOLDBC = 'inwib2c_AnnulDemandeDegIAM';

    
    for (InwiB2C_Annulation_du_Old_BC__e event : Trigger.New) {
        
                 Map <String, Object> ipInput = new Map <String, Object> ();
                 Map <String, Object> ipOutput = new Map <String, Object> ();
                 Map <String, Object> ipOptions = new Map <String, Object> ();

                 ipInput.put('Action', event.InwiB2C_Action__c);
                 ipInput.put('CodeOpDemandeur', event.InwiB2C_CodeOpDemandeur__c);
                 ipInput.put('NumOrdreUnique', event.InwiB2C_NumOrdreUnique__c);
                 ipInput.put('TypeCommande', event.InwiB2C_TypeCommande__c);
                 ipInput.put('typePrestation', event.InwiB2C_typePrestation__c);

                 
                 Map <String, Object> Params = new Map <String, Object> ();
                 Params.put('Name',InwiB2C_CancelOLDBC);
                 Params.put('ipInput',ipInput);
                 Params.put('ipOptions',ipOptions);

                 
                 //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
                 inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));

        }  
        

    }