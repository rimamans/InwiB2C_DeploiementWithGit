@isTest
public class inwiB2C_CallAnnulDmdDegroupageTest {
     @isTest
    static void testTriggerExecution() {

        Test.startTest();

        inwiB2C_CallAnnulDmdDegroupage__e testEvent = new inwiB2C_CallAnnulDmdDegroupage__e(
            InwiB2C_Action__c = 'TestAction',
            inwiB2C_DemandeDeg__c = 'TestCommandeDeg',
            inwiB2C_Type__c = 'TestType'
        );


        List<inwiB2C_CallAnnulDmdDegroupage__e> eventList = new List<inwiB2C_CallAnnulDmdDegroupage__e>();
        eventList.add(testEvent);

        Database.SaveResult[] srList = EventBus.publish(eventList);
        System.assertEquals(1, srList.size());
        System.assert(srList[0].isSuccess());

        Test.stopTest();
        

    }

}