@istest
public class inwib2c_ScheduleIdentTest {
public static testMethod void testschedule() {
		Test.StartTest();
		inwib2c_ScheduleIdent testsche = new inwib2c_ScheduleIdent();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}