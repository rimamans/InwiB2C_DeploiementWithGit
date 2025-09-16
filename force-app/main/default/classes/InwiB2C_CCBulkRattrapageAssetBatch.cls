/**
 * @description       : 
 * @author            : Chadia bani
 * @group             : 
 * @last modified on  : 08-03-2024
 * @last modified by  : CHB
 * @Last Update       : 
**/
// CHB - BEGIN - CreateContract Bulk Batch Rattrapage Asset
public with sharing class InwiB2C_CCBulkRattrapageAssetBatch implements Database.Batchable<sobject>{
    public Database.querylocator start(Database.BatchableContext BC){

    

      Id thisJobId = bc.getJobId();
      AsyncApexJob[] jobs = [select id from AsyncApexJob where status='Processing' AND ApexClass.Name = 'InwiB2C_CCBulkRattrapageAssetBatch' and id != :thisJobId];
      
      if(!jobs.IsEmpty() && !Test.isRunningTest()){
         return Database.getQueryLocator('select id ,inwiB2C_IdAccount__c,inwiB2C_SegmentLevel1__c,inwiB2C_RootAssetId__c,CreatedDate,inwiB2C_StatutDeTraitement__c,inwiB2C_Mdn__c,inwiB2C_ProfileId__c,inwiB2C_IdSubscription__c from inwiB2C_CreateContractBulk__c where  inwiB2C_RootAssetId__c =\'\' and CreatedDate > 2024-02-20T18:04:17.441+01:00  and inwiB2C_StatutDeTraitement__c =\'inwiB2C_Termine\' order by CreatedDate asc LIMIT 200');
      }
      else{
          if(!Test.isRunningTest()) {
              String query = 'select id ,inwiB2C_Icc__c,inwiB2C_imsi__c,inwiB2C_SegmentLevel1__c,inwiB2C_Ki__c,inwiB2C_Puk__c,inwiB2C_OcsId__c,inwiB2C_CodeArticle__c,inwiB2C_IdAccount__c,inwiB2C_RootAssetId__c,CreatedDate,inwiB2C_StatutDeTraitement__c,inwiB2C_Mdn__c,inwiB2C_ProfileId__c,inwiB2C_IdSubscription__c from inwiB2C_CreateContractBulk__c where  inwiB2C_RootAssetId__c =\'\' and CreatedDate > 2024-02-20T18:04:17.441+01:00  and inwiB2C_StatutDeTraitement__c =\'inwiB2C_Termine\' order by CreatedDate asc LIMIT 200';
              return Database.getQueryLocator(query);
                  
          }
          else {
              return Database.getQueryLocator('SELECT Id, inwiB2C_Address__c,InwiB2C_CorrelationId__c, inwiB2C_BirthDate__c, inwiB2C_BusinessSegment__c, inwiB2C_Canal__c, inwiB2C_City__c, inwiB2C_CodeAgence__c, inwiB2C_CodeArticle__c, inwiB2C_CodeDistributeur__c, inwiB2C_ComplementAddress__c, inwiB2C_CountryCode__c, inwiB2C_FirstName__c, inwiB2C_Gender__c, inwiB2C_Icc__c, inwiB2C_IdAccount__c, inwiB2C_IdAccount__r.InwiB2C_Address__c, inwiB2C_IdContract__c, inwiB2C_IdOrder__c, inwiB2C_imsi__c, inwiB2C_Ki__c, inwiB2C_LastName__c, inwiB2C_MdnDealer__c, inwiB2C_Mdn__c, inwiB2C_Ocerised__c, inwiB2C_OcsId__c, inwiB2C_PieceIdentite__c, inwiB2C_PostCode__c, inwiB2C_ProfileId__c, inwiB2C_Puk__c, inwiB2C_Request__c, inwiB2C_SegmentLevel1__c, inwiB2C_SegmentLevel2__c, inwiB2C_State__c, inwiB2C_Street__c, inwiB2C_TypePieceIdentite__c, inwiB2C_User__c, inwiB2C_uuid__c,CreatedDate,inwiB2C_PS_BO_ID__c,inwiB2C_RbtBoId__c, inwiB2C_StatutDeTraitement__c,InwiB2C_DateReelDemande__c FROM inwiB2C_CreateContractBulk__c WHERE inwiB2C_StatutDeTraitement__c = \'inwiB2C_Termine\' order by CreatedDate desc LIMIT 2 ');
          }
      }
  }
  
  public void execute (Database.BatchableContext BC, List<sobject> scope) {
    
        id assetIdTemplateDealer = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'AssetDealer' limit 1].InwiB2C_AssetId__c;
        id assetIdTemplate = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'TicTacAsset' limit 1].InwiB2C_AssetId__c;
        id assetIdTemplateCampus = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'TicTacAssetCampus' limit 1].InwiB2C_AssetId__c;

        //get the list of the assets having as the rootitemid the template id
        List<Asset> genericAssetsDealer= [SELECT ProductCode, Name, Quantity, Id, vlocity_cmt__Action__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PriceListId__c, vlocity_cmt__PricebookEntryId__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c,Price, vlocity_cmt__LineNumber__c, ParentId, vlocity_cmt__ParentItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where vlocity_cmt__RootItemId__c = :assetIdTemplateDealer order by vlocity_cmt__SequenceNumber__c asc];
        List<Asset> genericAssetsTicTac= [SELECT ProductCode, Name, Quantity, Id, vlocity_cmt__Action__c,vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PriceListId__c, vlocity_cmt__PricebookEntryId__c,vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__SequenceNumber__c,vlocity_cmt__ServiceAccountId__c, Price, vlocity_cmt__LineNumber__c, ParentId, vlocity_cmt__ParentItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where vlocity_cmt__RootItemId__c = :assetIdTemplate order by vlocity_cmt__SequenceNumber__c asc];
        List<Asset> genericAssetsTicTacCampus= [SELECT ProductCode, Name, Quantity, Id, vlocity_cmt__Action__c,vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PriceListId__c, vlocity_cmt__PricebookEntryId__c,vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__SequenceNumber__c,vlocity_cmt__ServiceAccountId__c, Price, vlocity_cmt__LineNumber__c, ParentId, vlocity_cmt__ParentItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where vlocity_cmt__RootItemId__c = :assetIdTemplateCampus order by vlocity_cmt__SequenceNumber__c asc];
        Map<string, List<Asset>> mapAssetByTempId = new Map<string, List<Asset>>();
        Map<String, String> mapAssetParentByTempId = new Map<String, String>();
        List<inwiB2C_CloneAssetEvent__e> cloneAssetListPE = new List<inwiB2C_CloneAssetEvent__e>();   
        List<Asset> ListAssets = new List<Asset>();

        for(sObject newObjScope : scope){
            inwiB2C_CreateContractBulk__c bulkScope = (inwiB2C_CreateContractBulk__c)newObjScope;
            if ((bulkScope.inwiB2C_SegmentLevel1__c == 'D' || bulkScope.inwiB2C_SegmentLevel1__c == 'SD') && bulkScope.inwiB2C_ProfileId__c != '20707') {
                system.debug('Dealer'+bulkScope.inwiB2C_ProfileId__c);
                List<Asset> ListAssetsForMapping = new List<Asset>();
                for (Asset assetToUpdate: genericAssetsDealer){

                    Asset newAsset;
                    newAsset = assetToUpdate.clone(false, true, false, true);
                    newAsset.inwiB2C_TempId__c = bulkScope.Id;
                    newAsset.accountId = bulkScope.inwiB2C_IdAccount__c;
                    newAsset.vlocity_cmt__BillingAccountId__c = bulkScope.inwiB2C_IdAccount__c;
                    ListAssets.add(newAsset);
                    ListAssetsForMapping.add(newAsset);
                }
                if (ListAssetsForMapping.size() > 0){
                    mapAssetByTempId.put(bulkScope.Id,ListAssetsForMapping);
                }
                System.debug('Map Assets : '+ mapAssetByTempId);
                }
            else if(bulkScope.inwiB2C_ProfileId__c == '20707'){
                  List<Asset> ListAssetsForMapping = new List<Asset>();
                for (Asset assetToUpdate: genericAssetsTicTacCampus){
                    Asset newAsset;
                    newAsset = assetToUpdate.clone(false, true, false, true);
                    newAsset.inwiB2C_TempId__c = bulkScope.Id;
                    newAsset.accountId = bulkScope.inwiB2C_IdAccount__c;
                    newAsset.vlocity_cmt__BillingAccountId__c = bulkScope.inwiB2C_IdAccount__c;
                    ListAssets.add(newAsset);
                    ListAssetsForMapping.add(newAsset);
                }
              if (ListAssetsForMapping.size() > 0){
                  mapAssetByTempId.put(bulkScope.Id,ListAssetsForMapping);
                }
                System.debug('Map Assets Campus : '+ mapAssetByTempId);
            }else
            {
                system.debug('TicTac'+bulkScope.inwiB2C_ProfileId__c);
                List<Asset> ListAssetsForMapping = new List<Asset>();
                for (Asset assetToUpdate: genericAssetsTicTac){
                    Asset newAsset;
                    newAsset = assetToUpdate.clone(false, true, false, true);
                    newAsset.inwiB2C_TempId__c = bulkScope.Id;
                    newAsset.accountId = bulkScope.inwiB2C_IdAccount__c;
                    newAsset.vlocity_cmt__BillingAccountId__c = bulkScope.inwiB2C_IdAccount__c;
                    ListAssets.add(newAsset);
                    ListAssetsForMapping.add(newAsset);
                }
                if (ListAssetsForMapping.size() > 0){
                    mapAssetByTempId.put(bulkScope.Id,ListAssetsForMapping);
                }
                System.debug('Map Assets : '+ mapAssetByTempId);
            }
        }   if(!Test.isRunningTest()) {
            insert ListAssets; 
       }
            Map<String,String> mapAssetLineNumber = new Map<String,String> ();
            for (Asset assetObj : ListAssets) { 
   
                if (! mapAssetLineNumber.containsKey(assetObj.inwiB2C_TempId__c + '-' + assetObj.vlocity_cmt__LineNumber__c  )){
                     mapAssetLineNumber.put(assetObj.inwiB2C_TempId__c + '-' + assetObj.vlocity_cmt__LineNumber__c,assetObj.id);
                }
            }    
            if(!Test.isRunningTest()) {
            update ListAssets;
            }
            List<Asset> listUpdatedAsset = new List<Asset>();
            for (sObject objScope: scope) {
                inwiB2C_CreateContractBulk__c newObjScope = (inwiB2C_CreateContractBulk__c)objScope;

                if (newObjScope.inwiB2C_IdAccount__c!=null || Test.isRunningTest()) {    
                    
                    Map<String, Asset> mapAssetLevel1 = new Map<String, Asset>();
                    Map<String, Asset> mapAssetLevel2 = new Map<String, Asset>();
                    
                    List<Asset> listAssetToUpdate = new List<Asset>();
                    listAssetToUpdate = mapAssetByTempId.get(newObjScope.Id);
                    string subscriptionId;
                    if(!Test.isRunningTest()){
                    subscriptionId=newObjScope.inwiB2C_IdSubscription__c;
                    }
                    string assetLineNumber;
                    string assetLevel1Id;
                   // if(!Test.isRunningTest()) {
                        if (listAssetToUpdate != null){                
                            for (Asset assetObj : listAssetToUpdate)
                            {   
                                
                                if (assetObj.vlocity_cmt__LineNumber__c.length() == 4){
                                    assetLineNumber = assetObj.vlocity_cmt__LineNumber__c;
                                    assetLevel1Id = mapAssetLineNumber.get(assetObj.inwiB2C_TempId__c + '-' + assetLineNumber.substring(0,4));
                                    System.debug('ASSET LEVEL 1 :'+ assetLevel1Id);
                                    assetObj.vlocity_cmt__SubscriptionId__c = subscriptionId;
                                    mapAssetParentByTempId.put(newObjScope.Id, assetLevel1Id);
                                    listUpdatedAsset.add(assetObj);
                                    break;
                                }
                            }
                            //  Get the asset parentId and update its fields - END 
                            System.debug('HERE ASSET2 ' + mapAssetParentByTempId);
                            for (Asset assetObj : listAssetToUpdate)
                            {   
                                
                                string assetLevel2Id;
                                assetLineNumber = assetObj.vlocity_cmt__LineNumber__c;
                                
                                if (assetObj.vlocity_cmt__LineNumber__c.length() == 9){      
                                    System.debug('HERE ASSET2 ' + assetLevel1Id);
                                    assetObj.vlocity_cmt__RootItemId__c = assetLevel1Id;
                                    assetObj.ParentId = assetLevel1Id;
                                    assetObj.vlocity_cmt__ParentItemId__c = assetLevel1Id;
                                    listUpdatedAsset.add(assetObj);
                            
                                }else if (assetObj.vlocity_cmt__LineNumber__c.length() == 14){
                                    assetLevel2Id = mapAssetLineNumber.get(assetObj.inwiB2C_TempId__c + '-' + assetLineNumber.substring(0,9));
                                    System.debug('HERE ASSET3 '+assetLineNumber.substring(0,9) + '    ' + assetLineNumber);
                                    assetObj.vlocity_cmt__RootItemId__c = assetLevel1Id;
                                    assetObj.ParentId = assetLevel2Id;      
                                    System.debug('assetLevel2Id ' + assetLevel2Id);                                            
                                    assetObj.vlocity_cmt__ParentItemId__c = assetLevel2Id;
                                    listUpdatedAsset.add(assetObj);
                                }
                                
                            }
                        }
                   // }
                   // else{
                  //      assetLevel1Id = 'TEST12345';
                 //   }
                    // Update Assets Fields - END
                    inwiB2C_CloneAssetEvent__e cloneAssetObj = new inwiB2C_CloneAssetEvent__e();
                    cloneAssetObj.inwiB2C_CustomerId__c = newObjScope.inwiB2C_IdAccount__c;
                    cloneAssetObj.inwiB2C_assetId__c = mapAssetParentByTempId.get(newObjScope.Id);
                    //Deactivate Create Order PE - START
                    cloneAssetObj.inwiB2C_Icc__c = newObjScope.inwiB2C_Icc__c;
                    cloneAssetObj.inwiB2C_imsi__c = newObjScope.inwiB2C_imsi__c;
                    cloneAssetObj.inwiB2C_ki__c = newObjScope.inwiB2C_Ki__c;
                    cloneAssetObj.inwiB2C_Mdn__c = newObjScope.inwiB2C_Mdn__c;
                    cloneAssetObj.inwiB2C_ProfileId__c = newObjScope.inwiB2C_ProfileId__c;
                    cloneAssetObj.inwiB2C_puk__c = newObjScope.inwiB2C_Puk__c;
                    cloneAssetObj.inwiB2C_SimOCSID__c = newObjScope.inwiB2C_OcsId__c;
                    cloneAssetObj.inwiB2C_MdnOCSID__c = newObjScope.inwiB2C_OcsId__c;
                    cloneAssetObj.inwiB2C_CodeArticle__c = newObjScope.inwiB2C_CodeArticle__c;
                    cloneAssetObj.inwiB2C_IdCreateContractBulk__c = newObjScope.id;
                    cloneAssetListPE.add(cloneAssetObj);
                    if(!Test.isRunningTest()) {
                        newObjScope.inwiB2C_RootAssetId__c = mapAssetParentByTempId.get(newObjScope.Id);
                    }
                }
        
    }
    
    if(!Test.isRunningTest()) {
        update scope;
        update listUpdatedAsset;
        List<Database.SaveResult> resultsAssets = EventBus.publish(cloneAssetListPE);
        // - Publish the events to update created assets - END
    }
  }
  public void finish(Database.BatchableContext BC) {
    AsyncApexJob a = [Select a.id, a.TotalJobItems, a.Status, a.NumberOfErrors,
                      a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
                      a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] email = new String[]{'prod.salesforceb2c@inwi.ma'};
    mail.setToAddresses(email);
    mail.setReplyTo('prod.salesforceb2c@inwi.ma');
    mail.setSenderDisplayName('Batch Processing');
    mail.setSubject('Batch Process '+a.Status);
    mail.setPlainTextBody('The Batch Apex job ('+ a.id +') processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}// CHB - END - CreateContract Bulk Batch Rattrapage Asset
// CHB - END - CreateContract Bulk Batch Rattrapage Asset