@isTest
public class InwiB2C_Invoices_Doc_ControllerTest {

        @isTest
public static void CallConstructorTestInvoice() {
       
     Map<String, Object> root = new  Map<String, Object>();
     Map<String, Object> invoice = new  Map<String, Object>();
     List<Object> invoicesList = new List<Object>();
    //new Invoice
    invoice.put('Id','F124785');
    invoice.put('InvoiceDate','12/07/2022');
    invoice.put('invoicePaymentDueDate','30/07/2022');
    invoice.put('invoiceAmount','100');
    invoicesList.add(invoice);
    
    root.put('CIN','B1452');
    root.put('Nom','Test');
    root.put('Prenom','Test');
    root.put('CodePointDeVente','CP01');
    root.put('CodeAgent','CP01');
    root.put('BillingAccount','SF0001');
    root.put('ModeDePaiement','Espece');
    root.put('TotalAmount','200');
    root.put('FraisTimbre','2');
    root.put('NumTransaction','252964785');
    root.put('NumeroDeRecu','252964785');
    root.put('data',invoicesList);
    string output = JSON.serialize(root);
    PageReference pageRef = Page.inwiB2C_Invoices_Doc_Page;
    Test.setCurrentPage(pageRef);
    Test.startTest();
    ApexPages.currentPage().getParameters().put('input', String.valueOf(output));
    InwiB2C_Invoices_Doc_Controller testcall = new InwiB2C_Invoices_Doc_Controller();
    
           Test.stopTest();
    
 }
}