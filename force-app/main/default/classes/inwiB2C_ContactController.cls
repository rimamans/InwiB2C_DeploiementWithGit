public with sharing class inwiB2C_ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsByAccountId(Id accountId) {
        return [
            SELECT Id, FirstName, LastName, InwiB2C_CIN__c, InwiB2C_Num_ro_de_contact__c 
            FROM Contact 
            WHERE AccountId = :accountId
        ];
    }
}