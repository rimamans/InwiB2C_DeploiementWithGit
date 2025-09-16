@isTest
public with sharing class inwib2c_promotion_functionsTest{
    @isTest(SeeAllData = true)
    public static void inwib2c_promotion_functionsTest(){
        inwib2c_promotion_functions cls = new inwib2c_promotion_functions();
        //
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
        order neworder = new Order(Pricebook2Id = customPB.Id, inwiB2C_Statut__c = 'inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId = testAccount.Id, contractId = c.id);
        insert neworder;
        OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, PriceBookEntryId = customPrice.Id, OrderId = neworder.Id, Quantity = 1, UnitPrice = customPrice.UnitPrice, ServiceDate = Date.Today());
        insert newOrderitem;
        String strDt = '25/1/2022';
        //convert String to Date(output:2018-01-25 00:00:00)
        Date dateDebut = Date.parse(strDt);
        //convert date to DateTime.Can be used in soql but not in dynamic soql(output:2018-01-25 05:00:00)
        DateTime dt = DateTime.newInstance(dateDebut.year(), dateDebut.month(), dateDebut.day(), 0, 0, 0);

        String strDF = '25/1/2024';
        //convert String to Date(output:2018-01-25 00:00:00)
        Date dateFin = Date.parse(strDF);
        //convert date to DateTime.Can be used in soql but not in dynamic soql(output:2018-01-25 05:00:00)
        DateTime df = DateTime.newInstance(dateFin.year(), dateFin.month(), dateFin.day(), 0, 0, 0);

        InwiB2C_Promotion__c promo = new InwiB2C_Promotion__c(inwiB2C_Code_Produit__c = 'inwiB2C_Code_Produit__c', inwiB2C_code_promotion__c = 'code', InwiB2C_date_Debut__c = dt, inwiB2C_date_fin__c = df, Name = 'promotion name');
        insert promo;
        orderItemAppliedPromotion__c orderItemAppliedPromotion = new orderItemAppliedPromotion__c();
        orderItemAppliedPromotion.orderItemId__c = newOrderitem.Id;
        orderItemAppliedPromotion.promotionId__c = promo.Id;

        //
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('orderItemId', newOrderitem.Id);
        inputMap.put('orderId', neworder.Id);
        Map<String, Object> listPromotionIds = new Map<String, Object>();
        List<Map<String, Object>> data = new List<Map<String, Object>>();
        Map<String, Object> item = new Map<String, Object>();
        item.put('orderItemId', newOrderitem.Id);
        item.put('promotionId__c', promo.Id);
        data.add(item);
        listPromotionIds.put('data', data);
        inputMap.put('listPromotionIds', listPromotionIds);
        System.debug(inputMap);
        boolean result = cls.invokeMethod('getAppliedPromotions', inputMap, outMap, options);
        boolean result2 = cls.invokeMethod('getAppliedPromotionsForCart', inputMap, outMap, options);
        boolean result3 = cls.invokeMethod('saveAppliedPromotions', inputMap, outMap, options);
    }

}