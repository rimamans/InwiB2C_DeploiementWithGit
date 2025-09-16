@istest
class InwiB2C_Schedule_CreateMigratedSubsTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_Schedule_CreateMigratedSubs testsche = new InwiB2C_Schedule_CreateMigratedSubs();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}

}