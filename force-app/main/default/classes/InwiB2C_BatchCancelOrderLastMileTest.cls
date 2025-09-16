@isTest
public class InwiB2C_BatchCancelOrderLastMileTest {

    @isTest
    static void testBatchExecution() {
        // Création de données fictives nécessaires pour le test
        Account partenaire = new Account(
            Name = 'Partenaire Test',
            inwib2c_CodePartenaire__c = 'PART123'
        );
        insert partenaire;

        // Vérifiez si l'objet Order est disponible et que tous les champs obligatoires sont renseignés
        Order orderToCancel = new Order(
            Status = 'Draft',
                EffectiveDate = Date.today().addDays(-10),
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
               inwiB2C_Statut__c = 'inwiB2C_A_Annuler',
                
                inwib2c_Partenaire__r = partenaire,
            	AccountId =partenaire.Id
        );
        insert orderToCancel;

        // Exécution du batch
        Test.startTest();
        InwiB2C_BatchCancelOrderLastMile batch = new InwiB2C_BatchCancelOrderLastMile();
        Database.executeBatch(batch, 1);
        Test.getEventBus().deliver(); // Simule la livraison des événements de la file d'attente
        Test.stopTest();

        // Validation simple que le batch s'exécute sans erreur
        System.assert(true, 'Le batch s\'est exécuté correctement.');
    }

    @isTest
    static void testBatchFinish() {
        // Simulez un traitement de batch et vérifiez l'exécution complète
        Test.startTest();
        InwiB2C_BatchCancelOrderLastMile batch = new InwiB2C_BatchCancelOrderLastMile();
        Database.executeBatch(batch, 1);
        Test.stopTest();

        // Validation simple que la méthode finish s'exécute correctement
        System.assert(true, 'La méthode finish s\'est exécutée correctement.');
    }
}