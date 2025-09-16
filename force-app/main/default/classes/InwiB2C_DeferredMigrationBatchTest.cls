@isTest
public class InwiB2C_DeferredMigrationBatchTest{
    @isTest(SeeAllData = true)
    public static void InwiB2C_DeferredMigrationBatchTest(){
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode = 'INWIB2C_OFFERING_SIM');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        // create contract
        Contract c = new Contract(AccountId = testAccount.Id, InwiB2C_statut_contrat__c = 'Initialise');
        insert c;
        order neworder = new Order(Pricebook2Id = customPB.Id, inwiB2C_Statut__c = 'inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId = testAccount.Id, contractId = c.id);
        insert neworder;

        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003WKyfEAG", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ICCID", "attributeconfigurable__c": true, "attributedisplaysequence__c": "35", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "ICCID", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmHzEAI", "isrequired__c": true, "rulemessage__c": null, "uidisplaytype__c": "Text", "value__c": null, "valuedatatype__c": "Text", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Text", "uiDisplayType": "Text", "value": "892128510050200922" }, "$$AttributeDefinitionEnd$$": null },{ "$$AttributeDefinitionStart$$": null, "objectid__c": "01t2500000632KBAAY", "attributeid__c": "a0X25000003XKyNEAW", "attributecategoryid__c": "a0W25000003M2TZEA0", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_MODELE_CARTE_SIM", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Modèle Carte Sim", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": 56165, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U25000003mmnCEAQ", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "000056165", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "values": [{ "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } ], "selectedItem": { "displayText": "S.A SIM 4G BOUTIQUES PREPAID", "id": "87113dce-34ed-d476-7080-5782930ab5d9", "sequence": 10, "value": "000056165" } }, "$$AttributeDefinitionEnd$$": null }]}';

        OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId = customPrice.Id, OrderId = neworder.Id, Quantity = 1, UnitPrice = customPrice.UnitPrice, ServiceDate = Date.Today());
        insert newOrderitem;

        //Create and Insert Asset
        Asset asset1 = new Asset(Name = 'Test Asset', Status = 'Installed', AccountId = testAccount.Id, InstallDate = System.Today(), Product2Id = prod.Id, UsageEndDate = System.Today(), vlocity_cmt__OrderProductId__c = newOrderitem.Id);
        insert asset1;

        //ORCHESTRATION PLAN

        vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test', vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

        vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name = 'Billing Test');
        insert planDef1;

        vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(vlocity_cmt__OrchestrationPlanDefinitionId__c = planDef1.Id, Name = 'Generate Bill Manual Task', vlocity_cmt__itemImplementationId__c = itemImpl1.Id, vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

        insert itemDef1;

        vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress', vlocity_cmt__OrderId__c = neworder.Id);
        insert planId1;


        vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New', vlocity_cmt__OrchestrationPlanId__c = planId1.Id, vlocity_cmt__OrderId__c = neworder.Id);
        insert FRId1;


        vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add', vlocity_cmt__FulfilmentRequestID__c = FRId1.Id);
        insert FRLine1;


        vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
        insert FRLineDecom1;

        vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task', vlocity_cmt__OrchestrationPlanId__c = planId1.Id, vlocity_cmt__State__c = 'Completed', vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id, vlocity_cmt__OrderItemId__c = newOrderitem.Id);
        insert item3;

        System.debug('Item Name : ' + item3.Name);

        vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2', vlocity_cmt__OrchestrationPlanId__c = planId1.Id, vlocity_cmt__State__c = 'Completed', vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id, vlocity_cmt__OrderItemId__c = newOrderitem.Id);
        insert item4;


        List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
        allItemsGenBilling1.add(item3);
        allItemsGenBilling1.add(item4);

        //END OF ORECHESTRATION PLAN

        InwiB2C_MIGRATIONDIFF__c newMigg = new InwiB2C_MIGRATIONDIFF__c();
        newMigg.Name='Test12';
        newMigg.Cycle_de_facturation__c = 18;
        newMigg.Statut__c = 'Waiting';
        newMigg.Order__c=neworder.Id;
        newMigg.Orchestration_Item_Id__c = item3.Id;
        insert newMigg;


        Id batchId = Database.executeBatch(new InwiB2C_DeferredMigrationBatch());
       
    }

}