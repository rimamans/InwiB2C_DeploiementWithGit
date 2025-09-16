public class InwiB2C_UpdateDealerInformationsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
      
    public Database.querylocator start(Database.BatchableContext BC){
  
        String RequestQuery;
        String status = 'ToUpdate';
        RequestQuery = 'select Id, InwiB2B_MDN_Dealer__c, InwiB2C_Segment__c, InwiB2C_Region__c, InwiB2C_Regional__c, InwiB2C_Numero_Contact__c, InwiB2C_RVR__c,inwiB2C_Erreur__c,INWIB2C_STATUT__c from InwiB2C_UpdateDealer__c where INWIB2C_STATUT__c = :status limit 200';
        return Database.getQueryLocator(RequestQuery) ;         
    }
    public void execute(Database.BatchableContext BC, List<InwiB2C_UpdateDealer__c> scope){      
        System.debug('In Execute:'+scope);
        List<InwiB2C_UpdateDealer__c> listDealersToUpdate=[SELECT InwiB2B_MDN_Dealer__c,InwiB2C_RVR__c,InwiB2C_Regional__c FROM InwiB2C_UpdateDealer__c WHERE INWIB2C_STATUT__c =  'ToUpdate'];
        List<string> ListMdnDealer = new List <String>();
        List<string> ListRVRDealer = new List <String>();
        List<string> ListRegionalDealer = new List <String>();
        Map <String, vlocity_cmt__Subscription__c> subsMap = new Map <String, vlocity_cmt__Subscription__c>();
        Map <String, String> RVRMap = new Map <String, String>();
        Map <String, String> regionalMap = new Map <String, String>();
        List<InwiB2C_Update_Dealer__e> UpdateDealer_event = new List<InwiB2C_Update_Dealer__e>();

        for(InwiB2C_UpdateDealer__c mdnDealer : listDealersToUpdate){
            ListMdnDealer.add(mdnDealer.InwiB2B_MDN_Dealer__c);
            ListRVRDealer.add(mdnDealer.InwiB2C_RVR__c);
            ListRegionalDealer.add(mdnDealer.InwiB2C_Regional__c);
        }
        
        for(vlocity_cmt__Subscription__c subscription : [SELECT id, Inwib2c_Num_ro_de_la_ligne__c,vlocity_cmt__AccountId__c,vlocity_cmt__AccountId__r.vlocity_cmt__PrimaryContactId__c
            FROM vlocity_cmt__Subscription__c
            WHERE InwiB2C_Segment_March__c  = 'Dealer' and Inwib2c_Num_ro_de_la_ligne__c in :ListMdnDealer]){
            if (! subsMap.containsKey(subscription.Inwib2c_Num_ro_de_la_ligne__c)){
                subsMap.put(subscription.Inwib2c_Num_ro_de_la_ligne__c, subscription);
            }
        }

        for(User user : [SELECT id, Name
            FROM User
            WHERE Name in :ListRVRDealer]){
            if (! RVRMap.containsKey(user.Name)){
                RVRMap.put(user.Name, user.id);
            }
        }
        for(User user : [SELECT id, Name
            FROM User
            WHERE Name in :ListRegionalDealer]){
            if (! regionalMap.containsKey(user.Name)){
                regionalMap.put(user.Name, user.id);
            }
        }

        for (sObject objScope: scope) {
            InwiB2C_UpdateDealer__c newObjScope = (InwiB2C_UpdateDealer__c)objScope;
        if (subsMap.containsKey(newObjScope.InwiB2B_MDN_Dealer__c)) {
            InwiB2C_Update_Dealer__e eventToCreate = new InwiB2C_Update_Dealer__e();
            eventToCreate.InwiB2C_AccountId__c = (subsMap.get(newObjScope.InwiB2B_MDN_Dealer__c)).vlocity_cmt__AccountId__c;
            eventToCreate.InwiB2C_ContactId__c = (subsMap.get(newObjScope.InwiB2B_MDN_Dealer__c)).vlocity_cmt__AccountId__r.vlocity_cmt__PrimaryContactId__c;
            eventToCreate.InwiB2C_segmentDealer__c = newObjScope.InwiB2C_Segment__c;
            eventToCreate.InwiB2C_RegionDealer__c = newObjScope.InwiB2C_Region__c;
            eventToCreate.InwiB2C_IdUpdateDealer__c = newObjScope.Id;
            eventToCreate.InwiB2C_RegionalDealer__c = regionalMap.containsKey(newObjScope.InwiB2C_Regional__c) ?  regionalMap.get(newObjScope.InwiB2C_Regional__c) : '';
            eventToCreate.InwiB2C_Numero_Contact__c = newObjScope.InwiB2C_Numero_Contact__c;
            eventToCreate.InwiB2C_RVRDealer__c = RVRMap.containsKey(newObjScope.InwiB2C_RVR__c) ? RVRMap.get(newObjScope.InwiB2C_RVR__c) : '';
            UpdateDealer_event.add(eventToCreate);
            //newObjScope.INWIB2C_STATUT__c = 'Termine';
            
        }
        else {
            newObjScope.inwiB2C_Erreur__c = 'Ce MDN dealer n\'exite pas.' ;
            newObjScope.INWIB2C_STATUT__c = 'Erreur'; 
        }
    }
    
    update scope;
    System.debug('Fin class0:'+scope);  
    System.debug('Fin class1:'+UpdateDealer_event); 
    List <Database.SaveResult> sresult = EventBus.publish(UpdateDealer_event);
    
    //System.debug('after insert UpdateDealer_event:'+UpdateDealer_event);
    
    }


    public void finish(Database.BatchableContext BC){
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
        a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
        a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 
        String[] email = new String[]{'abdelali.bakhti@assa-associates.com'};
        mail.setToAddresses(email);
        mail.setReplyTo('abdelali.bakhti@assa-associates.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed'+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    /*public void finish(Database.BatchableContext BC) 
    {
        //Query the AsyncApexJob object to retrieve the current job's information.
           AsyncApexJob apexJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                                  FROM AsyncApexJob WHERE Id =: BC.getJobId()];
            
            //Send an email to the Apex job's submitter notifying of job completion.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddress = new String[] {apexJob.CreatedBy.Email};
            system.debug('apexJob.CreatedBy.Email : '+apexJob.CreatedBy.Email);
            mail.setToAddresses(toAddress);
            mail.setSubject('Apex Job status is ' + apexJob.Status);
            mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems + ' batches with '+ apexJob.NumberOfErrors + ' failures.');
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                
            system.debug('results : '+results);
            if (!results.get(0).isSuccess()) {
                System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                String errorMessage = results.get(0).getErrors()[0].getMessage();
            }
        }*/
 
}