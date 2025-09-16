/** 
 * description: Cette classe permet de récupérer les demandes de partage FTTH
 * author : khaoula kanboua
 * last modify by : Khaoula kanboua  14/05/2025
 
*/
/*K-KA B-28661 begin */

public with sharing class inwiB2C_DisplayDemandePartageFTTH{
   
    //Récupère toutes les demandes de partage FTTH associées à une commande donnée
    @AuraEnabled(cacheable=true)
    public static List<inwiB2C_demande_partage__c> getOrderDPs(String Id) {
        // Requête pour récupérer les demandes de partage liées à une commande spécifique
        List<inwiB2C_demande_partage__c> orderDPs = [ SELECT Id,Name,InwiB2C_Order__r.OrderNumber, InwiB2C_Numero_Partage__c, InwiB2C_Statut_demande__c  from inwiB2C_demande_partage__c  where InwiB2C_Order__c = :Id ];
        return orderDPs;
    }
}
/*K-KA End*/