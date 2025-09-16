@isTest
private class inwiB2C_ScheduleBatchRattrMigFTTHTest {
    @isTest
    static void testScheduleExecution() {
        Test.startTest();
        inwiB2C_ScheduleBatchRattMigrFTTH testsche = new inwiB2C_ScheduleBatchRattMigrFTTH();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
        Test.stopTest();        
    }
}