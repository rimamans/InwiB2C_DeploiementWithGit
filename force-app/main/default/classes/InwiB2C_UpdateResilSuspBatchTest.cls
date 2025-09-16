@isTest
public class InwiB2C_UpdateResilSuspBatchTest {
    
    private static List<InwiB2C_Demande_de_resiliation__c> createTestRecords() {
        List<InwiB2C_Demande_de_resiliation__c> demandes = new List<InwiB2C_Demande_de_resiliation__c>();
        
        vlocity_cmt__Subscription__c sub = new vlocity_cmt__Subscription__c(
        Name = 'Test Subscription',
        vlocity_cmt__Status__c = 'Active',
        vlocity_cmt__SubscriptionNumber__c = 'SUB-TEST-001'
    );
    insert sub;
        
        // En attente de suspension avec date = today
        demandes.add(new InwiB2C_Demande_de_resiliation__c(
            InwiB2C_Statut_Resil__c = 'En attente de suspension',
        inwiB2C_expectedSuspendDate__c = System.today(),
        InwiB2C_Subscription__c = sub.Id
            ));
        
        // En attente de résiliation avec date = today
        demandes.add(new InwiB2C_Demande_de_resiliation__c(
            InwiB2C_Statut_Resil__c = 'En attente de résiliation',
        inwiB2C_expectedDisconnectDate__c = System.today(),
        InwiB2C_Subscription__c = sub.Id
            ));
        
        // En attente de suspension avec date future
        demandes.add(new InwiB2C_Demande_de_resiliation__c(
            InwiB2C_Statut_Resil__c = 'En attente de suspension',
        inwiB2C_expectedSuspendDate__c = System.today().addDays(5),
        InwiB2C_Subscription__c = sub.Id
            ));
        
        // En attente de résiliation avec date future
        demandes.add(new InwiB2C_Demande_de_resiliation__c(
            InwiB2C_Statut_Resil__c = 'En attente de résiliation',
        inwiB2C_expectedDisconnectDate__c = System.today().addDays(5),
        InwiB2C_Subscription__c = sub.Id
            ));
        
        insert demandes;
        return demandes;
    }
    
    @isTest
    static void testBatchExecution() {
        // creation des enregistrements
        List<InwiB2C_Demande_de_resiliation__c> demandes = createTestRecords();
        
        // execution du batch
        Test.startTest();
        Database.executeBatch(new InwiB2C_UpdateResiliationSuspensionBatch(), 200);
        Test.stopTest();
        
        List<InwiB2C_Demande_de_resiliation__c> results = [
            SELECT Id, Name, InwiB2C_Statut_Resil__c,
                   inwiB2C_expectedDisconnectDate__c,
                   inwiB2C_expectedSuspendDate__c
            FROM InwiB2C_Demande_de_resiliation__c
            ORDER BY Name
        ];
        
        System.assertEquals('En cours de suspension', results[0].InwiB2C_Statut_Resil__c,
        'Le record "En attente de suspension" avec date today doit passer en "En cours de suspension".');
        
        System.assertEquals('En cours de résiliation', results[1].InwiB2C_Statut_Resil__c,
        'Le record "En attente de résiliation" avec date today doit passer en "En cours de résiliation".');
        
        System.assertEquals('En attente de suspension', results[2].InwiB2C_Statut_Resil__c,
        'Le record avec une date future pour suspension ne doit pas changer.');
        
        System.assertEquals('En attente de résiliation', results[3].InwiB2C_Statut_Resil__c,
        'Le record avec une date future pour résiliation ne doit pas changer.');
    }
}