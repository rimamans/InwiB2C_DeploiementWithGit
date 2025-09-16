@isTest
public with sharing class inwib2c_CreateEshopCartTriggerTest {
    public static testMethod void testTriggerLogic(){

        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        InwiB2C_Trace_API__c trace = new InwiB2C_Trace_API__c();
        //trace.InwiB2C_request_body__c= '{"CSOperationInfo":{"channel":"","user":"","uuid":"1234"},"CSExecuteMigPostPost":{"Code_offre":"INWIB2C_OFFERING_99DH_ILLINWI_APL","Ins":"","MDN":"212648101017","Profil":"86910","TL":"CI","billingAccount":"","productId":"Forfait 11h + 11Go"}}';  
        //trace.InwiB2C_request_body__c= '{"CSOperationInfo":{"channel":"","user":"","uuid":"1234"},"CSExecuteMigPostPost":{"Code_offre":"INWIB2C_OFFERING_99DH_ILLINWI_APL","Ins":"","MDN":"212648101017","Profil":"86910","TL":"CI","billingAccount":"","productId":"Forfait 11h + 11Go"}}';   
        trace.InwiB2C_request_body__c='{"CSOperationInfo": {"uuid": "b517c235-2a9f-4007-ac08-8aa9513c5f97","user": "galaxie","channel": "galaxie"},"buyerId": "'+ testAccount.Id +'","customerId": "'+ testAccount.Id +'","delivery": {"type": "DOMICILE","deliveryPrice": 0.0,"codeliv": "deliverydomicile"},"orderType": "PDC","paymentMethod": "ES","paymentReference": "","products": [{"type": "Handset","price": {"type": "ONE_SHOT","amount": 2100.0},"code": "TERMINAL","attributes": [{"value": "100001793","code": "INWIB2C_ATT_RT_MODELE"},{"value": "XIAOMI NOTE 10 4/128GB DK","code": "INWIB2C_ATT_DC_MODELELABEL"}]}],"promo": "","siteId": ""}';

        insert trace;
            inwib2c_createEshop__e EventItem = new inwib2c_createEshop__e(TraceId__c=trace.Id);
        
            Test.startTest();
            Database.SaveResult results = EventBus.publish(EventItem);
            Test.stopTest();

    }
}