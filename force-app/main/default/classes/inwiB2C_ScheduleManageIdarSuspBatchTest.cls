@IsTest
public class inwiB2C_ScheduleManageIdarSuspBatchTest {
   @IsTest
    static void testBatchJob() {
        Test.startTest();
        inwiB2C_ScheduleManageIdarSuspBatch testsche = new inwiB2C_ScheduleManageIdarSuspBatch();
        String cronExpression = '0 0 0 * * ?'; 
        String jobName = 'TestScheduleManageIdarSuspensionBatchJob';
        System.schedule(jobName, cronExpression, testsche);
        Test.stopTest();
    }
}