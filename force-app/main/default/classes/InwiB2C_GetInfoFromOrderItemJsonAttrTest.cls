/**
 * @description       : Classe de test pour InwiB2C_GetInfoFromOrderItemJsonAttr
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-22-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class InwiB2C_GetInfoFromOrderItemJsonAttrTest {

    @testSetup
    static void setupTestData() {
        // Création d'un compte de test
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        Product2 testProduct = new Product2(
            Name = 'Terminal',
            ProductCode = 'P001',
            IsActive = true
        );
        insert testProduct;

        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = testProduct.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = testProduct.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Order testOrder = new Order(
            Name = 'Test Order',
            Status = 'Draft',
            Pricebook2Id = customPB.Id,
            AccountId = testAccount.Id,
            EffectiveDate = System.today()
        );
        insert testOrder;

        OrderItem testOrderItem1 = new OrderItem(
            OrderId = testOrder.Id,
            PriceBookEntryId=customPrice.Id,
            UnitPrice = 100,
            Quantity = 1,
            vlocity_cmt__JSONAttribute__c = '{"INWIB2C_ATT_RT_MODELE":"CodeArticle1"}'
        );
        insert testOrderItem1;

        OrderItem testOrderItem2 = new OrderItem(
            OrderId = testOrder.Id,
            PriceBookEntryId=customPrice.Id,
            UnitPrice = 200,
            Quantity = 1,
            vlocity_cmt__JSONAttribute__c = '{"INWIB2C_ATT_RT_MODELE":"CodeArticle2"}'
        );
        insert testOrderItem2;
    }

    @isTest
    static void testGetInfoByOrderIdSuccess() {
        Order testOrder = [SELECT Id FROM Order LIMIT 1];

        List<Id> orderIds = new List<Id>{testOrder.Id};
        List<String> result = InwiB2C_GetInfoFromOrderItemJsonAttr.getInfoByOrderId(orderIds);

        System.assertNotEquals(null, result, 'Le résultat ne doit pas être null.');
      
    }

    @isTest
    static void testGetInfoByOrderIdEmptyList() {
        try {
            InwiB2C_GetInfoFromOrderItemJsonAttr.getInfoByOrderId(new List<Id>());
            System.assert(false, 'Une exception doit être levée pour une liste vide.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('OrderId list cannot be null or empty.', e.getMessage(), 'Le message d\'erreur doit être correct.');
        }
    }

    @isTest
    static void testGetInfoByOrderIdNullList() {
        try {
            InwiB2C_GetInfoFromOrderItemJsonAttr.getInfoByOrderId(null);
            System.assert(false, 'Une exception doit être levée pour une liste nulle.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('OrderId list cannot be null or empty.', e.getMessage(), 'Le message d\'erreur doit être correct.');
        }
    }

    @isTest
    static void testGetInfoByOrderIdNoResults() {
        Account testAccount = new Account(
            Name = 'Test Account 2'
        );
        insert testAccount;

        Order emptyOrder = new Order(
            Name = 'Empty Order',
            Status = 'Draft',
            AccountId = testAccount.Id,
            EffectiveDate = System.today()
        );
        insert emptyOrder;

        List<Id> orderIds = new List<Id>{emptyOrder.Id};
        List<String> result = InwiB2C_GetInfoFromOrderItemJsonAttr.getInfoByOrderId(orderIds);

        System.assertNotEquals(null, result, 'Le résultat ne doit pas être null.');
        System.assertEquals(0, result.size(), 'Le résultat doit être une liste vide.');
    }
}