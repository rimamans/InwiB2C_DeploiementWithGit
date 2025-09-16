@isTest
public with sharing class inwiB2C_MandatDegroupageFTTTest {

    @isTest
    public static void testInwiB2C_MandatDegroupageFTTHController() {
        // Création des données de test
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Order testOrder = new Order(
            inwiB2C_Statut__c = 'inwiB2C_EnCours',
            Status = 'Draft',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = '	inwiB2C_Acquisition',
            AccountId = acc.Id
        );
        insert testOrder;

        System.debug('Created Order ID: ' + testOrder.Id);

        // Simulation du contexte de page
        PageReference pageRef = Page.InwiB2C_MandatDegroupage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('orderid', testOrder.Id);

        // Initialisation des maps pour simuler l'appel à l'Integration Procedure
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        // Ajout des paramètres d'entrée
        inputMap.put('orderid', testOrder.Id);

        // Mock de l'Integration Procedure Service
        Test.startTest();

        // Création d'une instance du contrôleur
        inwiB2C_MandatDegroupageFTTHController controller = new inwiB2C_MandatDegroupageFTTHController();

        // Simulation de l'appel à l'Integration Procedure
        outMap = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(
            'inwib2c_GetInfoDocMandatDegroupageFTTH', inputMap, options
        );

        Test.stopTest();

        // Vérifications
        System.assertNotEquals(controller.output, null, 'L\'output ne doit pas être null');
        System.assertNotEquals(controller.keys, null, 'Les clés de sortie ne doivent pas être nulles');
        System.debug('Output: ' + controller.output);
        System.debug('Keys: ' + controller.keys);
    }
}