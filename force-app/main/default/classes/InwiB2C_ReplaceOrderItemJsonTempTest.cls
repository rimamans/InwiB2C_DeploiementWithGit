/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-13-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest(SeeAllData=true)
private class InwiB2C_ReplaceOrderItemJsonTempTest {
    @isTest
    static void testReplaceSimJson(){
        
       // creation compte de test
       Account accountTest = new Account(
           Name = 'Test Account'
       );
       Insert accountTest;
        
      // Creation de produit Parnt
       Product2 productParent = new Product2(
          Name ='Forfait 11h + 11Go',
          ProductCode ='INWIB2C_OFFERING_99DH_APL',
          IsActive =true
       );
        Insert productParent;
        
        // Récupère l'ID du Pricebook standard pour les tests
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPriceParent = new PricebookEntry(
        Pricebook2Id = pricebookId,
        Product2Id = productParent.Id,
        UnitPrice = 10000, 
        IsActive = true
        );
        
        Insert standardPriceParent;
       
       // Creation de produit SIM
       Product2 productTestSim = new Product2(
        Name = 'SIM',
        ProductCode ='INWIB2C_MOB02_OFFERING_SIM',
        IsActive = true
       );
        
       Insert productTestSim;
        
        PricebookEntry standardPriceSim = new PricebookEntry(
        Pricebook2Id = pricebookId,
        Product2Id = productTestSim.Id,
        UnitPrice = 10000, 
        IsActive = true
        );
        
       Insert standardPriceSim;
        
       //Creation de la commande
       
       Order orderTest = new Order(
           Name ='Test Order',
           status = 'Draft',
           Pricebook2Id =pricebookId,
           AccountId = accountTest.Id,
           EffectiveDate = System.today()
       );
        
        Insert orderTest;
        
       // Creation de OrderItem Parent 
      OrderItem parentItem = new OrderItem (
        OrderId = orderTest.Id,
        Quantity = 1,
        UnitPrice = 100,
        Product2Id = productParent.Id,
        PricebookEntryId = standardPriceParent.Id 
       );
        
       Insert parentItem;
               
       // Creation de OrderItem SIM
       OrderItem orderitemSIM = new OrderItem(
       OrderId = orderTest.Id,
       Quantity = 1,
       UnitPrice = 10,
       Product2Id = productTestSim.Id,
       PricebookEntryId = standardPriceSim.Id, 
       vlocity_cmt__ParentItemId__c = parentItem.Id,
       vlocity_cmt__JSONAttribute__c = '{}' 
       );
        
       Insert orderitemSIM;
        
        // Get le parentItem avec le Product2.ProductCode
        parentItem = [SELECT Id, Product2.ProductCode FROM OrderItem WHERE Id = :parentItem.Id];
        String parentProductCode = parentItem.Product2.ProductCode;

        System.debug('Code produit du parent : ' + parentProductCode);

       // Récupérer OrderTemplate avec product code 
        List<inwib2c_OrderTemplateEshop__mdt> templates = [
            SELECT OrderId__c FROM inwib2c_OrderTemplateEshop__mdt
            WHERE CodeProduct__c = :parentProductCode
            LIMIT 1
        ];

        Id templateOrderId = templates[0].OrderId__c;
        System.debug('template OrderId : ' + templateOrderId);

        //  Récupérer le JSON du SIM depuis la commande template
        List<OrderItem> templateSimItems = [
            SELECT vlocity_cmt__JSONAttribute__c
            FROM OrderItem
            WHERE OrderId = :templateOrderId AND Product2.Name = 'SIM'
            LIMIT 1
        ];
          System.debug('template SIM : ' + templateSimItems);

          Map<String,Object> inputMap = new Map<String,Object>{
            'orderId' => orderTest.Id 
         };
            
        Map<String,Object> outputMap = new Map<String,Object>();
        
        Test.startTest();
        InwiB2C_ReplaceOrderItemJsonFromTemplate service = new InwiB2C_ReplaceOrderItemJsonFromTemplate();
        Boolean result = service.invokeMethod('replaceOrderItemJson',inputMap,outputMap,new Map<String,Object>());
        Test.stopTest();
        
         System.debug('Résultat de invokeMethod : ' + result);
         System.debug('Contenu de outputMap : ' + outputMap);
        
        System.assertEquals(true,result,'La method invokeMethod doit retourner true');
        System.assertEquals('OK',outputMap.get('status'),'Status attendu : Ok');
     }
    
     // Test methode Inconnue avec un OrderId inconnue 
      @isTest
      static void testMethodeInconnue() {
         Map<String,Object> inputMap = new Map<String,Object>{
        'orderId' => '001000000000000AAA' 
     };
    
      Map<String,Object> outputMap = new Map<String,Object>();
    
      InwiB2C_ReplaceOrderItemJsonFromTemplate service = new InwiB2C_ReplaceOrderItemJsonFromTemplate();
    
      Boolean result = service.invokeMethod('methodInconnu', inputMap, outputMap, new Map<String,Object>());
    
      System.assertEquals(false, result, 'Résultat attendu :méthode inconnue');
      System.assertEquals('KO', outputMap.get('status'));
      System.assert(((String) outputMap.get('message')).contains('Méthode inconnue'), 'Le message doit contenir "Méthode inconnue"');
    
  }
   // Test Exception avec un input vide 
     @isTest
     static void testException() {
      Map<String,Object> inputMap = null;
      Map<String,Object> outputMap = new Map<String,Object>();
    
     InwiB2C_ReplaceOrderItemJsonFromTemplate service = new InwiB2C_ReplaceOrderItemJsonFromTemplate();
    
     Boolean result = service.invokeMethod('replaceOrderItemJson', inputMap, outputMap, new Map<String,Object>());
    
      System.assertEquals(false, result, 'Résultat attendu : Exception');
     System.assertEquals('ERROR', outputMap.get('status'));
     System.assertNotEquals(null, outputMap.get('message'), 'Un message d’erreur doit être retourné');
}

  
        
}