public class InwiB2C_CreateOrderCH_TechnlogieBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String RequestQuery ;
    
    
public Database.querylocator start(Database.BatchableContext BC){

    RequestQuery = 'select Id,InwiB2C_Statut__c,InwiB2C_Order__c,InwiB2C_Demande_degroupage__c,InwiB2C_Attribut_technologie_source__c,InwiB2C_Attribut_technologie_cible__c  from InwiB2C_changement_technologie_automa__c where (InwiB2C_Statut__c =  \'In Progres\' and InwiB2C_Nouvelle_Commande__c !=null) limit 200';
    
    return Database.getQueryLocator(RequestQuery) ;         
    }
public void execute(Database.BatchableContext BC, List<InwiB2C_changement_technologie_automa__c> scope){      
    
        system.debug('batch scope'+scope);  
        String RequestStatus = 'running ';
        List<InwiB2C_CreateOrder_CH_Technologie__e> ChangementRequest_event = new List<InwiB2C_CreateOrder_CH_Technologie__e>();
    
        for (InwiB2C_changement_technologie_automa__c  requestitem: scope)
        {
        
            InwiB2C_CreateOrder_CH_Technologie__e eventToCreate = new InwiB2C_CreateOrder_CH_Technologie__e();
                eventToCreate.InwiB2C_Order__c = requestitem.InwiB2C_Order__c;
                eventToCreate.InwiB2C_Id_Demande_degroupage__c = requestitem.Id;
                eventToCreate.InwiB2C_Attribut_technologie_cible__c = requestitem.InwiB2C_Attribut_technologie_cible__c;

                
                requestitem.InwiB2C_Statut__c=RequestStatus;
                ChangementRequest_event.add(eventToCreate);	
        }
    
        List <Database.SaveResult> sresult = EventBus.publish(ChangementRequest_event);
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