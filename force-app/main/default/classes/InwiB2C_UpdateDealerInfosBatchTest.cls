@isTest
public class InwiB2C_UpdateDealerInfosBatchTest {
@isTest(SeeAllData=true)
    public static void InwiB2C_UpdateDealerInfosBatchTest(){
        Test.startTest();
        // Insert Update Dealer 
        InwiB2C_UpdateDealer__c updateDealer = new InwiB2C_UpdateDealer__c();
        updateDealer.InwiB2B_MDN_Dealer__c = '212612547896';
        updateDealer.InwiB2C_Segment__c='R+';
        updateDealer.InwiB2C_Region__c='inwib2c_SUD';
        updateDealer.InwiB2C_Regional__c='Lamyaa Brikssi';
        updateDealer.InwiB2C_Numero_Contact__c='212641759522';
        updateDealer.InwiB2C_RVR__c='Lamyaa Brikssi';
        updateDealer.INWIB2C_STATUT__c='ToUpdate';
        insert updateDealer;
        //Insert Contact
        Contact contact = new Contact();
        contact.InwiB2C_Num_ro_de_contact__c = '212654784125';
        contact.LastName = 'Test';
        insert contact;
        //Insert Account
        Account account = new Account();
        account.Inwib2c_Segment_march__c='Dealer';
        account.vlocity_cmt__PrimaryContactId__c = contact.id;
        account.Name = 'Test account';
        Insert account;
        //Insert Subscription
        vlocity_cmt__Subscription__c subscription = new vlocity_cmt__Subscription__c();
        subscription.vlocity_cmt__SubscriptionNumber__c = '02i1M000000BIaRQAW';
        subscription.inwib2c_vip__c = false;
        subscription.inwiB2C_OptionIdentification__c = false;
        subscription.inwiB2C_managedInSF__c = true;
        subscription.InwiB2C_A_r_silier__c = false;
        subscription.Blacklist__c = false;
        subscription.vlocity_cmt__AccountId__c = account.Id;
        subscription.Inwib2c_Num_ro_de_la_ligne__c='212612547896';
        insert subscription;
        Id bacthId = Database.executeBatch( new InwiB2C_UpdateDealerInformationsBatch());
         Test.stopTest();
    }
}