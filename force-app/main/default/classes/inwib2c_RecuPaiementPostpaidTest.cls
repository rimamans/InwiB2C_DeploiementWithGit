/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class inwib2c_RecuPaiementPostpaidTest{
    @isTest
    public static void inwib2c_RecuPaiementPostpaidTest(){
        
        PageReference pageRef = Page.inwib2c_RecuPaiementPostpaid;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('input','{ "datafms": [ { "type": "FMS", "timbre": "0.00", "montantrestant": "0.00", "mode_paiement": "En espèce","montant":100,"montant_fmd":100,"reference_fmd":"123456","montantrestant":"0.0","date": "09/12/2022"} ], "canal": "Point de vente", "displayFMD": true, "compte_facturation": "SF0000001310", "countIdarDuo": 1,  "countchangemnt": 0, "pdv": "CMS01","User": "mohammed hamitouche", "isIdarDuo": true }');
        inwib2c_RecuPaiementPostpaid testcall = new inwib2c_RecuPaiementPostpaid();
        Test.stopTest();
    }

}