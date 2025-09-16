@isTest
public  class InwiB2C_Calcule_CAUT_FMSFMDTest {
 @isTest(SeeAllData=true)
   	 static void testCallVIP()
{
    InwiB2C_MONT_CAUT_FMSFMD__c caution = new InwiB2C_MONT_CAUT_FMSFMD__c(InwiB2C_Code_Offre__c='INWIB2C_OFFERING_FORMULE2_249DH',InwiB2C_DUREE_ENGAGEMENT__c=0,InwiB2C_IS_PORTABILITY__c='ALL',InwiB2C_ISBLACKLISTED__c='False',InwiB2C_M_Type_Client__c='GP',InwiB2C_TYPE_HANDSET__c='ALL');
    insert caution;
    //chb 20/02/2024 ANO B-14377 Begin */
     Account testAccount = new Account();
    testAccount.Name = 'Test Account';
    insert testAccount;

    Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode = 'INWIB2C_OFFERING_FORMULE2_249DH');
    insert prod;

    Id pricebookId = Test.getStandardPricebookId();

    PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
    insert standardPrice;

    Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
    insert customPB;

    PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
    insert customPrice;
    // create contract
    Contract c = new Contract(AccountId = testAccount.Id, InwiB2C_statut_contrat__c = 'Initialise');
    insert c;
    order neworder = new Order(Pricebook2Id = customPB.Id, inwiB2C_Statut__c = 'inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId = testAccount.Id, contractId = c.id);
    insert neworder;

    String JsonAttr = '{ "INWIB2C_ACAT_MOBILE": [ { "objectid__c": "01t3M000000xuJaQAI", "attributeid__c": "a0X3M000000NxllUAC", "attributecategoryid__c": "a0W3M000002oGhPUAU", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_TYPE_LIGNE", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Type de ligne", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U3M0000013Io4UAE", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "GP", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [ { "displayText": "Grand Public", "id": "52bed3eb-3bd1-82aa-59a3-c4239906e71e", "sequence": 40, "value": "GP" } ], "values": [ { "displayText": "Collaborateur Inwi", "id": "f7966777-c1d1-4db4-ba45-e1982b88b467", "sequence": 10, "value": "CI" }, { "displayText": "Collaborateur Ona", "id": "bcdcfaa3-9e56-9727-5f47-be68a4ef9e15", "sequence": 20, "value": "CO" }, { "displayText": "Famille Inwi", "id": "478db15d-0361-49e2-65a4-f08ea290dc3d", "sequence": 30, "value": "FA" }, { "displayText": "Grand Public", "id": "52bed3eb-3bd1-82aa-59a3-c4239906e71e", "sequence": 40, "value": "GP" }, { "displayText": "NAFIDA_2021", "id": "31754b46-f5a3-c168-9527-eaa656f439c2", "sequence": 50, "value": "NAFIDA" }, { "displayText": "Premium", "id": "db84de6f-7fb8-ccc9-27b5-6d7f0b149465", "sequence": 60, "value": "PR" }, { "displayText": "Étudiant campus connecté", "id": "f6fdb875-aad2-0e24-5c5e-c130e00ffb4d", "sequence": 70, "value": "CP" }, { "displayText": "Tombola", "id": "eeae476f-044b-7363-cbbf-1c8aa53f9b00", "sequence": 80, "value": "TB" } ], "selectedItem": { "displayText": "Grand Public", "id": "52bed3eb-3bd1-82aa-59a3-c4239906e71e", "sequence": 40, "value": "GP" } }, "$$AttributeDefinitionEnd$$": null } ] }';

    OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId = customPrice.Id, OrderId = neworder.Id, Quantity = 1, UnitPrice = customPrice.UnitPrice, ServiceDate = Date.Today());
    insert newOrderitem;
    String firstinput='{"CSOrderScor":{"targetOperator":"mTelecom","seniority":0,"AdditionelCretera":[{"Value":"","Code":""}],"typeClient":"GP","isPorrtability":"NON","isBlackListed":"False","handSetType":"Term","engagementDuration":0,"Isterminal":"TRUE","offre":"INWIB2C_OFFERING_FORMULE2_249DH","Id":"'+newOrderitem.Id+'"}}';
    //chb 20/02/2024 ANO B-14377 end */  
    Map<String,Object> input =  (Map<String, Object>)JSON.deserializeUntyped(firstinput);
    Map<String,Object> options = new  Map<String,Object>();
	Map<String,Object> output= new  Map<String,Object>();
	InwiB2C_Calcule_CAUT_FMSFMD cls= new InwiB2C_Calcule_CAUT_FMSFMD();
	cls.invokeMethod('Calculs_Values',input,output,options);
   
}

}