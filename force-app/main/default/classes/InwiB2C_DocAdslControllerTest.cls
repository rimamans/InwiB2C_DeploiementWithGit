/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class InwiB2C_DocAdslControllerTest {
    @isTest
    public static void InwiB2C_DocAdslControllerTest() {

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
         Account acc = new Account(Name='classTestAccount');
        insert acc;
       order neworder = new Order ( inwiB2C_Statut__c ='inwiB2C_EnCours', Status = 'Draft' ,EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', AccountId =acc.Id);
        insert neworder;
        system.debug('neworder.Id'+neworder.Id);
        inputMap.put('recordId',neworder.Id);
                String OrderId=neworder.Id;
        
        String transactionCode='123456789';
        PageReference pageRef1 = Page.InwiB2C_BonDeLivraisonGarantie;
        PageReference pageRef2 = Page.inwiB2C_MandatPortabilite;
        PageReference pageRef3 = Page.InwiB2C_MandatDegroupage;
        Test.setCurrentPage(pageRef1);
        Test.setCurrentPage(pageRef2);
        Test.setCurrentPage(pageRef3);
        
        Test.StartTest(); 
        ApexPages.standardSetController sc = new ApexPages.standardSetController(Database.getQueryLocator([SELECT Id FROM Order where id=:OrderId]));
        ApexPages.currentPage().getParameters().put('transactionCode', String.valueOf('123'));
        InwiB2C_DocAdslController testcall = new InwiB2C_DocAdslController();
        Test.StopTest();
      }
        

    }