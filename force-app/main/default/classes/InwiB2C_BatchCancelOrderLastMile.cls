public class InwiB2C_BatchCancelOrderLastMile implements Database.Batchable<sObject>, Database.AllowsCallouts {
    private DateTime cutoffTime;
    private Decimal TimeOrder;
    private Integer intConvertedValue;
    // Méthode start : Initialisation du batch
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Définir le délai de 2 heures
       // cutoffTime = System.now().addHours(-2);
        System.debug('Cutoff time for cancellation: ' + cutoffTime);
       // TimeOrder = [Select MasterLabel, inwiB2C_LimitTimeCancelOrder__c, Label from inwiB2CTimeOrderCancelLastMile__mdt limit 1].inwiB2C_LimitTimeCancelOrder__c;
       // intConvertedValue = TimeOrder.intValue();
       // cutoffTime = System.Now().addHours(-intConvertedValue);
        // Requête pour récupérer les commandes à annuler
        return Database.getQueryLocator(
            'SELECT Id, CreatedDate, inwib2c_Partenaire__r.inwib2c_CodePartenaire__c ' +
            'FROM Order ' +
            'WHERE inwiB2C_Statut__c = \'inwiB2C_A_Annuler\' ' 
           // +'AND CreatedDate <= :cutoffTime' 
           +'limit 200'
        );
    }

    // Méthode execute : Traite chaque lot de commandes
    public void execute(Database.BatchableContext BC, List<Order> scope) {
        List<InwiB2C_CancelOrderBatchLastMile__e> eventsToPublish = new List<InwiB2C_CancelOrderBatchLastMile__e>();

        // Parcourir les commandes à annuler et créer des événements
        for (Order orderItem : scope) {
            InwiB2C_CancelOrderBatchLastMile__e eventToCreate = new InwiB2C_CancelOrderBatchLastMile__e();
            eventToCreate.inwiB2C_OrderId__c = orderItem.Id;
            eventToCreate.inwiB2C_CodePartenaire__c = orderItem.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c;
            eventsToPublish.add(eventToCreate);
        }

        // Publier les événements pour annuler les commandes
        if (!eventsToPublish.isEmpty()) {
            List<Database.SaveResult> saveResults = EventBus.publish(eventsToPublish);
            System.debug('Events published for cancellation: ' + eventsToPublish.size());
        }
    }

    // Méthode finish : Action finale après l'exécution complète du batch
    public void finish(Database.BatchableContext BC){
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
                          a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
                          a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] email = new String[]{'oumaima.gharnoussi@assa-associates.com'};
            mail.setToAddresses(email);
        mail.setReplyTo('oumaima.gharnoussi@assa-associates.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed'+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}