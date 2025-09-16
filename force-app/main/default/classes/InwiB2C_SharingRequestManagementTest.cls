/**
 * @description       :  classe de test pour InwiB2C_SharingRequestManagement
 * @author            : Imane Lakrari
 * @last modified on  : 23-01-2025
 * @last modified by  : Imane Lakrari
**/

@IsTest
public class InwiB2C_SharingRequestManagementTest {
    @testSetup
    static void dataFactory(){
        Contact personContact = new Contact(LastName='testContact',FirstName='testContact',Phone='212945345345',InwiB2C_CIN__c='FNR898787');
        insert personContact;
        Account testAccount = new Account(Name='Test Account',vlocity_cmt__PersonContactId__c=personContact.id);
        insert testAccount;
        InwiB2C_Region__c  region = new InwiB2C_Region__c(Name='region test',InwiB2C_RegionMdn__c='SUD');
        insert region;
        InwiB2C_Address__c adresse = new InwiB2C_Address__c (name='adresse test',InwiB2C_Region__c=region.id);
        insert adresse;
        Account serviceAccount = new Account(Name='Test Account',InwiB2C_PrenomIAM__c='siteTest',InwiB2C_NomIAM__c='siteTest',InwiB2C_Portabilite__c='Non',Inwib2c_NdOperateur__c='212545567688',inwiB2C_numero_de_designation__c='212545567688');
        insert serviceAccount;
        
        //create products
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                    ProductCode='INWIB2C_OFFERING_FTTH100MG_449DH',vlocity_cmt__Type__c= 'FTTH');
        insert prod;
        Product2 prodTerminal = new Product2(Name = 'Terminal', 
                                    Family = 'Hardware',
                                    ProductCode='INWIB2C_FOB2C_OFFERING_TERMINAL');
        insert prodTerminal;
        Product2 prodMDN = new Product2(Name = 'MSISDN', 
                                    Family = 'Hardware',
                                    ProductCode='INWIB2C_FOB2C_OFFERING_MSISDN_STANDARD');
        insert prodMDN;
        
        //create standard and custom prices
        Id pricebookId = Test.getStandardPricebookId(); 
        PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prod.Id,
                UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPriceMdn = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prodMDN.Id,
                UnitPrice = 0, IsActive = true);
        insert standardPriceMdn;
        PricebookEntry standardPriceTerminal = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prodTerminal.Id,
                UnitPrice = 0, IsActive = true);
        insert standardPriceTerminal;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prod.Id,
        UnitPrice = 12000, IsActive = true);
        insert customPrice;    
        PricebookEntry customPriceMDN = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prodMDN.Id,
        UnitPrice = 12000, IsActive = true);
        insert customPriceMDN;
        PricebookEntry customPriceTerminal = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prodTerminal.Id,
        UnitPrice = 12000, IsActive = true);
        insert customPriceTerminal;
        
        //create order and order items
        order neworder = new Order (vlocity_cmt__DefaultServiceAccountId__c=serviceAccount.id,Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder;    
        String JsonAttr='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIc0QAG","attributeid__c":"a0XAd0000021qzVMAQ","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_INSTALLDATE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"date d\'installation","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0UAd000003kQYrMAM","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Datetime","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Datetime","value":"2025-01-21T23:00:00.000Z"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIc0QAG","attributeid__c":"a0X3L0000019UhgUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_LOGIN","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Login","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JQ5VUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIc0QAG","attributeid__c":"a0X3L0000019UhpUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NOMBRE_RECURENCE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre de récurrences pour remise","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JQ5XUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIc0QAG","attributeid__c":"a0XAd000001zw8JMAQ","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_OPERATEUROI","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Operateur Infrastructure","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0UAd000003fMpFMAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"INWI","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"INWI","id":"24dde73c-ee8d-04df-13ec-2e3f4b40004b","sequence":28,"value":"INWI"}],"values":[{"displayText":"IAM","id":"466dfa46-cec2-9c73-a201-695cfb30280e","sequence":9,"value":"IAM"},{"displayText":"ORANGE","id":"a8a7c7f6-73a1-1ed9-e5c9-94fe059eaf57","sequence":19,"value":"ORANGE"},{"displayText":"INWI","id":"24dde73c-ee8d-04df-13ec-2e3f4b40004b","sequence":28,"value":"INWI"}],"selectedItem":{"displayText":"IAM","id":"466dfa46-cec2-9c73-a201-695cfb30280e","sequence":9,"value":"IAM"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIc0QAG","attributeid__c":"a0XAd000001zxtpMAA","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_STATUTPARTAGE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Statut Partage","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0UAd000003fMpGMAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Ligne Active","id":"78b8ea25-f7d8-b249-9a31-173bc04712bf","sequence":8,"value":"LA"},{"displayText":"Ligne Inactive","id":"438a54d5-d6a6-4f06-7717-f8b42fe9da37","sequence":20,"value":"LI"}],"default":[],"selectedItem":{"displayText":"Ligne Active","id":"78b8ea25-f7d8-b249-9a31-173bc04712bf","sequence":8,"value":"LA"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIc0QAG","attributeid__c":"a0XAd0000021TlBMAU","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPEPARTAGE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"type de partage","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0UAd000003iwplMAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"NA","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"NA","sequence":30,"id":"1b903b50-07f1-a9a9-56dd-cc1c9c8a2374","displayText":"NA"}],"values":[{"value":"ACTIF","sequence":8,"id":"0926f076-5819-964d-1274-958f54cc83d6","displayText":"ACTIF"},{"value":"PASSIF","sequence":20,"id":"0080ed54-3533-313b-0f27-a714345d371b","displayText":"PASSIF"},{"value":"NA","sequence":30,"id":"1b903b50-07f1-a9a9-56dd-cc1c9c8a2374","displayText":"NA"}],"selectedItem":{"value":"NA","sequence":30,"id":"1b903b50-07f1-a9a9-56dd-cc1c9c8a2374","displayText":"NA"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIc0QAG","attributeid__c":"a0XAd000001zxvRMAQ","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_WITHND","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"acces avec ND","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0UAd000003fMpHMAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}]}';
        orderItem parentItem = new OrderItem(vlocity_cmt__Action__c = 'Add', vlocity_cmt__Product2Id__c = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());   
        insert parentItem;
        String JsonAttrMDN='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIbpQAG","attributeid__c":"a0X3L0000019UhmUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_MSISDN","attributeconfigurable__c":true,"attributedisplaysequence__c":"60","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"MSISDN","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JPvlUAG","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"212545567788"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIbpQAG","attributeid__c":"a0X3L0000019UhnUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_MSISDN_PORTED","attributeconfigurable__c":true,"attributedisplaysequence__c":"180","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro à porter","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JPvmUAG","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"212545567788"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIbpQAG","attributeid__c":"a0X3L0000019UirUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_RIO","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"RIO","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JPvpUAG","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"123"},"$$AttributeDefinitionEnd$$":null}]}';
        orderItem MdnItem = new OrderItem(vlocity_cmt__Action__c = 'Add', vlocity_cmt__Product2Id__c = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonAttrMDN, PriceBookEntryId=customPriceMDN.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=100, ServiceDate=Date.Today(),vlocity_cmt__RootItemId__c=parentItem.Id,vlocity_cmt__ParentItemId__c=parentItem.Id);
        insert MdnItem;
        String JsonAttrTerminal='{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIawQAG","attributeid__c":"a0X3L0000019UhZUAU","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IMEI","attributeconfigurable__c":true,"attributedisplaysequence__c":"40","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMEI/ESN","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JPdHUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"isnotassetizable__c":false,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"AZERTY"},"$$AttributeDefinitionEnd$$":null}';
        orderItem TerminalItem = new OrderItem(vlocity_cmt__Action__c = 'Add', vlocity_cmt__Product2Id__c = prodTerminal.Id, vlocity_cmt__JSONAttribute__c = JsonAttrTerminal, PriceBookEntryId=customPriceTerminal.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=100, ServiceDate=Date.Today(),vlocity_cmt__RootItemId__c=parentItem.Id,vlocity_cmt__ParentItemId__c=parentItem.Id);
        insert TerminalItem;
        
        //create subscription
        vlocity_cmt__Subscription__c ligne = new vlocity_cmt__Subscription__c(vlocity_cmt__AccountId__c=testAccount.id,vlocity_cmt__SubscriptionNumber__c='212657768799');
        insert ligne;
        
        //create sharing requests
        InwiB2C_Commande_de_partage__c commandeP = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c=neworder.Id);
        insert commandeP;
        inwiB2C_demande_partage__c SR1 = new inwiB2C_demande_partage__c(InwiB2C_Commande_de_partage__c=commandeP.Id,InwiB2C_Statut_demande__c='SUS',InwiB2C_NumeroDesignation__c='065667687');
        insert SR1;
        inwiB2C_demande_partage__c SR2 = new inwiB2C_demande_partage__c(InwiB2C_Commande_de_partage__c=commandeP.Id,InwiB2C_Statut_demande__c='SUS',InwiB2C_NumeroDesignation__c='065667687');
        insert SR2;
        InwiB2C_Button_Action_Vula__c BAV = new InwiB2C_Button_Action_Vula__c(InwiB2C_Cancel__c=true,InwiB2C_Recycle__c=true,InwiB2C_Statut__c='SUS');
        insert BAV;
        
    }

    @isTest
    static void createNewSharingRequestTest(){
        Order order = [Select Id from Order where Account.Name='Test Account' limit 1];
        vlocity_cmt__Subscription__c ligne = [Select Id from vlocity_cmt__Subscription__c where vlocity_cmt__SubscriptionNumber__c='212657768799' limit 1];
        InwiB2C_SharingRequestManagement.createNewSharingRequest(order.Id,ligne.Id);
    }
    
         @isTest
    static void cloneSharingRequestTest(){
        Order order = [Select Id from Order where Account.Name='Test Account' limit 1];
        InwiB2C_Commande_de_partage__c commandeP = [Select Id from InwiB2C_Commande_de_partage__c where InwiB2C_Order__c=:order.Id limit 1];
        Map<String,Object> inputCloneDeg = new Map<String,Object>();
        inputCloneDeg.put('InwiB2C_Commande_de_partage__c',commandeP.id);
        inputCloneDeg.put('InwiB2C_Order__c',order.id);
        inputCloneDeg.put('InwiB2C_Statut_demande__c','MES');
        inputCloneDeg.put('InwiB2C_Motif__c','motif');
        inputCloneDeg.put('InwiB2C_Code_Motif__c','5');
        inputCloneDeg.put('InwiB2C_lineId__c','123');
        inputCloneDeg.put('InwiB2C_UUID__c','123');
        inputCloneDeg.put('InwiB2C_FirstName__c','firstName');
        inputCloneDeg.put('InwiB2C_LastName__c','lastName');
        inputCloneDeg.put('InwiB2C_Nationalid__c','Nationalid');
        inputCloneDeg.put('InwiB2C_Commentaire__c','Commentaire');
        inputCloneDeg.put('InwiB2C_Province__c','province');
        inputCloneDeg.put('InwiB2C_Code_Province__c','province');
        inputCloneDeg.put('InwiB2C_Commune__c','Comm');
        inputCloneDeg.put('InwiB2C_Code_Commune__c','comm');
        inputCloneDeg.put('inwiB2C_Quartier__c','quartier');
        inputCloneDeg.put('InwiB2C_Code_Quartier__c','quartier');
        inputCloneDeg.put('InwiB2C_Voie__c','voie');
        inputCloneDeg.put('InwiB2C_Numero_de_la_voie__c','numVoie');
        inputCloneDeg.put('InwiB2C_nd_Attribut__c','Nationalid');
		inputCloneDeg.put('newCommande','true');
        InwiB2C_SharingRequestManagement.cloneSharingRequest(inputCloneDeg);
        
    }
     @isTest
    static void searchForScopedRequestTest(){
        String jsonString = '{"InwiB2C_Numero_Partage__c":"","startDate":"","endDate":"","InwiB2C_NumeroDesignation__c":"065667687"}';
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        InwiB2C_SharingRequestManagement.searchForScopedRequest(input);
    }
         @isTest
    static void searchForUnScopedRequestTest(){
        String jsonString = '{"InwiB2C_Numero_Partage__c":"","startDate":"","endDate":"","InwiB2C_lineId__c":"","InwiB2C_Statut_demande__c":"SUS"}';
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        InwiB2C_SharingRequestManagement.searchForUnscopedRequest(input);
    }
    @isTest 
    static void getRequestStatus(){
        Map<String, Object> input=new Map<String, Object>();
        input.put('fieldName','InwiB2C_Statut_demande__c');
        InwiB2C_SharingRequestManagement.getRequestStatus(input);
        
    }
   }