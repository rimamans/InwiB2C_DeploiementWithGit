@isTest 
public with sharing class inwiB2C_Wakil_OrderControllerTest {
    @isTest 
    static void testGetOrderList() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Order testOrder = new Order(
            AccountId = acc.Id,
            Name = 'Test Order 1',
            
            inwib2c_TypeDeLaCommande__c = 'inwib2c_Fidelisation',
            InwiB2C_Type_Offer__c = 'OfferType1',
            InwiB2C_Offre__c = 'Offer1',
            inwiB2C_Canal__c = 'Wakil',
            
            EffectiveDate = Date.today(), 
            Status = 'Draft' );
        insert testOrder;

          
        Test.startTest();
        List<Order> orders = InwiB2C_Wakil_OrderController.getOrderList(acc.Id);
        Test.stopTest();

    }
}