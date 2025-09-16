/**
 * @author            : LAKRARI Imane
 * @created on		  :	27-12-2022
 * @last modified on  : 27-12-2022
**/
@isTest
public class InwiB2C_WaitBeforeCycleBatchTest {
    @testSetup
    static void setup() {
        //get today's day for cycle 
        DateTime td = System.now();
		Integer cycle=td.day();
        //Creer OI
        vlocity_cmt__OrchestrationPlan__c planId = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress');
        insert planId;
        vlocity_cmt__OrchestrationItem__c OI = new vlocity_cmt__OrchestrationItem__c(Name = 'Wait before Cycle', vlocity_cmt__State__c = 'Fatally Failed',vlocity_cmt__OrchestrationPlanId__c = planId.Id);
        insert OI;
        
        //Create InwiB2C_WaitForCycle__c
        //InwiB2C_WaitForCycle__c wfc = new InwiB2C_WaitForCycle__c(InwiB2C_Statut__c='waiting',InwiB2C_Orchestration_Item__c=OI.Id,InwiB2C_Cycle_de_facturation__c=cycle);
        //insert wfc;
    }
     @isTest static void test() {
        Test.startTest();
        InwiB2C_WaitBeforeCycleBatch WFCB = new InwiB2C_WaitBeforeCycleBatch();
        Id batchId = Database.executeBatch(WFCB);
        Test.stopTest();
    }
}