public with sharing class InwiB2C_DeferredMigrationBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
  Integer daysBefore = 3;
  Date todayDate = system.today();
  // Date todayDate = Date.newInstance(2022,03,01);
  List<Integer> daysList = new List<Integer>{  };
  public InwiB2C_DeferredMigrationBatch(){
  }

  public Database.querylocator start(Database.BatchableContext bc){
       //C.bani - CHECK IF THERE IS STILL A JOB RUNNING
        Id thisJobId = bc.getJobId();
        AsyncApexJob[] jobs = [select id from AsyncApexJob where status='Processing' AND ApexClass.Name = 'InwiB2C_DeferredMigrationBatch' and id != :thisJobId];
        
    if (!Test.isRunningTest()){
      for (integer i = 0; i <= daysBefore; i++){
        Date migrationDate = todayDate.addDays(i);
        Integer day = migrationDate.Day();
        daysList.add(day);
      }
    } else{
      daysList.add(18);
    }

System.debug('jobs: '+jobs);
    System.debug('daysList----');
    System.debug(daysList);
       if(jobs.IsEmpty() && !Test.isRunningTest()){
           String limitRecordsRetreived;
           limitRecordsRetreived = [Select MasterLabel, InwiB2C_LimitBulkBatch__c, Label from inwiB2C_DeferredMigrationLimit__mdt where label = 'DeferredMigration' limit 1].InwiB2C_LimitBulkBatch__c;
		   //System.debug('limit : '+limitRecordsRetreived);
		   return Database.getQueryLocator([SELECT Id, Cycle_de_facturation__c, Statut__c, Orchestration_Item_Id__c, Orchestration_Item_Id__r.vlocity_cmt__State__c, Order__c, Order__r.InwiB2C_isMigrationDeffered__c
                                 FROM InwiB2C_MIGRATIONDIFF__c
                                 WHERE Cycle_de_facturation__c in:daysList AND Statut__c = :'Waiting' AND Orchestration_Item_Id__c != '' AND  Orchestration_Item_Id__c != null  AND Order__c != '' AND  Order__c !=null AND Order__r.inwiB2C_Statut__c <> 'inwiB2C_Annulee' LIMIT :integer.valueof(limitRecordsRetreived)]);
  }
      else{
          return Database.getQueryLocator([SELECT Id, Cycle_de_facturation__c, Statut__c, Orchestration_Item_Id__c, Orchestration_Item_Id__r.vlocity_cmt__State__c, Order__c, Order__r.InwiB2C_isMigrationDeffered__c
                                 FROM InwiB2C_MIGRATIONDIFF__c
                                 WHERE Cycle_de_facturation__c in:daysList 
                                           AND Statut__c = :'Waiting' AND Orchestration_Item_Id__c != '' 
                                           AND  Orchestration_Item_Id__c != null  AND Order__c != '' AND  Order__c !=null 
                                           limit 1 ]);
      }  
      
     }

  public void execute(Database.BatchableContext bc, List<InwiB2C_MIGRATIONDIFF__c> scope){
   // System.debug('scopedata----');
    //System.debug(scope);
    List<InwiB2C_MIGRATIONDIFF__c> migList = new List<InwiB2C_MIGRATIONDIFF__c>();
   // List<vlocity_cmt__OrchestrationItem__c> orchestListP = new List<vlocity_cmt__OrchestrationItem__c>();
    List<vlocity_cmt__OrchestrationItem__c> orchestListC = new List<vlocity_cmt__OrchestrationItem__c>();
    List<Order> orderList = new List<Order>();
    for (InwiB2C_MIGRATIONDIFF__c migDiff : scope){
      migDiff.Statut__c = 'Completed';
      migList.add(migDiff);

  /*    vlocity_cmt__OrchestrationItem__c statePending = new vlocity_cmt__OrchestrationItem__c(id = migDiff.Orchestration_Item_Id__c, vlocity_cmt__State__c = 'Pending');
      if (!orchestListP.contains(statePending)){
        orchestListP.add(statePending);
      //  update orchestListP;
      }*/
      vlocity_cmt__OrchestrationItem__c stateCompleted = new vlocity_cmt__OrchestrationItem__c(id = migDiff.Orchestration_Item_Id__c, vlocity_cmt__State__c = 'Completed');
      if (!orchestListC.contains(stateCompleted)){
        orchestListC.add(stateCompleted);
     //   update orchestListC;
      }
      Order isMigrate = new Order(id = migDiff.Order__c, InwiB2C_isMigrationDeffered__c = true);
      if (!orderList.contains(isMigrate)){
        orderList.add(isMigrate);

       // update orderList;


      }
    }
      //update orchestListP;
      update orchestListC;
      update orderList;
      Update migList;
  }

  public void finish(Database.BatchableContext bc){
  }

}