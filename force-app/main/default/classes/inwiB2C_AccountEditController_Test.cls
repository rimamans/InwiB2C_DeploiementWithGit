/*ZME*/
@isTest
public class inwiB2C_AccountEditController_Test {
    public static testMethod void testAccountController() {
        Test.StartTest(); 
        Account accPartner = new Account();
        accPartner.Name='Test Partner';
        accPartner.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partenaire').getRecordTypeId();     
        insert accPartner;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(accPartner);
        inwiB2C_AccountEditController testAccPlan = new inwiB2C_AccountEditController(sc);
        
        PageReference pageRefPartner;
        pageRefPartner = new PageReference('/' + accPartner.id +'/e'); 
        pageRefPartner.getParameters().put('nooverride', '1');
        pageRefPartner.getParameters().put('retURL', ApexPages.currentPage().getParameters().get('retURL'));
        pageRefPartner.getParameters().put('id', accPartner.id);
        Test.setCurrentPage(pageRefPartner);
        testAccPlan.getRedir();
        
        Account accConsumer = new Account();
        accConsumer.Name='Test Consumer';
        accConsumer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();     
        insert accConsumer;
        
        PageReference pageRefConsumer = Page.inwiB2C_AccountEditConsumer; 
        pageRefConsumer.getParameters().put('id', accConsumer.id);
        Test.setCurrentPage(pageRefConsumer);
        testAccPlan.getRedir();
        Test.StopTest();
    }
}