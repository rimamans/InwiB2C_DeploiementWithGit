public with sharing class inwiB2C_ManageIdarSuspensionBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{


    String RequestQuery ;

    public Database.querylocator start(Database.BatchableContext BC){

        RequestQuery = 'select ID, InwiB2C_OrderIdar__c,InwiB2C_OrderFIXE__c,InwiB2C_OrderFIXE__r.InwiB2C_Id_Panier_Eshop__c,InwiB2C_OrderFIXE__r.inwiB2C_TypeDeMigration__c,InwiB2C_OrderIdar__r.inwiB2C_TypeDeMigration__c ,InwiB2C_OrderIdar__r.InwiB2C_Id_Panier_Eshop__c , InwiB2C_SubscriptionIdar__c, InwiB2C_CaseId__c  from InwiB2C_Order_SuspIdar__c where InwiB2C_Statut__c = \'Ready\' and ((InwiB2C_OrderIdar__c = null and InwiB2C_SubscriptionIdar__c != null) or (InwiB2C_OrderIdar__c != null and InwiB2C_SubscriptionIdar__c = null) or (InwiB2C_OrderFIXE__c != null and InwiB2C_SubscriptionIdar__c = null)) limit 200';        return Database.getQueryLocator(RequestQuery) ;         
    }
    
    public void execute(Database.BatchableContext BC, List<InwiB2C_Order_SuspIdar__c> scope){      
        
        //system.debug('batch scope'+scope);  

        List<Id> orderIdList = new List<Id>();
              //ACYL 11/03/2025 B-26828 begin*/
        List<Id> subscriptionIds = new List<Id>();

        for (InwiB2C_Order_SuspIdar__c suspIdar: scope){
            if (suspIdar.InwiB2C_OrderIdar__c != null){
                orderIdList.add(suspIdar.InwiB2C_OrderIdar__c);
            }
            if (suspIdar.InwiB2C_SubscriptionIdar__c != null) {
                subscriptionIds.add(suspIdar.InwiB2C_SubscriptionIdar__c);
            }
     
        }
      //ACYL 11/03/2025 B-26828 end*/

     
        List<inwiB2C_OrderSubscription__c> orderSubscriptionList= [select id, inwiB2C_Subscription__c, inwiB2C_Order__c  from inwiB2C_OrderSubscription__c where inwiB2C_Order__c in :orderIdList ];
        
        Map<Id,Id> subscriptionIdByOrderIdMap = new Map<Id,Id> ();
//acyl 11/03/2025 B-26828  begin*/
        List<Asset> assetList=[ SELECT Id, Product2.vlocity_cmt__Type__c ,vlocity_cmt__SubscriptionId__c   FROM Asset WHERE vlocity_cmt__SubscriptionId__c IN :subscriptionIds AND vlocity_cmt__ParentItemId__c =: null ];
        Map<Id, Asset> assetBySubscriptionMap = new Map<Id, Asset>();
        for (Asset asset :assetList){
        assetBySubscriptionMap.put(asset.vlocity_cmt__SubscriptionId__c, asset);
        }
//acyl 11/03/2025  B-26828 end*/


        for (inwiB2C_OrderSubscription__c orderSubscription: orderSubscriptionList ){
            subscriptionIdByOrderIdMap.put(orderSubscription.inwiB2C_Order__c, orderSubscription.inwiB2C_Subscription__c);
        }

        List<InwiB2C_Demande_de_resiliation__c> demandeResilList = new List<InwiB2C_Demande_de_resiliation__c>();
        Date myDate = system.today();
        String requestStatusSusp = 'En attente de suspension';

        for (InwiB2C_Order_SuspIdar__c suspIdar: scope){

            Id subscriptionId;

            if (suspIdar.InwiB2C_OrderIdar__c != null){
                subscriptionId = subscriptionIdByOrderIdMap.get(suspIdar.InwiB2C_OrderIdar__c);
                
            }else if (suspIdar.InwiB2C_SubscriptionIdar__c != null){
                subscriptionId = suspIdar.InwiB2C_SubscriptionIdar__c;

            }

            if (subscriptionId != null){

                InwiB2C_Demande_de_resiliation__c demandeResil= new InwiB2C_Demande_de_resiliation__c();
                demandeResil.InwiB2C_Subscription__c= subscriptionId;
                demandeResil.InwiB2C_Date_de_signature__c= myDate;
                demandeResil.InwiB2C_Statut_Resil__c = requestStatusSusp;
                demandeResil.InwiB2C_Type_Profil__c= 'idar duo' ;
                // Check if case exists then The Idar Pack is Dépanage. therefore delay is 45 days. otherwise delay is 15 days
                demandeResil.inwiB2C_expectedDisconnectDate__c= suspIdar.InwiB2C_CaseId__c == null ? myDate.adddays(15): myDate.adddays(45);
                demandeResil.inwiB2C_expectedSuspendDate__c= myDate;
                demandeResil.inwiB2C_Canal__c = 'Auto';
                demandeResil.InwiB2C_AnnuleFraisResil__c = true;
                demandeResilList.add(demandeResil);
                suspIdar.InwiB2C_Statut__c = 'Done';

                
              /* ACYL 28/01/2025 Start */


//chb 10/03/2025 changement de subscription id  begin*/
    //List<asset> assetParent = [SELECT id,Product2.vlocity_cmt__Type__c from asset where  vlocity_cmt__SubscriptionId__c = :suspIdar.InwiB2C_SubscriptionIdar__c ];
    //List<asset> assetParent = [SELECT id,Product2.vlocity_cmt__Type__c from asset where  vlocity_cmt__SubscriptionId__c = :subscriptionId ];
 //chb 10/03/2025 changement de subscription id  end*/ 

      //ACYL 11/03/2025 B-26828 begin*/
    if (suspIdar.InwiB2C_SubscriptionIdar__c != null) {
    //Asset assetParent = assetBySubscriptionMap.get(suspIdar.InwiB2C_SubscriptionIdar__c);
      //ACYL 11/03/2025 B-26828 end*/

    String typeDeMigration = suspIdar.InwiB2C_OrderFIXE__c != null ? suspIdar.InwiB2C_OrderFIXE__r.inwiB2C_TypeDeMigration__c : null;
    system.debug('typeDeMigrationV'+typeDeMigration);
    if (typeDeMigration == 'InwiB2C_Migration_FTTH_Vers_IDAR' || 
        typeDeMigration == 'InwiB2C_Migration_ADSL_Vers_IDAR' || 
        typeDeMigration == 'InwiB2C_Migration_FTTH_Vers_ADSL') {

        String orderId = suspIdar.InwiB2C_OrderFIXE__c != null ? suspIdar.InwiB2C_OrderFIXE__c :null;
        String externalOrderId = suspIdar.InwiB2C_OrderFIXE__c != null ? suspIdar.InwiB2C_OrderFIXE__r.InwiB2C_Id_Panier_Eshop__c : null;
         //ACYL 19/03/2025 MC-MGEN3660  start*/
        String step = 'EVENT_5';
                 //ACYL 19/03/2025 MC-MGEN3660  end*/

         /* //ACYL 11/03/2025 B-26828 begin

        if (assetParent != null) {
            if (assetParent.Product2.vlocity_cmt__Type__c == 'FTTH') {
                step = 'EVENT_6'; 
            } else if (assetParent.Product2.vlocity_cmt__Type__c == 'ADSL') {
                step = 'EVENT_7'; 
            }
        }
         //ACYL 11/03/2025 B-26828 end*/

        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('orderId', orderId);
        inputMap.put('step', step);

        if (externalOrderId != null) {
            inputMap.put('externalOrderId', externalOrderId);
        }
        system.debug('inputMap'+inputMap);
               if (!Test.isRunningTest()) {
        InwiB2C_ManageSuiviCommEvent.createEvent(inputMap, new Map<String, Object>(), new Map<String, Object>());
               }
        } 
/* ACYL 28/01/2025 end */
    }


            } else{
                suspIdar.InwiB2C_Statut__c = 'Error';
            }
        }
        if (demandeResilList.size() > 0){
            insert demandeResilList;
        }  
        update scope;
    
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