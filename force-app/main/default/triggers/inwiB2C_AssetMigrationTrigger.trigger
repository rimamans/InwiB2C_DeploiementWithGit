trigger inwiB2C_AssetMigrationTrigger on Asset (after insert) {

    Set<Id> assetIdSet = trigger.newMap.keySet();
    List<Asset> assetsToUpdateList = [SELECT ProductCode, Id, ParentId, vlocity_cmt__ParentItemId__c, RootAssetId, vlocity_cmt__RootItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where inwiB2C_Legacy_Id__c != null and id in :assetIdSet];


    for (Asset assetToUpdate: assetsToUpdateList){
        assetToUpdate.vlocity_cmt__ParentItemId__c = assetToUpdate.ParentId;
        assetToUpdate.vlocity_cmt__RootItemId__c = assetToUpdate.RootAssetId;
        if (assetToUpdate.AssetLevel == 1){
            assetToUpdate.vlocity_cmt__ProductHierarchyPath__c = assetToUpdate.Product2Id;
            assetToUpdate.vlocity_cmt__ProductHierarchyGroupKeyPath__c = assetToUpdate.vlocity_cmt__ProductGroupKey__c;

        }else if (assetToUpdate.AssetLevel == 2){
            assetToUpdate.vlocity_cmt__ProductHierarchyPath__c = assetToUpdate.Parent.Product2Id + '<' + assetToUpdate.Product2Id;
            assetToUpdate.vlocity_cmt__ProductHierarchyGroupKeyPath__c = assetToUpdate.Parent.vlocity_cmt__ProductGroupKey__c + '<' + assetToUpdate.vlocity_cmt__ProductGroupKey__c ;

        }else if (assetToUpdate.AssetLevel == 3){
            assetToUpdate.vlocity_cmt__ProductHierarchyPath__c =  assetToUpdate.Parent.Parent.Product2Id + '<' + assetToUpdate.Parent.Product2Id + '<' + assetToUpdate.Product2Id ;
            assetToUpdate.vlocity_cmt__ProductHierarchyGroupKeyPath__c = assetToUpdate.Parent.Parent.vlocity_cmt__ProductGroupKey__c + '<' + assetToUpdate.Parent.vlocity_cmt__ProductGroupKey__c + '<' + assetToUpdate.vlocity_cmt__ProductGroupKey__c ;

        }
    }

    update assetsToUpdateList;



}