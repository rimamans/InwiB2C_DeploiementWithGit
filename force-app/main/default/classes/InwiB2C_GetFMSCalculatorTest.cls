@isTest
public class InwiB2C_GetFMSCalculatorTest {
    
    @testSetup
    static void setupTestData(){
        
        // Cas cameleon
       vlocity_cmt__PricingVariable__c pricingVariable = new vlocity_cmt__PricingVariable__c(
            Name = 'FMS_Catalogue',
           vlocity_cmt__Code__c  ='InwiB2C_FMS_Catalogue'
        );
        insert pricingVariable;
        
         vlocity_cmt__PricingElement__c pricingElement = new vlocity_cmt__PricingElement__c(
            vlocity_cmt__PricingVariableId__c = pricingVariable.Id,
            vlocity_cmt__Amount__c = 400
             
        );
        insert pricingElement;
        
         Product2 product = new Product2(
            Name = 'Forfait FLEXI 119dh 29Go + 2h',
            ProductCode = 'INWIB2C_OFFERING_CAM_FORFAIT119DH20G2H',
            vlocity_cmt__Type__c ='Cameleon', 
            isActive = true
        );
        insert product;
        
         vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c(
          Name = 'Test Price List',
          vlocity_cmt__Code__c = 'Test B2C'
          );
          insert priceList;
        
        vlocity_cmt__PriceListEntry__c priceListEntry = new vlocity_cmt__PriceListEntry__c(
            
            vlocity_cmt__ProductId__c = product.Id,
            vlocity_cmt__PricingElementId__c = pricingElement.Id,
            vlocity_cmt__PriceListId__c = priceList.Id

        );
        insert priceListEntry;
           
        
        // Cas Postpaye
        InwiB2C_MONT_CAUT_FMSFMD__c fmsRecord = new InwiB2C_MONT_CAUT_FMSFMD__c(
            InwiB2C_Code_Offre__c = 'INWIB2C_OFFERING_ILLIMITEINWI299DH',
            InwiB2C_Libell_Offre__c	='Forfait illimité inwi 349dhs',
            InwiB2C_DUREE_ENGAGEMENT__c = 12,
            InwiB2C_IS_PORTABILITY__c = 'ALL',
            InwiB2C_ISBLACKLISTED__c = 'false',
            InwiB2C_M_Type_Client__c = 'GP',
            VALUE_FMS__c = 450
        );
        insert fmsRecord;
    
        
    } 
         // test method with prodcut code Cameleon     
      @isTest
    static void testCameleonFMSCalculation() {
        Map<String, Object> inputMap = new Map<String, Object>{
            'OrderDataInput' => new Map<String, Object>{
                'productCode' => 'INWIB2C_OFFERING_CAM_FORFAIT119DH20G2H',
                'offreType' => 'Cameleon',
                'typeLigne' => '',
                'isBlackListed' => '',
                'engagementDuration' => null
            }
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();

        InwiB2C_GetFMSCalculator calc = new InwiB2C_GetFMSCalculator();
        Test.startTest();
        Boolean result = calc.invokeMethod('GetFMSByOrderId', inputMap, outputMap, optionsMap);
        Test.stopTest();

        System.assertEquals(true, result);
        System.assertEquals(400, outputMap.get('MontantFMS'));
    }

       // test method with prodcut code Postpaye   
      @isTest
    static void testPostpayeFMSCalculation() {
        Map<String, Object> inputMap = new Map<String, Object>{
            'OrderDataInput' => new Map<String, Object>{
                'productCode' => 'INWIB2C_OFFERING_ILLIMITEINWI299DH',
                'offreType' => 'Postpaye',
                'typeLigne' => 'GP',
                'isBlackListed' => 'false',
                'engagementDuration' => 12
            }
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();

        InwiB2C_GetFMSCalculator calc = new InwiB2C_GetFMSCalculator();
        Test.startTest();
        Boolean result = calc.invokeMethod('GetFMSByOrderId', inputMap, outputMap, optionsMap);
        Test.stopTest();

        System.assertEquals(true, result);
        System.assertEquals(450, outputMap.get('MontantFMS'));
    }
    
    // test method with prodcut code Empty
    @isTest
    static void testProductCodeMissing() {
        Map<String, Object> inputMap = new Map<String, Object>{
            'OrderDataInput' => new Map<String, Object>{
                'productCode' => '',
                'offreType' => 'Postpaye',
                'typeLigne' => 'GP',
                'isBlackListed' => 'false',
                'engagementDuration' => 12
            }
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();

        InwiB2C_GetFMSCalculator calc = new InwiB2C_GetFMSCalculator();
        Boolean result = calc.invokeMethod('GetFMSByOrderId', inputMap, outputMap, optionsMap);

        System.assertEquals(true, result);
        System.assertEquals('ProductCode non fourni ou vide.', outputMap.get('error'));
    }  
    
    // test method with invoke exceptions 

    @isTest
          static void testInvokeMethodExceptionHandling() {
     // Création d'une entrée invalide 
       Map<String, Object> inputMap = new Map<String, Object>{
        'OrderDataInput' => null 
    };
      Map<String, Object> outputMap = new Map<String, Object>();
      Map<String, Object> optionsMap = new Map<String, Object>();

    InwiB2C_GetFMSCalculator calc = new InwiB2C_GetFMSCalculator();
    Test.startTest();
    Boolean result = calc.invokeMethod('GetFMSByOrderId', inputMap, outputMap, optionsMap);
    Test.stopTest();

    System.assertEquals(true, result);
    System.assert(((String)outputMap.get('error')).startsWith('Erreur lors du calcul FMS'));
}


}