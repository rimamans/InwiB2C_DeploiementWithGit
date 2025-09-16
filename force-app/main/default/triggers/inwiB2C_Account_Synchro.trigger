trigger inwiB2C_Account_Synchro on Account (before update){

    // Trigger created to check which fields are updated

    // Get billing record type
    String type = 'Billing';
    RecordType recordType = [select id, name
                             from RecordType
                             where name = :type
                             limit 1];


    // Get user
    String Username = 'prod.salesforceb2c@inwi.ma.inwib2c';

    Id prodId = (Id) '0054K00000438M3QAI';

    // List of plateform events
    List<Sync_Client__e> data = new List<Sync_Client__e>();

    for (Account newAccount : Trigger.new ){
        // get account before update
        Account oldAccount = Trigger.oldMap.get(newAccount.ID);

        // Synch only accounts managed in SF (inwiB2C_managedInSF__c == true)
        // and account type <> Billing (RecordTypeId != recordType.Id)
        // no synchro after updating inwiB2C_PS_BO_ID__c
        //

        System.debug('newAccount.LastModifiedById');
        System.debug(newAccount.LastModifiedById);

        if (newAccount.inwiB2C_managedInSF__c == true && newAccount.RecordTypeId != recordType.Id && newAccount.inwiB2C_PS_BO_ID__c == oldAccount.inwiB2C_PS_BO_ID__c && prodId != newAccount.LastModifiedById){
            Sync_Client__e c = new Sync_Client__e(AccountId__c = newAccount.Id);
            data.add(c);
        }
    }

    System.debug('size');
    System.debug(String.valueOf(data.size()));
    List<Database.SaveResult> sresult = EventBus.publish(data);
}