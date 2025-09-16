/** 
 * description: Cette classe permet de récupérer les demandes de recyclage FTTH
 * author : khaoula kanboua
 * last modify by : Khaoula kanboua  14/02/2025
 
*/
/*K-KA begin */

public with sharing class InwiB2C_DisplayDemandeRecyclage {
   
    //Récupère toutes les demandes de recyclage FTTH associées à une commande donnée
    @AuraEnabled(cacheable=true)
    public static List<InwiB2C_Demande_de_recyclage_FTTH__c> getOrderDRs(String Id) {
        // Requête pour récupérer les demandes de recyclage liées à une commande spécifique
        List<InwiB2C_Demande_de_recyclage_FTTH__c> orderDRs = [ select Id,Name, InwiB2C_ND__c, InwiB2C_work_order_Id__c, InwiB2C_Workordertask_Id__c, InwiB2C_Statut__c,InwiB2C_Motif_d_chec_de_raccordement__c,InwiB2C_Date_debut_planifiee__c,InwiB2C_Compteur_de_rep_chage__c,InwiB2C_client__r.Name,InwiB2C_Id_Rendez_vous__c  from InwiB2C_Demande_de_recyclage_FTTH__c  where InwiB2C_commande__c = :Id ];
        return orderDRs;
    }
}
/*K-KA End*/