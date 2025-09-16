public class InwiB2C_OrderDeactivationBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
String query;
String email;
Id toUserId;
Id fromUserId;

public Database.querylocator start(Database.BatchableContext BC){
           String limitRecordsRetreived;
           limitRecordsRetreived = [Select MasterLabel, InwiB2C_LimitPortaOutBatch__c, Label from InwiB2C_OrderDeactivationBatchLimit__mdt where label = 'PortaOutLimit' limit 1].InwiB2C_LimitPortaOutBatch__c;

            return Database.getQueryLocator(
            'select ID, INWIB2C_STATUT__c, INWIB2C_PORTED_MDN__c from INWIB2C_REQ_PORTA__c where INWIB2C_STATUT__c = \'NEW\' and INWIB2C_ACTION_CODE__c = \'DEACTIVATION\' LIMIT '+limitRecordsRetreived
        );}
 
public void execute(Database.BatchableContext BC, List<INWIB2C_REQ_PORTA__c> scope){
    
    List<inwiB2C_API_Create_SMO__e> ItemsToInsert = new List<inwiB2C_API_Create_SMO__e>();
    List<INWIB2C_REQ_PORTA__c> ItemsToUpdateStatus = new List<INWIB2C_REQ_PORTA__c>();

   for (INWIB2C_REQ_PORTA__c portaItem : scope) {
        system.debug('inwiB2C_MDN__c'+portaItem.INWIB2C_PORTED_MDN__c);
       portaItem.INWIB2C_STATUT__c = 'En cours';
       ItemsToUpdateStatus.add(portaItem);

		inwiB2C_API_Create_SMO__e eventCreateOrder = new inwiB2C_API_Create_SMO__e();
        eventCreateOrder.inwiB2C_MDN__c = portaItem.INWIB2C_PORTED_MDN__c;
        eventCreateOrder.inwiB2C_PortaId__c = portaItem.ID;
        eventCreateOrder.inwiB2C_Source__c = 'Deactivate';
        ItemsToInsert.add(eventCreateOrder);
        //Database.SaveResult sresult = EventBus.publish(eventCreateOrder);
		
   }
   system.debug('ItemsToInsert'+ItemsToInsert);
    List <Database.SaveResult> sresult = EventBus.publish(ItemsToInsert);
    Update ItemsToUpdateStatus;
}
public void finish(Database.BatchableContext BC){
          AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
      a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
      a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 
String[] email = new String[]{'jawad.bentaybi@atos.net'};
mail.setToAddresses(email);
mail.setReplyTo('jawad.bentaybi@atos.net');
mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Completed'+a.Status);
mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
 
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}

}