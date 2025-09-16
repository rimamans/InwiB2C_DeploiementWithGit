@istest
class InwiB2C_ScheduleBatchOrderLastMileTest {
    public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleBatchCancelOrderLastMile testsche = new InwiB2C_ScheduleBatchCancelOrderLastMile();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}