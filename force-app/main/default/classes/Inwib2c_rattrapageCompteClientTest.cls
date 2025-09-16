@isTest
public class Inwib2c_rattrapageCompteClientTest {
    @isTest (SeeAllData=true) 
    private static void testCallVIP(){
        Account accountId = new Account(Name='classTestAccount');
        insert accountId;
        Inwib2c_rattrapageCompteClient__c newJDD = new Inwib2c_rattrapageCompteClient__c ( inwiB2C_Status__c='Nouveau' , AccountId__c=accountId.Id);
        insert newJDD;
        Inwib2c_rattrapageCompteClient.execCallVIP();
        
    }

}