@isTest
public with sharing class inwiB2C_Create_Comment_SNTriggerTest {
    public static testMethod void testTriggerLogic() {
        List<InwiB2C_Create_Comment_SN__e> testEvents = new List<InwiB2C_Create_Comment_SN__e>();
        InwiB2C_Create_Comment_SN__e testEvent = new InwiB2C_Create_Comment_SN__e(inwiB2C_CommentId__c = '021252');
        testEvents.add(testEvent);
          
          // Publish the test event
          Test.startTest();
          List<Database.SaveResult> results = EventBus.publish(testEvents);
          Test.stopTest();
  
  
      }

}