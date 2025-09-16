public class Inwib2c_CreateMassInventoryItems implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String Query;
    public Inwib2c_CreateMassInventoryItems(){
        
    }
    public Database.querylocator start(Database.BatchableContext BC){
        		system.debug('in Start');
                String limitRecordsRetreived;
                limitRecordsRetreived = [Select MasterLabel, inwiB2C_LimitCreateInventoryItem__c, Label from inwiB2C_Limite_Create_MassInventoryItems__mdt   where Label = 'InventoryItemLimit' limit 1].inwiB2C_LimitCreateInventoryItem__c;         
                Query='SELECT InwiB2C_AssetId__c, InwiB2C_Statut__c From InwiB2C_MigratedAssets__c WHERE  InwiB2C_Statut__c=\'New\' Limit '+limitRecordsRetreived;
               
               return Database.getQueryLocator(Query);
    }
    
    public void execute(Database.BatchableContext BC, List<InwiB2C_MigratedAssets__c> scope){
         List<InwiB2C_Asset_Migration_Event__e> Asset_Migration_Event = new List<InwiB2C_Asset_Migration_Event__e>();

         system.debug('in Execute');
         System.debug(scope);
      
        for(InwiB2C_MigratedAssets__c  assetMigration: scope){
            InwiB2C_Asset_Migration_Event__e  NewActionEvent = new InwiB2C_Asset_Migration_Event__e();
            
  			NewActionEvent.MigrationAssetId__c = assetMigration.id;
            NewActionEvent.AssetId__c=assetMigration.InwiB2C_AssetId__c;  
            NewActionEvent.Step__c='CreateOrder';
            
         	Asset_Migration_Event.Add(NewActionEvent);
            system.debug('eventaction'+Asset_Migration_Event);
            assetMigration.InwiB2C_Statut__c='Processing';
		    
        }
        System.debug(Asset_Migration_Event);
         List<Database.SaveResult> results = EventBus.publish(Asset_Migration_Event);
         update scope;
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }

}