@isTest
public class InwiB2C_TraitementNotificationDegTest {
    @isTest
    public static void notification(){
        InwiB2C_Notification_degroupage__c  trace = new InwiB2C_Notification_degroupage__c();
        insert trace;
        InwiB2C_Notification_degroupage_Event__e eventMsg = new InwiB2C_Notification_degroupage_Event__e(InwiB2C_trace_Id__c=trace.id); 
        Test.startTest();
        EventBus.publish(eventMsg);
        Test.stopTest();
    }


}