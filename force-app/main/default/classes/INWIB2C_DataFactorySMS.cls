@isTest
public class INWIB2C_DataFactorySMS {
    Public static Case createCasewithSubscription(){
        vlocity_cmt__Subscription__c ligne = new vlocity_cmt__Subscription__c(vlocity_cmt__SubscriptionNumber__c='212658498760',
                                                                              Inwib2c_Num_ro_de_la_ligne__c='212658498760');
        insert ligne;
        Case req = new Case(vlocity_cmt__SubscriptionId__c=ligne.Id);
        insert req;
        return req;
    }
}