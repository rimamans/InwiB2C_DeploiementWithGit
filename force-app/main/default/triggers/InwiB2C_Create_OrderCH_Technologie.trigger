trigger InwiB2C_Create_OrderCH_Technologie on InwiB2C_CreateOrder_CH_Technologie__e (after insert) {
    system.debug('In trigger');
    String IP_cloneCart = 'inwib2c_CreateCartTechnlogie';

    
    for (InwiB2C_CreateOrder_CH_Technologie__e event : Trigger.New) {
        
                 Map <String, Object> ipInput = new Map <String, Object> ();
                 Map <String, Object> ipOutput = new Map <String, Object> ();
                 Map <String, Object> ipOptions = new Map <String, Object> ();

                 ipInput.put('OrderId', event.InwiB2C_Order__c);
                 ipInput.put('DemandeId', event.InwiB2C_Id_Demande_degroupage__c);
                 ipInput.put('attribut', event.InwiB2C_Attribut_technologie_cible__c);

                 
                 Map <String, Object> Params = new Map <String, Object> ();
                 Params.put('Name',IP_cloneCart);
                 Params.put('ipInput',ipInput);
                 Params.put('ipOptions',ipOptions);

                 
                 //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
                 inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));

        }  
        

    }