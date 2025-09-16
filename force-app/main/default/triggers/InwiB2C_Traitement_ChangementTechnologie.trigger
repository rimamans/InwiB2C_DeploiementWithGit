trigger InwiB2C_Traitement_ChangementTechnologie on InwiB2C_TraitementChangementTechnologie__e (after insert) {
    system.debug('In trigger');
    String IP_MassProcessing = 'inwib2c_Traitement_Changement_technologie';

    
    for (InwiB2C_TraitementChangementTechnologie__e event : Trigger.New) {
        
        if (event.InwiB2C_Id_Demande_degroupage__c	 != null ){         
                 Map <String, Object> ipInput = new Map <String, Object> ();
                 Map <String, Object> ipOutput = new Map <String, Object> ();
                 Map <String, Object> ipOptions = new Map <String, Object> ();

                 ipInput.put('OrderId', event.InwiB2C_Order__c);
                 ipInput.put('DemandeId', event.InwiB2C_Id_Demande_degroupage__c);
                 ipInput.put('Demande', event.InwiB2C_Id_Demande_degroupage__c);
                 ipInput.put('attribut', event.InwiB2C_Attribut_technologie_cible__c);

                 Map <String, Object> Params = new Map <String, Object> ();
                 Params.put('Name',IP_MassProcessing);
                 Params.put('ipInput',ipInput);
                 Params.put('ipOptions',ipOptions);
                 //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
                 inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));

            }          
        }  
        

     
    }