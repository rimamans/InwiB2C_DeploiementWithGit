@IsTest
public class InwiB2C_CreateOrderCH_TechnoBatchTest {
  @IsTest
      static void testBatchJob() {
        // Create test data
     
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode = 'INWIB2C_OFFERING_SIM');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
        insert customPB;

        // create contract
        Contract c = new Contract(AccountId = testAccount.Id, InwiB2C_statut_contrat__c = 'Initialise');
        insert c;
       
        // Create a test Order
        Order testOrder = new Order(Pricebook2Id = customPB.Id, inwiB2C_Statut__c = 'inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId = testAccount.Id, contractId = c.id);
        insert testOrder;
        System.debug('testOrder.Id: ' + testOrder.Id); 

        Account agence = new Account(Name='agence');
        insert agence;

      // Create a test Demande_degroupage
         INWIB2C_DEMANDE_DEGROUPAGE__c testDemande = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_NumeroDesignation__c='14',InwiB2C_Agence__c=agence.Id,InwiB2C_numeroContact__c='prenom',InwiB2C_Statutdegroupage__c='ACC',InwiB2C_dateOrdre__c=Date.today(),InwiB2C_DEGROUPAGE_NUM__c=70000016);
        insert testDemande;   
    
        List<InwiB2C_changement_technologie_automa__c> testData = new List<InwiB2C_changement_technologie_automa__c>();
        System.debug('order '+testOrder );
        for (Integer i = 0; i < 5; i++) {
            InwiB2C_changement_technologie_automa__c record = new InwiB2C_changement_technologie_automa__c(
                InwiB2C_Statut__c = 'In Progres',
                InwiB2C_Order__c = testOrder.Id,
                InwiB2C_Demande_degroupage__c = testDemande.Id,
                InwiB2C_Attribut_technologie_source__c = 'Source ' + i,
                InwiB2C_Attribut_technologie_cible__c = 'Target ' + i,
                InwiB2C_Nouvelle_Commande__c = testOrder.Id
            );
            testData.add(record);
        }
        insert testData;

          // Start the batch job
        Test.startTest();
        Database.executeBatch(new InwiB2C_CreateOrderCH_TechnlogieBatch(), 200);
        Test.stopTest();

        // Assert records were processed
        List<InwiB2C_changement_technologie_automa__c> updatedRecords = [SELECT Id, InwiB2C_Statut__c FROM InwiB2C_changement_technologie_automa__c WHERE  Id IN :testData];
        System.assertEquals(5, updatedRecords.size());
         for (InwiB2C_changement_technologie_automa__c record : updatedRecords) {
             System.debug('status ' + record.InwiB2C_Statut__c);
            System.assertEquals('Running', record.InwiB2C_Statut__c);
        }

    }
}