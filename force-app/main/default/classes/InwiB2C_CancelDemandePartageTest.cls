@isTest
private class InwiB2C_CancelDemandePartageTest {

    @testSetup
    static void setupTestData() {

        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;

        Product2 prod = new Product2(Name = 'Laptop X200',
                                     Family = 'Hardware',
                                     ProductCode='INWIB2C_OFFERING_SIM'
                                   );
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;

        order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder;

        InwiB2C_Commande_de_partage__c  commandePartage = new InwiB2C_Commande_de_partage__c (
            InwiB2C_Order__c = neworder.Id
        );
        insert commandePartage;


        // Creating test data for InwiB2C_demande_partage__c
        InwiB2C_demande_partage__c demande = new InwiB2C_demande_partage__c(
            InwiB2C_Account__c = testAccount.Id, 
            InwiB2C_Commande_de_partage__c = commandePartage.Id,
            InwiB2C_Statut_demande__c = 'NOU'
        );
        insert demande;
       
    }
    
    @isTest
    static void testGetDemandeById() {
        // Retrieve test record dynamically
        InwiB2C_demande_partage__c demande = [SELECT Id FROM InwiB2C_demande_partage__c where InwiB2C_Statut_demande__c = 'NOU' LIMIT 1];
        
        Map<String, Object> inputMap = new Map<String, Object>{'demandeId' => demande.Id};
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Test.startTest();
        InwiB2C_CancelDemandePartage canceldemandePartage = new InwiB2C_CancelDemandePartage(); 
        canceldemandePartage.invokeMethod('getDemandeById',inputMap, outMap, options);
        Test.stopTest();
        
    }
    
    @isTest
    static void testCancelDemande() {
        // Retrieve test record dynamically
        InwiB2C_demande_partage__c demande = [SELECT Id FROM InwiB2C_demande_partage__c LIMIT 1];

        Map<String, Object> inputMap = new Map<String, Object>{
            'OrchPlanId' => 'a38Ad000000xkGXIAY',
            'orderId' => '801Ad00000eZxxRIAS',
            'demandeId' => demande.Id,
            'CommPartage' => 'aEIAd0000015llhOAA',
            'motifAnnulation' => 'CNN',
            'requestId' => 'W00000000',
            'lineId' => '234'
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Test.startTest();
        InwiB2C_CancelDemandePartage canceldemandePartage = new InwiB2C_CancelDemandePartage();
        canceldemandePartage.invokeMethod('CancelDemande',inputMap, outMap, options);
        Test.stopTest();

    }
    
    @isTest
    static void testCancelDemandeAnnulee3Susp() {
        // Retrieve test record dynamically
        Account testAccount = new Account(Name = 'Test Account' , inwiB2C_numero_de_designation__c = '0529111637');  
        insert testAccount;
        Order testOrder =new Order(
            vlocity_cmt__DefaultServiceAccountId__c = testAccount.Id,
            inwiB2C_Statut__c = 'inwiB2C_Activation',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert testOrder;
        InwiB2C_Commande_de_partage__c testCommandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c = testOrder.Id);
        insert testCommandePartage;
        inwiB2C_demande_partage__c testDemande= new inwiB2C_demande_partage__c(
            InwiB2C_Statut_demande__c = 'Annulee_3_Susp',
            InwiB2C_Commande_de_partage__c = testCommandePartage.Id,
            InwiB2C_Sequence__c = 1,
            InwiB2C_Operateur_Infrastructure__c ='ORANGE',
            InwiB2C_NumeroDesignation__c ='0788990055',
            InwiB2C_Nationalid__c ='CIN1234',
            InwiB2C_nd_Attribut__c ='0529111637'
        );
        insert testDemande;
        Map<String, Object> inputMap = new Map<String, Object>{
            'OrchPlanId' => 'a38Ad000000xkGXIAY',
            'orderId' => testOrder.Id,
            'demandeId' => testDemande.Id,
            'CommPartage' => testCommandePartage.Id,
            'motifAnnulation' => 'CNN',
            'requestId' => 'W00000000',
            'lineId' => '234'
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Test.startTest();
        InwiB2C_CancelDemandePartage canceldemandePartage = new InwiB2C_CancelDemandePartage();
        canceldemandePartage.invokeMethod('CancelDemande',inputMap, outMap, options);
        Test.stopTest();

    }
}