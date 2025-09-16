/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-10-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class inwiB2C_ContractControllerPhase4Test{

    @isTest(SeeAllData=true)
    static void validateStandardController(){
          
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
        
        order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder;
        
String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvRHUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_FilteredByOffer","attributeconfigurable__c":true,"attributedisplaysequence__c":"23","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"FilteredByOffer","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi2UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvSNUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_SerialType","attributeconfigurable__c":true,"attributedisplaysequence__c":"13","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"SerialType","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"IMEI","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"IMEI","id":"4709e2ed-41df-1e43-dccd-94ddc0391c0e","sequence":20,"value":"IMEI"}],"values":[{"displayText":"ICCID","id":"436f94d1-bb4e-b36c-1676-6a43ee16be1c","sequence":10,"value":"ICCID"},{"displayText":"IMEI","id":"4709e2ed-41df-1e43-dccd-94ddc0391c0e","sequence":20,"value":"IMEI"},{"displayText":"ESN","id":"e7b65f72-4b89-d814-bc34-65311118b361","sequence":30,"value":"ESN"}],"selectedItem":{"displayText":"IMEI","id":"4709e2ed-41df-1e43-dccd-94ddc0391c0e","sequence":20,"value":"IMEI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvSOUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ShowPrice","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ShowPrice","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvSPUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_StockValidated","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"StockValidated","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSiAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvSYUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_Technology","attributeconfigurable__c":true,"attributedisplaysequence__c":"22","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Technology","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSiBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"GSM","valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"GSM","value":"GSM"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvRQUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_MODELE","attributeconfigurable__c":true,"attributedisplaysequence__c":"55","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modèle","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"0081231113"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvShUAI","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_OFFERING_MARQUE","attributeconfigurable__c":true,"attributedisplaysequence__c":"50","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Marque","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi5UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvPuUAI","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_MODELELABEL","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Modèle Label","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi6UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"Router Alcatel"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvRMUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IMEI","attributeconfigurable__c":true,"attributedisplaysequence__c":"40","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMEI/ESN","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi3UAE","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"312312312344"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3L000002nAKbQAM","attributeid__c":"a0X3L000000yvRPUAY","attributecategoryid__c":"a0W3L000001fDsnUAE","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_MARQUELABEL","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Marque Label","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000000aSi4UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null}]}';

        
        OrderItem newOrderitem = new OrderItem(Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
        insert newOrderitem;
        
        //List<String> listIdOrder = new List<String>();
        //listIdOrder.add(neworder.Id);
        
        //List<Order> OrdersList = [select id from Order where id in :listIdOrder]; 
        //Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock()); 
        PageReference pageRef = Page.inwiB2C_ContractGeneration;
        Test.setCurrentPage(pageRef);
        Test.StartTest(); 
            
              List<Order> OrderTarget = [select id from Order where id in (select OrderId from orderitem where quantity > 0) limit 1];
        //ApexPages.standardSetController sc = new ApexPages.standardSetController(OrdersList);
        
        ApexPages.currentPage().getParameters().put('orderid', String.valueOf(OrderTarget[0].Id));
        ApexPages.currentPage().getParameters().put('isvivs', String.valueOf(true));
        
        inwiB2C_ContractControllerPhase4 testcall = new inwiB2C_ContractControllerPhase4();
        //testcall.inwiB2C_ContractGenerationController(sc);
        inwiB2C_ContractControllerPhase4.formatDate(Date.today());
        
        Test.StopTest();
      }
    
    	@isTest(SeeAllData=true)
    static void validateStandardController2(){
        
        //List<Contract> ListContract = [SELECT id FROM Contract where InwiB2C_Subscription_contract__r.inwib2c_type_offre__c != null and inwib2c_date_de_naissance__c != null and inwib2c_address__r.name != null limit 1];
        List<Contract> ListContract = [SELECT id FROM Contract where inwib2c_date_de_naissance__c != null and inwib2c_address__r.name != null limit 1];
        PageReference pageRef = Page.inwiB2C_ContractGeneration;
        Test.setCurrentPage(pageRef);
        Test.StartTest(); 
        ApexPages.standardSetController sc = new ApexPages.standardSetController(Database.getQueryLocator([SELECT Id FROM Order limit 2]));
        ApexPages.currentPage().getParameters().put('isvivs', String.valueOf(true));
        ApexPages.currentPage().getParameters().put('contractid', String.valueOf(ListContract[0].Id));
        ApexPages.currentPage().getParameters().put('dealer', String.valueOf(true));
        
        inwiB2C_ContractControllerPhase4 testcall = new inwiB2C_ContractControllerPhase4();
        Test.StopTest();
      }
    
        	@isTest(SeeAllData=true)
    static void validateStandardController3(){
        
        List<Contract> ListContract = [SELECT id FROM Contract where inwib2c_date_de_naissance__c != null and inwib2c_address__r.name != null limit 1];
        
        PageReference pageRef = Page.inwiB2C_ContractGeneration;
        Test.setCurrentPage(pageRef);
        Test.StartTest(); 
        ApexPages.standardSetController sc = new ApexPages.standardSetController(Database.getQueryLocator([SELECT Id FROM Order limit 2]));
        ApexPages.currentPage().getParameters().put('isvivs', String.valueOf(false));
        ApexPages.currentPage().getParameters().put('contractid', String.valueOf(ListContract[0].Id));
        ApexPages.currentPage().getParameters().put('articleNonSerailise', String.valueOf('TEST'));
        ApexPages.currentPage().getParameters().put('dealer', String.valueOf(false));
        
         // Set the page parameters for the test 
         String jsonString = '{"Adresse":"Adresse","CodePostal":"CodePostal","Email":"Email","NomTitulaire":"NomTitulaire","NumContact":"NumContact","NumContrat":"NumContrat","NumIdentifiant":"NumIdentifiant","POS":"POS","PrenomTitulaire":"PrenomTitulaire","Terminal":[{"ModeleTerminal_new":"thecontract:subscriptions|1:ModelTerminal","NumSerieTerminal":"hecontract:subscriptions|1:NumSerieTerminal","TypeMiseDispo":"Vente","prixTerminal":"thecontract:subscriptions|1:PrixTerminal"}],"TitulaireCompte":"TitulaireCompte","TypeContratDoc":"typeContratDoc","TypeContrat":"TypeContrat","TypeIdent":"TypeIdent","Ville":"Ville","dateContract":"dateContract","dateNaissance":"dateNaissance","offre":[{"FormuleChoisie":"thecontract:subscriptions|1:FormuleChoisie","ICCSIM":"thecontract:subscriptions|1:ESN_ICC_subscription","NumLigne":"thecontract:subscriptions|1:NLigne","PrixSIM":"thecontract:subscriptions|1:PrixSim","TypeOffe":"thecontract:subscriptions|1:typeOffre","TypeContrat":"TypeContrat"}],"productCode":"INWIB2C_OFFERING_TICTAC_SANS_TERMINAL"}';
         ApexPages.currentPage().getParameters().put('thejson', jsonString);
         ApexPages.currentPage().getParameters().put('isfromjson', 'true');
         inwiB2C_ContractControllerPhase4 testcall = new inwiB2C_ContractControllerPhase4();
        Test.StopTest();
      }
}