global with sharing class InwiB2C_CancelDemandePartage implements vlocity_cmt.VlocityOpenInterface{

    
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
     
            if (methodName == 'getDemandeById') {
                getDemandeById(inputMap, outMap, options);
                return true;
            } else if (methodName == 'CancelDemande') {
                CancelDemande(inputMap, outMap, options);
                return true;
            }

        return false; // Retourne false si aucun cas ne correspond
    }




   @AuraEnabled(cacheable=true)
   public static void CancelDemande(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

    String OrchPlanId = (String) inputMap.get('OrchPlanId');
    String orderId = (String) inputMap.get('orderId');
    String SubId = (String) inputMap.get('SubId');

    String demandeId = (String) inputMap.get('demandeId');
    String Commandepartage = (String) inputMap.get('CommPartage');
    String motifAnnulation = (String) inputMap.get('motifAnnulation');

    String requestId = (String) inputMap.get('requestId');
    String lineId = (String) inputMap.get('lineId');
    String operator = (String) inputMap.get('operator');
    if(operator=='ORANGE'){
        operator = 'oma';
    }
    String CanceldemandeVula = 'Inwi_InwiB2C_CancelVula';
    String CancelOrderAndOP = 'inwib2c_CancelOrderAndOP';

    Map<String, Object> Annulation = new Map<String, Object>();
    Map<String, Object> inputCC = new Map<String, Object>();
    Map<String, Object> optionsCC = new Map<String, Object>();

    Map<String, Object> inputCC_SH = new Map<String, Object>();

    Map<String, Object> inputCC_IP = new Map<String, Object>();
    Map<String, Object> outPutCC_IP = new Map<String, Object>();


    inputCC.put('lineId', lineId);
    inputCC.put('requestId',requestId);
    inputCC.put('operator',operator);

    inputCC_IP.put('order',orderId);
    inputCC_IP.put('OP',OrchPlanId);
    system.debug(inputCC);
    system.debug(inputCC_IP);

    // MGEN3741-FTTH_VULA_Recyclage_hors délai-rejet-max suspension : Meryem Yahya
    String statutDemande = [Select InwiB2C_Statut_demande__c from inwiB2C_demande_partage__c where Id =: demandeId limit 1].InwiB2C_Statut_demande__c ;
       if(statutDemande == 'Annulee_Delai_Reg' || statutDemande == 'Annulee_3_Susp'){
           
       inputCC_SH.put('InwiB2C_Statut_demande__c', 'ANN');
        inputCC_SH.put('Motif_d_annulation__c', motifAnnulation);
        inputCC_SH.put('InwiB2C_Commande_de_partage__c', Commandepartage);
        inputCC_SH.put('newCommande', 'false');

        system.debug(inputCC_SH);
        String IdDemandeANN  = InwiB2C_SharingRequestManagement.cloneSharingRequest(inputCC_SH);
        system.debug(IdDemandeANN);
		
        outPutCC_IP = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(CancelOrderAndOP, inputCC_IP, optionsCC);
        system.debug(outPutCC_IP);

        InwiB2C_ResiliationSuiteAnnulationPartag__e ResiliationSuiteAnnulationEvent = new InwiB2C_ResiliationSuiteAnnulationPartag__e();

        ResiliationSuiteAnnulationEvent.inwiB2C_Subscription__c = SubId;

        Database.SaveResult results = EventBus.publish(ResiliationSuiteAnnulationEvent);
        system.debug(results);
        
        outMap.put('Annulation', Annulation);
        outMap.put('IdDemandeANN', IdDemandeANN );
        system.debug(outMap);
       }
       else{
           
    Annulation = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(CanceldemandeVula, inputCC, optionsCC);
    outMap.put('Annulation',Annulation);
    system.debug(outMap);
    system.debug(Annulation);
    if(Annulation.get('AcqIAM')=='OK')
    {inputCC_SH.put('InwiB2C_Statut_demande__c', 'ANN');
        inputCC_SH.put('Motif_d_annulation__c', motifAnnulation);
        inputCC_SH.put('InwiB2C_Commande_de_partage__c', Commandepartage);
        inputCC_SH.put('newCommande', 'false');

        system.debug(inputCC_SH);
        String IdDemandeANN  = InwiB2C_SharingRequestManagement.cloneSharingRequest(inputCC_SH);
        system.debug(IdDemandeANN);

        outPutCC_IP = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(CancelOrderAndOP, inputCC_IP, optionsCC);
        system.debug(outPutCC_IP);

        InwiB2C_ResiliationSuiteAnnulationPartag__e ResiliationSuiteAnnulationEvent = new InwiB2C_ResiliationSuiteAnnulationPartag__e();

        ResiliationSuiteAnnulationEvent.inwiB2C_Subscription__c = SubId;

        Database.SaveResult results = EventBus.publish(ResiliationSuiteAnnulationEvent);
        system.debug(results);
        
        outMap.put('Annulation', Annulation);
        outMap.put('IdDemandeANN', IdDemandeANN );
        system.debug(outMap);}
       // MGEN3741-FTTH_VULA_Recyclage_hors délai-rejet-max suspension : Meryem Yahya
       	}
       }
   @AuraEnabled(cacheable=true)
   public static void getDemandeById(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
    System.debug(JSON.serialize(inputMap));



        // String idDemande =  (String) inputMap.get('demandeId');
            String idDemande;
        try{

            idDemande = String.valueOf((Long) inputMap.get('demandeId'));

        }catch (Exception e) {
            idDemande = (String) inputMap.get('demandeId');
        }
        System.debug(idDemande);
        ////R-SL Ticket B-29934 19/06/2025 start
        InwiB2C_demande_partage__c demande = [select id,InwiB2C_Subscription__c,InwiB2C_Account__r.Name,InwiB2C_Compteur_recyclage__c, InwiB2C_Account__c,InwiB2C_Commande_de_partage__c,InwiB2C_LastName__c,InwiB2C_Installation_CPE__c,InwiB2C_Identifiant_CPE__c,InwiB2C_FirstName__c,InwiB2C_Commune__c,InwiB2C_Commentaire__c,InwiB2C_Level_Signal__c,InwiB2C_lineId__c,InwiB2C_Login__c,InwiB2C_Motif__c,InwiB2C_Nationalid__c,InwiB2C_nd_Attribut__c,InwiB2C_Numero_de_la_voie__c,InwiB2C_Numero_Partage__c,InwiB2C_Portabilite__c,InwiB2C_Order__c,InwiB2C_Operateur_Infrastructure__c,InwiB2C_Operateur_commercial__c,InwiB2C_NumeroDesignation__c,InwiB2C_numeroContact__c,InwiB2C_Province__c,inwiB2C_Quartier__c,InwiB2C_rendezvous__c,InwiB2C_Rio__c,InwiB2C_savPlus__c,InwiB2C_Sequence__c,InwiB2C_Site__c,InwiB2C_Statut_demande__c,InwiB2C_Voie__c,InwiB2C_Vitesse__c,InwiB2C_Type_d_operation__c,InwiB2C_Statut_ligne__c,Motif_d_annulation__c,Type_de_partage__c, InwiB2C_Order__r.OrderNumber, InwiB2C_Site__r.Name, LastModifiedBy.Name, CreatedBy.Name, InwiB2C_Order__r.vlocity_cmt__OrchestrationPlanId__c,InwiB2C_Date_de_mise_en_service__c   from inwiB2C_demande_partage__c
        WHERE Id = :idDemande LIMIT 1];
        ////R-SL Ticket B-29934 19/06/2025 end

        

        System.debug(demande);
        outMap.put('resultdata',demande);
        

    }
}