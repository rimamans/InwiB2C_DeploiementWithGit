@IsTest
public without sharing class InwiB2C_VOCGetOrderMDNTest {

	@TestSetup
    static void setup() {
        // Product
        Product2 testProduct = new Product2(Name='Numéro Téléphone', ProductCode='INWIB2C_DEG01_OFFERING_MSISDN_STANDARD' );
        insert testProduct;
        
        Id pricebookId = Test.getStandardPricebookId();

        // PricebookEntry
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = testProduct.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
        insert customPB;
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = testProduct.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
            
                
        //Account
      	Account testAccount = new Account(Name = 'Test Account');
      	insert testAccount;
        
        //Order

        Order testOrder = new Order(
                //inwiB2C_Statut__c = 'inwiB2C_Activation',
                Pricebook2Id = customPB.Id,
                //inwiB2C_Statut__c = 'inwiB2C_EnCours',
                EffectiveDate = Date.today().addDays(-1),
                Status = 'Draft',
                AccountId = testAccount.Id
            );

       	insert testOrder;
        
        OrderItem testOrderItem = new OrderItem(
            PriceBookEntryId = customPrice.Id, 
            OrderId = testOrder.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            Quantity = 1,
            vlocity_cmt__JSONAttribute__c = '{"INWIB2C_ACAT_MOBILE":[{"attributeuniquecode__c":"INWIB2C_ATT_RT_MSISDN","attributeRunTimeInfo":{"value":"12345"}}]}'
        );
        insert testOrderItem;
        
        
       /*  List<OrderItem> mockOrderItems = new List<OrderItem>();

        for (Integer i=0 ; i < 201; i++){
            OrderItem OI = new OrderItem(
            PriceBookEntryId = customPrice.Id, 
            OrderId = testOrder.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            Quantity = 1,
                vlocity_cmt__JSONAttribute__c = '{"INWIB2C_ACAT_MOBILE":[{"attributeuniquecode__c":"INWIB2C_ATT_RT_MSISDN","attributeRunTimeInfo":{value:"12345"}]}'
        );
            mockOrderItems.add(OI);
       }
        insert mockOrderItems;*/
        
        
          List<Order> mockOrders = new List<Order>();

        for (Integer i=0 ; i < 201; i++){
            Order mockOrder = new Order(
                //inwiB2C_Statut__c = 'inwiB2C_Activee',
                EffectiveDate = Date.today().addDays(-1),
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
                Status = 'Draft',
                AccountId = testAccount.Id
            );
            mockOrders.add(mockOrder);
       }
        insert mockOrders;
    }
    
    @IsTest
    static void testGetOrderMDNAttribute() {
        List<Order> orders = [SELECT Id FROM Order LIMIT 1];
        List<String> orderIds = new List<String>{orders[0].Id};
        
        Test.startTest();
        List<String> results = InwiB2C_VOCGetOrderMDN.getOrderItemAttributes(orderIds);
        Test.stopTest();
        
        System.assertEquals(1, results.size());
        System.assertEquals('12345', results[0]);
    }
    
        @isTest
    static void BulkVerificationTest() {

        List<Order> recordsList = [Select id from Order];
        Integer listSize = recordsList.size();
        List<String> listInput = new List<String>();

        for( Order record : recordsList ){
            String input = record.Id ;
            listInput.add(input);
        }
               
        Test.startTest();
        List<String> result = InwiB2C_VOCGetOrderMDN.getOrderItemAttributes(listInput);
        Test.stopTest();

        // Assert 
        System.debug(result);
       // System.assertEquals(true, result[0]);
        System.assertEquals(listSize, result.size());

    }
    
    @IsTest
    static void testGetOrderItemAttributesWithInvalidOrderId() {
        List<String> invalidOrderIds = new List<String>{'000000000000000'};
        
        Test.startTest();
        List<String> invalidResults = InwiB2C_VOCGetOrderMDN.getOrderItemAttributes(invalidOrderIds);
        Test.stopTest();
        
        System.assertEquals(1, invalidResults.size());
        System.assertEquals('', invalidResults[0]);
    }
    
    @IsTest
    static void EmptyListTest() {
        List<String> emptyOrderIds = new List<String>();
        
        Test.startTest();
        List<String> emptyResults = InwiB2C_VOCGetOrderMDN.getOrderItemAttributes(emptyOrderIds);
        Test.stopTest();
        
        System.assertEquals(1, emptyResults.size());
        System.assertEquals('', emptyResults[0]);
    }
    
     @isTest
    static void CallFromFuturTest(){

        SystemFacade.isFuture = true;

         List<String> listInput = new List<String>();
            
        for (Integer i=0 ; i < 20 ; i++){
        	listInput.add('test,' + i);
        }
      
        Test.startTest();
        List<String> result = InwiB2C_VOCGetOrderMDN.getOrderItemAttributes(listInput);
        Test.stopTest();

        
        // Assert 
        System.debug(result);
        System.assertEquals('', result[0]);
        System.assertEquals(20, result.size());

    }
    
     @isTest
    static void CallFromBatchTest(){


        SystemFacade.isBatch = true;

         List<String> listInput = new List<String>();
            
        for (Integer i=0 ; i < 20 ; i++){
        	listInput.add('test,' + i);
        }
      
        Test.startTest();
        List<String> result = InwiB2C_VOCGetOrderMDN.getOrderItemAttributes(listInput);
        Test.stopTest();

        
        // Assert 
        System.debug(result);
        System.assertEquals('', result[0]);
        System.assertEquals(20, result.size());

    }

}