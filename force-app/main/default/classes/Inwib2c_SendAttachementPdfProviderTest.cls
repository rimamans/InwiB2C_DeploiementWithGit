@isTest
public  class Inwib2c_SendAttachementPdfProviderTest {
    @isTest (SeeAllData=true) 
    public static void testSend_pdfProvider() {

        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware',
                                     ProductCode='INWIB2C_OFFERING_SIM'
                                   );
        insert prod;
        
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours',  inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',	
inwiB2C_Canal__c='inwiB2C_Eshop',EffectiveDate = Date.today().addDays(-1), Status = 'Draft',inwib2c_ModeDeLivraison__c='inwiB2C_Domicile', AccountId =testAccount.Id);
        insert neworder;
        
String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvRHUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_FilteredByOffer","attributeconfigurable__c":true,"attributedisplaysequence__c":"23","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"FilteredByOffer","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi2UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvSNUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_SerialType","attributeconfigurable__c":true,"attributedisplaysequence__c":"13","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"SerialType","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"IMEI","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"IMEI","id":"4709e2ed-41df-1e43-dccd-94ddc0391c0e","sequence":20,"value":"IMEI"}],"values":[{"displayText":"ICCID","id":"436f94d1-bb4e-b36c-1676-6a43ee16be1c","sequence":10,"value":"ICCID"},{"displayText":"IMEI","id":"4709e2ed-41df-1e43-dccd-94ddc0391c0e","sequence":20,"value":"IMEI"},{"displayText":"ESN","id":"e7b65f72-4b89-d814-bc34-65311118b361","sequence":30,"value":"ESN"}],"selectedItem":{"displayText":"IMEI","id":"4709e2ed-41df-1e43-dccd-94ddc0391c0e","sequence":20,"value":"IMEI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvSOUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ShowPrice","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ShowPrice","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvSPUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_StockValidated","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"StockValidated","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSiAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvSYUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_Technology","attributeconfigurable__c":true,"attributedisplaysequence__c":"22","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Technology","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSiBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"GSM","valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"GSM","value":"GSM"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvRQUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_MODELE","attributeconfigurable__c":true,"attributedisplaysequence__c":"55","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modèle","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"0081231113"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvShUAI","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_OFFERING_MARQUE","attributeconfigurable__c":true,"attributedisplaysequence__c":"50","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Marque","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi5UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvPuUAI","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_MODELELABEL","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Modèle Label","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi6UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"Router Alcatel"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvRMUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IMEI","attributeconfigurable__c":true,"attributedisplaysequence__c":"40","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMEI/ESN","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi3UAE","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"312312312344"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvRPUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_MARQUELABEL","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Marque Label","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi4UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null}]}';

        
        OrderItem newOrderitem = new OrderItem(Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
        insert newOrderitem;

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        inputMap.put('email','bouremmaamine09@gmail.com');
        inputMap.put('pdf','/apex/inwiB2C_ContractGeneration?orderid='+neworder.Id);
        inputMap.put('mandat','/apex/inwiB2C_MandatPortabilite?orderid='+neworder.Id);
        inputMap.put('fmsPaiement','/apex/inwib2c_RecuPaiementPostpaid?orderid='+neworder.Id);
        inputMap.put('paiementTerminal','/apex/inwib2c_recu_paiement_terminal?orderid='+neworder.Id);
        inputMap.put('mandatdegrouage','/apex/InwiB2C_MandatDegroupage?orderid='+neworder.Id);
        inputMap.put('bonlivgarantie','/apex/InwiB2C_BonDeLivraisonGarantie?orderid='+neworder.Id);

        inputMap.put('adslmandatportabilite','/apex/inwiB2C_MandatPortabiliteADSL?orderid='+neworder.Id);

        inputMap.put('recuPaiement','/apex/inwiB2C_RecuPaiement?orderid='+neworder.Id);
        inputMap.put('bonlivraison','/apex/iniwiB2C_BonLivraison?orderid='+neworder.Id);
       
        // inputMap.put('simulationfacture','');
        inputMap.put('orderid',neworder.Id);
        inputMap.put('orderitemid',newOrderitem.Id);
        inputMap.put('fms',49);
        inputMap.put('fmd',0);
        inputMap.put('prix',100);
        inputMap.put('typeforfais','Mobile Postpayé');
        inputMap.put('codetransaction',true);
        inputMap.put('statutdegroupage','inwiB2C_Inactive');


        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();

        // ipInput.put('orderid','8013M000001zcQ7QAI');
        // ipInput.put('orderitemid','8023M000003IAAeQAO');
        // ipInput.put('activation_date','2023-05-30T02:10:33Z' );
        // ipInput.put('fms',49 );
        

        // ipOutput.put('TypeDoc', 'No');
        // ipOutput.put('TypeContratDoc','Postpayé');
        // ipOutput.put('TypeDeMigration','');
        // ipOutput.put('TypeOffe','Forfait 1H + 11Go');
        // ipOutput.put('IsProrate', 'Oui');
        // ipOutput.put('address', 'Maatkas TiziOuzou');
        // ipOutput.put('clientname', 'Bouremma Amine');
        // ipOutput.put('fms', 49.0 ); 
        // ipOutput.put('gamme', 'Forfait in sans engagement'); 
        // ipOutput.put('Code_de_transaction_FMS', '123456789');
        // ipOutput.put('Code_de_transaction_FMD', '');  
        // ipOutput.put('activation_date', '12/05/2023 02:00:00');
        // ipOutput.put('billing_cycle', 18); 
        // Integer billingcycle=18;
        // String billing='18';     

        // Test.setMock(
        //     vlocity_cmt.IntegrationProcedureService.Mock.class,
        //     new vlocity_cmt.IntegrationProcedureService.Mock()
        // );
         
       
        new Inwib2c_SendAttachementPdfProvider().invokeMethod('send_pdfProvider',inputMap,outMap,options);
        
    }
}