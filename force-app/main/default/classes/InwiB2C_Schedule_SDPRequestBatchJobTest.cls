/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
class InwiB2C_Schedule_SDPRequestBatchJobTest {
    public static testMethod void testschedule() {
        Test.StartTest();
        InwiB2C_Schedule_SDPRequestBatchJob batchJob = new InwiB2C_Schedule_SDPRequestBatchJob();
        String cronExp = '0 0 0 ? * * *';
        System.schedule('Test batch Scheduler', cronExp, batchJob);
        Test.stopTest();
    }
}