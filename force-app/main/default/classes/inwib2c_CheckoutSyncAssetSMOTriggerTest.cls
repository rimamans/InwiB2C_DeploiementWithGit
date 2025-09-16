@isTest
public class inwib2c_CheckoutSyncAssetSMOTriggerTest {
  public static testMethod void inwib2c_CheckoutSyncAssetSMOTriggerTest() {
      Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;


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

        order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder;
         
        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';
                
        OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
        insert newOrderitem;

        vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223355',Inwib2c_Num_ro_de_la_ligne__c='0177662233',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
        Insert newSubsc;

        INWIB2C_REQ_PORTA__c porta = new INWIB2C_REQ_PORTA__c(INWIB2C_Order__c=neworder.Id,Name=neworder.Id,INWIB2C_ACTION_CODE__c='DEACTIVATION',INWIB2C_STATUT__c = 'NEW', INWIB2C_NEWROUTE__c = 'D77', INWIB2C_PORTED_MDN__c = '0177662233', INWIB2C_SOA_UID__c='f975f115-dcc5-41fc-ad48-63a90f94425e',INWIB2C_SUBSCRIPTION__c=newSubsc.Id);
        insert porta;
      
		InwiB2C_Trace_API__c trace = new InwiB2C_Trace_API__c();
            trace.InwiB2C_MDN__c='212648069781';
     		trace.InwiB2C_request_body__c= '{"CSOperationInfo":"","CSCreateSMO":{"mdn":"212648068203","MotifSusp":"Perte / Vol","SuspType":"Total","actionType":"SUSP","canal":"inwiB2C_MyInwi"}}';  
            insert trace;
            
        /////////////////   
        inwiB2C_CheckoutSyncAssetSMO__e eventItem = new inwiB2C_CheckoutSyncAssetSMO__e(Step__c='checkout',OrderId__c=neworder.Id,TraceId__c=trace.Id,Source__c=null);     
 
      
        Test.startTest();
        Database.SaveResult results = EventBus.publish(eventItem);
        Test.stopTest();
  }
     
}