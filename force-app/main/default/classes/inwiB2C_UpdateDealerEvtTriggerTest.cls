@isTest
public class inwiB2C_UpdateDealerEvtTriggerTest {
@isTest(SeeAllData=true)
    public static void inwiB2C_UpdateDealerEvtTriggerTest(){
        //Insert Contact
        Contact contact = new Contact();
        contact.InwiB2C_Num_ro_de_contact__c = '212654784125';
        contact.LastName = 'Test';
        insert contact;
        //Insert Account
        Account account = new Account();
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
        insert subscription;
        Id bacthId = Database.executeBatch( new InwiB2C_UpdateDealerInformationsBatch());
}
}