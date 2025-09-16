/*ILA INWIB2C-PHASE2 04.05.2021 BEGIN*/
@RestResource(urlMapping='/Subscription/DeactivateSubscription/*')
global with sharing class INWIB2C_DeactivateSubscription {
    @HttpPost
    global static void deactivateSubscription(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        Integer isOk;
		Integer errorCode;
		String errorMessage;
		vlocity_cmt__Subscription__c ligne;
		/*Migration inter-technologie TMA 12/01/2023 Begin*/
		List <Asset> assetToUpdateList = new List<Asset>();
		List<vlocity_cmt__InventoryItem__c> inventoryItemToUpdate = new List<vlocity_cmt__InventoryItem__c>();
		/*Migration inter-technologie TMA 12/01/2023 End*/		
        
        /*Traçabilité ILA 11/10/2021 Begin*/
        String statut;
        InwiB2C_Trace_API__c trace=new InwiB2C_Trace_API__c();
        trace.InwiB2C_API_Name__c='WS05';
        trace.InwiB2C_request_body__c=req.requestBody.toString();
        trace.InwiB2C_Status__c='ko';
        insert trace;
        /*Traçabilité ILA 11/10/2021 End*/
        
		String uuid;
		//String request= '{"CSDeactivateSub": {"mdn": "212658498300"},"CSOperationInfo": {"user" : "imane","channel" : "Legacy","uuid": "123"}}';
		try
        {
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
			Map<String, Object> m1 = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(m.get('CSDeactivateSub')));
			Map<String, Object> m2 = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(m.get('CSOperationInfo')));
    		/*Get Mdn and uuid*/
    		String mdn=String.valueof(m1.get('mdn')); 
    		uuid=String.valueof(m2.get('uuid'));
			/*Migration inter-technologie TMA 12/01/2023 Begin*/
			/* Get action*/
			String action=String.valueof(m1.get('action'));
			/*Migration inter-technologie TMA 12/01/2023 End*/
			
            
            /*Traçabilité ILA 11/10/2021 Begin*/
            trace.InwiB2C_MDN__c=mdn;
            trace.InwiB2C_uuid__c=uuid;
            /*Traçabilité ILA 11/10/2021 End*/
            
    		if(String.isBlank(mdn))
            {
                isOk=0;
    			errorCode=400;
    			errorMessage = 'bad request';
                
                /*Traçabilité ILA 11/10/2021 Begin*/
                statut='ko';
                /*Traçabilité ILA 11/10/2021 End*/
    		}
    		else
   	 		{
                try
                {
                    	/*vérifier si la ligne est existante et active*/
        			/*OGA B-16507 08/10/2024 begin */
						//ligne = [Select Id,inwiB2C_LegacyStatus__c,	inwiB2C_Statut__c,vlocity_cmt__Status__c,vlocity_cmt__BillingAccountId__r.Inwib2c_Type_d_offre__c,
                 											//Inwib2c_Offre__c,vlocity_cmt__AccountId__c From vlocity_cmt__Subscription__c
                                                            //Where Inwib2c_Num_ro_de_la_ligne__c=:mdn
                                         					//and inwiB2C_LegacyStatus__c='ACTIVE'];
						ligne = [Select Id,inwiB2C_LegacyStatus__c,	inwiB2C_Statut__c,vlocity_cmt__Status__c,vlocity_cmt__BillingAccountId__r.Inwib2c_Type_d_offre__c,
                 											Inwib2c_Offre__c,vlocity_cmt__AccountId__c ,Inwib2C_Type_Offre__c From vlocity_cmt__Subscription__c
                                                            Where Inwib2c_Num_ro_de_la_ligne__c=:mdn
                                         					 and  (inwiB2C_Statut__c='InwiB2C_Active' or inwiB2C_Statut__c='InwiB2C_Blocked' 
															 or inwiB2C_Statut__c='InwiB2C_Nonidentificationdelaligne' or inwiB2C_Statut__c='InwiB2C_EncoursDactivation' or inwiB2C_Statut__c='InwiB2C_EncoursMigration'
															 or inwiB2C_Statut__c='InwiB2C_RestreinteRecouvrement' or inwiB2C_Statut__c='InwiB2C_SuspCycleVie' or inwiB2C_Statut__c='InwiB2C_Suspended'
															 or inwiB2C_Statut__c='InwiB2C_SuspendueFacturation' or inwiB2C_Statut__c='InwiB2C_SuspendueFacturationReseau' or inwiB2C_Statut__c='InwiB2C_SuspendueFraude' 
															 or inwiB2C_Statut__c='InwiB2C_SuspendueRecouvrement')];
						/*OGA B-16507 08/10/2024 end */
            			/*vérifier si l'offre est prépayée*/
            		//if(vlocity_cmt__BillingAccountId__r.Inwib2c_Type_d_offre__c=='Prépayé')
       	    		if(ligne.Inwib2c_Offre__c == 'Offre TicTac Sim+Terminal' || ligne.Inwib2c_Offre__c =='Offre TicTac Sim Seule'
         				||ligne.Inwib2c_Offre__c == 'Pack Box Huawei B310S 4G + 20 Go' || ligne.Inwib2c_Offre__c =='Pack Box ZTE 4G + 20 Go'
         				||ligne.Inwib2c_Offre__c =='Pack Modem 3G+  + 10 Go' ||ligne.Inwib2c_Offre__c =='Pack Modem 4G + 10 Go'
           				||ligne.Inwib2c_Offre__c =='Pack My Wifi 4G + 10 Go' ||ligne.Inwib2c_Offre__c =='SIM 4G + 5 Go'||ligne.Inwib2c_Offre__c =='Offre Koulchi'
						||ligne.Inwib2c_Offre__c =='Pack Internet Direct'||ligne.Inwib2c_Offre__c =='Pack de dépannage'||ligne.Inwib2c_Offre__c =='Idar Duo 199 dhs'
						||ligne.Inwib2c_Offre__c =='Idar Duo 249 dhs'||ligne.Inwib2c_Offre__c =='Idar Duo 349 dhs'
						/*OGA B-16507 08/10/2024 begin */
						||ligne.Inwib2C_Type_Offre__c=='InwiB2C_Postpaye'
						/*OGA B-16507 08/10/2024 end */
                        //CH-Y B-28677 08/05/2025 begin
						||ligne.Inwib2c_Offre__c == 'Offre Dealer Sim Seule'
						//CH-Y B-28677 08/05/2025 end
						)
                    {
                		 	
						 /*Migration inter-technologie TMA 12/01/2023 Begin*/
						 if (action != 'SUSF') 
						  { 	
							/*Migration inter-technologie TMA 12/01/2023 END*/
							/*désactiver la ligne*/
                 		ligne.inwiB2C_LegacyStatus__c='EXPIRED'; 
                        ligne.inwiB2C_Statut__c='InwiB2C_Expired';
                        ligne.vlocity_cmt__Status__c='Expired';
					        }
							/*Migration inter-technologie TMA 12/01/2023 Begin*/
					        else 
						 {
					  /*suspendre la ligne*/
					  ligne.inwiB2C_LegacyStatus__c = 'Suspension Facturation';
					  ligne.inwiB2C_Statut__c = 'InwiB2C_SuspendueFacturation';
					  ligne.vlocity_cmt__Status__c = 'Suspended';
						  }

						  
						  /* 19/02/2025 OGH migration B2C vers B2B Begin */
						  List<InwiB2C_Demande__c> demandes = [SELECT Id, InwiB2C_Statut__c FROM InwiB2C_Demande__c 
						  WHERE InwiB2C_Subscription__c = :ligne.Id 
						  AND Type_de_modification__c = 'migration B2C vers B2B' 
						  AND InwiB2C_Statut__c != 'Finalisé'];

                          for (InwiB2C_Demande__c demande : demandes) {
                          demande.InwiB2C_Statut__c = 'Finalisé';
                          }
                          update demandes;
						
                        /* 19/02/2025 OGH migration B2C vers B2B End*/


						  /*Migration inter-technologie TMA 12/01/2023 END*/
						  Asset parentAsset=[Select Id,Status,StatusReason,vlocity_cmt__ParentItemId__c from Asset where vlocity_cmt__SubscriptionId__c=:ligne.Id and vlocity_cmt__ParentItemId__c='' ];
             	 		  List<Asset> assets = [Select Id,Status,StatusReason from Asset where vlocity_cmt__ParentItemId__c=:parentAsset.Id];
						/*Migration inter-technologie TMA 12/01/2023 begin*/
						if (action != 'SUSF') 
					    { 
							/*Migration inter-technologie TMA 12/01/2023 End*/
							
                 			/*desactiver les assets*/
             	 		 assets.add(parentAsset);
                 		for(Asset a : assets)
             	 		{  
               				a.Status='Obsolete'; 
               				a.StatusReason='Désactivé';
             	 		}
						/*Migration inter-technologie TMA 12/01/2023 begin*/
					   } else 
				     { 
					
					 Asset currentAsset=[Select Id,vlocity_cmt__JSONAttribute__c from Asset where vlocity_cmt__SubscriptionId__c=:ligne.Id and vlocity_cmt__ParentItemId__c='' ];
					 Map<String,String> assetAttributes = new Map<String,String>();
					 assetAttributes.put('INWIB2C_ATT_RT_APPELS_ENRTANT', 'Bloqué');
					 assetAttributes.put('INWIB2C_ATT_RT_APPELS_SORTANT', 'Bloqué');
					 if (currentAsset != null)
					 {
					 currentAsset.vlocity_cmt__JSONAttribute__c = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentAsset.vlocity_cmt__JSONAttribute__c, assetAttributes);
					 assetToUpdateList.add(currentAsset);
					 system.debug('currentAsset: '+currentAsset);
					 
					 }
					 /*suspendre les invtitem*/
					 vlocity_cmt__InventoryItemDecompositionRelationship__c  currentInvItemDecom = [SELECT vlocity_cmt__DestinationInventoryItemId__c,vlocity_cmt__SourceAssetId__c,vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode, vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c  FROM vlocity_cmt__InventoryItemDecompositionRelationship__c WHERE  vlocity_cmt__SourceAssetId__c =:currentAsset.Id and vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode = 'INWIB2C_RFS_VOICE'];

                    if (currentInvItemDecom != null)
                    {
	                 Map<String,String> invItemAttributes = new Map<String,String>();

	                 invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_IN', 'Bloqué');
	                 invItemAttributes.put('INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_OUT', 'Bloqué');
	                 String invItemJSON = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c, invItemAttributes);
	                 inventoryItemToUpdate.add (new vlocity_cmt__InventoryItem__c(id=currentInvItemDecom.vlocity_cmt__DestinationInventoryItemId__c, vlocity_cmt__JSONAttribute__c=invItemJSON));
	                 system.debug('currentInvItemDecom: '+currentInvItemDecom);
                    }
					    }
						/*Migration inter-technologie TMA 12/01/2023 end*/
						
              	 		try
                        {
                    		
							Update ligne;
						if (action != 'SUSF') 
					    { 
                    		Update assets;
						}
							/*Migration inter-technologie TMA 12/01/2023 begin*/
							if(assetToUpdateList.size() > 0 ){
								update assetToUpdateList;
							}
							if (inventoryItemToUpdate.size() > 0){
								update inventoryItemToUpdate;
							} 
							/*insert into demande resiliation */
							if (action == 'SUSF') 
					       { 
							Date resiliationDate = Date.today().addDays(15);
							InwiB2C_Demande_de_resiliation__c newdemandeResil = new InwiB2C_Demande_de_resiliation__c(
								InwiB2C_Account__c =ligne.vlocity_cmt__AccountId__c , inwiB2C_expectedDisconnectDate__c=resiliationDate, InwiB2C_Statut_R_tention__c='Non Retenu', InwiB2C_Statut_Resil__c='En attente de résiliation', InwiB2C_Subscription__c=ligne.Id, inwiB2C_num_Ligne__c=mdn, InwiB2C_AnnuleFraisResil__c = true);
							insert newdemandeResil;
						   }
							/*Migration inter-technologie TMA 12/01/2023 end*/
               			}catch(DmlException e) {
    						System.debug('An unexpected error has occurred: ' + e.getMessage());
                    	    isOk=0;
    						errorCode=304;
    						errorMessage = 'Erreur de désactivation de ligne';
                            /*Traçabilité ILA 11/10/2021 Begin*/
                             statut='ko';
                           /*Traçabilité ILA 11/10/2021 End*/
						}
                    	isOk=1;
    					errorCode=200;
    			    	errorMessage = 'SUCCESS';
                        /*Traçabilité ILA 11/10/2021 Begin*/
                        statut='ok';
                        /*Traçabilité ILA 11/10/2021 End*/
                		}
             		  else
                	{
                    	errorCode=200;
    					errorMessage='offre non prépayée';
            			isOk=0;
                       /*Traçabilité ILA 11/10/2021 Begin*/
                         statut='ko';
                       /*Traçabilité ILA 11/10/2021 End*/
                	}
        	}
        	catch (Exception e) {
                	System.debug('An unexpected error has occurred: ' + e.getMessage());
                    isOk=0;
    				errorCode=200;
    				errorMessage='ligne inexistante ou inactive';
                   /*Traçabilité ILA 11/10/2021 Begin*/
                    statut='ko';
                   /*Traçabilité ILA 11/10/2021 End*/
            }
        
    }	
	}catch(Exception e){
    	isOk=0;
    	errorCode=200;
    	errorMessage = 'bad request';
     /*Traçabilité ILA 11/10/2021 Begin*/
       statut='ko';
      /*Traçabilité ILA 11/10/2021 End*/
	}
        /*Response*/
	Map<String, String> result=new Map<String,String>();
	result.put('errorCode',String.valueOf(errorCode));
	result.put('isOk',String.valueOf(isOk));
	result.put('errorMessage',errorMessage);
	result.put('uuid',uuid);
    res.addHeader('charset', 'UTF-8 Server');
    res.addHeader('Content-Type', 'application/json');
    res.responseBody = blob.valueOf('{"CSOperationResultInfo": '+ JSON.serialize(result)+'}');
    res.statusCode = errorCode;
        
    /*Traçabilité ILA 11/10/2021 Begin*/
    trace.InwiB2C_Response__c=res.responseBody.toString();
    trace.InwiB2C_Status__c=statut;
        update trace;
    /*Traçabilité ILA 11/10/2021 End*/
        
	}
}
/*ILA INWIB2C-PHASE2 04.05.2021 END*/