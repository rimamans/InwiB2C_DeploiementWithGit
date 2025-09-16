trigger inwiB2C_SMO_MassifTrigger on inwiB2C_SMO_Massif__e (after insert) {
    for (inwiB2C_SMO_Massif__e event : Trigger.New) {
        if (event.InwiB2C_DocumentId__c != null && event.InwiB2C_TraitementsList__c!=null) {
            String traitementsListJson = event.InwiB2C_TraitementsList__c;
            List<Object> traitementsList= (List<Object>) JSON.deserializeUntyped(traitementsListJson);
            Map <String, Object> Params = new Map <String, Object> ();
            Map <String, Object> ipInput = new Map <String, Object> ();
            Map <String, Object> ipOptions = new Map <String, Object> ();
            String IP_SMOMassif = 'inwib2c_inwiB2C_SMOMassif_IP';
            ipInput.put('documentId', event.InwiB2C_DocumentId__c);
            ipInput.put('TraitementsList', traitementsList);
            ipInput.put('typeChargement',event.inwiB2C_typeChargement__c);
            ipInput.put('STEP',event.InwiB2C_STEP__c);
            Params.put('Name', IP_SMOMassif);
            Params.put('ipInput', ipInput);    
            Params.put('ipOptions', ipOptions);
            system.debug('Params'+(String)JSON.serialize(Params));
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        }if(event.InwiB2C_STEP__c=='ResilVIP'){
            Map <String, Object> Params = new Map <String, Object> ();
            Map <String, Object> ipInput = new Map <String, Object> ();
            Map <String, Object> ipOptions= new Map <String, Object> ();
            String IP_SMOResil = 'inwib2c_InwiB2C_ResiliateSMO';
            ipInput.put('SubId', event.inwiB2C_SubscriptionID__c);
            ipInput.put('Action', event.inwiB2C_Action__c);
            Params.put('Name', IP_SMOResil );
            Params.put('ipInput', ipInput);    
            Params.put('ipOptions', ipOptions);
            system.debug('Params'+(String)JSON.serialize(Params));
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        }
    }
}