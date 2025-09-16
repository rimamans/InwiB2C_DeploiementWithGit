@istest
class InwiB2C_ScheduleNotifResilTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleNotifyClientResiliation testsche = new InwiB2C_ScheduleNotifyClientResiliation();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}