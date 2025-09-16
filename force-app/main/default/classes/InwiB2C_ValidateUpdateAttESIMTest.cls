@isTest(SeeAllData=true)
public class InwiB2C_ValidateUpdateAttESIMTest {
@isTest(SeeAllData = true)
    public static void InwiB2C_ValidateUpdateAttESIMTest(){
         InwiB2C_ValidateUpdateAttESIM__e  EventItem = new InwiB2C_ValidateUpdateAttESIM__e (InwiB2C_PanierId__c='xxxx',InwiB2C_OrderId__c='xxxx');
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
    }
}