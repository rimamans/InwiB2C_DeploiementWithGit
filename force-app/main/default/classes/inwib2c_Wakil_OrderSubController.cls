public with sharing class inwib2c_Wakil_OrderSubController{
    @AuraEnabled(cacheable = true)
    public static List<InwiB2C_OrderSubscription__c> getAllOrders(String subscriptionId){
        return [SELECT Id, InwiB2C_Num_ro_de_la_commande__c, InwiB2C_Statut_Order__c, InwiB2C_Canal_Order__c, InwiB2C_Type_commande__c, InwiB2C_Type_acte_de_gestion__c, InwiB2C_Type_de_migration__c, inwiB2C_Order__r.InwiB2C_Type_Offer__c, inwiB2C_Order__c
                FROM InwiB2C_OrderSubscription__c
                WHERE inwiB2C_Subscription__c = :subscriptionId and (inwiB2C_Order__r.inwiB2C_Canal__c ='Wakil')];
    }

}