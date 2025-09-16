public class InwiB2C_SubsMassProcessingBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
String query;
String email;
Id toUserId;
Id fromUserId;

/**B-8863  TMA 02/05/2023 Begin*/
//String cin;
/**B-8863  TMA 02/05/2023 End*/
public Database.querylocator start(Database.BatchableContext BC){
    
    Id thisJobId = bc.getJobId();
    AsyncApexJob[] jobs = [select id from AsyncApexJob where status='Processing' AND ApexClass.Name = '	InwiB2C_SubsMassProcessingBatch' and id != :thisJobId];
    
    if(!jobs.IsEmpty()){
        // RETURN 0 RECORDS SINCE A JOB IS STILL RUNNING
        return Database.getQueryLocator('select ID,INWIB2C_Origin__c, INWIB2C_MOTIF__c, INWIB2C_MDN__c,INWIB2C_ACTION__c from INWIB2C_SUBSMASSPROCESSING__c where INWIB2C_STATUT__c = \'ERROR_ERORR\' limit 1');
    }
    else{
        if(!Test.isRunningTest()) {
            String limitRecordsRetreived;
            limitRecordsRetreived = [Select MasterLabel, InwiB2C_LimitBulkBatch__c, Label from inwiB2C_SubsMassProcessingLimit__mdt  where Label = 'SubsMassProcessingLimitCycleVie' limit 1].InwiB2C_LimitBulkBatch__c;
            //String query = 'select ID, INWIB2C_MOTIF__c,INWIB2C_Origin__c, INWIB2C_MDN__c,INWIB2C_ACTION__c, CreatedDate from INWIB2C_SUBSMASSPROCESSING__c where INWIB2C_STATUT__c = \'NEW\' AND INWIB2C_Origin__c != \'IMX\'  AND INWIB2C_ACTION__c =\'RESIL\' ORDER BY CreatedDate asc limit '+ limitRecordsRetreived;
            //String query = 'select ID, INWIB2C_MOTIF__c,INWIB2C_Origin__c, INWIB2C_MDN__c,INWIB2C_ACTION__c, CreatedDate from INWIB2C_SUBSMASSPROCESSING__c where INWIB2C_STATUT__c = \'NEW\' AND INWIB2C_Origin__c != \'IMX\'  ORDER BY CreatedDate asc limit '+ limitRecordsRetreived;
            //String query = 'select ID, INWIB2C_MOTIF__c,INWIB2C_Origin__c, INWIB2C_MDN__c,INWIB2C_ACTION__c, CreatedDate from INWIB2C_SUBSMASSPROCESSING__c where INWIB2C_STATUT__c = \'NEW\' AND (INWIB2C_Origin__c != \'IMX\'  OR (INWIB2C_Origin__c = \'IMX\' and INWIB2C_ACTION__c !=\'RESIL\'))  ORDER BY CreatedDate asc limit '+ limitRecordsRetreived;
            //CHB 26/10/2023 ANO 9305
            //Saad Sujet TTM Arret Synchronisation 19/12/2023 begin
            //String query = 'select ID, INWIB2C_MOTIF__c,INWIB2C_Origin__c, INWIB2C_MDN__c,INWIB2C_ACTION__c, CreatedDate from INWIB2C_SUBSMASSPROCESSING__c where INWIB2C_STATUT__c = \'NEW\' AND INWIB2C_Origin__c = \'PLC\'   ORDER BY CreatedDate asc limit '+ limitRecordsRetreived;
            String query = 'select ID, INWIB2C_MOTIF__c,INWIB2C_Origin__c, INWIB2C_MDN__c,INWIB2C_ACTION__c, CreatedDate,InwiB2C_Operator__c from INWIB2C_SUBSMASSPROCESSING__c where INWIB2C_STATUT__c = \'NEW\' AND INWIB2C_Origin__c = \'PLC\'   ORDER BY CreatedDate asc limit '+ limitRecordsRetreived;
            //Saad Sujet TTM Arret Synchronisation 19/12/2023 end
            return Database.getQueryLocator(query);
        }
        else
        {
            return Database.getQueryLocator('select ID, INWIB2C_Origin__c, INWIB2C_MOTIF__c, INWIB2C_MDN__c,INWIB2C_ACTION__c, CreatedDate,InwiB2C_Operator__c from INWIB2C_SUBSMASSPROCESSING__c order by CreatedDate desc limit 50');
        }
        }
    }
 
public void execute(Database.BatchableContext BC, List<INWIB2C_SUBSMASSPROCESSING__c> scope){
    
   // Build map of mdn, Subscription
   Map<String, vlocity_cmt__Subscription__c> mapSubscriptionByMdn = new Map<String, vlocity_cmt__Subscription__c>();
   Map<String, List<vlocity_cmt__Subscription__c>> mapListSubscriptionsByMdn = new Map<String, List<vlocity_cmt__Subscription__c>>();
   List<String> listMdn = new List<String>();
   List<String> listSubscriptionIds = new List<String>();
   List<String> listAssetIds = new List<String>();
   Map<String, List<vlocity_cmt__InventoryItemDecompositionRelationship__c>> mapInventoryItemByAsset = new Map<String, List<vlocity_cmt__InventoryItemDecompositionRelationship__c>>();
   Map<String, vlocity_cmt__InventoryItemDecompositionRelationship__c> mapInventoryItemVoiceByAsset = new Map<String, vlocity_cmt__InventoryItemDecompositionRelationship__c>();
   Map<String, Asset> mapAssetBySubsId = new Map<String, Asset>();
 

   Map<String, List<Asset>> mapAssetListByRootAssetId = new Map<String, List<Asset>>();
    //CHB 20/06/2023 ajout de la logique pour traiter les doublons -ANO-B-9305 
   /* Map<String, INWIB2C_SUBSMASSPROCESSING__c> latestSubMassItemsByMdn = new Map<String, INWIB2C_SUBSMASSPROCESSING__c>();
    Map<String, INWIB2C_SUBSMASSPROCESSING__c> oldestSubMassItemsByMdn = new Map<String, INWIB2C_SUBSMASSPROCESSING__c>();
    List<Id> listMdnDuplicates = new List<Id>();*/
    for (INWIB2C_SUBSMASSPROCESSING__c SubMassItem : scope) {
      /*  if (!latestSubMassItemsByMdn.containsKey(SubMassItem.INWIB2C_MDN__c) ||
            SubMassItem.CreatedDate > latestSubMassItemsByMdn.get(SubMassItem.INWIB2C_MDN__c).CreatedDate) {
            latestSubMassItemsByMdn.put(SubMassItem.INWIB2C_MDN__c, SubMassItem);  
                if(!listMdn.contains(SubMassItem.INWIB2C_MDN__c)){*/
                listMdn.add(SubMassItem.INWIB2C_MDN__c);
                    
       /*         }
        }*/
     }
    /* 
     //pour selectionner les plus anciennes doublons
     List<INWIB2C_SUBSMASSPROCESSING__c> scope2 = latestSubMassItemsByMdn.values(); //new scope 2 CHB 20/06/2023 -ANO-B-9305 
     for(INWIB2C_SUBSMASSPROCESSING__c scope3 : scope2){
         listMdnDuplicates.add(scope3.Id);
     }
          
     for (INWIB2C_SUBSMASSPROCESSING__c SubMassItem : scope) {
     if (!listMdnDuplicates.contains(SubMassItem.Id) ) {
         oldestSubMassItemsByMdn.put(subMassItem.INWIB2C_MDN__c, subMassItem);}
     }

     List<INWIB2C_SUBSMASSPROCESSING__c> oldestDuplicates = new List<INWIB2C_SUBSMASSPROCESSING__c>(oldestSubMassItemsByMdn.values());
    for (INWIB2C_SUBSMASSPROCESSING__c subMassItem : oldestDuplicates) {
       subMassItem.INWIB2C_STATUT__c = 'Bypassed';
     }
   */
    List<vlocity_cmt__Subscription__c> listSubscriptions = new List<vlocity_cmt__Subscription__c>();
    if(!Test.isRunningTest()) {
    	listSubscriptions = [SELECT Id, Inwib2c_Num_ro_de_la_ligne__c,inwiB2C_managedInSF__c,inwib2c_inst_prod_id__c,  inwiB2C_LegacyStatus__c , inwiB2C_Statut__c, vlocity_cmt__Status__c,Inwib2C_Type_Offre__c, Inwib2c_Type_de_forfait__c, InwiB2C_Date_d_activation__c,vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.Inwib2c_CIN__c,vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.FirstName,vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.LastName,vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_Type_CIN__c FROM vlocity_cmt__Subscription__c where Inwib2c_Num_ro_de_la_ligne__c in :listMdn and inwiB2C_managedInSF__c = true and inwiB2C_Statut__c not in('InwiB2C_Expired','InwiB2C_ResylCycleVie')];
    }
    else
    {
        listSubscriptions = [SELECT Id, Inwib2c_Num_ro_de_la_ligne__c,vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.Inwib2c_CIN__c,inwiB2C_managedInSF__c,inwib2c_inst_prod_id__c,  inwiB2C_LegacyStatus__c , inwiB2C_Statut__c, vlocity_cmt__Status__c,Inwib2C_Type_Offre__c, Inwib2c_Type_de_forfait__c, InwiB2C_Date_d_activation__c FROM vlocity_cmt__Subscription__c WHERE Inwib2c_Num_ro_de_la_ligne__c in :listMdn  limit 50];

       // listSubscriptions = [SELECT Id, Inwib2c_Num_ro_de_la_ligne__c,inwiB2C_managedInSF__c,inwib2c_inst_prod_id__c,  inwiB2C_LegacyStatus__c , inwiB2C_Statut__c, vlocity_cmt__Status__c,Inwib2C_Type_Offre__c, Inwib2c_Type_de_forfait__c, InwiB2C_Date_d_activation__c,vlocity_cmt__AccountId__r.Inwib2c_CIN__c,vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.FirstName,vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.LastName,vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_Type_CIN__c FROM vlocity_cmt__Subscription__c WHERE Inwib2c_Num_ro_de_la_ligne__c in :listMdn  limit 50];
   
    }
    
    for (vlocity_cmt__Subscription__c subObj : listSubscriptions) {
        listSubscriptionIds.add(subObj.Id);
        mapSubscriptionByMdn.put(subObj.Inwib2c_Num_ro_de_la_ligne__c,subObj );
    }

    //JBEN - 07042022 - UPDATE LIST OF SUBSCRIPTIONS INSTEAD OF JUST ONE ELEMENT
    for (INWIB2C_SUBSMASSPROCESSING__c SubMassItem : scope) {
        List<vlocity_cmt__Subscription__c> NewListSubsByMdn = new List<vlocity_cmt__Subscription__c>();
        for (vlocity_cmt__Subscription__c subObj : listSubscriptions) {
            if (subObj.Inwib2c_Num_ro_de_la_ligne__c == SubMassItem.INWIB2C_MDN__c )
            {
                NewListSubsByMdn.add(subObj);
            }
        }
        mapListSubscriptionsByMdn.put(SubMassItem.INWIB2C_MDN__c, NewListSubsByMdn);
    }

    List<Asset> listAsset = [SELECT Id , vlocity_cmt__SubscriptionId__c, vlocity_cmt__JSONAttribute__c FROM Asset WHERE vlocity_cmt__SubscriptionId__c IN :listSubscriptionIds and vlocity_cmt__ParentItemId__c = null];
    for (Asset assetObj : listAsset) {
        listAssetIds.add(assetObj.Id);
        mapAssetBySubsId.put(assetObj.vlocity_cmt__SubscriptionId__c, assetObj);
        //mapSubscriptionByMdn.put(subObj.Inwib2c_Num_ro_de_la_ligne__c,subObj );
    }


// MGEN3675 TTM: Eclipse Offre 5G
    // GetAsset 5G
    List<Asset> listAsset5GToUpdate = [SELECT Id , vlocity_cmt__SubscriptionId__c, vlocity_cmt__Action__c, vlocity_cmt__RootItemId__c , vlocity_cmt__JSONAttribute__c 
                                       FROM Asset 
                                       WHERE Product2.Name = 'Service 5G' AND  vlocity_cmt__RootItemId__c in :listAssetIds];
    //Construct Map Of Asset 5G By ID asset Parent to update 
    Map<String, Asset> mapAsset5GListByRootAssetId = new Map<String, Asset>();
    List<String> listAsset5GIds = new List<String>();
    for (Asset rootAssetObj : listAsset) {
        //List<Asset> assetsByRootId = new List<Asset>();
        for(Asset assetObj : listAsset5GToUpdate) {
            listAsset5GIds.add(assetObj.Id);
            if (assetObj.vlocity_cmt__RootItemId__c == rootAssetObj.id){
                //assetsByRootId.add(assetObj);
                mapAsset5GListByRootAssetId.put(rootAssetObj.id, assetObj);
            }
        }
        
    }
    //MGEN3675 TTM: Eclipse Offre 5G



    //Build list asset and mapListAsset for Resiliation 
    List<Asset> listAssetToUpdate = [SELECT Id, vlocity_cmt__Action__c,vlocity_cmt__RootItemId__c FROM ASSET WHERE vlocity_cmt__RootItemId__c in :listAssetIds];
    for (Asset rootAssetObj : listAsset) {
        List<Asset> assetsByRootId = new List<Asset>();
        for(Asset assetObj : listAssetToUpdate) {
            if (assetObj.vlocity_cmt__RootItemId__c == rootAssetObj.id){
                assetsByRootId.add(assetObj);
            }
        }
        mapAssetListByRootAssetId.put(rootAssetObj.id, assetsByRootId);
    }
    List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listInventoryItems = [SELECT vlocity_cmt__DestinationInventoryItemId__c,vlocity_cmt__SourceAssetId__c,vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode  FROM vlocity_cmt__InventoryItemDecompositionRelationship__c WHERE  vlocity_cmt__SourceAssetId__c in :listAssetIds];
    //List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listInventoryItems = [SELECT vlocity_cmt__DestinationInventoryItemId__c,vlocity_cmt__SourceAssetId__c FROM vlocity_cmt__InventoryItemDecompositionRelationship__c WHERE vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode = 'INWIB2C_RFS_VOICE' AND  vlocity_cmt__SourceAssetId__c in :listAssetIds];
    for(Asset assetObj : listAssetToUpdate) {
        List<vlocity_cmt__InventoryItemDecompositionRelationship__c> inventoryItemListByAssetId = new List<vlocity_cmt__InventoryItemDecompositionRelationship__c>();
        for(vlocity_cmt__InventoryItemDecompositionRelationship__c inventoryItemObj :listInventoryItems )
        {
            if (assetObj.id == inventoryItemObj.vlocity_cmt__SourceAssetId__c){
                inventoryItemListByAssetId.add(inventoryItemObj);
                /*if (inventoryItemObj.vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode == 'INWIB2C_RFS_VOICE')
                {
                    mapInventoryItemVoiceByAsset.put (assetObj.id, inventoryItemObj);
                }*/
            }
        }
        mapInventoryItemByAsset.put(assetObj.id , inventoryItemListByAssetId);
    }

    //LDA - START : change update of JSON in mass

    List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listInventoryItemsRFSVoice = [SELECT vlocity_cmt__DestinationInventoryItemId__c,vlocity_cmt__SourceAssetId__c,vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode, vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c  FROM vlocity_cmt__InventoryItemDecompositionRelationship__c WHERE  vlocity_cmt__SourceAssetId__c in :listAssetIds and vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode = 'INWIB2C_RFS_VOICE'];
    //List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listInventoryItems = [SELECT vlocity_cmt__DestinationInventoryItemId__c,vlocity_cmt__SourceAssetId__c FROM vlocity_cmt__InventoryItemDecompositionRelationship__c WHERE vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode = 'INWIB2C_RFS_VOICE' AND  vlocity_cmt__SourceAssetId__c in :listAssetIds];
    for(Asset assetObj : listAssetToUpdate) {
        List<vlocity_cmt__InventoryItemDecompositionRelationship__c> inventoryItemListByAssetId = new List<vlocity_cmt__InventoryItemDecompositionRelationship__c>();
        for(vlocity_cmt__InventoryItemDecompositionRelationship__c inventoryItemObj :listInventoryItemsRFSVoice )
        {
            if (assetObj.id == inventoryItemObj.vlocity_cmt__SourceAssetId__c){
                //inventoryItemListByAssetId.add(inventoryItemObj);
                
                    mapInventoryItemVoiceByAsset.put (assetObj.id, inventoryItemObj);
            
            }
        }
        //mapInventoryItemByAsset.put(assetObj.id , inventoryItemListByAssetId);
    }

    //MGEN3675 TTM: Eclipse Offre 5G
   	//GET InventoryItem Service Data
        Map<String, vlocity_cmt__InventoryItemDecompositionRelationship__c> mapInventoryItemDataByAsset = new Map<String, vlocity_cmt__InventoryItemDecompositionRelationship__c>();
        List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listInventoryItemsRFSData = [SELECT vlocity_cmt__DestinationInventoryItemId__c,vlocity_cmt__SourceAssetId__c,vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode, vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c  FROM vlocity_cmt__InventoryItemDecompositionRelationship__c WHERE  vlocity_cmt__SourceAssetId__c in :listAsset5GIds and vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode = 'INWIB2C_RFS_DATA'];
        //List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listInventoryItems = [SELECT vlocity_cmt__DestinationInventoryItemId__c,vlocity_cmt__SourceAssetId__c FROM vlocity_cmt__InventoryItemDecompositionRelationship__c WHERE vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode = 'INWIB2C_RFS_VOICE' AND  vlocity_cmt__SourceAssetId__c in :listAssetIds];
        for(Asset assetObj : listAsset5GToUpdate) {
           // List<vlocity_cmt__InventoryItemDecompositionRelationship__c> inventoryItemListByAssetId = new List<vlocity_cmt__InventoryItemDecompositionRelationship__c>();
            for(vlocity_cmt__InventoryItemDecompositionRelationship__c inventoryItemObj :listInventoryItemsRFSData )
            {
                if (assetObj.id == inventoryItemObj.vlocity_cmt__SourceAssetId__c){
                    //inventoryItemListByAssetId.add(inventoryItemObj);
                    
                        mapInventoryItemDataByAsset.put(assetObj.id, inventoryItemObj);
                
                }
            }
            //mapInventoryItemByAsset.put(assetObj.id , inventoryItemListByAssetId);
        }
    //MGEN3675 TTM: Eclipse Offre 5G
    
    
    List<Asset> listAssetResilToDisconnect = new List<Asset>();
    List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listInventoryItemsResilToDelete = new List<vlocity_cmt__InventoryItemDecompositionRelationship__c>();
    List<vlocity_cmt__Subscription__c> listSubsToUpdate = new List<vlocity_cmt__Subscription__c>();
    List<InwiB2C_ErrorInSubsMass__c> listErrorsInSubsMass = new List<InwiB2C_ErrorInSubsMass__c>();
    List<inwiB2C_SubsMassProcessingEvt__e> subsMassListPE = new List<inwiB2C_SubsMassProcessingEvt__e>();  

    //LDA - START : change update of JSON in mass
    List <Asset> assetToUpdateList = new List<Asset>();
    List<vlocity_cmt__InventoryItem__c> inventoryItemToUpdate = new List<vlocity_cmt__InventoryItem__c>();
     //Saad Sujet TTM Arret Synchronisation 19/12/2023 begin
    List<InwiB2C_Demande_Restitution__c> listDemandeRestToInsert = new List<InwiB2C_Demande_Restitution__c>();
     //Saad Sujet TTM Arret Synchronisation 19/12/2023 end
    // LDA - END

    
   /*B-8863  TMA 02/05/2023 Begin*/
  // List < InwiB2C_BlackList__c > Blacklist = new List < InwiB2C_BlackList__c > ();
  // cin=listSubscriptions[0].vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c;
  // InwiB2C_BlackList__c [] Liststatusblack=[select InwiB2C_Status__c from InwiB2C_BlackList__c where InwiB2C_CIN__c =: cin limit 1];
  // InwiB2C_BlackList__c statusblack;
   /*B-8863  TMA 02/05/2023 End*/

    for (INWIB2C_SUBSMASSPROCESSING__c SubMassItem : scope) {
        if (mapSubscriptionByMdn.containsKey(SubMassItem.INWIB2C_MDN__c))
        {
            //JBEN - 07042022 - Update list of Subscriptions instead of one element
            Boolean foundSubscription = false;
            for(vlocity_cmt__Subscription__c SubscriptionObj : mapListSubscriptionsByMdn.get(SubMassItem.INWIB2C_MDN__c))
            {
                if(SubscriptionObj.InwiB2C_Date_d_activation__c < SubMassItem.CreatedDate ){
                    //GET ASSET AND INVENTORY ITEM
                    String AssetId;
                    String InventoryItemId;
                    //LDA - START : change update of JSON in mass
                    Asset currentAsset;

                    // MGEN3675 TTM: Eclipse Offre 5G
                    Asset asset5G;
                    vlocity_cmt__InventoryItemDecompositionRelationship__c InvItemDecom5G;
                    // MGEN3675 TTM: Eclipse Offre 5G
                

                    
                    vlocity_cmt__InventoryItemDecompositionRelationship__c currentInvItemDecom;
                    foundSubscription = true;
                    //LDA - END
                    if (mapAssetBySubsId.containsKey(SubscriptionObj.id))
                    {
                        AssetId = mapAssetBySubsId.get(SubscriptionObj.id).Id;
                        //LDA  : change update of JSON in mass
                        currentAsset =  mapAssetBySubsId.get(SubscriptionObj.id);


                        // MGEN3675 TTM: Eclipse Offre 5G
                        // Get Asset 5G to update
                         if (mapAsset5GListByRootAssetId.containsKey(AssetId)){
                            asset5G = mapAsset5GListByRootAssetId.get(AssetId);
                            invItemDecom5G = mapInventoryItemDataByAsset.get(asset5G.Id);
                        }
                        // MGEN3675 TTM: Eclipse Offre 5G

                    
                        if (mapInventoryItemVoiceByAsset.containsKey(AssetId))
                        {
                            InventoryItemId = mapInventoryItemVoiceByAsset.get(AssetId).Id;
                            //LDA - START : change update of JSON in mass
                            currentInvItemDecom = mapInventoryItemVoiceByAsset.get(AssetId);
                        }
                    }
                    else
                    {
                        SubMassItem.INWIB2C_STATUT__c ='ERROR';
                        SubMassItem.INWIB2C_DESCRIPTION__c = 'Asset introuvable';
                    }
                    //REHAB
                    if(SubMassItem.INWIB2C_ACTION__c == 'REHAB')
                    {
                        SubscriptionObj.inwiB2C_LegacyStatus__c = 'ACTIVE';
                        SubscriptionObj.inwiB2C_Statut__c = 'InwiB2C_Active';
                        SubscriptionObj.vlocity_cmt__Status__c = 'Active';

                        // MGEN3675 TTM: Eclipse Offre 5G
                         Map<String,String> asset5GAttributes = new Map<String,String>();
                        // MGEN3675 TTM: Eclipse Offre 5G

                        /**B-8863  TMA 02/05/2023Begin*/
                     /*   if(Liststatusblack.size()>0){
                            statusblack=Liststatusblack[0];
                            statusblack.InwiB2C_Status__c =false;
                            update statusblack;
                        }*/
                        /**B-8863  TMA 02/05/2023 End*/

                        
                        //Call DR To update InventoryItem and Asset
                        /*string datajsonRehab = '{"AssetId":"'+AssetId+'", "InventoryItemId":"'+InventoryItemId+'","appelEntrant":"Autorisé","appelSortant":"Autorisé" }';
                        vlocity_cmt.DRProcessResult resultUpdateRehab = vlocity_cmt.DRGlobal.processObjectsJSON(datajsonRehab, 'InwiB2C_DR_UpdateSubscriptionStatusAndAttributes');

                        Map<String, Object> resultMapRehab = resultUpdateRehab.convertToMap();*/
                        //LDA - START : change update of JSON in mass
                        Map<String,String> assetAttributes = new Map<String,String>();

                        assetAttributes.put('INWIB2C_ATT_RT_APPELS_ENRTANT', 'Autorisé');
                        assetAttributes.put('INWIB2C_ATT_RT_APPELS_SORTANT', 'Autorisé');


                        // MGEN3675 TTM: Eclipse Offre 5G
                        asset5GAttributes.put('INWIB2C_ATT_RT_SERVICE5G', 'En service');
                        // MGEN3675 TTM: Eclipse Offre 5G

                        if (currentAsset != null){
                            currentAsset.vlocity_cmt__JSONAttribute__c = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentAsset.vlocity_cmt__JSONAttribute__c, assetAttributes);
                            assetToUpdateList.add(currentAsset);

                        }

                        if (currentInvItemDecom != null){
                            Map<String,String> invItemAttributes = new Map<String,String>();

                            invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_IN', 'Autorisé');
                            invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_OUT', 'Autorisé');
                            String invItemJSON = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c, invItemAttributes);
                            inventoryItemToUpdate.add (new vlocity_cmt__InventoryItem__c(id=currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__c, vlocity_cmt__JSONAttribute__c=invItemJSON));

                        }

                        // MGEN3675 TTM: Eclipse Offre 5G
                        if (asset5G != null){
                           
                                        asset5G.vlocity_cmt__JSONAttribute__c = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(asset5G.vlocity_cmt__JSONAttribute__c, asset5GAttributes);
                                        assetToUpdateList.add(asset5G);
                                       
                                        
                                    
                            }
                                
                        if (invItemDecom5G != null){
                            Map<String,String> invItem5GAttributes = new Map<String,String>();
                                    
                            invItem5GAttributes.put('INWIB2C_ATT_DC_SERVICE5G', 'En service');

                            String invItem5GJSON = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(invItemDecom5G.vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c, invItem5GAttributes);
                           
                                inventoryItemToUpdate.add (new vlocity_cmt__InventoryItem__c(id=invItemDecom5G.vlocity_cmt__DestinationInventoryItemId__c, vlocity_cmt__JSONAttribute__c=invItem5GJSON));
                               
                                
                                    
                            }
                        // MGEN3675 TTM: Eclipse Offre 5G
                    
                    }
                    //SUSP IMX    B-5626
                    //28/12/2023 CHB ANO B-13404
                    if(SubMassItem.INWIB2C_ACTION__c == 'SUSP'|| SubMassItem.INWIB2C_ACTION__c =='SUSC' && SubMassItem.INWIB2C_MOTIF__c=='SUSP_IDENTIF_CAMPUS')
                    {
                        if(SubMassItem.INWIB2C_MOTIF__c=='SUSP_IDENTIF_CAMPUS'){
                            SubscriptionObj.inwiB2C_LegacyStatus__c = 'Non identification de la ligne';
                            SubscriptionObj.inwiB2C_Statut__c = 'InwiB2C_Nonidentificationdelaligne';
                            SubscriptionObj.vlocity_cmt__Status__c = 'Suspended';
                            //Call DR To update InventoryItem and Asset
                            /*string datajsonSusp = '{"AssetId":"'+AssetId+'", "InventoryItemId":"'+InventoryItemId+'","appelEntrant":"Autorisé","appelSortant":"Bloqué" }';
                            vlocity_cmt.DRProcessResult resultUpdateRehab = vlocity_cmt.DRGlobal.processObjectsJSON(datajsonSusp, 'InwiB2C_DR_UpdateSubscriptionStatusAndAttributes');
        
                            Map<String, Object> resultMapRehab = resultUpdateRehab.convertToMap();*/

                        }else{
                            SubscriptionObj.inwiB2C_LegacyStatus__c = 'Restriction Recouvrement';
                            SubscriptionObj.inwiB2C_Statut__c = 'InwiB2C_RestreinteRecouvrement';
                            SubscriptionObj.vlocity_cmt__Status__c = 'Suspended';
                            //Call DR To update InventoryItem and Asset
                            /*string datajsonSusp = '{"AssetId":"'+AssetId+'", "InventoryItemId":"'+InventoryItemId+'","appelEntrant":"Autorisé","appelSortant":"Bloqué" }';
                            vlocity_cmt.DRProcessResult resultUpdateRehab = vlocity_cmt.DRGlobal.processObjectsJSON(datajsonSusp, 'InwiB2C_DR_UpdateSubscriptionStatusAndAttributes');

                            Map<String, Object> resultMapRehab = resultUpdateRehab.convertToMap();*/
                        }
                        //LDA - START : change update of JSON in mass
                        Map<String,String> assetAttributes = new Map<String,String>();

                        // MGEN3675 TTM: Eclipse Offre 5G
                        Map<String,String> asset5GAttributes = new Map<String,String>();
				        // MGEN3675 TTM: Eclipse Offre 5G

                        assetAttributes.put('INWIB2C_ATT_RT_APPELS_ENRTANT', 'Autorisé');
                        assetAttributes.put('INWIB2C_ATT_RT_APPELS_SORTANT', 'Bloqué');

                        // MGEN3675 TTM: Eclipse Offre 5G
                        asset5GAttributes.put('INWIB2C_ATT_RT_SERVICE5G', 'Bloqué');
                        // MGEN3675 TTM: Eclipse Offre 5G
 
    
                        if (currentAsset != null){
                            currentAsset.vlocity_cmt__JSONAttribute__c = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentAsset.vlocity_cmt__JSONAttribute__c, assetAttributes);
                            assetToUpdateList.add(currentAsset);

                        }
    
                        if (currentInvItemDecom != null){
                            Map<String,String> invItemAttributes = new Map<String,String>();
    
                            invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_IN', 'Autorisé');
                            invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_OUT', 'Bloqué');
                            String invItemJSON = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c, invItemAttributes);
                            inventoryItemToUpdate.add (new vlocity_cmt__InventoryItem__c(id=currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__c, vlocity_cmt__JSONAttribute__c=invItemJSON));
    
                        }
                         // MGEN3675 TTM: Eclipse Offre 5G
                     if (asset5G != null){
                         
                                    asset5G.vlocity_cmt__JSONAttribute__c = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(asset5G.vlocity_cmt__JSONAttribute__c, asset5GAttributes);
                                    assetToUpdateList.add(asset5G);
                                    
                                    
                                
                            }
                            
                       if (invItemDecom5G != null){
                       	Map<String,String> invItem5GAttributes = new Map<String,String>();
                                
                       	invItem5GAttributes.put('INWIB2C_ATT_DC_SERVICE5G', 'Bloqué');

                        String invItem5GJSON = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(invItemDecom5G.vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c, invItem5GAttributes);
                       
                        	inventoryItemToUpdate.add (new vlocity_cmt__InventoryItem__c(id=invItemDecom5G.vlocity_cmt__DestinationInventoryItemId__c, vlocity_cmt__JSONAttribute__c=invItem5GJSON));
                         	
                                
                        }
        			// MGEN3675 TTM: Eclipse Offre 5G

                    }
                
                    //SUSPENSION CYCLE DE VIE
                    //28/12/2023 CHB ANO B-13404
                    if(SubMassItem.INWIB2C_ACTION__c == 'SUSC' &&  SubMassItem.INWIB2C_MOTIF__c!='SUSP_IDENTIF_CAMPUS')
                    {
                        SubscriptionObj.inwiB2C_LegacyStatus__c = 'Suspension cycle de vie';
                        SubscriptionObj.inwiB2C_Statut__c = 'InwiB2C_SuspCycleVie';
                        SubscriptionObj.vlocity_cmt__Status__c = 'Suspended';
                        //Call DR To update InventoryItem and Asset
                        /*string datajsonSUSC = '{"AssetId":"'+AssetId+'", "InventoryItemId":"'+InventoryItemId+'","appelEntrant":"Bloqué","appelSortant":"Bloqué" }';
                        vlocity_cmt.DRProcessResult resultUpdateSusc = vlocity_cmt.DRGlobal.processObjectsJSON(datajsonSUSC, 'InwiB2C_DR_UpdateSubscriptionStatusAndAttributes');

                        Map<String, Object> resultMapSusc = resultUpdateSusc.convertToMap();*/
                        //LDA - START : change update of JSON in mass
                        Map<String,String> assetAttributes = new Map<String,String>();

                        assetAttributes.put('INWIB2C_ATT_RT_APPELS_ENRTANT', 'Bloqué');
                        assetAttributes.put('INWIB2C_ATT_RT_APPELS_SORTANT', 'Bloqué');

                        if (currentAsset != null){
                            currentAsset.vlocity_cmt__JSONAttribute__c = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentAsset.vlocity_cmt__JSONAttribute__c, assetAttributes);
                            assetToUpdateList.add(currentAsset);

                        }
                        

                        if (currentInvItemDecom != null){
                            Map<String,String> invItemAttributes = new Map<String,String>();

                            invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_IN', 'Bloqué');
                            invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_OUT', 'Bloqué');
                            String invItemJSON = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c, invItemAttributes);
                            inventoryItemToUpdate.add (new vlocity_cmt__InventoryItem__c(id=currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__c, vlocity_cmt__JSONAttribute__c=invItemJSON));

                        }
                    }
                    //SUSPENSION FRAUDE
                    if(SubMassItem.INWIB2C_ACTION__c == 'SFRD')
                    {
                        SubscriptionObj.inwiB2C_LegacyStatus__c = 'Suspension fraude';
                        SubscriptionObj.inwiB2C_Statut__c = 'InwiB2C_Suspended';
                        SubscriptionObj.vlocity_cmt__Status__c = 'Suspended';
                        /**B-8863  TMA 02/05/2023 Begin*/
                       // Blacklist.add(new InwiB2C_BlackList__c(InwiB2C_CIN__c=cin,InwiB2C_Status__c=true,InwiB2C_FirstName__c=listSubscriptions[0].vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.FirstName,InwiB2C_LastName__c=listSubscriptions[0].vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.LastName,InwiB2C_TypeCIN__c=listSubscriptions[0].vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_Type_CIN__c));
                        //insert Blacklist;
                        /**B-8863  TMA 02/05/2023 End*/

                        //Call DR To update InventoryItem and Asset
                        /*string datajsonSFRD = '{"AssetId":"'+AssetId+'", "InventoryItemId":"'+InventoryItemId+'","appelEntrant":"Bloqué","appelSortant":"Bloqué" }';
                        vlocity_cmt.DRProcessResult resultUpdateSfrd = vlocity_cmt.DRGlobal.processObjectsJSON(datajsonSFRD, 'InwiB2C_DR_UpdateSubscriptionStatusAndAttributes');

                        Map<String, Object> resultMapSfrd = resultUpdateSfrd.convertToMap();*/
                        //LDA - START : change update of JSON in mass
                        Map<String,String> assetAttributes = new Map<String,String>();

                        assetAttributes.put('INWIB2C_ATT_RT_APPELS_ENRTANT', 'Bloqué');
                        assetAttributes.put('INWIB2C_ATT_RT_APPELS_SORTANT', 'Bloqué');

                        if (currentAsset != null){
                            currentAsset.vlocity_cmt__JSONAttribute__c = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentAsset.vlocity_cmt__JSONAttribute__c, assetAttributes);
                            assetToUpdateList.add(currentAsset);

                        }

                        if (currentInvItemDecom != null){
                            Map<String,String> invItemAttributes = new Map<String,String>();

                            invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_IN', 'Bloqué');
                            invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_OUT', 'Bloqué');
                            String invItemJSON = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c, invItemAttributes);
                            inventoryItemToUpdate.add (new vlocity_cmt__InventoryItem__c(id=currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__c, vlocity_cmt__JSONAttribute__c=invItemJSON));

                        }
                    }
                    //RESILIATION
                    if(SubMassItem.INWIB2C_ACTION__c == 'RESIL' || SubMassItem.INWIB2C_ACTION__c == 'RESILD')
                    {

                        
                        
                        
                            SubscriptionObj.inwiB2C_LegacyStatus__c = 'Résilié cycle de vie';
                            SubscriptionObj.inwiB2C_Statut__c = 'InwiB2C_ResylCycleVie';
                            SubscriptionObj.vlocity_cmt__Status__c = 'Expired'; 
                            //Call DR To update InventoryItem and Asset
                            /*string datajsonResil = '{"AssetId":"'+AssetId+'", "InventoryItemId":"'+InventoryItemId+'","appelEntrant":"Bloqué","appelSortant":"Bloqué" }';
                            vlocity_cmt.DRProcessResult resultUpdateResil = vlocity_cmt.DRGlobal.processObjectsJSON(datajsonResil, 'InwiB2C_DR_UpdateSubscriptionStatusAndAttributes');

                            Map<String, Object> resultMapResil = resultUpdateResil.convertToMap();*/
                            //LDA - START : change update of JSON in mass
                            Map<String,String> assetAttributes = new Map<String,String>();

                            assetAttributes.put('INWIB2C_ATT_RT_APPELS_ENRTANT', 'Bloqué');
                            assetAttributes.put('INWIB2C_ATT_RT_APPELS_SORTANT', 'Bloqué');
        
                            if (currentAsset != null){
                                currentAsset.vlocity_cmt__JSONAttribute__c = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentAsset.vlocity_cmt__JSONAttribute__c, assetAttributes);
                                assetToUpdateList.add(currentAsset);
        
                            }
        
                            if (currentInvItemDecom != null){
                                Map<String,String> invItemAttributes = new Map<String,String>();
        
                                invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_IN', 'Bloqué');
                                invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_OUT', 'Bloqué');
                                String invItemJSON = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c, invItemAttributes);
                                inventoryItemToUpdate.add (new vlocity_cmt__InventoryItem__c(id=currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__c, vlocity_cmt__JSONAttribute__c=invItemJSON));
        
                            }

                            //PUT ASSETS ACTION TO DISCONNECT
                            List<Asset> listAssetsToUpdate = new List<Asset>();

                            listAssetsToUpdate = mapAssetListByRootAssetId.get(AssetId);
                            if (listAssetsToUpdate != null )
                            {
                                for (Asset assetObj : listAssetsToUpdate)
                                {
                                    assetObj.vlocity_cmt__Action__c = 'Disconnect';
                                    if(!listAssetResilToDisconnect.contains(assetObj))
                                    {
                                        listAssetResilToDisconnect.add(assetObj);
                                    }
                                }
                                for (vlocity_cmt__InventoryItemDecompositionRelationship__c inventoryItemObj : mapInventoryItemByAsset.get(AssetId))
                                {
                                        if(!listInventoryItemsResilToDelete.contains(inventoryItemObj)){
                                            listInventoryItemsResilToDelete.add(inventoryItemObj);
                                        }
                                }
                            }
                            else
                            {
                                InwiB2C_ErrorInSubsMass__c itemErrorSubsMass = new InwiB2C_ErrorInSubsMass__c(inwib2c_inst_prod_id__c = SubscriptionObj.inwib2c_inst_prod_id__c, inwiB2C_SubscriptionId__c = SubscriptionObj.id , InwiB2C_MDN__c = SubscriptionObj.Inwib2c_Num_ro_de_la_ligne__c );
                                listErrorsInSubsMass.add(itemErrorSubsMass);
                            }
                            //Saad 19/12/2023 TTM  arret synchronisation begin
                            if(subMassItem.InwiB2C_Operator__c == 'fOrange' || subMassItem.InwiB2C_Operator__c == 'mOrange' || subMassItem.InwiB2C_Operator__c == 'fTelecom'|| subMassItem.InwiB2C_Operator__c == 'mTelecom'){
                                
                                InwiB2C_Demande_Restitution__c itemDemandeRestitution = new InwiB2C_Demande_Restitution__c(InwiB2C_Statut__c ='InwiB2C_New'  ,InwiB2C_MDN__c = SubscriptionObj.Inwib2c_Num_ro_de_la_ligne__c, InwiB2C_ClientId__c = SubscriptionObj.vlocity_cmt__AccountId__c , InwiB2C_Operator__c = subMassItem.InwiB2C_Operator__c );
                                listDemandeRestToInsert.add(itemDemandeRestitution);
                            } 
                             //Saad 19/12/2023 TTM  arret synchronisation end
                        
                    }
                    
                    
                    if(!listSubsToUpdate.contains(SubscriptionObj))
                    {
                        listSubsToUpdate.add(SubscriptionObj);
                    }

                    //UPDATE scope
                    SubMassItem.INWIB2C_STATUT__c ='TRAITE';
                }
                
            }
            if (!foundSubscription){
                SubMassItem.INWIB2C_STATUT__c ='ERROR';
                SubMassItem.INWIB2C_DESCRIPTION__c = 'Souscription introuvable';
            }
        }
        else
        {
            SubMassItem.INWIB2C_STATUT__c ='ERROR';
            SubMassItem.INWIB2C_DESCRIPTION__c = 'Souscription introuvable';
        }

		
   }
    update scope;
    if (listSubsToUpdate.size() > 0){
        update listSubsToUpdate;
    }

    if (listAssetResilToDisconnect.size() >0) {
        update listAssetResilToDisconnect;
    }
    if (listInventoryItemsResilToDelete.size()>0)
    {
        delete listInventoryItemsResilToDelete;
    }
    if (listErrorsInSubsMass.size()>0)
    {
        insert listErrorsInSubsMass;
    }
     //Saad 19/12/2023 TTM  arret synchronisation begin
     if (listDemandeRestToInsert.size()>0)
     {
         insert listDemandeRestToInsert;
     }
      //Saad 19/12/2023 TTM  arret synchronisation end
    if(!Test.isRunningTest()) {
    System.debug('we are here2');
    List<Database.SaveResult> resultsSubsMassPE = EventBus.publish(subsMassListPE);
    System.debug('we are here2');
                        
    //LDA - START : change update of JSON in mass

    if(assetToUpdateList.size() > 0 ){
        update assetToUpdateList;
    }
    if (inventoryItemToUpdate.size() > 0){
        update inventoryItemToUpdate;
    } 
  /*   //chb 20/06/2023 bypass duplication  B-9305
    if (oldestDuplicates.size() > 0){
        update oldestDuplicates;
    } */



}
   
    
}
public void finish(Database.BatchableContext BC){
          /*AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
      a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
      a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];*/

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
String[] email = new String[]{'prod.salesforceb2c@inwi.ma'};
mail.setToAddresses(email);
mail.setReplyTo('prod.salesforceb2c@inwi.ma');
mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process ');
mail.setPlainTextBody('The Batch Apex job ');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}

}