public with sharing class inwiB2C_ExecAsyncLimitedAPIBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String RequestQuery ;
    
    
    public Database.querylocator start(Database.BatchableContext BC){
        if(!Test.isRunningTest()) {
            RequestQuery = 'SELECT id ,InwiB2C_API_Name__c,InwiB2C_Status__c,InwiB2C_MDN__c from InwiB2C_Trace_API__c where InwiB2C_Status__c in (\'inwiB2C_ExecuteLater\',\'inwiB2C_ExecuteLaterAssetGeneration\') and InwiB2C_API_Name__c in(\'WS24\',\'WS25\',\'WS01\',\'WS70\',\'WS54\',\'WS95\',\'WS93\') order by CreatedDate asc limit 200';
        }else{
            RequestQuery = 'SELECT id ,InwiB2C_API_Name__c,InwiB2C_Status__c,InwiB2C_MDN__c from InwiB2C_Trace_API__c where InwiB2C_Status__c in (\'inwiB2C_ExecuteLater\',\'inwiB2C_ExecuteLaterAssetGeneration\') AND InwiB2C_uuid__c=\'TESTASYNC\' order by CreatedDate asc limit 5';   
        }
        return Database.getQueryLocator(RequestQuery);   
    }
    
    public void execute(Database.BatchableContext BC, List<InwiB2C_Trace_API__c> scope){    

        Map<String, Object> ipIntput = new Map<String, Object>();
        Map<String, Object> ipOutput = new Map<String, Object>();
        Map<String, Object> ipOptions = new Map<String, Object>();
        //Event API WS70
        List<inwib2c_createEshop__e> createEshopEvents = new List<inwib2c_createEshop__e>();
        //Event API WS24
        List<inwiB2C_ExecuteMigrPrePostEvent__e> ExecuteMigrPrePostEvent = new List<inwiB2C_ExecuteMigrPrePostEvent__e>();
        //Event API WS25
        List<inwiB2C_ExecuteTraitementMigPostPostSMO__e> ExecuteTraitementMigPostPostSMOEvent = new List<inwiB2C_ExecuteTraitementMigPostPostSMO__e>();
        List<InwiB2C_AssetGenerationMigPostPost__e> InwiB2C_AssetGenerationMigPostPostEvent = new List<InwiB2C_AssetGenerationMigPostPost__e>();
        Map<String,String> AssetGenWS25Map = new Map<String,String>();
        List<String> ListMDNWS25WithoutInv = new List<String>();
        //event API WS95 Y_MH
        List<InwiB2C_VulaDesconnectService__e> ExecuteTraitementSMODisconnetvulaEvent = new List<InwiB2C_VulaDesconnectService__e>();
        List<String> ListMDNWS95WithoutInv = new List<String>();
        Map<String,String> AssetGenWS95Map = new Map<String,String>();
        //event API WS93 SOB
        List<InwiB2C_ExecuteTransfer__e> ExecuteTransferEvent = new List<InwiB2C_ExecuteTransfer__e>();
        List<String> ListMDNWS93WithoutInv = new List<String>();
        Map<String, Id> AssetGenWS93Map = new Map<String, Id>();
        //event API WS01
        List<inwiB2C_ExecuteTraitementSMO__e> ExecuteTraitementSMOEvent = new List<inwiB2C_ExecuteTraitementSMO__e>();
        List<inwiB2C_Asset_Generation__e> inwiB2C_Asset_GenerationEvent = new List<inwiB2C_Asset_Generation__e>();
        Map<String,String> AssetGenWS01Map = new Map<String,String>();
        List<String> ListMDNWS01WithoutInv = new List<String>();
        ipOutput = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_inwiB2C_GetDailyAsyncApex', ipIntput, ipOptions);
        String statusApexAsynchrone = (String) ipOutput.get('StatusApexAsynchrone');    
        String AssetId;
        String AccountId;  
        if(Test.isRunningTest()) {
            statusApexAsynchrone='NolimitAsyncApexExceeded';
        }
        if(statusApexAsynchrone=='NolimitAsyncApexExceeded'){
           for (InwiB2C_Trace_API__c  TraceRequestItem: scope){
                //Traitement API WS24 migration PREPOST
                if(TraceRequestItem.InwiB2C_API_Name__c=='WS24'){
                    inwiB2C_ExecuteMigrPrePostEvent__e eventToCreatePrePost = new inwiB2C_ExecuteMigrPrePostEvent__e();
                    eventToCreatePrePost.InwiB2C_TraceId__c = TraceRequestItem.Id;
                    ExecuteMigrPrePostEvent.add(eventToCreatePrePost);	
                    TraceRequestItem.InwiB2C_Status__c='OK';
                }//Traitement API WS25 migration POSTPOST
                else if(TraceRequestItem.InwiB2C_API_Name__c=='WS25'){
                    if(TraceRequestItem.InwiB2C_Status__c=='inwiB2C_ExecuteLater'){
                        inwiB2C_ExecuteTraitementMigPostPostSMO__e eventToCreatePostPost = new inwiB2C_ExecuteTraitementMigPostPostSMO__e();
                        eventToCreatePostPost.InwiB2C_TraceId__c = TraceRequestItem.Id;
                        ExecuteTraitementMigPostPostSMOEvent.add(eventToCreatePostPost);	
                        TraceRequestItem.InwiB2C_Status__c='OK';
                    }if(TraceRequestItem.InwiB2C_Status__c=='inwiB2C_ExecuteLaterAssetGeneration'){  
                        ListMDNWS25WithoutInv.add(TraceRequestItem.InwiB2C_MDN__c);
                        AssetGenWS25Map.put(TraceRequestItem.InwiB2C_MDN__c,TraceRequestItem.Id);
                        TraceRequestItem.InwiB2C_Status__c='OK';
                    }
                } //Traitement API WS01 createSMO
                else if(TraceRequestItem.InwiB2C_API_Name__c=='WS01'){
                    if(TraceRequestItem.InwiB2C_Status__c=='inwiB2C_ExecuteLater'){
                        inwiB2C_ExecuteTraitementSMO__e eventToCreateSMO = new inwiB2C_ExecuteTraitementSMO__e();
                        eventToCreateSMO.TraceId__c = TraceRequestItem.Id;
                        ExecuteTraitementSMOEvent.add(eventToCreateSMO);	
                        TraceRequestItem.InwiB2C_Status__c='OK';
                    }if(TraceRequestItem.InwiB2C_Status__c=='inwiB2C_ExecuteLaterAssetGeneration'){
                        ListMDNWS01WithoutInv.add(TraceRequestItem.InwiB2C_MDN__c);
                        AssetGenWS01Map.put(TraceRequestItem.InwiB2C_MDN__c,TraceRequestItem.Id);
                        TraceRequestItem.InwiB2C_Status__c='OK';
                    }
                }   //Traitement API WS95 createSMO Y_MH
                else if(TraceRequestItem.InwiB2C_API_Name__c=='WS95'){
                    if(TraceRequestItem.InwiB2C_Status__c=='inwiB2C_ExecuteLater'){
                        InwiB2C_VulaDesconnectService__e eventToCreateSMODesconnectService = new InwiB2C_VulaDesconnectService__e();
                        eventToCreateSMODesconnectService.Trace_Id__c = TraceRequestItem.Id;
                        ExecuteTraitementSMODisconnetvulaEvent.add(eventToCreateSMODesconnectService);	
                        TraceRequestItem.InwiB2C_Status__c='OK';
                    }if(TraceRequestItem.InwiB2C_Status__c=='inwiB2C_ExecuteLaterAssetGeneration'){
                        ListMDNWS95WithoutInv.add(TraceRequestItem.InwiB2C_MDN__c);
                        AssetGenWS95Map.put(TraceRequestItem.InwiB2C_MDN__c,TraceRequestItem.Id);
                        TraceRequestItem.InwiB2C_Status__c='OK';
                    }
                }  //Traitement API WS93 ExecuteTransfert SOB
                else if(TraceRequestItem.InwiB2C_API_Name__c=='WS93'){
                    if(TraceRequestItem.InwiB2C_Status__c == 'inwiB2C_ExecuteLater') {
                        InwiB2C_ExecuteTransfer__e eventToCreateTransfer = new InwiB2C_ExecuteTransfer__e();
                        eventToCreateTransfer.InwiB2C_TraceId__c = TraceRequestItem.Id;
                        ExecuteTransferEvent.add(eventToCreateTransfer);  
                        TraceRequestItem.InwiB2C_Status__c = 'OK';
                    } 
                    if(TraceRequestItem.InwiB2C_Status__c == 'inwiB2C_ExecuteLaterAssetGeneration') {
                        ListMDNWS93WithoutInv.add(TraceRequestItem.InwiB2C_MDN__c);
                        AssetGenWS93Map.put(TraceRequestItem.InwiB2C_MDN__c, TraceRequestItem.Id);
                        TraceRequestItem.InwiB2C_Status__c = 'OK';
                    }
                }
 
                // C-Y ajout de la restriction pour le daily apex dans l'api WS70 et WS54
                 // Traitement pour WS70
                else if(TraceRequestItem.InwiB2C_API_Name__c == 'WS70'){
                    inwib2c_createEshop__e eventToCreateEshop = new inwib2c_createEshop__e();
                    eventToCreateEshop.TraceId__c = TraceRequestItem.Id;
                    createEshopEvents.add(eventToCreateEshop);
                    TraceRequestItem.InwiB2C_Status__c = 'OK';
                }
                 // Traitement pour WS54
                else if(TraceRequestItem.InwiB2C_API_Name__c == 'WS54'){
                    inwib2c_createEshop__e eventToCreateEshop = new inwib2c_createEshop__e();
                    eventToCreateEshop.TraceId__c = TraceRequestItem.Id;
                    createEshopEvents.add(eventToCreateEshop);
                    TraceRequestItem.InwiB2C_Status__c = 'OK';
              }
              // C-Y ajout de la restriction pour le daily apex dans l'api WS70 et WS54
            }//WS25SansInventory
            String StatusResil='InwiB2C_ResylCycleVie';
            String StatusExpired='InwiB2C_Expired';
            String TraceId;
            if(!ListMDNWS25WithoutInv.isEmpty()){
                List<Asset> assetList25 = [select id, AccountId,vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c from asset where vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c in: ListMDNWS25WithoutInv and vlocity_cmt__SubscriptionId__r.inwiB2C_Statut__c not in (:StatusExpired ,:StatusResil )  and vlocity_cmt__ParentItemId__c =: null];
                for (Asset assetWithoutInv25:assetList25){
                    TraceId = (String) AssetGenWS25Map.get(assetWithoutInv25.vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c);
                    InwiB2C_AssetGenerationMigPostPost__e eventToCreateAssetGenerationMigPostPost = new InwiB2C_AssetGenerationMigPostPost__e();
                    eventToCreateAssetGenerationMigPostPost.AccountId__c=assetWithoutInv25.AccountId;
                    eventToCreateAssetGenerationMigPostPost.AssetId__c =assetWithoutInv25.id;
                    eventToCreateAssetGenerationMigPostPost.Step__c= 'CreateOrder';
                    eventToCreateAssetGenerationMigPostPost.TraceId__c= TraceId;
                    InwiB2C_AssetGenerationMigPostPostEvent.add(eventToCreateAssetGenerationMigPostPost);	
                }
            }//WS01SansInventory
            if(!ListMDNWS01WithoutInv.isEmpty()){
                List<Asset> assetList01 = [select id, AccountId,vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c from asset where vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c in: ListMDNWS01WithoutInv and vlocity_cmt__SubscriptionId__r.inwiB2C_Statut__c not in (:StatusExpired ,:StatusResil )   and vlocity_cmt__ParentItemId__c =: null];
                for (Asset assetWithoutInv01:assetList01){
                    TraceId = (String) AssetGenWS01Map.get(assetWithoutInv01.vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c);
                    inwiB2C_Asset_Generation__e eventToCreateAsset_Generation = new inwiB2C_Asset_Generation__e();
                    eventToCreateAsset_Generation.AccountId__c =assetWithoutInv01.AccountId;
                    eventToCreateAsset_Generation.AssetId__c = assetWithoutInv01.id;
                    eventToCreateAsset_Generation.InwiB2C_TraceId__c = TraceId;
                    inwiB2C_Asset_GenerationEvent.add(eventToCreateAsset_Generation);	
                }
            }
            //WS95SansInventory
            if(!ListMDNWS95WithoutInv.isEmpty()){
                List<Asset> assetList95 = [select id, AccountId,vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c from asset where vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c in: ListMDNWS95WithoutInv and vlocity_cmt__SubscriptionId__r.inwiB2C_Statut__c not in (:StatusExpired ,:StatusResil )   and vlocity_cmt__ParentItemId__c =: null];
                for (Asset assetWithoutInv95:assetList95){
                    TraceId = (String) AssetGenWS95Map.get(assetWithoutInv95.vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c);
                    inwiB2C_Asset_Generation__e eventToCreateAsset_GenerationWS95 = new inwiB2C_Asset_Generation__e();
                    eventToCreateAsset_GenerationWS95.AccountId__c =assetWithoutInv95.AccountId;
                    eventToCreateAsset_GenerationWS95.AssetId__c = assetWithoutInv95.id;
                    eventToCreateAsset_GenerationWS95.InwiB2C_TraceId__c = TraceId;
                    inwiB2C_Asset_GenerationEvent.add(eventToCreateAsset_GenerationWS95);	
                }
            }            
            if(!ExecuteMigrPrePostEvent.isEmpty()){
                List <Database.SaveResult> sresultPrePost = EventBus.publish(ExecuteMigrPrePostEvent);
            }//WS25__AvecInventory
            if(!ExecuteTraitementMigPostPostSMOEvent.isEmpty()){
                List <Database.SaveResult> sresultPostPost = EventBus.publish(ExecuteTraitementMigPostPostSMOEvent);
            } //WS25__SansInventory
            if(!InwiB2C_AssetGenerationMigPostPostEvent.isEmpty()){
                List <Database.SaveResult> sresultAssetGenerationPostPost = EventBus.publish(InwiB2C_AssetGenerationMigPostPostEvent);
            }//WS01__AvecInventory
            if(!ExecuteTraitementSMOEvent.isEmpty()){
                List <Database.SaveResult> sresultSMO = EventBus.publish(ExecuteTraitementSMOEvent);
            }//WS01__SansInventory
            if(!inwiB2C_Asset_GenerationEvent.isEmpty()){
                List <Database.SaveResult> sresultAssetGenerationSMO = EventBus.publish(inwiB2C_Asset_GenerationEvent);
            }
            //WS95__AvecInventory Y_MH
            if(!ExecuteTraitementSMODisconnetvulaEvent.isEmpty()){
                List <Database.SaveResult> sresultSMO = EventBus.publish(ExecuteTraitementSMODisconnetvulaEvent);
            }
            if(!createEshopEvents.isEmpty()){
                List<Database.SaveResult> sresultEshop = EventBus.publish(createEshopEvents);
            }
            //WS93__SansInventory SOB
            if (!ListMDNWS93WithoutInv.isEmpty()) {
                List<Asset> assetList93 = [SELECT Id, AccountId, vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c 
                                        FROM Asset 
                                        WHERE vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c IN :ListMDNWS93WithoutInv
                                        AND vlocity_cmt__SubscriptionId__r.inwiB2C_Statut__c NOT IN (:StatusExpired, :StatusResil) 
                                        AND vlocity_cmt__ParentItemId__c = NULL];

                for (Asset assetWithoutInv93 : assetList93) {
                    TraceId = (String) AssetGenWS93Map.get(assetWithoutInv93.vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c);
                    inwiB2C_Asset_Generation__e eventToCreateAsset_GenerationWS93 = new inwiB2C_Asset_Generation__e();
                    eventToCreateAsset_GenerationWS93.AccountId__c = assetWithoutInv93.AccountId;
                    eventToCreateAsset_GenerationWS93.AssetId__c = assetWithoutInv93.Id;
                    eventToCreateAsset_GenerationWS93.InwiB2C_TraceId__c = TraceId;
                    inwiB2C_Asset_GenerationEvent.add(eventToCreateAsset_GenerationWS93);
                }

                if (!inwiB2C_Asset_GenerationEvent.isEmpty()) {
                    List<Database.SaveResult> sresultAssetGen = EventBus.publish(inwiB2C_Asset_GenerationEvent);
                }
            }
            //WS93__AvecInventory SOB
            if(!ExecuteTransferEvent.isEmpty()) {
                List<Database.SaveResult> sresultTransfer = EventBus.publish(ExecuteTransferEvent);
            }


            update scope;
        }
        
    }
   
    public void finish(Database.BatchableContext BC){

        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
        a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
        a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 
        String[] email = new String[]{'projet-crm-sf@inwi.ma'};
        mail.setToAddresses(email);
        mail.setReplyTo('projet-crm-sf@inwi.ma');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed'+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  
    }
}