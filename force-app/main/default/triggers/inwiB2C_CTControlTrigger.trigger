trigger inwiB2C_CTControlTrigger on InwiB2C_Controle_CT_Massif__e (after insert) {
    for (InwiB2C_Controle_CT_Massif__e event : Trigger.New) {
       if (event.InwiB2C_demandesList__c!= null && event.InwiB2C_documentId__c!= null){
           Integer i = Integer.valueOf(event.InwiB2C_Counter__c) + 50;
           String demandesListJson = event.InwiB2C_demandesList__c;
           List<Object> demandesList= (List<Object>) JSON.deserializeUntyped(demandesListJson);
           Map <String, Object> Params = new Map <String, Object> ();
           Map <String, Object> ipInput = new Map <String, Object> ();
           Map <String, Object> ipOptions = new Map <String, Object> ();
           
           ipInput.put('lignes', demandesList);
           ipInput.put('documentId', event.InwiB2C_documentId__c);
           ipInput.put('fileSize', event.InwiB2C_fileSize__c);
           ipInput.put('Counter', i);
           
           system.debug('test input: '+JSON.serialize(ipInput));
           
           Params.put('Name','inwib2c_PostUpdateTechnoRequests');
           Params.put('ipInput',ipInput);
           Params.put('ipOptions',ipOptions);
           
           inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
           
         }
     }
}