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
private class inwiB2C_CreateAsyncSwapEsimTriggerTest {

    @isTest
    static void createAsync() {
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
        InwiB2C_CreateSMOSwapEsimAsynchrone__e e = new InwiB2C_CreateSMOSwapEsimAsynchrone__e(
            InwiB2C_PanierId__c=panier.Id,
            InwiB2C_TraceId__c=trace.Id
        );
        Database.SaveResult results = EventBus.publish(e);
        Test.stopTest();
    }
}