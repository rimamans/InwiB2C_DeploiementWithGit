@IsTest
public class InwiB2C_SearchOrderD2DTest {
  @IsTest
    static void testSearchOrderD2D() {
        // Create test Account
        
        Account testAcc = new Account(Name = 'Test Account');
        insert testAcc;
        
        Contact testContact = new Contact(LastName ='testCon', AccountId = testAcc.Id ,InwiB2C_Num_ro_de_contact__c ='212654433544');
        insert testContact; 
        
        Account testAccount = new Account(Name = 'Test Account' , vlocity_cmt__PrimaryContactId__c =testContact.Id );
        insert testAccount;
        
        Profile p = [select id from profile where name='Inwi POS' limit 1];
        ID pname = p.Id;
        
        User userlivreur = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = pname, country='United States',IsActive =true,
                ContactId = testContact.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert userlivreur;

        // Create test Product
        //Product2 prod = new Product2(Name = 'ADSL XTRA by inwi Jusqu\'à 20 Mega', Family = 'Test Family', ProductCode = 'INWIB2C_OFFERING_ADSL20MG_199DH' , InwiB2C_Type_offre__c='ADSL');
        Product2 prod = new Product2(Name = 'Terminal', Family = 'Test Family', ProductCode = 'INWIB2C_DEG01_OFFERING_TERMINAL' , InwiB2C_Type_offre__c='ADSL');
        insert prod;
        
         // Create Pricebook and PricebookEntry
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 100, IsActive = true);
        insert standardPrice;

        // Create a test Order
        Order neworder = new Order(
            Pricebook2Id = pricebookId,
            Status = 'Draft',
            AccountId = testAccount.Id,
            EffectiveDate = Date.today().addDays(-1),
            inwiB2C_Canal__c = 'inwiB2C_D2D',
            //inwiB2C_Statut__c = 'inwiB2C_EnCours',
            inwiB2C_Statut__c = 'inwiB2C_Activee',
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            OwnerId = userlivreur.Id,
            InwiB2C_Offre__c = 'ADSL XTRA by inwi Jusqu\'à 20 Mega',
            InwB2C_Statut_livraison_D2D__c = 'Inwib2c_Commande_A_Livrer'
            //inwib2c_Partenaire__c= testAccount.Id 
        );
        insert neworder;

        // Create a test OrderItem with JSON attribute
        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "attributeuniquecode__c": "INWIB2C_ATT_DC_MODELELABEL", "attributeRunTimeInfo": { "value": "CPE ADSL HUAWEI DG8245V-10" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE", "attributeRunTimeInfo": { "value": "12345" }, "$$AttributeDefinitionEnd$$": null }]}';
        OrderItem newOrderitem = new OrderItem(
            Product2Id = prod.Id,
            vlocity_cmt__JSONAttribute__c = JsonAttr,
            PriceBookEntryId = standardPrice.Id,
            OrderId = neworder.Id,
            Quantity = 1,
            UnitPrice = standardPrice.UnitPrice,
            ServiceDate = Date.today(),
            vlocity_cmt__ParentItemId__c= null
        );
        insert newOrderitem;

        System.debug('json att '+newOrderitem.vlocity_cmt__JSONAttribute__c);
        // Set input, output, options map
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('orderid', neworder.Id);
        inputMap.put('typeoffre', 'ADSL');
        inputMap.put('statut', 'inwiB2C_Activee');
        inputMap.put('statuslivraison', 'Inwib2c_Commande_A_Livrer');
        inputMap.put('PosId', '');
        inputMap.put('userlivreur', userlivreur.Id);
        inputMap.put('startdate', neworder.CreatedDate);
        inputMap.put('enddate', '');
        inputMap.put('numcontact', '212654433544' );

        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        
        InwiB2C_SearchOrderD2D orderSearch = new InwiB2C_SearchOrderD2D();
        
        Test.startTest();
        orderSearch.invokeMethod('SearchOrderD2D', inputMap, outMap, options);
        
        DateTime tomorrowDatetime = DateTime.now().addDays(1);
        String tomorrowDatetimeString = tomorrowDatetime.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        inputMap.put('enddate', tomorrowDatetimeString);
        
        orderSearch.invokeMethod('SearchOrderD2D', inputMap, outMap, options);
        Test.stopTest();
    }
}