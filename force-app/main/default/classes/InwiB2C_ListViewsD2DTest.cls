/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-30-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class InwiB2C_ListViewsD2DTest {
    @isTest
    static void testGetOrdersForUserQueue() {
        // Création d'un utilisateur test
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Integration' LIMIT 1];
        Profile boProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice Distributeur D2D' LIMIT 1];

        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com.' + System.currentTimeMillis(),
            Alias = 'tuser',
            ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'Europe/Paris',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
		//bo user
		// Création d'un compte de l'agence
         RecordType accountPartenaireRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' and Name='Partenaire' LIMIT 1];

        Account testAccountagence = new Account(
            Name = 'Test AccountAgence',
            RecordTypeId = accountPartenaireRecordType.Id,
            InwiB2C_Queue__c='InwiB2C_Modif_Fiche_client'
        );
        insert testAccountagence;
        
        // Création d'un contact associé au compte créé
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Test',
            AccountId = testAccountagence.Id // Associer le contact dès sa création
        );
        insert testContact;
         User  BOUser = new User(
                    FirstName = 'BO',
                    LastName = 'CRC',
                    Email = 'BOCRC@example.com',
                    Username = 'BOCRC@example.com.' + System.currentTimeMillis(),
                    Alias = 'tuser',
                    ProfileId = boProfile.Id,
                    TimeZoneSidKey = 'Europe/Paris',
                    LocaleSidKey = 'en_US',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    ContactId =testContact.Id
                );
                insert BOUser;
        // Vérifier l'existence du RecordType pour Account
        RecordType accountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' and Name='Customer' LIMIT 1];
	// Création d'un compte avec le RecordTypeId
        Account testAccount = new Account(
            Name = 'Test Account',
            RecordTypeId = accountRecordType.Id
         
        );
        insert testAccount;
        
        
		
        // Rechercher une Queue existante
        Group existingQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' and name='Modif Fiche client' LIMIT 1];

        // Vérifier qu'une Queue a été trouvée
        System.assertNotEquals(null, existingQueue, 'Aucune Queue existante trouvée dans l’organisation.');

        // Attribution de l'utilisateur à la Queue dans un contexte admin
        System.runAs(new User(Id = UserInfo.getUserId())) { // Utilisateur admin
            GroupMember groupMember = new GroupMember(
                GroupId = existingQueue.Id,
                UserOrGroupId = testUser.Id
            );
            insert groupMember;
        }

        // Création de commandes associées à la Queue
        System.runAs(testUser) {
            Order testOrder1 = new Order(
                OwnerId = existingQueue.Id,
                AccountId = testAccount.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                inwiB2C_Statut__c = 'inwiB2C_Activee',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                InwiB2C_Type_Offer__c = 'Offre FTTH 200 Mbps',
                InwiB2C_Offre__c = 'FTTH',
                InwB2C_Statut_livraison_D2D__c='inwiB2C_Commande_livrée'
            );
            insert testOrder1;

            Order testOrder2 = new Order(
                OwnerId = existingQueue.Id,
                AccountId = testAccount.Id,
                Status = 'Draft',
                EffectiveDate = Date.today().addDays(-1),
                inwiB2C_Statut__c = 'inwiB2C_EnCours',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration',
                InwiB2C_Type_Offer__c = 'Offre FTTH 200 Mbps',
                InwiB2C_Offre__c = 'FTTH',
                InwB2C_Statut_livraison_D2D__c='Inwib2c_Commande_A_Livrer'
            );
            insert testOrder2;
            Order testOrder3 = new Order(
                OwnerId = existingQueue.Id,
                AccountId = testAccount.Id,
                Status = 'Draft',
                EffectiveDate = Date.today().addDays(-1),
                inwiB2C_Statut__c = 'inwiB2C_Paiement',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration',
                InwiB2C_Type_Offer__c = 'Offre FTTH 200 Mbps',
                InwiB2C_Offre__c = 'FTTH',
                InwB2C_Statut_livraison_D2D__c='Inwib2c_CommandeEnVerification'
            );
            insert testOrder3;
             Order testOrder4 = new Order(
                OwnerId = existingQueue.Id,
                AccountId = testAccount.Id,
                Status = 'Draft',
                EffectiveDate = Date.today().addDays(-1),
                inwiB2C_Statut__c = 'inwiB2C_Finalisation',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration',
                InwiB2C_Type_Offer__c = 'Offre FTTH 200 Mbps',
                InwiB2C_Offre__c = 'FTTH',
                InwB2C_Statut_livraison_D2D__c='Inwib2c_LivraisonAnnulée'
            );
            insert testOrder4;
              Order testOrder5 = new Order(
                OwnerId = existingQueue.Id,
                AccountId = testAccount.Id,
                Status = 'Draft',
                EffectiveDate = Date.today().addDays(-1),
                inwiB2C_Statut__c = 'inwiB2C_Activation',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration',
                InwiB2C_Type_Offer__c = 'Offre FTTH 200 Mbps',
                InwiB2C_Offre__c = 'FTTH'
            );
            insert testOrder5;
             Order testOrder6 = new Order(
                OwnerId = existingQueue.Id,
                AccountId = testAccount.Id,
                Status = 'Draft',
                EffectiveDate = Date.today().addDays(-1),
                inwiB2C_Statut__c = 'inwiB2C_Annulee',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration',
                InwiB2C_Type_Offer__c = 'Offre FTTH 200 Mbps',
                InwiB2C_Offre__c = 'FTTH'
            );
            insert testOrder6;
              Order testOrder7 = new Order(
                OwnerId = existingQueue.Id,
                AccountId = testAccount.Id,
                Status = 'Draft',
                EffectiveDate = Date.today().addDays(-1),
                inwiB2C_Statut__c = 'inwiB2C_Conforme',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                InwiB2C_Type_Offer__c = 'Offre FTTH 200 Mbps',
                InwiB2C_Offre__c = 'FTTH'
            );
            insert testOrder7;
              Order testOrder8 = new Order(
                OwnerId = existingQueue.Id,
                AccountId = testAccount.Id,
                Status = 'Draft',
                EffectiveDate = Date.today().addDays(-1),
                inwiB2C_Statut__c = 'En attente d\'approbation',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                InwiB2C_Type_Offer__c = 'Offre FTTH 200 Mbps',
                InwiB2C_Offre__c = 'FTTH'
            );
            insert testOrder8;
             Order testOrder9 = new Order(
                OwnerId = existingQueue.Id,
                AccountId = testAccount.Id,
                Status = 'Draft',
                EffectiveDate = Date.today().addDays(-1),
                inwiB2C_Statut__c = 'inwib2c_Validee_BO_135',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                InwiB2C_Type_Offer__c = 'Offre FTTH 200 Mbps',
                InwiB2C_Offre__c = 'FTTH'
            );
            
            insert testOrder9;
  
            
        }

        
        // Exécution de la méthode avec l'utilisateur test
        System.runAs(BOUser) {
            Test.startTest();
            List<Order> orders = InwiB2C_ListViewsD2D.getOrdersForUserQueue();
           
            List<Order> Allorders = InwiB2C_ListViewsD2D.getAllOrders();
            Test.stopTest();
            // Vérification des résultats
            //System.assertNotEquals(0, orders.size(), 'Les commandes doivent être récupérées.');
            //System.assertEquals(9, orders.size(), 'Deux commandes doivent être récupérées.');
        }

        
    }
  //H-M Methode test ALL statut Order
    @isTest
    static void testAllRemainingStatuts() {
        RecordType accRT = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Customer' LIMIT 1];
        Account acc = new Account(Name = 'Statut Account', RecordTypeId = accRT.Id);
         insert acc;

      List<String> statuts = new List<String>{
           'inwiB2C_NonConforme',
           'inwib2c_Validee_BO_135', 'inwiB2C_Refusee_BO_135',
           'En attente d\'approbation', 'inwiB2C_Recyclee', 'inwiB2C_A_Recycler'
        };

        List<Order> orders = new List<Order>();
        for (String statut : statuts) {
           orders.add(new Order(
              OwnerId = UserInfo.getUserId(),
              AccountId = acc.Id,
              Status = 'Draft',
              EffectiveDate = Date.today(),
              inwiB2C_Statut__c = statut,
              inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition'
          ));
       }
       insert orders;
  
       Test.startTest();
       List<Order> result = InwiB2C_ListViewsD2D.getAllOrders();
       Test.stopTest();

       System.assertEquals(statuts.size(), result.size(), 'Toutes les commandes avec les statuts restants doivent être retournées.');
}


  @isTest
   static void testLabelsMapCoverage() {
       RecordType accRT = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Customer' LIMIT 1];
       Account acc = new Account(Name = 'Label Coverage Account', RecordTypeId = accRT.Id);
      insert acc;

      Order o = new Order(
        OwnerId = UserInfo.getUserId(),
        AccountId = acc.Id,
        Status = 'Draft',
        EffectiveDate = Date.today(),
        inwiB2C_Statut__c = 'inwiB2C_Activee',
        inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration',
        InwB2C_Statut_livraison_D2D__c = 'Inwib2c_Commande_A_Livrer'
      );
      insert o;
  
      Test.startTest();
      List<Order> result = InwiB2C_ListViewsD2D.getAllOrders(); 
      Test.stopTest();
 
    System.assertNotEquals(0, result.size(), 'La commande doit être retournée');
}





}