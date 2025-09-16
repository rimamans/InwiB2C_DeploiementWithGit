@istest
class InwiB2C_ScheduleRattrapageUSSDDraftTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleRattrapageUSSDDraftOrd testsche = new InwiB2C_ScheduleRattrapageUSSDDraftOrd();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}