/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-18-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class INWIB2CCreateSubscription implements vlocity_cmt.XOMOrchestrationInterfaces.IAutoTask {
    global void executeBatch(List < vlocity_cmt__OrchestrationItem__c > items) {
  
        vlocity_cmt__OrchestrationItem__c OrchPLan = [select id, vlocity_cmt__OrderItemId__c from vlocity_cmt__OrchestrationItem__c where id =: items[0].id LIMIT 1];
        String orditemId = OrchPLan.vlocity_cmt__OrderItemId__c;
        createorupdatesubscription(orditemId);
  
    }
  
    public static void createorupdatesubscription(Id orditemId) {
  
        //get order id from orderitem
        string ordId = '';
        string action = '';
        string offre = '';
        /*B-5394 ILA 22/09/2022 begin */
         decimal fms;
         decimal fmd;
         String CodeTransactionFMD;
         String CodeTransactionFMS;
              /*B-5394 ILA 22/09/2022 end */
        /*Vue 360 Sous ILA 15/04/2022 begin */
         decimal prixAbonn;
        /*Vue 360 Sous ILA 15/04/2022 end */
        /*W-000162 ILA 25/01/2022 Begin*/
        string typeOffre = '';
        /*W-000162 ILA 25/01/2022 End*/
        /*W-000177 ILA 08/02/2022 begin */
        string typeLigne = '';
        String typeLigneValue = '';
        /*W-000177 ILA 08/02/2022 END */
        /*Vue 360 ILA 13/04/2022 begin */
         string gammeOffre = '';
         String gammeOffreValue = '';
       /*Vue 360 ILA 13/04/2022 END */
        OrderItem orderidlist = [select orderid from OrderItem where id =: orditemId ];
        system.debug('xxxxxxxxxxxxxxxxxxxxx:'+orditemId);
        ordId = orderidlist.orderid;
        system.debug('yyyyyyyyyyyyyyyyyy:'+ordId);
        /*TTM Sav Idar ILA 4/3/2024  Start*/
        //Order orderlist = [select id,AccountId,vlocity_cmt__DefaultBillingAccountId__c,inwiB2C_MotifChangementCarteSim__c, inwib2c_Partenaire__r.inwib2c_CodePartenaire__c, inwib2c_TypeDeLaCommande__c, inwiB2C_TypeActeDeGestion__c, inwiB2C_TypeDeMigration__c, inwib2c_Distributeur__c, inwib2c_Partenaire__c, inwib2c_Canal__c, ContractId, OrderNumber, CreatedDate, Account.vlocity_cmt__PersonContactId__c,Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,Account.vlocity_cmt__PersonContactId__r.Phone, inwiB2C_MotifDeSuspension__c, inwib2c_AvecPortabilite__c, vlocity_cmt__EffectiveOrderTotal__c, Contract.id,vlocity_cmt__DefaultServiceAccountId__c,Account.vlocity_cmt__PersonContactId__r.FirstName,Account.vlocity_cmt__PersonContactId__r.LastName,Account.InwiB2C_Num_ro_de_contact__c,Account.vlocity_cmt__PersonContactId__r.InwiB2C_Type_CIN__c,inwib2c_DetailMotif__c,InwiB2C_Subscription_Migration__c,InwiB2C_Offre__c,Old_Account_id__c from order where id =: ordId];
        Order orderlist = [select id,EffectiveDate, InwiB2C_CodeTransactionFMD__c,InwiB2C_Code_de_transaction_FMS__c,AccountId,vlocity_cmt__DefaultBillingAccountId__c,inwiB2C_MotifChangementCarteSim__c, inwib2c_Partenaire__r.inwib2c_CodePartenaire__c, inwib2c_TypeDeLaCommande__c, inwiB2C_TypeActeDeGestion__c, inwiB2C_TypeDeMigration__c, inwib2c_Distributeur__c, inwib2c_Partenaire__c, inwib2c_Canal__c, ContractId, OrderNumber, CreatedDate, Account.vlocity_cmt__PersonContactId__c,Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,Account.vlocity_cmt__PersonContactId__r.Phone, inwiB2C_MotifDeSuspension__c, inwib2c_AvecPortabilite__c, vlocity_cmt__EffectiveOrderTotal__c, Contract.id,vlocity_cmt__DefaultServiceAccountId__c,Account.vlocity_cmt__PersonContactId__r.FirstName,Account.vlocity_cmt__PersonContactId__r.LastName,Account.InwiB2C_Num_ro_de_contact__c,Account.vlocity_cmt__PersonContactId__r.InwiB2C_Type_CIN__c,inwib2c_DetailMotif__c,InwiB2C_Subscription_Migration__c,InwiB2C_Offre__c,Old_Account_id__c from order where id =: ordId];
        /*TTM Sav Idar ILA 4/3/2024  End*/
        Account account1=[Select id,vlocity_cmt__Status__c from Account where id =:orderlist.AccountId  limit 1];
        Boolean flagporta = orderlist.inwib2c_AvecPortabilite__c;
        Decimal prixvente = orderlist.vlocity_cmt__EffectiveOrderTotal__c;
        String serviceAccountId;
        string mdn = '';
        string IMEI = '';
        string profileid = '';
        string forfait = '';
        string icc = '';
        string imsi = '';
        string puck = '';
        string accoutid = orderlist.AccountId;
        string contactid = orderlist.Account.vlocity_cmt__PersonContactId__c;
        string pos = orderlist.inwib2c_Partenaire__c;
        string distrib = orderlist.inwib2c_Distributeur__c;
        string canal = orderlist.inwib2c_Canal__c;
        string contrat = orderlist.ContractId;
        string idcontrat = orderlist.Contract.id;
        /*Get billingAccountFromOrderItem ILA 20/05/2022 begin */
        //string billingaccount = orderlist.vlocity_cmt__DefaultBillingAccountId__c;
        string billingaccount='';
        /*Get billingAccountFromOrderItem ILA 20/05/2022 End */
        string cintype = '';
        string natureoffre = '';
        string choixnimber = '';
        string portednumber = '';
        string operator = '';
        string newrout = '';
        string descroperator = '';
        string Terminal = '';
        string libeletterminal;
        string articlesim;
        /*B-2458 DLE 23/07/2021 begin */
        string productcode = '';
        double nbractivclient = 0;
        /*B-2458 DLE 23/07/2021 end */
        /*B-2423 DLE 27/07/2021 begin */
        Date myDateporta;
        /*B-2423 DLE 27/07/2021 end */
        /*B-2675 DLE 06/09/2021 begin*/
        string rootorderitem;
        /*B-2675 DLE 06/09/2021 end*/
        /*B-3097 DLE 12/11/2021 begin */
        decimal prixterm;
        decimal prixsim;
        /*B-3097 DLE 12/11/2021 end */
        /*B-3144 DLE 23/11/2021 begin*/
        string source;
        /*B-3144 DLE 23/11/2021 end*/
         /*RIO  begin */
         string coderio = '';
         /*RIO end */
        /*B-7538 ILA 18/01/2023 begin */
        string dureeEngag = '';
        String dureeEngagValue = '';
        /*B-7538 ILA 18/01/2023 END */
        /*B-3798 DLE 30/03/2022 begin */
        string ProductType ;
        String typeComm;
        /*B-3798 DLE 30/03/2022 end */

        /**ESim ILA 01/04/2024 End */
        String typeSim=''; 
        /**ESim ILA 01/04/2024 End */

        /**B-14273 ILA 19/02/2024 Start */
        /*
         String dslamPort = '';
         String statutLigneIam = '';
         String technoDegroupage = '';
         String positionReglette = '';
         Date rendezvous ;
         */
         /**B-14273 ILA 19/02/2024 Start */

          /**B-8863  TMA 27/04/2023 Begin*/
         String cin = orderlist.Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c;
         
          /**B-8863  TMA 27/04/2023 End*/
        /**Demande de partage ILA 26/02/25 Start */
        String operInfra='';
        String statutPartage='';
        /**Demande de partage ILA 26/02/25 Start */

       

        /*B-7259 ILA 12/01/2023 begin */
        Date dateLimiteSR;
        InwiB2C_delai_stdr_satisfait_rembourse__mdt delai = [Select id,InwiB2C_delai__c from InwiB2C_delai_stdr_satisfait_rembourse__mdt where DeveloperName='InwiB2C_Satisfait_ou_Rembourse'];
        DateTime dateLimite = System.now();
        dateLimite = dateLimite.addDays(Integer.valueOf(delai.InwiB2C_delai__c)); 
        dateLimiteSR = date.newinstance(dateLimite.year(), dateLimite.month(), dateLimite.day());
        /*B-7259 ILA 12/01/2023 end */
        Datetime activationDate = Datetime.now();
        //get attributs from order offer
        List < OrderItem > ordItemoffer = [SELECT id,Order.inwib2c_TypeDeLaCommande__c,Order.inwiB2C_TypeDeMigration__c,Product2.ProductCode,vlocity_cmt__BillingAccountId__c, vlocity_cmt__Action__c, vlocity_cmt__JSONAttribute__c, product2.vlocity_cmt__Type__c,product2.Name, vlocity_cmt__RootItemId__c,vlocity_cmt__RecurringCharge__c,product2.Family,InwiB2C_FMS__c,InwiB2C_FMD__c,InwiB2C_TransactionCode_FMS__c,InwiB2C_TransactionCode_FMD__c FROM OrderItem
            WHERE id =: orditemId
        ];
        /*B-5394 ILA 27/09/2022 begin */
        Asset assetDisconnect;
        if(orderlist.inwiB2C_TypeDeMigration__c == 'Migration Postpayé Postpayé' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Retention_Cascade')
        {
          OrderItem orderItemDisc = [select id from orderitem where vlocity_cmt__Action__c ='Disconnect' and vlocity_cmt__ParentItemId__c = null and OrderId =: ordId];
          assetDisconnect = [select id,vlocity_cmt__SubscriptionId__r.InwiB2C_FMD__c,vlocity_cmt__SubscriptionId__r.InwiB2C_FMS__c,vlocity_cmt__SubscriptionId__r.InwiB2C_Code_de_transaction_FMD__c,vlocity_cmt__SubscriptionId__r.InwiB2C_Code_de_transaction_FMS__c,vlocity_cmt__SubscriptionId__r.InwiB2C_date_limite_satisfait_rembours__c,vlocity_cmt__SubscriptionId__r.InwiB2C_Date_d_activation__c from asset where vlocity_cmt__OrderProductId__c =: orderItemDisc.Id ];
        }
        /*B-5394 ILA 27/09/2022 end */
        system.debug('ordItemoffer------> ' + ordItemoffer);
        if (ordItemoffer.size() > 0) {
            for (OrderItem ordLineItem: ordItemoffer) {
                /*B-2458 DLE 23/07/2021 begin */
                productcode = ordLineItem.Product2.ProductCode;
                /*B-2458 DLE 23/07/2021 end */
                 /*B-3798 DLE 30/03/2022 begin */
                ProductType = ordLineItem.product2.vlocity_cmt__Type__c ;
                typeComm = ordLineItem.Order.inwib2c_TypeDeLaCommande__c;
                offre = ordLineItem.product2.Name;
                /*B-3798 DLE 30/03/2022 end */
                /*B-2675 DLE 06/09/2021 begin*/
                rootorderitem = ordLineItem.vlocity_cmt__RootItemId__c;
                /*B-2675 DLE 06/09/2021 end*/
                action = ordLineItem.vlocity_cmt__Action__c;
                profileid = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_PROFIL');
                /*W-000177 ILA 08/02/2022 begin */
                /*Get billingAccountFromOrderItem ILA 20/05/2022 begin */
                  billingaccount=ordLineItem.vlocity_cmt__BillingAccountId__c;
               /*Get billingAccountFromOrderItem ILA 20/05/2022 End */
                if (ordLineItem.product2.vlocity_cmt__Type__c == 'Postpaye' || ordLineItem.product2.vlocity_cmt__Type__c == 'idar duo' || ordLineItem.product2.vlocity_cmt__Type__c == 'Home Postpaye' || ordLineItem.product2.vlocity_cmt__Type__c == 'FTTH' || ordLineItem.product2.vlocity_cmt__Type__c == 'Cameleon' || ordLineItem.product2.vlocity_cmt__Type__c == 'ADSL' )
                 {     
                  /*B-5394 ILA 22/09/2022 begin */
                  if(ordLineItem.Order.inwiB2C_TypeDeMigration__c == 'Migration Postpayé Postpayé' || ordLineItem.Order.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Retention_Cascade')   
                  {
                      fms=assetDisconnect.vlocity_cmt__SubscriptionId__r.InwiB2C_FMS__c;
                      fmd=assetDisconnect.vlocity_cmt__SubscriptionId__r.InwiB2C_FMD__c;
                      CodeTransactionFMD = assetDisconnect.vlocity_cmt__SubscriptionId__r.InwiB2C_Code_de_transaction_FMD__c;
                      CodeTransactionFMS = assetDisconnect.vlocity_cmt__SubscriptionId__r.InwiB2C_Code_de_transaction_FMS__c;
                      dateLimiteSR = assetDisconnect.vlocity_cmt__SubscriptionId__r.InwiB2C_date_limite_satisfait_rembours__c;
                      activationDate = assetDisconnect.vlocity_cmt__SubscriptionId__r.InwiB2C_Date_d_activation__c;

                  }
                  else {
                    // H-M Ticket B-17625 28/07/2024  begin 
                    if (String.isEmpty(ordLineItem.InwiB2C_TransactionCode_FMD__c) && String.isEmpty(ordLineItem.InwiB2C_TransactionCode_FMS__c)) {
                        fms = ordLineItem.InwiB2C_FMS__c;
                        fmd = ordLineItem.InwiB2C_FMD__c;
                        CodeTransactionFMD = orderlist.InwiB2C_CodeTransactionFMD__c;
                        CodeTransactionFMS = orderlist.InwiB2C_Code_de_transaction_FMS__c;
                    } else {
                      fms = ordLineItem.InwiB2C_FMS__c;
                      fmd = ordLineItem.InwiB2C_FMD__c;
                      CodeTransactionFMD = ordLineItem.InwiB2C_TransactionCode_FMD__c;
                      CodeTransactionFMS = ordLineItem.InwiB2C_TransactionCode_FMS__c;
                    }
                    // H-M Ticket B-17625 28/07/2024 End
                } 
                  /*B-5394 ILA 22/09/2022 end */
                      typeLigneValue = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_TYPE_LIGNE');
                    //  vlocity_cmt__PicklistValue__c typeLigne1 = [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c like 'INWIB2C_PKL_TYPE_LIGNE' and vlocity_cmt__TextValue__c =: typeLigneValue limit 1];
                      //typeLigne = typeLigne1.Name;  
                      /*Vue 360 ILA 13/04/2022 begin */   
                      gammeOffreValue = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_GAMME_OFFRE');
                      // vlocity_cmt__PicklistValue__c gammeOffre1 = [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c like 'INWIB2C_PKL_GAMME_OFFRE' and vlocity_cmt__TextValue__c =: gammeOffreValue limit 1];
                      //gammeOffre = gammeOffre1.Name;
                      /*Vue 360 ILA 13/04/2022 END */ 
                      /*Vue 360 Sous ILA 15/04/2022 begin */
                      prixAbonn = ordLineItem.vlocity_cmt__RecurringCharge__c;
                      /*Vue 360 Sous ILA 15/04/2022 end */
                    /*B-7538 ILA 18/01/2023 begin */
                     dureeEngagValue = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_ENGAGEMENT');
                    /*B-7538 ILA 18/01/2023 END */

                 
                /**Demande de partage ILA 24/12/24 Start */
                if(ordLineItem.product2.vlocity_cmt__Type__c == 'FTTH'){
                operInfra = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_OPERATEUROI');
                statutPartage = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_STATUTPARTAGE');
            }
                /*Demande de partage ILA 24/12/24 Start */



                }

                 /**B-14273 ILA 19/02/2024 Start */
                 /**Demande de dégroupage ILA 06/03/2023 Start */
                 /*
                 if(ordLineItem.product2.vlocity_cmt__Type__c == 'ADSL')
                 {
                    dslamPort= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_IDPORTDSLAM');
                    statutLigneIam = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_DSLSRCSTAT');
                    technoDegroupage = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_ODSLB2CTA');
                    positionReglette = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_POSITMDF');
                    rendezvous = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSONDate(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_CRINSTAL');
                 }
                 */
                  /**Demande de dégroupage ILA 06/03/2023 End */
                /**B-14273 ILA 19/02/2024 End */

                /*W-000177 ILA 08/02/2022 end */
                /*B-3052 DLE 11/11/2021 begin*/
                //forfait= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_PROFIL_IN');
                if (!Test.isRunningTest()) {
                    /*W-000162 ILA 25/01/2022 Begin*/
                    /*B-3204 DLE 09/12/2021n begin */
                    /*vlocity_cmt__PicklistValue__c forfait1 =  [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c='INWIB2C_PLK_FORFAIT_LABELv1' and vlocity_cmt__TextValue__c =:profileid limit 1];*/
                    //vlocity_cmt__PicklistValue__c forfait1 = [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c in ('INWIB2C_PLK_FORFAIT_LABELv1', 'INWIB2C_PLK_INPROFIL_KOULCHI') and vlocity_cmt__TextValue__c =: profileid limit 1];
                    /**MGEN3758 ILA 23/07/25 Start  add INWIB2C_PL_PROFIL_ESIM*/
                    vlocity_cmt__PicklistValue__c forfait1 = [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c in ('INWIB2C_PLK_FORFAIT_LABELv1', 'INWIB2C_PLK_INPROFIL_KOULCHI','INWIB2C_PLK_INPROFILP_POSTPAYELABEL','INWIB2C_PLK_INPROFILP_POSTPAYEMIGRE','INWIB2C_PLK_Data_only','INWIB2C_PL_OFFREVACANCIER','INWIB2C_PLK_ForfaitIdarDuo','InwiB2C_PL_FORFAIT_FTTH','INWIB2C_PL_CAMELEON','INWIB2C_PLK_FORFAIT_ADSL','INWIB2C_PKL_FORFFTTH','INWIB2C_PL_PROFIL_ESIM') and vlocity_cmt__TextValue__c =: profileid limit 1];
                    /**MGEN3758 ILA 23/07/25 End */
                    /*B-3204 DLE 09/12/2021n end */
                    /*W-000162 ILA 25/01/2022 End*/
                    forfait = forfait1.Name;
                } else {
                    //vlocity_cmt__PicklistValue__c forfait1 =  [select Name from vlocity_cmt__PicklistValue__c limit 1];
                    forfait = 'ZTE';
                }
  
                /*B-3052 DLE 11/11/2021 End*/
                natureoffre = ordLineItem.product2.Family;
                system.debug('profile Id------> ' + profileid);
                system.debug('forfait ------> ' + forfait);
  
            }
            vlocity_cmt__PicklistValue__c typeLigne1 = new vlocity_cmt__PicklistValue__c();
            vlocity_cmt__PicklistValue__c gammeOffre1 = new vlocity_cmt__PicklistValue__c();
            /*B-7538 ILA 18/01/2023 begin */
            vlocity_cmt__PicklistValue__c dureeEngag1 = new vlocity_cmt__PicklistValue__c();
            if (String.isNotBlank(dureeEngagValue) ){//correction ticket B-4444 pour le cas des offres pre
                if(!Test.isRunningTest()) {
                    dureeEngag1 = [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c like 'INWIB2C_PKL_ENGAGEMENT' and vlocity_cmt__TextValue__c =: dureeEngagValue limit 1];
                    dureeEngag = dureeEngag1.Name;  
              }
                else
                {
                    dureeEngag1 = [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c in ('INWIB2C_PKL_TYPE_LIGNE','INWIB2C_PKL_TYPE_LIGNE_FTTH') limit 1];
                    dureeEngag = dureeEngag1.Name;  
                }
  
            }
            /*B-7538 ILA 18/01/2023 end */
            if (String.isNotBlank(typeLigneValue) ){//correction ticket B-4444 pour le cas des offres pre
                if(!Test.isRunningTest()) {
                     typeLigne1 = [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c in ('INWIB2C_PKL_TYPE_LIGNE','INWIB2C_PKL_TYPE_LIGNE_FTTH','INWIB2C_PKL_TYPE_LIGNE_IDAR','INWIB2C_PKL_TYPE_LIGNE_ADSL','INWIB2C_PKL_FORFFTTH','INWIB2C_PKL_TYPE_LIGNE_FTTH_BAHIA') and vlocity_cmt__TextValue__c =: typeLigneValue limit 1];
                     typeLigne = typeLigne1.Name;  
              }
                else
                {
                     typeLigne1 = [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c in ('INWIB2C_PKL_TYPE_LIGNE','INWIB2C_PKL_TYPE_LIGNE_FTTH','INWIB2C_PKL_TYPE_LIGNE_FTTH_BAHIA') limit 1];
                   typeLigne = typeLigne1.Name;  
                }
  
            }
            if ( String.isNotBlank(gammeOffreValue)){//correction ticket B-4444 pour le cas des offres pre
                if(!Test.isRunningTest()) { 
                     gammeOffre1 = [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c like 'INWIB2C_PKL_GAMME_OFFRE' and vlocity_cmt__TextValue__c =: gammeOffreValue limit 1];
              }
                else
                { 
                      gammeOffre1 = [select Name from vlocity_cmt__PicklistValue__c where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c like 'INWIB2C_PKL_GAMME_OFFRE' limit 1];
                }
  
                 gammeOffre = gammeOffre1.Name;
            }
        }
        /*B-2458 DLE 23/07/2021 begin */
        if (productcode == 'INWIB2C_OFFERING_DEALER_SANS_TERMINAL' || productcode == 'INWIB2C_OFFERING_DEALER_AVEC_TERMINAL') {
            //select the cin   
            contact listContactcin = [select InwiB2C_CIN__c from contact where id =: contactid];
            //nombree de souscription active pour la cin
            /* chb 04/06/2024 anomalie B-16549 begin */
            list < vlocity_cmt__Subscription__c > contsubscription= new list < vlocity_cmt__Subscription__c >();
            if(listContactcin.InwiB2C_CIN__c!=null && listContactcin.InwiB2C_CIN__c!='XX1111111111'){
            contsubscription = [select id from vlocity_cmt__Subscription__c where vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c =: listContactcin.InwiB2C_CIN__c and inwiB2C_Statut__c = 'InwiB2C_Active'];
             }
             /* chb 04/06/2024 anomalie B-16549 end */
            InwiB2C_Nombre_Activation__mdt nbractivations = [select InwiB2C_Nombre_max_activation__c, InwiB2C_Nombre_min_activation__c from InwiB2C_Nombre_Activation__mdt];
            if (contsubscription.size() < nbractivations.InwiB2C_Nombre_min_activation__c) {
                nbractivclient = nbractivations.InwiB2C_Nombre_max_activation__c;
            } else {
                nbractivclient = 0;
            }
        }
        /*B-2458 DLE 23/07/2021 end */
  
        //get attributs from order sim
         /*W-000162 ILA 26/01/2022 Begin*/
               /*   List < OrderItem > ordItemsim = [SELECT id, Product2.ProductCode, vlocity_cmt__JSONAttribute__c, vlocity_cmt__OneTimeTotal__c FROM OrderItem
                      WHERE(id =: orditemId or vlocity_cmt__ParentItemId__c =: orditemId) and Product2.ProductCode = 'INWIB2C_OFFERING_SIM'
                  ];*/
          List < OrderItem > ordItemsim = [SELECT id, Product2.ProductCode, vlocity_cmt__JSONAttribute__c, vlocity_cmt__OneTimeTotal__c FROM OrderItem
              WHERE(id =: orditemId or vlocity_cmt__ParentItemId__c =: orditemId) and Product2.ProductCode in ('INWIB2C_OFFERING_SIM','INWIB2C_MOB01_OFFERING_SIM','INWIB2C_MOB02_OFFERING_SIM','INWIB2C_OPB2C_OFFERING_SIM')
              ];
         /*W-000162 ILA 26/01/2022 End*/
        system.debug('ordItemsim------> ' + ordItemsim);
        if (ordItemsim.size() > 0) {
            for (OrderItem ordLineItem: ordItemsim) {
                /*W-000162 ILA 26/01/2022 Begin*/
                //if (ordLineItem.Product2.ProductCode == 'INWIB2C_OFFERING_SIM')
                if (ordLineItem.Product2.ProductCode == 'INWIB2C_OFFERING_SIM' ||ordLineItem.Product2.ProductCode == 'INWIB2C_MOB01_OFFERING_SIM' ||ordLineItem.Product2.ProductCode == 'INWIB2C_MOB02_OFFERING_SIM'||ordLineItem.Product2.ProductCode == 'INWIB2C_OPB2C_OFFERING_SIM')
                /*W-000162 ILA 26/01/2022 End*/
                    icc = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_ICCID');
                imsi = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_IMSI');
                puck = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_SIM_PUK');
                articlesim = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_MODELE_CARTE_SIM');
                /*B-3097 DLE 12/11/2021 begin */
                prixsim = ordLineItem.vlocity_cmt__OneTimeTotal__c;
                /*B-3097 DLE 12/11/2021 end */
                system.debug('icc ------> ' + icc);
                system.debug('imsi ------> ' + imsi);
                system.debug('puck ------> ' + puck);
                /**ESim ILA 01/04/2024 START */
                if(ordLineItem.Product2.ProductCode == 'INWIB2C_OFFERING_SIM' || ordLineItem.Product2.ProductCode == 'INWIB2C_MOB02_OFFERING_SIM'){
                    typeSim=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_TYPESIM');
                }
                /**ESim ILA 01/04/2024 END */
  
            }
          }
  
              //get attributs from order term
            /*B-3798 DLE 30/03/2022 begin */
             if (ProductType <> 'Postpaye' && ProductType <> 'idar duo' && ProductType <> 'FTTH' && ProductType <> 'ADSL' )
                { 
               /*B-3798 DLE 30/03/2022 end */
                 List < OrderItem > ordItemterm = [SELECT id, Product2.ProductCode, vlocity_cmt__JSONAttribute__c, vlocity_cmt__OneTimeTotal__c FROM OrderItem
                 WHERE(id =: orditemId or vlocity_cmt__ParentItemId__c =: orditemId) and Product2.ProductCode = 'INWIB2C_OFFERING_TERMINAL'
                ];
               /*B-3798 DLE 30/03/2022 begin */
               system.debug('ordItemterm------> ' + ordItemterm);
               if (ordItemterm.size() > 0)
                {
               for (OrderItem ordLineItem: ordItemterm) 
                {
                  if (ordLineItem.Product2.ProductCode == 'INWIB2C_OFFERING_TERMINAL' )
                   IMEI = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_IMEI');
                  Terminal = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_DC_MODELELABEL');
                   libeletterminal = Terminal;
                    system.debug('imei ------> ' + imei);
                   /*B-3097 DLE 12/11/2021 begin */
                   prixterm = ordLineItem.vlocity_cmt__OneTimeTotal__c;
                   /*B-3097 DLE 12/11/2021 end */
                 }
  
              }
                }     else
                {
                  List < OrderItem > ordItemterm = [SELECT id, Product2.ProductCode, vlocity_cmt__JSONAttribute__c, vlocity_cmt__OneTimeTotal__c FROM OrderItem
                WHERE  vlocity_cmt__RootItemId__c =: orditemId and Product2.ProductCode in ('INWIB2C_MOB01_OFFERING_TERMINAL','INWIB2C_MOB02_OFFERING_TERMINAL','INWIB2C_OPB2C_OFFERING_TERMINAL','INWIB2C_FOB2C_OFFERING_TERMINAL','INWIB2C_DEG01_OFFERING_TERMINAL')
                ]; 
                system.debug('ordItemterm------> ' + ordItemterm);
                if (ordItemterm.size() > 0)
               {
                for (OrderItem ordLineItem: ordItemterm) 
                 {
                   if (ordLineItem.Product2.ProductCode == 'INWIB2C_MOB02_OFFERING_TERMINAL'|| ordLineItem.Product2.ProductCode == 'INWIB2C_MOB01_OFFERING_TERMINAL'|| ordLineItem.Product2.ProductCode == 'INWIB2C_OPB2C_OFFERING_TERMINAL'|| ordLineItem.Product2.ProductCode == 'INWIB2C_FOB2C_OFFERING_TERMINAL' || ordLineItem.Product2.ProductCode == 'INWIB2C_DEG01_OFFERING_TERMINAL' )
                    IMEI = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_IMEI');
                   Terminal = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_DC_MODELELABEL');
                     libeletterminal = Terminal;
                     system.debug('imei ------> ' + imei);
                    /*B-3097 DLE 12/11/2021 begin */
                    prixterm = ordLineItem.vlocity_cmt__OneTimeTotal__c;
                    /*B-3097 DLE 12/11/2021 end */
                  }
  
               }
               }
                /*B-3798 DLE 30/03/2022 End */
                
         
  
            //get attributs from order mdn
            /*W-000162 ILA 26/01/2022 Begin*/
              /*    List < OrderItem > ordItemmdn = [SELECT id, Product2.ProductCode, vlocity_cmt__JSONAttribute__c FROM OrderItem
                  WHERE(id =: orditemId or vlocity_cmt__ParentItemId__c =: orditemId) and Product2.ProductCode = 'INWIB2C_OFFERING_MSISDN_STANDARD'
              ];*/
              List < OrderItem > ordItemmdn = [SELECT id, Product2.ProductCode, vlocity_cmt__JSONAttribute__c FROM OrderItem
              WHERE(id =: orditemId or vlocity_cmt__ParentItemId__c =: orditemId) and Product2.ProductCode in ('INWIB2C_OFFERING_MSISDN_STANDARD','INWIB2C_MOB02_OFFERING_MSISDN_STANDARD','INWIB2C_MOB01_OFFERING_MSISDN_STANDARD','INWIB2C_OPB2C_OFFERING_MSISDN_STANDARD','INWIB2C_FOB2C_OFFERING_MSISDN_STANDARD','INWIB2C_DEG01_OFFERING_MSISDN_STANDARD')
          ]; 
          /*W-000162 ILA 26/01/2022 End*/
        system.debug('ordItemterm------> ' + ordItemmdn);
        if (ordItemmdn.size() > 0) {
            for (OrderItem ordLineItem: ordItemmdn) {
                /*W-000162 ILA 26/01/2022 Begin*/
               // if (ordLineItem.Product2.ProductCode == 'INWIB2C_OFFERING_MSISDN_STANDARD')
               if (ordLineItem.Product2.ProductCode == 'INWIB2C_OFFERING_MSISDN_STANDARD'||ordLineItem.Product2.ProductCode == 'INWIB2C_MOB02_OFFERING_MSISDN_STANDARD'|| ordLineItem.Product2.ProductCode == 'INWIB2C_MOB01_OFFERING_MSISDN_STANDARD'|| ordLineItem.Product2.ProductCode == 'INWIB2C_OPB2C_OFFERING_MSISDN_STANDARD' || ordLineItem.Product2.ProductCode == 'INWIB2C_FOB2C_OFFERING_MSISDN_STANDARD' || ordLineItem.Product2.ProductCode == 'INWIB2C_DEG01_OFFERING_MSISDN_STANDARD')
                /*W-000162 ILA 26/01/2022 End*/
                    mdn = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_MSISDN');
                choixnimber = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_CHOIX_NUMERO');
                portednumber = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_MSISDN_PORTED');
                operator = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWI_ATT_RT_OPERATOR');
                /*B-2423 DLE 27/07/2021 begin */
                myDateporta = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSONDate(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_Datedeportabilite');
                /*B-2423 DLE 27/07/2021 end */
                /*RIO  begin */
                coderio = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_RIO');
                 /*RIO end */
                /*B-2655 DLE 17/08/2021 begin */
                if (myDateporta == null) {
                    myDateporta = Date.today();
                }
                /*B-2655 DLE 17/08/2021 end */
                system.debug('mdn ------> ' + mdn);
            }
        }
  
        //insert subscriptions
  
        //partenairecoe
        string codepatenaire = orderlist.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c;
            /* Rollback ACYL 08/01/2025 Start */
            // MGEN3675A  25/06/2025 ILA ADD migration 4g<->5g Start
            if ((orderlist.inwib2c_TypeDeLaCommande__c == 'inwiB2C_Acquisition' && action == 'Add')|| (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_ADSL_Vers_IDAR' && action == 'Add') ||(orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_FTTH_Vers_IDAR' && action == 'Add') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_FTTH_Vers_ADSL' && action == 'Add') || (orderlist.inwiB2C_TypeDeMigration__c == 'inwiB2C_MigrationKoulchiVersTicTac' && action == 'Add')|| ( orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostpayé' && action == 'Add')||( orderlist.inwiB2C_TypeDeMigration__c == 'Migration Postpayé Postpayé' && action == 'Add') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_come-back' && action == 'Add') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Retention_Cascade' && action == 'Add') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Idar_vers_FTTH' && action == 'Add') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Idar_vers_ADSL' && action == 'Add') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Idar_vers_FTTH' && action == 'Add') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_ADSL_Vers_FTTH' && action == 'Add')|| ( orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostAvecIdentification' && action == 'Add') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostpayéPorta' && action == 'Add')|| (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationIdar5GversIdar4G' && action == 'Add') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationIdar4GversIdar5G' && action == 'Add')) {
            // MGEN3675A  25/06/2025 ILA ADD migration 4g<->5g End
            /* Rollback ACYL  08/01/2025 end */
//Saad 05/02/2024 ttm Migration PrePOST avec identification
             /* B-6225 ILA 09/11/2022 Start */
       /*   Datetime activationDate = Datetime.now();
          if (orderlist.inwiB2C_TypeDeMigration__c == 'Migration Postpayé Postpayé' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Retention_Cascade') {
              inwiB2C_OrderSubscription__c oldSub = [select id,inwiB2C_Subscription__r.InwiB2C_Date_d_activation__c from inwiB2C_OrderSubscription__c where inwiB2C_Order__c =:ordId];
              activationDate = oldSub.inwiB2C_Subscription__r.InwiB2C_Date_d_activation__c;
          }*/
          /*B-7259 ILA 12/01/2023 begin */
            if (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Retention_Cascade'){
            Order orderRetention = [Select id,CreatedDate from order where id =:ordId];
            inwiB2C_OrderSubscription__c OrdersubRetention = [select id,inwiB2C_Subscription__c from inwiB2C_OrderSubscription__c where inwiB2C_Order__c =:ordId];
            vlocity_cmt__Subscription__c subRetention = [select id,InwiB2C_Date_d_activation__c,InwiB2C_date_limite_satisfait_rembours__c from vlocity_cmt__Subscription__c where id =: OrdersubRetention.inwiB2C_Subscription__c];
            Date dateActivation = date.newinstance(subRetention.InwiB2C_Date_d_activation__c.year(), subRetention.InwiB2C_Date_d_activation__c.month(), subRetention.InwiB2C_Date_d_activation__c.day());
            if(subRetention.InwiB2C_date_limite_satisfait_rembours__c != null){
            Integer diffDate = dateActivation.daysBetween(subRetention.InwiB2C_date_limite_satisfait_rembours__c);
            InwiB2C_delai_stdr_satisfait_rembourse__mdt delaiPro = [Select id,InwiB2C_DelaiProlongation__c from InwiB2C_delai_stdr_satisfait_rembourse__mdt where DeveloperName='InwiB2C_Satisfait_ou_Rembourse'];
            if (orderRetention.CreatedDate <= subRetention.InwiB2C_date_limite_satisfait_rembours__c && diffDate <= 8  ){
                //subRetention.InwiB2C_date_limite_satisfait_rembours__c = subRetention.InwiB2C_date_limite_satisfait_rembours__c.addDays(Integer.valueOf(delaiPro.InwiB2C_DelaiProlongation__c));
                //update subRetention;
                dateLimiteSR = subRetention.InwiB2C_date_limite_satisfait_rembours__c.addDays(Integer.valueOf(delaiPro.InwiB2C_DelaiProlongation__c));
                
            }}
           // dateLimiteSR = subRetention.InwiB2C_date_limite_satisfait_rembours__c;}
    
        }
        /*B-7259 ILA 12/01/2023 end */
  
          /* B-6225 ILA 09/11/2022 End */
          Asset assetList = null;
            //get asset id
            //adaptation bulk order end
           
            // Asset assetList = [select id, product2.ProductCode, CreatedDate, vlocity_cmt__OrderProductId__c, vlocity_cmt__AssetReferenceId__c, vlocity_cmt__OrderProductId__r.OrderId, vlocity_cmt__ParentItemId__c, Product2.Name from asset where vlocity_cmt__OrderProductId__c =: orditemId];
           //if(typeComm == 'inwiB2C_Acquisition'&& ProductType == 'FTTH' || typeComm == 'inwiB2C_Migration' || typeComm == 'inwiB2C_Modification')
             assetList = [select id, product2.ProductCode,Product2.vlocity_cmt__Type__c, CreatedDate, vlocity_cmt__OrderProductId__c, vlocity_cmt__AssetReferenceId__c, vlocity_cmt__OrderProductId__r.OrderId, vlocity_cmt__ParentItemId__c, Product2.Name,Product2.Family from asset where vlocity_cmt__OrderProductId__c =: orditemId limit 1];
            //adaptation bulk order begin
            /*W-000162 ILA 25/01/2022 Begin*/
            /* ACYL 08/01/2025 Start */
            // MGEN3675A  25/06/2025 ILA ADD migration 4g<->5g Start
            list < inwiB2C_OrderSubscription__c > ordersubscc = [select inwiB2C_Subscription__c from inwiB2C_OrderSubscription__c where inwiB2C_Order__c =: ordId and inwiB2C_Order__r.inwiB2C_Canal__c in ('inwiB2C_USSD','inwiB2C_Dealer','inwiB2C_MyInwi','inwiB2C_FirstCall')];
            if (ordersubscc.size() == 0 ||orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_ADSL_Vers_IDAR' ||orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_FTTH_Vers_IDAR' ||orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_FTTH_Vers_ADSL' || orderlist.inwiB2C_TypeDeMigration__c == 'Migration Postpayé Postpayé' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostpayé' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Idar_vers_ADSL' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_ADSL_Vers_FTTH' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostAvecIdentification' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostpayéPorta' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationIdar5GversIdar4G'|| orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationIdar4GversIdar5G' )
            // MGEN3675A  25/06/2025 ILA ADD migration 4g<->5g end 
             {
                                     /* ACYL 08/01/2025 end*/ 
                //Saad 05/02/2024 ttm Migration PrePOST avec identification

                //adaptation bulk order end
                   
                   
                  //offre = assetList.Product2.Name;
                 
                  //system.debug('asset Id------> ' + Idasset);
              

                String StatutSouc='';
                String legacyState='';
                string Idasset=assetList.id;
                 /* ACYL 08/01/2025 Start */
                 if( (typeComm == 'inwiB2C_Acquisition' ||orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_ADSL_Vers_IDAR' ||orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_FTTH_Vers_IDAR' ||orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_FTTH_Vers_ADSL' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Idar_vers_FTTH' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Idar_vers_ADSL' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_ADSL_Vers_FTTH' )  && (ProductType == 'FTTH' || ProductType == 'ADSL')  )
                 {                      /* ACYL 08/01/2025 end */ 
                        StatutSouc='InwiB2C_EncoursDactivation';
                        legacyState = 'En cours d\'activation';
                        typeOffre = 'InwiB2C_Postpaye';
                        serviceAccountId = orderlist.vlocity_cmt__DefaultServiceAccountId__c;
                    }
                else
                      {
                        StatutSouc='InwiB2C_Active';
                        legacyState = 'ACTIVE';
                         /*W-000162 ILA 25/01/2022 Begin*/
                        if(assetList.Product2.vlocity_cmt__Type__c == 'Postpaye' || assetList.Product2.vlocity_cmt__Type__c =='Home Postpaye' || assetList.Product2.vlocity_cmt__Type__c =='idar duo'|| assetList.Product2.vlocity_cmt__Type__c =='FTTH'|| assetList.Product2.vlocity_cmt__Type__c =='cameleon' || assetList.Product2.vlocity_cmt__Type__c =='ADSL')
                        {
                            typeOffre = 'InwiB2C_Postpaye';
                        } 
                        else
                        {
                            typeOffre = 'InwiB2C_Prepaye';
                        }
                        /*W-000162 ILA 25/01/2022 END*/
                            }
                vlocity_cmt__Subscription__c newsubscription = new vlocity_cmt__Subscription__c(
                    OwnerId = UserInfo.getUserId(),
                    Name = mdn,
                    vlocity_cmt__AccountId__c = accoutid,
                    /*B-7538 ILA 18/01/2023 begin */
                    InwiB2C_Dur_e_d_engagement__c = dureeEngag,
                    /*B-7538 ILA 18/01/2023 end */
                    /*W-000177 ILA 08/02/2022 begin */
                    InwiB2C_Type_Client__c = typeLigne,
                    /*W-000177 ILA 08/02/2022 END */
                    /*Vue 360 ILA 13/04/2022 begin */
                    InwiB2C_Gamme_de_l_offre__c = gammeOffre,
                    /*Vue 360 ILA 13/04/2022 END */ 
                    vlocity_cmt__BillingAccountId__c = billingaccount,
                    vlocity_cmt__SubscriptionNumber__c = Idasset,
                   //vlocity_cmt__SubscriptionNumber__c = '8023M000000dIlnQAE',
                      /*RMA D2D  26/01/2024 begin */
                    InwiB2C_Famille_d_offre__c= assetList.Product2.vlocity_cmt__Type__c,
                      /*RMA D2D  26/01/2024 END */ 
                    InwiB2C_IMSI__c = IMSI,
                    InwiB2C_Id_profil__c = profileid,
                    InwiB2C_MEI__c = IMEI,
                    Inwib2c_ICC__c = icc,
                    Inwib2c_Num_ro_de_la_ligne__c = mdn,
                    Inwib2c_Offre__c = offre,
                    Inwib2c_Profil__c = forfait,
                    Inwib2c_code_puk__c = puck,
                    inwiB2C_Statut__c = StatutSouc,
                    inwiB2C_LegacyStatus__c = legacyState,
                    vlocity_cmt__Status__c = 'Active',
                    InwiB2C_Point_de_vente__c = codepatenaire,
                    InwiB2C_Date_d_activation__c = activationDate,
                    Inwib2c_type_de_sim__c = 'GSM',
                    InwiB2C_Partenaire__c = pos,
                    InwiB2C_Distributeur__c = distrib,
                    InwiB2C_Canal__c = canal,
                    vlocity_cmt__CurrentContractId__c = contrat,
                    InwiB2C_Contract__c = contrat,
                    Inwib2c_Type_de_forfait__c = natureoffre,
                    /*W-000162 ILA 25/01/2022 Begin*/
                    Inwib2C_Type_Offre__c = typeOffre,
                    /*W-000162 ILA 25/01/2022 END*/
                    Inwib2c_Terminal__c = libeletterminal,
                    inwiB2C_managedInSF__c = true,
                    inwiB2C_NombreActivationClientParJour__c = nbractivclient,
                    Inwib2c_SegmentLigne__c = 'Silver',
                    /*Vue 360 Sous ILA 15/04/2022 begin */
                    inwiB2C_Montant_de_l_abonnement__c = prixAbonn,
                     /*Vue 360 Sous ILA 15/04/2022 end */ 
                     /*B-5394 ILA 22/09/2022 begin */
                     InwiB2C_FMS__c=fms,
                     InwiB2C_FMD__c=fmd,
                     /*B-5394 ILA 22/09/2022 end */ 
                    /*W-7223 RMA 04/01/2023 begin */
                    InwiB2C_Code_de_transaction_FMD__c = CodeTransactionFMD,
                    InwiB2C_Code_de_transaction_FMS__c=CodeTransactionFMS,
                    /*B-7223 RMA 04/01/2023 end */ 
                    /*B-7259 ILA 12/01/2023 begin */
                    InwiB2C_date_limite_satisfait_rembours__c = dateLimiteSR,
                    /*B-7259 ILA 12/01/2023 end */
                    vlocity_cmt__ServiceAccountId__c = serviceAccountId,
                    /**ESim ILA 01/04/2024 START */
                    inwib2c_Categorie_de_sim__c=typeSim,
                    /**ESim ILA 01/04/2024 End */
                    /**Demande de partage ILA 24/12/24 Start */
                    InwiB2C_Operateur_infrastructure__c=operInfra
                    /**Demande de partage ILA 24/12/24 End */

                    
                     );
  
                insert newsubscription;

                account1.vlocity_cmt__Status__c='Active';
                update account1;    

                string suscriptionid = newsubscription.id;
                //update asset with subscription id
                if(typeComm == 'inwiB2C_Acquisition' || typeComm == 'inwiB2C_Migration'){
                  List < Asset > assetRecords = new List < Asset > ();
                  
                  assetRecords.add(new Asset(id = Idasset, vlocity_cmt__SubscriptionId__c = suscriptionid));
                /**Demande de dégroupage ILA 03/03/2023 Start */
                  /* ACYL 08/01/2025 Start */
                 if((typeComm == 'inwiB2C_Acquisition' && assetList.Product2.vlocity_cmt__Type__c == 'ADSL') || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Idar_vers_ADSL' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_FTTH_Vers_ADSL')
                   /* ACYL 08/01/2025 end */
                    /**B-14273 ILA 16/02/2024 END */
                   InwiB2C_ManageDegroupageOrder.createNewDegroupageOrder( orderlist.id,'acq');
                   /**Demande de partage ILA 24/12/24 Start */
                    //creer une nouvelle deamnde de partage dans le cas d'acquisition ou de migraion vers une ligne FTT
                    //ILA B-28515 02/05/2025 ajouter migrationn adsl=>ftth start
                    if((operInfra == 'ORANGE' || operInfra == 'IAM') && ((typeComm == 'inwiB2C_Acquisition' && assetList.Product2.vlocity_cmt__Type__c == 'FTTH') || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Idar_vers_FTTH' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_ADSL_Vers_FTTH'))
                    //ILA B-28515 02/05/2025 ajouter migrationn adsl=>ftth end
                        InwiB2C_SharingRequestManagement.createNewSharingRequest(orderlist.id,suscriptionid);
                // attacher la nouvelle souscripton aux demandes de partage
                    if((operInfra == 'ORANGE' || operInfra == 'IAM')  && orderlist.inwiB2C_TypeDeMigration__c == 'Migration Postpayé Postpayé' && action == 'Add' && assetList.Product2.vlocity_cmt__Type__c == 'FTTH'){
                        List<inwiB2C_demande_partage__c> sharingRequests = [Select Id,InwiB2C_Subscription__c from inwiB2C_demande_partage__c where InwiB2C_Order__c=:orderlist.id ];
                        for(inwiB2C_demande_partage__c demande :sharingRequests )
                            demande.InwiB2C_Subscription__c=suscriptionid;
                            update sharingRequests;
                        }
                    /*
                    Map<String, String> insertAdresse = new Map<String, String>();
                    InwiB2C_Sequence_Order_Number__c sequenceDeg = [select id,InwiB2C_Sequence__c from InwiB2C_Sequence_Order_Number__c where name='Sequence Degroupage'];
                    InwiB2C_Sequence_Order_Number__c parametresDeg = [select id,InwiB2C_typePrestation__c,InwiB2C_Debit__c,InwiB2C_qualiteService__c from InwiB2C_Sequence_Order_Number__c where InwiB2C_statut_ligne__c=: statutLigneIam and InwiB2C_Technologie__c=: technoDegroupage];
                    
                    Account serviceAccountDeg = [Select id,inwiB2C_numero_de_designation__c,InwiB2C_NomIAM__c,InwiB2C_PrenomIAM__c,inwiB2C_Adresse_Facture_IAM__c,InwiB2C_Address__r.InwiB2C_Region__r.InwiB2C_RegionMdn__c from Account where id=: serviceAccountId];
                    Date dateOrder;
                    DateTime dtOrder = System.now();
                    dateOrder = date.newinstance(dtOrder.year(), dtOrder.month(), dtOrder.day());
                    String nd ='';
                    String ndOp = '';
                    String nomIam =serviceAccountDeg.InwiB2C_NomIAM__c;
                    String prenomIam = serviceAccountDeg.InwiB2C_PrenomIAM__c;
                    Integer portabilite = 0;
                    String codeRoutage ='';
                    String numContact = '';
                    
                    List<String> addSplitee = serviceAccountDeg.inwiB2C_Adresse_Facture_IAM__c.split('\\|',-1);
                    if(statutLigneIam =='LA' )
                    {
                        nd = serviceAccountDeg.inwiB2C_numero_de_designation__c;
                        portabilite = 1;
                        if(serviceAccountDeg.InwiB2C_Address__r.InwiB2C_Region__r.InwiB2C_RegionMdn__c == 'NORD')
                            codeRoutage = 'E2101';
                        else   
                            codeRoutage = 'E3101';
                    }
                    if(statutLigneIam =='LI')
                    {
                        Map<Integer,String> formatAddresse = new Map<Integer,String>{0 =>'PORTE',1=>'ETAGE', 2=>'ESC', 3=>'BAT', 4=>'NVOIE', 5=>'CVOIE', 6=>'CQUARTIER',7 =>'CCOM'};
                        ndOp=serviceAccountDeg.inwiB2C_numero_de_designation__c;
                        if(orderlist.Account.vlocity_cmt__PersonContactId__r.Phone != '')
                            numContact=orderlist.Account.vlocity_cmt__PersonContactId__r.Phone;
                        else
                            numContact = '0600002028';
                        for (Integer key : formatAddresse.keySet()){
                            if(addSplitee[key].indexOf(';')== -1)
                                insertAdresse.put(formatAddresse.get(key),addSplitee[key]);
                            else
                                insertAdresse.put(formatAddresse.get(key),addSplitee[key].substring(0,addSplitee[key].indexOf(';')));
                        }
                        
                    }
                    if(String.isBlank(serviceAccountDeg.InwiB2C_NomIAM__c) || serviceAccountDeg.InwiB2C_NomIAM__c=='undefined' )
                        nomIam = orderlist.Account.vlocity_cmt__PersonContactId__r.LastName;
                    if(String.isBlank(serviceAccountDeg.InwiB2C_PrenomIAM__c) || serviceAccountDeg.InwiB2C_PrenomIAM__c=='undefined')
                        prenomIam = orderlist.Account.vlocity_cmt__PersonContactId__r.FirstName;
                    INWIB2C_DEMANDE_DEGROUPAGE__c degroupage = new INWIB2C_DEMANDE_DEGROUPAGE__c(
                        InwiB2C_DEGROUPAGE_NUM__c = sequenceDeg.InwiB2C_Sequence__c,
                        InwiB2C_SEQ_NUM__c = 1,
                        InwiB2C_Order__c = orderlist.id,
                        InwiB2C_NumeroDesignation__c = nd,
                        InwiB2C_CLIENT_TYPE__c ='B2C',
                        InwiB2C_Account__c = accoutid,
                        InwiB2C_Site__c = serviceAccountDeg.Id ,
                        InwiB2C_LastName__c = nomIam,
                        InwiB2C_FirstName__c = prenomIam ,
                        InwiB2C_Nationalid__c = orderlist.Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,
                        InwiB2C_ADRESSE__c = serviceAccountDeg.inwiB2C_Adresse_Facture_IAM__c,
                        InwiB2C_Statutdegroupage__c = 'NOU',
                        InwiB2C_Dslamport__c = dslamPort,
                        InwiB2C_StatutLigneIam__c = statutLigneIam,
                        InwiB2C_Technologie__c= technoDegroupage,
                        InwiB2C_PartenaireCode__c = codepatenaire,
                        InwiB2C_ACTION__c = 'ADD',
                        InwiB2C_codeOpDemandeur__c = 'WNA',
                        InwiB2C_typeCommande__c = 'NA',
                        InwiB2C_ndOperateur__c = ndOp,
                        InwiB2C_dateOrdre__c = dateOrder,
                        InwiB2C_portabilite__c = portabilite,
                        InwiB2C_codeRoutage__c = codeRoutage,
                        InwiB2C_positionReglette__c = positionReglette,
                        InwiB2C_typePrestation__c = parametresDeg.InwiB2C_typePrestation__c,
                        InwiB2C_Debit__c = parametresDeg.InwiB2C_Debit__c,
                        InwiB2C_qualiteService__c = parametresDeg.InwiB2C_qualiteService__c,
                        InwiB2C_categorieClient__c = 'R',
                        InwiB2C_numeroContact__c = numContact,
                        InwiB2C_rendezvous__c = rendezvous,
                        InwiB2C_PORTE__c =insertAdresse.get('PORTE'),
                        InwiB2C_ETAGE__c = insertAdresse.get('ETAGE'),
                        InwiB2C_ESC__c = insertAdresse.get('ESC'),
                        InwiB2C_BAT__c = insertAdresse.get('BAT'),
                        InwiB2C_NVOIE__c = insertAdresse.get('NVOIE'), 
                        InwiB2C_CVOIE__c = insertAdresse.get('CVOIE'), 
                        InwiB2C_CQUARTIER__c = insertAdresse.get('CQUARTIER'), 
                        InwiB2C_CCOM__c = insertAdresse.get('CCOM'),
                        InwiB2C_Agence__c = orderlist.inwib2c_Partenaire__c
                    );
                    insert degroupage;
                    sequenceDeg.InwiB2C_Sequence__c = sequenceDeg.InwiB2C_Sequence__c +1;
                    update sequenceDeg;
                */
                /**B-14273 ILA 16/02/2024 END */

                
                /**Demande de partage ILA 24/12/24 End */
                /**Demande de dégroupage ILA 03/03/2023 End */
                              
              /*Vue 360 Sous ILA 18/04/2022 begin 
               List <Asset> childAsset = [Select id,vlocity_cmt__SubscriptionId__c,vlocity_cmt__RootItemId__c,vlocity_cmt__ParentItemId__c from Asset where vlocity_cmt__RootItemId__c =: Idasset and vlocity_cmt__ParentItemId__c !=''];
               for (Asset assetTmp : childAsset)
               {
                   assetRecords.add(new Asset(id = assetTmp.id, vlocity_cmt__SubscriptionId__c = suscriptionid));
               }
               Vue 360 Sous ILA 18/04/2022 end */
  
                update assetRecords;}
                //insert in object Subscriptions 
                inwiB2C_OrderSubscription__c newsubscOrder = new inwiB2C_OrderSubscription__c(
                    inwiB2C_Order__c = ordId,
                    inwiB2C_Subscription__c = suscriptionid, InwiB2C_Order_Root_Id__c = rootorderitem);
                insert newsubscOrder;
  
                // adaptation bulkorder begin
            } else {
                for (inwiB2C_OrderSubscription__c suborder: ordersubscc) {
                    string suscriptionid1 = suborder.inwiB2C_Subscription__c;
  
                    //update asset with subscription id
                    string Idasset1 = assetList.id;
                    List < Asset > assetRecords1 = new List < Asset > ();
                    assetRecords1.add(new Asset(id = Idasset1, vlocity_cmt__SubscriptionId__c = suscriptionid1));
                    
                   /*Vue 360 Sous ILA 18/04/2022 begin 
                   List <Asset> childAsset1 = [Select id,vlocity_cmt__SubscriptionId__c,vlocity_cmt__RootItemId__c,vlocity_cmt__ParentItemId__c from Asset where vlocity_cmt__RootItemId__c =: Idasset1 and vlocity_cmt__ParentItemId__c !='' ];
                   for (Asset assetTmp : childAsset1)
                   {
                      assetRecords1.add(new Asset(id = assetTmp.id, vlocity_cmt__SubscriptionId__c = suscriptionid1));
                   }
                  /*Vue 360 Sous ILA 18/04/2022 end */
                    
                    
                    update assetRecords1;
                    //update in object Subscriptions
                    List < vlocity_cmt__Subscription__c > assetRecords2 = new List < vlocity_cmt__Subscription__c > ();
                    assetRecords2.add(new vlocity_cmt__Subscription__c(id = suscriptionid1, vlocity_cmt__SubscriptionNumber__c = Idasset1));
                    update assetRecords2;
                }
            }
            
            // adaptation bulkorder end
  
          /*OPtimisation Parcours Mig PrePost  ILA 15/08/2022 begin */
            system.debug('Type : '+orderlist.inwiB2C_TypeDeMigration__c );

        //B-14554 21/03/2024 begin
          //if(orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostpayé' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_come-back' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_ADSL_Vers_FTTH' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostAvecIdentification'  ){//Saad 05/02/2024 ttm Migration PrePOST avec identification
          if(orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostpayé' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_come-back'  || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostAvecIdentification'  ){//Saad 05/02/2024 ttm Migration PrePOST avec identification
        //B-14554 21/03/2024 end
          Order orderMig = [Select id,InwiB2C_Subscription_Migration__c from Order where id =: ordId limit 1];
          //get prepayed sub
          vlocity_cmt__Subscription__c subPrep = [Select id,inwiB2C_LegacyStatus__c,inwiB2C_Statut__c,vlocity_cmt__Status__c,vlocity_cmt__AccountId__c  from vlocity_cmt__Subscription__c where id =: orderMig.InwiB2C_Subscription_Migration__c limit 1];
          subPrep.inwiB2C_Statut__c='InwiB2C_Expired';
          subPrep.vlocity_cmt__Status__c='Expired';
          subPrep.inwiB2C_LegacyStatus__c='EXPIRED'; 
          /*B-6440 DLE 22/11/2022 begin */
          subPrep.INWIB2C_NoSynchronize__c=true;
            /*B-6440 DLE 22/11/2022 end */
          // Saad 05/02/2024 ttm Migration PrePOST avec identification begin */
         if(orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostAvecIdentification'){
            subPrep.vlocity_cmt__AccountId__c=accoutid;
         }
          // Saad 05/02/2024 ttm Migration PrePOST avec identification end */
          //get assets
          Asset parentAssetMig=[Select Id,vlocity_cmt__ParentItemId__c,vlocity_cmt__RootItemId__c from Asset where vlocity_cmt__SubscriptionId__c=:subPrep.Id and vlocity_cmt__ParentItemId__c='' limit 1 ];
          List<Asset> Childassets = [Select Id,vlocity_cmt__Action__c,vlocity_cmt__ProvisioningStatus__c,AccountId  from Asset where vlocity_cmt__RootItemId__c =:parentAssetMig.vlocity_cmt__RootItemId__c ];
          for(Asset a : Childassets)
                            {  
                              a.vlocity_cmt__Action__c='Disconnect';
                              a.vlocity_cmt__ProvisioningStatus__c='Deleted';
                               // Saad 05/02/2024 ttm Migration PrePOST avec identification begin */
                             if(orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostAvecIdentification'){
                                a.AccountId=accoutid;
                                }
                               // Saad 05/02/2024 ttm Migration PrePOST avec identification end */
                            }
          try
              {
                  Update subPrep;
                  Update Childassets;
              }catch(DmlException e) {
                  System.debug('An unexpected error has occurred: ' + e.getMessage());
                            }
                          }
          /*OPtimisation Parcours Mig PrePost  ILA 15/08/2022 end */ 
  
        }
        //Insert in objet subscription contrat
        if (orderlist.inwib2c_TypeDeLaCommande__c == 'inwiB2C_Acquisition' && canal <> 'inwiB2C_USSD' && canal <> 'inwiB2C_Dealer' && canal <> 'inwiB2C_MyInwi' && canal <> 'inwiB2C_FirstCall') {
  
            if (operator == 'MARM1') {
                descroperator = 'Maroc Telecom';
            } else {
                descroperator = 'Orange';
            }
  
            if (operator == 'WIN') {
                descroperator = 'WIN';
            }
            if (flagporta == false) {
                descroperator = 'Inwi';
            }
  
            InwiB2C_Subscription_contract__c newsubContrat = new InwiB2C_Subscription_contract__c(
                InwiB2C_Code_Article__c = articlesim,
                InwiB2C_Contract__c = contrat,
                InwiB2C_IMSI__c = IMSI,
                InwiB2C_MDN__c = mdn,
                InwiB2C_ESN_ICC__c = icc,
                InwiB2C_N_Ligne__c = mdn,
                InwiB2C_Numero_Terminal__c = IMEI,
                InwiB2C_Profil__c = profileid,
                InwiB2C_Date_CRM__c = Date.today(),
                InwiB2C_akey__c = '',
                InwiB2C_Type_Offre__c = offre,
                InwiB2C_Porta__c = flagporta,
                InwiB2C_Prix_de_Vente__c = prixvente,
                InwiB2C_operateur_d_origine__c = descroperator,
                InwiB2C_Prix_de_la_sim__c = prixsim,
                InwiB2C_Prix_du_terminal__c = prixterm,
                InwiB2C_Numero_de_serie_terminal__c = IMEI,
                InwiB2C_Modele_terminal__c = libeletterminal
            );
            insert newsubContrat;
  
            List < Contract > ContratRecords = new List < Contract > ();
            ContratRecords.add(new Contract(id = idcontrat, InwiB2C_Prix_de_Vente__c = prixvente, InwiB2C_Date_de_souscription__c=Date.today()));
            update ContratRecords;
  
        }
        //insert into portability
      // H-M TTM MC_SF24-006_Portabilité_Fix Enlever la condition ProductType != FTTH    
       //Vula ILA Vula 26/02/25 ajouter la condition ur le statut de Partage Start  
        //B-26981 ILA  10/03/25 Start
        // if (orderlist.inwib2c_TypeDeLaCommande__c == 'inwiB2C_Acquisition'  && choixnimber == 'porter' && operator != 'WIN' && ProductType != 'ADSL' && statutPartage != 'LA') 
        if (action == 'Add' && choixnimber == 'porter' && operator != 'WIN' && ProductType != 'ADSL' && statutPartage != 'LA') 
         //B-26981 ILA  10/03/25 End
        //Vula ILA Vula 26/02/25 ajouter la condition ur le statut de Partage End 
         {
            contact listContact = [select FirstName, LastName, InwiB2C_CIN__c, InwiB2C_Type_CIN__c from contact where id =: contactid];
            //get asset id
            Asset assetListid = [select id, product2.ProductCode, CreatedDate, vlocity_cmt__OrderProductId__c, vlocity_cmt__AssetReferenceId__c, vlocity_cmt__OrderProductId__r.OrderId, vlocity_cmt__ParentItemId__c, Product2.Name from asset where vlocity_cmt__OrderProductId__c =: orditemId];
  
            string Idasset2 = assetListid.id;
  
            if (listContact.InwiB2C_Type_CIN__c == 'Carte d\'Identité Nationale') {
                cintype = '01';
            }
            if (listContact.InwiB2C_Type_CIN__c == 'Passeport') {
                cintype = '02';
            }
            if (listContact.InwiB2C_Type_CIN__c == 'Carte de séjour') {
                cintype = '03';
            }
            //Meryem Yahya MGEN3626-Améliorations Porta diverses
            //Si la demande de porta est faite avec un code RIO alors mettre la valeur 05 sur le champ type d'identification.
             if (String.isNotBlank(coderio)) {
                cintype = '05';
            }

            //Meryem Yahya MGEN3626-Améliorations Porta diverses
           //  H-M TTM MC_SF24-006_Portabilité_Fix Ticket B-16037
            if (natureoffre == 'Mobile' && ProductType != 'ADSL' && ProductType != 'FTTH' ) {
                natureoffre = 'MOBILE';
                newrout = 'D66';
            } else {
                natureoffre = 'FIXE';
                newrout = '';
            }
  
            if (operator == 'MARM1') {
                descroperator = 'MAROCTELECOM';
            } else {
                descroperator = 'ORANGE';
            }
            INWIB2C_PORTABILITE_REQ__c newreqportain = new INWIB2C_PORTABILITE_REQ__c(
                INWIB2C_PORTEDNUMBER__c = portednumber,
                INWIB2C_TEMPNUMBER__c = mdn,
                INWIB2C_ORDERID__c = ordId,
                INWIB2C_ORIGINE_OPERATOR__c = descroperator,
                INWIB2C_CLIENT_PORTA__c = accoutid,
                INWIB2C_DATE_PORTA__c = myDateporta,
                INWIB2C_REJECT_REASON__c = '',
                INWIB2C_NATIONAL_ID__c = listContact.InwiB2C_CIN__c,
                INWIB2C_NATURE_OFFRE__c = natureoffre,
                INWIB2C_NEWROUTE__c = newrout,
                INWIB2C_STATUT_PORTA__c = 'Nouveau',
                INWIB2C_TYPE_CIN__c = cintype,
                INWIB2C_ASSET_ID__c = Idasset2,
                InwiB2C_Order_Root_Id__c = rootorderitem,
                INWIB2C_RIO__c=coderio
            );
            insert newreqportain;
        }
        // update status subscription
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_Suspension') {
            orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
            Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
            List < vlocity_cmt__Subscription__c > subscrRecords = new List < vlocity_cmt__Subscription__c > ();
             /**B-8863  TMA 27/04/2023 Begin*/
            List < InwiB2C_BlackList__c > Blacklist = new List < InwiB2C_BlackList__c > ();
            InwiB2C_BlackList__c [] Liststatusblack=[select InwiB2C_Status__c from InwiB2C_BlackList__c where InwiB2C_CIN__c =: cin limit 1];
            InwiB2C_BlackList__c statusblack;
            /**Fraude 15/08/24 Ila Start */
            if (orderlist.inwiB2C_MotifDeSuspension__c == 'Fraude'||orderlist.inwiB2C_MotifDeSuspension__c == 'Préserver' || orderlist.inwiB2C_MotifDeSuspension__c == 'Usage Indu' || orderlist.inwiB2C_MotifDeSuspension__c == 'Usage indu PSP' || orderlist.inwiB2C_MotifDeSuspension__c == 'Usage indu PREP' || orderlist.inwiB2C_MotifDeSuspension__c == 'Préserver PREP' ) {
                String motif='';
                switch on orderlist.inwiB2C_MotifDeSuspension__c {
                    when 'Fraude' {
                        motif = 'inwiB2C_Fraude';
                    }
                    when 'Préserver' {
                        motif = 'inwiB2C_Preserver';
                    }
                    when 'Usage Indu' {
                        motif = 'inwiB2C_UsageIndu';
                    }
                    when 'Usage indu PSP' {
                        motif = 'inwiB2C_UsageInduPSP';
                    }
                    when 'Usage indu PREP' {
                        motif = 'inwiB2C_UsageInduPREP';
                    }
                    when 'Préserver PREP' {
                        motif = 'inwiB2C_PreserverPREP';
                    }
                } 
                /**Fraude 15/08/24 Ila End */
                 /**B-8863  TMA 27/04/2023 End*/
                subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, inwiB2C_Statut__c = 'InwiB2C_SuspendueFraude',inwiB2C_LegacyStatus__c = 'Suspendue', vlocity_cmt__Status__c = 'Suspended',Blacklist__c= true));
                 /**B-8863  TMA 27/04/2023 Begin*/
                if(Liststatusblack.size()>0){
                    statusblack=Liststatusblack[0];
                    statusblack.InwiB2C_Status__c =true;
                    statusblack.InwiB2C_Motif__c=motif;
                    update statusblack;
                }else{
                    Blacklist.add(new InwiB2C_BlackList__c(InwiB2C_CIN__c=cin,InwiB2C_Status__c=true,InwiB2C_FirstName__c=orderlist.Account.vlocity_cmt__PersonContactId__r.FirstName,InwiB2C_LastName__c=orderlist.Account.vlocity_cmt__PersonContactId__r.LastName,InwiB2C_TypeCIN__c=orderlist.Account.vlocity_cmt__PersonContactId__r.InwiB2C_Type_CIN__c,InwiB2C_Motif__c=motif));
                    insert Blacklist;
                }
                /**B-8863  TMA 27/04/2023 End*/
            } else {
                subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, inwiB2C_LegacyStatus__c = 'Suspendue', inwiB2C_Statut__c = 'InwiB2C_Suspended', vlocity_cmt__Status__c = 'Suspended'));
            }
            update subscrRecords;
  
        }

        /**B-8002 ILA 21/02/2023 Begin*/
        if(orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_SuspensionFacturationReseau'){
            orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
            Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
            List < vlocity_cmt__Subscription__c > subscrRecords = new List < vlocity_cmt__Subscription__c > ();
            subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, inwiB2C_Statut__c = 'InwiB2C_SuspendueFacturationReseau', inwiB2C_LegacyStatus__c = 'Suspension Facturation et Reseau',vlocity_cmt__Status__c = 'Suspended'));
            update subscrRecords;
        }
        /**B-8002 ILA 21/02/2023 End*/
        // CHB 05/10/2023 SAV SIM AVEC REHAB
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_Rehabilitation' || orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_ChangementDeCarteSIMAvecRehab') {
            
            orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
            Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c,vlocity_cmt__SubscriptionId__r.inwiB2C_Statut__c,vlocity_cmt__SubscriptionId__r.inwiB2C_LegacyStatus__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];

            List < vlocity_cmt__Subscription__c > subscrRecords = new List < vlocity_cmt__Subscription__c > ();
          /**CHB ANO  B-18889  07/08/2024 BEGIN*/
            /**Fraude ILA 13/07/24 Start */
            if(subscriptionList.vlocity_cmt__SubscriptionId__r.inwiB2C_Statut__c == 'InwiB2C_SuspendueFraude'){
                //subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, inwiB2C_Statut__c = 'InwiB2C_Active', vlocity_cmt__Status__c = 'Active'));
                //update subscrRecords;
                /**B-8863  TMA 27/04/2023 Begin*/

                    List < InwiB2C_BlackList__c > Blacklist = new List < InwiB2C_BlackList__c > ();
                    InwiB2C_BlackList__c [] Liststatusblack=[select InwiB2C_Status__c from InwiB2C_BlackList__c where InwiB2C_CIN__c =: cin limit 1];
                    /** TMA 15/05/2023 Begin*/
                    List<vlocity_cmt__Subscription__c> subSuspList = [select id, vlocity_cmt__Status__c from vlocity_cmt__Subscription__c where vlocity_cmt__AccountId__r.Inwib2c_CIN__c= :cin AND vlocity_cmt__Status__c = 'Suspended'];
                    /** TMA 15/05/2023 End*/
                    InwiB2C_BlackList__c statusblack;
                    //if(Liststatusblack.size()>0 && subSuspList.size()==1 ){
                    if(Liststatusblack.size()>0 && subSuspList.size()>0 ){
                        statusblack=Liststatusblack[0];
                        statusblack.InwiB2C_Status__c =false;
                    }
                    update statusblack;
                    subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c,  inwiB2C_Statut__c = 'InwiB2C_Active',inwiB2C_LegacyStatus__c = 'ACTIVE', vlocity_cmt__Status__c = 'Active',Blacklist__c=false));
                    update subscrRecords;
            }
            else{
                subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c,  inwiB2C_Statut__c = 'InwiB2C_Active', inwiB2C_LegacyStatus__c = 'ACTIVE',vlocity_cmt__Status__c = 'Active'));
                update subscrRecords;
            }
            /**Fraude ILA 13/07/24 End */
            
            /**B-8863  TMA 27/04/2023 End*/
           /**CHB ANO B-18889 07/08/2024 end*/
  
        }
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_ModificationDeNumero' || orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_ChangementDeNumeroPorta') {
            orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
            Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
            List < vlocity_cmt__Subscription__c > subscrRecords = new List < vlocity_cmt__Subscription__c > ();
            subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, Inwib2c_Num_ro_de_la_ligne__c = mdn, Name = mdn));
            update subscrRecords;
  
        }
        /*B- RMA 14/03/2022 begin */
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_ChangementTypeLigne') {
          orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
          Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
          List <vlocity_cmt__Subscription__c > subscrRecords = new List < vlocity_cmt__Subscription__c > ();
          subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, Inwib2c_Num_ro_de_la_ligne__c = mdn, Name = mdn,InwiB2C_Type_Client__c = typeLigne,inwiB2C_Montant_de_l_abonnement__c = prixAbonn));
          update subscrRecords;
  
      }
        /*B- RMA 14/03/2022 END */
        
        /*B-13347 ABB 03/01/2024 begin */
        if (orderlist.inwiB2C_TypeDeMigration__c == 'inwiB2C_Migration_Prepaye_vers_Campus' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_campus_prepaye' ) {
          orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
          Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
          List <vlocity_cmt__Subscription__c > subscrRecords = new List < vlocity_cmt__Subscription__c > ();
          subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, InwiB2C_Id_profil__c = profileid, Inwib2c_Profil__c =profileid));
          update subscrRecords;
            /* CHB 24/01/2024 API SWAP ws64 begin*/
            if(orderlist.inwiB2C_TypeDeMigration__c == 'inwiB2C_Migration_Prepaye_vers_Campus' && orderlist.inwib2c_Canal__c=='inwiB2C_MyInwi'){
            	Account accountCampusList = [select id ,inwib2c_UniversiteEtablissement__c from Account where id=:orderlist.Old_Account_id__c];
           		String universiteEtablissement=accountCampusList.inwib2c_UniversiteEtablissement__c;	
                Account AccListPrep=[select id ,inwib2c_UniversiteEtablissement__c from Account where id =:orderlist.AccountId];
                AccListPrep.inwib2c_UniversiteEtablissement__c=universiteEtablissement;
                update AccListPrep;
            }/*CHB 24/01/2024 API SWAP ws64 end*/
        }
        /*B-13347 ABB 03/01/2024 END */
        
        /**B-14273 ILA 19/02/2024 Start */
        if (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_ADSL_Vers_FTTH'){
            vlocity_cmt__Subscription__c SubscriptionADSL = [select id,Inwib2c_Num_ro_de_la_ligne__c from vlocity_cmt__Subscription__c where Id =:orderlist.InwiB2C_Subscription_Migration__c];
            String numeroDesignation = '0'+SubscriptionADSL.Inwib2c_Num_ro_de_la_ligne__c.substring(3);
            /* CHB 17/04/2024 ano B-15335 begin */
            List<INWIB2C_DEMANDE_DEGROUPAGE__c> degroupageClone = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
            if (!Test.isRunningTest()) {
                  degroupageClone = [select Id,InwiB2C_Commande_de_degroupage__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where (InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation ) and InwiB2C_Statutdegroupage__c =:'REU' order by CreatedDate desc limit 1];
                  /**B-15867 ILA 08/05/2024 Start*/ 
                  if(degroupageClone.isEmpty()){
                    degroupageClone = [select Id,InwiB2C_Commande_de_degroupage__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where (InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation ) and InwiB2C_Statutdegroupage__c =:'ACT' order by CreatedDate desc limit 1];
                    if(degroupageClone.isEmpty()){
                        degroupageClone = [select Id,InwiB2C_Commande_de_degroupage__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where (InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation ) and InwiB2C_Statutdegroupage__c =:'SOU' order by CreatedDate desc limit 1];
                    }
                }
                  /**B-15867 ILA 08/05/2024 End*/ 
            }else{
                  degroupageClone = [select Id,InwiB2C_Commande_de_degroupage__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation order by CreatedDate desc limit 1]; 
            }
             /* CHB 17/04/2024 ano B-15335 end */
            Map<String,Object> inputCloneDeg = new Map<String,Object>();
            /**B-15867 ILA 08/05/2024 Start*/
            //inputCloneDeg.put('InwiB2C_Commande_de_degroupage__c',degroupageClone.InwiB2C_Commande_de_degroupage__c);
            inputCloneDeg.put('InwiB2C_Commande_de_degroupage__c',degroupageClone[0].InwiB2C_Commande_de_degroupage__c);
            /**B-15867 ILA 08/05/2024 End*/
            inputCloneDeg.put('InwiB2C_Order__c',orderlist.id);
            /* CHB 01/04/2024 ANO B-15150 BEGIN*/
            //inputCloneDeg.put('InwiB2C_Statutdegroupage__c','RES');
            inputCloneDeg.put('InwiB2C_Statutdegroupage__c','inwiB2C_en_cours_de_resiliation');
            /* CHB 01/04/2024 ANO B-15150 END*/
            inputCloneDeg.put('InwiB2C_typeCommande__c','RS1');
            /* CHB 17/04/2024 ano B-15335 begin */
            /* CHB 04/06/2024 ano B-14597 begin */
            inputCloneDeg.put('newCommande','true');
            //inputCloneDeg.put('newCommande','false');
             /* CHB 04/06/2024 ano B-14597 end */
            /* CHB 17/04/2024 ano B-15335 end */
            InwiB2C_ManageDegroupageOrder.cloneDemandeDeg(inputCloneDeg);
        }


        //B-28987 ILA Start
        /*if ((orderlist.inwiB2C_TypeActeDeGestion__c =='inwiB2C_Resiliation'||orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_Remboursement_Offre' || orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_DéconnecterService' || orderlist.inwiB2C_TypeActeDeGestion__c== 'InwiB2C_ResiliationSuiteRemboursementClient') && (orderlist.InwiB2C_Offre__c=='ADSL XTRA by inwi Jusqu\'à 20 Mega' || orderlist.InwiB2C_Offre__c=='Offre ADSL 149 Dhs' ) )*/
        if ((orderlist.inwiB2C_TypeActeDeGestion__c =='inwiB2C_Resiliation'||orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_Remboursement_Offre' || orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_DéconnecterService' || orderlist.inwiB2C_TypeActeDeGestion__c== 'InwiB2C_ResiliationSuiteRemboursementClient' || orderlist.inwiB2C_TypeActeDeGestion__c== 'inwiB2C_PortaOut') && ProductType=='ADSL')
        //B-28987 ILA end
        {
            inwiB2C_OrderSubscription__c Ordersub = [select id,inwiB2C_Subscription__r.Inwib2c_Num_ro_de_la_ligne__c from inwiB2C_OrderSubscription__c where inwiB2C_Order__c =:orderlist.id order by CreatedDate DESC limit 1];
        	String numeroDesignation = '0'+Ordersub.inwiB2C_Subscription__r.Inwib2c_Num_ro_de_la_ligne__c.substring(3);
         	/* CHB 17/04/2024 ano B-15335 begin */
             List<INWIB2C_DEMANDE_DEGROUPAGE__c> degroupageClone = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
             if (!Test.isRunningTest()) {
                  degroupageClone = [select Id,CreatedDate,InwiB2C_Commande_de_degroupage__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where (InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation) and InwiB2C_Statutdegroupage__c =:'REU' order by CreatedDate desc limit 1]; 																																																		
                  /**B-15867 ILA 08/05/2024 Start*/ 
                  if(degroupageClone.isEmpty()){
                    degroupageClone = [select Id,InwiB2C_Commande_de_degroupage__c,CreatedDate FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where (InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation ) and InwiB2C_Statutdegroupage__c =:'ACT' order by CreatedDate desc limit 1];
                    if(degroupageClone.isEmpty()){
                        degroupageClone = [select Id,InwiB2C_Commande_de_degroupage__c,CreatedDate FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where (InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation ) and InwiB2C_Statutdegroupage__c =:'SOU' order by CreatedDate desc limit 1];
                    }
                }
                  /**B-15867 ILA 08/05/2024 End*/ 
                }else{
                  degroupageClone = [select Id,InwiB2C_Commande_de_degroupage__c,CreatedDate FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation order by CreatedDate desc limit 1]; 																																																		
             }



            /* CHB 17/04/2024 ano B-15335 end */
            Map<String,Object> inputCloneDeg = new Map<String,Object>();
            /**B-15867 ILA 08/05/2024 Start*/
            //inputCloneDeg.put('InwiB2C_Commande_de_degroupage__c',degroupageClone.InwiB2C_Commande_de_degroupage__c);
            inputCloneDeg.put('InwiB2C_Commande_de_degroupage__c',degroupageClone[0].InwiB2C_Commande_de_degroupage__c);
              /**B-15867 ILA 08/05/2024 End*/
            inputCloneDeg.put('InwiB2C_Order__c',orderlist.id);
              /* CHB 01/04/2024 ANO B-15150 BEGIN*/

            //inputCloneDeg.put('InwiB2C_Statutdegroupage__c','RES');

            //C-Y PO satisfait ou remboursé begin
            Boolean isWithin5BusinessDays = false;
            if(orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_Remboursement_Offre'){
                Datetime purchaseDateTime = degroupageClone[0].CreatedDate;
                Date purchaseDate = purchaseDateTime.date();
                system.debug(purchaseDate);
                isWithin5BusinessDays = InwiB2C_DaysCalculator.isWithinBusinessDays(purchaseDate, 1);
                if (isWithin5BusinessDays){
                    inputCloneDeg.put('InwiB2C_Statutdegroupage__c','ANN');
                    inputCloneDeg.put('newCommande','false');
                    }
            }
            //C-Y PO satisfait ou remboursé end
            if(!isWithin5BusinessDays){
            inputCloneDeg.put('InwiB2C_Statutdegroupage__c','inwiB2C_en_cours_de_resiliation');
            /* CHB 01/04/2024 ANO B-15150 END*/
            inputCloneDeg.put('InwiB2C_typeCommande__c','RS1');
            
            /* CHB 17/04/2024 ano B-15335 begin */
                /* CHB 04/06/2024 ano B-14597 begin */
            inputCloneDeg.put('newCommande','true');
        }
            //inputCloneDeg.put('newCommande','false');
                /* CHB 04/06/2024 ano B-14597 end */
	        /* CHB 17/04/2024 ano B-15335 end */
            InwiB2C_ManageDegroupageOrder.cloneDemandeDeg(inputCloneDeg);
            
        }
       /*B-10468 CHB 28/07/2023 begin */
       /*
       if (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_ADSL_Vers_FTTH' ) {
        vlocity_cmt__Subscription__c SubscriptionADSL = [select id,Inwib2c_Num_ro_de_la_ligne__c from vlocity_cmt__Subscription__c where Id =:orderlist.InwiB2C_Subscription_Migration__c];
         String numeroDesignation = '0'+SubscriptionADSL.Inwib2c_Num_ro_de_la_ligne__c.substring(3);

         INWIB2C_DEMANDE_DEGROUPAGE__c  degroupageClone = [select InwiB2C_ACTION__c,InwiB2C_ADRESSE__c,InwiB2C_Account__c,InwiB2C_AdresseIAMProposee__c,InwiB2C_Agence__c,InwiB2C_BAT__c,InwiB2C_CCOM__c,InwiB2C_CLIENT_TYPE__c,InwiB2C_CQUARTIER__c,InwiB2C_CVOIE__c,InwiB2C_CodeMotifRejet__c,InwiB2C_Commentaire__c,InwiB2C_DEGROUPAGE_NUM__c,InwiB2C_Debit__c,InwiB2C_DetailErreur__c,InwiB2C_Dslamport__c,InwiB2C_ESC__c,InwiB2C_ETAGE__c,InwiB2C_FirstName__c,InwiB2C_LastName__c,InwiB2C_MotifAnnulation__c,InwiB2C_Motif__c,InwiB2C_NVOIE__c,InwiB2C_Nationalid__c,InwiB2C_NouvelleTechnologie__c,InwiB2C_NumeroDesignation__c,InwiB2C_Order__c,InwiB2C_PORTE__c,InwiB2C_PartenaireCode__c,InwiB2C_SEQ_NUM__c,InwiB2C_Site__c,InwiB2C_StatutDegroupageIAM__c,InwiB2C_StatutLigneIam__c,InwiB2C_Statutdegroupage__c,InwiB2C_Technologie__c,InwiB2C_categorieClient__c,InwiB2C_codeOpDemandeur__c,InwiB2C_codeRoutage__c,InwiB2C_dateOrdre__c,InwiB2C_ndOperateur__c,InwiB2C_ndPrecedent__c,InwiB2C_numeroContact__c,InwiB2C_portabilite__c,InwiB2C_positionReglette__c,InwiB2C_qualiteService__c,InwiB2C_rendezvous__c,InwiB2C_typeCommande__c,InwiB2C_typePrestation__c,InwiB2C_AvecInstallationDomicile__c,InwiB2C_OrigineDemande__c,InwiB2C_Date_de_mise_en_service__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation order by CreatedDate desc limit 1]; 																																																		
        
         InwiB2C_Sequence_Order_Number__c sequenceDeg = [select id,InwiB2C_Sequence__c from InwiB2C_Sequence_Order_Number__c where name =:'Sequence Degroupage'];
        
         INWIB2C_DEMANDE_DEGROUPAGE__c degroupageList = new INWIB2C_DEMANDE_DEGROUPAGE__c(
            InwiB2C_DEGROUPAGE_NUM__c = sequenceDeg.InwiB2C_Sequence__c +1,
            InwiB2C_SEQ_NUM__c = degroupageClone.InwiB2C_SEQ_NUM__c+1,
            InwiB2C_Order__c = orderlist.id,
            InwiB2C_NumeroDesignation__c = degroupageClone.InwiB2C_NumeroDesignation__c,
            InwiB2C_CLIENT_TYPE__c = degroupageClone.InwiB2C_CLIENT_TYPE__c,
            InwiB2C_Account__c = degroupageClone.InwiB2C_Account__c,
            InwiB2C_Site__c = degroupageClone.InwiB2C_Site__c,
            InwiB2C_LastName__c = degroupageClone.InwiB2C_LastName__c,
            InwiB2C_FirstName__c = degroupageClone.InwiB2C_FirstName__c,
            InwiB2C_Nationalid__c = degroupageClone.InwiB2C_Nationalid__c,
            InwiB2C_ADRESSE__c = degroupageClone.InwiB2C_ADRESSE__c,
            InwiB2C_Statutdegroupage__c = 'RES',//CHB 30/01/2024 B-14045
            InwiB2C_Dslamport__c = degroupageClone.InwiB2C_Dslamport__c,
            InwiB2C_StatutLigneIam__c = degroupageClone.InwiB2C_StatutLigneIam__c,
            InwiB2C_Technologie__c = degroupageClone.InwiB2C_Technologie__c,
            InwiB2C_PartenaireCode__c = degroupageClone.InwiB2C_PartenaireCode__c,
            InwiB2C_ACTION__c = degroupageClone.InwiB2C_ACTION__c,
            InwiB2C_codeOpDemandeur__c = degroupageClone.InwiB2C_codeOpDemandeur__c,
            InwiB2C_typeCommande__c = 'RS1',
            InwiB2C_ndOperateur__c = degroupageClone.InwiB2C_ndOperateur__c,
            InwiB2C_dateOrdre__c = degroupageClone.InwiB2C_dateOrdre__c,
            InwiB2C_portabilite__c = degroupageClone.InwiB2C_portabilite__c,
            InwiB2C_codeRoutage__c = degroupageClone.InwiB2C_codeRoutage__c,
            InwiB2C_positionReglette__c = degroupageClone.InwiB2C_positionReglette__c,
            InwiB2C_typePrestation__c = degroupageClone.InwiB2C_typePrestation__c,
            InwiB2C_Debit__c = degroupageClone.InwiB2C_Debit__c,
            InwiB2C_qualiteService__c = degroupageClone.InwiB2C_qualiteService__c,
            InwiB2C_categorieClient__c = degroupageClone.InwiB2C_categorieClient__c,
            InwiB2C_numeroContact__c = degroupageClone.InwiB2C_numeroContact__c,
            InwiB2C_rendezvous__c = degroupageClone.InwiB2C_rendezvous__c,
            InwiB2C_PORTE__c = degroupageClone.InwiB2C_PORTE__c,
            InwiB2C_ETAGE__c = degroupageClone.InwiB2C_ETAGE__c,
            InwiB2C_ESC__c = degroupageClone.InwiB2C_ESC__c,
            InwiB2C_BAT__c = degroupageClone.InwiB2C_BAT__c,
            InwiB2C_NVOIE__c = degroupageClone.InwiB2C_NVOIE__c,
            InwiB2C_CVOIE__c = degroupageClone.InwiB2C_CVOIE__c,
            InwiB2C_CQUARTIER__c = degroupageClone.InwiB2C_CQUARTIER__c,
            InwiB2C_CCOM__c = degroupageClone.InwiB2C_CCOM__c,
            InwiB2C_Agence__c = degroupageClone.InwiB2C_Agence__c
        );
        insert degroupageList;
        sequenceDeg.InwiB2C_Sequence__c = sequenceDeg.InwiB2C_Sequence__c +1;
         update sequenceDeg; 
    }
    */
    
      /*
    // H-M Ajouter SMO InwiB2C_ResiliationSuiteRemboursementClient suite au ticket B-13282
     if ((orderlist.inwiB2C_TypeActeDeGestion__c =='inwiB2C_Resiliation'||orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_Remboursement_Offre' || orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_DéconnecterService' || orderlist.inwiB2C_TypeActeDeGestion__c== 'InwiB2C_ResiliationSuiteRemboursementClient') && orderlist.InwiB2C_Offre__c=='ADSL XTRA by inwi Jusqu\'à 20 Mega' ) {
        inwiB2C_OrderSubscription__c Ordersub = [select id,inwiB2C_Subscription__r.Inwib2c_Num_ro_de_la_ligne__c from inwiB2C_OrderSubscription__c where inwiB2C_Order__c =:orderlist.id order by CreatedDate DESC limit 1];
        String numeroDesignation = '0'+Ordersub.inwiB2C_Subscription__r.Inwib2c_Num_ro_de_la_ligne__c.substring(3);
        system.debug('numeroDesignation'+numeroDesignation);
        system.debug('Ordersub'+Ordersub);
         INWIB2C_DEMANDE_DEGROUPAGE__c  degroupageClone = [select InwiB2C_ACTION__c,InwiB2C_ADRESSE__c,InwiB2C_Account__c,InwiB2C_AdresseIAMProposee__c,InwiB2C_Agence__c,InwiB2C_BAT__c,InwiB2C_CCOM__c,InwiB2C_CLIENT_TYPE__c,InwiB2C_CQUARTIER__c,InwiB2C_CVOIE__c,InwiB2C_CodeMotifRejet__c,InwiB2C_Commentaire__c,InwiB2C_DEGROUPAGE_NUM__c,InwiB2C_Debit__c,InwiB2C_DetailErreur__c,InwiB2C_Dslamport__c,InwiB2C_ESC__c,InwiB2C_ETAGE__c,InwiB2C_FirstName__c,InwiB2C_LastName__c,InwiB2C_MotifAnnulation__c,InwiB2C_Motif__c,InwiB2C_NVOIE__c,InwiB2C_Nationalid__c,InwiB2C_NouvelleTechnologie__c,InwiB2C_NumeroDesignation__c,InwiB2C_Order__c,InwiB2C_PORTE__c,InwiB2C_PartenaireCode__c,InwiB2C_SEQ_NUM__c,InwiB2C_Site__c,InwiB2C_StatutDegroupageIAM__c,InwiB2C_StatutLigneIam__c,InwiB2C_Statutdegroupage__c,InwiB2C_Technologie__c,InwiB2C_categorieClient__c,InwiB2C_codeOpDemandeur__c,InwiB2C_codeRoutage__c,InwiB2C_dateOrdre__c,InwiB2C_ndOperateur__c,InwiB2C_ndPrecedent__c,InwiB2C_numeroContact__c,InwiB2C_portabilite__c,InwiB2C_positionReglette__c,InwiB2C_qualiteService__c,InwiB2C_rendezvous__c,InwiB2C_typeCommande__c,InwiB2C_typePrestation__c,InwiB2C_AvecInstallationDomicile__c,InwiB2C_OrigineDemande__c,InwiB2C_Date_de_mise_en_service__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation order by CreatedDate desc limit 1]; 																																																		
        
         InwiB2C_Sequence_Order_Number__c sequenceDeg = [select id,InwiB2C_Sequence__c from InwiB2C_Sequence_Order_Number__c where name='Sequence Degroupage'];
         
         INWIB2C_DEMANDE_DEGROUPAGE__c degroupageList = new INWIB2C_DEMANDE_DEGROUPAGE__c(
            InwiB2C_DEGROUPAGE_NUM__c =sequenceDeg.InwiB2C_Sequence__c +1,
            InwiB2C_SEQ_NUM__c = degroupageClone.InwiB2C_SEQ_NUM__c+1,
            InwiB2C_Order__c = orderlist.id,
            InwiB2C_NumeroDesignation__c = degroupageClone.InwiB2C_NumeroDesignation__c,
            InwiB2C_CLIENT_TYPE__c = degroupageClone.InwiB2C_CLIENT_TYPE__c,
            InwiB2C_Account__c = degroupageClone.InwiB2C_Account__c,
            InwiB2C_Site__c = degroupageClone.InwiB2C_Site__c,
            InwiB2C_LastName__c = degroupageClone.InwiB2C_LastName__c,
            InwiB2C_FirstName__c = degroupageClone.InwiB2C_FirstName__c,
            InwiB2C_Nationalid__c = degroupageClone.InwiB2C_Nationalid__c,
            InwiB2C_ADRESSE__c = degroupageClone.InwiB2C_ADRESSE__c,
            InwiB2C_Statutdegroupage__c = 'RES',//CHB 30/01/2024 B-14045
            InwiB2C_Dslamport__c = degroupageClone.InwiB2C_Dslamport__c,
            InwiB2C_StatutLigneIam__c = degroupageClone.InwiB2C_StatutLigneIam__c,
            InwiB2C_Technologie__c = degroupageClone.InwiB2C_Technologie__c,
            InwiB2C_PartenaireCode__c = degroupageClone.InwiB2C_PartenaireCode__c,
            InwiB2C_ACTION__c = degroupageClone.InwiB2C_ACTION__c,
            InwiB2C_codeOpDemandeur__c = degroupageClone.InwiB2C_codeOpDemandeur__c,
            InwiB2C_typeCommande__c = 'RS1',
            InwiB2C_ndOperateur__c = degroupageClone.InwiB2C_ndOperateur__c,
            InwiB2C_dateOrdre__c = degroupageClone.InwiB2C_dateOrdre__c,
            InwiB2C_portabilite__c = degroupageClone.InwiB2C_portabilite__c,
            InwiB2C_codeRoutage__c = degroupageClone.InwiB2C_codeRoutage__c,
            InwiB2C_positionReglette__c = degroupageClone.InwiB2C_positionReglette__c,
            InwiB2C_typePrestation__c = degroupageClone.InwiB2C_typePrestation__c,
            InwiB2C_Debit__c = degroupageClone.InwiB2C_Debit__c,
            InwiB2C_qualiteService__c = degroupageClone.InwiB2C_qualiteService__c,
            InwiB2C_categorieClient__c = degroupageClone.InwiB2C_categorieClient__c,
            InwiB2C_numeroContact__c = degroupageClone.InwiB2C_numeroContact__c,
            InwiB2C_rendezvous__c = degroupageClone.InwiB2C_rendezvous__c,
            InwiB2C_PORTE__c = degroupageClone.InwiB2C_PORTE__c,
            InwiB2C_ETAGE__c = degroupageClone.InwiB2C_ETAGE__c,
            InwiB2C_ESC__c = degroupageClone.InwiB2C_ESC__c,
            InwiB2C_BAT__c = degroupageClone.InwiB2C_BAT__c,
            InwiB2C_NVOIE__c = degroupageClone.InwiB2C_NVOIE__c,
            InwiB2C_CVOIE__c = degroupageClone.InwiB2C_CVOIE__c,
            InwiB2C_CQUARTIER__c = degroupageClone.InwiB2C_CQUARTIER__c,
            InwiB2C_CCOM__c = degroupageClone.InwiB2C_CCOM__c,
            InwiB2C_Agence__c = degroupageClone.InwiB2C_Agence__c
        );
        insert degroupageList;
        sequenceDeg.InwiB2C_Sequence__c = sequenceDeg.InwiB2C_Sequence__c +1;
        update sequenceDeg;  
       
    }
    */
    /**B-14273 ILA 19/02/2024 End */
       /*B-10468 CHB 28/07/2023 End */
        /*B-2657 DLE 18/08/2021 begin */
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_ChangementDeNumeroPorta') {
            orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
            INWIB2C_PORTABILITE_REQ__c portaList = [select id from INWIB2C_PORTABILITE_REQ__c where INWIB2C_ASSET_ID__c =: assetList1.vlocity_cmt__AssetId__c];
            List < INWIB2C_PORTABILITE_REQ__c > portrRecords = new List < INWIB2C_PORTABILITE_REQ__c > ();
            portrRecords.add(new INWIB2C_PORTABILITE_REQ__c(id = portaList.id, INWIB2C_STATUT_PORTA__c = 'Portee'));
            update portrRecords;
  
        }
        /*B-2657 DLE 18/08/2021 end */
        // update status subscriptions
        if ((orderlist.inwiB2C_TypeDeMigration__c == 'inwiB2C_MigrationKoulchiVersTicTac' && action == 'Disconnect') ||(orderlist.inwiB2C_TypeDeMigration__c == 'Migration Postpayé Postpayé' && action == 'Disconnect') || (orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_resiliation_CH_technologie' && action == 'Disconnect') || orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_PortaOutWin'||(orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Retention_Cascade' && action == 'Disconnect') ||(orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostpayé' && action == 'Disconnect') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_come-back' && action == 'Disconnect') || (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_PortaOut') ||(orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_PortaOutWin') || (orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_Remboursement_Offre') || (orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_Remboursement_Suite_Refus_Porta_FTTH') || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPrePostAvecIdentification' && action == 'Disconnect')) {//Saad 05/02/2024 ttm Migration PrePOST avec identification
            orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
            Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
            List < vlocity_cmt__Subscription__c > subscrRecords = new List < vlocity_cmt__Subscription__c > ();
              /*B-6440 DLE 22/11/2022 begin */
             /* B-7692 DLE 27/01/2023 begin */
               /*if ((orderlist.inwiB2C_TypeDeMigration__c == 'inwiB2C_MigrationKoulchiVersTicTac' && action == 'Disconnect') || orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_PortaOut') */
               if ((orderlist.inwiB2C_TypeDeMigration__c == 'inwiB2C_MigrationKoulchiVersTicTac' && action == 'Disconnect') || orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_PortaOut'  || orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_PortaOutWin'|| orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_Remboursement_Offre'  || orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_Remboursement_Suite_Refus_Porta_FTTH')  
               /* B-7692 DLE 27/01/2023 end */
              {
              /*B-6440 DLE 22/11/2022 end */
              subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, inwiB2C_Statut__c = 'InwiB2C_Expired', inwiB2C_LegacyStatus__c = 'EXPIRED', vlocity_cmt__Status__c = 'Expired'));
           /*B-6440 DLE 22/11/2022 begin */  
            } else 
            {subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, inwiB2C_Statut__c = 'InwiB2C_Expired', inwiB2C_LegacyStatus__c = 'EXPIRED',vlocity_cmt__Status__c = 'Expired',INWIB2C_NoSynchronize__c=true));
             } 
            /*B-6440 DLE 22/11/2022 end */
            update subscrRecords;
  
        }
        // CHB 05/10/2023 SAV SIM AVEC REHAB
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_ChangementDeCarteSIMAvecRehab' || orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_ChangementDeCarteSIM' || orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_SAVInterneChangementDeCarteSIM') {
            orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
            Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
            List < vlocity_cmt__Subscription__c > subscrRecords = new List < vlocity_cmt__Subscription__c > ();
            //subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, InwiB2C_IMSI__c = IMSI, Inwib2c_ICC__c = icc, Inwib2c_code_puk__c = puck));      
            /*B-6520 Begin*/
            /**ESim ILA 01/04/2024 START ajouter inwib2c_Categorie_de_sim__c=typeSim sur les records */
            if (orderlist.inwiB2C_MotifChangementCarteSim__c == 'inwiB2C_Upgrade4G' || orderlist.inwiB2C_MotifChangementCarteSim__c == 'inwiB2C_SAVInterneUpgrade4G'){
              subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, InwiB2C_IMSI__c = IMSI, Inwib2c_ICC__c = icc, Inwib2c_code_puk__c = puck, Inwib2c_type_de_sim__c ='4G',inwib2c_Categorie_de_sim__c=typeSim));
            }else {
             subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, InwiB2C_IMSI__c = IMSI, Inwib2c_ICC__c = icc, Inwib2c_code_puk__c = puck,inwib2c_Categorie_de_sim__c=typeSim));
            }
            /*B-6520 End*/
            update subscrRecords;
  
        }
  
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_ChangementDeTerminalModem' || orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_SAVInterneChangementDeTerminalModem') {
            orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
            Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
           
            List < vlocity_cmt__Subscription__c > subscrRecords = new List < vlocity_cmt__Subscription__c > ();
            
            /*B-4462 SAS 02/08/2022 Begin */
            if (orderlist.inwiB2C_MotifChangementCarteSim__c == 'inwiB2C_Upgrade4G'){
              subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, InwiB2C_MEI__c = IMEI, Inwib2c_Terminal__c = libeletterminal,Inwib2c_type_de_sim__c='4G'));
            }else {
                /*TTM Sav Idar ILA 4/3/2024  Start*/
                //subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, InwiB2C_MEI__c = IMEI, Inwib2c_Terminal__c = libeletterminal));
                /* Ano B-21751 Meryem Yahya*/
                vlocity_cmt__Subscription__c subrecordtoadd = new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c, InwiB2C_MEI__c = IMEI, Inwib2c_Terminal__c = libeletterminal);
               if(!String.isBlank(orderlist.InwiB2C_CodeTransactionFMD__c))  subrecordtoadd.InwiB2C_Code_de_transaction_FMD__c=  orderlist.InwiB2C_CodeTransactionFMD__c ;
                subscrRecords.add(subrecordtoadd);
                 /* Ano B-21751 Meryem Yahya*/
                /*TTM Sav Idar ILA 4/3/2024  End*/
            }/*B-4462 SAS 02/08/2022 End */
            update subscrRecords;
  
        }
        // H-M Ajouter SMO InwiB2C_ResiliationSuiteRemboursementClient suite au ticket B-13282
        if(orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_DéconnecterService' || orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_Resiliation' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPost_Prepayé' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Post_Pré_suite_Remboursement' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Cameleon_Prepaye' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Post_Pré_suite_SatisfaitRemboursé'|| orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_ResiliationSuiteAnnulationDegroupage' || orderlist.inwiB2C_TypeActeDeGestion__c =='InwiB2C_ResiliationSuiteRemboursementClient' || orderlist.inwiB2C_TypeActeDeGestion__c =='InwiB2C_ResiliationSuiteAnnulationPartage'){// 
              orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
                Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c]; 
                Id subscriptionId = subscriptionList.vlocity_cmt__SubscriptionId__c;
                vlocity_cmt__Subscription__c  subscriptionResil = [select id,inwiB2C_Statut__c,inwiB2C_LegacyStatus__c,Inwib2c_Num_ro_de_la_ligne__c from vlocity_cmt__Subscription__c where Id =: subscriptionId];
                subscriptionResil.inwiB2C_Statut__c = 'InwiB2C_Expired';
                subscriptionResil.vlocity_cmt__Status__c = 'Expired';
                subscriptionResil.inwiB2C_LegacyStatus__c = 'EXPIRED';
              /*B-6440 DLE 22/11/2022 begin */  
              if(orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPost_Prepayé' || orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Post_Pré_suite_Remboursement')
              {
                  subscriptionResil.INWIB2C_NoSynchronize__c = true;
              }
              /*B-6440 DLE 22/11/2022 end */  
                update subscriptionResil;
              
              /*Insert in InwiB2C_R_siliation_Postpay_e__c ILA 08/09/2022 Start*/
            if(orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPost_Prepayé'){
              /*B-5394 ILA 22/09/2022 Start*/
                /* Recupere le FMS depuis la commande d'acq 
                inwiB2C_OrderSubscription__c orderSubAcq =[select id,inwiB2C_Order__c from inwiB2C_OrderSubscription__c where inwiB2C_Subscription__c =: subscriptionId and inwiB2C_Order__r.inwib2c_TypeDeLaCommande__c ='inwiB2C_Acquisition']; 
                orderitem orderItemParent =[select id,InwiB2C_FMS__c,vlocity_cmt__Action__c from OrderItem where OrderId =:orderSubAcq.inwiB2C_Order__c and vlocity_cmt__ParentItemId__c =''];
               
                InwiB2C_R_siliation_Postpay_e__c ResilPost = new InwiB2C_R_siliation_Postpay_e__c(Name=subscriptionResil.Inwib2c_Num_ro_de_la_ligne__c,
                                                                                                 InwiB2C_MDN__c=subscriptionResil.Inwib2c_Num_ro_de_la_ligne__c,InwiB2C_FMS_de_l_offre__c=orderItemParent.InwiB2C_FMS__c);*/
              vlocity_cmt__Subscription__c subPost = [select id,InwiB2C_FMD__c, InwiB2C_FMS__c,Inwib2c_Num_ro_de_la_ligne__c from vlocity_cmt__Subscription__c where id =: subscriptionId];
              InwiB2C_R_siliation_Postpay_e__c ResilPost = new InwiB2C_R_siliation_Postpay_e__c(Name=subPost.Inwib2c_Num_ro_de_la_ligne__c,
                                                                                                 InwiB2C_MDN__c=subPost.Inwib2c_Num_ro_de_la_ligne__c,InwiB2C_FMS_de_l_offre__c=subPost.InwiB2C_FMS__c,InwiB2C_Date_de_resiliation__c=Date.today());
                insert ResilPost;
            }
            /*Insert in InwiB2C_R_siliation_Postpay_e__c ILA 08/09/2022 End*/

            /**B-14273 ILA 19/02/2024 Start */
            /**B-13901 ILA 24/01/2024 Start */
            if(orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_ResiliationSuiteAnnulationDegroupage'){
                /**B-16271 30/05/2024 ILA Start */
               vlocity_cmt__Subscription__c SubscriptionADSL = [select id,Inwib2c_Num_ro_de_la_ligne__c from vlocity_cmt__Subscription__c where Id =: subscriptionId];
                String numeroDesignation = '0'+SubscriptionADSL.Inwib2c_Num_ro_de_la_ligne__c.substring(3);
                INWIB2C_DEMANDE_DEGROUPAGE__c  degroupageClone=[select Id,InwiB2C_MotifAnnulation__c,InwiB2C_Commande_de_degroupage__c,InwiB2C_typeCommande__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where (InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_ndOperateur__c =: numeroDesignation ) and (InwiB2C_Statutdegroupage__c='ANN' OR InwiB2C_Statutdegroupage__c='RES') order by CreatedDate desc limit 1];
                /**B-16271 30/05/2024 ILA End */
                if(degroupageClone.InwiB2C_typeCommande__c != 'RS1'){
                    Map<String,Object> inputCloneDeg = new Map<String,Object>();
                    inputCloneDeg.put('InwiB2C_Commande_de_degroupage__c',degroupageClone.InwiB2C_Commande_de_degroupage__c);
                    inputCloneDeg.put('InwiB2C_Statutdegroupage__c','DAN');
                    /**B-16271 30/05/2024 ILA Start */
                    inputCloneDeg.put('InwiB2C_MotifAnnulation__c',degroupageClone.InwiB2C_MotifAnnulation__c);
                    /**B-23227 30/05/2024 ILA End */
                    inputCloneDeg.put('newCommande','false');
                    InwiB2C_ManageDegroupageOrder.cloneDemandeDeg(inputCloneDeg);
                }
                																																												

            }
            /**B-13901 ILA 24/01/2024 End */

            // B-27844 CH-Y 09/04/2025 Begin
                if(orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_ResiliationSuiteAnnulationPartage'){

                    vlocity_cmt__Subscription__c SubscriptionADSL = [select id,Inwib2c_Num_ro_de_la_ligne__c from vlocity_cmt__Subscription__c where Id =: subscriptionId];
                    String numeroDesignation = '0'+SubscriptionADSL.Inwib2c_Num_ro_de_la_ligne__c.substring(3);
                    /*B-32042 K_KA 01/09/2025 Start*/
                    inwiB2C_demande_partage__c  partageClone=[select Id,Motif_d_annulation__c,InwiB2C_Commande_de_partage__c FROM inwiB2C_demande_partage__c where (InwiB2C_NumeroDesignation__c =: numeroDesignation OR InwiB2C_nd_Attribut__c =: numeroDesignation) and (InwiB2C_Statut_demande__c='ANN' OR InwiB2C_Statut_demande__c='RES') order by CreatedDate desc limit 1];
                    /*B-32042 K_KA 01/09/2025 End*/
                        Map<String,Object> inputCloneDemandePartage = new Map<String,Object>();
                        inputCloneDemandePartage.put('InwiB2C_Commande_de_partage__c',partageClone.InwiB2C_Commande_de_partage__c);
                        inputCloneDemandePartage.put('InwiB2C_Statut_demande__c','DAN');
                        /*B-32042 K_KA 01/09/2025 Start*/
                        inputCloneDemandePartage.put('Motif_d_annulation__c',partageClone.Motif_d_annulation__c);
                        /*B-32042 K_KA 01/09/2025 End*/
                        inputCloneDemandePartage.put('newCommande','false');
            
                        InwiB2C_SharingRequestManagement.cloneSharingRequest(inputCloneDemandePartage);			
            // B-27844 CH-Y 09/04/2025 End
            }
             /**B-14273 ILA 19/02/2024 Start */
        }
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_Resiliation4G') {
            orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
            Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
            List < vlocity_cmt__Subscription__c > subscrRecords = new List < vlocity_cmt__Subscription__c > ();
            subscrRecords.add(new vlocity_cmt__Subscription__c(id = subscriptionList.vlocity_cmt__SubscriptionId__c,  inwiB2C_Statut__c = 'InwiB2C_Expired',inwiB2C_LegacyStatus__c = 'EXPIRED',  vlocity_cmt__Status__c = 'Expired'));
            update subscrRecords;
            //insert platform event generate smo changement carte sim
            InwiB2C_Migration2G4G__c Migration = [select Id from InwiB2C_Migration2G4G__c where InwiB2C_OrderResiliation4G__c =: ordId];
  
            List < InwiB2C_Migration2G4GEvt__e > eventChangeSim = new List < InwiB2C_Migration2G4GEvt__e > ();
            eventChangeSim.add(new InwiB2C_Migration2G4GEvt__e(inwiB2C_MigrationId__c = Migration.Id, inwiB2C_Step__c = 'Changement2G'));
            // Call method to publish events
            List < Database.SaveResult > results = EventBus.publish(eventChangeSim);
  
        }
        /*B-3144 DLE 23/11/2021 begin*/
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_Synchronisation_Assets' && canal == 'inwiB2C_USSD') {
            
          list<InwiB2C_Trace_API__c> traceapi = [select Id, InwiB2C_API_Name__c from InwiB2C_Trace_API__c where InwiB2C_OrderGenAssetId__c =: ordId];
        if (traceapi.size() > 0) {
            for (InwiB2C_Trace_API__c traceapiitem: traceapi) {
                if (traceapiitem.InwiB2C_API_Name__c == 'WS01' || traceapiitem.InwiB2C_API_Name__c == 'WS12') {
                    source = null;
                }
                if (traceapiitem.InwiB2C_API_Name__c == 'WS10') {
                    source = 'portaout';
                }
                if (traceapiitem.InwiB2C_API_Name__c == 'WS40') {
                    source = 'portaoutwin';
                }
                // YMH ajouter check iventory ExecuteDesconnect
                if (traceapiitem.InwiB2C_API_Name__c == 'WS95') {
                    source = 'resilSNVula';
                }
                Map < string, String > inputMap = new Map < String, String > ();
                Map < string, Object > outMap = new Map < String, Object > ();
                String procedureName = 'inwib2c_inwiB2C_CallExecuteTraitementSMOEvent';
                inputMap.put('TraceId', traceapiitem.Id);
                inputMap.put('Source', source);
                outMap = (Map < String, Object > ) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, inputMap, null);
                System.debug('IP Output CallExecuteTraitementSMOEvent: ' + outMap);
  
            }
          }
  
        }
        /*B-3144 DLE 23/11/2021 end*/
          /*B-10088 ILA 13/06/2023 START*/
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_DéconnecterService'|| orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_PortaOut' ||orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Cameleon_Prepaye' || (orderlist.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPost_Prepayé' && orderlist.inwib2c_DetailMotif__c == 'Résiliation suite demande client')){
            // Anuuler les demandes de migration cameleon
            orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
            String motif;
            if(orderlist.inwiB2C_TypeActeDeGestion__c == 'InwiB2C_DéconnecterService')
                motif='inwiB2C_Resiliation';
            else if(orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_PortaOut' )
                motif='inwiB2C_PortabiliteOut';
            else
                motif='inwiB2C_MigrationVersPrepaye';
            Asset subscriptionList = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
            List <InwiB2C_Demande_de_migration__c> demandes = [Select id,InwiB2C_Statut__c,InwiB2C_Motif_annulation__c from InwiB2C_Demande_de_migration__c where InwiB2C_Souscription__c =: subscriptionList.vlocity_cmt__SubscriptionId__c and InwiB2C_Statut__c != 'InwiB2C_Annule' and InwiB2C_Statut__c != 'InwiB2C_Termine'];
            if(demandes.size() != 0){
                demandes[0].InwiB2C_Statut__c = 'InwiB2C_Annule';
                demandes[0].InwiB2C_Motif_annulation__c = motif;
                update demandes[0];
            }


        }

        /*B-10088 ILA 13/06/2023 END*/
         /*B-4186 ILA 20/05/2022 Start*/
        /*
        if (orderlist.inwiB2C_TypeActeDeGestion__c == 'inwiB2C_ChangementOptionsAttributs') {
          List <Asset> addAsset = new List<Asset>();
          List <Asset> DeleteAsset = new List<Asset>();
          orderitem assetList1 = [select vlocity_cmt__AssetId__c from orderitem where id =: orditemId];
          Asset ParentAsset = [select vlocity_cmt__SubscriptionId__c from asset where id =: assetList1.vlocity_cmt__AssetId__c];
          List <Asset> childAsset = [Select id,vlocity_cmt__SubscriptionId__c,vlocity_cmt__RootItemId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__Action__c from Asset where vlocity_cmt__RootItemId__c =: ParentAsset.Id and vlocity_cmt__ParentItemId__c !=''];
          for (Asset assetTmp : childAsset){
              if(assetTmp.vlocity_cmt__Action__c == 'Add')
                  addAsset.add(new Asset(id = assetTmp.Id, vlocity_cmt__SubscriptionId__c = ParentAsset.vlocity_cmt__SubscriptionId__c));
              if(assetTmp.vlocity_cmt__Action__c == 'Disconnect')
                  DeleteAsset.add(new Asset(id = assetTmp.Id, vlocity_cmt__SubscriptionId__c = null));
          }
          update addAsset;
          update DeleteAsset;
      }*/
       /*B-4186 ILA 20/05/2022 end*/
  
  
        //update status order
        if(typeComm == 'inwiB2C_Acquisition' && ProductType != 'FTTH' || typeComm == 'inwiB2C_Migration' || typeComm == 'inwiB2C_Modification' || typeComm == 'inwiB2C_Acquisition' && ProductType != 'ADSL'){
          List < Order > orderrecord = new List < Order > ();
          orderrecord.add(new Order(id = ordId, inwiB2C_Statut__c = 'inwiB2C_Activation'));
          update orderrecord;
        }
  
  
    }
  }