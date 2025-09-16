@isTest
public class inwiB2C_BatchAnnulationDemandeDegTest {
    
    @testSetup
    static void setupData() {
        
        // Insert holiday records
        InwiB2C_Holidays__c holiday = new InwiB2C_Holidays__c(
            inwib2c_date__c = Date.today().addDays(1)
        );
        insert holiday;
        
        // Insert Account
        Account testAccount = new Account( Name = 'Test');

        insert testAccount;

        //Insert Subscription
        vlocity_cmt__Subscription__c testSubscription = new vlocity_cmt__Subscription__c (
            vlocity_cmt__AccountId__c = testAccount.id,
            Inwib2c_Num_ro_de_la_ligne__c = '0601010101',
            vlocity_cmt__SubscriptionNumber__c = '1'
        );

        insert testSubscription;
        
        vlocity_cmt__Subscription__c testSubscription2 = new vlocity_cmt__Subscription__c (
            vlocity_cmt__AccountId__c = testAccount.id,
            Inwib2c_Num_ro_de_la_ligne__c = '0601010101',
            vlocity_cmt__SubscriptionNumber__c = '2'
        );

        insert testSubscription2;
        
        // Cas 1
        InwiB2C_Commande_de_degroupage__c commandeDegCas1 = new InwiB2C_Commande_de_degroupage__c ();
        insert commandeDegCas1;
        
        INWIB2C_DEMANDE_DEGROUPAGE__c demandeCas1 = new INWIB2C_DEMANDE_DEGROUPAGE__c(
                InwiB2C_Commande_de_degroupage__c = commandeDegCas1.Id,
                InwiB2C_Statutdegroupage__c = 'SUS',
                InwiB2C_CodeMotifRejet__c = '63',
                InwiB2C_SEQ_NUM__c = 2,
                InwiB2C_NumeroDesignation__c = '0601010101'
            );
         insert demandeCas1;
        
        Test.setCreatedDate(demandeCas1.Id, DateTime.newInstance(2024,08,25));
                
        
        // Cas 2
        InwiB2C_Commande_de_degroupage__c commandeDegCas2 = new InwiB2C_Commande_de_degroupage__c ();
        insert commandeDegCas2;
        
        INWIB2C_DEMANDE_DEGROUPAGE__c demandeCas2SUS = new INWIB2C_DEMANDE_DEGROUPAGE__c(
                InwiB2C_Commande_de_degroupage__c = commandeDegCas2.Id,
                InwiB2C_Statutdegroupage__c = 'SUS',
                InwiB2C_SEQ_NUM__c = 2,
                InwiB2C_ndOperateur__c = '0601010101'
            );
         insert demandeCas2SUS;
        
        INWIB2C_DEMANDE_DEGROUPAGE__c demandeCas2SOU = new INWIB2C_DEMANDE_DEGROUPAGE__c(
                InwiB2C_Commande_de_degroupage__c = commandeDegCas2.Id,
                InwiB2C_Statutdegroupage__c = 'SOU',
                InwiB2C_SEQ_NUM__c = 1,
                InwiB2C_ndOperateur__c = '0601010101'
            );
         insert demandeCas2SOU;
        
        Test.setCreatedDate(demandeCas2SUS.Id, DateTime.newInstance(2024,08,01));
        Test.setCreatedDate(demandeCas2SOU.Id, DateTime.newInstance(2024,07,25));
        

        // Cas 3
        InwiB2C_Commande_de_degroupage__c commandeDegCas3 = new InwiB2C_Commande_de_degroupage__c ();
        insert commandeDegCas3;
        for (Integer i = 0; i < 3; i++) {
            INWIB2C_DEMANDE_DEGROUPAGE__c demande = new INWIB2C_DEMANDE_DEGROUPAGE__c(
                InwiB2C_Commande_de_degroupage__c = commandeDegCas3.Id,
                InwiB2C_Statutdegroupage__c = 'SUS',
                InwiB2C_CodeMotifRejet__c = '63',
                InwiB2C_Compteur_recyclage__c = 3,
                InwiB2C_SEQ_NUM__c = i+1,
                InwiB2C_ndOperateur__c = '0601010101'
            );
            insert demande;
        }
    }

    @isTest 
    static void testBatchExecution() {
        
        Integer batchSize = 200;
        inwiB2C_BatchAnnulationDemandeDeg batchInstance = new inwiB2C_BatchAnnulationDemandeDeg(batchSize);

        Test.startTest();
        Database.executeBatch(batchInstance, batchSize);
        Test.stopTest();

        List<INWIB2C_DEMANDE_DEGROUPAGE__c> processedDemandes = [SELECT Id FROM INWIB2C_DEMANDE_DEGROUPAGE__c WHERE InwiB2C_Statutdegroupage__c = 'ANN'];

        System.assertEquals(3, processedDemandes.size());
    }

    @isTest
    static void testGetWorkingDateAfterXDays() {
        DateTime inputDate = DateTime.now();
        Integer numberOfDays = 3;

        DateTime resultDate = inwiB2C_BatchAnnulationDemandeDeg.getWorkingDateAterXDays(inputDate, numberOfDays);

        System.assertNotEquals(inputDate.addDays(3), resultDate);
    }

}