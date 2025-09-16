@IsTest
public class InwiB2C_ResiliationSuiteAnnulatTrigTest {
    @IsTest
    public static void test_ResiliationSuiteAnnulationTrigger() {
        // Création d’un compte de test
        Account testAccount = new Account(Name = 'TestAccount');
        insert testAccount;

        // Création d’un produit
        Product2 prod = new Product2(
            Name = 'Laptop X200',
            Family = 'Hardware',
            ProductCode = 'INWIB2C_OFFERING_SIM',
            vlocity_cmt__Type__c = 'Postpaye'
        );
        insert prod;

        // Récupération du Pricebook standard
        Id pricebookId = Test.getStandardPricebookId();

        // Ajout du produit au Pricebook standard
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 10000,
            IsActive = true
        );
        insert standardPrice;

        // Création d’un Pricebook personnalisé
        Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
        insert customPB;

        // Ajout du produit au Pricebook personnalisé
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id,
            Product2Id = prod.Id,
            UnitPrice = 12000,
            IsActive = true
        );
        insert customPrice;

        // Création d’un contrat
        Contract c = new Contract(AccountId = testAccount.Id, InwiB2C_statut_contrat__c = 'Initialise');
        insert c;

        // Création d’une commande
        Order newOrder = new Order(
            Pricebook2Id = customPB.Id,
            inwiB2C_Statut__c = 'inwiB2C_EnCours',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
            Status = 'Draft',
            AccountId = testAccount.Id,
            ContractId = c.Id
        );
        insert newOrder;

        vlocity_cmt__Subscription__c newSubsc1=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223344',Inwib2c_Num_ro_de_la_ligne__c='0611223344',Name='TEST',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
        Insert newSubsc1;

        // Création de l’événement à publier avec le champ inwiB2C_Subscription__c renseigné
        InwiB2C_ResiliationSuiteAnnulationPartag__e resilAnnulationPar = new InwiB2C_ResiliationSuiteAnnulationPartag__e();
        resilAnnulationPar.InwiB2C_OrderId__c = newOrder.Id;
        resilAnnulationPar.inwiB2C_Subscription__c = newSubsc1.Id;

        List<InwiB2C_ResiliationSuiteAnnulationPartag__e> resilAnnulationList = new List<InwiB2C_ResiliationSuiteAnnulationPartag__e>();
        resilAnnulationList.add(resilAnnulationPar);

        Test.startTest();
        List<Database.SaveResult> resultsResilAnnul = EventBus.publish(resilAnnulationList);
        Test.stopTest();

        // Optionnel : assert pour vérifier que tout s’est bien passé
        System.assertEquals(true, resultsResilAnnul[0].isSuccess());
    }
}