@isTest
public class InwiB2C_FormRembTest {

    @isTest
    static void  FormRemb(){
         Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
         Account acc = new Account(Name='classTestAccount');
        insert acc;
       order neworder = new Order ( inwiB2C_Statut__c ='inwiB2C_EnCours', Status = 'Draft' ,EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', AccountId =acc.Id);
        insert neworder;
        system.debug('neworder.Id'+neworder.Id);
        inputMap.put('recordId',neworder.Id);
                String OrderId=neworder.Id;
        
        String transactionCode='123456789';
        PageReference pageRef1 = Page.InwiB2C_FormulairedeRemboursement;
        PageReference pageRef2 = Page.InwiB2C_Recu_remboursement;
        Test.setCurrentPage(pageRef1);
        Test.setCurrentPage(pageRef2);
        
        Test.StartTest(); 
        ApexPages.standardSetController sc = new ApexPages.standardSetController(Database.getQueryLocator([SELECT Id FROM Order where id=:OrderId]));
        ApexPages.currentPage().getParameters().put('transactionCode', String.valueOf('123'));
        InwiB2C_FormRemb testcall = new InwiB2C_FormRemb();
        Test.StopTest();
      }

}