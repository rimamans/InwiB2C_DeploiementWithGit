@isTest 
public class InwiB2C_GetOfferPostTest {
@isTest (SeeAllData=true)
    static void InwiB2C_GetOfferPostTest(){
         Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
       //create Acc
       
    Account testAccount = new Account();
    testAccount.Name = 'Test Account';
    insert testAccount;
 String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJaQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86906,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013Io7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86906","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Forfait 49dhs Appels","id":"870a4b4e-1761-53bf-4990-0a29151c00d9","sequence":20,"value":"86906"}],"values":[{"id":"870a4b4e-1761-53bf-4990-0a29151c00d9","displayText":"Forfait 49dhs Appels","value":"86906","sequence":20},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"displayText":"Forfait 49dhs Appels","id":"870a4b4e-1761-53bf-4990-0a29151c00d9","sequence":20,"value":"86906"}},"$$AttributeDefinitionEnd$$":null}]}';
    
    Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware',vlocity_cmt__JSONAttribute__c=JsonAttr, ProductCode = 'INWIB2C_OFFERING_49DH_APL');
    insert prod;

    Id pricebookId = Test.getStandardPricebookId();

    PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
    insert standardPrice;

/*    Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
    insert customPB;

    PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
    insert customPrice;
    // create contract
    
    order neworder = new Order(Pricebook2Id = customPB.Id, inwiB2C_Statut__c = 'inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId = testAccount.Id);
    insert neworder;*/
 //get offer 
        InwiB2C_Offer__c newOffer = new InwiB2C_Offer__c();
        newOffer.Offre_Cible__c='INWIB2C_OFFERING_49DH_APL';
        newOffer.Offre_Source__c='INWIB2C_OFFERING_ILIM_INW2H5GO';
        insert newOffer;
    	INWIB2C_FRAIS_MGR_CML__c newOfferCam = new INWIB2C_FRAIS_MGR_CML__c();
        newOfferCam.INWIB2C_OFFRE_DESTINATION__c = 'INWIB2C_OFFERING_CAM_INW2H5GO';
        newOfferCam.INWIB2C_OFFRE_SOURCE__c = 'INWIB2C_OFFERING_50DH_APL';
        insert newOfferCam;
        
     /*   OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId = customPrice.Id, OrderId = neworder.Id, Quantity = 1, UnitPrice = customPrice.UnitPrice, ServiceDate = Date.Today());
         insert newOrderitem;
        Asset asset1 = new Asset(Name = 'Test Asset',Status = 'Installed',AccountId = testAccount.Id,InstallDate = System.Today(), Product2Id = prod.Id,UsageEndDate = System.Today(),vlocity_cmt__OrderProductId__c = newOrderitem.Id,vlocity_cmt__JSONAttribute__c=JsonAttr,vlocity_cmt__RecurringCharge__c=90);
         insert asset1;
   */

        
 
       
        inputMap.put('offresource',newOffer.Offre_Cible__c);
        inputMap.put('typeoffre',newOfferCam.INWIB2C_OFFRE_DESTINATION__c);
        new InwiB2C_GetOfferPost().invokeMethod('getOffer',inputMap,outMap,options);
        
    }
}