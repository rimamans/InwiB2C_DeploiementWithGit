@isTest
public class InwiB2C_DemandeResilControllerTest {
@isTest(SeeAllData=true)
    static void InwiB2C_DemandeResilControllerTest(){
        /*
        lastname=Apexpages.currentPage().getParameters().get('lastname');
    firstname= Apexpages.currentPage().getParameters().get('firstname');
    raisonsociale= Apexpages.currentPage().getParameters().get('raisonsociale');
    numligne=Apexpages.currentPage().getParameters().get('numligne');
    typeidentite=Apexpages.currentPage().getParameters().get('typeidentite');
    offre = Apexpages.currentPage().getParameters().get('offre');
    numcontact = Apexpages.currentPage().getParameters().get('numcontact'); 
    datedesignature = Apexpages.currentPage().getParameters().get('datedesignature');*/

    PageReference pageRefForm = Page.InwiB2C_ForumalaireResiliation;
    Test.setCurrentPage(pageRefForm);
    Test.StartTest(); 
    ApexPages.currentPage().getParameters().put('lastname', String.valueOf('AB'));
    ApexPages.currentPage().getParameters().put('firstname', String.valueOf('KH'));
    ApexPages.currentPage().getParameters().put('numligne', String.valueOf('121231233'));
    ApexPages.currentPage().getParameters().put('datedesignature', String.valueOf('12/11/2022'));
    InwiB2C_DemandeResil_Form_Controller testcall = new InwiB2C_DemandeResil_Form_Controller();
    Test.StopTest();

    }
}