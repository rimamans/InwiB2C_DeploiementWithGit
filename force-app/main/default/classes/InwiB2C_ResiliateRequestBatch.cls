public class InwiB2C_ResiliateRequestBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String RequestQuery ;
    
      
   public Database.querylocator start(Database.BatchableContext BC){

       // RequestQuery = 'select Id,InwiB2C_Subscription__c,InwiB2C_Date_de_signature__c,inwiB2C_date_validation_bo__c,InwiB2C_Statut_Resil__c,InwiB2C_Date_pr_vue_de_r_siliation__c,InwiB2C_Type_Profil__c,InwiB2C_Date_de_suspension__c, inwiB2C_expectedDisconnectDate__c, inwiB2C_expectedSuspendDate__c  from InwiB2C_Demande_de_resiliation__c where (inwiB2C_expectedDisconnectDate__c <= TODAY or inwiB2C_expectedSuspendDate__c <= TODAY) and InwiB2C_Statut_Resil__c in (\'En attente de résiliation\',\'En attente de suspension\') limit 200';
       String limitRecordsRetreived;
       limitRecordsRetreived = [Select MasterLabel, InwiB2C_LimitBulkBatch__c, Label from inwiB2C_SubsMassProcessingLimit__mdt  where Label = 'DemandeResiliationLimit' limit 1].InwiB2C_LimitBulkBatch__c;
       RequestQuery = 'select Id, name,InwiB2C_Subscription__c,InwiB2C_Date_de_signature__c,inwiB2C_date_validation_bo__c,InwiB2C_Statut_Resil__c, InwiB2C_Date_pr_vue_de_r_siliation__c,InwiB2C_Type_Profil__c,InwiB2C_Date_de_suspension__c, inwiB2C_expectedDisconnectDate__c, inwiB2C_expectedSuspendDate__c from InwiB2C_Demande_de_resiliation__c where (InwiB2C_Statut_Resil__c =  \'En attente de résiliation\' AND inwiB2C_expectedDisconnectDate__c <= TODAY) OR (InwiB2C_Statut_Resil__c = \'En attente de suspension\' AND inwiB2C_expectedSuspendDate__c <= TODAY)  limit ' + limitRecordsRetreived;
       
       return Database.getQueryLocator(RequestQuery) ;         
    }
    
    public void execute(Database.BatchableContext BC, List<InwiB2C_Demande_de_resiliation__c> scope){      
        
        system.debug('batch scope'+scope);  
        Date myDate = system.today();
        String RequestStatusResil = 'En attente de résiliation';
        String RequestStatusSusp = 'En attente de suspension';
        List<inwiB2C_ResilRequestEvt__e> ResilRequest_event = new List<inwiB2C_ResilRequestEvt__e>();
        List<inwiB2C_SuspRequestEvt__e> SuspRequest_event = new List<inwiB2C_SuspRequestEvt__e>();
       
        for (InwiB2C_Demande_de_resiliation__c  resilrequestitem: scope){
            if(resilrequestitem.InwiB2C_Statut_Resil__c == RequestStatusResil && resilrequestitem.inwiB2C_expectedDisconnectDate__c <= myDate)
            {
                system.debug('Resil:'+resilrequestitem.Id);
                inwiB2C_ResilRequestEvt__e eventToCreate = new inwiB2C_ResilRequestEvt__e();
                eventToCreate.inwiB2C_requestId__c = resilrequestitem.Id;
                eventToCreate.inwiB2C_subsId__c = resilrequestitem.InwiB2C_Subscription__c;
                ResilRequest_event.add(eventToCreate);	
                system.debug('batch id'+resilrequestitem.InwiB2C_Subscription__c); 
                resilrequestitem.InwiB2C_Statut_Resil__c = 'En cours de résiliation';
            }
            else if (resilrequestitem.InwiB2C_Statut_Resil__c == RequestStatusSusp && resilrequestitem.inwiB2C_expectedSuspendDate__c <= myDate)
            {
                system.debug('suspension:'+resilrequestitem.Id);
                inwiB2C_SuspRequestEvt__e suspEventToCreate = new inwiB2C_SuspRequestEvt__e();
                suspEventToCreate.inwiB2C_requestId__c = resilrequestitem.Id;
                suspEventToCreate.inwiB2C_subsId__c = resilrequestitem.InwiB2C_Subscription__c;
                SuspRequest_event.add(suspEventToCreate);
                resilrequestitem.InwiB2C_Statut_Resil__c = 'En cours de suspension';
            }
        }

        List <Database.SaveResult> sresult = EventBus.publish(ResilRequest_event);
        List <Database.SaveResult> sresultSusp = EventBus.publish(SuspRequest_event);
        update scope;
    
    }


    public void finish(Database.BatchableContext BC){

        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
        a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
        a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 
        String[] email = new String[]{'projet-crm-sf@inwi.ma'};
        mail.setToAddresses(email);
        mail.setReplyTo('projet-crm-sf@inwi.ma');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed'+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  
    }

    
}