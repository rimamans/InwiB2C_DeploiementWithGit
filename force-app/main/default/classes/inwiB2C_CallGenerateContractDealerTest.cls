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
private class inwiB2C_CallGenerateContractDealerTest {
    @isTest
    static void generateContractDealerTest() {
        inwiB2C_CallGenerateContractDealer cls = new inwiB2C_CallGenerateContractDealer();
        Map<String,Object> inp = new Map<String,Object>();
        Map<String,Object> out = new Map<String,Object>();
        Map<String,Object> opt = new Map<String,Object>();
        inp.put('', '{"contractDealerBean":{"reengag":"","portedProfil":"","portedOfferType":"","portedMsisdn":"","portedLineType":"","portedIccId":"","portedEngagement":"","paymentReference":"","paymentMode":"","options":"","lineType":"Principale","fms":0,"fmd":0,"fi":"","fag":"","equipmentType4":"","equipmentType3":"","equipmentType2":"","equipmentType":"","equipmentSerialNumber4":"","equipmentSerialNumber3":"","equipmentSerialNumber2":"","equipmentSerialNumber":"","equipmentPrice4":"","equipmentPrice3":"","equipmentPrice2":"","equipmentPrice":"","equipmentLabel4":"","equipmentLabel3":"","equipmentLabel2":"","equipmentLabel":"","equipmentEngagement4":"","equipmentEngagement3":"","equipmentEngagement2":"","equipmentEngagement":"","equipmentDisposition4":"","equipmentDisposition3":"","equipmentDisposition2":"","equipmentDisposition":"","caution":"","asf":"","suscriptionPrice":"0","isSAV":"false","isPre":"true","isPost":"false","isPorta":"false","isMig":"false","globalEquipmentPrice":"0","contractType":"Prépayé","adress":"LOT DE TEST","simPrice":0,"identificationType":"Passport","identificationNumber":"AMM31","contractNumber":"CTR-46101416","agreementDate":"08-02-2025","profil":"84001","offerType":"Offre TicTac Sim Seule","msisdn":"212648206512","lastName":"TEACH","iccId":"892128510051005477","firstName":"MULTICIN","email":"212648208644@dummy.xx","custumerFullName":"MULTICIN TEACH","contactNumber":"212648208644","city":"CASABLANCA","birthDay":"01-01-1995","billingAccountNumber":"SF0070014236"}}');
        cls.generateContractDealer(inp);
    }
    @isTest(SeeAllData=true)
    static void checkSubscriptionTest() {
        Account client = new Account(Name='acc');
        insert client;
        Contract contract = new Contract(
            AccountId=client.Id,
            inwib2c_Identification__c=true,
            inwib2c_Qualification__c=true
        );
        insert contract;
        vlocity_cmt__Subscription__c ligne = new vlocity_cmt__Subscription__c(
            Inwib2c_Num_ro_de_la_ligne__c = '212999999999',
            vlocity_cmt__SubscriptionNumber__c='999',
            Inwib2c_Offre__c = 'Offre Dealer Sim Seule',
            inwiB2C_LegacyStatus__c='ACTIVE',
            Inwib2C_Type_Offre__c='InwiB2C_Prepaye'
        );
        insert ligne;
        inwiB2C_CallGenerateContractDealer cls = new inwiB2C_CallGenerateContractDealer();
        Map<String,Object> inp = new Map<String,Object>();
        Map<String,Object> out = new Map<String,Object>();
        Map<String,Object> opt = new Map<String,Object>();
        inp.put('subscriptionId', ligne.Id);
        cls.checkSubscription(inp);
    }
}