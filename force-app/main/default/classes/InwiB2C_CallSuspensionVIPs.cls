public with sharing class InwiB2C_CallSuspensionVIPs {
    @future(callout = true)
    public static void CallVIP(String requestId, String subsId){
        system.debug('InwiB2C_CallSuspensionVIPs');

        InwiB2C_Demande_de_resiliation__c request = [select InwiB2C_Subscription__c,InwiB2C_Statut_Resil__c,InwiB2C_Date_de_suspension__c from InwiB2C_Demande_de_resiliation__c where id = :requestId];

        String procedureName1 = 'inwib2c_InwiB2C_SuspendSubscription2';
        Map<String, Object> ipInput1 = new Map<String, Object>();
        ipInput1.put('SubscriptionId', subsId); 
        ipInput1.put('requestId', requestId); 
        Map<String, Object> ipOptions1 = new Map<String, Object>();
        Map<String, Object> ipOutput1 = new Map<String, Object>();
        if(Test.isRunningTest()) {
        //Code en dur du resultat de l'api pour la class de test
            ipOutput1.put('ok',1); 
        }else{
            ipOutput1 = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName1, ipInput1, ipOptions1);
        }
        Object resultVIP1 = ipOutput1.get('ok');

        if(resultVIP1 == 1 ){
            system.debug('Id:'+request.Id);
            request.InwiB2C_Statut_Resil__c = 'En attente de résiliation';
            request.InwiB2C_Date_de_suspension__c=Date.today();
        }
    
        Update request;


/* OLD CODE        
        List<InwiB2C_Demande_de_resiliation__c> requestsToSend = new List <InwiB2C_Demande_de_resiliation__c>();
        List<InwiB2C_Demande_de_resiliation__c> requestsToUpdate = new List <InwiB2C_Demande_de_resiliation__c>();
        
        requestsToSend = [select InwiB2C_Subscription__c,InwiB2C_Statut_Resil__c,InwiB2C_Date_de_suspension__c from InwiB2C_Demande_de_resiliation__c where id in :RequestIds];
       
        for (InwiB2C_Demande_de_resiliation__c request : requestsToSend){
            // call the API to suspend line services 
            String procedureName1 = 'InwiB2C_ServicesSuspension';
            Map<String, Object> ipInput1 = new Map<String, Object>();
            ipInput1.put('SubscriptionId', request.InwiB2C_Subscription__c); 
            Map<String, Object> ipOptions1 = new Map<String, Object>();
            Map<String, Object> ipOutput1 = new Map<String, Object>();
            if(Test.isRunningTest()) {
         //Code en dur du resultat de l'api pour la class de test
          ipOutput1.put('status',1); 
            }else{
                ipOutput1 = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName1, ipInput1, ipOptions1);
            }
             Object resultVIP1 = ipOutput1.get('status');
            //call the API to suspend line billing
            String procedureName2 = 'InwiB2C_SuspendBillingBSCS';
            Map<String, Object> ipInput2 = new Map<String, Object>();
            ipInput2.put('capture_id', request.InwiB2C_Subscription__c); 
            ipInput2.put('offreTechnique', 'OPB2C'); 
            Map<String, Object> ipOptions2 = new Map<String, Object>();
            Map<String, Object> ipOutput2 = new Map<String, Object>();
            if(Test.isRunningTest()) {
         //Code en dur du resultat de l'api pour la class de test
          ipOutput2.put('status',1); 
            }else{
            ipOutput2 = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName2, ipInput2, ipOptions2); 
            }
             Object resultVIP2 =ipOutput2.get('status');
            //update the status and suspension date of the request
            if(resultVIP1 == 1 && resultVIP2 == 1){
                system.debug('Id:'+request.Id);
                request.InwiB2C_Statut_Resil__c = 'En attente de résiliation';
                request.InwiB2C_Date_de_suspension__c = system.today();
                requestsToUpdate.add(request);
            }
        }
       Update requestsToUpdate;*/
    }
}