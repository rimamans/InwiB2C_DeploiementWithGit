@isTest
public class InwiB2C_VIP_ModifFicheClientTest {
@isTest (SeeAllData=true)   
    private static void testexecCallVIP(){
        Account accountId = new Account(Name='classTestAccount');
        insert accountId;
        InwiB2C_Demande__c newDemand = new InwiB2C_Demande__c ( InwiB2C_Statut__c ='Validé' , FirstName__c = 'FirstTest',LastName__c='LastTest', InwiB2C_Account__c=accountId.Id);
       
        insert newDemand;
        InwiB2C_VIP_ModifFicheClient.execCallVIP(accountId.Id);
        InwiB2C_VIP_ModifFicheClient.execCallVIPIMX(accountId.Id);
        InwiB2C_VIP_ModifFicheClient.updateName(accountId.Id);
    }
   
    
}