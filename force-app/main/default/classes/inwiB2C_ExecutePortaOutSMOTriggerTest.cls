@isTest
public class inwiB2C_ExecutePortaOutSMOTriggerTest {
 public static testMethod void testExecuteSMO() {
       		InwiB2C_Trace_API__c trace = new InwiB2C_Trace_API__c();
            trace.InwiB2C_MDN__c='212648069781';
     		trace.InwiB2C_request_body__c= '{"CSOperationInfo":"","CSCreateSMO":{"mdn":"212648068203","MotifSusp":"Perte / Vol","SuspType":"Total","actionType":"SUSP","canal":"inwiB2C_MyInwi"}}';  
            insert trace;
            
        InwiB2C_TraitementPortaOutSMO__e EventItem = new InwiB2C_TraitementPortaOutSMO__e(TraceId__c=trace.Id);
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
        
 }
}