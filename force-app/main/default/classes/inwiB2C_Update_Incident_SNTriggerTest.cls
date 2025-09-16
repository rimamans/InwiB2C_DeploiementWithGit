@isTest
public with sharing class inwiB2C_Update_Incident_SNTriggerTest {
    public static testMethod void testTriggerLogic() {
        List<inwiB2C_Update_Incident_SN__e> testEvents = new List<inwiB2C_Update_Incident_SN__e>();
        inwiB2C_Update_Incident_SN__e testEvent = new inwiB2C_Update_Incident_SN__e(inwiB2C_CaseId__c = '021252');
        testEvents.add(testEvent);
          
          // Publish the test event
          Test.startTest();
          List<Database.SaveResult> results = EventBus.publish(testEvents);
          Test.stopTest();
  
  
      }

}