trigger  inwiB2C_UpdateDealerEvtTrigger on InwiB2C_Update_Dealer__e (after insert) {

    List<Account> listAccountsToUpdate = new List <Account>();
    List<Contact> listContactsToUpdate = new List<Contact>();
    List<InwiB2C_UpdateDealer__c> listUpdateDealersToUpdate = new List<InwiB2C_UpdateDealer__c>();
    for (InwiB2C_Update_Dealer__e event : Trigger.New) {
        System.debug('AccId:'+event.InwiB2C_AccountId__c);
        System.debug('segm:'+event.InwiB2C_segmentDealer__c);
        System.debug('Regional:'+event.InwiB2C_RegionalDealer__c);
        System.debug('Region:'+'inwib2c_'+event.InwiB2C_RegionDealer__c);
        System.debug('RVR:'+event.InwiB2C_RVRDealer__c);
        System.debug('UpDealerId:'+event.InwiB2C_IdUpdateDealer__c);
        System.debug('contact Id:'+event.InwiB2C_ContactId__c);
        System.debug('num contact:'+event.InwiB2C_Numero_Contact__c);
        //System.debug('Statut updateDealer:'+event.INWIB2C_STATUT__c);
        if(event.InwiB2C_AccountId__c != '' && event.InwiB2C_AccountId__c != null){
         Account account = new Account (
            id = event.InwiB2C_AccountId__c,
            InwiB2C_Segment_Dealer__c = event.InwiB2C_segmentDealer__c,
            inwib2c_Region__c = 'inwib2c_'+event.InwiB2C_RegionDealer__c,
            InwiB2C_Regional__c = event.InwiB2C_RegionalDealer__c,
            InwiB2C_RVR__c = event.InwiB2C_RVRDealer__c
         );
         listAccountsToUpdate.add(account);
        }
        if(event.InwiB2C_ContactId__c != '' && event.InwiB2C_ContactId__c != null ){
         Contact contact = new Contact(
            id = event.InwiB2C_ContactId__c,
            InwiB2C_Num_ro_de_contact__c = event.InwiB2C_Numero_Contact__c
         );
         listContactsToUpdate.add(contact);
         }
         if(event.InwiB2C_IdUpdateDealer__c != '' && event.InwiB2C_IdUpdateDealer__c != null ){
            InwiB2C_UpdateDealer__c UpdateDealer = new InwiB2C_UpdateDealer__c(
               id = event.InwiB2C_IdUpdateDealer__c,
               INWIB2C_STATUT__c='Termine'
            );
            listUpdateDealersToUpdate.add(UpdateDealer);
            }
         
    }
    Update listAccountsToUpdate;
    Update listContactsToUpdate;
    Update listUpdateDealersToUpdate;
}