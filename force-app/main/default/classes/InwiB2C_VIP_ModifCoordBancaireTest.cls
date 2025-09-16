@isTest 
public class InwiB2C_VIP_ModifCoordBancaireTest {

    @isTest (SeeAllData=true)   
    private static void testexecCallVIP(){
        Account accountId = new Account(Name='classTestAccount');
        insert accountId;
        InwiB2C_Demande__c newDemand = new InwiB2C_Demande__c ( InwiB2C_Status_BO__c ='Validé' , Mode_de_paiement__c = 'Prélèvement automatique (RIB)', InwiB2C_Account__c=accountId.Id);
       
        insert newDemand;
        Id id = accountId.Id;
       
        Set<Id> accountIds = new Set<Id>();
        accountIds.add(accountId.Id);
        List<Id> listIds = new List<Id>(accountIds);
        InwiB2C_VIP_ModifCoordBancaire.callVIP(listIds);
        
        InwiB2C_VIP_ModifCoordBancaire.execCallVIP(accountId.Id);
         InwiB2C_VIP_ModifCoordBancaire.execCallVIPIMX(accountId.Id);
         InwiB2C_VIP_ModifCoordBancaire.execCallVIPBSCS(accountId.Id);
    }
}