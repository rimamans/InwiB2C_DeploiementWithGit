@isTest(SeeAllData=true)
public class InwiB2C_IdentificationPDV48hTriggerTest {
    @isTest(SeeAllData = true)
    public static void InwiB2C_IdentificationPDV48hTriggerTest(){
        InwiB2C_Identification_PDV_48h__e  EventItem = new InwiB2C_Identification_PDV_48h__e (InwiB2C_MDN__c='212123456789');
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
    }

}