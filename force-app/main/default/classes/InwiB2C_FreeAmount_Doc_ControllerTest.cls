@isTest
global class InwiB2C_FreeAmount_Doc_ControllerTest {
  
    @isTest
public static void CallConstructorTest() {
           
     
    PageReference pageRef = Page.InwiB2C_FreeAmount_Doc;
    Test.setCurrentPage(pageRef);
    Test.startTest();
    ApexPages.currentPage().getParameters().put('NumTransaction','123456');
    ApexPages.currentPage().getParameters().put('CIN','B8596');
    ApexPages.currentPage().getParameters().put('Nom','Test');
    ApexPages.currentPage().getParameters().put('Prenom','Test');
    ApexPages.currentPage().getParameters().put('CodePointDeVente','CPD01');
    ApexPages.currentPage().getParameters().put('CodeAgent','CPD01');
    ApexPages.currentPage().getParameters().put('BillingAccount','SF123456');
    ApexPages.currentPage().getParameters().put('ModeDePaiement','Espece');
    ApexPages.currentPage().getParameters().put('TotalAmount','200');
    ApexPages.currentPage().getParameters().put('ReferenceDePaiement','8596123456');
    ApexPages.currentPage().getParameters().put('NumeroDeTransaction','8596123456');
    ApexPages.currentPage().getParameters().put('Quartier','Elqods');
    ApexPages.currentPage().getParameters().put('Ville','Casa');
    ApexPages.currentPage().getParameters().put('Pays','Maroc');
    //Test.startTest();
    InwiB2C_FreeAmount_Doc_Controller testcall = new InwiB2C_FreeAmount_Doc_Controller();
    
           Test.stopTest();
    
 }
   
}