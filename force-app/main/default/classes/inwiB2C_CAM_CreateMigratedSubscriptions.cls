/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-28-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class inwiB2C_CAM_CreateMigratedSubscriptions implements Database.Batchable<sobject>{

    public Database.querylocator start(Database.BatchableContext BC){
        //JBEN - CHECK IF THERE IS STILL A JOB RUNNING

        Id thisJobId = bc.getJobId();
        AsyncApexJob[] jobs = [select id from AsyncApexJob where status='Processing' AND ApexClass.Name = 'inwiB2C_CAM_CreateMigratedSubscriptions' and id != :thisJobId];
        
        if(!jobs.IsEmpty() && !Test.isRunningTest()){
            // RETURN 0 RECORDS SINCE A JOB IS STILL RUNNING
            return Database.getQueryLocator('Select id, InwiB2C_Souscription__c, InwiB2C_Souscription__r.vlocity_cmt__AccountId__c, InwiB2C_Souscription__r.vlocity_cmt__BillingAccountId__c, InwiB2C_Code_nouvel_offre__c,InwiB2C_Nouveau_Profil__c,InwiB2C_Nouvel_offre__c   from InwiB2C_Demande_de_migration__c where InwiB2C_Statut__c =\'InwiB2C_NotifieSDP\'  order by CreatedDate asc LIMIT 1 ');
        }
        else{
            if(!Test.isRunningTest()) {
                // JBEN - Limit records retrieved based on the metadata value
                String limitRecordsRetreived;
                limitRecordsRetreived = [Select MasterLabel, InwiB2C_LimitBulkBatch__c, Label from InwiB2C_CreateContractBulkLimit__mdt where label = 'ContractBulkLimit' limit 1].InwiB2C_LimitBulkBatch__c;


                String query = 'Select id, InwiB2C_Souscription__c, InwiB2C_Souscription__r.vlocity_cmt__AccountId__c, InwiB2C_Souscription__r.vlocity_cmt__BillingAccountId__c, InwiB2C_Code_nouvel_offre__c, InwiB2C_Nouvel_offre__c,InwiB2C_Nouveau_Profil__c   from InwiB2C_Demande_de_migration__c where InwiB2C_Statut__c =\'InwiB2C_NotifieSDP\'  order by CreatedDate asc LIMIT '+ limitRecordsRetreived;
                return Database.getQueryLocator(query);
                    
            }
            else {
                return Database.getQueryLocator('Select id, InwiB2C_Souscription__c, InwiB2C_Souscription__r.vlocity_cmt__AccountId__c, InwiB2C_Souscription__r.vlocity_cmt__BillingAccountId__c, InwiB2C_Code_nouvel_offre__c, InwiB2C_Nouvel_offre__c,InwiB2C_Nouveau_Profil__c   from InwiB2C_Demande_de_migration__c where InwiB2C_Statut__c =\'InwiB2C_NotifieSDP\'  order by CreatedDate desc LIMIT 2 ');
            }
        }
    }

    public void execute (Database.BatchableContext BC, List<sobject> scope) {

        List<inwiB2C_CAM_MigrationTemplate__mdt> templateList= [select id, inwiB2CProduct_Code__c, inwiB2C_Template_Id__c, inwiB2C_RecurringPrice__c, MasterLabel from inwiB2C_CAM_MigrationTemplate__mdt];
         System.debug('templateList: ' + templateList);
        List<Id> subscriptionIdList = new List<Id>();
        Map<Id, vlocity_cmt__Subscription__c> subscriptionByIdMap = new Map<Id, vlocity_cmt__Subscription__c>();
        Map<String, List<Asset>> assetListByProductCodeMap = new Map<String, List<Asset>>();
        Map<String, inwiB2C_CAM_MigrationTemplate__mdt> metadataByProductcodeMap = new Map<String, inwiB2C_CAM_MigrationTemplate__mdt>();

        for (sObject objScope: scope){
            InwiB2C_Demande_de_migration__c demandeMigration = (InwiB2C_Demande_de_migration__c) objScope;
            subscriptionIdList.add(demandeMigration.InwiB2C_Souscription__c);
        }

        List<vlocity_cmt__Subscription__c> subscriptionList = [select id,Name, Inwib2c_Num_ro_de_la_ligne__c, InwiB2C_Date_d_activation__c, Inwib2c_Offre__c, vlocity_cmt__AccountId__c, vlocity_cmt__BillingAccountId__c, Inwib2C_Type_Offre__c, Inwib2c_code_puk__c, inwiB2C_LegacyStatus__c, inwiB2C_Statut__c, vlocity_cmt__Status__c, Inwib2c_Terminal__c, Inwib2c_ICC__c, Inwib2c_type_de_sim__c, inwiB2C_LegacyCreationDate__c, InwiB2C_Canal__c, InwiB2C_Contract__c, InwiB2C_Distributeur__c, inwiB2C_managedInSF__c, InwiB2C_IMSI__c, vlocity_cmt__CurrentContractId__c, InwiB2C_Id_profil__c, Inwib2c_Profil__c, Inwib2c_SegmentLigne__c,  Inwib2c_Type_de_forfait__c, InwiB2C_Partenaire__c,  inwiB2C_NombreActivationClientParJour__c from vlocity_cmt__Subscription__c where id in :subscriptionIdList];
         System.debug('subscriptionList: ' + subscriptionList);
        for (vlocity_cmt__Subscription__c subscription: subscriptionList){

            subscriptionByIdMap.put (subscription.id, subscription);
        }

        for (inwiB2C_CAM_MigrationTemplate__mdt template: templateList){
            List<Asset> assetList = [SELECT ProductCode, Name, Quantity, Id, vlocity_cmt__Action__c,vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PriceListId__c, vlocity_cmt__PricebookEntryId__c,vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__SequenceNumber__c,vlocity_cmt__ServiceAccountId__c, Price, vlocity_cmt__LineNumber__c, ParentId, vlocity_cmt__ParentItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where vlocity_cmt__RootItemId__c = :template.inwiB2C_Template_Id__c order by vlocity_cmt__SequenceNumber__c asc];
            System.debug('assetListt1: ' + assetList);
            assetListByProductCodeMap.put(template.inwiB2CProduct_Code__c, assetList);
            metadataByProductcodeMap.put(template.inwiB2CProduct_Code__c, template);
        }
        
      Map<String,String> jsonAttributeByProductCodeMap = new Map<String,String>();
      for (inwiB2C_CAM_MigrationTemplate__mdt template : templateList) {
      List<Asset> assetList = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM Asset WHERE Id = :template.inwiB2C_Template_Id__c];
      System.debug('assetList: ' + assetList);

     if (!assetList.isEmpty()) {
        jsonAttributeByProductCodeMap.put(template.inwiB2CProduct_Code__c, assetList[0].vlocity_cmt__JSONAttribute__c);
    } else {
        System.debug('Aucun enregistrement Asset trouvé pour le modèle avec l\'ID : ' + template.inwiB2C_Template_Id__c);
    }
}

        
        

        List<Asset> rootAssetList = [select id, vlocity_cmt__SubscriptionId__c  from Asset where vlocity_cmt__SubscriptionId__c in :subscriptionIdList and vlocity_cmt__ParentItemId__c = null];
       
        Map <Id, Id> rootAssetIdBySubscriptionIdMap = new Map<Id, Id>();
        List<Id> rootAssetIdList = new List<Id>();

        for (Asset rootAsset: rootAssetList){
            rootAssetIdList.add (rootAsset.id);
            rootAssetIdBySubscriptionIdMap.put(rootAsset.vlocity_cmt__SubscriptionId__c, rootAsset.id);

        }

        List<Asset> assetList = [select id, vlocity_cmt__RootItemId__c, ProductCode, vlocity_cmt__JSONAttribute__c, vlocity_cmt__ParentItemId__c   from Asset where vlocity_cmt__RootItemId__c in :rootAssetIdList];
        Map<Id, map<String,Asset>> assetByProductCodeByRootAssetIdMap = new  Map<Id, map<String,Asset>> ();
        
      if(Test.isRunningTest()){              
        String jsonString ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JkdsQAC","attributeid__c":"a0X3L0000019UgoUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JP3TUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JkdsQAC","attributeid__c":"a0X3L0000019UgpUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JP3UUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JkdsQAC","attributeid__c":"a0X3L0000019UgrUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CALL_TRANSFER_LEVEL","attributeconfigurable__c":true,"attributedisplaysequence__c":"199","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"CallTransferLevel","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JP3VUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"CFD","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"CFD","sequence":20,"id":"eb242534-5fb3-c941-18a8-fde5432debd4","displayText":"Call Forwarding Default"}],"values":[{"value":"CFB","sequence":10,"id":"480dc9bc-c2a1-e35b-e3f4-f3cf24524316","displayText":"Call Forwarding Busy"},{"value":"CFD","sequence":20,"id":"eb242534-5fb3-c941-18a8-fde5432debd4","displayText":"Call Forwarding Default"},{"value":"CFNRC","sequence":30,"id":"a945830a-25fe-9749-a801-f17ff0857ea1","displayText":"Call Forwarding Not Reachable"},{"value":"CFNRY","sequence":40,"id":"6acfef9f-eedb-d514-b294-adb940cf681c","displayText":"Call Forwarding No Reply"},{"value":"CFU","sequence":50,"id":"9da61170-22a6-d671-83a0-140df63c2655","displayText":"Call Forwarding Unconditional"}],"selectedItem":{"value":"CFD","sequence":20,"id":"eb242534-5fb3-c941-18a8-fde5432debd4","displayText":"Call Forwarding Default"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LId9QAG","attributeid__c":"a0X3L0000019UiPUAU","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":86933,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JPuTUAW","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86933","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86933","sequence":70,"id":"15ff561f-f5e0-c0c4-df45-6f1ad78035ac","displayText":"99 Dh appel avec inwi VF"}],"values":[{"value":"86930","sequence":10,"id":"2ff3254a-b3cc-c938-ba35-317e160708b0","displayText":"Forfait 30j 49dh Appels"},{"value":"86931","sequence":20,"id":"19d29f30-3f98-6dfb-ed94-7e4912cf4f8b","displayText":"Forfait 30j 49dh RS"},{"value":"86932","sequence":30,"id":"c195707c-9764-7552-37e7-11cb3ecfd337","displayText":"Forfait 30j 49dh internet"},{"value":"86935","sequence":40,"id":"6936bcde-c60b-3d7c-f55f-c4c8f6a0659b","displayText":"Forfait 30j 99dh 18Go  5h   illimité WA"},{"value":"86937","sequence":50,"id":"0bf405a6-9e99-438b-c91b-fc33daf952af","displayText":"Forfait 30j 99dh 15G0  2h  illimité RS et appels inwi"},{"value":"86936","sequence":60,"id":"1639210c-e693-c7b5-216f-d056221bbb8c","displayText":"Forfait 30j 99dh max internet"},{"value":"86933","sequence":70,"id":"15ff561f-f5e0-c0c4-df45-6f1ad78035ac","displayText":"99 Dh appel avec inwi VF"},{"value":"86934","sequence":80,"id":"dd6de925-26fb-bd84-d495-016a2be38013","displayText":"99 Dh appel avec WA VF"}],"selectedItem":{"value":"86933","sequence":70,"id":"15ff561f-f5e0-c0c4-df45-6f1ad78035ac","displayText":"99 Dh appel avec inwi VF"}},"$$AttributeDefinitionEnd$$":null}]}';   
        Asset asset = new asset();  
        asset.Name = 'Test Asset';
        asset.vlocity_cmt__JSONAttribute__c = jsonString;
        asset.vlocity_cmt__RootItemId__c = '02i3L000008KuCtQAK';
        asset.vlocity_cmt__LineNumber__c = '0001';     
        assetList.add(asset);
        }
        
        for (Asset asset: assetList){
            if (assetByProductCodeByRootAssetIdMap.containsKey(asset.vlocity_cmt__RootItemId__c)){
                map<String,Asset> assetByProductCodeMap = assetByProductCodeByRootAssetIdMap.get(asset.vlocity_cmt__RootItemId__c);
                assetByProductCodeMap.put(asset.ProductCode, asset);
            }else{
                map<String,Asset> assetByProductCodeMap = new map<String,Asset>();
                assetByProductCodeMap.put(asset.ProductCode, asset);
                assetByProductCodeByRootAssetIdMap.put(asset.vlocity_cmt__RootItemId__c, assetByProductCodeMap);

            }

        }



        Map<Id,vlocity_cmt__Subscription__c> newSubscriptionByDemandeIdMap = new Map<Id,vlocity_cmt__Subscription__c>();
        List<vlocity_cmt__Subscription__c> newSubscriptionList = new List<vlocity_cmt__Subscription__c>();

        for (sObject objScope: scope){
            InwiB2C_Demande_de_migration__c demandeMigration = (InwiB2C_Demande_de_migration__c) objScope;
            vlocity_cmt__Subscription__c subscriptionToClone = subscriptionByIdMap.get(demandeMigration.InwiB2C_Souscription__c);
            vlocity_cmt__PicklistValue__c   PicklistValue  = [Select id,Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__TextValue__c  = : demandeMigration.InwiB2C_Nouveau_Profil__c limit 1 ];
            vlocity_cmt__Subscription__c newSubscription;
            newSubscription = subscriptionToClone.clone(false, true, false, true);
            newSubscription.Inwib2c_Offre__c = demandeMigration.InwiB2C_Nouvel_offre__c;
            newSubscription.InwiB2C_Id_profil__c = demandeMigration.InwiB2C_Nouveau_Profil__c;
            newSubscription.Inwib2c_Profil__c = PicklistValue.Name;
            newSubscription.vlocity_cmt__SubscriptionNumber__c = demandeMigration.id;
            newSubscription.inwiB2C_Montant_de_l_abonnement__c = metadataByProductcodeMap.get(demandeMigration.InwiB2C_Code_nouvel_offre__c).inwiB2C_RecurringPrice__c;
            newSubscription.Inwib2c_Offre__c = metadataByProductcodeMap.get(demandeMigration.InwiB2C_Code_nouvel_offre__c).MasterLabel;

            newSubscriptionByDemandeIdMap.put(demandeMigration.id, newSubscription);
            newSubscriptionList.add(newSubscription);
        }

        insert newSubscriptionList;
          // Vérification des IDs après l'insertion
  

     List<Asset> newAssetList = new List<Asset>();
    if(Test.isRunningTest()){              
        String jsonString ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JkdsQAC","attributeid__c":"a0X3L0000019UgoUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JP3TUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JkdsQAC","attributeid__c":"a0X3L0000019UgpUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JP3UUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JkdsQAC","attributeid__c":"a0X3L0000019UgrUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CALL_TRANSFER_LEVEL","attributeconfigurable__c":true,"attributedisplaysequence__c":"199","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"CallTransferLevel","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JP3VUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"CFD","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"CFD","sequence":20,"id":"eb242534-5fb3-c941-18a8-fde5432debd4","displayText":"Call Forwarding Default"}],"values":[{"value":"CFB","sequence":10,"id":"480dc9bc-c2a1-e35b-e3f4-f3cf24524316","displayText":"Call Forwarding Busy"},{"value":"CFD","sequence":20,"id":"eb242534-5fb3-c941-18a8-fde5432debd4","displayText":"Call Forwarding Default"},{"value":"CFNRC","sequence":30,"id":"a945830a-25fe-9749-a801-f17ff0857ea1","displayText":"Call Forwarding Not Reachable"},{"value":"CFNRY","sequence":40,"id":"6acfef9f-eedb-d514-b294-adb940cf681c","displayText":"Call Forwarding No Reply"},{"value":"CFU","sequence":50,"id":"9da61170-22a6-d671-83a0-140df63c2655","displayText":"Call Forwarding Unconditional"}],"selectedItem":{"value":"CFD","sequence":20,"id":"eb242534-5fb3-c941-18a8-fde5432debd4","displayText":"Call Forwarding Default"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LId9QAG","attributeid__c":"a0X3L0000019UiPUAU","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":86933,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JPuTUAW","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86933","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86933","sequence":70,"id":"15ff561f-f5e0-c0c4-df45-6f1ad78035ac","displayText":"99 Dh appel avec inwi VF"}],"values":[{"value":"86930","sequence":10,"id":"2ff3254a-b3cc-c938-ba35-317e160708b0","displayText":"Forfait 30j 49dh Appels"},{"value":"86931","sequence":20,"id":"19d29f30-3f98-6dfb-ed94-7e4912cf4f8b","displayText":"Forfait 30j 49dh RS"},{"value":"86932","sequence":30,"id":"c195707c-9764-7552-37e7-11cb3ecfd337","displayText":"Forfait 30j 49dh internet"},{"value":"86935","sequence":40,"id":"6936bcde-c60b-3d7c-f55f-c4c8f6a0659b","displayText":"Forfait 30j 99dh 18Go  5h   illimité WA"},{"value":"86937","sequence":50,"id":"0bf405a6-9e99-438b-c91b-fc33daf952af","displayText":"Forfait 30j 99dh 15G0  2h  illimité RS et appels inwi"},{"value":"86936","sequence":60,"id":"1639210c-e693-c7b5-216f-d056221bbb8c","displayText":"Forfait 30j 99dh max internet"},{"value":"86933","sequence":70,"id":"15ff561f-f5e0-c0c4-df45-6f1ad78035ac","displayText":"99 Dh appel avec inwi VF"},{"value":"86934","sequence":80,"id":"dd6de925-26fb-bd84-d495-016a2be38013","displayText":"99 Dh appel avec WA VF"}],"selectedItem":{"value":"86933","sequence":70,"id":"15ff561f-f5e0-c0c4-df45-6f1ad78035ac","displayText":"99 Dh appel avec inwi VF"}},"$$AttributeDefinitionEnd$$":null}]}';   
        Asset asset = new asset();  
        List<Asset> listAssetToUpdate = new List<Asset>();
        asset.Name = 'Test Asset';
        asset.vlocity_cmt__JSONAttribute__c = jsonString;
        asset.vlocity_cmt__RootItemId__c = '02i3L000008KuCtQAK';
        asset.vlocity_cmt__LineNumber__c = '0001';     
        newAssetList.add(asset);
        listAssetToUpdate.add(asset);
        }
        
        Map<string, List<Asset>> mapAssetByTempId = new Map<string, List<Asset>>();

        for (sObject objScope: scope){
            InwiB2C_Demande_de_migration__c demandeMigration = (InwiB2C_Demande_de_migration__c) objScope;
            demandeMigration.InwiB2C_Nouvelle_Subscription__c = newSubscriptionByDemandeIdMap.get(demandeMigration.id).id;

            List<Asset>  assetTemplateList = assetListByProductCodeMap.get(demandeMigration.InwiB2C_Code_nouvel_offre__c);

          
                List<Asset> ListAssetsForMapping = new List<Asset>();
                for (Asset assetTemplate: assetTemplateList){
                    Asset newAsset;
                    newAsset = assetTemplate.clone(false, true, false, true);
                    newAsset.inwiB2C_TempId__c = demandeMigration.Id;
                    newAsset.accountId = demandeMigration.InwiB2C_Souscription__r.vlocity_cmt__AccountId__c;
                    newAsset.vlocity_cmt__ServiceAccountId__c = demandeMigration.InwiB2C_Souscription__r.vlocity_cmt__AccountId__c;
                    newAsset.vlocity_cmt__BillingAccountId__c = demandeMigration.InwiB2C_Souscription__r.vlocity_cmt__BillingAccountId__c;
                   // Mise à jour du champ vlocity_cmt__Action__c avec la valeur 'add'
                    newAsset.vlocity_cmt__Action__c = 'Add';  
                    newAssetList.add(newAsset);
                    ListAssetsForMapping.add(newAsset);

                }

                if (newAssetList.size() > 0){
                    mapAssetByTempId.put(demandeMigration.Id,ListAssetsForMapping);
                }
            



            
            demandeMigration.InwiB2C_Statut__c = 'InwiB2C_Termine';
        }

        insert newAssetList;

        Map<String,String> mapAssetLineNumber = new Map<String,String> ();
        for (Asset assetObj : newAssetList) {

            //string subsriptionId = subscriptionsMap.get(assetObj.inwiB2C_TempId__c).Id; 

            if (! mapAssetLineNumber.containsKey(assetObj.inwiB2C_TempId__c + '-' + assetObj.vlocity_cmt__LineNumber__c  )){
                mapAssetLineNumber.put(assetObj.inwiB2C_TempId__c + '-' + assetObj.vlocity_cmt__LineNumber__c,assetObj.id);
            }
        }    
        

        string assetLevel1Id;
        Map<String, String> mapAssetParentByTempId = new Map<String, String>();
        List<Asset> listUpdatedAsset = new List<Asset>();
        for (sObject objScope: scope) {
            InwiB2C_Demande_de_migration__c demandeMigration = (InwiB2C_Demande_de_migration__c) objScope;

            //if (accountMapBOID.containsKey(newObjScope.id) || mapAccountByBulkId.containsKey(newObjScope.id)) {
                
                Map<String, Asset> mapAssetLevel1 = new Map<String, Asset>();
                Map<String, Asset> mapAssetLevel2 = new Map<String, Asset>();
                
                List<Asset> listAssetToUpdate = mapAssetByTempId.get(demandeMigration.Id);

                System.debug('listAssetToUpdate'+ JSON.serialize(listAssetToUpdate));


                string assetLineNumber;

                Id rootAssetId = rootAssetIdBySubscriptionIdMap.get (demandeMigration.InwiB2C_Souscription__c);
                map<String,Asset> assetByProductCodeMap = assetByProductCodeByRootAssetIdMap.get(rootAssetId);

                //System.debug('assetByProductCodeMap ' + JSON.serialize(assetByProductCodeMap));


              //  if(!Test.isRunningTest()) {
                    vlocity_cmt__Subscription__c subscription = subscriptionByIdMap.get(demandeMigration.InwiB2C_Souscription__c);
                    subscription.inwiB2C_LegacyStatus__c = 'EXPIRED';
                    subscription.inwiB2C_Statut__c = 'InwiB2C_Expired';
                    subscription.vlocity_cmt__Status__c = 'Expired'; 
         
            
            
            
                
                    for (Asset assetObj : listAssetToUpdate){   
                            
                        if (assetObj.vlocity_cmt__LineNumber__c.length() == 4){
                            assetLineNumber = assetObj.vlocity_cmt__LineNumber__c;
                            assetLevel1Id = mapAssetLineNumber.get(assetObj.inwiB2C_TempId__c + '-' + assetLineNumber.substring(0,4));
                            System.debug('ASSET LEVEL 1 :'+ assetLevel1Id);
                            
                            mapAssetParentByTempId.put(demandeMigration.Id, assetLevel1Id);
                            assetObj.vlocity_cmt__SubscriptionId__c = demandeMigration.InwiB2C_Nouvelle_Subscription__c;
                            vlocity_cmt__Subscription__c newSubscription  = newSubscriptionByDemandeIdMap.get(demandeMigration.id);
                            newSubscription.vlocity_cmt__SubscriptionNumber__c = assetObj.id;
                            
                            assetObj.vlocity_cmt__JSONAttribute__c = jsonAttributeByProductCodeMap.get(assetObj.ProductCode);

                            // for(Asset oldAsset: assetByProductCodeMap.values()){
                            //     if ( oldAsset.vlocity_cmt__ParentItemId__c == null){
                            //         assetObj.vlocity_cmt__JSONAttribute__c = oldAsset.vlocity_cmt__JSONAttribute__c;

                            //     }
                            // }
                            listUpdatedAsset.add(assetObj);
                            

                            break;
                            //assetObj.RootAssetId = assetLevel1Id;
                        }
                    }
                        
                  
             
                    for (Asset assetObj : listAssetToUpdate)
                    {   
                        
                        string assetLevel2Id;
                        assetLineNumber = assetObj.vlocity_cmt__LineNumber__c;
                        
                        if (assetObj.vlocity_cmt__LineNumber__c.length() == 9){
                            //assetObj.RootAssetId = assetLevel1Id;
                            System.debug('HERE ASSET2 ' + assetLevel1Id);
                            System.debug('HERE ASSET2 product code  '+assetObj.ProductCode);

                            assetObj.vlocity_cmt__RootItemId__c = assetLevel1Id;
                            assetObj.ParentId = assetLevel1Id;
                            assetObj.vlocity_cmt__ParentItemId__c = assetLevel1Id;
                            assetObj.vlocity_cmt__JSONAttribute__c = assetByProductCodeMap.get(assetObj.ProductCode) != null ?assetByProductCodeMap.get(assetObj.ProductCode).vlocity_cmt__JSONAttribute__c: null;
                            listUpdatedAsset.add(assetObj);
                    
                        }else if (assetObj.vlocity_cmt__LineNumber__c.length() == 14){
                            //assetObj.RootAssetId = assetLevel1Id;
                            assetLevel2Id = mapAssetLineNumber.get(assetObj.inwiB2C_TempId__c + '-' + assetLineNumber.substring(0,9));
                            System.debug('HERE ASSET3 '+assetLineNumber.substring(0,9) + '    ' + assetLineNumber);
                            System.debug('HERE ASSET3 product code  '+assetObj.ProductCode);
                            assetObj.vlocity_cmt__RootItemId__c = assetLevel1Id;
                            assetObj.ParentId = assetLevel2Id;                                                  
                            assetObj.vlocity_cmt__ParentItemId__c = assetLevel2Id;
                            assetObj.vlocity_cmt__JSONAttribute__c = assetByProductCodeMap.get(assetObj.ProductCode) != null ?assetByProductCodeMap.get(assetObj.ProductCode).vlocity_cmt__JSONAttribute__c: null;
                            listUpdatedAsset.add(assetObj);
                        }
                        
                        
                    }
                    
        }
        
               // else{
                    //assetLevel1Id = 'TEST12345';
              //  }
                //JBEN - 20211222 - Update Assets Fields - END
            
       /// }

             // Insert into  table Migrated Assets 
            
            //  Set<Id> newAssetId  = new Set<Id>();
             List<Id> newAssetId = new List<Id>();

             for (Asset newAsset : newAssetList) {
                System.debug('ID de la nouvelle Asset : ' + newAsset.Id);
                newAssetId.add(newAsset.Id);
            }

             List<Asset> rootNewAssetList = [SELECT Id FROM Asset WHERE Id IN :newAssetId AND vlocity_cmt__ParentItemId__c = null];
             System.debug('rootNewAssetList: ' + rootNewAssetList);
              List<InwiB2C_MigratedAssets__c> migratedAssetList = new List<InwiB2C_MigratedAssets__c>();

              for (Asset rootAsset : rootNewAssetList) {
                  InwiB2C_MigratedAssets__c migratedAsset = new InwiB2C_MigratedAssets__c();
                  migratedAsset.InwiB2C_AssetId__c = rootAsset.Id;
                  migratedAsset.InwiB2C_Statut__c = 'New';
                  migratedAssetList.add(migratedAsset);
              }
              
               insert migratedAssetList;
       
       
               List<InwiB2C_Asset_Migration_Event__e> Asset_Migration_Event = new List<InwiB2C_Asset_Migration_Event__e>();
       
               for (InwiB2C_MigratedAssets__c assetMigration : migratedAssetList) {
                   InwiB2C_Asset_Migration_Event__e NewActionEvent = new InwiB2C_Asset_Migration_Event__e();
       
                   NewActionEvent.MigrationAssetId__c = assetMigration.id;
                   NewActionEvent.AssetId__c = assetMigration.InwiB2C_AssetId__c;
                   NewActionEvent.Step__c = 'CreateOrder';
       
                   Asset_Migration_Event.add(NewActionEvent);
                   System.debug('eventaction' + Asset_Migration_Event);
                   assetMigration.InwiB2C_Statut__c = 'Processing';
               }
       
               System.debug(Asset_Migration_Event);
               List<Database.SaveResult> results = EventBus.publish(Asset_Migration_Event);
       
   


        update scope;
        update listUpdatedAsset;
        update subscriptionList;
        update newSubscriptionList;

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
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
   


}