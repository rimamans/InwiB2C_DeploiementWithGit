@isTest
public with sharing class inwiB2C_OrderPromotionManagementOSTest{
    @isTest(SeeAllData = true)
    public static void inwiB2C_OrderPromotionManagementOSTest(){
        inwiB2C_OrderPromotionManagementOS cls = new inwiB2C_OrderPromotionManagementOS();
        // Account
        Account testAccount = new Account();
        testAccount.Name = 'TestPromo';
        //testAccount.Inwib2c_CIN__c = 'cin';
        insert testAccount;

        // Product
        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode = 'INWIB2C_LAPTOP');
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();

        // PricebookEntry
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
        insert customPB;
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        // create contract
        Contract c = new Contract(AccountId = testAccount.Id, InwiB2C_statut_contrat__c = 'Initialise');
        insert c;

        // Order
        order neworder = new Order(Pricebook2Id = customPB.Id, inwiB2C_Statut__c = 'inwiB2C_EnCours', inwiB2C_Canal__c = 'Point de vente', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId = testAccount.Id, contractId = c.id);
        insert neworder;

        // Order Item
        String JsonAttr = '{ "INWIB2C_ACAT_MOBILE": [ { "$$AttributeDefinitionStart$$": null, "objectid__c": "01t3M000000xuJZQAY", "attributeid__c": "a0X3M000000NxkvUAC", "attributecategoryid__c": "a0W3M000002oGhPUAU", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ENGAGEMENT", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Engagement", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": true, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U3M0000013ImyUAE", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "0Month", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [ { "displayText": "Sans engagement", "id": "102adc19-1a03-524e-4b70-c98179eea478", "sequence": 10, "value": "0Month" } ], "values": [ { "displayText": "Sans engagement", "id": "102adc19-1a03-524e-4b70-c98179eea478", "sequence": 10, "value": "0Month" }, { "displayText": "12 Mois", "id": "43d82073-ac9e-d6e4-fd43-252ccd7619c5", "sequence": 20, "value": "12Months" }, { "displayText": "24 Mois", "id": "1874b54d-5b3d-6205-5fec-c5ac54e2c251", "sequence": 30, "value": "24Months" }, { "displayText": "36 Mois", "id": "b1fe82df-bda8-db5f-13f9-83226142e8db", "sequence": 40, "value": "36Months" } ], "selectedItem": { "displayText": "Sans engagement", "id": "102adc19-1a03-524e-4b70-c98179eea478", "sequence": 10, "value": "0Month" } }, "$$AttributeDefinitionEnd$$": null }, { "$$AttributeDefinitionStart$$": null, "objectid__c": "01t3M000000xuJZQAY", "attributeid__c": "a0X3M000000NxlJUAS", "attributecategoryid__c": "a0W3M000002oGhPUAU", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_PROFIL", "attributeconfigurable__c": true, "attributedisplaysequence__c": "75", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Promotion à lacquisition", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": true, "valueinnumber__c": 86911, "objecttype__c": "vlocity_cmt__ObjectClass__c", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U3M0000013In6UAE", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "86911", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [ { "displayText": "Forfait 149dhs Internet", "id": "851403ac-71b6-7b15-3bf1-7152252a11e9", "sequence": 90, "value": "86911" } ], "values": [ { "displayText": "Forfait inwi 49dhs Appels", "id": "d9f44f6f-0d36-4c8c-16af-3d89f297b537", "sequence": 10, "value": "82191" }, { "displayText": "Forfait 49dhs Appels", "id": "870a4b4e-1761-53bf-4990-0a29151c00d9", "sequence": 20, "value": "86906" }, { "displayText": "Forfait 49dhs Internet", "id": "a9497403-58b5-e252-54ad-5cc902e7afcb", "sequence": 30, "value": "86907" }, { "displayText": "Forfait 49dhs illimité RS", "id": "3f7700bb-659f-bb22-d7fc-cbc93e0bf126", "sequence": 40, "value": "86916" }, { "displayText": "Forfait 99dhs illimité RS", "id": "19b96ec1-72a4-85be-a35b-3598f662c25a", "sequence": 50, "value": "83515" }, { "displayText": "Forfait 99dhs Appels", "id": "b71b917e-a8d8-f990-010b-bf471d0da0de", "sequence": 60, "value": "86908" }, { "displayText": "Forfait 99dhs Internet", "id": "77a80d8d-0e14-f7c8-b7be-fbf5b482d0ae", "sequence": 70, "value": "86909" }, { "displayText": "Forfait 149dhs Appels", "id": "1a781060-c37d-227d-08fc-60ba11abc574", "sequence": 80, "value": "86910" }, { "displayText": "Forfait 149dhs Internet", "id": "851403ac-71b6-7b15-3bf1-7152252a11e9", "sequence": 90, "value": "86911" }, { "displayText": "Forfait 199dhs Internet", "id": "de6959bf-d9ee-792c-94a2-f0bda6bd0ce2", "sequence": 100, "value": "86913" }, { "displayText": "Forfait 199dhs Appels", "id": "28d93f79-73c9-6fd2-76ce-0e6f778226a0", "sequence": 110, "value": "86912" }, { "displayText": "Forfait 249dhs tout inclus", "id": "d5625f56-addf-d72b-0e47-666f501c7ff7", "sequence": 120, "value": "86914" }, { "displayText": "Forfait 499dhs  tout inclus", "id": "c5f27a11-ed93-8538-8f5a-c834785e9f1e", "sequence": 130, "value": "86915" }, { "displayText": "Forfait illimité inwi 99dhs Appels", "id": "d947c372-b3f7-a731-d84b-ba6f57b7983f", "sequence": 140, "value": "82194" } ], "selectedItem": { "displayText": "Forfait 149dhs Internet", "id": "851403ac-71b6-7b15-3bf1-7152252a11e9", "sequence": 90, "value": "86911" } }, "$$AttributeDefinitionEnd$$": null }, { "$$AttributeDefinitionStart$$": null, "objectid__c": "01t3M000000xuJZQAY", "attributeid__c": "a0X3M000000NxlYUAS", "attributecategoryid__c": "a0W3M000002oGhPUAU", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_REMISE_POURCENT", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Remise en % sur abonnement", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": false, "ishidden__c": true, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U3M0000013In2UAE", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Single Value", "value__c": null, "valuedatatype__c": "Number", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Number", "uiDisplayType": "Single Value", "value": null }, "$$AttributeDefinitionEnd$$": null }, { "$$AttributeDefinitionStart$$": null, "objectid__c": "01t3M000000xuJZQAY", "attributeid__c": "a0X3M000000NxllUAC", "attributecategoryid__c": "a0W3M000002oGhPUAU", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_TYPE_LIGNE", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Type de ligne", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U3M0000013In3UAE", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "GP", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [ { "displayText": "Grand Public", "id": "52bed3eb-3bd1-82aa-59a3-c4239906e71e", "sequence": 40, "value": "GP" } ], "values": [ { "id": "31754b46-f5a3-c168-9527-eaa656f439c2", "displayText": "NAFIDA_2022", "value": "NAFIDA", "sequence": 50 }, { "id": "52bed3eb-3bd1-82aa-59a3-c4239906e71e", "displayText": "Grand Public", "value": "GP", "sequence": 40 }, { "id": "bcdcfaa3-9e56-9727-5f47-be68a4ef9e15", "displayText": "Collaborateur Ona", "value": "CO", "sequence": 20 }, { "id": "f7966777-c1d1-4db4-ba45-e1982b88b467", "displayText": "Collaborateur Inwi", "value": "CI", "sequence": 10 } ], "selectedItem": { "displayText": "Grand Public", "id": "52bed3eb-3bd1-82aa-59a3-c4239906e71e", "sequence": 40, "value": "GP" } }, "$$AttributeDefinitionEnd$$": null } ] }';
        OrderItem newOrderitem = new OrderItem(vlocity_cmt__RecurringCharge__c = 100, vlocity_cmt__OneTimeCalculatedPrice__c = 100, vlocity_cmt__OneTimeCharge__c= 100, vlocity_cmt__OneTimeTotal__c = 100, InwiB2C_FMS__c = 50,InwiB2C_FMS_Catalogue__c=50, InwiB2C_FMD__c = 50,InwiB2C_FMD_Catalogue__c=50, vlocity_cmt__Action__c = 'Add', vlocity_cmt__JSONAttribute__c = JsonAttr, Product2Id = prod.Id, PriceBookEntryId = customPrice.Id, OrderId = neworder.Id, Quantity = 1, UnitPrice = customPrice.UnitPrice, ServiceDate = Date.Today());
        insert newOrderitem;

        newOrderitem.vlocity_cmt__RootItemId__c = newOrderitem.Id;
        update newOrderitem;

        // Subscription
        vlocity_cmt__Subscription__c newSubsc1 = new vlocity_cmt__Subscription__c(Inwib2c_Offre__c = 'offer1', vlocity_cmt__SubscriptionNumber__c = '06112223344', Inwib2c_Num_ro_de_la_ligne__c = '06112223344', Name = 'TEST', inwiB2C_LegacyStatus__c = 'ACTIVE', inwiB2C_Statut__c = 'InwiB2C_Active', vlocity_cmt__Status__c = 'Active', vlocity_cmt__AccountId__c = testAccount.Id);
        Insert newSubsc1;

        // Promotion
        String strDt = '25/1/2022';
        //convert String to Date(output:2018-01-25 00:00:00)
        Date dateDebut = Date.parse(strDt);
        //convert date to DateTime.Can be used in soql but not in dynamic soql(output:2018-01-25 05:00:00)
        DateTime dt = DateTime.newInstance(dateDebut.year(), dateDebut.month(), dateDebut.day(), 0, 0, 0);

        String strDF = '25/1/2024';
        //convert String to Date(output:2018-01-25 00:00:00)
        Date dateFin = Date.parse(strDF);
        //convert date to DateTime.Can be used in soql but not in dynamic soql(output:2018-01-25 05:00:00)
        DateTime df = DateTime.newInstance(dateFin.year(), dateFin.month(), dateFin.day(), 0, 0, 0);

        InwiB2C_Promotion__c promo = new InwiB2C_Promotion__c(inwiB2C_Code_Produit__c = 'INWIB2C_LAPTOP', inwiB2C_code_promotion__c = 'code', InwiB2C_date_Debut__c = dt, inwiB2C_date_fin__c = df, Name = 'promotion name', inwiB2C_Libelle_promotion__c = 'Promo test');
        insert promo;

        // Scope Determinant
        inwiB2C_scop_determinant__c scope1 = new inwiB2C_scop_determinant__c(inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_Canal__c = 'Point de vente', InwiB2C_type_acte_de_gestion__c = 'inwiB2C_Acquisition', InwiB2C_Type_d_inclution__c = 'included');
        insert scope1;

        inwiB2C_scop_determinant__c scope2 = new inwiB2C_scop_determinant__c(inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_Canal__c = 'Point de vente', InwiB2C_type_acte_de_gestion__c = 'inwiB2C_Acquisition', InwiB2C_Type_d_inclution__c = 'Cochable');
        insert scope2;

        inwiB2C_scop_determinant__c scope3 = new inwiB2C_scop_determinant__c(inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_Canal__c = 'Point de vente', InwiB2C_type_acte_de_gestion__c = 'inwiB2C_Acquisition', InwiB2C_Type_d_inclution__c = 'Cochable');
        insert scope3;

        // Determinant
        inwiB2C_determinant__c determinant1 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromo', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_field__c = 'Name');
        insert determinant1;

        inwiB2C_determinant__c determinant2 = new inwiB2C_determinant__c(inwiB2C_value__c = 'inwiB2C_EnCours', inwiB2C_scope__c = 'inwiB2C_Order', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_field__c = 'inwiB2C_Statut__c');
        insert determinant2;

        inwiB2C_determinant__c determinant3 = new inwiB2C_determinant__c(inwiB2C_scope__c = 'inwiB2C_Assets', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_Code_Produit__c = 'offer1');
        insert determinant3;

        inwiB2C_determinant__c determinant4 = new inwiB2C_determinant__c(inwiB2C_code_attribute__c = 'INWIB2C_ATT_RT_ENGAGEMENT', inwiB2C_Code_Produit__c = 'INWIB2C_LAPTOP', inwiB2C_value__c = 'cin', inwiB2C_scope__c = 'inwiB2C_Order_item', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_Valeur_attribut__c = '0Month');
        insert determinant4;

        inwiB2C_determinant__c determinant5 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromo', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope2.Id, inwiB2C_field__c = 'Name');
        insert determinant5;

        inwiB2C_determinant__c determinant6 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromo', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope2.Id, inwiB2C_field__c = 'Name');
        insert determinant6;

        inwiB2C_determinant__c determinant7 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromotion', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope3.Id, inwiB2C_field__c = 'Name');
        insert determinant7;

        // Applied Product
        inwiB2C_Applied_Product__c appliedProduct = new inwiB2C_Applied_Product__c(inwiB2C_Code_Produit__c = 'INWIB2C_LAPTOP', inwiB2C_Libelle_du_produit__c = 'libelle', inwiB2C_Promotion_discount__c = promo.Id);
        insert appliedProduct;

        // Promotion result
        inwiB2C_promotion_result__c promotionResult1 = new inwiB2C_promotion_result__c(inwiB2C_valeur_attribut__c = '50', inwiB2C_Result_type__c = 'inwiB2C_Action', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_code_attribute__c = 'INWIB2C_ATT_RT_REMISE_POURCENT');
        insert promotionResult1;

        inwiB2C_promotion_result__c promotionResult2 = new inwiB2C_promotion_result__c(inwiB2C_percent__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'FMS');
        insert promotionResult2;

        inwiB2C_promotion_result__c promotionResult3 = new inwiB2C_promotion_result__c(inwiB2C_percent__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'FMD');
        insert promotionResult3;
		
        inwiB2C_promotion_result__c promotionResult6 = new inwiB2C_promotion_result__c(InwiB2C_MontantRemise__c = 200, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'One time');
        insert promotionResult6;
        
        inwiB2C_promotion_result__c promotionResult4 = new inwiB2C_promotion_result__c(inwiB2C_percent__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'One time');
        insert promotionResult4;
        
        inwiB2C_promotion_result__c promotionResult7 = new inwiB2C_promotion_result__c(InwiB2C_MontantRemise__c = 200, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'recurring price');
        insert promotionResult7;

        inwiB2C_promotion_result__c promotionResult5 = new inwiB2C_promotion_result__c(inwiB2C_percent__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'recurring price');
        insert promotionResult5;
        

        //
        // orderItemAppliedPromotion__c orderItemAppliedPromotion = new orderItemAppliedPromotion__c();
        // orderItemAppliedPromotion.orderItemId__c = newOrderitem.Id;
        // orderItemAppliedPromotion.promotionId__c = promo.Id;

        //
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('orderItemId', newOrderitem.Id);
        inputMap.put('orderId', neworder.Id);
        inputMap.put('typeparcours','eshop');
        inputMap.put('datecreationeshop','2023-11-07T13:09:03.000Z');
        Map<String, Object> listPromotionIds = new Map<String, Object>();
        List<Map<String, Object>> data = new List<Map<String, Object>>();
        Map<String, Object> item = new Map<String, Object>();
        item.put('orderItemId', newOrderitem.Id);
        item.put('promotionId', promo.Id);
        data.add(item);
        listPromotionIds.put('data', data);
        inputMap.put('promotionIdList', listPromotionIds);
        System.debug(inputMap);
        boolean result = cls.invokeMethod('getOrderEligiblePromotions', inputMap, outMap, options);
        boolean result2 = cls.invokeMethod('applyPromotions', inputMap, outMap, options);
    }
    @isTest(SeeAllData = true)
    public static void inwiB2C_OrderPromotionManagementOSTest2(){
        inwiB2C_OrderPromotionManagementOS cls = new inwiB2C_OrderPromotionManagementOS();
        // Account
        Account testAccount = new Account();
        testAccount.Name = 'TestPromo';
        //testAccount.Inwib2c_CIN__c = 'cin';
        insert testAccount;

        // Product
        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode = 'INWIB2C_LAPTOP');
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();

        // PricebookEntry
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
        insert customPB;
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        // create contract
        Contract c = new Contract(AccountId = testAccount.Id, InwiB2C_statut_contrat__c = 'Initialise');
        insert c;

        // Order
        order neworder = new Order(Pricebook2Id = customPB.Id, inwiB2C_Statut__c = 'inwiB2C_EnCours', inwiB2C_Canal__c = 'Point de vente', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId = testAccount.Id, contractId = c.id);
        insert neworder;

        // Order Item
        String JsonAttr = '{ "INWIB2C_ACAT_MOBILE": [ { "$$AttributeDefinitionStart$$": null, "objectid__c": "01t3M000000xuJZQAY", "attributeid__c": "a0X3M000000NxkvUAC", "attributecategoryid__c": "a0W3M000002oGhPUAU", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_ENGAGEMENT", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Engagement", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": true, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U3M0000013ImyUAE", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "0Month", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [ { "displayText": "Sans engagement", "id": "102adc19-1a03-524e-4b70-c98179eea478", "sequence": 10, "value": "0Month" } ], "values": [ { "displayText": "Sans engagement", "id": "102adc19-1a03-524e-4b70-c98179eea478", "sequence": 10, "value": "0Month" }, { "displayText": "12 Mois", "id": "43d82073-ac9e-d6e4-fd43-252ccd7619c5", "sequence": 20, "value": "12Months" }, { "displayText": "24 Mois", "id": "1874b54d-5b3d-6205-5fec-c5ac54e2c251", "sequence": 30, "value": "24Months" }, { "displayText": "36 Mois", "id": "b1fe82df-bda8-db5f-13f9-83226142e8db", "sequence": 40, "value": "36Months" } ], "selectedItem": { "displayText": "Sans engagement", "id": "102adc19-1a03-524e-4b70-c98179eea478", "sequence": 10, "value": "0Month" } }, "$$AttributeDefinitionEnd$$": null }, { "$$AttributeDefinitionStart$$": null, "objectid__c": "01t3M000000xuJZQAY", "attributeid__c": "a0X3M000000NxlJUAS", "attributecategoryid__c": "a0W3M000002oGhPUAU", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_PROFIL", "attributeconfigurable__c": true, "attributedisplaysequence__c": "75", "attributefilterable__c": true, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Promotion à lacquisition", "displaysequence__c": "10", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": true, "valueinnumber__c": 86911, "objecttype__c": "vlocity_cmt__ObjectClass__c", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U3M0000013In6UAE", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "86911", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [ { "displayText": "Forfait 149dhs Internet", "id": "851403ac-71b6-7b15-3bf1-7152252a11e9", "sequence": 90, "value": "86911" } ], "values": [ { "displayText": "Forfait inwi 49dhs Appels", "id": "d9f44f6f-0d36-4c8c-16af-3d89f297b537", "sequence": 10, "value": "82191" }, { "displayText": "Forfait 49dhs Appels", "id": "870a4b4e-1761-53bf-4990-0a29151c00d9", "sequence": 20, "value": "86906" }, { "displayText": "Forfait 49dhs Internet", "id": "a9497403-58b5-e252-54ad-5cc902e7afcb", "sequence": 30, "value": "86907" }, { "displayText": "Forfait 49dhs illimité RS", "id": "3f7700bb-659f-bb22-d7fc-cbc93e0bf126", "sequence": 40, "value": "86916" }, { "displayText": "Forfait 99dhs illimité RS", "id": "19b96ec1-72a4-85be-a35b-3598f662c25a", "sequence": 50, "value": "83515" }, { "displayText": "Forfait 99dhs Appels", "id": "b71b917e-a8d8-f990-010b-bf471d0da0de", "sequence": 60, "value": "86908" }, { "displayText": "Forfait 99dhs Internet", "id": "77a80d8d-0e14-f7c8-b7be-fbf5b482d0ae", "sequence": 70, "value": "86909" }, { "displayText": "Forfait 149dhs Appels", "id": "1a781060-c37d-227d-08fc-60ba11abc574", "sequence": 80, "value": "86910" }, { "displayText": "Forfait 149dhs Internet", "id": "851403ac-71b6-7b15-3bf1-7152252a11e9", "sequence": 90, "value": "86911" }, { "displayText": "Forfait 199dhs Internet", "id": "de6959bf-d9ee-792c-94a2-f0bda6bd0ce2", "sequence": 100, "value": "86913" }, { "displayText": "Forfait 199dhs Appels", "id": "28d93f79-73c9-6fd2-76ce-0e6f778226a0", "sequence": 110, "value": "86912" }, { "displayText": "Forfait 249dhs tout inclus", "id": "d5625f56-addf-d72b-0e47-666f501c7ff7", "sequence": 120, "value": "86914" }, { "displayText": "Forfait 499dhs  tout inclus", "id": "c5f27a11-ed93-8538-8f5a-c834785e9f1e", "sequence": 130, "value": "86915" }, { "displayText": "Forfait illimité inwi 99dhs Appels", "id": "d947c372-b3f7-a731-d84b-ba6f57b7983f", "sequence": 140, "value": "82194" } ], "selectedItem": { "displayText": "Forfait 149dhs Internet", "id": "851403ac-71b6-7b15-3bf1-7152252a11e9", "sequence": 90, "value": "86911" } }, "$$AttributeDefinitionEnd$$": null }, { "$$AttributeDefinitionStart$$": null, "objectid__c": "01t3M000000xuJZQAY", "attributeid__c": "a0X3M000000NxlYUAS", "attributecategoryid__c": "a0W3M000002oGhPUAU", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_REMISE_POURCENT", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Remise en % sur abonnement", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": false, "ishidden__c": true, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U3M0000013In2UAE", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Single Value", "value__c": null, "valuedatatype__c": "Number", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Number", "uiDisplayType": "Single Value", "value": null }, "$$AttributeDefinitionEnd$$": null }, { "$$AttributeDefinitionStart$$": null, "objectid__c": "01t3M000000xuJZQAY", "attributeid__c": "a0X3M000000NxllUAC", "attributecategoryid__c": "a0W3M000002oGhPUAU", "categorycode__c": "INWIB2C_ACAT_MOBILE", "categoryname__c": "Mobile", "attributeuniquecode__c": "INWIB2C_ATT_RT_TYPE_LIGNE", "attributeconfigurable__c": true, "attributedisplaysequence__c": "1", "attributefilterable__c": false, "attributecloneable__c": true, "isactive__c": true, "attributedisplayname__c": "Type de ligne", "displaysequence__c": "null", "categorydisplaysequence__c": 10, "customconfiguitemplate__c": null, "formatmask__c": null, "hasrule__c": false, "isconfigurable__c": true, "ishidden__c": false, "valueinnumber__c": null, "objecttype__c": "Product2", "querycode__c": null, "isreadonly__c": false, "isnottranslatable__c": false, "isquerydriven__c": false, "querylabel__c": null, "id": "a0U3M0000013In3UAE", "isrequired__c": false, "rulemessage__c": null, "uidisplaytype__c": "Dropdown", "value__c": "GP", "valuedatatype__c": "Picklist", "valuedescription__c": null, "attributegrouptype__c": null, "attributeRunTimeInfo": { "dataType": "Picklist", "uiDisplayType": "Dropdown", "default": [ { "displayText": "Grand Public", "id": "52bed3eb-3bd1-82aa-59a3-c4239906e71e", "sequence": 40, "value": "GP" } ], "values": [ { "id": "31754b46-f5a3-c168-9527-eaa656f439c2", "displayText": "NAFIDA_2022", "value": "NAFIDA", "sequence": 50 }, { "id": "52bed3eb-3bd1-82aa-59a3-c4239906e71e", "displayText": "Grand Public", "value": "GP", "sequence": 40 }, { "id": "bcdcfaa3-9e56-9727-5f47-be68a4ef9e15", "displayText": "Collaborateur Ona", "value": "CO", "sequence": 20 }, { "id": "f7966777-c1d1-4db4-ba45-e1982b88b467", "displayText": "Collaborateur Inwi", "value": "CI", "sequence": 10 } ], "selectedItem": { "displayText": "Grand Public", "id": "52bed3eb-3bd1-82aa-59a3-c4239906e71e", "sequence": 40, "value": "GP" } }, "$$AttributeDefinitionEnd$$": null } ] }';
        OrderItem newOrderitem = new OrderItem(vlocity_cmt__RecurringCharge__c = 100, vlocity_cmt__OneTimeCalculatedPrice__c = 100, vlocity_cmt__OneTimeCharge__c= 100, vlocity_cmt__EffectiveOneTimeTotal__c = 100, vlocity_cmt__OneTimeTotal__c = 100, InwiB2C_FMS__c = 50,InwiB2C_FMS_Catalogue__c=50, InwiB2C_FMD__c = 50,InwiB2C_FMD_Catalogue__c=50, vlocity_cmt__Action__c = 'Add', vlocity_cmt__JSONAttribute__c = JsonAttr, Product2Id = prod.Id, PriceBookEntryId = customPrice.Id, OrderId = neworder.Id, Quantity = 1, UnitPrice = customPrice.UnitPrice, ServiceDate = Date.Today());
        insert newOrderitem;

        newOrderitem.vlocity_cmt__RootItemId__c = newOrderitem.Id;
        update newOrderitem;

        // Subscription
        vlocity_cmt__Subscription__c newSubsc1 = new vlocity_cmt__Subscription__c(Inwib2c_Offre__c = 'offer1', vlocity_cmt__SubscriptionNumber__c = '06112223344', Inwib2c_Num_ro_de_la_ligne__c = '06112223344', Name = 'TEST', inwiB2C_LegacyStatus__c = 'ACTIVE', inwiB2C_Statut__c = 'InwiB2C_Active', vlocity_cmt__Status__c = 'Active', vlocity_cmt__AccountId__c = testAccount.Id);
        Insert newSubsc1;

        // Promotion
        String strDt = '25/1/2022';
        //convert String to Date(output:2018-01-25 00:00:00)
        Date dateDebut = Date.parse(strDt);
        //convert date to DateTime.Can be used in soql but not in dynamic soql(output:2018-01-25 05:00:00)
        DateTime dt = DateTime.newInstance(dateDebut.year(), dateDebut.month(), dateDebut.day(), 0, 0, 0);

        String strDF = '25/1/2024';
        //convert String to Date(output:2018-01-25 00:00:00)
        Date dateFin = Date.parse(strDF);
        //convert date to DateTime.Can be used in soql but not in dynamic soql(output:2018-01-25 05:00:00)
        DateTime df = DateTime.newInstance(dateFin.year(), dateFin.month(), dateFin.day(), 0, 0, 0);

        InwiB2C_Promotion__c promo = new InwiB2C_Promotion__c( inwiB2C_code_promotion__c = 'code', InwiB2C_date_Debut__c = dt, inwiB2C_date_fin__c = df, Name = 'promotion name', inwiB2C_Libelle_promotion__c = 'Promo test');
        insert promo;

        // Scope Determinant
        inwiB2C_scop_determinant__c scope1 = new inwiB2C_scop_determinant__c(inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_Canal__c = 'Point de vente', InwiB2C_type_acte_de_gestion__c = 'inwiB2C_Acquisition', InwiB2C_Type_d_inclution__c = 'included');
        insert scope1;

        inwiB2C_scop_determinant__c scope2 = new inwiB2C_scop_determinant__c(inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_Canal__c = 'Point de vente', InwiB2C_type_acte_de_gestion__c = 'inwiB2C_Acquisition', InwiB2C_Type_d_inclution__c = 'Cochable');
        insert scope2;

        inwiB2C_scop_determinant__c scope3 = new inwiB2C_scop_determinant__c(inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_Canal__c = 'Point de vente', InwiB2C_type_acte_de_gestion__c = 'inwiB2C_Acquisition', InwiB2C_Type_d_inclution__c = 'Cochable');
        insert scope3;

        // Determinant
        inwiB2C_determinant__c determinant1 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromo', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_field__c = 'Name');
        insert determinant1;

        inwiB2C_determinant__c determinant2 = new inwiB2C_determinant__c(inwiB2C_value__c = 'inwiB2C_EnCours', inwiB2C_scope__c = 'inwiB2C_Order', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_field__c = 'inwiB2C_Statut__c');
        insert determinant2;

        inwiB2C_determinant__c determinant3 = new inwiB2C_determinant__c(inwiB2C_scope__c = 'inwiB2C_Assets', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_Code_Produit__c = 'offer1');
        insert determinant3;

        inwiB2C_determinant__c determinant4 = new inwiB2C_determinant__c(inwiB2C_code_attribute__c = 'INWIB2C_ATT_RT_ENGAGEMENT', inwiB2C_Code_Produit__c = 'INWIB2C_LAPTOP', inwiB2C_value__c = 'cin', inwiB2C_scope__c = 'inwiB2C_Order_item', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_Valeur_attribut__c = '0Month');
        insert determinant4;

        inwiB2C_determinant__c determinant5 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromo', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope2.Id, inwiB2C_field__c = 'Name');
        insert determinant5;

        inwiB2C_determinant__c determinant6 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromo', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope2.Id, inwiB2C_field__c = 'Name');
        insert determinant6;

        inwiB2C_determinant__c determinant7 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromotion', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope3.Id, inwiB2C_field__c = 'Name');
        insert determinant7;

        // Applied Product
        inwiB2C_Applied_Product__c appliedProduct = new inwiB2C_Applied_Product__c(inwiB2C_Code_Produit__c = 'INWIB2C_LAPTOP', inwiB2C_Libelle_du_produit__c = 'libelle', inwiB2C_Promotion_discount__c = promo.Id);
        insert appliedProduct;

        // Promotion result
        inwiB2C_promotion_result__c promotionResult1 = new inwiB2C_promotion_result__c(inwiB2C_valeur_attribut__c = '50', inwiB2C_Result_type__c = 'inwiB2C_Action', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_code_attribute__c = 'INWIB2C_ATT_RT_REMISE_POURCENT');
        insert promotionResult1;

        inwiB2C_promotion_result__c promotionResult2 = new inwiB2C_promotion_result__c(InwiB2C_MontantRemise__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'FMS');
        insert promotionResult2;

        inwiB2C_promotion_result__c promotionResult3 = new inwiB2C_promotion_result__c(InwiB2C_MontantRemise__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'FMD');
        insert promotionResult3;
        
       // inwiB2C_promotion_result__c promotionResult4 = new inwiB2C_promotion_result__c(inwiB2C_percent__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'One time');
        //insert promotionResult4;

        inwiB2C_promotion_result__c promotionResult5 = new inwiB2C_promotion_result__c(inwiB2C_percent__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'recurring price');
        insert promotionResult5;
        

        //
        // orderItemAppliedPromotion__c orderItemAppliedPromotion = new orderItemAppliedPromotion__c();
        // orderItemAppliedPromotion.orderItemId__c = newOrderitem.Id;
        // orderItemAppliedPromotion.promotionId__c = promo.Id;

        //
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('orderItemId', newOrderitem.Id);
        inputMap.put('orderId', neworder.Id);
        inputMap.put('typeparcours','eshop');
        inputMap.put('datecreationeshop','2023-11-07T13:09:03.000Z');
        Map<String, Object> listPromotionIds = new Map<String, Object>();
        List<Map<String, Object>> data = new List<Map<String, Object>>();
        Map<String, Object> item = new Map<String, Object>();
        item.put('orderItemId', newOrderitem.Id);
        item.put('promotionId', promo.Id);
        data.add(item);
        listPromotionIds.put('data', data);
        inputMap.put('promotionIdList', listPromotionIds);
        System.debug(inputMap);
        boolean result = cls.invokeMethod('getOrderEligiblePromotions', inputMap, outMap, options);
        boolean result2 = cls.invokeMethod('applyPromotions', inputMap, outMap, options);
    }

}