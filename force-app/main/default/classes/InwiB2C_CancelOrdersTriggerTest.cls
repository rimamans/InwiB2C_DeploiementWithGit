@isTest
public class InwiB2C_CancelOrdersTriggerTest {

        @TestSetup
    public static void setupData() {

        //List<Order> OrderList = TestUtility.prepare
        //insert OrderList;
    }
    
    public static testMethod void batchOrderTest() {
        /* Begin JBE */
        Test.startTest();
inwiB2CTimeOrderCancel__mdt newTimeOrder= new inwiB2CTimeOrderCancel__mdt(inwiB2C_TimeOutOrder__c =0);
        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        
        Product2 prod = new Product2(Name = 'SIM', 
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
        
        order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder;
        
        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
            
        OrderItem newOrderitem = new OrderItem(Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
        insert newOrderitem;
        Id bacthId = Database.executeBatch( new InwiB2C_CancelOrderBatch() , 10 );
        
        ///////////////////////////////////////
        Product2 prodTerminal = new Product2(Name = 'Terminal', 
                                     Family = 'Hardware',
                                     ProductCode='INWIB2C_OFFERING_TERMINAL');
        insert prodTerminal;
        
        Id pricebookId1 = Test.getStandardPricebookId();
        
        PricebookEntry standardPriceTerminal = new PricebookEntry(
            Pricebook2Id = pricebookId1, Product2Id = prodTerminal.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPriceTerminal;
        
        Pricebook2 customPB1 = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB1;
        
        PricebookEntry customPrice1 = new PricebookEntry(
            Pricebook2Id = customPB1.Id, Product2Id = prodTerminal.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        order neworder1 = new Order (Pricebook2Id = customPB1.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder1;
        
        String JsonTerminal =  '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000063RMvAAM","attributeid__c":"a0X25000003WKyaEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_MODELE","attributeconfigurable__c":true,"attributedisplaysequence__c":"55","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modèle","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003wNKDEA2","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Samsung Galaxy A01 CORE","id":"44900b4b-a6cf-7e7e-25c7-3641f1e29c43","sequence":10,"value":"100001702"},{"displayText":"Samsung Galaxy A31","id":"2ecfff2c-17bf-d824-fdc9-e531b57a3316","sequence":20,"value":"100001685"},{"displayText":"Samsung Galaxy Note 20","id":"ebcbf96a-d180-dd53-1b6f-2a767a626f94","sequence":30,"value":"100001710"},{"displayText":"Samsung Galaxy Note 20 Ultra","id":"151bd122-ccfd-a207-fe50-134c107d3a3a","sequence":40,"value":"100001709"},{"displayText":"SAMSUNG GALAXY A11","id":"b44fbb33-8783-15c5-dba0-cc7d047f5bd1","sequence":50,"value":"100001684"},{"displayText":"APPLE IPHONE 6 SPACE GREY","id":"466ef9c9-c1da-6ad0-c990-cb6b390ee719","sequence":60,"value":"47355"},{"displayText":"APPLE IPHONE 6 SILVER","id":"96833b3a-b332-89c0-9210-c9233b46a4e3","sequence":70,"value":"47415"},{"displayText":"APPLE IPHONE 6 GOLD","id":"0e8a004e-17dd-bc6b-79a8-01a74eef37af","sequence":80,"value":"47375"},{"displayText":"APPLE iPhone 6s Or 16 Go","id":"48a23652-6517-eae9-c438-3f4b2f4aeecc","sequence":90,"value":"52577"},{"displayText":"APPLE iPhone 6s Or Rose 16 Go","id":"fe64930a-2d10-d281-9e4e-bdb09e28faec","sequence":100,"value":"52576"},{"displayText":"Modem Alactel One Touch","id":"82983c3a-fc9f-4340-3fd1-e3d23076e071","sequence":110,"value":"0000123"},{"displayText":"Modem INWI","id":"9d6a2f3b-bb09-db20-eebc-c6fc6cee6ec9","sequence":120,"value":"1234"},{"displayText":"Alcatel Wifi","id":"993ae7af-1d35-69ac-169d-5afe2f7231c2","sequence":130,"value":"12345"},{"displayText":"BOX ZTE","id":"4ed9522d-c6e5-391b-3de2-1aa275de4ada","sequence":140,"value":"123456"},{"displayText":"Huawei B310S","id":"671ce0ea-0194-90ef-9ae8-38d02b4f9133","sequence":150,"value":"1234567"},{"displayText":"HUAWEI P30 DK","id":"624c7f6d-f735-41b3-6094-6f9c80c1c55f","sequence":160,"value":"58213"},{"displayText":"HUAWEI P30 PR","id":"b04fbac8-8eea-172f-0bf4-af4d28ebb51e","sequence":170,"value":"58214"},{"displayText":"WIKO U PULSE DARK LTE","id":"4b683c83-33ad-acf4-b422-c63adb73fd1f","sequence":180,"value":"55801"},{"displayText":"WIKO U PULSE GOLD LTE","id":"2b4609fa-3dbb-90b2-a1ec-75d32ab3192c","sequence":190,"value":"55802"},{"displayText":"NOKIA 3 SILVER","id":"49e71cd0-640c-e93f-1ea5-8c71fcd14829","sequence":200,"value":"55021"},{"displayText":"NOKIA 3 DARK","id":"ea71ba40-823c-ecb6-c769-7ab5c5d0a913","sequence":210,"value":"55037"}],"default":[],"selectedItem":{"displayText":"Samsung Galaxy A01 CORE","id":"44900b4b-a6cf-7e7e-25c7-3641f1e29c43","sequence":10,"value":"100001702"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000063RMvAAM","attributeid__c":"a0X25000003WKyVEAW","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IMEI","attributeconfigurable__c":true,"attributedisplaysequence__c":"40","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMEI/ESN","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003wNJyEAM","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"900000000000962"},"$$AttributeDefinitionEnd$$":null}]}';
        
        OrderItem newOrderitemTerminal = new OrderItem(Product2Id = prodTerminal.Id , vlocity_cmt__JSONAttribute__c = JsonTerminal, PriceBookEntryId=customPrice1.Id, OrderId=neworder1.Id, Quantity=1, UnitPrice=customPrice1.UnitPrice, ServiceDate=Date.Today());
        insert newOrderitemTerminal;
        Id bacthId1 = Database.executeBatch( new InwiB2C_CancelOrderBatch() , 10 );
        //////////////////////////////////////////

        
        Product2 prodMDN = new Product2(Name = 'Laptop X202', 
               Family = 'Hardware',
               ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
        insert prodMDN;
        
        Id pricebookId2 = Test.getStandardPricebookId();
        
        PricebookEntry standardPriceMDN = new PricebookEntry(
            Pricebook2Id = pricebookId2, Product2Id = prodMDN.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPriceMDN;
        
        
        Pricebook2 customPB2 = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB2;
      
        
        PricebookEntry customPrice2 = new PricebookEntry(
            Pricebook2Id = customPB2.Id, Product2Id = prodMDN.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice2;
        

        order neworder2 = new Order (Pricebook2Id = customPB2.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder2;
        
        String JsonMDN =  '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003WKyLEAW","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_MSISDN","attributeconfigurable__c":true,"attributedisplaysequence__c":"60","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"MSISDN","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003vWhMEAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"212648061134"},"$$AttributeDefinitionEnd$$":null]}';
        
        OrderItem newOrderitemMDN = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworder2.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
        insert newOrderitemMDN;
        
        //insert neworder;
        //Id bacthId2 = Database.executeBatch( new InwiB2C_CancelOrderBatch() , 10 );
        List<inwiB2C_CancelOrdersBatchEvent__e> ItemsToInsert = new List<inwiB2C_CancelOrdersBatchEvent__e>();
        
        inwiB2C_CancelOrdersBatchEvent__e eventToCreatesim = new inwiB2C_CancelOrdersBatchEvent__e();
        inwiB2C_CancelOrdersBatchEvent__e eventToCreateterm = new inwiB2C_CancelOrdersBatchEvent__e();
        inwiB2C_CancelOrdersBatchEvent__e eventToCreatemdn = new inwiB2C_CancelOrdersBatchEvent__e();
        
        eventToCreatesim.inwiB2C_OrderId__c = neworder.Id;
        eventToCreatesim.inwiB2C_CodePartenaire__c = neworder.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c;
        ItemsToInsert.add(eventToCreatesim);
        
      	eventToCreateterm.inwiB2C_OrderId__c = neworder1.Id;
        eventToCreateterm.inwiB2C_CodePartenaire__c = neworder1.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c;
        ItemsToInsert.add(eventToCreateterm);
        
        eventToCreatemdn.inwiB2C_OrderId__c = neworder2.Id;
        eventToCreatemdn.inwiB2C_CodePartenaire__c = neworder2.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c;
        ItemsToInsert.add(eventToCreatemdn);

        system.debug('list of orders to cancel :'+ ItemsToInsert);
        List <Database.SaveResult> sresult = EventBus.publish(ItemsToInsert);
        Test.stopTest();
    }
}