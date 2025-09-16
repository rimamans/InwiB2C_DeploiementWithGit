@isTest(SeeAllData=true)
public class inwiB2C_SMO_OptionTriggerTest {
    public static testMethod void CaseAddOptionChangeAttribute() {
       		Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            /* Begin JBE */
             
            Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware',ProductCode='INWIB2C_OFFERING_SIM');
            insert prod;
            Product2 prod2 = new Product2(Name = 'Options Roaming',  Family = 'None',ProductCode='INWIB2C_OFFERING_OPT_ROAMING');
            insert prod2;
            Product2 prod5 = new Product2(Name = 'Options Roaming',  Family = 'None',ProductCode='INWIB2C_OFFERING_SRV_ROAMING');
            insert prod5;

            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            

            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;
    
            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
            String JsonAttrROA ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t8E00000BnteBQAR","attributeid__c":"a0X8E0000051NNsUAM","attributecategoryid__c":"a0W8E000005GM9oUAG","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ROAMING_VOIX_SMS","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Roaming","displaysequence__c":null,"categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":null,"querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U8E000008D8owUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Radiobutton","value__c":"Roaming Voix+SMS","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Radiobutton","default":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}],"values":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"},{"value":"Roaming Voix+SMS+Data","sequence":20,"id":"d97b0953-68d9-fc93-fc8a-ef12ac3070a6","displayText":"Roaming Voix+SMS+Data"}],"selectedItem":{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
        
        			
          	OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod2.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem2;
                			
          	OrderItem newOrderitem3 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod5.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem3;

           
        	

            
             //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;
        ////////
  
        
        String post='{"methodName": "postCartsItems","items": [{"parentId": "8022500000312PgAAI","parentHierarchyPath": "01t250000064YH7AAM<01t250000063AblAAE","itemId": "01u25000008nDqcAAE"]},"cartId": "801250000029z8TAAQ","price": true,"validate": true,"includeAttachment": true,"pagesize": 20,"lastRecordId": null,"hierarchy": -1,"query": null}';
		inwiB2C_SMO_API__c NewSmoItem2 = new inwiB2C_SMO_API__c(name = '212777777772', Order__c=newOrder.Id,Asset__c=asset1.Id);
        insert NewSmoItem2;
        
        inwiB2C_SMO_Option_API__c newSmoOptionItem2 = new inwiB2C_SMO_Option_API__c(Step__c='changeAttribute',postCartItemInput__c=post,CodeOption__c='INWIB2C_OFFERING_OPT_ROAMING',inwiB2C_SMO_API__c=NewSmoItem2.Id, Selected__c=true,Done__c=false);
        insert newSmoOptionItem2;
        
        inwiB2C_SMO_Attribute_API__c newSmoAttItem2 = new inwiB2C_SMO_Attribute_API__c(inwiB2C_SMO_Option_API__c=newSmoOptionItem2.Id,Attribute_Code__c='INWIB2C_ATT_RT_ROAMING_VOIX_SMS',Attribute_Value__c='Roaming Voix+SMS+Data');
        insert newSmoAttItem2;
        
        inwiB2C_SMO_Option_API_Event__e EventItem2 = new inwiB2C_SMO_Option_API_Event__e(inwiB2C_SMO_API__c=NewSmoItem2.Id);
        
          Test.startTest();
         
        Database.SaveResult results = EventBus.publish(EventItem2);
        Test.stopTest();
      

    }    
    public static testMethod void CaseAddOptionChangeAttributeMOB02() {
      Account testAccount = new Account();
       testAccount.Name='Test Account';
       insert testAccount;
       /* Begin JBE */
        
       Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware',ProductCode='INWIB2C_OFFERING_SIM');
       insert prod;
       Product2 prod2 = new Product2(Name = 'Options Roaming',  Family = 'None',ProductCode='INWIB2C_MOB02_OFFERING_SRV_ROAMING');
       insert prod2;
       Product2 prod5 = new Product2(Name = 'Options Roaming',  Family = 'None',ProductCode='INWIB2C_MOB02_OFFERING_SRV_ROAMING');
       insert prod5;

       Id pricebookId = Test.getStandardPricebookId();
       
       PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
       insert standardPrice;
       
       Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
       insert customPB;
       

       PricebookEntry customPrice = new PricebookEntry(
           Pricebook2Id = customPB.Id, Product2Id = prod.Id,
           UnitPrice = 12000, IsActive = true);
       insert customPrice;

       order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
       insert neworder;
       
       String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
       String JsonAttrROA ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t8E00000BnteBQAR","attributeid__c":"a0X8E0000051NNsUAM","attributecategoryid__c":"a0W8E000005GM9oUAG","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ROAMING_VOIX_SMS","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Roaming","displaysequence__c":null,"categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":null,"querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U8E000008D8owUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Radiobutton","value__c":"Roaming Voix+SMS","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Radiobutton","default":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}],"values":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"},{"value":"Roaming Voix+SMS+Data","sequence":20,"id":"d97b0953-68d9-fc93-fc8a-ef12ac3070a6","displayText":"Roaming Voix+SMS+Data"}],"selectedItem":{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}},"$$AttributeDefinitionEnd$$":null}]}';
       OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
       insert newOrderitem;
   
         
       OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod2.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
       insert newOrderitem2;
                 
       OrderItem newOrderitem3 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod5.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
       insert newOrderitem3;

      
     

       
        //Create and Insert Asset
       Asset asset1 = new Asset(
           Name = 'Test Asset',
           Status = 'Installed',
           AccountId = testAccount.Id,
           InstallDate = System.Today(),
           Product2Id = prod.Id,
           UsageEndDate = System.Today(),
           vlocity_cmt__OrderProductId__c = newOrderitem.Id
           );
           insert asset1;
   ////////
   
   
   String post='{"methodName": "postCartsItems","items": [{"parentId": "8022500000312PgAAI","parentHierarchyPath": "01t250000064YH7AAM<01t250000063AblAAE","itemId": "01u25000008nDqcAAE"]},"cartId": "801250000029z8TAAQ","price": true,"validate": true,"includeAttachment": true,"pagesize": 20,"lastRecordId": null,"hierarchy": -1,"query": null}';
inwiB2C_SMO_API__c NewSmoItem2 = new inwiB2C_SMO_API__c(name = '212777777772', Order__c=newOrder.Id,Asset__c=asset1.Id);
   insert NewSmoItem2;
   
   inwiB2C_SMO_Option_API__c newSmoOptionItem2 = new inwiB2C_SMO_Option_API__c(Step__c='changeAttribute',postCartItemInput__c=post,CodeOption__c='INWIB2C_MOB02_OFFERING_SRV_ROAMING',inwiB2C_SMO_API__c=NewSmoItem2.Id, Selected__c=true,Done__c=false);
   insert newSmoOptionItem2;
   
   inwiB2C_SMO_Attribute_API__c newSmoAttItem2 = new inwiB2C_SMO_Attribute_API__c(inwiB2C_SMO_Option_API__c=newSmoOptionItem2.Id,Attribute_Code__c='INWIB2C_ATT_RT_ROAMING_VOIX_SMS',Attribute_Value__c='Roaming Voix+SMS');
   insert newSmoAttItem2;
   
   inwiB2C_SMO_Option_API_Event__e EventItem2 = new inwiB2C_SMO_Option_API_Event__e(inwiB2C_SMO_API__c=NewSmoItem2.Id);
   
     Test.startTest();
    
   Database.SaveResult results = EventBus.publish(EventItem2);
   Test.stopTest();
 

}
    public static testMethod void CaseAddOptionPost() {
       		Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            /* Begin JBE */
             
            Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware',ProductCode='INWIB2C_OFFERING_SIM');
            insert prod;
            Product2 prod2 = new Product2(Name = 'Options Roaming',  Family = 'None',ProductCode='INWIB2C_OFFERING_OPT_ROAMING');
            insert prod2;
            Product2 prod5 = new Product2(Name = 'Options Roaming',  Family = 'None',ProductCode='INWIB2C_OFFERING_SRV_ROAMING');
            insert prod5;

            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            

            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;
    
            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
           String JsonAttrROA ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t8E00000BnteBQAR","attributeid__c":"a0X8E0000051NNsUAM","attributecategoryid__c":"a0W8E000005GM9oUAG","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ROAMING_VOIX_SMS","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Roaming","displaysequence__c":null,"categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":null,"querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U8E000008D8owUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Radiobutton","value__c":"Roaming Voix+SMS","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Radiobutton","default":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}],"values":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"},{"value":"Roaming Voix+SMS+Data","sequence":20,"id":"d97b0953-68d9-fc93-fc8a-ef12ac3070a6","displayText":"Roaming Voix+SMS+Data"}],"selectedItem":{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}},"$$AttributeDefinitionEnd$$":null}]}';
             OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
        
        			
          	OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod2.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem2;
                			
          	OrderItem newOrderitem3 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod5.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem3;

           
        	

            
             //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;
        ////////
  
        
        String post='{"methodName": "postCartsItems","items": [{"parentId": "8022500000312PgAAI","parentHierarchyPath": "01t250000064YH7AAM<01t250000063AblAAE","itemId": "01u25000008nDqcAAE"]},"cartId": "801250000029z8TAAQ","price": true,"validate": true,"includeAttachment": true,"pagesize": 20,"lastRecordId": null,"hierarchy": -1,"query": null}';
		inwiB2C_SMO_API__c NewSmoItem2 = new inwiB2C_SMO_API__c(name = '212777777772', Order__c=newOrder.Id,Asset__c=asset1.Id);
        insert NewSmoItem2;
        
        inwiB2C_SMO_Option_API__c newSmoOptionItem2 = new inwiB2C_SMO_Option_API__c(Step__c='PostCart',postCartItemInput__c=post,CodeOption__c='INWIB2C_OFFERING_OPT_ROAMING',inwiB2C_SMO_API__c=NewSmoItem2.Id, Selected__c=true,Done__c=false);
        insert newSmoOptionItem2;
        
        inwiB2C_SMO_Attribute_API__c newSmoAttItem2 = new inwiB2C_SMO_Attribute_API__c(inwiB2C_SMO_Option_API__c=newSmoOptionItem2.Id,Attribute_Code__c='INWIB2C_ATT_RT_ROAMING_VOIX_SMS',Attribute_Value__c='Roaming Voix+SMS+Data');
        insert newSmoAttItem2;
        
        inwiB2C_SMO_Option_API_Event__e EventItem2 = new inwiB2C_SMO_Option_API_Event__e(inwiB2C_SMO_API__c=NewSmoItem2.Id);
        
          Test.startTest();
         
        Database.SaveResult results = EventBus.publish(EventItem2);
        Test.stopTest();
      

    } 
  
    public static testMethod void CaseAddOption() {
       		Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            /* Begin JBE */
           

            
            Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware',ProductCode='INWIB2C_MOB02_OFFERING_SIM');
            insert prod;
            Product2 prod2 = new Product2(Name = 'Options Roaming',  Family = 'None',ProductCode='INWIB2C_MOB02_OFFERING_SRV_ROAMING');
            insert prod2;
           Product2 prod5 = new Product2(Name = 'Options Roaming',  Family = 'None',ProductCode='INWIB2C_MOB02_OFFERING_SRV_ROAMING');
            insert prod5;

            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            

            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;

        
        
          

            
            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
          String JsonAttrROA ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t8E00000BnteBQAR","attributeid__c":"a0X8E0000051NNsUAM","attributecategoryid__c":"a0W8E000005GM9oUAG","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ROAMING_VOIX_SMS","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Roaming","displaysequence__c":null,"categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":null,"querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U8E000008D8owUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Radiobutton","value__c":"Roaming Voix+SMS","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Radiobutton","default":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}],"values":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"},{"value":"Roaming Voix+SMS+Data","sequence":20,"id":"d97b0953-68d9-fc93-fc8a-ef12ac3070a6","displayText":"Roaming Voix+SMS+Data"}],"selectedItem":{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}},"$$AttributeDefinitionEnd$$":null}]}';
              OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
        
        			
          	OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod2.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem2;
                			
          	OrderItem newOrderitem3 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod5.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem3;

           
        	

            
             //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;
        ////////
        inwiB2C_SMO_API__c NewSmoItem = new inwiB2C_SMO_API__c(name = '21277777777', Order__c=newOrder.Id,Asset__c=asset1.Id);
        insert NewSmoItem;
       
        inwiB2C_SMO_Option_API__c newSmoOptionItem1 = new inwiB2C_SMO_Option_API__c(Step__c='Init',CodeOption__c='INWIB2C_MOB02_OFFERING_SRV_ROAMING',inwiB2C_SMO_API__c=NewSmoItem.Id, Selected__c=true);
        insert newSmoOptionItem1;
       
        inwiB2C_SMO_Attribute_API__c newSmoAttItem1 = new inwiB2C_SMO_Attribute_API__c(inwiB2C_SMO_Option_API__c=newSmoOptionItem1.Id,Attribute_Code__c='INWIB2C_ATT_RT_ROAMING_VOIX_SMS',Attribute_Value__c='Roaming Voix+SMS+Data');
        insert newSmoAttItem1;
        
       


        
        inwiB2C_SMO_Option_API_Event__e EventItem = new inwiB2C_SMO_Option_API_Event__e(inwiB2C_SMO_API__c=NewSmoItem.Id);
       

          Test.startTest();
         Database.SaveResult results = EventBus.publish(EventItem);
       
        Test.stopTest();
      

    }
    public static testMethod void CasDescativateRoaming() {
       		Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            /* Begin JBE */
           

            
            Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware',ProductCode='INWIB2C_OFFERING_SIM');
            insert prod;

            Product2 prod2 = new Product2(Name = 'Options Roaming', 
            Family = 'None',
            ProductCode='INWIB2C_OFFERING_OPT_ROAMING');
            insert prod2;
            
        
            Product2 prod3 = new Product2(Name = 'Service Roaming', 
            Family = 'None',
            ProductCode='INWIB2C_OFFERING_SRV_ROAMING');
            insert prod3;
            
           Product2 prod4 = new Product2(Name = 'Volte', 
            Family = 'None',
            ProductCode='INWIB2C_OFFRING_VOLTE');
            insert prod4;
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            

            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;

        
        
          

            
            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
           String JsonAttrROA ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t8E00000BnteBQAR","attributeid__c":"a0X8E0000051NNsUAM","attributecategoryid__c":"a0W8E000005GM9oUAG","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ROAMING_VOIX_SMS","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Roaming","displaysequence__c":null,"categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":null,"querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U8E000008D8owUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Radiobutton","value__c":"Roaming Voix+SMS","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Radiobutton","default":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}],"values":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"},{"value":"Roaming Voix+SMS+Data","sequence":20,"id":"d97b0953-68d9-fc93-fc8a-ef12ac3070a6","displayText":"Roaming Voix+SMS+Data"}],"selectedItem":{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}},"$$AttributeDefinitionEnd$$":null}]}';
             OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
			
          	OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod2.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem2;
        
          	OrderItem newOrderitem3 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod3.Id, vlocity_cmt__JSONAttribute__c = '', PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem3;
           
        	

            
             //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;
        ////////
        inwiB2C_SMO_API__c NewSmoItem = new inwiB2C_SMO_API__c(name = '21277777777', Order__c=newOrder.Id,Asset__c=asset1.Id);
        insert NewSmoItem;
		
        inwiB2C_SMO_Option_API__c newSmoOptionItem1 = new inwiB2C_SMO_Option_API__c(CodeOption__c='INWIB2C_OFFERING_OPT_ROAMING',inwiB2C_SMO_API__c=NewSmoItem.Id, Selected__c=false,Done__c=false);
        insert newSmoOptionItem1;
   


        
        inwiB2C_SMO_Option_API_Event__e EventItem = new inwiB2C_SMO_Option_API_Event__e(inwiB2C_SMO_API__c=NewSmoItem.Id);
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
    

    } 
    public static testMethod void CasDescativateRoamingMOB02() {
      Account testAccount = new Account();
       testAccount.Name='Test Account';
       insert testAccount;
       /* Begin JBE */
      

       
       Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware',ProductCode='INWIB2C_OFFERING_SIM');
       insert prod;

       Product2 prod2 = new Product2(Name = 'Options Roaming', 
       Family = 'None',
       ProductCode='INWIB2C_MOB02_OFFERING_SRV_ROAMING');
       insert prod2;
       
   
       Product2 prod3 = new Product2(Name = 'Service Roaming', 
       Family = 'None',
       ProductCode='INWIB2C_MOB02_OFFERING_SRV_ROAMING');
       insert prod3;
       
      Product2 prod4 = new Product2(Name = 'Volte', 
       Family = 'None',
       ProductCode='INWIB2C_OFFRING_VOLTE');
       insert prod4;
       Id pricebookId = Test.getStandardPricebookId();
       
       PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
       insert standardPrice;
       
       Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
       insert customPB;
       

       PricebookEntry customPrice = new PricebookEntry(
           Pricebook2Id = customPB.Id, Product2Id = prod.Id,
           UnitPrice = 12000, IsActive = true);
       insert customPrice;

   
   
     

       
       order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
       insert neworder;
       
       String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
       String JsonAttrROA ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t8E00000BnteBQAR","attributeid__c":"a0X8E0000051NNsUAM","attributecategoryid__c":"a0W8E000005GM9oUAG","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ROAMING_VOIX_SMS","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Roaming","displaysequence__c":null,"categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":null,"querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U8E000008D8owUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Radiobutton","value__c":"Roaming Voix+SMS","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Radiobutton","default":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}],"values":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"},{"value":"Roaming Voix+SMS+Data","sequence":20,"id":"d97b0953-68d9-fc93-fc8a-ef12ac3070a6","displayText":"Roaming Voix+SMS+Data"}],"selectedItem":{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
       insert newOrderitem;
 
       OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod2.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
       insert newOrderitem2;
   
       OrderItem newOrderitem3 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod3.Id, vlocity_cmt__JSONAttribute__c = '', PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
       insert newOrderitem3;
      
     

       
        //Create and Insert Asset
       Asset asset1 = new Asset(
           Name = 'Test Asset',
           Status = 'Installed',
           AccountId = testAccount.Id,
           InstallDate = System.Today(),
           Product2Id = prod.Id,
           UsageEndDate = System.Today(),
           vlocity_cmt__OrderProductId__c = newOrderitem.Id
           );
           insert asset1;
   ////////
   inwiB2C_SMO_API__c NewSmoItem = new inwiB2C_SMO_API__c(name = '21277777777', Order__c=newOrder.Id,Asset__c=asset1.Id);
   insert NewSmoItem;

   inwiB2C_SMO_Option_API__c newSmoOptionItem1 = new inwiB2C_SMO_Option_API__c( CodeOption__c='INWIB2C_MOB02_OFFERING_SRV_ROAMING',inwiB2C_SMO_API__c=NewSmoItem.Id, Selected__c=false,Done__c=false);
   insert newSmoOptionItem1;



   
   inwiB2C_SMO_Option_API_Event__e EventItem = new inwiB2C_SMO_Option_API_Event__e(inwiB2C_SMO_API__c=NewSmoItem.Id);
   
   Test.startTest();
   Database.SaveResult results = EventBus.publish(EventItem);
   Test.stopTest();


}
    public static testMethod void CasDescativateOther() {
       		Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            /* Begin JBE */
           

            
            Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware',ProductCode='INWIB2C_OFFERING_SIM');
            insert prod;

            Product2 prod2 = new Product2(Name = 'Options Roaming', 
            Family = 'None',
            ProductCode='INWIB2C_OFFERING_OPT_ROAMING');
            insert prod2;
            
        
            Product2 prod3 = new Product2(Name = 'Service Roaming', 
            Family = 'None',
            ProductCode='INWIB2C_OFFERING_SRV_ROAMING');
            insert prod3;
            
           Product2 prod4 = new Product2(Name = 'Volte', 
            Family = 'None',
            ProductCode='INWIB2C_OFFRING_VOLTE');
            insert prod4;
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            

            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;

        
        
          

            
            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
           String JsonAttrROA ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t8E00000BnteBQAR","attributeid__c":"a0X8E0000051NNsUAM","attributecategoryid__c":"a0W8E000005GM9oUAG","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ROAMING_VOIX_SMS","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Roaming","displaysequence__c":null,"categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":null,"querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U8E000008D8owUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Radiobutton","value__c":"Roaming Voix+SMS","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Radiobutton","default":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}],"values":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"},{"value":"Roaming Voix+SMS+Data","sequence":20,"id":"d97b0953-68d9-fc93-fc8a-ef12ac3070a6","displayText":"Roaming Voix+SMS+Data"}],"selectedItem":{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
			
          	OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod2.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem2;
        
          	OrderItem newOrderitem3 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod4.Id, vlocity_cmt__JSONAttribute__c = '', PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem3;
 
           
        	

            
             //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;
        ////////
        inwiB2C_SMO_API__c NewSmoItem = new inwiB2C_SMO_API__c(name = '21277777777', Order__c=newOrder.Id,Asset__c=asset1.Id);
        insert NewSmoItem;
		
        inwiB2C_SMO_Option_API__c newSmoOptionItem1 = new inwiB2C_SMO_Option_API__c(Step__c='Init',CodeOption__c='INWIB2C_OFFRING_VOLTE',inwiB2C_SMO_API__c=NewSmoItem.Id, Selected__c=false);
        insert newSmoOptionItem1;
   


        
        inwiB2C_SMO_Option_API_Event__e EventItem = new inwiB2C_SMO_Option_API_Event__e(inwiB2C_SMO_API__c=NewSmoItem.Id);
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
        
      //  System.assertEquals(newSmoOptionItem2.CodeOption__c, 'INWIB2C_OFFERING_VMSCFWNR');
        
        //System.assertEquals(newSmoOptionItem1.CodeOption__c, 'INWIB2C_OFFERING_OPT_ROAMING');
        
        //System.assertEquals(newSmoOptionItem3.CodeOption__c, 'INWIB2C_OFFRING_VOLTE');
        //inwiB2C_SMO_Option_API_Event__e Item = new inwiB2C_SMO_Option_API_Event__e

    }  
  
    public static testMethod void CaseCheckout() {
       		Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            /* Begin JBE */
           

            
            Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware',ProductCode='INWIB2C_OFFERING_SIM');
            insert prod;

            Product2 prod2 = new Product2(Name = 'Options Roaming', 
            Family = 'None',
            ProductCode='INWIB2C_OFFERING_OPT_ROAMING');
            insert prod2;
            
        
            Product2 prod3 = new Product2(Name = 'Service Roaming', 
            Family = 'None',
            ProductCode='INWIB2C_OFFERING_SRV_ROAMING');
            insert prod3;
            
           Product2 prod4 = new Product2(Name = 'Volte', 
            Family = 'None',
            ProductCode='INWIB2C_OFFRING_VOLTE');
            insert prod4;
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            

            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;

        
        
          

            
            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
            String JsonAttrROA ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t8E00000BnteBQAR","attributeid__c":"a0X8E0000051NNsUAM","attributecategoryid__c":"a0W8E000005GM9oUAG","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ROAMING_VOIX_SMS","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Roaming","displaysequence__c":null,"categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":null,"querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U8E000008D8owUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Radiobutton","value__c":"Roaming Voix+SMS","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Radiobutton","default":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}],"values":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"},{"value":"Roaming Voix+SMS+Data","sequence":20,"id":"d97b0953-68d9-fc93-fc8a-ef12ac3070a6","displayText":"Roaming Voix+SMS+Data"}],"selectedItem":{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
			
          	OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Change', Product2Id = prod2.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem2;
        
          	OrderItem newOrderitem3 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod3.Id, vlocity_cmt__JSONAttribute__c = '', PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem3;
           
        	

            
             //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;
        ////////
        inwiB2C_SMO_API__c NewSmoItem = new inwiB2C_SMO_API__c(name = '21277777777', Order__c=newOrder.Id,Asset__c=asset1.Id);
        insert NewSmoItem;
           
        inwiB2C_SMO_Option_API_Event__e EventItem = new inwiB2C_SMO_Option_API_Event__e(inwiB2C_SMO_API__c=NewSmoItem.Id);
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
        
      //  System.assertEquals(newSmoOptionItem2.CodeOption__c, 'INWIB2C_OFFERING_VMSCFWNR');
        
        //System.assertEquals(newSmoOptionItem1.CodeOption__c, 'INWIB2C_OFFERING_OPT_ROAMING');
        
        //System.assertEquals(newSmoOptionItem3.CodeOption__c, 'INWIB2C_OFFRING_VOLTE');
        //inwiB2C_SMO_Option_API_Event__e Item = new inwiB2C_SMO_Option_API_Event__e

    }
   
    public static testMethod void CaseCancel() {
       		Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            /* Begin JBE */
           

            
            Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware',ProductCode='INWIB2C_OFFERING_SIM');
            insert prod;

            Product2 prod2 = new Product2(Name = 'Options Roaming', 
            Family = 'None',
            ProductCode='INWIB2C_OFFERING_OPT_ROAMING');
            insert prod2;
            
        
            Product2 prod3 = new Product2(Name = 'Service Roaming', 
            Family = 'None',
            ProductCode='INWIB2C_OFFERING_SRV_ROAMING');
            insert prod3;
            
           Product2 prod4 = new Product2(Name = 'Volte', 
            Family = 'None',
            ProductCode='INWIB2C_OFFRING_VOLTE');
            insert prod4;
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            

            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;

        
        
          

            
            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
            String JsonAttrROA ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t8E00000BnteBQAR","attributeid__c":"a0X8E0000051NNsUAM","attributecategoryid__c":"a0W8E000005GM9oUAG","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ROAMING_VOIX_SMS","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Roaming","displaysequence__c":null,"categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":null,"querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U8E000008D8owUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Radiobutton","value__c":"Roaming Voix+SMS","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Radiobutton","default":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}],"values":[{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"},{"value":"Roaming Voix+SMS+Data","sequence":20,"id":"d97b0953-68d9-fc93-fc8a-ef12ac3070a6","displayText":"Roaming Voix+SMS+Data"}],"selectedItem":{"value":"Roaming Voix+SMS","sequence":10,"id":"f33ec679-fb6f-730b-772a-6eb22ab1fc9b","displayText":"Roaming Voix+SMS"}},"$$AttributeDefinitionEnd$$":null}]}';
			OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
			
          	OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod2.Id, vlocity_cmt__JSONAttribute__c = JsonAttrROA, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem2;
        
          	OrderItem newOrderitem3 = new OrderItem(vlocity_cmt__Action__c = 'Existing', Product2Id = prod3.Id, vlocity_cmt__JSONAttribute__c = '', PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem3;
           
        	

            
             //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;
        ////////
        inwiB2C_SMO_API__c NewSmoItem = new inwiB2C_SMO_API__c(name = '21277777777', Order__c=newOrder.Id,Asset__c=asset1.Id);
        insert NewSmoItem;
           
        inwiB2C_SMO_Option_API_Event__e EventItem = new inwiB2C_SMO_Option_API_Event__e(inwiB2C_SMO_API__c=NewSmoItem.Id);
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
        
      //  System.assertEquals(newSmoOptionItem2.CodeOption__c, 'INWIB2C_OFFERING_VMSCFWNR');
        
        //System.assertEquals(newSmoOptionItem1.CodeOption__c, 'INWIB2C_OFFERING_OPT_ROAMING');
        
        //System.assertEquals(newSmoOptionItem3.CodeOption__c, 'INWIB2C_OFFRING_VOLTE');
        //inwiB2C_SMO_Option_API_Event__e Item = new inwiB2C_SMO_Option_API_Event__e

    } 
 
}