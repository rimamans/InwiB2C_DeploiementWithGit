@istest
class InwiB2C_SusStudentProfBatchScheduleTest{
    public static testMethod void testschedule() {
        Test.StartTest();
        InwiB2C_SuspendStudentProfBatchSchedule testsche = new InwiB2C_SuspendStudentProfBatchSchedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
        
    }
}