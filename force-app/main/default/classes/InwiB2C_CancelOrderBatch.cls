/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-25-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class InwiB2C_CancelOrderBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String query;
    String email;
    Id toUserId;
    Id fromUserId;
    private DateTime dt;
    private Decimal TimeOrder;
    private Integer intConvertedValue;
    private DateTime recycleLimitDate;  // Nouvelle date pour recyclage
    private Decimal recycleDays;        // Nombre de jours pour le recyclage
    private Integer intConvertedRecycleDays;
    
    public Database.querylocator start(Database.BatchableContext BC){
        
        TimeOrder = [Select MasterLabel, inwiB2C_TimeOutOrder__c, Label from inwiB2CTimeOrderCancel__mdt limit 1].inwiB2C_TimeOutOrder__c;
         //H-M Récupérer le délai de recyclage commande BO CRC D2D "MGEN3670SF" Begin
        recycleDays = [SELECT MasterLabel,RecyclingTimeoutDays__c,Label FROM inwiB2CTimeOrderCancel__mdt LIMIT 1].RecyclingTimeoutDays__c;
         //H-M Récupérer le délai de recyclage  commande BO CRC D2D  END 

        id orderIdTemplateDealer = [Select MasterLabel, OrderId__c, Label from InwiB2C_IdOrderToClone__mdt where label = 'OrderIdDealer' limit 1].OrderId__c;
        id orderIdTemplate = [Select MasterLabel, OrderId__c, Label from InwiB2C_IdOrderToClone__mdt where label = 'OrderId' limit 1].OrderId__c;
        intConvertedValue = TimeOrder.intValue();
        dt = System.Now().addHours(-intConvertedValue);
        system.debug('limit time order is :'+ dt);

         //H-M date limit des commandes d2d "A Recycler" plus de X jours Begin
         intConvertedRecycleDays = recycleDays.intValue();
         recycleLimitDate = System.now().addDays(-intConvertedRecycleDays);
         system.debug('limit time order RecycleDay  :'+ recycleLimitDate);
         //H-M date limit des commandes d2d "A Recycler" plus de X jours END

        // return Database.getQueryLocator(
        //     //'select Id,LastModifiedDate,inwib2c_Partenaire__r.inwib2c_CodePartenaire__c from order where Id = \'8012500000283xCAAQ\''
        //     'select Id,LastModifiedDate,inwib2c_Partenaire__r.inwib2c_CodePartenaire__c from order where id not in (:orderIdTemplate, :orderIdTemplateDealer) and LastModifiedDate <= : dt  and inwiB2C_Statut__c in (\'inwiB2C_EnCours\', \'inwiB2C_Paiement\') AND (inwib2c_CodeDeTransaction__c = null AND InwiB2C_Code_de_transaction_FMS__c = null AND InwiB2C_CodeTransactionFMD__c= null) AND (InwiB2C_Type_Offer__c !=\'Cameleon\') AND (inwib2c_TypeDeLaCommande__c=\'inwiB2C_Acquisition\' OR inwib2c_TypeDeLaCommande__c=\'inwiB2C_Migration\'  ) limit 200'
        // );

       //H-M Ajouter le statut A Recycler et la date Limit recyclage commande d2d 
        return Database.getQueryLocator(
            'SELECT Id, LastModifiedDate, inwib2c_Partenaire__r.inwib2c_CodePartenaire__c ' +
            'FROM Order ' + 
            'WHERE ( id NOT IN (:orderIdTemplate, :orderIdTemplateDealer) ' +
            'AND LastModifiedDate <= :dt ' +
            'AND inwiB2C_Statut__c IN (\'inwiB2C_EnCours\', \'inwiB2C_Paiement\') ' + 
            'AND (inwib2c_CodeDeTransaction__c = NULL ' + 
            'AND InwiB2C_Code_de_transaction_FMS__c = NULL ' +
            'AND InwiB2C_CodeTransactionFMD__c = NULL) ' + 
            'AND (InwiB2C_Type_Offer__c != \'Cameleon\') ' +
            'AND (inwib2c_TypeDeLaCommande__c = \'inwiB2C_Acquisition\' ' + 
            'OR inwib2c_TypeDeLaCommande__c = \'inwiB2C_Migration\')) ' + 
            'OR (inwiB2C_Statut__c = \'inwiB2C_A_Recycler\' AND LastModifiedDate <= :recycleLimitDate) ' +
            'LIMIT 200' 
        );

        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        // H-M : SECTION TEMPORAIRE POUR TESTS UNIQUEMENT
       // À activer uniquement pour tester les commandes avec un statut specfique sur les environnnment de test pour valider les TEST 
       // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
       // return Database.getQueryLocator(
       // 'SELECT Id, LastModifiedDate, inwib2c_Partenaire__r.inwib2c_CodePartenaire__c ' +
       // 'FROM Order ' +
       //     'WHERE inwiB2C_Statut__c = \'inwiB2C_A_Recycler\' AND LastModifiedDate <= :recycleLimitDate ' +
       //     'LIMIT 200'
       // );
       // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


        
        //String query = 'select Id,LastModifiedDate,inwib2c_Partenaire__r.inwib2c_CodePartenaire__c from order where id <> \''+ orderIdTemplate+'\' and id <> \''+orderIdTemplateDealer+'\' and LastModifiedDate <= '+dt+' and inwiB2C_Statut__c in (\'inwiB2C_EnCours\', \'inwiB2C_Paiement\')';
    //return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Order> scope){
        
        List<inwiB2C_CancelOrdersBatchEvent__e> ItemsToInsert = new List<inwiB2C_CancelOrdersBatchEvent__e>();
        
        for (Order orderItem : scope) {
            
            inwiB2C_CancelOrdersBatchEvent__e eventToCreate = new inwiB2C_CancelOrdersBatchEvent__e();
            eventToCreate.inwiB2C_OrderId__c = orderItem.Id;
            eventToCreate.inwiB2C_CodePartenaire__c = orderItem.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c;

            ItemsToInsert.add(eventToCreate);
            
        }	

           
        system.debug('list of orders to cancel :'+ ItemsToInsert);
        List <Database.SaveResult> sresult = EventBus.publish(ItemsToInsert);
        
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