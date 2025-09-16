public class InwiB2C_CallVoc {
    @InvocableMethod
    public static void callVIP(List<String> inputs){
         system.debug('input Call voc' + inputs);
        //get informations
        
         System.debug('Inputs size: ' + inputs.size());

        if(inputs.size() > 50){
           return;
        }
        for(String input : inputs ){
        List<String> splitList = input.split(',');
        String objectType = splitList[0];
        String objectId = splitList[1];
        //String id_enquete = splitList[2];
        String objectVIP;
        String IdVIP;
        
        //set Object Type
        switch on objectType {
        when 'Order' {		
            objectVIP='Order';
            IdVIP='OrderId';
        }	
        when 'Case' {	
            objectVIP='Case';
            IdVIP='CaseId';
        }
        when 'InwiB2C_Demande_de_resiliation__c' {		
            objectVIP='Resiliation';
            IdVIP='ResiliationId';
        }
        when 'InwiB2C_Demande_IdentificationClient__c'{
            objectVIP='Identification';
            IdVIP='IdentificationId';
        }
        when else {		  
            objectVIP='Action';
            IdVIP='ActionId';
        }
    }
       /* String procedureName = 'inwib2c_SendRequestVoc';
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();

        ipInput.put('Objet', objectVIP);
        ipInput.put(IdVIP, objectId);
        ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);  
         system.debug('ouput call voc' + ipOutput);*/
        //Create Voc
		//InwiB2C_VOC_Survey__c survery= new InwiB2C_VOC_Survey__c ();
        //insert survery;
        //String tmp = survery.Id;
        callVIP(objectVIP,IdVIP,objectId);
        }
    }
    
    @future(callout=true)
    public static void callVIP(String objectVIP, String IdVIP, String objectId ){
        String procedureName = 'inwib2c_SendRequestVoc';
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();

        ipInput.put('Objet', objectVIP);
        ipInput.put(IdVIP, objectId);
       // ipInput.put('id_enquete', id_enquete);
        
        ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);  
    	system.debug('ouput call voc' + ipOutput);
    }
}