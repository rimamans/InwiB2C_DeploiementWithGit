/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class InwiB2C_CancelOrderAndOPlanTriggerTest {
   
    @isTest
    public static void testCancelOrderAndOrchePlanTrigger(){

        Account testAccount = new Account();
        testAccount.Name = 'Test Account'; 
        insert testAccount;


        Order testOrder = new Order();
        testOrder.Name = 'Test Order';
        testOrder.Status = 'Draft';
        testOrder.EffectiveDate = Date.today();
        testOrder.AccountId = testAccount.Id;
        testOrder.inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition';
        insert testOrder;


        
        vlocity_cmt__OrchestrationPlan__c Testplan = new vlocity_cmt__OrchestrationPlan__c();
        Testplan.vlocity_cmt__State__c = 'InProgress';
        insert Testplan;

        InwiB2C_CancelOrderAndOrchestarionPlan__e eventRecord = new InwiB2C_CancelOrderAndOrchestarionPlan__e(
            InwiB2C_OrderId__c = testOrder.Id,
            InwiB2C_OrchestrationPlanId__c = Testplan.Id
        );

        
        Test.startTest();
        EventBus.publish(eventRecord);
        Test.stopTest();
        

        vlocity_cmt__OrchestrationPlan__c updatedPlan = [SELECT vlocity_cmt__State__c FROM vlocity_cmt__OrchestrationPlan__c WHERE Id = :Testplan.Id];
        System.assertEquals('Frozen', updatedPlan.vlocity_cmt__State__c, 'Le statut du plan d\'orchestration devrait être mis à jour en Frozen');
    }
}