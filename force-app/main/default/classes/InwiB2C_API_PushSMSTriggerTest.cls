@isTest(SeeAllData=true)

public class InwiB2C_API_PushSMSTriggerTest {
 @isTest(SeeAllData = true)
    public static void InwiB2C_API_PushSMSTriggerTest(){
         inwiB2C_API_PushSMS__e EventItem = new inwiB2C_API_PushSMS__e(InwiB2C_MDN__c='212123456789');
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
    }
}