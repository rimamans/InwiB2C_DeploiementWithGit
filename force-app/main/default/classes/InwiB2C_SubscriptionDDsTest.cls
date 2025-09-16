/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class InwiB2C_SubscriptionDDsTest {

    @isTest
    static void getSubscriptionDDsTest() {
        String uniqueId = 'test' + String.valueOf(DateTime.now().getTime()) + String.valueOf(Math.random()).substring(2, 8);
        uniqueId.substring(2,12);
        vlocity_cmt__Subscription__c sub = new vlocity_cmt__Subscription__c(Inwib2c_Num_ro_de_la_ligne__c='2126678909',vlocity_cmt__SubscriptionNumber__c=uniqueId);
        insert sub;

        Product2 product = new Product2(Name='Offre TicTac Sim+Termina', ProductCode='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL');
        insert product;
        Product2 product2 = new Product2(Name='Numéro Téléphone',ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
        insert product2;
        Account acc = new Account(Name='test porta Acc');
        insert acc;
        Id pricebookId = '01s4K000001FA2rQAG';
        Id pricebookId2 = '01s4K000001FA2rQAG';
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = product.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = product.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        Order order = new Order(Pricebook2Id = customPB.Id, Name='test order',inwiB2C_Statut__c ='inwiB2C_EnCours',inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',inwiB2C_Canal__c='inwiB2C_Eshop',EffectiveDate = Date.today().addDays(-1), Status = 'Draft',inwib2c_ModeDeLivraison__c='inwiB2C_Domicile', AccountId =acc.Id);
        insert order;

        inwiB2C_OrderSubscription__c orderSub = new inwiB2C_OrderSubscription__c(
            inwiB2C_Order__c = order.Id,
            inwiB2C_Subscription__c = sub.Id
        );
        insert orderSub;

        Account client = new Account(Name='client');
        insert client;
        Account agence = new Account(Name='agence');
        insert agence;
        Account site = new Account(Name='site');
        insert site;
        INWIB2C_DEMANDE_DEGROUPAGE__c demande = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_NumeroDesignation__c='14',InwiB2C_Agence__c=agence.Id,InwiB2C_numeroContact__c='prenom',InwiB2C_Statutdegroupage__c='ACC',InwiB2C_dateOrdre__c=Date.newInstance(2023, 04, 24),InwiB2C_DEGROUPAGE_NUM__c=70000016, InwiB2C_Order__c=order.Id);
        insert demande;
        
        InwiB2C_SubscriptionDDs.getSubscriptionDDs(sub.Id);

    }
    static void getOrderDDsTest() {
        String uniqueId = 'test' + String.valueOf(DateTime.now().getTime()) + String.valueOf(Math.random()).substring(2, 8);
        uniqueId.substring(2,12);
        vlocity_cmt__Subscription__c sub = new vlocity_cmt__Subscription__c(Inwib2c_Num_ro_de_la_ligne__c='2126678909',vlocity_cmt__SubscriptionNumber__c=uniqueId);
        insert sub;

        Product2 product = new Product2(Name='Offre TicTac Sim+Termina', ProductCode='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL');
        insert product;
        Product2 product2 = new Product2(Name='Numéro Téléphone',ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
        insert product2;
        Account acc = new Account(Name='test porta Acc');
        insert acc;
        Id pricebookId = '01s4K000001FA2rQAG';
        Id pricebookId2 = '01s4K000001FA2rQAG';
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = product.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = product.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        Order order = new Order(Pricebook2Id = customPB.Id, Name='test order',inwiB2C_Statut__c ='inwiB2C_EnCours',inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',inwiB2C_Canal__c='inwiB2C_Eshop',EffectiveDate = Date.today().addDays(-1), Status = 'Draft',inwib2c_ModeDeLivraison__c='inwiB2C_Domicile', AccountId =acc.Id);
        insert order;

        inwiB2C_OrderSubscription__c orderSub = new inwiB2C_OrderSubscription__c(
            inwiB2C_Order__c = order.Id,
            inwiB2C_Subscription__c = sub.Id
        );
        insert orderSub;

        Account client = new Account(Name='client');
        insert client;
        Account agence = new Account(Name='agence');
        insert agence;
        Account site = new Account(Name='site');
        insert site;
        INWIB2C_DEMANDE_DEGROUPAGE__c demande = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_NumeroDesignation__c='14',InwiB2C_Agence__c=agence.Id,InwiB2C_numeroContact__c='prenom',InwiB2C_Statutdegroupage__c='ACC',InwiB2C_dateOrdre__c=Date.newInstance(2023, 04, 24),InwiB2C_DEGROUPAGE_NUM__c=70000016, InwiB2C_Order__c=order.Id);
        insert demande;
        
        InwiB2C_SubscriptionDDs.getOrderDDs(order.Id);

    }
    static void getAccountDDsTest() {
        String uniqueId = 'test' + String.valueOf(DateTime.now().getTime()) + String.valueOf(Math.random()).substring(2, 8);
        uniqueId.substring(2,12);
        vlocity_cmt__Subscription__c sub = new vlocity_cmt__Subscription__c(Inwib2c_Num_ro_de_la_ligne__c='2126678909',vlocity_cmt__SubscriptionNumber__c=uniqueId);
        insert sub;

        Product2 product = new Product2(Name='Offre TicTac Sim+Termina', ProductCode='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL');
        insert product;
        Product2 product2 = new Product2(Name='Numéro Téléphone',ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
        insert product2;
        Account acc = new Account(Name='test porta Acc');
        insert acc;
        Id pricebookId = '01s4K000001FA2rQAG';
        Id pricebookId2 = '01s4K000001FA2rQAG';
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = product.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = product.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        Order order = new Order(Pricebook2Id = customPB.Id, Name='test order',inwiB2C_Statut__c ='inwiB2C_EnCours',inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',inwiB2C_Canal__c='inwiB2C_Eshop',EffectiveDate = Date.today().addDays(-1), Status = 'Draft',inwib2c_ModeDeLivraison__c='inwiB2C_Domicile', AccountId =acc.Id);
        insert order;

        inwiB2C_OrderSubscription__c orderSub = new inwiB2C_OrderSubscription__c(
            inwiB2C_Order__c = order.Id,
            inwiB2C_Subscription__c = sub.Id
        );
        insert orderSub;

        Account client = new Account(Name='client');
        insert client;
        Account agence = new Account(Name='agence');
        insert agence;
        Account site = new Account(Name='site');
        insert site;
        INWIB2C_DEMANDE_DEGROUPAGE__c demande = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_NumeroDesignation__c='14',InwiB2C_Agence__c=agence.Id,InwiB2C_numeroContact__c='prenom',InwiB2C_Statutdegroupage__c='ACC',InwiB2C_dateOrdre__c=Date.newInstance(2023, 04, 24),InwiB2C_DEGROUPAGE_NUM__c=70000016, InwiB2C_Order__c=order.Id);
        insert demande;
        
        InwiB2C_SubscriptionDDs.getAccountDDs(client.Id);

    }
}