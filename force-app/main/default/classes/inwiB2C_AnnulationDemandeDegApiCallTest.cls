@isTest
public class inwiB2C_AnnulationDemandeDegApiCallTest {
    
     @isTest
    static void testQueueableExecution() {

       InwiB2C_Commande_de_degroupage__c commandeDegroupage = new InwiB2C_Commande_de_degroupage__c();
       insert commandeDegroupage;
        
        List<INWIB2C_DEMANDE_DEGROUPAGE__c> records = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
        INWIB2C_DEMANDE_DEGROUPAGE__c record1 = new INWIB2C_DEMANDE_DEGROUPAGE__c(
            InwiB2C_typeCommande__c = 'NA',
            InwiB2C_Commande_de_degroupage__c = commandeDegroupage.Name,
            InwiB2C_codeOpDemandeur__c = 'WNA'
        );
        records.add(record1);

        insert records;

        Test.startTest();

        inwiB2C_AnnulationDemandeDegApiCall queueableJob = new inwiB2C_AnnulationDemandeDegApiCall(records);

        System.enqueueJob(queueableJob);

        Test.stopTest();

        records = [SELECT InwiB2C_retour_annulation_IAM__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c WHERE Id IN :records];

        for (INWIB2C_DEMANDE_DEGROUPAGE__c record : records) {
            System.assertEquals(true, record.InwiB2C_retour_annulation_IAM__c, '');
        }
    }


}