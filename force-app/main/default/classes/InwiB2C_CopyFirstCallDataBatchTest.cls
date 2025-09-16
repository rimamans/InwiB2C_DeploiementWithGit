@IsTest
public class InwiB2C_CopyFirstCallDataBatchTest {

    @IsTest(seeAllData=true)
    public static void batchTest() {
        Test.startTest();
        
		inwiB2C_ContractFirstCall__c testFirstCall = new inwiB2C_ContractFirstCall__c();
        testFirstCall.inwiB2C_Canal__c = 'FirstCall';
        testFirstCall.inwiB2C_CodeAgence__c = 'CPD01';
        testFirstCall.inwiB2C_CodeArticle__c = '000056826';
        testFirstCall.inwiB2C_CodeDistributeur__c = 'CPD01';
        testFirstCall.inwiB2C_Icc__c = '892128510050188115';
        testFirstCall.inwiB2C_imsi__c = '604050400041084';
        testFirstCall.inwiB2C_Ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        testFirstCall.inwiB2C_Mdn__c = '212622334455';
        testFirstCall.inwiB2C_OcsId__c = 'IN2';
        testFirstCall.inwiB2C_ProfileId__c = '618';
        testFirstCall.inwiB2C_Puk__c = '123456';
        testFirstCall.inwiB2C_User__c = '212648058729';
        testFirstCall.inwiB2C_uuid__c = '1234-5678-9012';
        testFirstCall.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Nouveau';
        insert testFirstCall;
        
        Id bacthId = Database.executeBatch(new InwiB2C_CopyFirstCallDataBatch() , 2000 );
        Test.stopTest();
    }
}