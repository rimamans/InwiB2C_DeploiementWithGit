@isTest
public with sharing class inwib2c_contract_cession_controllerTest{
    @isTest
    public static void inwib2c_contract_cession_controllerTest(){
        Map<String, Object> globalMap = new Map<String, Object>();

        //
        // Map<String, Object> root = new Map<String, Object>();
        // List<Map<String, Object>> data = new List<Map<String, Object>>();
        // root.put('typeligne', 'Grand Public');
        // root.put('typeoffre', 'Forfait 1H + 2Go + Illimité RS + inwi"');
        // root.put('formule', 'Forfait in sans engagement');
        // root.put('numligne', '212648079991');
        // root.put('icc', '892128510050233556');

        // data.add(root);
        // //
        // globalMap.put('typeContract', 'Contract Mobile avec abonnement');
        // globalMap.put('ville', 'CASABLANCA');
        // globalMap.put('adresse', 'rue 11 Maroc');
        // globalMap.put('numBillingAccount', 'SF0000000433');
        // globalMap.put('typecin', 'Passport');
        // globalMap.put('titulaire', 'Madame');
        // globalMap.put('phone', '212678451236');
        // globalMap.put('lastname', 'Formation');
        // globalMap.put('firstname', 'Formation');
        // globalMap.put('datenaissance', '01/05/1998');
        // globalMap.put('cin', 'AZ7896');
        // globalMap.put('date', '17/05/2022');
        // globalMap.put('data', data);

        PageReference pageRef = Page.inwib2c_contract_cession;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('input', '{ "typeContract": "Contract Mobile avec abonnement", "data": [ { "typeligne": "Grand Public", "typeoffre": "Forfait 1H + 2Go + Illimité RS + inwi", "formule": "Forfait in sans engagement", "numligne": "212648079991", "icc": "892128510050233556" } ], "ville": "CASABLANCA", "adresse": "rue 11 Maroc", "numBillingAccount": "SF0000000433", "typecin": "Passoport", "titulaire": "Madame", "phone": "212678451236", "lastname": "Formation", "firstname": "changement titulaire", "datenaissance": "01/05/1998", "cin": "AZ7896", "date": "17/05/2022" }');
        inwib2c_contract_cession_controller testcall = new inwib2c_contract_cession_controller();
        Test.stopTest();
    }

}