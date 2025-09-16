@istest
public class inwiB2C_SchedUpdateInvoicSuspBatchTest {
public static testMethod void testschedule() {
		Test.StartTest();
		inwiB2C_ScheduleUpdateInvoicSuspenBatch testsche = new inwiB2C_ScheduleUpdateInvoicSuspenBatch();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}