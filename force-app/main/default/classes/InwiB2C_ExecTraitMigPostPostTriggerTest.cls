@isTest
public class InwiB2C_ExecTraitMigPostPostTriggerTest {
 public static testMethod void testExecuteSMO() {
       		InwiB2C_Trace_API__c trace = new InwiB2C_Trace_API__c();
            trace.InwiB2C_MDN__c='212648069781';
     		trace.InwiB2C_request_body__c= '{"CSOperationInfo":{"channel":"","user":"","uuid":"1234"},"CSExecuteMigPostPost":{"Code_offre":"INWIB2C_OFFERING_99DH_ILLINWI_APL","Ins":"","MDN":"212648101017","Profil":"86910","TL":"CI","billingAccount":"","productId":"Forfait 11h + 11Go"}}';  
            insert trace;
            
        inwiB2C_ExecuteTraitementMigPostPostSMO__e EventItem = new inwiB2C_ExecuteTraitementMigPostPostSMO__e(InwiB2C_TraceId__c=trace.Id);
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
        
 }
}