@isTest
public class inwiB2C_CTControlTriggerTest {
    public static testMethod void testTrigger() {
        String lignes='[{"ND":"0529154145","RecordId":"a9VVd0000003xgYMAQ"},{"ND":"0526467367","RecordId":"a9VVd0000003xgrMAA"}]';
        
        InwiB2C_Controle_CT_Massif__e CTControlEvent = new InwiB2C_Controle_CT_Massif__e(
        InwiB2C_fileSize__c=20,InwiB2C_documentId__c='test',InwiB2C_Counter__c=1,InwiB2C_demandesList__c=lignes);
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(CTControlEvent);
        Test.stopTest();
        
    }

}