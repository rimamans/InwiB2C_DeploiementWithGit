/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-09-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class InwiB2C_DeleteInventoryItemsForAsset implements vlocity_cmt.VlocityOpenInterface2 {

    // Méthode pour appeler les différentes méthodes de la classe en fonction du 'methodName'
    global static boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        Boolean result = true;
        try {
            if (methodName.equals('DeleteInventoryItemsForAsset')) {
                // Récupérez l'Id de l'asset à partir du paramètre 'input'
                Id assetId = (Id) input.get('assetId');
                // Appelez la méthode 'DeleteInventoryItemsForAsset'
                 DeleteInventoryItemsForAsset(assetId);
            }
        } catch (Exception e) {
            result = false;
        }
        return result;
    }

    // Méthode pour supprimer les inventory items d'un asset
    global static void DeleteInventoryItemsForAsset(Id assetId) {
        // Récupérez les relations d'éléments de l'inventaire associées à l'asset
        List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listOfInventoryItemRels = [
            SELECT Id, vlocity_cmt__DestinationInventoryItemId__c 
            FROM vlocity_cmt__InventoryItemDecompositionRelationship__c 
            WHERE vlocity_cmt__SourceAssetId__c = :assetId
        ];

        // Récupérez les Ids des inventory items associés à l'asset
        List<Id> listOfInventoryItemRelIds = new List<Id>();
        for (vlocity_cmt__InventoryItemDecompositionRelationship__c InventoryItemRel : listOfInventoryItemRels) {
            listOfInventoryItemRelIds.add(InventoryItemRel.vlocity_cmt__DestinationInventoryItemId__c);
        }

        // Récupérez les inventory items associés à l'asset
        List<vlocity_cmt__InventoryItem__c> listInventoryItems = [
            SELECT Id 
            FROM vlocity_cmt__InventoryItem__c  
            WHERE Id IN :listOfInventoryItemRelIds
        ];

        // Supprimez les relations d'éléments de l'inventaire et les inventory items
        delete listOfInventoryItemRels;
        delete listInventoryItems;
    }
}