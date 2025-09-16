@istest
class InwiB2C_ScheduCCBulkRattAssetBatchTest {
    public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduCCBulkRattrapageAssetBatch testsche = new InwiB2C_ScheduCCBulkRattrapageAssetBatch();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}