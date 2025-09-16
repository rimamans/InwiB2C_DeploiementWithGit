@isTest
private class inwiB2C_BatchRattrapageMigrationFTTHTest {

    @isTest
    static void testBatchExecution() {
        Account accountTest= new Account(
        Name='TestMigrationFTTH',
        vlocity_cmt__Status__c ='Nouveau' );
        insert accountTest;
        Asset parentAsset = new Asset(
            Name = 'Parent Asset',
            AccountId = accountTest.Id
        );
        insert parentAsset;

        Asset childAsset = new Asset(
            Name = 'Child Asset',
            AccountId = accountTest.Id,
            vlocity_cmt__RootItemId__c = parentAsset.Id
        );
        insert childAsset;
/*
        vlocity_cmt__InventoryItem__c inventoryItem = new vlocity_cmt__InventoryItem__c();
        insert inventoryItem;

        vlocity_cmt__InventoryItemDecompositionRelationship__c decompositionRel = new vlocity_cmt__InventoryItemDecompositionRelationship__c(
            vlocity_cmt__SourceAssetId__c = parentAsset.Id,
            vlocity_cmt__DestinationInventoryItemId__c = inventoryItem.Id
        );
        insert decompositionRel;
*/
        inwiB2C_Rattrapage_MigrationFTTH__c rattrapage = new inwiB2C_Rattrapage_MigrationFTTH__c(
            inwiB2C_Statut__c = 'inwiB2C_Nouveau',
            inwib2C_Asset__c = parentAsset.Id
        );
        insert rattrapage;

        Test.startTest();
        inwiB2C_BatchRattrapageMigrationFTTH batch = new inwiB2C_BatchRattrapageMigrationFTTH();
        Database.executeBatch(batch, 100);
        Test.stopTest();

        rattrapage = [SELECT inwiB2C_Statut__c FROM inwiB2C_Rattrapage_MigrationFTTH__c WHERE Id = :rattrapage.Id];
        System.assertEquals('InwiB2C_Finalise', rattrapage.inwiB2C_Statut__c, 'Rattrapage status should be updated');
    }
}