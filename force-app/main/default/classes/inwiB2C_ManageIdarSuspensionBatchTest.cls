@isTest
public class inwiB2C_ManageIdarSuspensionBatchTest {
    @isTest(SeeAllData=false)  
    public static void inwiB2C_ManageIdarSuspensionBatchTest() {
        //acyl
         Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
         Product2 prod2 = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'Postpaye');
            insert prod2;
            
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prod2.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            
            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod2.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;
                        // create contract
                 Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
                 insert c;
            order neworderFixe = new Order (Pricebook2Id = customPB.Id,inwiB2C_TypeDeMigration__c='InwiB2C_Migration_ADSL_Vers_IDAR', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id);
            insert neworderFixe;
        // Création d'un abonnement de test
        vlocity_cmt__Subscription__c subsc = new vlocity_cmt__Subscription__c ();
        subsc.Inwib2c_Num_ro_de_la_ligne__c = '212647858612';
        subsc.vlocity_cmt__SubscriptionNumber__c = '02i8M000000BIcZQAW';
        subsc.inwib2c_vip__c = false;
        subsc.inwiB2C_OptionIdentification__c = false;
        subsc.inwiB2C_managedInSF__c = true;
        subsc.InwiB2C_A_r_silier__c = false;
        subsc.Blacklist__c = false;
        insert subsc;
        
        
         // Création d'un produit et d'un asset pour tester la logique
        Product2 prod = new Product2(Name = 'FTTH', vlocity_cmt__Type__c = 'FTTH');
        insert prod;

        Asset asset = new Asset(Name = 'AssetTest', Product2Id = prod.Id, vlocity_cmt__SubscriptionId__c = subsc.Id);
        insert asset;


        // Cas 2 : ADSL vers IDAR
        InwiB2C_Order_SuspIdar__c lstRequestADSL = new InwiB2C_Order_SuspIdar__c();
        lstRequestADSL.InwiB2C_Statut__c = 'Ready';
        lstRequestADSL.InwiB2C_SubscriptionIdar__c = subsc.Id;
        lstRequestADSL.Name = 'testADSL';
        lstRequestADSL.InwiB2C_OrderFIXE__c = neworderFixe.Id;  // Remplacer par un ID valide
        insert lstRequestADSL;



        // Test du cas ADSL vers IDAR
        String typeDeMigrationADSL = 'InwiB2C_Migration_ADSL_Vers_IDAR';
        String orderIdADSL = lstRequestADSL.InwiB2C_OrderFIXE__c != null ? lstRequestADSL.InwiB2C_OrderFIXE__c : null;
        String stepADSL = 'EVENT_7';  // Étape correspondant au produit ADSL

        // Remplacement de la création de l'événement par la création d'un enregistrement de suivi commande fixe
        InwiB2C_Suivi_commande_fixe__c suiviADSL = new InwiB2C_Suivi_commande_fixe__c();
        suiviADSL.InwiB2C_step__c = stepADSL;
        suiviADSL.InwiB2C_orderId__c = orderIdADSL;
        insert suiviADSL;
        
        
  

        // Exécution du batch
        Test.startTest();
        inwiB2C_ManageIdarSuspensionBatch obj = new inwiB2C_ManageIdarSuspensionBatch();
        Database.executeBatch(obj);
        Test.stopTest();
    }
}