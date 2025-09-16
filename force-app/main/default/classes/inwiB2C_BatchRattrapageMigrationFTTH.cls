public with sharing class inwiB2C_BatchRattrapageMigrationFTTH implements Database.Batchable<SObject> {
    // SO-B 18/04/2025 : created the batch apex class
    // start method: get records from Rattrapage_MigrationFTTH
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            'SELECT Id, inwiB2C_Statut__c, inwib2C_Asset__c FROM inwiB2C_Rattrapage_MigrationFTTH__c WHERE inwiB2C_Statut__c = \'inwiB2C_Nouveau\' LIMIT 300'
            );
        
    }
    
    // execute method: update status to disconnect in assets and update disconnectdate, delete inventory items, update rattrapage_mgration status
    public void execute(Database.BatchableContext BC, List<inwiB2C_Rattrapage_MigrationFTTH__c> scope) {
        List<Id> listAssetID = new List<Id>();
        
        for (inwiB2C_Rattrapage_MigrationFTTH__c record : scope) {
            if (record.inwib2C_Asset__c != null) {
                listAssetID.add(record.inwib2C_Asset__c);
                
            }
            record.inwiB2C_Statut__c = 'InwiB2C_Finalise';
        }
        
        if (!listAssetID.isEmpty()) {
            // update child assets
            List<Asset> childAssets = [
                SELECT Id, Product2.Name, vlocity_cmt__Action__c, vlocity_cmt__DisconnectDate__c
                FROM Asset
                WHERE vlocity_cmt__RootItemId__c IN :listAssetID
            ];
            
            for (Asset asset : childAssets) {
                asset.vlocity_cmt__Action__c = 'Disconnect';
                asset.vlocity_cmt__DisconnectDate__c = Date.today();
            }
            
            if (!childAssets.isEmpty()) {
                update childAssets;
            }
            /*
            // delete inventory items
            List<vlocity_cmt__InventoryItemDecompositionRelationship__c> relationshipIds = [
                SELECT Id, vlocity_cmt__DestinationInventoryItemId__c
                FROM vlocity_cmt__InventoryItemDecompositionRelationship__c
                WHERE vlocity_cmt__SourceAssetId__c IN :listAssetID
            ];
            
            
            
            List<Id> inventoryItemIds = new List<Id>();
			
            for (vlocity_cmt__InventoryItemDecompositionRelationship__c rel : relationshipIds) {
                if (rel.vlocity_cmt__DestinationInventoryItemId__c != null) {
                    inventoryItemIds.add(rel.vlocity_cmt__DestinationInventoryItemId__c);
                }
            }
            
            // Ensuite, récupérer les objets InventoryItem à partir de ces Ids :
            List<vlocity_cmt__InventoryItem__c> inventoryItems = [
                SELECT Id FROM vlocity_cmt__InventoryItem__c WHERE Id IN :inventoryItemIds
            ];
            
             if (!relationshipIds.isEmpty()) {
                delete relationshipIds;
            } 
             if(!inventoryItems.isEmpty()){
                delete inventoryItems;
            }  */
              // update status of processed records
        
      
        update scope;
        }
        
     
    }
    
    public void finish(Database.BatchableContext BC) {
    }
}