@isTest
public class inwiB2C_CloneOrderTriggerTest {

    public static testMethod void CloneOrderTriggerTest() {
    
        /*Test.startTest();
        inwiB2C_CreateContractBulk__c testCCBulk = new inwiB2C_CreateContractBulk__c();
        testCCBulk.inwiB2C_Address__c = 'Address';
        testCCBulk.inwiB2C_BirthDate__c = Date.parse('01/01/1900');
        testCCBulk.inwiB2C_BusinessSegment__c = '';
        testCCBulk.inwiB2C_Canal__c = 'Dealer';
        testCCBulk.inwiB2C_City__c = 'Casablanca';
        testCCBulk.inwiB2C_CodeAgence__c = 'CPD01';
        testCCBulk.inwiB2C_CodeArticle__c = '000056826';
        testCCBulk.inwiB2C_CodeDistributeur__c = 'CPD01';
        testCCBulk.inwiB2C_ComplementAddress__c = '';
        testCCBulk.inwiB2C_CountryCode__c = 'MAR';
        testCCBulk.inwiB2C_FirstName__c = 'FirstName';
        testCCBulk.inwiB2C_Gender__c = 'M';
        testCCBulk.inwiB2C_Icc__c = '892128510050188115';
        testCCBulk.inwiB2C_imsi__c = '604050400041084';
        testCCBulk.inwiB2C_Ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        testCCBulk.inwiB2C_LastName__c = 'LastName';
        testCCBulk.inwiB2C_MdnDealer__c = '212648049518';
        testCCBulk.inwiB2C_Mdn__c = '212648058729';
        testCCBulk.inwiB2C_Ocerised__c = false;
        testCCBulk.inwiB2C_OcsId__c = 'IN2';
        testCCBulk.inwiB2C_PieceIdentite__c = 'CIN57098';
        testCCBulk.inwiB2C_PostCode__c = '20000';
        testCCBulk.inwiB2C_ProfileId__c = '618';
        testCCBulk.inwiB2C_Puk__c = '123456';
        testCCBulk.inwiB2C_SegmentLevel1__c = 'C';
        testCCBulk.inwiB2C_SegmentLevel2__c = '';
        testCCBulk.inwiB2C_State__c = '';
        testCCBulk.inwiB2C_Street__c = '';
        testCCBulk.inwiB2C_TypePieceIdentite__c = 'NID';
        testCCBulk.inwiB2C_User__c = '212648058729';
        testCCBulk.inwiB2C_uuid__c = '1234-5678-9012';
        testCCBulk.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Nouveau';
        insert testCCBulk;
        Id bacthId = Database.executeBatch(new InwiB2C_CreateContractBulkBatch() , 10 );
        Test.stopTest();*/
        Test.startTest();
        List<inwiB2C_CloneOrderEvent__e> cloneOrderListPE = new List<inwiB2C_CloneOrderEvent__e>();
        inwiB2C_CloneOrderEvent__e cloneOrderObj = new inwiB2C_CloneOrderEvent__e();
        
        cloneOrderObj.inwiB2C_CustomerId__c = '0012500001XICSEAA5';
        cloneOrderObj.inwiB2C_ContratId__c = '80025000007pTocAAE';
        cloneOrderObj.inwiB2C_IdCreateContractBulk__c= 'a6s260000004sMAAAY';
        cloneOrderObj.inwiB2C_Icc__c = '123000000000004950';
        cloneOrderObj.inwiB2C_imsi__c = '123000000004950';
        cloneOrderObj.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        cloneOrderObj.inwiB2C_Mdn__c = '212648069979';
        cloneOrderObj.inwiB2C_ProfileId__c = '618';
        cloneOrderObj.inwiB2C_puk__c = '26364298';
        cloneOrderObj.inwiB2C_SimOCSID__c = 'IN1';
        cloneOrderObj.inwiB2C_MdnOCSID__c = 'IN1';
        cloneOrderObj.inwiB2C_UpdateAttribute__c = true;
        cloneOrderObj.inwiB2C_CheckOut__c = true;
        
        cloneOrderListPE.add(cloneOrderObj);
        List<Database.SaveResult> results = EventBus.publish(cloneOrderListPE);
		Test.stopTest();

    
    
    }
    
}