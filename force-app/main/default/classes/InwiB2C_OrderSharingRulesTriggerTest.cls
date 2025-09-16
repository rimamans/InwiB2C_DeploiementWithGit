/**
 * @description       : Classe de test pour InwiB2C_OrderSharingRulesTrigger
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
@isTest
public class InwiB2C_OrderSharingRulesTriggerTest {

    @isTest
    public static void OrderSharingRulesTriggerTest() {
        // Création d'un utilisateur et utilisation de System.runAs
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Username = 'testuser' + System.currentTimeMillis() + '@example.com',
            Email = 'testuser' + System.currentTimeMillis() + '@example.com',
            Alias = 'tuser',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        System.runAs(testUser) {
            // Étape création d'un compte pour les commandes
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;

  
            List<Order> orders = new List<Order>{
                new Order(
                    inwiB2C_Statut__c = 'inwiB2C_EnCours',
                    EffectiveDate = Date.today().addDays(-1),
                    inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
                    Status = 'Draft',
                    AccountId = testAccount.Id
                ),
                new Order(
                    inwiB2C_Statut__c = 'inwiB2C_EnCours',
                    EffectiveDate = Date.today().addDays(-1),
                    inwiB2C_Canal__c = 'inwiB2C_Eshop',
                    inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                    Status = 'Draft',
                    AccountId = testAccount.Id
                ),
                new Order(
                    inwiB2C_Statut__c = 'inwiB2C_EnCours',
                    EffectiveDate = Date.today().addDays(-1),
                    inwiB2C_Canal__c = 'inwiB2C_D2D',
                    inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                    Status = 'Draft',
                    AccountId = testAccount.Id
                ),
               
                new Order(
                    inwiB2C_Statut__c = 'inwiB2C_EnCours',
                    EffectiveDate = Date.today().addDays(-1),
                    inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                    Status = 'Draft',
                    AccountId = testAccount.Id
                ),
                
                new Order(
                    inwiB2C_Statut__c = 'inwiB2C_Annulee',
                    EffectiveDate = Date.today().addDays(-1),
                    inwiB2C_Canal__c = 'inwiB2C_Eshop',
                    inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                    Status = 'Draft',
                    AccountId = testAccount.Id
                )
            };

            Test.startTest();
            insert orders;

         
            for (Order ord : orders) {
                if (ord.inwiB2C_Statut__c == 'inwiB2C_EnCours') {
                    ord.inwiB2C_Statut__c = 'inwiB2C_Activation';
                }
            }
            update orders;
            Test.stopTest();

      
            System.assertEquals('inwiB2C_Modification', orders[0].inwib2c_TypeDeLaCommande__c, 'Type de commande incorrect pour la commande 1');
            System.assertEquals('inwiB2C_Acquisition', orders[1].inwib2c_TypeDeLaCommande__c, 'Type de commande incorrect pour la commande 2');
            System.assertEquals('inwiB2C_Acquisition', orders[2].inwib2c_TypeDeLaCommande__c, 'Type de commande incorrect pour la commande 3');

           
            System.assertEquals('inwiB2C_Acquisition', orders[3].inwib2c_TypeDeLaCommande__c, 'Commande sans canal non gérée correctement');
            System.assertEquals('inwiB2C_Acquisition', orders[4].inwib2c_TypeDeLaCommande__c, 'Commande avec statut annulé non gérée correctement');
        }
    }
}