@isTest
public class InwiB2C_IdentificationPDV48hBatchTest {
    @isTest(SeeAllData = true)
    public static void InwiB2C_IdentificationPDV48hBatchTest(){
        InwiB2C_Demande_IdentificationClient__c newIdentificationClient = new InwiB2C_Demande_IdentificationClient__c();
      
        newIdentificationClient.InwiB2C_Statut__c='InwiB2C_Encours';
        newIdentificationClient.InwiB2C_MDN__c='212611223355';
       // newIdentificationClient.InwiB2C_SubscriptionId__c=newSubsc.Id;
        insert newIdentificationClient;


        Id batchId = Database.executeBatch(new InwiB2C_IdentificationPDV48hBatch());
        
    }

}