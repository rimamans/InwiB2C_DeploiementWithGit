@isTest
public class inwiB2C_CallGenerateContractPrepaidTest {

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"content": "Contrat généré", "name": "ContratPrepayé"}');
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockHttpResponseError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"content": "Contrat généré", "name": "ContratPrepayé"}');
            res.setStatusCode(500);
            return res;
        }
    }

    @isTest (SeeAllData=true) 
    public static void generateContractPrePaidTest1() {
        Test.startTest(); 
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Account client = new Account(Name = 'acc');
        insert client;

        Contract contract = new Contract(
            AccountId = client.Id,
            inwib2c_Identification__c = true,
            inwib2c_Qualification__c = true,
            Status = 'Draft',
            StartDate = Date.today()
        );
        insert contract;

        vlocity_cmt__Subscription__c ligne = new vlocity_cmt__Subscription__c(
            Inwib2c_Num_ro_de_la_ligne__c = '212999999999',
            vlocity_cmt__SubscriptionNumber__c = '999',
            Inwib2c_Offre__c = 'Offre TicTac Sim Seule',
            inwiB2C_LegacyStatus__c = 'ACTIVE',
            InwiB2C_Type_Offre__c = 'InwiB2C_Prepaye',
            InwiB2C_Contract__c = contract.Id
        );
        insert ligne;

        Map<String, Object> inputMap = new Map<String, Object>{
            'souscriptionID' => ligne.Id
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        new inwiB2C_CallGenetayeContractPrePaid().invokeMethod('generateContractPrePaid', inputMap, outMap, options);
        
        Test.stopTest();

    }

    @isTest (SeeAllData=true) 
    public static void generateContractPrePaidTest2() {
        Test.startTest(); 
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Account client = new Account(Name = 'acc');
        insert client;

        Contract contract = new Contract(
            AccountId = client.Id,
            inwib2c_Identification__c = true,
            inwib2c_Qualification__c = true,
            Status = 'Draft',
            StartDate = Date.today()
        );
        insert contract;

        vlocity_cmt__Subscription__c ligne = new vlocity_cmt__Subscription__c(
            Inwib2c_Num_ro_de_la_ligne__c = '212999998889',
            vlocity_cmt__SubscriptionNumber__c = '999',
            Inwib2c_Offre__c = 'Offre TicTac Sim Seule',
            inwiB2C_LegacyStatus__c = 'ACTIVE',
            InwiB2C_Type_Offre__c = 'InwiB2C_Prepaye',
            InwiB2C_Contract__c = contract.Id
        );
        insert ligne;

          Map<String, Object> inputMap = new Map<String, Object>{
             'subscriptionId' => ligne.Id
           };

        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        new inwiB2C_CallGenetayeContractPrePaid().invokeMethod('checkSubscription', inputMap, outMap, options);
        
        Test.stopTest();
    }
    @isTest (SeeAllData=true) 
    public static void generateContractPrePaidTest3() {
        Test.startTest(); 
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseError());

        Account client = new Account(Name = 'acc');
        insert client;

        Contract contract = new Contract(
            AccountId = client.Id,
            inwib2c_Identification__c = true,
            inwib2c_Qualification__c = true,
            Status = 'Draft',
            StartDate = Date.today()
        );
        insert contract;

        vlocity_cmt__Subscription__c ligne = new vlocity_cmt__Subscription__c(
            Inwib2c_Num_ro_de_la_ligne__c = '212999999999',
            vlocity_cmt__SubscriptionNumber__c = '999',
            Inwib2c_Offre__c = 'Offre TicTac Sim Seule',
            inwiB2C_LegacyStatus__c = 'ACTIVE',
            InwiB2C_Type_Offre__c = 'InwiB2C_Prepaye',
            InwiB2C_Contract__c = contract.Id
        );
        insert ligne;

        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('requete', '{"contractDealerBean":{"reengag":"","portedProfil":"","portedOfferType":"","portedMsisdn":"","portedLineType":"","portedIccId":"","portedEngagement":"","paymentReference":"","paymentMode":"","options":"","lineType":"Principale","fms":0,"fmd":0,"fi":"","fag":"","equipmentType4":"","equipmentType3":"","equipmentType2":"","equipmentType":"","equipmentSerialNumber4":"","equipmentSerialNumber3":"","equipmentSerialNumber2":"","equipmentSerialNumber":"","equipmentPrice4":"","equipmentPrice3":"","equipmentPrice2":"","equipmentPrice":"","equipmentLabel4":"","equipmentLabel3":"","equipmentLabel2":"","equipmentLabel":"","equipmentEngagement4":"","equipmentEngagement3":"","equipmentEngagement2":"","equipmentEngagement":"","equipmentDisposition4":"","equipmentDisposition3":"","equipmentDisposition2":"","equipmentDisposition":"","caution":"","asf":"","suscriptionPrice":"0","isSAV":"false","isPre":"true","isPost":"false","isPorta":"false","isMig":"false","globalEquipmentPrice":"0","contractType":"Prépayé","adress":"LOT DE TEST","simPrice":0,"identificationType":"Passport","identificationNumber":"AMM31","contractNumber":"CTR-46101416","agreementDate":"08-02-2025","profil":"84001","offerType":"Offre TicTac Sim Seule","msisdn":"212648206512","lastName":"TEACH","iccId":"892128510051005477","firstName":"MULTICIN","email":"212648208644@dummy.xx","custumerFullName":"MULTICIN TEACH","contactNumber":"212648208644","city":"CASABLANCA","birthDay":"01-01-1995","billingAccountNumber":"SF0070014236"}}');
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        new inwiB2C_CallGenetayeContractPrePaid().invokeMethod('generateContractPrePaid', inputMap, outMap, options);
        
        // System.assertEquals('error', outMap.get('error'), 'error est');
        Test.stopTest();

    }
}