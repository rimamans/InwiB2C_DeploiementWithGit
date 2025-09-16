@istest
class InwiB2C_CreateOrderCHSchedulableTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_CreateOrderCHSchedulable testsche = new InwiB2C_CreateOrderCHSchedulable();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}