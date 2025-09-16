@isTest
public class InwiB2C_ResiliationPrePayeControllerTest {
    @isTest(SeeAllData=true)
    static void InwiB2C_ResiliationPrePayeControllerTest() {

    PageReference pageRefForm = Page.InwiB2C_FormulaireResiliationPrePaye;
    Test.setCurrentPage(pageRefForm);
    Test.StartTest(); 

    ApexPages.currentPage().getParameters().put('lastname', String.valueOf('AB'));
    ApexPages.currentPage().getParameters().put('firstname', String.valueOf('KH'));
    ApexPages.currentPage().getParameters().put('numligne', String.valueOf('121231233'));
    ApexPages.currentPage().getParameters().put('datedesignature', String.valueOf('12/11/2022'));

     ApexPages.currentPage().getParameters().put('numcontact', String.valueOf('12344'));
    ApexPages.currentPage().getParameters().put('offre', String.valueOf('4G illimité'));
    ApexPages.currentPage().getParameters().put('email', String.valueOf('121231233@gmail.com'));
    ApexPages.currentPage().getParameters().put('numPieceIdentite', String.valueOf('2345643765'));
    ApexPages.currentPage().getParameters().put('typeidentite', String.valueOf('CIN'));
    InwiB2C_ResiliationPrePaye_Controller testcall = new InwiB2C_ResiliationPrePaye_Controller();
    Test.StopTest();

    }
}