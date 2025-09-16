@isTest
public class inwiB2C_RecuPaiementInvoiceTest {
@isTest(SeeAllData=true)
    static void inwiB2C_RecuPaiement(){
        
        
         Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
       // List<Order> OrderId = [SELECT id FROM Order where inwib2c_TypeDeLaCommande__c='inwiB2C_Migration' and inwiB2C_TypeDeMigration__c='InwiB2C_Migration_Post_Pré_suite_Remboursement' limit 1];
         Account acc = new Account(Name='classTestAccount');
        insert acc;
        system.debug('acc.Id'+acc.Id);
       
        inputMap.put('recordId',acc.Id);
                String accId=acc.Id;

        String invoiceID='123456789';
        PageReference pageRef = Page.inwiB2C_RecuPaiementInvoice;
        Test.setCurrentPage(pageRef);
        Test.StartTest(); 
        ApexPages.standardSetController sc = new ApexPages.standardSetController(Database.getQueryLocator([SELECT Id FROM account where id=:accId]));
        ApexPages.currentPage().getParameters().put('invoiceID', String.valueOf(invoiceID));
        inwiB2C_RecuPaiementInvoice testcall = new inwiB2C_RecuPaiementInvoice();
        Test.StopTest();
      }
    
}