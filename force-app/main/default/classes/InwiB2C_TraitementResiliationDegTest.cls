@isTest
public class InwiB2C_TraitementResiliationDegTest {
     @isTest
    public static void resiliation(){
        vlocity_cmt__Subscription__c ligne = new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='123');
        insert ligne;
        InwiB2C_TraitementResiliationDegroupage__e eventResil = new InwiB2C_TraitementResiliationDegroupage__e(InwiB2C_subscriptionId__c=ligne.id); 
        Test.startTest();
        EventBus.publish(eventResil);
        Test.stopTest();
    }

}