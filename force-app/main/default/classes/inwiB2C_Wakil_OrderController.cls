public with sharing class inwiB2C_Wakil_OrderController {
    @AuraEnabled(cacheable=true)
    public static List<Order> getOrderList(String accountId) {
        return [
            SELECT Id, InwiB2C_Offre__c, InwiB2C_Type_Offer__c, vlocity_cmt__MasterOrderName__c, OrderNumber, Status, EffectiveDate, inwib2c_TypeDeLaCommande__c, inwib2c_ReferenceLM__c, inwiB2C_TypeActeDeGestion__c, inwiB2C_TypeDeMigration__c, CreatedBy.Name
            FROM Order
            WHERE AccountId = :accountId
            AND inwiB2C_Canal__c ='Wakil' 
        ];
    }
}