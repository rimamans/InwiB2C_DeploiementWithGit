/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class InwiB2C_AssetDigitalEsimTriggerTest {

    @isTest
    public static void CreateOrderTest() {
        Account accTest = new Account(Name='test esim Asset');
        insert accTest;
        Asset asset1 = new Asset(
            Name = 'Test Asset',
            Status = 'Installed',
            AccountId = accTest.Id,
            InstallDate = System.Today(),
            UsageEndDate = System.Today()
        );
        insert asset1;
        String requestBody = '[{"CSOperationInfo":{"channel":"galaxie","user":"galaxie","uuid":"123"},"CSCreateSMO":{"mdn":"2126678909","actionType":"CHSIM","ICC":"892128510050258770","puk":"18640773903954","ki":"F97769DD8309EA44AD0EE2BBB7AB45CC","imsi":"604050400092861","codeArticle":"300001141","ocsid":"IN2","submite":"O","waitpayment":"N","Motif":"SWAP_SIM_ESIM","typesim":"ESMD"}}]';
        inwib2c_TraceDemandeEshop__c panier = new inwib2c_TraceDemandeEshop__c(inwib2c_MDN__c='2126678909', inwib2c_Request_body__c=requestBody);
        insert panier;
        InwiB2C_Trace_API__c trace = new InwiB2C_Trace_API__c(
            InwiB2C_request_body__c= '[{"CSOperationInfo":{"channel":"galaxie","user":"galaxie","uuid":"123"},"CSCreateSMO":{"mdn":"2126678909","actionType":"CHSIM","ICC":"892128510050258770","puk":"18640773903954","ki":"F97769DD8309EA44AD0EE2BBB7AB45CC","imsi":"604050400092861","codeArticle":"300001141","ocsid":"IN2","submite":"O","waitpayment":"N","Motif":"SWAP_SIM_ESIM","typesim":"ESMD"}}]',
            InwiB2C_MDN__c='2126678909',
            InwiB2C_API_Name__c = 'WS71'
        );
        insert trace;

        Test.startTest();
        INWIB2C_Asset_Generation_SWAP_SIM_ESIM__e e = new INWIB2C_Asset_Generation_SWAP_SIM_ESIM__e(
            AccountId__c=accTest.Id,
            AssetId__c=asset1.Id,
            Canal__c='MyInwi',
            PanierId__c=panier.Id,
            Step__c='CreateOrder',
            TraceId__c=trace.Id
        );
        Database.SaveResult results = EventBus.publish(e);
        Test.stopTest();

    }
    @isTest
    public static void checkoutTest() {
        Account accTest = new Account(Name='test esim Asset');
        insert accTest;
        String requestBody = '[{"CSOperationInfo":{"channel":"galaxie","user":"galaxie","uuid":"123"},"CSCreateSMO":{"mdn":"2126678909","actionType":"CHSIM","ICC":"892128510050258770","puk":"18640773903954","ki":"F97769DD8309EA44AD0EE2BBB7AB45CC","imsi":"604050400092861","codeArticle":"300001141","ocsid":"IN2","submite":"O","waitpayment":"N","Motif":"SWAP_SIM_ESIM","typesim":"ESMD"}}]';
        inwib2c_TraceDemandeEshop__c panier = new inwib2c_TraceDemandeEshop__c(inwib2c_MDN__c='2126678909', inwib2c_Request_body__c=requestBody);
        insert panier;
        InwiB2C_Trace_API__c trace = new InwiB2C_Trace_API__c(
            InwiB2C_request_body__c= '[{"CSOperationInfo":{"channel":"galaxie","user":"galaxie","uuid":"123"},"CSCreateSMO":{"mdn":"2126678909","actionType":"CHSIM","ICC":"892128510050258770","puk":"18640773903954","ki":"F97769DD8309EA44AD0EE2BBB7AB45CC","imsi":"604050400092861","codeArticle":"300001141","ocsid":"IN2","submite":"O","waitpayment":"N","Motif":"SWAP_SIM_ESIM","typesim":"ESMD"}}]',
            InwiB2C_MDN__c='2126678909',
            InwiB2C_API_Name__c = 'WS71'
        );
        insert trace;
        Product2 product = new Product2(Name='Offre TicTac Sim+Termina', ProductCode='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL');
        insert product;
        Product2 product2 = new Product2(Name='Numéro Téléphone',ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
        insert product2;
        Account acc = new Account(Name='test porta Acc');
        insert acc;
        Id pricebookId = '01s4K000001FA2rQAG';
        Id pricebookId2 = '01s4K000001FA2rQAG';
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = product.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = product.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        Order order = new Order(Pricebook2Id = customPB.Id, Name='test order',inwiB2C_Canal__c='inwiB2C_MyInwi',EffectiveDate = Date.today().addDays(-1), Status = 'Draft', AccountId =acc.Id);
        insert order;
        Test.startTest();
        INWIB2C_Asset_Generation_SWAP_SIM_ESIM__e e = new INWIB2C_Asset_Generation_SWAP_SIM_ESIM__e(
            AccountId__c=accTest.Id,
            Canal__c='MyInwi',
            PanierId__c=panier.Id,
            OrderId__c=order.Id,
            Step__c='checkout',
            TraceId__c=trace.Id
        );
        Database.SaveResult results = EventBus.publish(e);
        Test.stopTest();
    }
}