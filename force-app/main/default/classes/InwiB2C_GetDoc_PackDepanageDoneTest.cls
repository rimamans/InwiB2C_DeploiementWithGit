@isTest
public class InwiB2C_GetDoc_PackDepanageDoneTest {
@isTest(SeeAllData=true)
    static void InwiB2C_PackDepanageDone(){
        
        
         Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
       // List<Order> OrderId = [SELECT id FROM Order where inwib2c_TypeDeLaCommande__c='inwiB2C_Migration' and inwiB2C_TypeDeMigration__c='InwiB2C_Migration_Post_Pré_suite_Remboursement' limit 1];
         Account acc = new Account(Name='classTestAccount');
        insert acc;
        system.debug('acc.Id'+acc.Id);
        order neworder = new Order ( inwiB2C_Statut__c ='inwiB2C_EnCours', Status = 'Draft' ,EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration',inwiB2C_TypeDeMigration__c='InwiB2C_Migration_Post_Pré_suite_Remboursement', AccountId =acc.Id);
        insert neworder;
        system.debug('neworder.Id'+neworder.Id);
        inputMap.put('recordId',neworder.Id);
                String OrderId=neworder.Id;

        String transactionCode='123456789';
        PageReference pageRef = Page.InwiB2C_ConventionDepanage;
        Test.setCurrentPage(pageRef);
        Test.StartTest(); 
        ApexPages.standardSetController sc = new ApexPages.standardSetController(Database.getQueryLocator([SELECT Id FROM Order where id=:OrderId]));
         ApexPages.currentPage().getParameters().put('OrderId', String.valueOf(neworder.Id));
        InwiB2C_GetDoc_PackDepanageDone testcall = new InwiB2C_GetDoc_PackDepanageDone();
        Test.StopTest();
      }
    
}