@istest
public class InwiB2C_DeferredBatchScheduleTest {
public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_DeferredMigrationBatchSchedule testsche = new InwiB2C_DeferredMigrationBatchSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}