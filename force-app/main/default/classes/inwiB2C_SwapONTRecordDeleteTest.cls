@isTest
public class inwiB2C_SwapONTRecordDeleteTest {
     public static testMethod void testTrigger() {
         
    	InwiB2C_offre_ciblee__c offre = new InwiB2C_offre_ciblee__c();
         insert offre;
         
        inwiB2C_Swap_ONT_Record_Delete_Event__e swapEvent = new inwiB2C_Swap_ONT_Record_Delete_Event__e(inwiB2C_Record_Id__c=offre.Id);
        Test.startTest();
        Database.SaveResult results = EventBus.publish(swapEvent);
        Test.stopTest();
    }
    

}