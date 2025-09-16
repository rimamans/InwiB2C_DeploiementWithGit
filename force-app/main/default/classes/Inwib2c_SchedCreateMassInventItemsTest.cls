@istest
public class Inwib2c_SchedCreateMassInventItemsTest {

    public static testMethod void testschedule() {
		Test.StartTest();
		Inwib2c_ScheduleCreateMassInventoryItems testsche = new Inwib2c_ScheduleCreateMassInventoryItems();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}