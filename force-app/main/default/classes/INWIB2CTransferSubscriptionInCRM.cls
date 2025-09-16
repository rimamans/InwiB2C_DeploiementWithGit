/**
 * @description       : 
 * @author            : 
 * @group             : 
 * @last modified on  : 
 * @last modified by  : 
**/

global class INWIB2CTransferSubscriptionInCRM implements vlocity_cmt.XOMOrchestrationInterfaces.IAutoTask{
	global void executeBatch(List < vlocity_cmt__OrchestrationItem__c > items) {
	  //String subscriptionId = 'a4k3M0000008jnQQAQ';	
      vlocity_cmt__OrchestrationItem__c orchestrationItem = [select id, vlocity_cmt__OrderItemId__c,vlocity_cmt__FulfilmentRequestLineId__c from vlocity_cmt__OrchestrationItem__c where id =: items[0].id LIMIT 1];
		
      Id oiId = orchestrationItem.vlocity_cmt__OrderItemId__c;
        if(oiId == null){
            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FulfilmentRequestLineDecompRelationship = [select id,vlocity_cmt__SourceOrderItemId__c from vlocity_cmt__FulfilmentRequestLineDecompRelationship__c where vlocity_cmt__DestinationFulfilmentRequestLineId__c =: orchestrationItem.vlocity_cmt__FulfilmentRequestLineId__c  and vlocity_cmt__SourceOrderItemId__r.vlocity_cmt__ParentItemId__c =''
                                                                                                              LIMIT 1];
            oiId = FulfilmentRequestLineDecompRelationship.vlocity_cmt__SourceOrderItemId__c;
        }
	  OrderItem orderItem = [SELECT  id,vlocity_cmt__BillingAccountId__c,vlocity_cmt__AssetId__c,OrderId,vlocity_cmt__ServiceAccountId__c from OrderItem where id =: oiId LIMIT 1];
      Id orderId = orderItem.OrderId;
      String smoType ='';
      String newAccountId = '';
      Order order = [SELECT ID,inwiB2C_TypeActeDeGestion__c , InwiB2C_New_Account_Id__c from order where ID =: orderId LIMIT 1];
      if (order != null)
      smoType = order.inwiB2C_TypeActeDeGestion__c;
      newAccountId = order.InwiB2C_New_Account_Id__c; 
      Id billingAccountId = orderItem.vlocity_cmt__BillingAccountId__c;
      Id customerAccountId = orderItem.vlocity_cmt__ServiceAccountId__c;
      Id AssetId = orderItem.vlocity_cmt__AssetId__c;
      Asset  asset = [select ID,vlocity_cmt__SubscriptionId__c from Asset where id =: AssetId LIMIT 1 ];
      Id subscriptionId = asset.vlocity_cmt__SubscriptionId__c;
      /**Demande de partage ILA 24/12/24 Start 
      ajouter le champ InwiB2C_Operateur_infrastructure__c pour clone
      */
      vlocity_cmt__Subscription__c  subscription  = [select Id,InwiB2C_Operateur_infrastructure__c,Name,vlocity_cmt__AccountId__c,vlocity_cmt__BillingAccountId__c,vlocity_cmt__CurrentContractEndDate__c,vlocity_cmt__CurrentContractId__c,vlocity_cmt__CurrentContractStartDate__c,			
														vlocity_cmt__CurrentContractTerm__c,vlocity_cmt__EndDate__c,vlocity_cmt__PremisesId__c,vlocity_cmt__ServiceAccountId__c,vlocity_cmt__ServiceContactId__c,vlocity_cmt__StartDate__c,
														vlocity_cmt__Status__c,vlocity_cmt__SubscriptionNumber__c,vlocity_cmt__SuspendDate__c,InwiB2C_Cycle_de_facturation__c,InwiB2C_Date_d_activation__c,InwiB2C_Date_de_fin_d_engagement__c,
														InwiB2C_Date_de_r_engagement__c,InwiB2C_Dur_e_d_engagement__c,InwiB2C_IMSI__c,InwiB2C_Id_profil__c,InwiB2C_MEI__c,InwiB2C_Point_de_vente__c,InwiB2C_Statut_du_compte_de_facturation__c,
														InwiB2C_Type_Client__c,InwiB2C_Type_de_Handset__c,Inwib2c_ICC__c,Inwib2c_Num_ro_de_la_ligne__c,Inwib2c_Offre__c,Inwib2c_Profil__c,Inwib2c_SegmentLigne__c,Inwib2c_Terminal__c,Inwib2c_Type_de_forfait__c,
														Inwib2c_code_puk__c,Inwib2c_type_de_sim__c,inwiB2C_LegacyCreationDate__c,inwiB2C_LegacyStatus__c,inwib2c_inst_prod_id__c,inwib2c_vip__c,InwiB2C_Code_Article__c,vlocity_cmt__OldMSISDN__c,
														vlocity_cmt__ServiceIdentifier__c,InwiB2C_Canal__c,InwiB2C_Contract__c,InwiB2C_Distributeur__c,InwiB2C_Incentive__c,InwiB2C_MDN__c,InwiB2C_Partenaire__c,InwiB2C_Profie_Name__c,Inwib2C_Type_Offre__c,
														inwiB2C_NombreActivationClientParJour__c,inwiB2C_OptionIdentification__c,inwiB2C_Statut__c,inwiB2C_managedInSF__c,InwiB2C_Segment_March__c,inwiB2C_Type_de_Ligne__c,InwiB2C_FMS__c,
                            InwiB2C_FMD__c,InwiB2C_Code_de_transaction_FMS__c,InwiB2C_Code_de_transaction_FMD__c from vlocity_cmt__Subscription__c where id =: subscriptionId LIMIT 1];
      /**Demande de partage ILA 24/12/24 End */
      ID oldSubscriptionId  = subscription.Id;
      String oldSubscriptionNumber = subscription.vlocity_cmt__SubscriptionNumber__c;
      subscription.inwiB2C_Statut__c = 'InwiB2C_Expired';
      subscription.inwiB2C_LegacyStatus__c = 'EXPIRED';
       /*B-6440 DLE 22/11/2022 begin */
       subscription.INWIB2C_NoSynchronize__c=true;
        /*B-6440 DLE 22/11/2022 end */
      subscription.vlocity_cmt__SubscriptionNumber__c  =oldSubscriptionId;
      update subscription;
      // fin traitement sur la souscription existante;
      vlocity_cmt__Subscription__c clonedSubscription   = subscription.clone(false,false,false,false);
      clonedSubscription.inwiB2C_Statut__c = 'InwiB2C_Active';
      clonedSubscription.inwiB2C_LegacyStatus__c = 'ACTIVE';
      clonedSubscription.vlocity_cmt__SubscriptionNumber__c  = oldSubscriptionNumber;
      clonedSubscription.vlocity_cmt__BillingAccountId__c = billingAccountId;
      clonedSubscription.INWIB2C_IMPORTED_LEGACY__c = false;
      clonedSubscription.inwib2c_inst_prod_id__c = null;
      clonedSubscription.vlocity_cmt__AccountId__c  = newAccountId;

      
        
      if(String.isNotBlank(smoType) && smoType.equalsIgnoreCase('inwiB2C_ChangementTitulaire')){
      	clonedSubscription.vlocity_cmt__AccountId__c = customerAccountId;      
      }
      insert clonedSubscription;
      vlocity_cmt__Subscription__c  subscription2  = [select id,InwiB2C_MDN__c,inwiB2C_Statut__c,vlocity_cmt__AccountId__c,vlocity_cmt__SubscriptionNumber__c from vlocity_cmt__Subscription__c where id =: clonedSubscription.Id LIMIT 1];

      //Asset asset = [select id,vlocity_cmt__SubscriptionId__c from asset where vlocity_cmt__SubscriptionId__c =: subscriptionId limit 1];
      asset.vlocity_cmt__SubscriptionId__c =  clonedSubscription.Id;
      update asset;
      /*DLE B-7033 23/12/2022 begin */
        //insert in object OrderSubscriptions
              inwiB2C_OrderSubscription__c newsubscOrder = new inwiB2C_OrderSubscription__c(
                  inwiB2C_Order__c = orderId,
                  inwiB2C_Subscription__c = clonedSubscription.Id);
              insert newsubscOrder;
       /*DLE B-7033 23/12/2022 End */




  }
}