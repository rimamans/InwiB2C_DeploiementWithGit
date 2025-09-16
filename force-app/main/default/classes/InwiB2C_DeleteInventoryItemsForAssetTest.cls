/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-07-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class InwiB2C_DeleteInventoryItemsForAssetTest {
    @isTest
    static void testInvokeMethod() {
        // Créez un nouvel asset pour le test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        Asset testAsset = new Asset(Name = 'Test Asset', AccountId = testAccount.Id);
        insert testAsset;

        // Appelez la méthode 'invokeMethod'
        Map<String, Object> input = new Map<String, Object>();
        input.put('assetId', testAsset.Id);
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Boolean result = InwiB2C_DeleteInventoryItemsForAsset.invokeMethod('DeleteInventoryItemsForAsset', input, output, options);

        // Vérifiez que la méthode a réussi
        System.assertEquals(true, result, 'La méthode a échoué');

        // Vérifiez que tous les inventory items associés à l'asset ont été supprimés
        List<vlocity_cmt__InventoryItem__c> inventoryItemsAfterDelete = [
            SELECT Id 
            FROM vlocity_cmt__InventoryItem__c  
            WHERE Id IN :getListInventoryItemRelIds(testAsset.Id)
        ];
        System.assertEquals(0, inventoryItemsAfterDelete.size(), 'Certains inventory items n\'ont pas été supprimés');
    }

    private static List<Id> getListInventoryItemRelIds(Id assetId) {
        List<Id> inventoryItemRelIds = new List<Id>();
        List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listOfInventoryItemRels = [
            SELECT Id, vlocity_cmt__DestinationInventoryItemId__c 
            FROM vlocity_cmt__InventoryItemDecompositionRelationship__c 
            WHERE vlocity_cmt__SourceAssetId__c = :assetId
        ];
        
        for (vlocity_cmt__InventoryItemDecompositionRelationship__c InventoryItemRel : listOfInventoryItemRels) {
            inventoryItemRelIds.add(InventoryItemRel.vlocity_cmt__DestinationInventoryItemId__c);
        }
        
        return inventoryItemRelIds;
    }
}