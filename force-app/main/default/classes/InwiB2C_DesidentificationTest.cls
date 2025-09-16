@isTest 
public with sharing class InwiB2C_DesidentificationTest {
    @isTest 
    static void validateDesidentificationclass() {
        InwiB2C_DemandeDesidentification__c DD = new InwiB2C_DemandeDesidentification__c(Inwib2c_Status__c='Nouveau');
        insert DD;
        system.debug(DD);
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Account a=new Account(RecordTypeId = devRecordTypeId,Name='test');
        insert a;
        Contract c=new Contract	(AccountId=a.Id);
        insert c;
        Contract c1=new Contract(AccountId=a.Id,InwiB2C_statut_contrat__c='Initialise');
        insert c1;
		InwiB2C_Subscription_contract__c subcontract1= new InwiB2C_Subscription_contract__c(InwiB2C_Contract__c=c.Id);
        insert subcontract1;
        
        InwiB2C_Subscription_contract__c subcontract2= new InwiB2C_Subscription_contract__c(InwiB2C_Contract__c=c1.Id);
        insert subcontract2;
        vlocity_cmt__Subscription__c Sub1=new vlocity_cmt__Subscription__c(Name='test',vlocity_cmt__AccountId__c=a.id,vlocity_cmt__SubscriptionNumber__c='212111111111',InwiB2C_MDN__c='212111111111',InwiB2C_Contract__c=c.id,InwiB2C_Date_d_activation__c=date.Today());
        insert Sub1;
        vlocity_cmt__Subscription__c Sub2=new vlocity_cmt__Subscription__c(Name='test',vlocity_cmt__SubscriptionNumber__c='212222222222',InwiB2C_MDN__c='212222222222',InwiB2C_Contract__c=c.id,InwiB2C_Date_d_activation__c=date.Today()  );
        insert Sub2;
        
        InwiB2C_SubscriptionDesidentification__c SD= new InwiB2C_SubscriptionDesidentification__c(InwiB2C_ContractId__c=c.Id,InwiB2C_Demande_Desidentification_Id__c=DD.Id,InwiB2C_SouscriptionId__c=Sub1.Id,InwiB2C_MDN__c='212111111111');
        InwiB2C_SubscriptionDesidentification__c SD2= new InwiB2C_SubscriptionDesidentification__c(InwiB2C_ContractId__c=c1.Id,InwiB2C_Demande_Desidentification_Id__c=DD.Id,InwiB2C_SouscriptionId__c=Sub2.Id,InwiB2C_MDN__c='212111122111',InwiB2C_isSelected__c=false);
    	SD.InwiB2C_Motif_de_refus__c = null;
        SD2.InwiB2C_Motif_de_refus__c = null;
        insert SD;
        insert SD2;
        system.debug(SD);
        InwiB2C_Desidentification cla=new InwiB2C_Desidentification();
        List<Id> list1 = new List<Id>();
        list1.add(DD.Id);
        
        system.debug(list1);
        InwiB2C_Desidentification.Traitement(list1);
        system.debug(c1.InwiB2C_statut_contrat__c);
        boolean assert=(c1.InwiB2C_statut_contrat__c =='Initialise') ? true : false;
        system.debug(assert);
        System.assertEquals(true, assert);
  
    }
}