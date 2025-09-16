/**
 * @author            : LAKRARI Imane
 * @created on		  :	26-12-2022
 * @last modified on  : 26-12-2022
**/

public with sharing class InwiB2C_WaitBeforeCycleBatch implements Database.Batchable<sObject> {
DateTime td = System.now();
Integer tdDay=td.day();
public Database.querylocator start(Database.BatchableContext bc){
      //recuperer les enregistrements avec statut waiting et cycle de facturation = today's day
    //return Database.getQueryLocator([select id,InwiB2C_Statut__c, InwiB2C_Orchestration_Item__c, InwiB2C_Cycle_de_facturation__c from InwiB2C_WaitForCycle__c where InwiB2C_Statut__c ='waiting' and InwiB2C_Orchestration_Item__c != null and InwiB2C_Cycle_de_facturation__c =: tdDay]);
    return Database.getQueryLocator([select id from vlocity_cmt__OrchestrationItem__c where name ='Wait before cycle' and vlocity_cmt__State__c in ('Fatally Failed','Failed')]);
}
    /*public void execute(Database.BatchableContext bc, List<InwiB2C_WaitForCycle__c> scope){
        List<InwiB2C_WaitForCycle__c> waitCycleList = new List<InwiB2C_WaitForCycle__c>();
        List<vlocity_cmt__OrchestrationItem__c> orchestList = new List<vlocity_cmt__OrchestrationItem__c>();
           
        for(InwiB2C_WaitForCycle__c tmpWFC : scope){
            //Changer le statut des records traités a completed
            tmpWFC.InwiB2C_Statut__c = 'completed';
            waitCycleList.add(tmpWFC);
            
            //changer le statut des OI a completed
            vlocity_cmt__OrchestrationItem__c stateCompleted = new vlocity_cmt__OrchestrationItem__c(id=tmpWFC.InwiB2C_Orchestration_Item__c,vlocity_cmt__State__c = 'Completed',vlocity_cmt__Response__c='SUCCESS');
                  if (!orchestList.contains(stateCompleted))
        				orchestList.add(stateCompleted);
        }
        
        //Update
        update waitCycleList;
        update orchestList;
        

    }*/

    public void execute(Database.BatchableContext bc, List<vlocity_cmt__OrchestrationItem__c> scope){

        for (vlocity_cmt__OrchestrationItem__c orcestrationItem: scope){
            orcestrationItem.vlocity_cmt__State__c = 'Completed';
        }
        update scope;
    }


    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }

}