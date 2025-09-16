@isTest
public class InwiB2C_ResiliationIamBatchTest {
    @testSetup
    static void setup() {
        vlocity_cmt__OrchestrationPlan__c planId = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress');
        insert planId;
        vlocity_cmt__OrchestrationItem__c OI = new vlocity_cmt__OrchestrationItem__c(Name = 'Notification Resiliation IAM', vlocity_cmt__State__c = 'Running',vlocity_cmt__OrchestrationPlanId__c = planId.Id);
        insert OI;
        DateTime td = System.now();
		Datetime createdDatetime = Datetime.newInstance(td.date().addDays(-3),td.time());
        Test.setCreatedDate(OI.id, createdDatetime);
    }
    
      @isTest static void test() {
        Test.startTest();
        InwiB2C_ResiliationIamBatch ResilB = new InwiB2C_ResiliationIamBatch();
        Id batchId = Database.executeBatch(ResilB);
        Test.stopTest();
    }

}