@isTest
public class inwib2cSMOSwapSimEsimCheckoutTEST {
 @isTest
     private static void testsample(){

        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        String JsonResponse ='{"errorCode":"","errorMessage":"Success","isOK":0,"orderId":""}';
        InwiB2C_Trace_API__c newtrace =new  InwiB2C_Trace_API__c(InwiB2C_API_Name__c='WS71',InwiB2C_Status__c='OK',InwiB2C_Response__c=JsonResponse,InwiB2C_uuid__c='6fa0c6b7-9895-6263-498b-242facac8a96');
        insert newtrace;
        inwib2c_TraceDemandeEshop__c newtraceeshop =new  inwib2c_TraceDemandeEshop__c(inwib2c_Statut__c='OK',inwib2c_Mode_de_paiement__c='En Espece',IdTraceAPI__c=newtrace.Id);
        insert newtraceeshop;

        Product2 prod = new Product2(Name = 'Laptop X200', 
        Family = 'Hardware',
        ProductCode='INWIB2C_OFFERING_SIM'
      );
insert prod;
Id pricebookId = Test.getStandardPricebookId();
        
PricebookEntry standardPrice = new PricebookEntry(
    Pricebook2Id = pricebookId, Product2Id = prod.Id,
    UnitPrice = 10000, IsActive = true);
insert standardPrice;
Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
insert customPB;

PricebookEntry customPrice = new PricebookEntry(
    Pricebook2Id = customPB.Id, Product2Id = prod.Id,
    UnitPrice = 12000, IsActive = true);
insert customPrice;
        order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours',  inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',	
        inwiB2C_Canal__c='inwiB2C_Eshop',EffectiveDate = Date.today().addDays(-1), Status = 'Draft',inwib2c_ModeDeLivraison__c='inwiB2C_Domicile', AccountId =testAccount.Id);
                insert neworder;
         String input ='{"TraceId":"' + newtrace.Id + '","Id":"' + neworder.Id + '"}';
         Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock()); 
         inwib2cSMOSwapSimEsimCheckout.inwib2cSMOSwapSimEsimCheckout(input);
    }
}