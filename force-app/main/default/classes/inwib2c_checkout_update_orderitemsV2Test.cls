@isTest
public class inwib2c_checkout_update_orderitemsV2Test {
@isTest(SeeAllData = true)
     public static void inwib2c_checkout_update_orderitemsV2Test(){
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode = 'INWIB2C_OFFERING_SIM');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        // create contract
        Contract c = new Contract(AccountId = testAccount.Id, InwiB2C_statut_contrat__c = 'Initialise');
        insert c;
        order neworder = new Order(inwiB2C_TypeActeDeGestion__c = 'inwiB2C_ChangementTitulaire', Pricebook2Id = customPB.Id, inwiB2C_Statut__c = 'inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId = testAccount.Id, contractId = c.id);
        insert neworder;

        OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, PriceBookEntryId = customPrice.Id, OrderId = neworder.Id, Quantity = 1, UnitPrice = customPrice.UnitPrice, ServiceDate = Date.Today());
        insert newOrderitem;

        neworder.inwiB2C_Statut__c = 'inwiB2C_ValideeBO';

        update neworder;

        List<String> input = new List<String>();
        input.add(neworder.Id);

        inwib2c_checkout_update_orderitemsCLV2.callVIP(input);

    }
}