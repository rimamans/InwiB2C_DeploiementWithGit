public with sharing class InwiCGC_AMStatsController {
    @AuraEnabled(cacheable=true)
    public static List<Schema.RetailStore> getRetailStores() {
        return [
            SELECT Id, Name, CreatedDate, CreatedBy.Name, inwiB2C_MDN__c, inwiCGC_TypeActivite__c, 
                   inwiB2C_MDN2__c, inwib2c_IsDealer__c, inwib2c_Segment__c, inwiCGC_Dealer_Identifier__c, 
                   inwiCGC_Distributeur_App__c, inwiCGC_Region_AC__c, inwiCGC_Flag__c, 
                   inwiCGC_VilleAM__c, PrimaryContact.FirstName, PrimaryContact.LastName, 
                   PrimaryContact.Phone, PrimaryContact.OtherPhone
            FROM RetailStore
        ];
    }
}