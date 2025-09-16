@istest
class InwiB2C_ScheduleSubsMassProBatch_IMXTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleSubsMassProcesBatch_IMX testsche = new InwiB2C_ScheduleSubsMassProcesBatch_IMX();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}