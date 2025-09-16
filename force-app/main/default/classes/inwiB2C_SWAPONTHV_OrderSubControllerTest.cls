@isTest
public class inwiB2C_SWAPONTHV_OrderSubControllerTest {
 @isTest
    static void setupTestData() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        // Création d'une OrderSubscription associée
       vlocity_cmt__Subscription__c testSubscription = new vlocity_cmt__Subscription__c(
            Name = 'Test Subscription'
        );
        InwiB2C_OrderSubscription__c orderSub = new InwiB2C_OrderSubscription__c(
            //AccountId = acc.Id,
           // Name = 'Test Order 1',
            inwiB2C_Subscription__c = testSubscription.Id
            //InwiB2C_Num_ro_de_la_commande__c = '12345',
           // InwiB2C_Canal_Order__c = 'Online',
            //InwiB2C_Type_commande__c = 'New',
            //InwiB2C_Type_acte_de_gestion__c = 'Test',
            //InwiB2C_Type_de_migration__c = 'PrePost'
        );
        insert orderSub;
        Test.startTest();
        List<InwiB2C_OrderSubscription__c> orders = inwiB2C_SWAPONTHV_OrderSubController.getAllOrders(testSubscription.Id);
        Test.stopTest();
    }
}