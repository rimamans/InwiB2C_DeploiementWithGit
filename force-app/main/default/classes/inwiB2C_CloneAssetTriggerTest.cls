@isTest
public class inwiB2C_CloneAssetTriggerTest {

    public static testMethod void CloneAssetTriggerTest() {
    
		Test.startTest();
        List<inwiB2C_CloneAssetEvent__e> cloneAssetListPE = new List<inwiB2C_CloneAssetEvent__e>();
        inwiB2C_CloneAssetEvent__e cloneAssetObj = new inwiB2C_CloneAssetEvent__e();
        
        cloneAssetObj.inwiB2C_CustomerId__c = '0012500001XICSEAA5';
        cloneAssetObj.inwiB2C_assetId__c = '02i2500000JA0VAAA1';
        cloneAssetObj.inwiB2C_IdCreateContractBulk__c= 'a6s260000004sMAAAY';
        cloneAssetObj.inwiB2C_Icc__c = '123000000000004950';
        cloneAssetObj.inwiB2C_imsi__c = '123000000004950';
        cloneAssetObj.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        cloneAssetObj.inwiB2C_Mdn__c = '212648069979';
        cloneAssetObj.inwiB2C_ProfileId__c = '618';
        cloneAssetObj.inwiB2C_puk__c = '26364298';
        cloneAssetObj.inwiB2C_SimOCSID__c = 'IN1';
        cloneAssetObj.inwiB2C_MdnOCSID__c = 'IN1';
        cloneAssetObj.inwib2c_TypeCarteSIM__c = 'ESIM';
        
        cloneAssetListPE.add(cloneAssetObj);
        List<Database.SaveResult> results = EventBus.publish(cloneAssetListPE);
		Test.stopTest();

    
    
    }
    
}