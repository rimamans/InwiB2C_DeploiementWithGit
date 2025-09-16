@isTest
public with sharing class inwiB2C_docModControllerTest{
    @isTest
    public static void inwiB2C_docModControllerTest(){
          Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        
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
        
        order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder;
        
        PageReference pageRef = Page.inwiB2C_generateDocModification;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('orderId',neworder.Id);
         ApexPages.currentPage().getParameters().put('oldmac','oldmac');
          ApexPages.currentPage().getParameters().put('oldmodel','oldmodel');
        inwiB2C_documentModificationController testcall = new inwiB2C_documentModificationController();
        Test.stopTest();
    }

}