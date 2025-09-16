@istest
class InwiB2C_ChangementTechnoSchedulableTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ChangementTechnologieSchedulable testsche = new InwiB2C_ChangementTechnologieSchedulable();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}