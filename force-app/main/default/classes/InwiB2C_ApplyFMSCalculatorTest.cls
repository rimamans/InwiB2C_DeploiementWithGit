@isTest
public class InwiB2C_ApplyFMSCalculatorTest {

    @isTest
    static void testApplyFMS_Success(){
        
        Id standardPricebookId  = Test.getStandardPricebookId();
        
        Product2  prod2 = new Product2 (
        Name = 'Test product',
        IsActive = true
        );
        insert prod2;
        
        PricebookEntry pricebook = new PricebookEntry (
        Pricebook2Id = standardPricebookId,
        Product2Id =  prod2.Id,
        UnitPrice  = 100,
        IsActive = true
        );
        insert pricebook;
        
        Account acc = new Account(
        Name = 'Test Account'
        );
        insert acc;
        
        
        Order ord = new Order(
        Name ='Test Order',
        Status ='Draft',
        EffectiveDate = Date.today(),
        AccountId = acc.Id,
        Pricebook2Id = standardPricebookId
        );
        
        insert ord; 
        
        Orderitem orderItem = new OrderItem(
         OrderId = ord.Id,
         PricebookEntryId = pricebook.Id,
         Quantity = 1,
         UnitPrice = 100,
         InwiB2C_FMS__c = 0,
         InwiB2C_FMS_Catalogue__c = 0   
         );
        insert orderItem;
        
        Map<String,Object> inputMap = new Map<String,Object>{
            'orderItemId' => orderItem.Id,
             'MontantFMS' => 123.45
        };
            
        Map<String,Object> outputMap = new Map<String,Object>();
        Map<String,Object> optionsMap  = new Map<String,Object>();
        
        InwiB2C_ApplyFMSCalculator calc = new InwiB2C_ApplyFMSCalculator();
        Test.startTest();
        Boolean  result = calc.invokeMethod('ApplyFMSByOrderId',inputMap,outputMap,optionsMap);
        Test.StopTest();
        
        system.assert(result);
        Map<String,Object> response = (Map<String,Object>)outputMap.get('CSGetFMSResultInfo');
        System.assertEquals('INVOKE-200', response.get('errorCode'));
        System.assertEquals('OK', response.get('errorMessage'));
        
        // Vérifier la mise a jour 
        OrderItem updated = [SELECT InwiB2C_FMS__c, InwiB2C_FMS_Catalogue__c FROM OrderItem WHERE Id = :orderItem.Id];
        System.assertEquals(123.45, updated.InwiB2C_FMS__c);
        System.assertEquals(123.45, updated.InwiB2C_FMS_Catalogue__c);
    }
    
      // Test method Erreur avec OrderItemId manquant
      @isTest
    static void testApplyFMS_MissingOrderItemId() {
        Map<String, Object> inputMap = new Map<String, Object>{
            'MontantFMS' => 50.0
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();

        InwiB2C_ApplyFMSCalculator calc = new InwiB2C_ApplyFMSCalculator();
        Boolean result = calc.invokeMethod('ApplyFMSByOrderId', inputMap, outputMap, optionsMap);

        System.assert(result); 

        Map<String, Object> response = (Map<String, Object>) outputMap.get('CSGetFMSResultInfo');
        System.assertEquals('INVOKE-400', response.get('errorCode'));
        System.assertEquals('Champ Obligatoire manquant : orderItemId', response.get('errorMessage'));
    }
    
      // Test methode avec erreur de la mise a jour 
      @isTest
    static void testApplyFMS_ExceptionHandling() {
        Map<String, Object> inputMap = new Map<String, Object>{
            'orderItemId' => 'a0123456789fakeId',
            'MontantFMS' => 99.99
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();

        InwiB2C_ApplyFMSCalculator calc = new InwiB2C_ApplyFMSCalculator();
        Boolean result = calc.invokeMethod('ApplyFMSByOrderId', inputMap, outputMap, optionsMap);

        System.assertEquals(true, result);
        Map<String, Object> response = (Map<String, Object>) outputMap.get('CSGetFMSResultInfo');
        System.assertEquals('INVOKE-500', response.get('errorCode'));
        System.assert(((String) response.get('errorMessage')).startsWith('Erreur lors de la mise à jour des FMS'));
    }    
 


    
    
    
}