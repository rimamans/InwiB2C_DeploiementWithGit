@isTest
public class inwiB2C_CreateContractTrigger_Test {
    @isTest(SeeAllData=true)
    public static  void CreateContractTrigger_Test_OrderCreate() {
        Account client;
        Account acctPartner;
        Contract contractClient;
        order order;
        
        acctPartner = new Account(Name='Test Agence', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partenaire').getRecordTypeId());
        insert acctPartner;
        
        client = new Account();
        client.Name = 'Dummy Test';
        client.Inwib2c_Segment_march__c = 'Particulier';
        client.Inwib2c_Segment_valeur__c = 'Silver';
        client.vlocity_cmt__Status__c = 'Nouveau';
        client.Inwib2c_Client_Depuis__c = date.today();
        client.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert client; 
        
        Contact contactClient = new Contact();
        contactClient.AccountId = client.id;
        contactClient.firstName = 'Dummy Test';
        contactClient.lastname = '21266';
        contactClient.InwiB2C_Anciennet__c = 'Dummy';
        contactClient.InwiB2C_Profession__c = 'Dummy';
        contactClient.InwiB2C_Secteur_d_activit__c = 'Dummy';
        insert contactClient;
        
        client.vlocity_cmt__PersonContactId__c = contactClient.id;
        update client;
        
        contractClient = new Contract();
        contractClient.AccountId = client.Id;
        contractClient.InwiB2c_Nom__c = 'Dummy Test';
        contractClient.InwiB2c_Prenom__c = '21266';
        contractClient.InwiB2C_Sexe__c = 'Homme';
        contractClient.InwiB2C_Date_de_naissance__c = Date.parse('01/01/1986');
        contractClient.InwiB2C_statut_contrat__c = 'Initialise';
        contractClient.inwiB2C_Profession__c = 'Dummy';
        contractClient.InwiB2C_Date_CRM__c = datetime.now();
        contractClient.InwiB2C_Type_CIN__c = 'CIN';
        contractClient.InwiB2C_Num_CIN__c = 'X123456';
        contractClient.InwiB2C_Civilite__c = 'Monsieur';
        insert contractClient;
        
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware',
                                     ProductCode='INWIB2C_OFFERING_SIM');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c(
            vlocity_cmt__Code__c = 'TEST');
        insert priceList;
        
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        order = new Order (Pricebook2Id = customPB.Id,
                           inwiB2C_Statut__c ='inwiB2C_EnCours',
                           EffectiveDate = Date.today().addDays(-1),
                           inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                           Status = 'Draft',
                           AccountId =client.Id);
        insert order;
        
        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
        
        OrderItem orderItem = new OrderItem(vlocity_cmt__Action__c = 'Add',
                                            Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr,
                                            PriceBookEntryId=customPrice.Id,
                                            OrderId=order.Id,
                                            Quantity=1,
                                            UnitPrice=customPrice.UnitPrice,
                                            ServiceDate=Date.Today());
        insert orderItem;
        
        vlocity_cmt__Subscription__c subs = new vlocity_cmt__Subscription__c(vlocity_cmt__SubscriptionNumber__c='212648058885',
                                                                             Inwib2c_Num_ro_de_la_ligne__c='212648058885',
                                                                             Name='TEST2',
                                                                             inwiB2C_LegacyStatus__c='Active',
                                                                             inwiB2C_Statut__c='InwiB2C_Active',
                                                                             vlocity_cmt__Status__c='Active');
        Insert subs;
        
        
        Account dealer = new Account();
        dealer.Name = 'Dummy Test';
        dealer.Inwib2c_Segment_march__c = 'Dealer';
        dealer.vlocity_cmt__Status__c = 'Existant';
        dealer.Inwib2c_Client_Depuis__c = date.today();
        dealer.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert dealer;
        
        order.inwiB2C_Dealer__c = dealer.id;
        
        Contact contactDealer = new Contact();
        contactDealer.AccountId = dealer.id;
        contactDealer.firstName = 'Dealer';
        contactDealer.lastname = 'Dealer';
        contactDealer.InwiB2C_Anciennet__c = 'Dummy';
        contactDealer.InwiB2C_Profession__c = 'Dummy';
        contactDealer.InwiB2C_Secteur_d_activit__c = 'Dummy';
        insert contactDealer;
        
        client.vlocity_cmt__PersonContactId__c = contactDealer.id;
        update dealer;        
        
        vlocity_cmt__Subscription__c subsDealer = new vlocity_cmt__Subscription__c(vlocity_cmt__SubscriptionNumber__c='212648049518',
                                                                                   Inwib2c_Num_ro_de_la_ligne__c='212648049518',
                                                                                   Name='TEST2',
                                                                                   inwiB2C_LegacyStatus__c='Active',
                                                                                   inwiB2C_Statut__c='InwiB2C_Active',
                                                                                   vlocity_cmt__Status__c='Active',
                                                                                   vlocity_cmt__AccountId__c = dealer.id);
        Insert subsDealer;
        
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        //Operation
        logCreateContract.inwib2c_Canal__c = 'USSD-D';
        logCreateContract.inwiB2C_CodeDistributeur__c = 'CPD01';
        logCreateContract.InwiB2C_CodeAgence__c = 'CPD01';
        logCreateContract.inwiB2C_User__c = '212648058885';
        logCreateContract.inwiB2C_uuid__c = '6159aed6-b8cc-41ca-9f01-2ed542cf4090';
        //Customers
        logCreateContract.inwiB2C_FirstName__c = 'Dummy';
        logCreateContract.inwiB2C_LastName__c = 'Dummy';
        logCreateContract.inwiB2C_Gender__c = 'M';
        logCreateContract.inwiB2C_BirthDate__c = Date.parse('01/01/1990');
        logCreateContract.inwiB2C_TypePieceIdentite__c = 'CIN';
        logCreateContract.inwiB2C_PieceIdentite__c = 'CIN57098';
        logCreateContract.inwiB2C_Ocerised__c = False;
        logCreateContract.inwiB2C_SegmentLevel1__c = 'C';
        logCreateContract.inwiB2C_SegmentLevel2__c = '';
        logCreateContract.inwiB2C_CountryCode__c = 'MAR';
        logCreateContract.inwiB2C_Region__c = '';
        logCreateContract.inwiB2C_City__c = '';
        logCreateContract.inwiB2C_State__c = '';
        logCreateContract.inwiB2C_Street__c = '';
        logCreateContract.inwiB2C_Address__c = '';
        logCreateContract.inwiB2C_ComplementAddress__c = '';
        logCreateContract.inwiB2C_PostCode__c = '';
        logCreateContract.inwiB2C_BusinessSegment__c = '';
        //Ressources
        logCreateContract.inwiB2C_Mdn__c = '212648058885';
        logCreateContract.inwiB2C_MdnDealer__c = '212648049518';
        logCreateContract.inwiB2C_Icc__c = '892128510050203257';
        logCreateContract.inwiB2C_ProfileId__c = '84001';
        logCreateContract.inwiB2C_imsi__c = '604050400056226';
        logCreateContract.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        logCreateContract.inwiB2C_puk__c = '26364298';
        logCreateContract.inwiB2C_CodeArticle__c = '000056826';
        logCreateContract.inwiB2C_OcsId__c = 'IN2';
        //Statut
        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_EnCours';
        logCreateContract.inwiB2C_IdOrder__c = order.Id;
        insert logCreateContract;
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventGetCartProduct = new inwiB2C_APICreateOrder__e(
            inwiB2C_Canal__c = 'inwiB2C_USSD',
            inwiB2C_BusinessUnit__c = acctPartner.id,
            inwiB2C_POS__c = acctPartner.id,
            inwiB2C_Ocerised__c = False,
            inwiB2C_Mdn__c = '212660',
            inwiB2C_Icc__c = '123456',
            inwiB2C_ProfileId__c = '618',
            inwiB2C_imsi__c = '12345',
            inwiB2C_ki__c = '1234567890',
            inwiB2C_puk__c = '123456',
            inwiB2C_MdnOCSID__c = 'IN2',
            inwiB2C_ContratId__c = contractClient.id,
            inwiB2C_CustomerId__c = client.id,
            inwiB2C_IdLog__c = logCreateContract.id,
            inwiB2C_CodeArticle__c = '000056826',
            inwiB2C_DealerId__c = dealer.id);
        eventItems.add(eventGetCartProduct);
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
        System.assertEquals(results[0].isSuccess(), True);
        
    }
    
    @isTest(SeeAllData=true)
    public static  void CreateContractTrigger_Test_GetCartProduct() {
        Account client;
        Account acctPartner;
        Contract contractClient;
        order order;
        
        acctPartner = new Account(Name='Test Agence', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partenaire').getRecordTypeId());
        insert acctPartner;
        
        client = new Account();
        client.Name = 'Dummy Test';
        client.Inwib2c_Segment_march__c = 'Particulier';
        client.Inwib2c_Segment_valeur__c = 'Silver';
        client.vlocity_cmt__Status__c = 'Nouveau';
        client.Inwib2c_Client_Depuis__c = date.today();
        client.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert client; 
        
        Contact contactClient = new Contact();
        contactClient.AccountId = client.id;
        contactClient.firstName = 'Dummy Test';
        contactClient.lastname = '21266';
        contactClient.InwiB2C_Anciennet__c = 'Dummy';
        contactClient.InwiB2C_Profession__c = 'Dummy';
        contactClient.InwiB2C_Secteur_d_activit__c = 'Dummy';
        insert contactClient;
        
        client.vlocity_cmt__PersonContactId__c = contactClient.id;
        update client;
        
        contractClient = new Contract();
        contractClient.AccountId = client.Id;
        contractClient.InwiB2c_Nom__c = 'Dummy Test';
        contractClient.InwiB2c_Prenom__c = '21266';
        contractClient.InwiB2C_Sexe__c = 'Homme';
        contractClient.InwiB2C_Date_de_naissance__c = Date.parse('01/01/1986');
        contractClient.InwiB2C_statut_contrat__c = 'Initialise';
        contractClient.inwiB2C_Profession__c = 'Dummy';
        contractClient.InwiB2C_Date_CRM__c = datetime.now();
        contractClient.InwiB2C_Type_CIN__c = 'CIN';
        contractClient.InwiB2C_Num_CIN__c = 'X123456';
        contractClient.InwiB2C_Civilite__c = 'Monsieur';
        insert contractClient;
        
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware',
                                     ProductCode='INWIB2C_OFFERING_SIM');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        order = new Order (Pricebook2Id = customPB.Id,
                           inwiB2C_Statut__c ='inwiB2C_EnCours',
                           EffectiveDate = Date.today().addDays(-1),
                           inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                           Status = 'Draft',
                           AccountId =client.Id);
        insert order;
        
        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
        
        OrderItem orderItem = new OrderItem(vlocity_cmt__Action__c = 'Add',
                                            Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr,
                                            PriceBookEntryId=customPrice.Id,
                                            OrderId=order.Id,
                                            Quantity=1,
                                            UnitPrice=customPrice.UnitPrice,
                                            ServiceDate=Date.Today());
        insert orderItem;
        
        vlocity_cmt__Subscription__c subs = new vlocity_cmt__Subscription__c(vlocity_cmt__SubscriptionNumber__c='0611223355',
                                                                             Inwib2c_Num_ro_de_la_ligne__c='0177662233',
                                                                             Name='TEST2',
                                                                             inwiB2C_LegacyStatus__c='Active',
                                                                             inwiB2C_Statut__c='InwiB2C_Active',
                                                                             vlocity_cmt__Status__c='Active');
        Insert subs;
        
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        //Operation
        logCreateContract.inwib2c_Canal__c = 'USSD-D';
        logCreateContract.inwiB2C_CodeDistributeur__c = 'CPD01';
        logCreateContract.InwiB2C_CodeAgence__c = 'CPD01';
        logCreateContract.inwiB2C_User__c = '212648058885';
        logCreateContract.inwiB2C_uuid__c = '6159aed6-b8cc-41ca-9f01-2ed542cf4090';
        //Customers
        logCreateContract.inwiB2C_FirstName__c = 'Dummy';
        logCreateContract.inwiB2C_LastName__c = 'Dummy';
        logCreateContract.inwiB2C_Gender__c = 'M';
        logCreateContract.inwiB2C_BirthDate__c = Date.parse('01/01/1990');
        logCreateContract.inwiB2C_TypePieceIdentite__c = 'CIN';
        logCreateContract.inwiB2C_PieceIdentite__c = 'CIN57098';
        logCreateContract.inwiB2C_Ocerised__c = False;
        logCreateContract.inwiB2C_SegmentLevel1__c = 'C';
        logCreateContract.inwiB2C_SegmentLevel2__c = '';
        logCreateContract.inwiB2C_CountryCode__c = 'MAR';
        logCreateContract.inwiB2C_Region__c = '';
        logCreateContract.inwiB2C_City__c = '';
        logCreateContract.inwiB2C_State__c = '';
        logCreateContract.inwiB2C_Street__c = '';
        logCreateContract.inwiB2C_Address__c = '';
        logCreateContract.inwiB2C_ComplementAddress__c = '';
        logCreateContract.inwiB2C_PostCode__c = '';
        logCreateContract.inwiB2C_BusinessSegment__c = '';
        //Ressources
        logCreateContract.inwiB2C_Mdn__c = '212648058885';
        logCreateContract.inwiB2C_MdnDealer__c = '212648049518';
        logCreateContract.inwiB2C_Icc__c = '892128510050203257';
        logCreateContract.inwiB2C_ProfileId__c = '84001';
        logCreateContract.inwiB2C_imsi__c = '604050400056226';
        logCreateContract.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        logCreateContract.inwiB2C_puk__c = '26364298';
        logCreateContract.inwiB2C_CodeArticle__c = '000056826';
        logCreateContract.inwiB2C_OcsId__c = 'IN2';
        //Statut
        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_EnCours';
        insert logCreateContract;
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventGetCartProduct = new inwiB2C_APICreateOrder__e(
            inwiB2C_Canal__c = 'inwiB2C_USSD',
            inwiB2C_BusinessUnit__c = acctPartner.id,
            inwiB2C_POS__c = acctPartner.id,
            inwiB2C_Ocerised__c = False,
            inwiB2C_Mdn__c = '212660',
            inwiB2C_Icc__c = '123456',
            inwiB2C_ProfileId__c = '618',
            inwiB2C_imsi__c = '12345',
            inwiB2C_ki__c = '1234567890',
            inwiB2C_puk__c = '123456',
            inwiB2C_MdnOCSID__c = 'IN2',
            inwiB2C_ContratId__c = contractClient.id,
            inwiB2C_CustomerId__c = client.id,
            inwiB2C_orderId__c = order.id,
            inwiB2C_step__c = 'getCartProduct',
            inwiB2C_IdLog__c = logCreateContract.id);
        eventItems.add(eventGetCartProduct);
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
        System.assertEquals(results[0].isSuccess(), True);
    }
    
    @isTest
    public static  void CreateContractTrigger_Test_GetCartProductError() {
        
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        //Operation
        logCreateContract.inwib2c_Canal__c = 'USSD-D';
        logCreateContract.inwiB2C_CodeDistributeur__c = 'CPD01';
        logCreateContract.InwiB2C_CodeAgence__c = 'CPD01';
        logCreateContract.inwiB2C_User__c = '212648058885';
        logCreateContract.inwiB2C_uuid__c = '6159aed6-b8cc-41ca-9f01-2ed542cf4090';
        //Customers
        logCreateContract.inwiB2C_FirstName__c = 'Dummy';
        logCreateContract.inwiB2C_LastName__c = 'Dummy';
        logCreateContract.inwiB2C_Gender__c = 'M';
        logCreateContract.inwiB2C_BirthDate__c = Date.parse('01/01/1990');
        logCreateContract.inwiB2C_TypePieceIdentite__c = 'CIN';
        logCreateContract.inwiB2C_PieceIdentite__c = 'CIN57098';
        logCreateContract.inwiB2C_Ocerised__c = False;
        logCreateContract.inwiB2C_SegmentLevel1__c = 'C';
        logCreateContract.inwiB2C_SegmentLevel2__c = '';
        logCreateContract.inwiB2C_CountryCode__c = 'MAR';
        logCreateContract.inwiB2C_Region__c = '';
        logCreateContract.inwiB2C_City__c = '';
        logCreateContract.inwiB2C_State__c = '';
        logCreateContract.inwiB2C_Street__c = '';
        logCreateContract.inwiB2C_Address__c = '';
        logCreateContract.inwiB2C_ComplementAddress__c = '';
        logCreateContract.inwiB2C_PostCode__c = '';
        logCreateContract.inwiB2C_BusinessSegment__c = '';
        //Ressources
        logCreateContract.inwiB2C_Mdn__c = '212648058885';
        logCreateContract.inwiB2C_MdnDealer__c = '212648049518';
        logCreateContract.inwiB2C_Icc__c = '892128510050203257';
        logCreateContract.inwiB2C_ProfileId__c = '84001';
        logCreateContract.inwiB2C_imsi__c = '604050400056226';
        logCreateContract.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        logCreateContract.inwiB2C_puk__c = '26364298';
        logCreateContract.inwiB2C_CodeArticle__c = '000056826';
        logCreateContract.inwiB2C_OcsId__c = 'IN2';
        //Statut
        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_EnCours';
        insert logCreateContract;
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventGetCartProduct = new inwiB2C_APICreateOrder__e(
            inwiB2C_Canal__c = '',
            inwiB2C_BusinessUnit__c = '',
            inwiB2C_POS__c = '',
            inwiB2C_Ocerised__c = False,
            inwiB2C_Mdn__c = '',
            inwiB2C_Icc__c = '',
            inwiB2C_ProfileId__c = '',
            inwiB2C_imsi__c = '',
            inwiB2C_ki__c = '',
            inwiB2C_puk__c = '',
            inwiB2C_MdnOCSID__c = '',
            inwiB2C_ContratId__c = '',
            inwiB2C_CustomerId__c = '',
            inwiB2C_orderId__c = '',
            inwiB2C_step__c = 'getCartProduct',
            inwiB2C_IdLog__c = logCreateContract.id);
        eventItems.add(eventGetCartProduct);
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
        System.assertEquals(results[0].isSuccess(), True);
    }
    
    @isTest
    public static  void CreateContractTrigger_Test_GetCartProductError2() {
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventGetCartProduct = new inwiB2C_APICreateOrder__e(
            inwiB2C_step__c = 'getCartProduct');
        eventItems.add(eventGetCartProduct);
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
        System.assertEquals(results[0].isSuccess(), True);
    }
    
    @isTest(SeeAllData=true)
    public static  void CreateContractTrigger_Test_AddProduct() {
        Account client;
        Account acctPartner;
        Contract contractClient;
        order order;
        
        acctPartner = new Account(Name='Test Agence', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partenaire').getRecordTypeId());
        insert acctPartner;
        
        client = new Account();
        client.Name = 'Dummy Test';
        client.Inwib2c_Segment_march__c = 'Particulier';
        client.Inwib2c_Segment_valeur__c = 'Silver';
        client.vlocity_cmt__Status__c = 'Nouveau';
        client.Inwib2c_Client_Depuis__c = date.today();
        client.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert client; 
        
        Contact contactClient = new Contact();
        contactClient.AccountId = client.id;
        contactClient.firstName = 'Dummy Test';
        contactClient.lastname = '21266';
        contactClient.InwiB2C_Anciennet__c = 'Dummy';
        contactClient.InwiB2C_Profession__c = 'Dummy';
        contactClient.InwiB2C_Secteur_d_activit__c = 'Dummy';
        insert contactClient;
        
        client.vlocity_cmt__PersonContactId__c = contactClient.id;
        update client;
        
        contractClient = new Contract();
        contractClient.AccountId = client.Id;
        contractClient.InwiB2c_Nom__c = 'Dummy Test';
        contractClient.InwiB2c_Prenom__c = '21266';
        contractClient.InwiB2C_Sexe__c = 'Homme';
        contractClient.InwiB2C_Date_de_naissance__c = Date.parse('01/01/1986');
        contractClient.InwiB2C_statut_contrat__c = 'Initialise';
        contractClient.inwiB2C_Profession__c = 'Dummy';
        contractClient.InwiB2C_Date_CRM__c = datetime.now();
        contractClient.InwiB2C_Type_CIN__c = 'CIN';
        contractClient.InwiB2C_Num_CIN__c = 'X123456';
        contractClient.InwiB2C_Civilite__c = 'Monsieur';
        insert contractClient;
        
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware',
                                     ProductCode='INWIB2C_OFFERING_SIM');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        order = new Order (Pricebook2Id = customPB.Id,
                           inwiB2C_Statut__c ='inwiB2C_EnCours',
                           EffectiveDate = Date.today().addDays(-1),
                           inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                           Status = 'Draft',
                           AccountId =client.Id);
        insert order;
        
        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
        
        OrderItem orderItem = new OrderItem(vlocity_cmt__Action__c = 'Add',
                                            Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr,
                                            PriceBookEntryId=customPrice.Id,
                                            OrderId=order.Id,
                                            Quantity=1,
                                            UnitPrice=customPrice.UnitPrice,
                                            ServiceDate=Date.Today());
        insert orderItem;
        
        vlocity_cmt__Subscription__c subs = new vlocity_cmt__Subscription__c(vlocity_cmt__SubscriptionNumber__c='0611223355',
                                                                             Inwib2c_Num_ro_de_la_ligne__c='0177662233',
                                                                             Name='TEST2',
                                                                             inwiB2C_LegacyStatus__c='Active',
                                                                             inwiB2C_Statut__c='InwiB2C_Active',
                                                                             vlocity_cmt__Status__c='Active');
        Insert subs;
        
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        //Operation
        logCreateContract.inwib2c_Canal__c = 'USSD-D';
        logCreateContract.inwiB2C_CodeDistributeur__c = 'CPD01';
        logCreateContract.InwiB2C_CodeAgence__c = 'CPD01';
        logCreateContract.inwiB2C_User__c = '212648058885';
        logCreateContract.inwiB2C_uuid__c = '6159aed6-b8cc-41ca-9f01-2ed542cf4090';
        //Customers
        logCreateContract.inwiB2C_FirstName__c = 'Dummy';
        logCreateContract.inwiB2C_LastName__c = 'Dummy';
        logCreateContract.inwiB2C_Gender__c = 'M';
        logCreateContract.inwiB2C_BirthDate__c = Date.parse('01/01/1990');
        logCreateContract.inwiB2C_TypePieceIdentite__c = 'CIN';
        logCreateContract.inwiB2C_PieceIdentite__c = 'CIN57098';
        logCreateContract.inwiB2C_Ocerised__c = False;
        logCreateContract.inwiB2C_SegmentLevel1__c = 'C';
        logCreateContract.inwiB2C_SegmentLevel2__c = '';
        logCreateContract.inwiB2C_CountryCode__c = 'MAR';
        logCreateContract.inwiB2C_Region__c = '';
        logCreateContract.inwiB2C_City__c = '';
        logCreateContract.inwiB2C_State__c = '';
        logCreateContract.inwiB2C_Street__c = '';
        logCreateContract.inwiB2C_Address__c = '';
        logCreateContract.inwiB2C_ComplementAddress__c = '';
        logCreateContract.inwiB2C_PostCode__c = '';
        logCreateContract.inwiB2C_BusinessSegment__c = '';
        //Ressources
        logCreateContract.inwiB2C_Mdn__c = '212648058885';
        logCreateContract.inwiB2C_MdnDealer__c = '212648049518';
        logCreateContract.inwiB2C_Icc__c = '892128510050203257';
        logCreateContract.inwiB2C_ProfileId__c = '84001';
        logCreateContract.inwiB2C_imsi__c = '604050400056226';
        logCreateContract.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        logCreateContract.inwiB2C_puk__c = '26364298';
        logCreateContract.inwiB2C_CodeArticle__c = '000056826';
        logCreateContract.inwiB2C_OcsId__c = 'IN2';
        //Statut
        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_EnCours';
        insert logCreateContract;
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventCreateOrderAddProduct = new inwiB2C_APICreateOrder__e(
            inwiB2C_Canal__c = 'inwiB2C_USSD',
            inwiB2C_BusinessUnit__c = acctPartner.id,
            inwiB2C_POS__c = acctPartner.id,
            inwiB2C_Ocerised__c = False,
            inwiB2C_Mdn__c = '212660',
            inwiB2C_Icc__c = '123456',
            inwiB2C_ProfileId__c = '618',
            inwiB2C_imsi__c = '12345',
            inwiB2C_ki__c = '1234567890',
            inwiB2C_puk__c = '123456',
            inwiB2C_MdnOCSID__c = 'IN2',
            inwiB2C_ContratId__c = contractClient.id,
            inwiB2C_CustomerId__c = client.id,
            inwiB2C_orderId__c = order.id,
            inwiB2C_step__c = 'addProduct',
            inwiB2C_IdLog__c = logCreateContract.id);  
        eventItems.add(eventCreateOrderAddProduct) ;
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
System.assertEquals(results[0].isSuccess(), True);
    }
    
    @isTest
    public static  void CreateContractTrigger_Test_AddProductError() {
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        //Operation
        logCreateContract.inwib2c_Canal__c = 'USSD-D';
        logCreateContract.inwiB2C_CodeDistributeur__c = 'CPD01';
        logCreateContract.InwiB2C_CodeAgence__c = 'CPD01';
        logCreateContract.inwiB2C_User__c = '212648058885';
        logCreateContract.inwiB2C_uuid__c = '6159aed6-b8cc-41ca-9f01-2ed542cf4090';
        //Customers
        logCreateContract.inwiB2C_FirstName__c = 'Dummy';
        logCreateContract.inwiB2C_LastName__c = 'Dummy';
        logCreateContract.inwiB2C_Gender__c = 'M';
        logCreateContract.inwiB2C_BirthDate__c = Date.parse('01/01/1990');
        logCreateContract.inwiB2C_TypePieceIdentite__c = 'CIN';
        logCreateContract.inwiB2C_PieceIdentite__c = 'CIN57098';
        logCreateContract.inwiB2C_Ocerised__c = False;
        logCreateContract.inwiB2C_SegmentLevel1__c = 'C';
        logCreateContract.inwiB2C_SegmentLevel2__c = '';
        logCreateContract.inwiB2C_CountryCode__c = 'MAR';
        logCreateContract.inwiB2C_Region__c = '';
        logCreateContract.inwiB2C_City__c = '';
        logCreateContract.inwiB2C_State__c = '';
        logCreateContract.inwiB2C_Street__c = '';
        logCreateContract.inwiB2C_Address__c = '';
        logCreateContract.inwiB2C_ComplementAddress__c = '';
        logCreateContract.inwiB2C_PostCode__c = '';
        logCreateContract.inwiB2C_BusinessSegment__c = '';
        //Ressources
        logCreateContract.inwiB2C_Mdn__c = '212648058885';
        logCreateContract.inwiB2C_MdnDealer__c = '212648049518';
        logCreateContract.inwiB2C_Icc__c = '892128510050203257';
        logCreateContract.inwiB2C_ProfileId__c = '84001';
        logCreateContract.inwiB2C_imsi__c = '604050400056226';
        logCreateContract.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        logCreateContract.inwiB2C_puk__c = '26364298';
        logCreateContract.inwiB2C_CodeArticle__c = '000056826';
        logCreateContract.inwiB2C_OcsId__c = 'IN2';
        //Statut
        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_EnCours';
        insert logCreateContract;
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventCreateOrderAddProduct = new inwiB2C_APICreateOrder__e(
            inwiB2C_Canal__c = '',
            inwiB2C_BusinessUnit__c = '',
            inwiB2C_POS__c = '',
            inwiB2C_Ocerised__c = False,
            inwiB2C_Mdn__c = '',
            inwiB2C_Icc__c = '',
            inwiB2C_ProfileId__c = '',
            inwiB2C_imsi__c = '',
            inwiB2C_ki__c = '',
            inwiB2C_puk__c = '',
            inwiB2C_MdnOCSID__c = '',
            inwiB2C_ContratId__c = '',
            inwiB2C_CustomerId__c = '',
            inwiB2C_orderId__c = '',
            inwiB2C_step__c = 'addProduct',
            inwiB2C_IdLog__c = logCreateContract.id);  
        eventItems.add(eventCreateOrderAddProduct) ;
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
System.assertEquals(results[0].isSuccess(), True);
    }
    
    @isTest
    public static  void CreateContractTrigger_Test_AddProductError2() {
        
        //Populate plateform Event
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventCreateOrderAddProduct = new inwiB2C_APICreateOrder__e();
        
        eventItems.add(eventCreateOrderAddProduct) ;
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
System.assertEquals(results[0].isSuccess(), True);
    }
    
    
    @isTest(SeeAllData=true)
    public static  void CreateContractTrigger_Test_UpdateAttributes() {
        Account client;
        Account acctPartner;
        Contract contractClient;
        order order;
        
        acctPartner = new Account(Name='Test Agence', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partenaire').getRecordTypeId());
        insert acctPartner;
        
        client = new Account();
        client.Name = 'Dummy Test';
        client.Inwib2c_Segment_march__c = 'Particulier';
        client.Inwib2c_Segment_valeur__c = 'Silver';
        client.vlocity_cmt__Status__c = 'Nouveau';
        client.Inwib2c_Client_Depuis__c = date.today();
        client.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert client; 
        
        Contact contactClient = new Contact();
        contactClient.AccountId = client.id;
        contactClient.firstName = 'Dummy Test';
        contactClient.lastname = '21266';
        contactClient.InwiB2C_Anciennet__c = 'Dummy';
        contactClient.InwiB2C_Profession__c = 'Dummy';
        contactClient.InwiB2C_Secteur_d_activit__c = 'Dummy';
        insert contactClient;
        
        client.vlocity_cmt__PersonContactId__c = contactClient.id;
        update client;
        
        contractClient = new Contract();
        contractClient.AccountId = client.Id;
        contractClient.InwiB2c_Nom__c = 'Dummy Test';
        contractClient.InwiB2c_Prenom__c = '21266';
        contractClient.InwiB2C_Sexe__c = 'Homme';
        contractClient.InwiB2C_Date_de_naissance__c = Date.parse('01/01/1986');
        contractClient.InwiB2C_statut_contrat__c = 'Initialise';
        contractClient.inwiB2C_Profession__c = 'Dummy';
        contractClient.InwiB2C_Date_CRM__c = datetime.now();
        contractClient.InwiB2C_Type_CIN__c = 'CIN';
        contractClient.InwiB2C_Num_CIN__c = 'X123456';
        contractClient.InwiB2C_Civilite__c = 'Monsieur';
        insert contractClient;
        
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware',
                                     ProductCode='INWIB2C_OFFERING_SIM');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        order = new Order (Pricebook2Id = customPB.Id,
                           inwiB2C_Statut__c ='inwiB2C_EnCours',
                           EffectiveDate = Date.today().addDays(-1),
                           inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                           Status = 'Draft',
                           AccountId =client.Id);
        insert order;
        
        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
        
        OrderItem orderItem = new OrderItem(vlocity_cmt__Action__c = 'Add',
                                            Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr,
                                            PriceBookEntryId=customPrice.Id,
                                            OrderId=order.Id,
                                            Quantity=1,
                                            UnitPrice=customPrice.UnitPrice,
                                            ServiceDate=Date.Today());
        insert orderItem;
        
        vlocity_cmt__Subscription__c subs = new vlocity_cmt__Subscription__c(vlocity_cmt__SubscriptionNumber__c='0611223355',
                                                                             Inwib2c_Num_ro_de_la_ligne__c='0177662233',
                                                                             Name='TEST2',
                                                                             inwiB2C_LegacyStatus__c='Active',
                                                                             inwiB2C_Statut__c='InwiB2C_Active',
                                                                             vlocity_cmt__Status__c='Active');
        Insert subs;
        
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        //Operation
        logCreateContract.inwib2c_Canal__c = 'USSD-D';
        logCreateContract.inwiB2C_CodeDistributeur__c = 'CPD01';
        logCreateContract.InwiB2C_CodeAgence__c = 'CPD01';
        logCreateContract.inwiB2C_User__c = '212648058885';
        logCreateContract.inwiB2C_uuid__c = '6159aed6-b8cc-41ca-9f01-2ed542cf4090';
        //Customers
        logCreateContract.inwiB2C_FirstName__c = 'Dummy';
        logCreateContract.inwiB2C_LastName__c = 'Dummy';
        logCreateContract.inwiB2C_Gender__c = 'M';
        logCreateContract.inwiB2C_BirthDate__c = Date.parse('01/01/1990');
        logCreateContract.inwiB2C_TypePieceIdentite__c = 'CIN';
        logCreateContract.inwiB2C_PieceIdentite__c = 'CIN57098';
        logCreateContract.inwiB2C_Ocerised__c = False;
        logCreateContract.inwiB2C_SegmentLevel1__c = 'C';
        logCreateContract.inwiB2C_SegmentLevel2__c = '';
        logCreateContract.inwiB2C_CountryCode__c = 'MAR';
        logCreateContract.inwiB2C_Region__c = '';
        logCreateContract.inwiB2C_City__c = '';
        logCreateContract.inwiB2C_State__c = '';
        logCreateContract.inwiB2C_Street__c = '';
        logCreateContract.inwiB2C_Address__c = '';
        logCreateContract.inwiB2C_ComplementAddress__c = '';
        logCreateContract.inwiB2C_PostCode__c = '';
        logCreateContract.inwiB2C_BusinessSegment__c = '';
        //Ressources
        logCreateContract.inwiB2C_Mdn__c = '212648058885';
        logCreateContract.inwiB2C_MdnDealer__c = '212648049518';
        logCreateContract.inwiB2C_Icc__c = '892128510050203257';
        logCreateContract.inwiB2C_ProfileId__c = '84001';
        logCreateContract.inwiB2C_imsi__c = '604050400056226';
        logCreateContract.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        logCreateContract.inwiB2C_puk__c = '26364298';
        logCreateContract.inwiB2C_CodeArticle__c = '000056826';
        logCreateContract.inwiB2C_OcsId__c = 'IN2';
        //Statut
        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_EnCours';
        insert logCreateContract;
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventCreateOrderupdateAttributes = new inwiB2C_APICreateOrder__e(
            inwiB2C_Canal__c = 'inwiB2C_USSD',
            inwiB2C_BusinessUnit__c = acctPartner.id,
            inwiB2C_POS__c = acctPartner.id,
            inwiB2C_Ocerised__c = False,
            inwiB2C_Mdn__c = '212660',
            inwiB2C_Icc__c = '123456',
            inwiB2C_ProfileId__c = '618',
            inwiB2C_imsi__c = '12345',
            inwiB2C_ki__c = '1234567890',
            inwiB2C_puk__c = '123456',
            inwiB2C_MdnOCSID__c = 'IN2',
            inwiB2C_ContratId__c = contractClient.id,
            inwiB2C_CustomerId__c = client.id,
            inwiB2C_orderId__c = order.id,
            inwiB2C_ItemId__c = orderItem.Id,
            inwiB2C_step__c = 'updateAttributes',
            inwiB2C_IdLog__c = logCreateContract.id); 
        eventItems.add(eventCreateOrderupdateAttributes) ;
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
System.assertEquals(results[0].isSuccess(), True);
    }
    
    @isTest
    public static  void CreateContractTrigger_Test_UpdateAttributesError() {
        
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        //Operation
        logCreateContract.inwib2c_Canal__c = 'USSD-D';
        logCreateContract.inwiB2C_CodeDistributeur__c = 'CPD01';
        logCreateContract.InwiB2C_CodeAgence__c = 'CPD01';
        logCreateContract.inwiB2C_User__c = '212648058885';
        logCreateContract.inwiB2C_uuid__c = '6159aed6-b8cc-41ca-9f01-2ed542cf4090';
        //Customers
        logCreateContract.inwiB2C_FirstName__c = 'Dummy';
        logCreateContract.inwiB2C_LastName__c = 'Dummy';
        logCreateContract.inwiB2C_Gender__c = 'M';
        logCreateContract.inwiB2C_BirthDate__c = Date.parse('01/01/1990');
        logCreateContract.inwiB2C_TypePieceIdentite__c = 'CIN';
        logCreateContract.inwiB2C_PieceIdentite__c = 'CIN57098';
        logCreateContract.inwiB2C_Ocerised__c = False;
        logCreateContract.inwiB2C_SegmentLevel1__c = 'C';
        logCreateContract.inwiB2C_SegmentLevel2__c = '';
        logCreateContract.inwiB2C_CountryCode__c = 'MAR';
        logCreateContract.inwiB2C_Region__c = '';
        logCreateContract.inwiB2C_City__c = '';
        logCreateContract.inwiB2C_State__c = '';
        logCreateContract.inwiB2C_Street__c = '';
        logCreateContract.inwiB2C_Address__c = '';
        logCreateContract.inwiB2C_ComplementAddress__c = '';
        logCreateContract.inwiB2C_PostCode__c = '';
        logCreateContract.inwiB2C_BusinessSegment__c = '';
        //Ressources
        logCreateContract.inwiB2C_Mdn__c = '212648058885';
        logCreateContract.inwiB2C_MdnDealer__c = '212648049518';
        logCreateContract.inwiB2C_Icc__c = '892128510050203257';
        logCreateContract.inwiB2C_ProfileId__c = '84001';
        logCreateContract.inwiB2C_imsi__c = '604050400056226';
        logCreateContract.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        logCreateContract.inwiB2C_puk__c = '26364298';
        logCreateContract.inwiB2C_CodeArticle__c = '000056826';
        logCreateContract.inwiB2C_OcsId__c = 'IN2';
        //Statut
        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_EnCours';
        insert logCreateContract;
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventCreateOrderupdateAttributes = new inwiB2C_APICreateOrder__e(
            inwiB2C_Canal__c = '',
            inwiB2C_BusinessUnit__c = '',
            inwiB2C_POS__c = '',
            inwiB2C_Ocerised__c = False,
            inwiB2C_Mdn__c = '',
            inwiB2C_Icc__c = '',
            inwiB2C_ProfileId__c = '',
            inwiB2C_imsi__c = '',
            inwiB2C_ki__c = '',
            inwiB2C_puk__c = '',
            inwiB2C_MdnOCSID__c = '',
            inwiB2C_ContratId__c = '',
            inwiB2C_CustomerId__c = '',
            inwiB2C_orderId__c = '',
            inwiB2C_ItemId__c = '',
            inwiB2C_step__c = 'updateAttributes',
            inwiB2C_IdLog__c = logCreateContract.id); 
        eventItems.add(eventCreateOrderupdateAttributes) ;
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
System.assertEquals(results[0].isSuccess(), True);
    }
    
    @isTest
    public static  void CreateContractTrigger_Test_UpdateAttributesError2() {
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventCreateOrderupdateAttributes = new inwiB2C_APICreateOrder__e(
            inwiB2C_step__c = 'updateAttributes');
        eventItems.add(eventCreateOrderupdateAttributes) ;
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
System.assertEquals(results[0].isSuccess(), True);
    }
    
    
    @isTest(SeeAllData=true)
    public static  void CreateContractTrigger_Test_Checkout() {        
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        //Operation
        logCreateContract.inwib2c_Canal__c = 'USSD-D';
        logCreateContract.inwiB2C_CodeDistributeur__c = 'CPD01';
        logCreateContract.InwiB2C_CodeAgence__c = 'CPD01';
        logCreateContract.inwiB2C_User__c = '212648058885';
        logCreateContract.inwiB2C_uuid__c = '6159aed6-b8cc-41ca-9f01-2ed542cf4090';
        //Customers
        logCreateContract.inwiB2C_FirstName__c = 'Dummy';
        logCreateContract.inwiB2C_LastName__c = 'Dummy';
        logCreateContract.inwiB2C_Gender__c = 'M';
        logCreateContract.inwiB2C_BirthDate__c = Date.parse('01/01/1990');
        logCreateContract.inwiB2C_TypePieceIdentite__c = 'CIN';
        logCreateContract.inwiB2C_PieceIdentite__c = 'CIN57098';
        logCreateContract.inwiB2C_Ocerised__c = False;
        logCreateContract.inwiB2C_SegmentLevel1__c = 'C';
        logCreateContract.inwiB2C_SegmentLevel2__c = '';
        logCreateContract.inwiB2C_CountryCode__c = 'MAR';
        logCreateContract.inwiB2C_Region__c = '';
        logCreateContract.inwiB2C_City__c = '';
        logCreateContract.inwiB2C_State__c = '';
        logCreateContract.inwiB2C_Street__c = '';
        logCreateContract.inwiB2C_Address__c = '';
        logCreateContract.inwiB2C_ComplementAddress__c = '';
        logCreateContract.inwiB2C_PostCode__c = '';
        logCreateContract.inwiB2C_BusinessSegment__c = '';
        //Ressources
        logCreateContract.inwiB2C_Mdn__c = '212648058885';
        logCreateContract.inwiB2C_MdnDealer__c = '212648049518';
        logCreateContract.inwiB2C_Icc__c = '892128510050203257';
        logCreateContract.inwiB2C_ProfileId__c = '84001';
        logCreateContract.inwiB2C_imsi__c = '604050400056226';
        logCreateContract.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        logCreateContract.inwiB2C_puk__c = '26364298';
        logCreateContract.inwiB2C_CodeArticle__c = '000056826';
        logCreateContract.inwiB2C_OcsId__c = 'IN2';
        //Statut
        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_EnCours';
        insert logCreateContract;
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventCreateOrderupdateCheckout = new inwiB2C_APICreateOrder__e(
            inwiB2C_Canal__c = '',
            inwiB2C_BusinessUnit__c = '',
            inwiB2C_POS__c = '',
            inwiB2C_Ocerised__c = False,
            inwiB2C_Mdn__c = '',
            inwiB2C_Icc__c = '',
            inwiB2C_ProfileId__c = '',
            inwiB2C_imsi__c = '',
            inwiB2C_ki__c = '',
            inwiB2C_puk__c = '',
            inwiB2C_MdnOCSID__c = '',
            inwiB2C_ContratId__c = '',
            inwiB2C_CustomerId__c = '',
            inwiB2C_orderId__c = '',
            inwiB2C_ItemId__c = '',
            inwiB2C_step__c = 'checkout',
            inwiB2C_IdLog__c = logCreateContract.id); 
        eventItems.add(eventCreateOrderupdateCheckout) ;
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
System.assertEquals(results[0].isSuccess(), True);
    }
    
    @isTest
    public static  void CreateContractTrigger_Test_CheckoutError() {
        
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        //Operation
        logCreateContract.inwib2c_Canal__c = 'USSD-D';
        logCreateContract.inwiB2C_CodeDistributeur__c = 'CPD01';
        logCreateContract.InwiB2C_CodeAgence__c = 'CPD01';
        logCreateContract.inwiB2C_User__c = '212648058885';
        logCreateContract.inwiB2C_uuid__c = '6159aed6-b8cc-41ca-9f01-2ed542cf4090';
        //Customers
        logCreateContract.inwiB2C_FirstName__c = 'Dummy';
        logCreateContract.inwiB2C_LastName__c = 'Dummy';
        logCreateContract.inwiB2C_Gender__c = 'M';
        logCreateContract.inwiB2C_BirthDate__c = Date.parse('01/01/1990');
        logCreateContract.inwiB2C_TypePieceIdentite__c = 'CIN';
        logCreateContract.inwiB2C_PieceIdentite__c = 'CIN57098';
        logCreateContract.inwiB2C_Ocerised__c = False;
        logCreateContract.inwiB2C_SegmentLevel1__c = 'C';
        logCreateContract.inwiB2C_SegmentLevel2__c = '';
        logCreateContract.inwiB2C_CountryCode__c = 'MAR';
        logCreateContract.inwiB2C_Region__c = '';
        logCreateContract.inwiB2C_City__c = '';
        logCreateContract.inwiB2C_State__c = '';
        logCreateContract.inwiB2C_Street__c = '';
        logCreateContract.inwiB2C_Address__c = '';
        logCreateContract.inwiB2C_ComplementAddress__c = '';
        logCreateContract.inwiB2C_PostCode__c = '';
        logCreateContract.inwiB2C_BusinessSegment__c = '';
        //Ressources
        logCreateContract.inwiB2C_Mdn__c = '212648058885';
        logCreateContract.inwiB2C_MdnDealer__c = '212648049518';
        logCreateContract.inwiB2C_Icc__c = '892128510050203257';
        logCreateContract.inwiB2C_ProfileId__c = '84001';
        logCreateContract.inwiB2C_imsi__c = '604050400056226';
        logCreateContract.inwiB2C_ki__c = 'F97769DD8309EA44AD0EE2BBB7AB45CC';
        logCreateContract.inwiB2C_puk__c = '26364298';
        logCreateContract.inwiB2C_CodeArticle__c = '000056826';
        logCreateContract.inwiB2C_OcsId__c = 'IN2';
        //Statut
        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_EnCours';
        insert logCreateContract;
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventCreateOrderupdateCheckout = new inwiB2C_APICreateOrder__e(
            inwiB2C_step__c = 'checkout',
            inwiB2C_IdLog__c = logCreateContract.id); 
        eventItems.add(eventCreateOrderupdateCheckout) ;
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
        System.assertEquals(results[0].isSuccess(), True);
    }
    
    @isTest
    public static  void CreateContractTrigger_Test_CheckoutError2() {
        
        //Populate plateform Event      
        List<inwiB2C_APICreateOrder__e> eventItems = new List<inwiB2C_APICreateOrder__e>();    
        inwiB2C_APICreateOrder__e eventCreateOrderupdateCheckout = new inwiB2C_APICreateOrder__e(
            inwiB2C_step__c = 'checkout');
        eventItems.add(eventCreateOrderupdateCheckout) ;
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
        System.assertEquals(results[0].isSuccess(), True);
    }  
}