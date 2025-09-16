global with sharing class InwiB2C_DemandePartageVula implements vlocity_cmt.VlocityOpenInterface{

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
            
        Boolean result = true;
            
        try{
            
            if(methodName.equals('getDemandeById')){
                getDemandeById(inputMap, outMap, options);
                                                                         
            
            }                       
            
        } catch(Exception e){
                       
            result = false;
                    
        }
             
        return result;
                  
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
        InwiB2C_demande_partage__c demande = [select id, InwiB2C_Account__c,InwiB2C_Commande_de_partage__c,InwiB2C_LastName__c,InwiB2C_Installation_CPE__c,InwiB2C_Identifiant_CPE__c,InwiB2C_FirstName__c,InwiB2C_Commune__c,InwiB2C_Commentaire__c,InwiB2C_Level_Signal__c,InwiB2C_lineId__c,InwiB2C_Login__c,InwiB2C_Motif__c,InwiB2C_Nationalid__c,InwiB2C_nd_Attribut__c,InwiB2C_Numero_de_la_voie__c,InwiB2C_Numero_Partage__c,InwiB2C_Portabilite__c,InwiB2C_Order__c,InwiB2C_Operateur_Infrastructure__c,InwiB2C_Operateur_commercial__c,InwiB2C_NumeroDesignation__c,InwiB2C_numeroContact__c,InwiB2C_Province__c,inwiB2C_Quartier__c,InwiB2C_rendezvous__c,InwiB2C_Rio__c,InwiB2C_savPlus__c,InwiB2C_Sequence__c,InwiB2C_Site__c,InwiB2C_Statut_demande__c,InwiB2C_Voie__c,InwiB2C_Vitesse__c,InwiB2C_Type_d_operation__c,InwiB2C_Statut_ligne__c,Motif_d_annulation__c,Type_de_partage__c from inwiB2C_demande_partage__c
        WHERE Id = :idDemande LIMIT 1];
        Map<String , Object> data = new Map<String , Object>();
        data.put('statut',demande.InwiB2C_Statut_demande__c);
        data.put('account', demande.InwiB2C_Account__c);
        data.put('commandePartage', demande.InwiB2C_Commande_de_partage__c);
        data.put('lastName', demande.InwiB2C_LastName__c);
        data.put('installationCPE', demande.InwiB2C_Installation_CPE__c);
        data.put('identifiantCPE', demande.InwiB2C_Identifiant_CPE__c);
        data.put('firstName', demande.InwiB2C_FirstName__c);
        data.put('commune', demande.InwiB2C_Commune__c);
        data.put('commentaire', demande.InwiB2C_Commentaire__c);
        data.put('levelSignal', demande.InwiB2C_Level_Signal__c);
        data.put('lineId', demande.InwiB2C_lineId__c);
        data.put('login', demande.InwiB2C_Login__c);
        data.put('motif', demande.InwiB2C_Motif__c);
        data.put('nationalid', demande.InwiB2C_Nationalid__c);
        data.put('ndAttribut', demande.InwiB2C_nd_Attribut__c);
        data.put('numeroVoie', demande.InwiB2C_Numero_de_la_voie__c);
        data.put('numeroPartage', demande.InwiB2C_Numero_Partage__c);
        data.put('portabilite', demande.InwiB2C_Portabilite__c);
        data.put('order', demande.InwiB2C_Order__c);
        data.put('operateurInfrastructure', demande.InwiB2C_Operateur_Infrastructure__c);
        data.put('operateurCommercial', demande.InwiB2C_Operateur_commercial__c);
        data.put('numeroDesignation', demande.InwiB2C_NumeroDesignation__c);
        data.put('numeroContact', demande.InwiB2C_numeroContact__c);
        data.put('province', demande.InwiB2C_Province__c);
        data.put('quartier', demande.inwiB2C_Quartier__c);
        data.put('rendezvous', demande.InwiB2C_rendezvous__c);
        data.put('rio', demande.InwiB2C_Rio__c);
        data.put('savPlus', demande.InwiB2C_savPlus__c);
        data.put('sequence', demande.InwiB2C_Sequence__c);
        data.put('site', demande.InwiB2C_Site__c);
        data.put('statutDemande', demande.InwiB2C_Statut_demande__c);
        data.put('voie', demande.InwiB2C_Voie__c);
        data.put('vitesse', demande.InwiB2C_Vitesse__c);
        data.put('typeOperation', demande.InwiB2C_Type_d_operation__c);
        data.put('statutLigne', demande.InwiB2C_Statut_ligne__c);
        data.put('motifAnnulation', demande.Motif_d_annulation__c);
        data.put('typePartage', demande.Type_de_partage__c);

        outMap.put('resultdata',data);


    }
}