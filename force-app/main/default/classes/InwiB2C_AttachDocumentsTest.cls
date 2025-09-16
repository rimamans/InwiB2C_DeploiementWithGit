@isTest
public class InwiB2C_AttachDocumentsTest {
 public static testMethod void testTrigger() {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode = 'INWIB2C_OFFERING_SIM');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
        insert customPB;

        
        Contract c = new Contract(AccountId = testAccount.Id, InwiB2C_statut_contrat__c = 'Initialise');
        insert c;
       
        
        Order testOrder = new Order(Pricebook2Id = customPB.Id, inwiB2C_Statut__c = 'inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId = testAccount.Id, contractId = c.id);
        insert testOrder;
        System.debug('testOrder.Id: ' + testOrder.Id); 
    

        Account agence = new Account(Name='agence');
        insert agence;


        
        InwiB2C_Attach_Documents__e newEvent = new InwiB2C_Attach_Documents__e(
            InwiB2C_OldOrder__c = testOrder.Id, 
            InwiB2C_New_Order__c = testOrder.Id,
            InwiB2C_Index_Type__c = 'ALL'
        );
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(newEvent);
        Test.stopTest();
 }
}