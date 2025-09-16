@IsTest
private class InwiB2C_AddOptionsBashTest {

    @IsTest(seeAllData=true)
    public static void batchTest() {

         
        
        
        List<InwiB2C_AddOptionsTemp__c> listAddOption = new List<InwiB2C_AddOptionsTemp__c>();
        InwiB2C_AddOptionsTemp__c AddOption = new InwiB2C_AddOptionsTemp__c();
        AddOption.InwiB2C_Mdn__c = '212648113305';
        AddOption.InwiB2C_Erreure__c = '';
        AddOption.InwiB2C_Option__c = 'INWIB2C_MOB02_OFFERING_OIM13';
        AddOption.InwiB2C_Statut__c = 'New';
        AddOption.InwiB2C_Statut_Extraction__c = 'New';
        listAddOption.add(AddOption);
        
        
        insert listAddOption;        
        
       
        
        
        Test.startTest();
        Id batchId = Database.executeBatch(new InwiB2C_AddOptionsBash(), 2000);
        Test.stopTest();
        
    }
    
    
    
}