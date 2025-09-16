/**
 * @description       :
 * @author            :
 * @group             :
 * @last modified on  : 09-23-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
global class INWIB2CCreatePrePaidOrder implements vlocity_cmt.XOMOrchestrationInterfaces.IAutoTask{
    global void executeBatch(List<vlocity_cmt__OrchestrationItem__c> items){

        //String orchestrationItemId = items[0].id;
        // Récupération du premier élément d'orchestration de la liste
        vlocity_cmt__OrchestrationItem__c orchestrationItem = [select id, vlocity_cmt__OrderItemId__c, vlocity_cmt__FulfilmentRequestLineId__c
                                                               from vlocity_cmt__OrchestrationItem__c
                                                               where id = :items[0].id
                                                               LIMIT 1];
        Id oiId = orchestrationItem.vlocity_cmt__OrderItemId__c;
        if (oiId == null){
            // Si l'ID de l'élément de commande est nul, chercher une relation alternative
            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FulfilmentRequestLineDecompRelationship = [select id, vlocity_cmt__SourceOrderItemId__c
                                                                                                               from vlocity_cmt__FulfilmentRequestLineDecompRelationship__c
                                                                                                               where vlocity_cmt__DestinationFulfilmentRequestLineId__c = :orchestrationItem.vlocity_cmt__FulfilmentRequestLineId__c and vlocity_cmt__SourceOrderItemId__r.vlocity_cmt__ParentItemId__c = ''
                                                                                                               LIMIT 1];
            oiId = FulfilmentRequestLineDecompRelationship.vlocity_cmt__SourceOrderItemId__c;  // Mise à jour de oiId avec l'élément source trouvé
        }
        // Récupération des détails de l'élément de commande
        OrderItem orderItem = [SELECT id, vlocity_cmt__BillingAccountId__c, Order.inwiB2C_TypeDeMigration__c, Order.Account.inwiB2C_PS_BO_ID__c, vlocity_cmt__AssetId__c, OrderId, Order.inwiB2C_Canal__c
                               from OrderItem
                               where id = :oiId
                               LIMIT 1];
        // Récupération de l'asset associé
        Id AssetId = orderItem.vlocity_cmt__AssetId__c;
        Asset  asset = [select ID,vlocity_cmt__SubscriptionId__c,/*CHB CPPP 26/04/2024 Begin*/vlocity_cmt__JSONAttribute__c  /*CHB CPPP 26/04/2024 END*/from Asset where id =: AssetId LIMIT 1 ];

        // Y-MH 06-12-2025 B-26743 begin include Volte in mig PostPre
       List<orderItem> orderitemVolteList  = [SELECT Id FROM Orderitem  WHERE OrderId =:  orderItem.OrderId  AND Product2.ProductCode in('INWIB2C_MOB02_Volte','INWIB2C_OFFRING_VOLTE','INWIB2C_MOB01_Volte')   LIMIT 1];
        // Y-MH END 

        Id subscriptionId = asset.vlocity_cmt__SubscriptionId__c;
        ///*CHB CPPP 26/04/2024 Begin*/
        // Extraction du type de ligne depuis les attributs JSON de l'asset
        String typeLigne = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(asset.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_TYPE_LIGNE');
        /*CHB CPPP 26/04/2024 END*/
        // Extraction du type de commande de migration
        String typeSMO = orderItem.Order.inwiB2C_TypeDeMigration__c;
        // Récupération des détails de l'abonnement
        vlocity_cmt__Subscription__c subscription = [select Id, InwiB2C_Canal__c, InwiB2C_Distributeur__c, Inwib2c_ICC__c, Name, Inwib2c_code_puk__c, InwiB2C_IMSI__c, vlocity_cmt__AccountId__c, inwib2c_inst_prod_id__c
                                                     from vlocity_cmt__Subscription__c
                                                     where id = :subscriptionId
                                                     LIMIT 1];
        //inwiB2C_Nouveau
        //84001
        /*DLE B-6656 05/12/2022 begin*/
        //Get Infos SIM
        string icc = '';
        string imsi = '';
        string puck = '';
        string articlesim = '';
        String ki = '';
        /*ILA B-7672 31/01/2023 Begin */
        String ocsid = '';
        /*ILA B-7672 31/01/2023 End */
        // Récupération des informations SIM associées à l'ordre
        List<OrderItem> ordItemsim = [SELECT id, Product2.ProductCode, vlocity_cmt__JSONAttribute__c, vlocity_cmt__OneTimeTotal__c
                                      FROM OrderItem
                                      WHERE OrderId = :orderItem.OrderId and Product2.ProductCode in ('INWIB2C_OFFERING_SIM', 'INWIB2C_MOB01_OFFERING_SIM', 'INWIB2C_MOB02_OFFERING_SIM')];
        if (ordItemsim.size() > 0){
            for (OrderItem ordLineItem : ordItemsim){
                if (ordLineItem.Product2.ProductCode == 'INWIB2C_OFFERING_SIM' || ordLineItem.Product2.ProductCode == 'INWIB2C_MOB01_OFFERING_SIM' || ordLineItem.Product2.ProductCode == 'INWIB2C_MOB02_OFFERING_SIM')
                    icc = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_ICCID');
                imsi = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_IMSI');
                puck = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_SIM_PUK');
                articlesim = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_MODELE_CARTE_SIM');
                ki = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_KI');
                /*ILA B-7672 31/01/2023 Begin */
                ocsid = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_OCSID');
                /*ILA B-7672 31/01/2023 End */
            }
        }
        // Création d'un nouvel enregistrement de contrat
        /*DLE B-6656 05/12/2022 END*/
        inwiB2C_CreateContractBulk__c contract = new inwiB2C_CreateContractBulk__c();
        contract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Nouveau';
        ///*CHB CPPP 26/04/2024 Begin*/
        //contract.inwiB2C_ProfileId__c ='84001';
        contract.inwiB2C_ProfileId__c = typeLigne == 'CP' ? '20707' : '84001';
        ///*CHB CPPP 26/04/2024 END*/
        // Si un abonnement existe, mise à jour des détails du contrat
        if (subscription != null){
            /*DLE B-6656 05/12/2022 begin*/
            /*contract.inwiB2C_Canal__c = subscription.InwiB2C_Canal__c != null ? subscription.InwiB2C_Canal__c : ' ';
             contract.inwiB2C_Icc__c = subscription.Inwib2c_ICC__c != null ? subscription.Inwib2c_ICC__c : '';
             contract.inwiB2C_Puk__c = subscription.Inwib2c_code_puk__c != null ? subscription.Inwib2c_code_puk__c : '';
             contract.inwiB2C_imsi__c = subscription.InwiB2C_IMSI__c != null ? subscription.InwiB2C_IMSI__c : '';*/
            contract.inwiB2C_Icc__c = icc;
            contract.inwiB2C_Puk__c = puck;
            contract.inwiB2C_imsi__c = imsi;
            contract.inwiB2C_CodeArticle__c = articlesim;
            contract.inwiB2C_Ki__c = ki;
            /*ILA B-7672 31/01/2023 Begin */
            contract.inwiB2C_OcsId__c = ocsid;
            /*ILA B-7672 31/01/2023 End */
            /*DLE B-6656 05/12/2022 end*/
            contract.inwiB2C_Mdn__c = subscription.Name;
            if (orderItem.Order.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Post_Pré_suite_Remboursement' || orderItem.Order.inwiB2C_TypeDeMigration__c == 'InwiB2C_MigrationPost_Prepayé'/*ZME B-8942 12/04/2023 BEGIN*/ || orderItem.Order.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Cameleon_Prepaye'/*ZME B-8942 12/04/2023 END*/ || orderItem.Order.inwiB2C_TypeDeMigration__c == 'InwiB2C_Migration_Post_Pré_suite_SatisfaitRemboursé'/*ILA offre HV 08/08/2023 END*/){
                //contract.inwiB2C_RbtBoId__c =orderItem.Order.Account.inwiB2C_PS_BO_ID__c;
                /* CHB B-16073 28/05/2024 begin */
                // contract.inwiB2C_PS_BO_ID__c=orderItem.Order.Account.inwiB2C_PS_BO_ID__c;
                /* CHB B-16073 28/05/2024 end */
                /*DLE B-6656 05/12/2022 begin*/
                contract.inwiB2C_IdAccount__c = subscription.vlocity_cmt__AccountId__c;
                /*DLE B-7758 03/03/2023 begin*/
                /*contract.InwiB2C_CorrelationId__c=subscription.inwib2c_inst_prod_id__c ; */
                contract.InwiB2C_CorrelationId__c = orderItem.OrderId;
                /*DLE B-7758 03/03/2023 end*/
                contract.inwiB2C_Canal__c = 'inwiB2C_CRC';
                /*DLE B-6656 05/12/2022 End*/
            }
            // Y-MH 06-12-2025 begin Ajout Option Volte Mig PostPre
            if (!orderitemVolteList.isEmpty()) {

                contract.inwib2c_Volte__c = true ;

            } 
            // Y-MH END 

        }
        insert contract;
    }

}