global with sharing  class inwiB2C_CreateContractIdentification implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        if(methodName.equals('changeAccountOfContract_OS')){
            changeAccountOfContract_OS(inputMap, outMap, options);
           
            }                              
      

        return result;
  }
    
     public static void changeAccountOfContract_OS(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

    try {

        Map<String,Object> linkingInput = (Map<String,Object>) inputMap.get('linkingInput');

        String idContractStr = (String) linkingInput.get('idContract');
        String mdn = (String) linkingInput.get('mdn');
        String icc = (String) linkingInput.get('icc');
        Id idContract;
        if(idContractStr.equals('')) idContract = null;
        else idContract = Id.valueOf(idContractStr);
        /*chb 02/10/2024 begin */
        String idSubscription = (String) linkingInput.get('idSubscription');
        Id SubscriptionId = String.isBlank(idSubscription) ? null : Id.valueOf(idSubscription);
        System.debug('SubscriptionId'+SubscriptionId);
        /*chb 02/10/2024 end */

        String idAccountStr =  (String) linkingInput.get('idAccount');
        Id idAccount;
        if(idAccountStr.equals('')) idAccount = null;
        else idAccount = Id.valueOf(idAccountStr);
    if(!Test.isRunningTest()){
        Id returnedId = inwiB2C_CreateContractIdentification.changeAccountOfContract(idContract,idAccount,mdn,icc,SubscriptionId);
         System.debug('ContractId: '+returnedId);                 
        outMap.put('ContractId', returnedId);
    }else{
        inwiB2C_CreateContractIdentification.changeAccountOfContract(idContract,idAccount,mdn,icc,SubscriptionId);
    }
       
    
    } catch (Exception e) {
        outMap.put('ContractId', null);
        System.debug('Exception: '+e);                 

    } finally {
        
    }

   }
   
    public static Id changeAccountOfContract(Id idContract,Id idAccount,String mdn,String icc,Id SubscriptionId) {
        //SOB TICKET N B-28060 --START
        Contract oldContract = [SELECT 
        AccountId,vlocity_cmt__ActiveContractVersionId__c,InwiB2C_Address__c,InwiB2C_Agence_d_identification__c,InwiB2C_Ancien_n_de_ligne__c,vlocity_cmt__IsAutoRenew__c,Canal_d_identification__c,InwiB2C_Categorie_client__c,InwiB2C_Choix_principal_op_rateur__c,InwiB2C_Civilite__c,InwiB2C_Code_bayn_shop__c,InwiB2C_Commentaires__c,CompanySignedId,CompanySignedDate,CurrencyIsoCode,vlocity_cmt__ContractGroupId__c,Name,OwnerId,RecordTypeId,vlocity_cmt__ContractReferenceNumber__c,StartDate,ContractTerm,vlocity_cmt__ContractType__c,CustomerSignedId,CustomerSignedDate,CustomerSignedTitle,InwiB2C_Date_changement_statut_Numerique__c,InwiB2C_Date_changement_statut_Physique__c,InwiB2C_Date_CRM__c,InwiB2C_Date_de_desidentification__c,InwiB2C_Date_de_la_commande__c,InwiB2C_Date_de_naissance__c,InwiB2C_Date_de_reception_de_dossier__c,InwiB2C_Date_de_souscription__c,InwiB2C_date_d_identification__c,Description,InwiB2C_Distributeur_Identification__c,InwiB2C_Distributeur__c,InwiB2C_Distributeur_Agence_idntfc__c,vlocity_cmt__LastDocumentBatchJobError__c,vlocity_cmt__LastDocumentBatchJobId__c,vlocity_cmt__LastDocumentBatchJobStatus__c,InwiB2C_Echange_express__c,InwiB2C_Email__c,InwiB2C_Entreprise__c,vlocity_cmt__ExpirationReason__c,vlocity_cmt__ExpiredContractId__c,InwiB2C_Figure_dans_l_annuaire_WANA__c,InwiB2C_ICC2__c,vlocity_cmt__IsFrameContract__c,vlocity_cmt__LocaleCode__c,vlocity_cmt__LastDocuSignEnvelopeId__c,vlocity_cmt__LastDocuSignEnvelopeStatus__c,vlocity_cmt__LastDocuSignJobId__c,InwiB2C_Lien_vers_la_fiche_Dealer__c,InwiB2C_Lien_vers_la_fiche_Distributeur__c,InwiB2C_MDN_Dealer__c,InwiB2C_Motif_incompletude_Numeriqu__c,InwiB2C_Motif_incompletude_Physique__c,InwiB2C_Motif_de_non_conformit__c,InwiB2c_Nom__c,
        InwiB2C_Num_CIN__c,InwiB2C_Numero_Terminal__c,InwiB2C_N_Ligne__c,vlocity_cmt__OpportunityId__c,vlocity_cmt__OrderId__c,vlocity_cmt__OriginalContractId__c,OwnerExpirationNotice,vlocity_cmt__ParentContractId__c,InwiB2C_Patente__c,InwiB2C_Point_de_vente_CMD__c,InwiB2C_Point_de_vente_Identification__c,InwiB2C_Porta__c,InwiB2C_Possession_Fixe__c,InwiB2C_Possession_Internet__c,InwiB2C_Possession_Mobile__c,Pricebook2Id,vlocity_cmt__PriceListId__c,InwiB2C_Prix_de_Vente__c,inwiB2C_Profession__c,InwiB2C_Profil_Gratuit__c,InwiB2c_Prenom__c,vlocity_cmt__QuoteId__c,InwiB2C_Registre_de_commerce__c,vlocity_cmt__RenewalStartDate__c,vlocity_cmt__AutoRenewObjectCreation__c,vlocity_cmt__RenewalNotification__c,vlocity_cmt__RenewalNotificationTerm__c,InwiB2C_Segmentation__c,InwiB2C_Segmentation2__c,vlocity_cmt__SendRenewalNotification__c,InwiB2C_Sexe__c,InwiB2C_Signature_PDV__c,inwiB2C_Solde_Initital__c,InwiB2C_Source_de_reception__c,SpecialTerms,Status,InwiB2C_statut_contrat__c,InwiB2C_Statut_Contrat_Num_rique__c,InwiB2C_Statut_d_identification__c,InwiB2C_Statut_Dossier__c,Subscription__c,InwiB2C_Subscription_contract__c,vlocity_cmt__TerminateDate__c,vlocity_cmt__TerminationReason__c,vlocity_cmt__TerminationType__c,InwiB2C_Type_CIN__c,InwiB2C_Telephone_contact__c,InwiB2C_Usage_internet__c,    
        inwib2c_Qualification__c, inwib2c_Identification__c
        FROM Contract WHERE Id=:idContract];
        //SOB TICKET N B-28060 --END
        if(idAccount==null || idContract==null){

            System.debug('Error in the input of changeAccountOfContract method in the class inwiB2C_changeAccountOfContract');                 
            System.debug('No record has been affected');                 

            return null;
        }
        else if(oldContract.AccountId==idAccount){
            System.debug('The contract has already the same Account');                 
            System.debug('No contract created:'+idContract);                 

            
            return idContract;
        }else{

        
        Contract newContract = new Contract();
        
        newContract=oldContract.clone();
        String status = oldContract.Status;
        System.debug('befre::status: ' + status);                 
        System.debug('befre::oldContract.Status: ' + oldContract.Status);                 
        System.debug('befre::newContract.Status: ' + newContract.Status);                 

        newContract.AccountId = idAccount;
        newContract.Status = null;
        newContract.OwnerId = UserInfo.getUserId() ;
        //SOB TICKET N B-28060 --START
        newContract.inwib2c_Qualification__c = true;
        newContract.inwib2c_Identification__c = true;
        //SOB TICKET N B-28060 --END

        insert newContract;

        System.debug('after::status: ' + status);                 
        System.debug('after::oldContract.Status: ' + oldContract.Status);                 
        System.debug('after::newContract.Status: ' + newContract.Status);                 

        if(status!=null){
            newContract.Status = status;
            update newContract;
        }
/*
      if(!Test.isRunningTest()){
        ContentDocumentLink[] files = [select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:idContract];        
        List<ContentDocumentLink> listFilesToInsert = new List<ContentDocumentLink>();
            for(ContentDocumentLink file : files) {
                ContentDocumentLink newclnk = file.clone();
                newclnk.LinkedEntityId=newContract.Id;
                listFilesToInsert.add(newclnk);
        }
     insert listFilesToInsert;
      }*/

        InwiB2C_Subscription_contract__c[] subsC = [select Id,InwiB2C_MDN__c,Name from InwiB2C_Subscription_contract__c where InwiB2C_Contract__c=:idContract AND  InwiB2C_MDN__c =: mdn AND InwiB2C_ESN_ICC__c =: icc];        
        List<InwiB2C_Subscription_contract__c> listSubConToUpdate = new List<InwiB2C_Subscription_contract__c>();
        if(subsC!=null && !subsC.isEmpty()) {    
        for(InwiB2C_Subscription_contract__c subC : subsC) {
                subC.InwiB2C_Contract__c = newContract.Id;
                listSubConToUpdate.add(subC);
        }
        update listSubConToUpdate;
    }
       /* chb 02/10/2024 begin */
       /* vlocity_cmt__Subscription__c[] subs = [select Id,Inwib2c_Num_ro_de_la_ligne__c,Name from vlocity_cmt__Subscription__c where InwiB2C_Contract__c=:idContract];        
        List<vlocity_cmt__Subscription__c> listSubToUpdate = new List<vlocity_cmt__Subscription__c>();
      
            for(vlocity_cmt__Subscription__c sub : subs) {
                sub.InwiB2C_Contract__c = newContract.Id;
                System.debug('sub.Inwib2c_Num_ro_de_la_ligne__c: ' + sub.Inwib2c_Num_ro_de_la_ligne__c);                 
                System.debug('subsC[0].InwiB2C_MDN__c: ' + subsC[0].InwiB2C_MDN__c);                 
              
                    sub.vlocity_cmt__AccountId__c = idAccount;
                    listSubToUpdate.add(sub);
            }*/
            List<vlocity_cmt__Subscription__c> subscriptionsToUpdate = new List<vlocity_cmt__Subscription__c>();

            vlocity_cmt__Subscription__c sub = new vlocity_cmt__Subscription__c(
            Id = SubscriptionId, 
            vlocity_cmt__AccountId__c = idAccount,  // Met à jour l'AccountId
            InwiB2C_Contract__c = newContract.Id    // Met à jour le contrat 
          
        );
        subscriptionsToUpdate.add(sub);

       
//*****************************************UpdateASSET******************************************************************
           Asset[]  assets2;
            List<Asset> listAssetToUpdate = new List<Asset>(); 
			 Asset[] assets1 = [select id from Asset where vlocity_cmt__SubscriptionId__c = :SubscriptionId and vlocity_cmt__ParentItemId__c=:'' ];        
                        System.debug('assets1: ' + assets1);
             
            	  assets2 = [select id,AccountId from Asset where vlocity_cmt__RootItemId__c  =: assets1[0].id];        
                        System.debug('assets2: ' + assets2); 
                                        
				 for(Asset asset : assets2) {
                    asset.AccountId=idAccount;
                    listAssetToUpdate.add(asset);
                     //listAssetToUpdate.add(new Asset (id = asset.Id, AccountId  = idAccount));
                    
               
                 } system.debug('listAssetToUpdate:'+listAssetToUpdate);

                 
       
//****************************************UpdateInventoryItem***********************************************************
            //getInventoryItem from vlocity_cmt__InventoryItemDecompositionRelationship__c
            
      
            vlocity_cmt__InventoryItemDecompositionRelationship__c[] var_InventoryItemDecompositionRelationship = [select  vlocity_cmt__DestinationInventoryItemId__c from vlocity_cmt__InventoryItemDecompositionRelationship__c 
            where vlocity_cmt__SourceAssetId__c in :assets2];
            
            List<Id> listIdInventoryItem = new List<Id>();

            for(vlocity_cmt__InventoryItemDecompositionRelationship__c element :var_InventoryItemDecompositionRelationship){
                listIdInventoryItem.add(element.vlocity_cmt__DestinationInventoryItemId__c);
            }


            vlocity_cmt__InventoryItem__c  [] inventoryItem = [select  Id, vlocity_cmt__AccountId__c from vlocity_cmt__InventoryItem__c  
            where Id in :listIdInventoryItem];     
            List<vlocity_cmt__InventoryItem__c> InventoryItemList =new List <vlocity_cmt__InventoryItem__c>();   
            System.debug('var_InventoryItemDecompositionRelationship: ' + var_InventoryItemDecompositionRelationship);                 
            
            
            for(vlocity_cmt__InventoryItem__c inventoryItemListB :inventoryItem ){
                inventoryItemListB.vlocity_cmt__AccountId__c=idAccount;
                InventoryItemList.add(inventoryItemListB);
               // InventoryItemList.add(new vlocity_cmt__InventoryItem__c (id = inventoryItemDec.vlocity_cmt__DestinationInventoryItemId__c, vlocity_cmt__AccountId__c  = idAccount));
            }
          system.debug('InventoryItemList:'+InventoryItemList);
//******************************************UPDATE**********************************************************************
               
            if (!InventoryItemList.isEmpty()) {
                update InventoryItemList;
            }
            update listAssetToUpdate;
            update subscriptionsToUpdate;    
        

      System.debug('Id.valueOf(idContract): ' + Id.valueOf(idContract));                 
      System.debug('Id.valueOf(newContract.Id): ' + Id.valueOf(newContract.Id));                 

     InwiB2C_AttachmentsManagement.attachmentsAssignment(Id.valueOf(idContract),Id.valueOf(newContract.Id),'CONTRACT','CONTRACT');

        System.debug('id newContract: ' + newContract.Id);                 
          
              return newContract.Id;

        }
    } 
   }