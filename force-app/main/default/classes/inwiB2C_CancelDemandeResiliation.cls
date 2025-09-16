global with sharing class inwiB2C_CancelDemandeResiliation implements vlocity_cmt.VlocityOpenInterface{

    
    global  Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
    Boolean result = true;
    try{
        if(methodName.equals('cancelDemandeResilaition')){

            return cancelDemandeResilaition(inputs, output, options);      

        }        
                       

    } catch(Exception e){

        result = false;

    }

    return result;

    }

    global static Boolean cancelDemandeResilaition( Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){

        Id demandeResilaitionId = (Id) inputs.get('idrequesttocancel');
        String motif = (String) inputs.get('motifcancel'); 
        List<InwiB2C_Demande_de_resiliation__c> requetesList = [select Id,CreatedById from InwiB2C_Demande_de_resiliation__c where Id =: demandeResilaitionId];
       
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest> ();


        
        //Get ProcessInstance Items
        Map<ID,ProcessInstance> piMap = New Map<ID,ProcessInstance>([Select Id from ProcessInstance where TargetObjectId = :demandeResilaitionId]);


        for(ProcessInstanceWorkItem pp : [Select Id from ProcessInstanceWorkItem where ProcessInstanceId IN :piMap.keySet()]){


            // if there's a work item, set the action to 'removed' and execute
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setAction('Removed');
            req2.setWorkitemId(pp.Id);
            requests.add(req2);
        }

        Approval.ProcessResult[] processResults = null;
        processResults = Approval.process(requests, true);

        InwiB2C_Demande_de_resiliation__c demande = new InwiB2C_Demande_de_resiliation__c(Id= demandeResilaitionId, inwiB2C_Motif_d_annulation__c= motif, InwiB2C_Statut_Resil__c = 'Annulée',inwiB2C_Statut_d_approbation__c='',OwnerId= requetesList[0].CreatedById);

        update demande;

        return true;

    }


}