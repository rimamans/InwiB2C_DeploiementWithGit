@isTest
public class InwiB2C_GenerationRecuE_RechargeTest {
@isTest(SeeAllData=true)
    static void validateStandardController3(){
        
        List<vlocity_cmt__Subscription__c> SubId = [SELECT id FROM vlocity_cmt__Subscription__c  limit 1];
        String montant='20';
        PageReference pageRef = Page.inwiB2C_recuPaiementE_recharge;
        Test.setCurrentPage(pageRef);
        Test.StartTest(); 
        ApexPages.standardSetController sc = new ApexPages.standardSetController(Database.getQueryLocator([SELECT Id FROM vlocity_cmt__Subscription__c limit 2]));
        ApexPages.currentPage().getParameters().put('montant', String.valueOf('10'));
        ApexPages.currentPage().getParameters().put('subscriptionid', String.valueOf(SubId[0].Id));
        ApexPages.currentPage().getParameters().put('transactionCode', String.valueOf('123'));
        ApexPages.currentPage().getParameters().put('typePay', String.valueOf('En espéce'));
        InwiB2C_GenerationRecuPaiementE_Recharge testcall = new InwiB2C_GenerationRecuPaiementE_Recharge();
        Test.StopTest();
      }
    
}