@isTest
public with sharing class inwib2c_RecuPaiementTerminalTest{
    @isTest
    public static void inwib2c_RecuPaiementTerminalTest(){
        PageReference pageRef = Page.inwib2c_recu_paiement_terminal;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('input', '{ "name": "Chadia Bani", "cin": "I718277", "lastname": "Bani", "firstname": "Chadia", "compte_facturation": "SF0000000150", "terminaux": [ { "quantity": "1", "gamme": "Forfait in sans engagement / Grand Public", "price": 165, "name": "ALCATEL IDOL 2 MINI L", "code": "000050846", "offre": "Forfait 11h + 11Go", "code_transaction": "22051723816", "mode_paiement": "En espèce" } ], "date": "17/05/2022", "ordernumber": "00420294", "pdv": "CPD01", "code_agent": "CPD01", "canal": "Point de vente" }');
        inwib2c_RecuPaiementTerminal testcall = new inwib2c_RecuPaiementTerminal();
        Test.stopTest();
    }

}