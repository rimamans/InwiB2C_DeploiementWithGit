@isTest
public class InwiB2C_ListViewWakilTest {
    @isTest
    static void testGetOrdersForUserQueue() {
        
        Account acc = new Account(Name = 'Test Account');
        insert acc;

       
        Order testOrder1 = new Order(
            AccountId = acc.Id,
            
            Name = 'Test Order 1',
            
            inwib2c_TypeDeLaCommande__c = 'inwib2c_Fidelisation',
            InwiB2C_Type_Offer__c = 'OfferType1',
            InwiB2C_Offre__c = 'Offer1',
            //inwiB2C_TypeDeMigration__c = 'InwiB2C_MigrationPrePostpayé',
            inwiB2C_Canal__c = 'Wakil',
            
            EffectiveDate = Date.today(), 
            Status = 'Draft' );
       	    insert testOrder1;

        
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + DateTime.now().getTime() + '@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        System.runAs(testUser) {
            
            Test.startTest();
            List<Order> orders = InwiB2C_ListViewWakil.getOrdersForUserQueue();
            Test.stopTest();

            
            System.debug('Test Order 1: ' + testOrder1);
			//List<Order> orders = InwiB2C_ListViewWakil.getOrdersForUserQueue();
			System.debug('Orders returned: ' + orders);

        }

    }
}