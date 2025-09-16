public with sharing class InwiB2C_OrderSubscriptionController {
    
    @AuraEnabled(cacheable=true)
    public static List<InwiB2C_OrderSubscription__c> getAllOrders(String subscriptionId) {
        return [SELECT InwiB2C_Num_ro_de_la_commande__c, 
                       InwiB2C_Statut_Order__c, 
                       InwiB2C_Canal_Order__c, 
                       InwiB2C_Type_commande__c, 
                       InwiB2C_Type_acte_de_gestion__c, 
                       InwiB2C_Type_de_migration__c, 
                       inwiB2C_Order__r.InwiB2C_Type_Offer__c,inwiB2C_Order__c
                FROM InwiB2C_OrderSubscription__c WHERE inwiB2C_Subscription__c = :subscriptionId
                and (inwiB2C_Order__r.InwiB2C_Type_Offer__c='idar duo' OR inwiB2C_Order__r.InwiB2C_Type_Offer__c='FTTH'
                 OR inwiB2C_Order__r.InwiB2C_Type_Offer__c='ADSL')];
    }
}