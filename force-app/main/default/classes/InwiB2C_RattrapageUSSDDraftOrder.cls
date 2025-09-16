public class InwiB2C_RattrapageUSSDDraftOrder implements Database.Batchable<sobject> {

    public Database.querylocator start(Database.BatchableContext BC){

            if(!Test.isRunningTest()) {

                String limitRecordsRetreived; limitRecordsRetreived = [Select MasterLabel, InwiB2C_LimitBulkBatch__c, Label from InwiB2C_CreateContractBulkLimit__mdt where label = 'InwiB2C_RattrapageActivationOrderLimit' limit 1].InwiB2C_LimitBulkBatch__c;


                String query = 'SELECT Id, inwiB2C_RootAssetId__c,inwiB2C_IdContract__c, inwiB2C_IdSubscription__c, inwiB2C_IdAccount__c, inwiB2C_CodeArticle__c, inwiB2C_SegmentLevel1__c, inwiB2C_Canal__c, inwiB2C_CodeDistributeur__c,  inwiB2C_Icc__c, inwiB2C_imsi__c, inwiB2C_Ki__c, inwiB2C_MdnDealer__c, inwiB2C_Mdn__c, inwiB2C_OcsId__c, inwiB2C_ProfileId__c, inwiB2C_Puk__c,   inwiB2C_uuid__c, InwiB2C_CorrelationId__c,inwiB2C_IdOrder__c FROM inwiB2C_CreateContractBulk__c WHERE inwiB2C_StatutDeTraitement__c    = \'inwiB2C_Termine\' and inwiB2C_IdOrder__r.Status = \'Draft\' and inwiB2C_IdOrder__r.inwiB2C_Statut__c not in (\'inwiB2C_Activation\',\'inwiB2C_Activee\') LIMIT '+ limitRecordsRetreived;
                return Database.getQueryLocator(query);
                    
            }
            else {
                return Database.getQueryLocator('SELECT Id, inwiB2C_RootAssetId__c,inwiB2C_IdContract__c, inwiB2C_IdSubscription__c, inwiB2C_IdAccount__c, inwiB2C_CodeArticle__c, inwiB2C_SegmentLevel1__c, inwiB2C_Canal__c, inwiB2C_CodeDistributeur__c,  inwiB2C_Icc__c, inwiB2C_imsi__c, inwiB2C_Ki__c, inwiB2C_MdnDealer__c, inwiB2C_Mdn__c, inwiB2C_OcsId__c, inwiB2C_ProfileId__c, inwiB2C_Puk__c,   inwiB2C_uuid__c, InwiB2C_CorrelationId__c,inwiB2C_IdOrder__c FROM inwiB2C_CreateContractBulk__c where inwiB2C_StatutDeTraitement__c    = \'inwiB2C_Termine\' and inwiB2C_IdOrder__r.Status = \'Draft\' and inwiB2C_IdOrder__r.inwiB2C_Statut__c not in (\'inwiB2C_Activation\',\'inwiB2C_Activee\') LIMIT 100  ');
            }
        }
    
    
    public void execute (Database.BatchableContext BC, List<sobject> scope) {
    
        //Get the ids of the Asset templates
        id assetIdTemplateDealer = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'AssetDealer' limit 1].InwiB2C_AssetId__c;
        id assetIdTemplate = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'TicTacAsset' limit 1].InwiB2C_AssetId__c;

        //get the list of the assets having as the rootitemid the template id
        List<Asset> genericAssetsDealer= [SELECT ProductCode, Name, Quantity, Id, vlocity_cmt__Action__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PriceListId__c, vlocity_cmt__PricebookEntryId__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c,Price, vlocity_cmt__LineNumber__c, ParentId, vlocity_cmt__ParentItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where vlocity_cmt__RootItemId__c = :assetIdTemplateDealer order by vlocity_cmt__SequenceNumber__c asc];
        List<Asset> genericAssetsTicTac= [SELECT ProductCode, Name, Quantity, Id, vlocity_cmt__Action__c,vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PriceListId__c, vlocity_cmt__PricebookEntryId__c,vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__SequenceNumber__c,vlocity_cmt__ServiceAccountId__c, Price, vlocity_cmt__LineNumber__c, ParentId, vlocity_cmt__ParentItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where vlocity_cmt__RootItemId__c = :assetIdTemplate order by vlocity_cmt__SequenceNumber__c asc];

        Map<string, List<Asset>> mapAssetByTempId = new Map<string, List<Asset>>();
		List<Asset> ListAssets = new List<Asset>();
		Map<String, String> mapAssetParentByTempId = new Map<String, String>();
        List<inwiB2C_OrderSubscription__c> ListOrdersSubs = new List<inwiB2C_OrderSubscription__c>();
        Map<String, String> mapSubscriptionByOrderId = new Map<String, String>();
		
		List<inwiB2C_CloneAssetEvent__e> cloneAssetListPE = new List<inwiB2C_CloneAssetEvent__e>();   
        List<inwiB2C_CloneOrderEvent__e> cloneOrderListPE = new List<inwiB2C_CloneOrderEvent__e>();    
		
		map<String, String> accountMapBOID = new map<String, String>();
        map<String, String> subscriptionsMap = new map<String, String>();
		
		List<Id> orderIdsList = new List<Id>();
		
        
        // Get Contract Bulk Ids from the created Assets to update
        for (sObject objScope: scope) {
            inwiB2C_CreateContractBulk__c newObjScope = (inwiB2C_CreateContractBulk__c)objScope;
			
			orderIdsList.add(newObjScope.inwiB2C_IdOrder__c);
			
			//Stock AccountId
			if (! accountMapBOID.containsKey(newObjScope.Id)){
                accountMapBOID.put(newObjScope.Id, newObjScope.inwiB2C_IdAccount__c);
            }

            //Stock SubscriptionId
			/*if (! subscriptionsMap.containsKey(newObjScope.Id)){
                subscriptionsMap.put(newObjScope.Id, newObjScope.inwiB2C_IdSubscription__c);
            }*/

			if (newObjScope.inwiB2C_SegmentLevel1__c == 'D' || newObjScope.inwiB2C_SegmentLevel1__c == 'SD') {
				List<Asset> ListAssetsForMapping = new List<Asset>();
				for (Asset assetToUpdate: genericAssetsDealer){
					Asset newAsset;
					newAsset = assetToUpdate.clone(false, true, false, true);
					newAsset.inwiB2C_TempId__c = newObjScope.Id;

					ListAssets.add(newAsset);
					ListAssetsForMapping.add(newAsset);
				}
					mapAssetByTempId.put(newObjScope.Id,ListAssetsForMapping);
				
				System.debug('Map Assets : '+ mapAssetByTempId);
				}
			else
			{
				List<Asset> ListAssetsForMapping = new List<Asset>();
				for (Asset assetToUpdate: genericAssetsTicTac){
					Asset newAsset;
					newAsset = assetToUpdate.clone(false, true, false, true);
					newAsset.inwiB2C_TempId__c = newObjScope.Id;

					ListAssets.add(newAsset);
					ListAssetsForMapping.add(newAsset);
				}
				if (ListAssetsForMapping.size() > 0){
					mapAssetByTempId.put(newObjScope.Id,ListAssetsForMapping);
				}
				System.debug('Map Assets : '+ mapAssetByTempId);
			}		
		}
		
        // GET ORDERS SUBSCRIPTIONS
        ListOrdersSubs = [ SELECT inwiB2C_Order__c, inwiB2C_Subscription__c from inwiB2C_OrderSubscription__c  where inwiB2C_Order__c in :orderIdsList];

        for (inwiB2C_OrderSubscription__c ordSubscriptionItem : ListOrdersSubs)
        { mapSubscriptionByOrderId.put(ordSubscriptionItem.inwiB2C_Order__c,ordSubscriptionItem.inwiB2C_Subscription__c);
        }


		        //Insert Assets
        for (Asset assetObj : ListAssets) {
            string accountId = accountMapBOID.get(assetObj.inwiB2C_TempId__c);
            assetObj.vlocity_cmt__BillingAccountId__c = accountId; 
            assetObj.AccountId = accountId;

        }
        insert ListAssets;
		
        Map<String,String> mapAssetLineNumber = new Map<String,String> ();
        for (Asset assetObj : ListAssets) {

            //string subsriptionId = subscriptionsMap.get(assetObj.inwiB2C_TempId__c).Id; 

            if (! mapAssetLineNumber.containsKey(assetObj.inwiB2C_TempId__c + '-' + assetObj.vlocity_cmt__LineNumber__c  )){
                mapAssetLineNumber.put(assetObj.inwiB2C_TempId__c + '-' + assetObj.vlocity_cmt__LineNumber__c,assetObj.id);
            }
        }    
        update ListAssets;
		
		//UPDATE ASSETS FIELDS
		        List<Asset> listUpdatedAsset = new List<Asset>();
        string assetLevel1Id;

        for (sObject objScope: scope) {
            inwiB2C_CreateContractBulk__c newObjScope = (inwiB2C_CreateContractBulk__c)objScope;

            if (accountMapBOID.containsKey(newObjScope.id)) {            
            
            Map<String, Asset> mapAssetLevel1 = new Map<String, Asset>();
            Map<String, Asset> mapAssetLevel2 = new Map<String, Asset>();
            
            List<Asset> listAssetToUpdate = new List<Asset>();
            listAssetToUpdate = mapAssetByTempId.get(newObjScope.Id);

            string subscriptionId;
            if (mapSubscriptionByOrderId.containsKey(newObjScope.inwiB2C_IdOrder__c)){
                subscriptionId = mapSubscriptionByOrderId.get(newObjScope.inwiB2C_IdOrder__c);  
            }   

            // JBEN - 20211124 - Get the asset parentId and update its fields - START 
            string assetLineNumber;
            //string assetLevel2Id = mapAssetLevel2.get(newObjScope.Id).Id;
            if(!Test.isRunningTest()) {
                for (Asset assetObj : listAssetToUpdate)
                {   
                    
                    if (assetObj.vlocity_cmt__LineNumber__c.length() == 4){
                        assetLineNumber = assetObj.vlocity_cmt__LineNumber__c;
                        assetLevel1Id = mapAssetLineNumber.get(assetObj.inwiB2C_TempId__c + '-' + assetLineNumber.substring(0,4));
                        System.debug('ASSET LEVEL 1 :'+ assetLevel1Id);
                        assetObj.vlocity_cmt__SubscriptionId__c = subscriptionId;
						mapAssetParentByTempId.put(newObjScope.Id, assetLevel1Id);
                        listUpdatedAsset.add(assetObj); break;
                        //assetObj.RootAssetId = assetLevel1Id;
                    }
                }
                // JBEN - 20211124 - Get the asset parentId and update its fields - END 

                for (Asset assetObj : listAssetToUpdate)
                {   
                    
                    string assetLevel2Id; assetLineNumber = assetObj.vlocity_cmt__LineNumber__c;
                    
                    if (assetObj.vlocity_cmt__LineNumber__c.length() == 9){
                        //assetObj.RootAssetId = assetLevel1Id;
                        System.debug('HERE ASSET2 ' + assetLevel1Id);
                        assetObj.vlocity_cmt__RootItemId__c = assetLevel1Id;
                        assetObj.ParentId = assetLevel1Id;
                        assetObj.vlocity_cmt__ParentItemId__c = assetLevel1Id;
                        listUpdatedAsset.add(assetObj);
                
                    }else if (assetObj.vlocity_cmt__LineNumber__c.length() == 14){
                        //assetObj.RootAssetId = assetLevel1Id;
                        assetLevel2Id = mapAssetLineNumber.get(assetObj.inwiB2C_TempId__c + '-' + assetLineNumber.substring(0,9));
                        System.debug('HERE ASSET3 '+assetLineNumber.substring(0,9) + '    ' + assetLineNumber);
                        assetObj.vlocity_cmt__RootItemId__c = assetLevel1Id;
                        assetObj.ParentId = assetLevel2Id;                                                  
                        assetObj.vlocity_cmt__ParentItemId__c = assetLevel2Id;
                        listUpdatedAsset.add(assetObj);
                    }
                    
                }
            }
            //JBEN -  Update Assets Fields - END
        }
    }
	
	//JBE - update Order fields - START
	/*List<Order> OrderlistToUpdate = [SELECT ID from order where id in :orderIdsList];
	for (Order OrderObj : OrderlistToUpdate)
	{
		OrderObj.inwiB2C_Statut__c = 'inwiB2C_Activee';
		OrderObj.status = 'Activated';
		OrderObj.vlocity_cmt__OrderStatus__c = 'Complete';
		OrderObj.vlocity_cmt__FulfilmentStatus__c = 'Activated';
	}
	update OrderlistToUpdate;*/
	//JBE - update Order fields - END
	
    for (sObject objScope: scope) {
        inwiB2C_CreateContractBulk__c newObjScope = (inwiB2C_CreateContractBulk__c)objScope;
		if (accountMapBOID.containsKey(newObjScope.id)) {
			
		inwiB2C_CloneAssetEvent__e cloneAssetObj = new inwiB2C_CloneAssetEvent__e();
        inwiB2C_CloneOrderEvent__e cloneOrderObj = new inwiB2C_CloneOrderEvent__e();
		
		cloneAssetObj.inwiB2C_CustomerId__c = newObjScope.inwiB2C_IdAccount__c;
		//cloneAssetObj.inwiB2C_CustomerId__c = accountIdDealer;	
		cloneAssetObj.inwiB2C_assetId__c = mapAssetParentByTempId.get(newObjScope.Id);
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
                             
        cloneOrderObj.inwiB2C_CustomerId__c = newObjScope.inwiB2C_IdAccount__c;
        cloneOrderObj.inwiB2C_OrderId__c = newObjScope.inwiB2C_IdOrder__c;
        cloneOrderObj.inwiB2C_Icc__c = newObjScope.inwiB2C_Icc__c;
        cloneOrderObj.inwiB2C_imsi__c = newObjScope.inwiB2C_imsi__c;
        cloneOrderObj.inwiB2C_ki__c = newObjScope.inwiB2C_Ki__c;
        cloneOrderObj.inwiB2C_Mdn__c = newObjScope.inwiB2C_Mdn__c;
        cloneOrderObj.inwiB2C_ProfileId__c = newObjScope.inwiB2C_ProfileId__c;
        cloneOrderObj.inwiB2C_puk__c = newObjScope.inwiB2C_Puk__c;
        cloneOrderObj.inwiB2C_SimOCSID__c = newObjScope.inwiB2C_OcsId__c;
        cloneOrderObj.inwiB2C_MdnOCSID__c = newObjScope.inwiB2C_OcsId__c;
        cloneOrderObj.inwiB2C_CodeArticle__c = newObjScope.inwiB2C_CodeArticle__c;
        cloneOrderObj.inwiB2C_IdCreateContractBulk__c = newObjScope.id;
        cloneOrderObj.inwiB2C_ContratId__c=newObjScope.inwiB2C_IdContract__c;
        cloneOrderObj.inwiB2C_UpdateAttribute__c = true;
        cloneOrderObj.inwiB2C_CheckOut__c= true;
        
        cloneOrderListPE.add(cloneOrderObj);
                

		newObjScope.inwiB2C_RootAssetId__c = mapAssetParentByTempId.get(newObjScope.Id);
        newObjScope.inwiB2C_IdSubscription__c = mapSubscriptionByOrderId.get(newObjScope.inwiB2C_IdOrder__c);

		
		system.debug('PE Clone asset : '+ cloneAssetObj);
		}
	}
	Update scope;
    update listUpdatedAsset;
    if(!Test.isRunningTest()) {
        List<Database.SaveResult> results = EventBus.publish(cloneOrderListPE);
        List<Database.SaveResult> resultsAssets = EventBus.publish(cloneAssetListPE);
    }
	
    
    }

    public void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [Select a.id, a.TotalJobItems, a.Status, a.NumberOfErrors,
                          a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
                          a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] email = new String[]{'prod.salesforceb2c@inwi.ma'};
        string mailsubject;
        string mailsubject1;
        string mailsubject2;
        string mailsubject3;
        string mailsubject4;
        mail.setToAddresses(email);
        mail.setReplyTo('prod.salesforceb2c@inwi.ma');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process '+a.Status);
        mail.setPlainTextBody('The Batch Apex job ('+ a.id +') processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}