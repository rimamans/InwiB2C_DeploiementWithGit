/** 
 * description: classe apex pour le parcours inwiB2C_RecyclageCommandeFTTH pour la partie details afin d'afficher les informations de la demande
 * author: slimani rosa 16/02/2025
 
*/


global with sharing class inwib2c_DemandeRecyclageInfo implements vlocity_cmt.VlocityOpenInterface2 {
    global static Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
       // Vérifie le nom de la méthode demandée et appelle la méthode correspondante
            if(methodName.equals('getDemandeById')){
                getDemandeById(inputMap, outMap, options);
                                                                                                                                                              
            }
           
            
             
        return true;
                  
   }

   
   @AuraEnabled(cacheable=true)
    // récupérer les informations de la demande à partir de son ID
   public static void getDemandeById(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
    System.debug(JSON.serialize(inputMap));
            String idDemande;
        try{
             //récupérer l'ID de la demande
            idDemande = String.valueOf((Long) inputMap.get('demandeId'));

        }catch (Exception e) {
            idDemande = (String) inputMap.get('demandeId');
        }
        //recuperer les enregistrements a partir de l'objet InwiB2C_Demande_de_recyclage_FTTH__c
        InwiB2C_Demande_de_recyclage_FTTH__c demande = [ select InwiB2C_work_order_Id__c,InwiB2C_Workordertask_Id__c,InwiB2C_client__r.Name ,InwiB2C_Date_debut_planifiee__c, InwiB2C_client__r.Inwib2c_CIN__c,InwiB2C_client__r.InwiB2C_Num_ro_de_contact__c,InwiB2C_commande__r.OrderNumber,
        InwiB2C_Compteur_de_rep_chage__c,InwiB2C_Motif_d_chec_de_raccordement__c,InwiB2C_ND__c,InwiB2C_Statut__c,CreatedById,LastModifiedById, InwiB2C_Id_Rendez_vous__r.inwiB2C_Date_RDV__c, LastModifiedBy.Name,CreatedBy.name
        FROM InwiB2C_Demande_de_recyclage_FTTH__c  WHERE Id = :idDemande LIMIT 1];

        // Ajoute le résultat de la requête à la map de sortie
        outMap.put('result',demande);


    }

}