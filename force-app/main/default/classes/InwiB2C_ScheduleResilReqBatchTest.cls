@istest
class InwiB2C_ScheduleResilReqBatchTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleResiliateRequestBatch testsche = new InwiB2C_ScheduleResiliateRequestBatch();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}