public  class Inwib2c_updateSubswithoutcontr implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public Integer recordsProcessed = 0;
    String query;
    String email;
    Id toUserId;
    Id fromUserId;
    private DateTime dt;
    private Decimal TimeOrder;
    private Integer intConvertedValue;
    public Database.querylocator start(Database.BatchableContext BC){
        

        return Database.getQueryLocator(
           
            'select id,InwiB2C_Contract__c, Inwib2c_Num_ro_de_la_ligne__c,inwib2c_inst_prod_id__c, inwiB2C_managedInSF__c  from vlocity_cmt__Subscription__c where InwiB2C_Contract__c = null and inwiB2C_managedInSF__c = true and inwib2c_inst_prod_id__c != null'
        );}
    
    public void execute(Database.BatchableContext BC, List<vlocity_cmt__Subscription__c> scope){
        
        List<vlocity_cmt__Subscription__c> subscriptions = new List<vlocity_cmt__Subscription__c>();
        
        for (vlocity_cmt__Subscription__c sub : scope) {
            
            sub.inwiB2C_managedInSF__c = false;
            subscriptions.add(sub);
            recordsProcessed = recordsProcessed + 1;
         
        }	
        system.debug('number of subscriptions:'+ recordsProcessed);
        update subscriptions;
        
    }
    public void finish(Database.BatchableContext BC){
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
                          a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
                          a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] email = new String[]{'islam.hamoudi@assa-associates.com'};
            mail.setToAddresses(email);
        mail.setReplyTo('islam.hamoudi@assa-associates.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed'+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}