@isTest
public class inwiB2C_MigrationAssetEventTriggerTest {
     public static testMethod void SubsMassProcessingTriggerTest() {
        Asset a=new asset();
        a.name='test';
        insert a;

        List<InwiB2C_Asset_Migration_Event__e> eventItems = new List<InwiB2C_Asset_Migration_Event__e>();
        InwiB2C_Asset_Migration_Event__e eventItem = new InwiB2C_Asset_Migration_Event__e(Step__c='CreateOrder',AssetId__c=a.id);     
        eventItems.add(eventItem) ;
        
        InwiB2C_Asset_Migration_Event__e eventItem1 = new InwiB2C_Asset_Migration_Event__e(Step__c='checkOut',AssetId__c=a.id);     
        eventItems.add(eventItem1) ;
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
       
        
    }
}