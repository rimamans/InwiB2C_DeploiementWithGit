@istest
class inwiB2C_SchuExecAsyncLimitedAPIBatchTest {
    public static testMethod void testschedule() {
		Test.StartTest();
		inwiB2C_SchuExecAsyncLimitedAPIBatch testsche = new inwiB2C_SchuExecAsyncLimitedAPIBatch();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}