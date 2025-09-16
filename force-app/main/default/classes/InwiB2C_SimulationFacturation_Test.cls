@isTest
public class InwiB2C_SimulationFacturation_Test {

    @isTest 
    static void testControllerWithValidOrder() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Order ord = new Order(
            AccountId = acc.Id,
            Status = 'Draft',
            EffectiveDate = System.today(),
            InwiB2C_Offre__c = 'Test'
        );
        insert ord;
        
        PageReference pageRef = new PageReference('/apex/TestPage');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('orderid', ord.Id);
        
        Test.startTest();
            InwiB2C_SimulationFacturation_Controller controller = new InwiB2C_SimulationFacturation_Controller();
        Test.stopTest();
    }
    
    @isTest 
    static void testControllerWithoutOrderId() {
        PageReference pageRef = new PageReference('/apex/TestPage');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().clear();
        
        Test.startTest();
            InwiB2C_SimulationFacturation_Controller controller = new InwiB2C_SimulationFacturation_Controller();
        Test.stopTest();
    }
    
    @isTest 
    static void testCalculatePaymentDeadline() {
        Date startDate = Date.newInstance(2023, 1, 31);
        
        Test.startTest();
            Date calculatedDeadline = InwiB2C_SimulationFacturation_Controller.calculatePaymentDeadline(startDate);
        Test.stopTest();
    }
    
    @isTest 
    static void testControllerWithInvalidOrderId() {
        PageReference pageRef = new PageReference('/apex/TestPage');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('orderid', 'invalidOrderId');
        
        Test.startTest();
            InwiB2C_SimulationFacturation_Controller controller = new InwiB2C_SimulationFacturation_Controller();
        Test.stopTest();
    }
}