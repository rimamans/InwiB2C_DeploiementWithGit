/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-10-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class InwB2C_SDPRequestEventTriggerTest {
    public static testMethod void testTriggerLogic() {
        List<InwiB2C_SDPEventRequest__e> testEvents = new List<InwiB2C_SDPEventRequest__e>();
        InwiB2C_SDPEventRequest__e testEvent = new InwiB2C_SDPEventRequest__e(DemandeId__c = 'TestDemandeId');
        testEvents.add(testEvent);
          
          // Publish the test event
          Test.startTest();
          List<Database.SaveResult> results = EventBus.publish(testEvents);
          Test.stopTest();
  
  
      }
}