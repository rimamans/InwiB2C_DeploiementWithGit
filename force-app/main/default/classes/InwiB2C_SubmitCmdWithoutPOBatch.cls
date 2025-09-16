global class InwiB2C_SubmitCmdWithoutPOBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
       String query = 'SELECT Id, LastModifiedDate, vlocity_cmt__OrchestrationPlanId__c, inwiB2C_Canal__c, CreatedDate, inwiB2C_TypeActeDeGestion__c, inwiB2C_TypeDeMigration__c ' +
                'FROM Order ' +
                'WHERE inwiB2C_Statut__c = \'inwiB2C_Activation\' ' +
                'AND vlocity_cmt__OrchestrationPlanId__c = \'\' ' +
                /*CHB 10/12/2024 B-15434 begin*/
                'inwiB2C_TypeActeDeGestion__c !=\'inwiB2C_Synchronisation_Assets\'' +
                'ORDER BY CreatedDate ASC ' +  /*CHB 10/12/2024 B-15434 end */
                'LIMIT 200';

                        System.debug(query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Order> scope) {
        System.debug('Start execution.');
        List<inwiB2C_API_Create_SMO__e> eventForCheckoutList = new List<inwiB2C_API_Create_SMO__e>();

        for (Order order : scope) {
            System.debug('Start boucle.');
            inwiB2C_API_Create_SMO__e eventForCheckout = new inwiB2C_API_Create_SMO__e();
            eventForCheckout.inwiB2C_step__c = 'checkout';
            eventForCheckout.inwiB2C_OrderId__c = order.Id;
            eventForCheckoutList.add(eventForCheckout);
            System.debug('display event for checkout '+eventForCheckout);
        }

        List<Database.SaveResult> results = EventBus.publish(eventForCheckoutList);
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Batch processing completed successfully.');
    }
}