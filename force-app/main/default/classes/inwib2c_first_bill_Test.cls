@isTest
public with sharing class inwib2c_first_bill_Test{
    @isTest
    public static void inwib2c_first_bill_Test(){
        PageReference pageRef = Page.inwib2c_first_bill;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('input', '{ "data": [ { "clientname": "testapiimx testapiimx", "offer": "Forfait 3H + 33Go", "num_cf": "SF0000000066", "gamme": "Forfait in sans engagement", "activationdate": "27/05/2022", "address": "cite mnewtestm 25102021", "pays": "Maroc", "ville": "test", "region": "Meknes,Tafilalet", "numfacture": "FMS123456789", "numligne": "21266666666", "fms": "124.17", "tva": "24.83", "timbre": "0.00", "totalttc": "149.00", "avancepaiement": "149.00" }, { "clientname": "testapiimx testapiimx", "offer": "Forfait 1H + 11Go", "num_cf": "SF0000000064", "gamme": "Forfait in sans engagement", "activationdate": "27/05/2022", "address": "cite mnewtestm 25102021", "pays": "Maroc", "ville": "test", "region": "Meknes,Tafilalet", "numfacture": "FMS987654321", "numligne": "21255555555555", "fms": "40.83", "tva": "8.17", "timbre": "0.00", "totalttc": "49.00", "avancepaiement": "49.00" } ] }');
        inwib2c_first_bill_controller testcall = new inwib2c_first_bill_controller();
        Test.stopTest();
    }

}