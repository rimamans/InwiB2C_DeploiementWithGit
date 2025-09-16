@isTest
public class inwiB2C_UpdateSubsEventTriggerTest {

@isTest(SeeAllData=true)
    static void MethodTestPositive() {
        Test.startTest();
    inwiB2C_SubscriptionUpdateEvent__e SubUpdateEvent = new inwiB2C_SubscriptionUpdateEvent__e(inwiB2C_Action__c = 'CHNU', inwiB2C_mdn__c ='0122334455', inwiB2C_oldmdn__c ='0155442266');
    
        Database.SaveResult sresult = EventBus.publish(SubUpdateEvent);
        Test.stopTest();
    }
    
}