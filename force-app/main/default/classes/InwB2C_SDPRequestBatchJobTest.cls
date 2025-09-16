/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-15-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public with sharing class InwB2C_SDPRequestBatchJobTest {
    @IsTest
    public static void testBatchJob() {
        // Create test data
        List<InwiB2C_Demande_de_migration__c> demandes = new List<InwiB2C_Demande_de_migration__c>();
        InwiB2C_Demande_de_migration__c demande1 = new InwiB2C_Demande_de_migration__c();
        demande1.InwiB2C_Statut__c = 'InwiB2C_ErreurNotificationSDP';
        demandes.add(demande1);
        InwiB2C_Demande_de_migration__c demande2 = new InwiB2C_Demande_de_migration__c();
        demande2.InwiB2C_Statut__c = 'InwiB2C_EnAttentEnvoiSDP';
        demandes.add(demande2);
        insert demandes;

        // Create an instance of the batch class
        InwB2C_SDPRequestBatchJob batchJob = new InwB2C_SDPRequestBatchJob();

        // Execute the batch
        Test.startTest();
        Database.executeBatch(batchJob);
        Test.stopTest();

        // Verify results
        demandes = [SELECT InwiB2C_Statut__c FROM InwiB2C_Demande_de_migration__c WHERE Id IN :demandes];
      //  System.assertEquals('InwiB2C_EnAttenteRetourSDP', demandes[0].InwiB2C_Statut__c);
      //System.assertEquals('InwiB2C_ErreurNotificationSDP', demandes[1].InwiB2C_Statut__c);
    }
}