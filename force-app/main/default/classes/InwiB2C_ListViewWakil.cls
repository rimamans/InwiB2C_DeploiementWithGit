public with sharing class InwiB2C_ListViewWakil {
    @AuraEnabled(cacheable=true)
    public static List<Order> getOrdersForUserQueue() {
        // Vérification des autorisations d'accès
        if (!Schema.sObjectType.Order.isAccessible()) {
            throw new AuraHandledException('Vous n\'avez pas les autorisations nécessaires pour accéder aux commandes.');
        }

        return [
            SELECT Id, OrderNumber, Name, inwiB2C_Animateur_D2D__r.Name, CreatedDate,
                   inwiB2C_Statut__c, inwib2c_Partenaire__r.inwib2c_CodePartenaire__c, inwib2c_TypeDeLaCommande__c, 
                   InwiB2C_Type_Offer__c, InwiB2C_Offre__c, AccountId, Account.Name, TotalAmount, inwiB2C_Canal__c
            FROM Order
            WHERE inwiB2C_Canal__c='Wakil'
            ORDER BY CreatedDate DESC
            LIMIT 2000
        ];
    }
}