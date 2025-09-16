@isTest
public class inwiB2C_TraitementMirCpCntTriggerTest {
public static testMethod void testExecuteSMO() {
       		InwiB2C_Trace_API__c trace = new InwiB2C_Trace_API__c();
            trace.InwiB2C_MDN__c='212648069781';
     		trace.InwiB2C_request_body__c= '{"CSOperationInfo":{"channel":"","user":"","uuid":"1234"},"CSExecuteMigPostPost":{"CSExecuteMigrCampus":{"mdn1":"212648069781","mdn2":"2126481010"}}';
            insert trace;
            
        InwiB2C_TraitementMirCampusConnectEvent__e EventItem = new InwiB2C_TraitementMirCampusConnectEvent__e(InwiB2C_TraceId__c=trace.Id);
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
        
 }
}