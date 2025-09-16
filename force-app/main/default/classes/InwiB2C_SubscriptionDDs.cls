public with sharing class InwiB2C_SubscriptionDDs {
    @AuraEnabled(cacheable=true)
    public static List<INWIB2C_DEMANDE_DEGROUPAGE__c> getSubscriptionDDs(String Id) {
        List<inwiB2C_OrderSubscription__c> orderSubs = [ SELECT inwiB2C_Order__c FROM inwiB2C_OrderSubscription__c WHERE inwiB2C_Subscription__c  = :Id ];
        List<INWIB2C_DEMANDE_DEGROUPAGE__c> DDs = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
        
        for (inwiB2C_OrderSubscription__c orderSub : orderSubs) {
            // B-18616 M-Dj 01/11/24 recuperer le champ InwiB2C_ORDER_DEGROUPAGE_NUM__c au lieu du orderNumber
            List<INWIB2C_DEMANDE_DEGROUPAGE__c> orderDDs = [ select Id, Name, InwiB2C_ORDER_DEGROUPAGE_NUM__c, InwiB2C_SEQ_NUM__c, InwiB2C_Statutdegroupage__c  from INWIB2C_DEMANDE_DEGROUPAGE__c where InwiB2C_Order__c = : orderSub.inwiB2C_Order__c ];
            // B-18616 M-Dj 01/11/24 recuperer le champ InwiB2C_ORDER_DEGROUPAGE_NUM__c au lieu du orderNumber
            for (INWIB2C_DEMANDE_DEGROUPAGE__c DD : orderDDs) {
                DDs.add(DD);
            }
        }
        System.debug(DDs);
        return DDs;
    }
    // B-18616 M-Dj 07/11/24 recuperer les demande degroupage depuis les account et les orders begin
    @AuraEnabled(cacheable=true)
    public static List<INWIB2C_DEMANDE_DEGROUPAGE__c> getOrderDDs(String Id) {
        List<INWIB2C_DEMANDE_DEGROUPAGE__c> orderDDs = [ select Id, Name, InwiB2C_ORDER_DEGROUPAGE_NUM__c, InwiB2C_SEQ_NUM__c, InwiB2C_Statutdegroupage__c  from INWIB2C_DEMANDE_DEGROUPAGE__c where InwiB2C_Order__c = :Id ];
        return orderDDs;
    }
    @AuraEnabled(cacheable=true) 
    public static List<INWIB2C_DEMANDE_DEGROUPAGE__c> getAccountDDs(String Id) {
        List<INWIB2C_DEMANDE_DEGROUPAGE__c> accountDDs = [ select Id, Name, InwiB2C_ORDER_DEGROUPAGE_NUM__c, InwiB2C_SEQ_NUM__c, InwiB2C_Statutdegroupage__c  from INWIB2C_DEMANDE_DEGROUPAGE__c where InwiB2C_Account__c = :Id ];
        return accountDDs;
    }
    // B-18616 M-Dj 07/11/24 recuperer les demande degroupage depuis les account et les orders end
}