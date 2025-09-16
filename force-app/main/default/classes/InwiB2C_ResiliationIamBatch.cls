public class InwiB2C_ResiliationIamBatch implements Database.Batchable<sObject>{
    
    public Database.querylocator start(Database.BatchableContext bc){
        DateTime td = System.now();
		Datetime delai48 = Datetime.newInstance(td.date().addDays(-2),td.time());
        return Database.getQueryLocator([select id from vlocity_cmt__OrchestrationItem__c where name ='Notification Resiliation IAM' and vlocity_cmt__State__c='Running' and CreatedDate <:delai48]);
	}
    
     public void execute(Database.BatchableContext bc, List<vlocity_cmt__OrchestrationItem__c> scope){

        for (vlocity_cmt__OrchestrationItem__c orcestrationItem: scope){
            orcestrationItem.vlocity_cmt__State__c = 'Completed';
        }
        update scope;
    }


    public void finish(Database.BatchableContext bc){
    }

}