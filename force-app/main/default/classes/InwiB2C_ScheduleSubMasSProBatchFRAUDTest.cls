@istest
 class InwiB2C_ScheduleSubMasSProBatchFRAUDTest {
        public static testMethod void testschedule() {
            Test.StartTest();
            InwiB2C_ScheduleSubMasSProBatch_FRAUDE testsche = new InwiB2C_ScheduleSubMasSProBatch_FRAUDE();
            String sch = '0 0 23 * * ?';
            system.schedule('Test status Check', sch, testsche );
            Test.stopTest();
            
        }
    
}