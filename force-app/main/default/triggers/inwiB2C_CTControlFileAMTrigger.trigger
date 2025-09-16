trigger inwiB2C_CTControlFileAMTrigger on  InwiB2C_Controle_fileAM__e (after insert) {
    for (InwiB2C_Controle_fileAM__e event : Trigger.New) {
       if (event.InwiB2C_demandesList__c!= null && event.InwiB2C_documentId__c!= null){
       Integer i ;
       if (Integer.valueOf(event.InwiB2C_Counter__c) >= 100 ){
            i = Integer.valueOf(event.InwiB2C_Counter__c) + 100;}
           else{  i = Integer.valueOf(event.InwiB2C_Counter__c);
           }
       
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
           
           Params.put('Name','inwiB2C_PostUpdateFileAMEnMasse');
           Params.put('ipInput',ipInput);
           Params.put('ipOptions',ipOptions);
           
           inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
           
         }
     }
}