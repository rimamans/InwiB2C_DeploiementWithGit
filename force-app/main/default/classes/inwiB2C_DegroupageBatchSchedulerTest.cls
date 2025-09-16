@isTest
public class inwiB2C_DegroupageBatchSchedulerTest {
 @isTest
    static void testScheduler() {
        Test.startTest();

        inwiB2C_DegroupageBatchScheduler scheduler = new inwiB2C_DegroupageBatchScheduler();
        
        String jobId = System.schedule('Test Degroupage Batch Scheduler', '0 0 0 * * ?', scheduler);

        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                                   FROM CronTrigger WHERE Id = :jobId];
        
        System.assertEquals('0 0 0 * * ?', cronTrigger.CronExpression);
        System.assertEquals(0, cronTrigger.TimesTriggered);
        
        Test.stopTest();
    }
}