@isTest
public class InwiB2C_IntegProAsyncSysInterfVulaTest {
    
    @testSetup
    static void createData()
    {
        Product2 prod1 = new Product2 (Name='Triple Play Bundle Small', ProductCode = 'INWIB2C_OFFERING_TERMINAL_SEUL');
        Insert prod1;
        Pricebook2 standardBook =  new Pricebook2(Id = Test.getStandardPricebookId(), Name = 'TestPricebook5', IsActive = true);
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = standardBook.Id,
        Product2Id = prod1.Id, UnitPrice = 10, IsActive = true);
        Insert pbe1;
        Account acc = new Account(Name = 'Account B');
        Insert acc;
       
        //Order creation
        Order ordA = new Order(Pricebook2Id = standardBook.Id , AccountId = acc.Id, EffectiveDate = date.today(), Status = 'Draft');
        Insert ordA;
        List<vlocity_cmt__OrchestrationPlan__c> orchestrationPlan = new List<vlocity_cmt__OrchestrationPlan__c>{
            new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__OrderId__c = ordA.Id),
            new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__OrderId__c = ordA.Id),
            new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__OrderId__c = ordA.Id)
        };
        Insert orchestrationPlan;
        List<vlocity_cmt__OrchestrationItem__c> listOrchestrationItem = new List<vlocity_cmt__OrchestrationItem__c>{
           new vlocity_cmt__OrchestrationItem__c(vlocity_cmt__OrchestrationPlanId__c = orchestrationPlan.get(0).Id,vlocity_cmt__ResponseOmniDataTransformName__c='',name='Provision Mobile Offer'),
           new vlocity_cmt__OrchestrationItem__c(vlocity_cmt__OrchestrationPlanId__c = orchestrationPlan.get(1).Id,vlocity_cmt__ResponseOmniDataTransformName__c='',name='Provision Mobile Offer'),
           new vlocity_cmt__OrchestrationItem__c(vlocity_cmt__OrchestrationPlanId__c = orchestrationPlan.get(2).Id,vlocity_cmt__ResponseOmniDataTransformName__c='',name='Provision Mobile Offer')
        };
        Insert listOrchestrationItem;
        
    }
    @isTest
    public static void InwiB2C_IntegProAsyncSysInterfVulaTest()
    {
        InwiB2C_IntegProcedureAsyncSysInterfVula obj = new InwiB2C_IntegProcedureAsyncSysInterfVula();
    }
    
    @isTest
    public static void startBatchTest()
    {
        InwiB2C_IntegProcedureAsyncSysInterfVula obj = new InwiB2C_IntegProcedureAsyncSysInterfVula();
        obj.startBatch('https://www.example.com', 'PATH B');
    }
    @isTest
    public static void executeItemTest()
    {
        vlocity_cmt__OrchestrationItem__c orchestrationItem = [SELECT Id,vlocity_cmt__ResponseOmniDataTransformName__c, Name, vlocity_cmt__OrderItemId__c, vlocity_cmt__VlocityDataRaptorBundleId__r.Id, vlocity_cmt__OrchestrationItemDefinitionId__r.Id FROM vlocity_cmt__OrchestrationItem__c LIMIT 1];
        InwiB2C_IntegProcedureAsyncSysInterfVula obj = new InwiB2C_IntegProcedureAsyncSysInterfVula();
        obj.executeItem('https://www.example.com', 'PATH B', orchestrationItem);
    }
    
    @isTest
    public static void endBatchTest()
        {
        InwiB2C_IntegProcedureAsyncSysInterfVula obj = new InwiB2C_IntegProcedureAsyncSysInterfVula();
        obj.endBatch('https://www.example.com', 'PATH B');
    }
    
    @isTest
    public static void processResponseDeferredTest()
    {
        vlocity_cmt__OrchestrationItem__c orchestrationItem = [SELECT Id, Name, vlocity_cmt__ResponseOmniDataTransformName__c,vlocity_cmt__ResponseAttrsVlocityDataRaptorBundleId__c, vlocity_cmt__ResponseItemsVlocityDataRaptorBundleId__c, vlocity_cmt__ResponseVlocityDataRaptorBundleId__c, vlocity_cmt__OrderItemId__c, vlocity_cmt__VlocityDataRaptorBundleId__r.Id, vlocity_cmt__OrchestrationItemDefinitionId__r.Id FROM vlocity_cmt__OrchestrationItem__c LIMIT 1];
        InwiB2C_IntegProcedureAsyncSysInterfVula obj = new InwiB2C_IntegProcedureAsyncSysInterfVula();
        obj.processResponseDeferred(orchestrationItem, 'https://www.example.com', 'PATH B', null, new System.HttpResponse());
    }
    
    


}