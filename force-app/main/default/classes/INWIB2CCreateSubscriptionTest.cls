@IsTest
    public class INWIB2CCreateSubscriptionTest {
    
        @isTest(SeeAllData=false)
        public static void batchOrderTest() {
            Account testAccount = new Account(Name='Test Account',InwiB2C_Date_modification_HV__c=null);
            insert testAccount;
            /* Begin JBE */
            Test.startTest();
            
            vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
			insert VloPickList;
            
            vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
			insert VloPickList1;
            
            vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
			insert VloPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList;
            
            vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList1;
            
            vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
            insert NewPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
            insert NewPickList3;
            
            system.debug('PICKLIST : '+ NewPickList2);

            
            Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'Postpaye',INWIB2C_ShowHV__c=true);
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
                        // create contract
                 Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
                 insert c;
            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id);
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNUUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_TypHandset","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type Handset","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}],"values":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"},{"value":"TERM","sequence":20,"id":"b1e73d9a-7aba-cd66-f5b8-bedaa7b3da92","displayText":"TERM"}],"selectedItem":{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OYtrUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_CUSTRISKPLAF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Plafond Risque Personnalisé","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":-999,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001AnFzUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":"-999","valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","default":"-999","value":"-999"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYupUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_ElligibleAuTypeLigne","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Elligible au type de ligne","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYuuUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_NUMERO_ADHERANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro adhérant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxklUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InDUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkmUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InEUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkvUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ENGAGEMENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Engagement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"0","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}],"values":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"},{"value":"12","sequence":20,"id":"43d82073-ac9e-d6e4-fd43-252ccd7619c5","displayText":"12 Mois"},{"value":"24","sequence":30,"id":"1874b54d-5b3d-6205-5fec-c5ac54e2c251","displayText":"24 Mois"}],"selectedItem":{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkyUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_GAMME_OFFRE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Gamme offre","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GALAXY","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}],"values":[{"value":"AMY","sequence":10,"id":"538aeaef-176d-2f05-c1aa-7a46eeb6fe46","displayText":"forfait Famille"},{"value":"BATMAN","sequence":20,"id":"da7bdac4-13d9-edd9-c1b3-89cd3a3c7221","displayText":"Batman"},{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"},{"value":"SW2","sequence":40,"id":"5ea7bea2-ea69-1f03-9458-4bbfd69eef24","displayText":"Star wars"},{"value":"PIZZA","sequence":50,"id":"d9f33766-032b-9ad5-3fd5-7d9444a61ce4","displayText":"Pizza"}],"selectedItem":{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlAUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NOMBRE_RECURENCE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre de récurrences pour remise","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86907,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InFUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86907","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}],"values":[{"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet","value":"86907","sequence":30},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlQUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_DIRHAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en Dh sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlYUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_POURCENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en % sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxllUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InCUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}],"values":[{"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public","value":"GP","sequence":40}],"selectedItem":{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTVUA4","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFAPP","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Application à partir de la nièm facture","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhDUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTaUAO","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFDIF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en différée","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNZUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_EXISTXGO","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Exist XGo","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"NON","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}],"values":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"},{"value":"OUI","sequence":20,"id":"16ef43d9-9e0b-20e6-aa23-e8bfbcf36257","displayText":"OUI"}],"selectedItem":{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}},"$$AttributeDefinitionEnd$$":null}]}';           
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
            
                           //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef1;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef1;

            vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder.Id);
            insert planId1;


            vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__OrderId__c=neworder.Id);
            insert FRId1;



            vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
            insert FRLine1;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
            insert FRLineDecom1;

            vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item3;

            System.debug('Item Name : ' +item3.Name);

            vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item4;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling1.add(item3);
            allItemsGenBilling1.add(item4);
            
            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
            InwiItemCreate1.executeBatch(allItemsGenBilling1);
            
                        ///////////////////////////////////////
            Product2 prodTerminal = new Product2(Name = 'Laptop X201', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_TERMINAL');
            insert prodTerminal;
            
            Id pricebookId1 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceTerminal = new PricebookEntry(
                Pricebook2Id = pricebookId1, Product2Id = prodTerminal.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceTerminal;
            
            Pricebook2 customPB1 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB1;
            
            PricebookEntry customPrice1 = new PricebookEntry(
                Pricebook2Id = customPB1.Id, Product2Id = prodTerminal.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice1;
            // create contract
            Contract c1=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c1;
            
            order neworder1 = new Order (Pricebook2Id = customPB1.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',inwiB2C_TypeActeDeGestion__c ='inwiB2C_Resiliation4G', Status = 'Draft', AccountId =testAccount.Id,ContractId=c1.id);
            insert neworder1;

            InwiB2C_Migration2G4G__c NewMigration = new InwiB2C_Migration2G4G__c(InwiB2C_OrderResiliation4G__c=neworder1.Id);
			Insert NewMigration;
            
            String JsonTerminal =  '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000063RMvAAM","attributeid__c":"a0X25000003WKyaEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_MODELE","attributeconfigurable__c":true,"attributedisplaysequence__c":"55","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modèle","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003wNKDEA2","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Samsung Galaxy A01 CORE","id":"44900b4b-a6cf-7e7e-25c7-3641f1e29c43","sequence":10,"value":"100001702"},{"displayText":"Samsung Galaxy A31","id":"2ecfff2c-17bf-d824-fdc9-e531b57a3316","sequence":20,"value":"100001685"},{"displayText":"Samsung Galaxy Note 20","id":"ebcbf96a-d180-dd53-1b6f-2a767a626f94","sequence":30,"value":"100001710"},{"displayText":"Samsung Galaxy Note 20 Ultra","id":"151bd122-ccfd-a207-fe50-134c107d3a3a","sequence":40,"value":"100001709"},{"displayText":"SAMSUNG GALAXY A11","id":"b44fbb33-8783-15c5-dba0-cc7d047f5bd1","sequence":50,"value":"100001684"},{"displayText":"APPLE IPHONE 6 SPACE GREY","id":"466ef9c9-c1da-6ad0-c990-cb6b390ee719","sequence":60,"value":"47355"},{"displayText":"APPLE IPHONE 6 SILVER","id":"96833b3a-b332-89c0-9210-c9233b46a4e3","sequence":70,"value":"47415"},{"displayText":"APPLE IPHONE 6 GOLD","id":"0e8a004e-17dd-bc6b-79a8-01a74eef37af","sequence":80,"value":"47375"},{"displayText":"APPLE iPhone 6s Or 16 Go","id":"48a23652-6517-eae9-c438-3f4b2f4aeecc","sequence":90,"value":"52577"},{"displayText":"APPLE iPhone 6s Or Rose 16 Go","id":"fe64930a-2d10-d281-9e4e-bdb09e28faec","sequence":100,"value":"52576"},{"displayText":"Modem Alactel One Touch","id":"82983c3a-fc9f-4340-3fd1-e3d23076e071","sequence":110,"value":"0000123"},{"displayText":"Modem INWI","id":"9d6a2f3b-bb09-db20-eebc-c6fc6cee6ec9","sequence":120,"value":"1234"},{"displayText":"Alcatel Wifi","id":"993ae7af-1d35-69ac-169d-5afe2f7231c2","sequence":130,"value":"12345"},{"displayText":"BOX ZTE","id":"4ed9522d-c6e5-391b-3de2-1aa275de4ada","sequence":140,"value":"123456"},{"displayText":"Huawei B310S","id":"671ce0ea-0194-90ef-9ae8-38d02b4f9133","sequence":150,"value":"1234567"},{"displayText":"HUAWEI P30 DK","id":"624c7f6d-f735-41b3-6094-6f9c80c1c55f","sequence":160,"value":"58213"},{"displayText":"HUAWEI P30 PR","id":"b04fbac8-8eea-172f-0bf4-af4d28ebb51e","sequence":170,"value":"58214"},{"displayText":"WIKO U PULSE DARK LTE","id":"4b683c83-33ad-acf4-b422-c63adb73fd1f","sequence":180,"value":"55801"},{"displayText":"WIKO U PULSE GOLD LTE","id":"2b4609fa-3dbb-90b2-a1ec-75d32ab3192c","sequence":190,"value":"55802"},{"displayText":"NOKIA 3 SILVER","id":"49e71cd0-640c-e93f-1ea5-8c71fcd14829","sequence":200,"value":"55021"},{"displayText":"NOKIA 3 DARK","id":"ea71ba40-823c-ecb6-c769-7ab5c5d0a913","sequence":210,"value":"55037"}],"default":[],"selectedItem":{"displayText":"Samsung Galaxy A01 CORE","id":"44900b4b-a6cf-7e7e-25c7-3641f1e29c43","sequence":10,"value":"100001702"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000063RMvAAM","attributeid__c":"a0X25000003WKyVEAW","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IMEI","attributeconfigurable__c":true,"attributedisplaysequence__c":"40","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMEI/ESN","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003wNJyEAM","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"900000000000962"},"$$AttributeDefinitionEnd$$":null}]}';
            
            OrderItem newOrderitemTerminal = new OrderItem(Product2Id = prodTerminal.Id , vlocity_cmt__JSONAttribute__c = JsonTerminal, PriceBookEntryId=customPrice1.Id, OrderId=neworder1.Id, Quantity=1, UnitPrice=customPrice1.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemTerminal;
            
                vlocity_cmt__Subscription__c newSubsc1=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223344',Inwib2c_Num_ro_de_la_ligne__c='0611223344',Name='TEST',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
                 Insert newSubsc1;
                
               //Create and Insert Asset
            Asset asset2 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodTerminal.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemTerminal.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc1.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset2;
            
            newOrderitemTerminal.vlocity_cmt__AssetId__c = asset2.Id;
            Update newOrderitemTerminal;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl2 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef2 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef2;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef2 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef2.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl2.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef2;

            vlocity_cmt__OrchestrationPlan__c planId2 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder1.Id);
            insert planId2;


            vlocity_cmt__FulfilmentRequest__c FRId2 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId2.Id,
            vlocity_cmt__OrderId__c=neworder1.Id);
            insert FRId2;



            vlocity_cmt__FulfilmentRequestLine__c FRLine2 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId2.Id); 
            insert FRLine2;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom2 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine2.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitemTerminal.Id);
            insert FRLineDecom2;

            vlocity_cmt__OrchestrationItem__c item5 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId2.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine2.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemTerminal.Id);
            insert item5;

            vlocity_cmt__OrchestrationItem__c item6 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId2.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine2.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemTerminal.Id);
            insert item6;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling3 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling3.add(item5);
            allItemsGenBilling3.add(item6);


            
            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            INWIB2CCreateSubscription InwiItemCreate2 = new INWIB2CCreateSubscription();
            InwiItemCreate2.executeBatch(allItemsGenBilling3);

        }
        
        @isTest(SeeAllData=false)
        public static void batchOrderTest2(){
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
                        
            Product2 prodMDN = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN;
            
            Id pricebookId2 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN = new PricebookEntry(
                Pricebook2Id = pricebookId2, Product2Id = prodMDN.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN;
            
            
            Pricebook2 customPB2 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB2;
          
            
            PricebookEntry customPrice2 = new PricebookEntry(
                Pricebook2Id = customPB2.Id, Product2Id = prodMDN.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice2;
            
            // create contract
            Contract c2=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c2;
            order neworder2 = new Order (Pricebook2Id = customPB2.Id,inwiB2C_TypeDeSuspension__c='International', inwiB2C_MotifDeSuspension__c ='Fraude', inwiB2C_TypeActeDeGestion__c='inwiB2C_Suspension', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworder2;
            
            String JsonMDN = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';

            OrderItem newOrderitemMDN = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworder2.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN;
            
            vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223355',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc;

               //Create and Insert Asset
            Asset asset = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset.Id;
            Update newOrderitemMDN;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef;

            vlocity_cmt__OrchestrationPlan__c planId = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder2.Id);
            insert planId;


            vlocity_cmt__FulfilmentRequest__c FRId = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId.Id,
            vlocity_cmt__OrderId__c=neworder2.Id);
            insert FRId;



            vlocity_cmt__FulfilmentRequestLine__c FRLine = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId.Id); 
            insert FRLine;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitemMDN.Id);
            insert FRLineDecom;

            vlocity_cmt__OrchestrationItem__c item1 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN.Id);
            insert item1;

            System.debug('Item Name : ' +item1.Name);

            vlocity_cmt__OrchestrationItem__c item2 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN.Id);
            insert item2;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling.add(item1);
            allItemsGenBilling.add(item2);


            
            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            INWIB2CCreateSubscription InwiItemCreate = new INWIB2CCreateSubscription();
            InwiItemCreate.executeBatch(allItemsGenBilling);
            
            /////////////////////////////////////////
            //
               contact listContact =new contact(FirstName='Jawad',AccountId =testAccount.Id,  LastName='Bentaybi',InwiB2C_CIN__c='BE110011',InwiB2C_Type_CIN__c ='Passeport');
            insert listContact;
            
            testAccount.vlocity_cmt__PersonContactId__c = listContact.Id;
            Update testAccount;
            
            Product2 prodMDN1  = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN1;
            
            Id pricebookId3 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN1 = new PricebookEntry(
                Pricebook2Id = pricebookId3, Product2Id = prodMDN1.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN1;
            
            
            Pricebook2 customPB3 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB3;
          
            
            PricebookEntry customPrice3 = new PricebookEntry(
                Pricebook2Id = customPB3.Id, Product2Id = prodMDN1.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice3;

            // create contract
            Contract c3=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c3;
            order neworder3 = new Order (Pricebook2Id = customPB3.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,contractId=c3.Id);
            insert neworder3;
            
            String JsonMDN1 = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitemMDN1 = new OrderItem(Product2Id = prodMDN1.Id, vlocity_cmt__JSONAttribute__c = JsonMDN1, PriceBookEntryId=customPrice3.Id, OrderId=neworder3.Id, Quantity=1, UnitPrice=customPrice3.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN1;
            
            vlocity_cmt__Subscription__c newSubsc2=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223366',Inwib2c_Num_ro_de_la_ligne__c='0611223366',Name='TEST3',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc2;

               //Create and Insert Asset
            Asset asset3 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN1.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN1.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc2.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset3;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset3.Id;
            Update newOrderitemMDN1;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl3 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef3 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef3;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef3 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef3.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl3.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef3;

            vlocity_cmt__OrchestrationPlan__c planId3 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder3.Id);
            insert planId3;


            vlocity_cmt__FulfilmentRequest__c FRId3 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__OrderId__c=neworder3.Id);
            insert FRId3;

            vlocity_cmt__FulfilmentRequestLine__c FRLine3 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId3.Id); 
            insert FRLine3;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom3 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine3.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitemMDN1.Id);
            insert FRLineDecom3;

            vlocity_cmt__OrchestrationItem__c item7 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item7;

            vlocity_cmt__OrchestrationItem__c item8 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item8;

            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling4 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling4.add(item7);
            allItemsGenBilling4.add(item8);

            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            INWIB2CCreateSubscription InwiItemCreate4 = new INWIB2CCreateSubscription();
            InwiItemCreate4.executeBatch(allItemsGenBilling4);
            //////////////////////////////////////
            //

        }
        
        
        @isTest(SeeAllData=false)
        public static void batchOrderTest3(){
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;

            
            
            //////////////////////////////////////////
    
				    Product2 prodMDN = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN;
            
            Id pricebookId2 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN = new PricebookEntry(
                Pricebook2Id = pricebookId2, Product2Id = prodMDN.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN;
            
            
            Pricebook2 customPB2 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB2;
          
            
            PricebookEntry customPrice2 = new PricebookEntry(
                Pricebook2Id = customPB2.Id, Product2Id = prodMDN.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice2;
            
            // create contract
            Contract c2=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c2;
            order neworder2 = new Order (Pricebook2Id = customPB2.Id,inwiB2C_TypeDeSuspension__c='International', inwiB2C_MotifDeSuspension__c ='Fraude', inwiB2C_TypeActeDeGestion__c='inwiB2C_Suspension', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworder2;
            
            String JsonMDN = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';

            OrderItem newOrderitemMDN = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworder2.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN;
            
            vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223355',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc;

               //Create and Insert Asset
            Asset asset = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset.Id;
            Update newOrderitemMDN;
            
            //////////////////////////////////////////
    
            
            
            contact listContact =new contact(FirstName='Jawad',AccountId =testAccount.Id,  LastName='Bentaybi',InwiB2C_CIN__c='BE110011',InwiB2C_Type_CIN__c ='Passeport');
            insert listContact;
            
            testAccount.vlocity_cmt__PersonContactId__c = listContact.Id;
            Update testAccount;
            
            Product2 prodMDN1  = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN1;
            
            Id pricebookId3 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN1 = new PricebookEntry(
                Pricebook2Id = pricebookId3, Product2Id = prodMDN1.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN1;
            
            
            Pricebook2 customPB3 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB3;
          
            
            PricebookEntry customPrice3 = new PricebookEntry(
                Pricebook2Id = customPB3.Id, Product2Id = prodMDN1.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice3;

            // create contract
            Contract c3=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c3;
            order neworder3 = new Order (Pricebook2Id = customPB3.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,contractId=c3.Id);
            insert neworder3;
            
            String JsonMDN1 = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitemMDN1 = new OrderItem(Product2Id = prodMDN1.Id, vlocity_cmt__JSONAttribute__c = JsonMDN1, PriceBookEntryId=customPrice3.Id, OrderId=neworder3.Id, Quantity=1, UnitPrice=customPrice3.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN1;
            
            vlocity_cmt__Subscription__c newSubsc2=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223366',Inwib2c_Num_ro_de_la_ligne__c='0611223366',Name='TEST3',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc2;

               //Create and Insert Asset
            Asset asset3 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN1.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN1.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc2.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset3;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset3.Id;
            Update newOrderitemMDN1;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl3 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef3 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef3;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef3 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef3.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl3.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef3;

            vlocity_cmt__OrchestrationPlan__c planId3 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder3.Id);
            insert planId3;


            vlocity_cmt__FulfilmentRequest__c FRId3 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__OrderId__c=neworder3.Id);
            insert FRId3;

            vlocity_cmt__FulfilmentRequestLine__c FRLine3 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId3.Id); 
            insert FRLine3;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom3 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine3.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitemMDN1.Id);
            insert FRLineDecom3;

            vlocity_cmt__OrchestrationItem__c item7 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item7;

            vlocity_cmt__OrchestrationItem__c item8 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item8;

            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling4 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling4.add(item7);
            allItemsGenBilling4.add(item8);

            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            INWIB2CCreateSubscription InwiItemCreate4 = new INWIB2CCreateSubscription();
            InwiItemCreate4.executeBatch(allItemsGenBilling4);
           
        }
        
         @isTest(SeeAllData=false)
        public static void batchOrderTest4(){
            
            Test.startTest();
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
               //////////////////////////////////////////
    
				    Product2 prodMDN = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN;
            
            Id pricebookId2 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN = new PricebookEntry(
                Pricebook2Id = pricebookId2, Product2Id = prodMDN.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN;
            
            
            Pricebook2 customPB2 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB2;
          
            
            PricebookEntry customPrice2 = new PricebookEntry(
                Pricebook2Id = customPB2.Id, Product2Id = prodMDN.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice2;
            
            // create contract
            Contract c2=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c2;
            order neworder2 = new Order (Pricebook2Id = customPB2.Id,inwiB2C_TypeDeSuspension__c='International', inwiB2C_MotifDeSuspension__c ='Fraude', inwiB2C_TypeActeDeGestion__c='inwiB2C_Suspension', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworder2;
            
            String JsonMDN = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';

            OrderItem newOrderitemMDN = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworder2.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN;
            
            vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223355',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc;

               //Create and Insert Asset
            Asset asset = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset.Id;
            Update newOrderitemMDN;
            
            //////////////////////////////////////////
    
            
            
            contact listContact =new contact(FirstName='Jawad',AccountId =testAccount.Id,  LastName='Bentaybi',InwiB2C_CIN__c='BE110011',InwiB2C_Type_CIN__c ='Passeport');
            insert listContact;
            
            testAccount.vlocity_cmt__PersonContactId__c = listContact.Id;
            Update testAccount;
            
            Product2 prodMDN1  = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN1;
            
            Id pricebookId3 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN1 = new PricebookEntry(
                Pricebook2Id = pricebookId3, Product2Id = prodMDN1.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN1;
            
            
            Pricebook2 customPB3 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB3;
          
            
            PricebookEntry customPrice3 = new PricebookEntry(
                Pricebook2Id = customPB3.Id, Product2Id = prodMDN1.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice3;

            // create contract
            Contract c3=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c3;
            order neworder3 = new Order (Pricebook2Id = customPB3.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,contractId=c3.Id);
            insert neworder3;
            
            String JsonMDN1 = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitemMDN1 = new OrderItem(Product2Id = prodMDN1.Id, vlocity_cmt__JSONAttribute__c = JsonMDN1, PriceBookEntryId=customPrice3.Id, OrderId=neworder3.Id, Quantity=1, UnitPrice=customPrice3.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN1;
            
            vlocity_cmt__Subscription__c newSubsc2=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223366',Inwib2c_Num_ro_de_la_ligne__c='0611223366',Name='TEST3',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc2;

               //Create and Insert Asset
            Asset asset3 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN1.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN1.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc2.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset3;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset3.Id;
            Update newOrderitemMDN1;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl3 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef3 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef3;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef3 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef3.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl3.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef3;

            vlocity_cmt__OrchestrationPlan__c planId3 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder3.Id);
            insert planId3;


            vlocity_cmt__FulfilmentRequest__c FRId3 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__OrderId__c=neworder3.Id);
            insert FRId3;

            vlocity_cmt__FulfilmentRequestLine__c FRLine3 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId3.Id); 
            insert FRLine3;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom3 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine3.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitemMDN1.Id);
            insert FRLineDecom3;

            vlocity_cmt__OrchestrationItem__c item7 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item7;

            vlocity_cmt__OrchestrationItem__c item8 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item8;

            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling4 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling4.add(item7);
            allItemsGenBilling4.add(item8);

            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            //INWIB2CCreateSubscription InwiItemCreate4 = new INWIB2CCreateSubscription();
           // InwiItemCreate4.executeBatch(allItemsGenBilling4);
            //////////////////////////////////////
            // JBEN - REHAB - 22052022 //
            order neworderRehab = new Order (Pricebook2Id = customPB2.Id, inwiB2C_TypeActeDeGestion__c='inwiB2C_Rehabilitation', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworderRehab;

            OrderItem newOrderitemRehab = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworderRehab.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemRehab;
            
            vlocity_cmt__Subscription__c newSubscRehab=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223377',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubscRehab;

               //Create and Insert Asset
            Asset assetRehab = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemRehab.Id,
                vlocity_cmt__SubscriptionId__c = newSubscRehab.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert assetRehab;
            
            newOrderitemRehab.vlocity_cmt__AssetId__c = assetRehab.Id;
            Update newOrderitemRehab;
            
            item7.vlocity_cmt__OrderItemId__c = newOrderitemRehab.Id;
            update item7;


            
			///////////////////////////////////////
            //Test.stopTest();
             //Modif inwiB2C_ChangementTypeLigne
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementTypeLigne';
            update neworderRehab;
            
			INWIB2CCreateSubscription InwiItemCreateModifTypeLine = new INWIB2CCreateSubscription();
            InwiItemCreateModifTypeLine.executeBatch(allItemsGenBilling4);
            
            //Modif PORTA OUT inwiB2C_PortaOut
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_PortaOut';
            update neworderRehab;
            
            Test.stopTest();
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            INWIB2CCreateSubscription InwiItemCreateRehab = new INWIB2CCreateSubscription();
            InwiItemCreateRehab.executeBatch(allItemsGenBilling4);
            
            /// Modif ligne 
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ModificationDeNumero';
            update neworderRehab;
            
			INWIB2CCreateSubscription InwiItemCreateModifLine = new INWIB2CCreateSubscription();
            InwiItemCreateModifLine.executeBatch(allItemsGenBilling4);
 ///////////////////////////////////////////////////////////////////////////////////////////////////    
            /*
            INWIB2CCreateSubscription InwiItemCreateportaout = new INWIB2CCreateSubscription();
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            // Modif ChangementDeCarteSIM inwiB2C_ChangementDeCarteSIM
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeCarteSIM';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            // Modif ChangementDeTerminalModem inwiB2C_ChangementDeTerminalModem
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeTerminalModem';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            
            // Modif Resiliation inwiB2C_Resiliation
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_Resiliation';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
*/
        }
        
        
        @isTest(SeeAllData=false)
        public static void batchOrderTest5(){
            
            Test.startTest();
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
               //////////////////////////////////////////
    
				    Product2 prodMDN = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN;
            
            Id pricebookId2 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN = new PricebookEntry(
                Pricebook2Id = pricebookId2, Product2Id = prodMDN.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN;
            
            
            Pricebook2 customPB2 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB2;
          
            
            PricebookEntry customPrice2 = new PricebookEntry(
                Pricebook2Id = customPB2.Id, Product2Id = prodMDN.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice2;
            
            // create contract
            Contract c2=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c2;
            order neworder2 = new Order (Pricebook2Id = customPB2.Id,inwiB2C_TypeDeSuspension__c='International', inwiB2C_MotifDeSuspension__c ='Fraude', inwiB2C_TypeActeDeGestion__c='inwiB2C_Suspension', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworder2;
            
            String JsonMDN = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';

            OrderItem newOrderitemMDN = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworder2.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN;
            
            vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223355',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc;

               //Create and Insert Asset
            Asset asset = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset.Id;
            Update newOrderitemMDN;
            
            //////////////////////////////////////////
    
            
            
            contact listContact =new contact(FirstName='Jawad',AccountId =testAccount.Id,  LastName='Bentaybi',InwiB2C_CIN__c='BE110011',InwiB2C_Type_CIN__c ='Passeport');
            insert listContact;
            
            testAccount.vlocity_cmt__PersonContactId__c = listContact.Id;
            Update testAccount;
            
            Product2 prodMDN1  = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN1;
            
            Id pricebookId3 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN1 = new PricebookEntry(
                Pricebook2Id = pricebookId3, Product2Id = prodMDN1.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN1;
            
            
            Pricebook2 customPB3 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB3;
          
            
            PricebookEntry customPrice3 = new PricebookEntry(
                Pricebook2Id = customPB3.Id, Product2Id = prodMDN1.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice3;

            // create contract
            Contract c3=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c3;
            order neworder3 = new Order (Pricebook2Id = customPB3.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,contractId=c3.Id);
            insert neworder3;
            
            String JsonMDN1 = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitemMDN1 = new OrderItem(Product2Id = prodMDN1.Id, vlocity_cmt__JSONAttribute__c = JsonMDN1, PriceBookEntryId=customPrice3.Id, OrderId=neworder3.Id, Quantity=1, UnitPrice=customPrice3.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN1;
            
            vlocity_cmt__Subscription__c newSubsc2=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223366',Inwib2c_Num_ro_de_la_ligne__c='0611223366',Name='TEST3',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc2;

               //Create and Insert Asset
            Asset asset3 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN1.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN1.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc2.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset3;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset3.Id;
            Update newOrderitemMDN1;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl3 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef3 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef3;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef3 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef3.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl3.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef3;

            vlocity_cmt__OrchestrationPlan__c planId3 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder3.Id);
            insert planId3;


            vlocity_cmt__FulfilmentRequest__c FRId3 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__OrderId__c=neworder3.Id);
            insert FRId3;

            vlocity_cmt__FulfilmentRequestLine__c FRLine3 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId3.Id); 
            insert FRLine3;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom3 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine3.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitemMDN1.Id);
            insert FRLineDecom3;

            vlocity_cmt__OrchestrationItem__c item7 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item7;

            vlocity_cmt__OrchestrationItem__c item8 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item8;

            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling4 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling4.add(item7);
            allItemsGenBilling4.add(item8);

            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            //INWIB2CCreateSubscription InwiItemCreate4 = new INWIB2CCreateSubscription();
           // InwiItemCreate4.executeBatch(allItemsGenBilling4);
            //////////////////////////////////////
            // JBEN - REHAB - 22052022 //
            /*
            order neworderRehab = new Order (Pricebook2Id = customPB2.Id, inwiB2C_TypeActeDeGestion__c='inwiB2C_Rehabilitation', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworderRehab;

            OrderItem newOrderitemRehab = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworderRehab.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemRehab;
            
            vlocity_cmt__Subscription__c newSubscRehab=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223377',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubscRehab;

               //Create and Insert Asset
            Asset assetRehab = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemRehab.Id,
                vlocity_cmt__SubscriptionId__c = newSubscRehab.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert assetRehab;
            
            newOrderitemRehab.vlocity_cmt__AssetId__c = assetRehab.Id;
            Update newOrderitemRehab;
            
            item7.vlocity_cmt__OrderItemId__c = newOrderitemRehab.Id;
            update item7;

             */
            
			///////////////////////////////////////
            //Test.stopTest();
             //Modif inwiB2C_ChangementTypeLigne
            //neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementTypeLigne';
            //update neworderRehab;
            
			//INWIB2CCreateSubscription InwiItemCreateModifTypeLine = new INWIB2CCreateSubscription();
            //InwiItemCreateModifTypeLine.executeBatch(allItemsGenBilling4);
            
            //Modif PORTA OUT inwiB2C_PortaOut
            //neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_PortaOut';
            //update neworderRehab;
            
            //Test.stopTest();

            //INWIB2CCreateSubscription InwiItemCreateRehab = new INWIB2CCreateSubscription();
            //InwiItemCreateRehab.executeBatch(allItemsGenBilling4);
            
            /// Modif ligne 
            //neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ModificationDeNumero';
            //update neworderRehab;
            
			//INWIB2CCreateSubscription InwiItemCreateModifLine = new INWIB2CCreateSubscription();
           // InwiItemCreateModifLine.executeBatch(allItemsGenBilling4);
 /////////////////////////////////////////////////////////////////////////////////////////////////////////    
            
           INWIB2CCreateSubscription InwiItemCreateportaout = new INWIB2CCreateSubscription();
           InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            // Modif ChangementDeCarteSIM inwiB2C_ChangementDeCarteSIM
            //
            //neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeCarteSIM';
            //update neworderRehab;
            
           // InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            /*
            // Modif ChangementDeTerminalModem inwiB2C_ChangementDeTerminalModem
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeTerminalModem';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            
            // Modif Resiliation inwiB2C_Resiliation
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_Resiliation';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);*/
        }
          
        @isTest(SeeAllData=false)
        public static void batchOrderTest6(){
            
            Test.startTest();
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
               //////////////////////////////////////////
    
				    Product2 prodMDN = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN;
            
            Id pricebookId2 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN = new PricebookEntry(
                Pricebook2Id = pricebookId2, Product2Id = prodMDN.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN;
            
            
            Pricebook2 customPB2 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB2;
          
            
            PricebookEntry customPrice2 = new PricebookEntry(
                Pricebook2Id = customPB2.Id, Product2Id = prodMDN.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice2;
            
            // create contract
            Contract c2=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c2;
            order neworder2 = new Order (Pricebook2Id = customPB2.Id,inwiB2C_TypeDeSuspension__c='International', inwiB2C_MotifDeSuspension__c ='Fraude', inwiB2C_TypeActeDeGestion__c='inwiB2C_Suspension', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworder2;
            
            String JsonMDN = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';

            OrderItem newOrderitemMDN = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworder2.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN;
            
            vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223355',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc;

               //Create and Insert Asset
            Asset asset = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset.Id;
            Update newOrderitemMDN;
            
            //////////////////////////////////////////
    
            
            
            contact listContact =new contact(FirstName='Jawad',AccountId =testAccount.Id,  LastName='Bentaybi',InwiB2C_CIN__c='BE110011',InwiB2C_Type_CIN__c ='Passeport');
            insert listContact;
            
            testAccount.vlocity_cmt__PersonContactId__c = listContact.Id;
            Update testAccount;
            
            Product2 prodMDN1  = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN1;
            
            Id pricebookId3 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN1 = new PricebookEntry(
                Pricebook2Id = pricebookId3, Product2Id = prodMDN1.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN1;
            
            
            Pricebook2 customPB3 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB3;
          
            
            PricebookEntry customPrice3 = new PricebookEntry(
                Pricebook2Id = customPB3.Id, Product2Id = prodMDN1.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice3;

            // create contract
            Contract c3=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c3;
            order neworder3 = new Order (Pricebook2Id = customPB3.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,contractId=c3.Id);
            insert neworder3;
            
            String JsonMDN1 = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitemMDN1 = new OrderItem(Product2Id = prodMDN1.Id, vlocity_cmt__JSONAttribute__c = JsonMDN1, PriceBookEntryId=customPrice3.Id, OrderId=neworder3.Id, Quantity=1, UnitPrice=customPrice3.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN1;
            
            vlocity_cmt__Subscription__c newSubsc2=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223366',Inwib2c_Num_ro_de_la_ligne__c='0611223366',Name='TEST3',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc2;

               //Create and Insert Asset
            Asset asset3 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN1.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN1.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc2.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset3;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset3.Id;
            Update newOrderitemMDN1;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl3 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef3 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef3;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef3 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef3.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl3.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef3;

            vlocity_cmt__OrchestrationPlan__c planId3 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder3.Id);
            insert planId3;


            vlocity_cmt__FulfilmentRequest__c FRId3 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__OrderId__c=neworder3.Id);
            insert FRId3;

            vlocity_cmt__FulfilmentRequestLine__c FRLine3 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId3.Id); 
            insert FRLine3;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom3 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine3.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitemMDN1.Id);
            insert FRLineDecom3;

            vlocity_cmt__OrchestrationItem__c item7 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item7;

            vlocity_cmt__OrchestrationItem__c item8 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item8;

            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling4 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling4.add(item7);
            allItemsGenBilling4.add(item8);

            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            //INWIB2CCreateSubscription InwiItemCreate4 = new INWIB2CCreateSubscription();
           // InwiItemCreate4.executeBatch(allItemsGenBilling4);
            //////////////////////////////////////
            // JBEN - REHAB - 22052022 //
            order neworderRehab = new Order (Pricebook2Id = customPB2.Id, inwiB2C_TypeActeDeGestion__c='inwiB2C_Rehabilitation', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworderRehab;

            OrderItem newOrderitemRehab = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworderRehab.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemRehab;
            
            vlocity_cmt__Subscription__c newSubscRehab=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223377',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubscRehab;

               //Create and Insert Asset
            Asset assetRehab = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemRehab.Id,
                vlocity_cmt__SubscriptionId__c = newSubscRehab.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert assetRehab;
            
            newOrderitemRehab.vlocity_cmt__AssetId__c = assetRehab.Id;
            Update newOrderitemRehab;
            
            item7.vlocity_cmt__OrderItemId__c = newOrderitemRehab.Id;
            update item7;


            
			///////////////////////////////////////
            //Test.stopTest();
             //Modif inwiB2C_ChangementTypeLigne
            //neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementTypeLigne';
            //update neworderRehab;
            
			//INWIB2CCreateSubscription InwiItemCreateModifTypeLine = new INWIB2CCreateSubscription();
            //InwiItemCreateModifTypeLine.executeBatch(allItemsGenBilling4);
            
            //Modif PORTA OUT inwiB2C_PortaOut
           // neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_PortaOut';
           // update neworderRehab;
            
            //Test.stopTest();
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //  INWIB2CCreateSubscription InwiItemCreateRehab = new INWIB2CCreateSubscription();
            //InwiItemCreateRehab.executeBatch(allItemsGenBilling4);
            
            /// Modif ligne 
          //  neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ModificationDeNumero';
          //  update neworderRehab;
            
			//INWIB2CCreateSubscription InwiItemCreateModifLine = new INWIB2CCreateSubscription();
           // InwiItemCreateModifLine.executeBatch(allItemsGenBilling4);
 ///////////////////////////////////////////////////////////////////////////////////////////////////    
            
            INWIB2CCreateSubscription InwiItemCreateportaout = new INWIB2CCreateSubscription();
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            // Modif ChangementDeCarteSIM inwiB2C_ChangementDeCarteSIM
           // neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeCarteSIM';
           // update neworderRehab;
            
            //InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
  ////////////////////////////////////////////////////////////////////////////////////          
            // Modif ChangementDeTerminalModem inwiB2C_ChangementDeTerminalModem
          /*  neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeTerminalModem';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            
            // Modif Resiliation inwiB2C_Resiliation
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_Resiliation';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);*/
        }
        
         @isTest(SeeAllData=false)
        public static void batchOrderTest7(){
            
            Test.startTest();
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
               //////////////////////////////////////////
    
				    Product2 prodMDN = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN;
            
            Id pricebookId2 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN = new PricebookEntry(
                Pricebook2Id = pricebookId2, Product2Id = prodMDN.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN;
            
            
            Pricebook2 customPB2 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB2;
          
            
            PricebookEntry customPrice2 = new PricebookEntry(
                Pricebook2Id = customPB2.Id, Product2Id = prodMDN.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice2;
            
            // create contract
            Contract c2=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c2;
            order neworder2 = new Order (Pricebook2Id = customPB2.Id,inwiB2C_TypeDeSuspension__c='International', inwiB2C_MotifDeSuspension__c ='Fraude', inwiB2C_TypeActeDeGestion__c='inwiB2C_Suspension', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworder2;
            
            String JsonMDN = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';

            OrderItem newOrderitemMDN = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworder2.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN;
            
            vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223355',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc;

               //Create and Insert Asset
            Asset asset = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset.Id;
            Update newOrderitemMDN;
            
            //////////////////////////////////////////
    
            
            
            contact listContact =new contact(FirstName='Jawad',AccountId =testAccount.Id,  LastName='Bentaybi',InwiB2C_CIN__c='BE110011',InwiB2C_Type_CIN__c ='Passeport');
            insert listContact;
            
            testAccount.vlocity_cmt__PersonContactId__c = listContact.Id;
            Update testAccount;
            
            Product2 prodMDN1  = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN1;
            
            Id pricebookId3 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN1 = new PricebookEntry(
                Pricebook2Id = pricebookId3, Product2Id = prodMDN1.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN1;
            
            
            Pricebook2 customPB3 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB3;
          
            
            PricebookEntry customPrice3 = new PricebookEntry(
                Pricebook2Id = customPB3.Id, Product2Id = prodMDN1.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice3;

            // create contract
            Contract c3=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c3;
            order neworder3 = new Order (Pricebook2Id = customPB3.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,contractId=c3.Id);
            insert neworder3;
            
            String JsonMDN1 = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitemMDN1 = new OrderItem(Product2Id = prodMDN1.Id, vlocity_cmt__JSONAttribute__c = JsonMDN1, PriceBookEntryId=customPrice3.Id, OrderId=neworder3.Id, Quantity=1, UnitPrice=customPrice3.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN1;
            
            vlocity_cmt__Subscription__c newSubsc2=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223366',Inwib2c_Num_ro_de_la_ligne__c='0611223366',Name='TEST3',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc2;

               //Create and Insert Asset
            Asset asset3 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN1.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN1.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc2.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset3;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset3.Id;
            Update newOrderitemMDN1;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl3 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef3 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef3;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef3 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef3.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl3.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef3;

            vlocity_cmt__OrchestrationPlan__c planId3 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder3.Id);
            insert planId3;


            vlocity_cmt__FulfilmentRequest__c FRId3 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__OrderId__c=neworder3.Id);
            insert FRId3;

            vlocity_cmt__FulfilmentRequestLine__c FRLine3 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId3.Id); 
            insert FRLine3;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom3 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine3.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitemMDN1.Id);
            insert FRLineDecom3;

            vlocity_cmt__OrchestrationItem__c item7 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item7;

            vlocity_cmt__OrchestrationItem__c item8 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item8;

            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling4 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling4.add(item7);
            allItemsGenBilling4.add(item8);

            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            //INWIB2CCreateSubscription InwiItemCreate4 = new INWIB2CCreateSubscription();
           // InwiItemCreate4.executeBatch(allItemsGenBilling4);
            //////////////////////////////////////
            // JBEN - REHAB - 22052022 //
            order neworderRehab = new Order (Pricebook2Id = customPB2.Id, inwiB2C_TypeActeDeGestion__c='inwiB2C_Rehabilitation', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworderRehab;

            OrderItem newOrderitemRehab = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworderRehab.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemRehab;
            
            vlocity_cmt__Subscription__c newSubscRehab=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223377',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubscRehab;

               //Create and Insert Asset
            Asset assetRehab = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemRehab.Id,
                vlocity_cmt__SubscriptionId__c = newSubscRehab.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert assetRehab;
            
            newOrderitemRehab.vlocity_cmt__AssetId__c = assetRehab.Id;
            Update newOrderitemRehab;
            
            item7.vlocity_cmt__OrderItemId__c = newOrderitemRehab.Id;
            update item7;


            
			///////////////////////////////////////
            //Test.stopTest();
             //Modif inwiB2C_ChangementTypeLigne
            //neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementTypeLigne';
            //update neworderRehab;
            
			//INWIB2CCreateSubscription InwiItemCreateModifTypeLine = new INWIB2CCreateSubscription();
            //InwiItemCreateModifTypeLine.executeBatch(allItemsGenBilling4);
            
            //Modif PORTA OUT inwiB2C_PortaOut
           // neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_PortaOut';
           // update neworderRehab;
            
            //Test.stopTest();
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //  INWIB2CCreateSubscription InwiItemCreateRehab = new INWIB2CCreateSubscription();
            //InwiItemCreateRehab.executeBatch(allItemsGenBilling4);
            
            /// Modif ligne 
          //  neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ModificationDeNumero';
          //  update neworderRehab;
            
			//INWIB2CCreateSubscription InwiItemCreateModifLine = new INWIB2CCreateSubscription();
           // InwiItemCreateModifLine.executeBatch(allItemsGenBilling4);
 ///////////////////////////////////////////////////////////////////////////////////////////////////    
            
            INWIB2CCreateSubscription InwiItemCreateportaout = new INWIB2CCreateSubscription();
           // InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            // Modif ChangementDeCarteSIM inwiB2C_ChangementDeCarteSIM
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeCarteSIM';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
  ////////////////////////////////////////////////////////////////////////////////////          
            // Modif ChangementDeTerminalModem inwiB2C_ChangementDeTerminalModem
          /*  neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeTerminalModem';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            
            // Modif Resiliation inwiB2C_Resiliation
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_Resiliation';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);*/
        }
         @isTest(SeeAllData=false)
        public static void batchOrderTest8(){
            
            Test.startTest();
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
               //////////////////////////////////////////
    
				    Product2 prodMDN = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN;
            
            Id pricebookId2 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN = new PricebookEntry(
                Pricebook2Id = pricebookId2, Product2Id = prodMDN.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN;
            
            
            Pricebook2 customPB2 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB2;
          
            
            PricebookEntry customPrice2 = new PricebookEntry(
                Pricebook2Id = customPB2.Id, Product2Id = prodMDN.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice2;
            
            // create contract
            Contract c2=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c2;
            order neworder2 = new Order (Pricebook2Id = customPB2.Id,inwiB2C_TypeDeSuspension__c='International', inwiB2C_MotifDeSuspension__c ='Fraude', inwiB2C_TypeActeDeGestion__c='inwiB2C_Suspension', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworder2;
            
            String JsonMDN = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';

            OrderItem newOrderitemMDN = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworder2.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN;
            
            vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223355',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc;

               //Create and Insert Asset
            Asset asset = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset.Id;
            Update newOrderitemMDN;
            
            //////////////////////////////////////////
    
            
            
            contact listContact =new contact(FirstName='Jawad',AccountId =testAccount.Id,  LastName='Bentaybi',InwiB2C_CIN__c='BE110011',InwiB2C_Type_CIN__c ='Passeport');
            insert listContact;
            
            testAccount.vlocity_cmt__PersonContactId__c = listContact.Id;
            Update testAccount;
            
            Product2 prodMDN1  = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN1;
            
            Id pricebookId3 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN1 = new PricebookEntry(
                Pricebook2Id = pricebookId3, Product2Id = prodMDN1.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN1;
            
            
            Pricebook2 customPB3 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB3;
          
            
            PricebookEntry customPrice3 = new PricebookEntry(
                Pricebook2Id = customPB3.Id, Product2Id = prodMDN1.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice3;

            // create contract
            Contract c3=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c3;
            order neworder3 = new Order (Pricebook2Id = customPB3.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,contractId=c3.Id);
            insert neworder3;
            
            String JsonMDN1 = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitemMDN1 = new OrderItem(Product2Id = prodMDN1.Id, vlocity_cmt__JSONAttribute__c = JsonMDN1, PriceBookEntryId=customPrice3.Id, OrderId=neworder3.Id, Quantity=1, UnitPrice=customPrice3.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN1;
            
            vlocity_cmt__Subscription__c newSubsc2=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223366',Inwib2c_Num_ro_de_la_ligne__c='0611223366',Name='TEST3',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc2;

               //Create and Insert Asset
            Asset asset3 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN1.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN1.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc2.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset3;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset3.Id;
            Update newOrderitemMDN1;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl3 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef3 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef3;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef3 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef3.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl3.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef3;

            vlocity_cmt__OrchestrationPlan__c planId3 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder3.Id);
            insert planId3;


            vlocity_cmt__FulfilmentRequest__c FRId3 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__OrderId__c=neworder3.Id);
            insert FRId3;

            vlocity_cmt__FulfilmentRequestLine__c FRLine3 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId3.Id); 
            insert FRLine3;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom3 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine3.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitemMDN1.Id);
            insert FRLineDecom3;

            vlocity_cmt__OrchestrationItem__c item7 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item7;

            vlocity_cmt__OrchestrationItem__c item8 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item8;

            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling4 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling4.add(item7);
            allItemsGenBilling4.add(item8);

            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            //INWIB2CCreateSubscription InwiItemCreate4 = new INWIB2CCreateSubscription();
           // InwiItemCreate4.executeBatch(allItemsGenBilling4);
            //////////////////////////////////////
            // JBEN - REHAB - 22052022 //
            order neworderRehab = new Order (Pricebook2Id = customPB2.Id, inwiB2C_TypeActeDeGestion__c='inwiB2C_Rehabilitation', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworderRehab;

            OrderItem newOrderitemRehab = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworderRehab.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemRehab;
            
            vlocity_cmt__Subscription__c newSubscRehab=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223377',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubscRehab;

               //Create and Insert Asset
            Asset assetRehab = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemRehab.Id,
                vlocity_cmt__SubscriptionId__c = newSubscRehab.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert assetRehab;
            
            newOrderitemRehab.vlocity_cmt__AssetId__c = assetRehab.Id;
            Update newOrderitemRehab;
            
            item7.vlocity_cmt__OrderItemId__c = newOrderitemRehab.Id;
            update item7;


            
			///////////////////////////////////////
            //Test.stopTest();
             //Modif inwiB2C_ChangementTypeLigne
            //neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementTypeLigne';
            //update neworderRehab;
            
			//INWIB2CCreateSubscription InwiItemCreateModifTypeLine = new INWIB2CCreateSubscription();
            //InwiItemCreateModifTypeLine.executeBatch(allItemsGenBilling4);
            
            //Modif PORTA OUT inwiB2C_PortaOut
           // neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_PortaOut';
           // update neworderRehab;
            
            //Test.stopTest();
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //INWIB2CCreateSubscription InwiItemCreateRehab = new INWIB2CCreateSubscription();
            //InwiItemCreateRehab.executeBatch(allItemsGenBilling4);
            
            /// Modif ligne 
          //  neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ModificationDeNumero';
          //  update neworderRehab;
            
			//INWIB2CCreateSubscription InwiItemCreateModifLine = new INWIB2CCreateSubscription();
           // InwiItemCreateModifLine.executeBatch(allItemsGenBilling4);
 ///////////////////////////////////////////////////////////////////////////////////////////////////    
            
            INWIB2CCreateSubscription InwiItemCreateportaout = new INWIB2CCreateSubscription();
            //InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            // Modif ChangementDeCarteSIM inwiB2C_ChangementDeCarteSIM
           // neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeCarteSIM';
           // update neworderRehab;
            
            //InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
  ////////////////////////////////////////////////////////////////////////////////////          
            // Modif ChangementDeTerminalModem inwiB2C_ChangementDeTerminalModem
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeTerminalModem';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            /*
            // Modif Resiliation inwiB2C_Resiliation
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_Resiliation';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);*/
        }
         @isTest(SeeAllData=false)
        public static void batchOrderTest9(){
            
            Test.startTest();
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
               //////////////////////////////////////////
    
				    Product2 prodMDN = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN;
            
            Id pricebookId2 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN = new PricebookEntry(
                Pricebook2Id = pricebookId2, Product2Id = prodMDN.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN;
            
            
            Pricebook2 customPB2 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB2;
          
            
            PricebookEntry customPrice2 = new PricebookEntry(
                Pricebook2Id = customPB2.Id, Product2Id = prodMDN.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice2;
            
            // create contract
            Contract c2=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c2;
            order neworder2 = new Order (Pricebook2Id = customPB2.Id,inwiB2C_TypeDeSuspension__c='International', inwiB2C_MotifDeSuspension__c ='Fraude', inwiB2C_TypeActeDeGestion__c='inwiB2C_Suspension', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworder2;
            
            String JsonMDN = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"garder","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}],"values":[{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"garder le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"garder"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';

            OrderItem newOrderitemMDN = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworder2.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN;
            
            vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223355',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc;

               //Create and Insert Asset
            Asset asset = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset.Id;
            Update newOrderitemMDN;
            
            //////////////////////////////////////////
    
            
            
            contact listContact =new contact(FirstName='Jawad',AccountId =testAccount.Id,  LastName='Bentaybi',InwiB2C_CIN__c='BE110011',InwiB2C_Type_CIN__c ='Passeport');
            insert listContact;
            
            testAccount.vlocity_cmt__PersonContactId__c = listContact.Id;
            Update testAccount;
            
            Product2 prodMDN1  = new Product2(Name = 'Laptop X202', 
                   Family = 'Hardware',
                   ProductCode='INWIB2C_OFFERING_MSISDN_STANDARD');
            insert prodMDN1;
            
            Id pricebookId3 = Test.getStandardPricebookId();
            
            PricebookEntry standardPriceMDN1 = new PricebookEntry(
                Pricebook2Id = pricebookId3, Product2Id = prodMDN1.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPriceMDN1;
            
            
            Pricebook2 customPB3 = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB3;
          
            
            PricebookEntry customPrice3 = new PricebookEntry(
                Pricebook2Id = customPB3.Id, Product2Id = prodMDN1.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice3;

            // create contract
            Contract c3=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c3;
            order neworder3 = new Order (Pricebook2Id = customPB3.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,contractId=c3.Id);
            insert neworder3;
            
            String JsonMDN1 = '{ "INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t2500000632FKAAY","attributeid__c":"a0X25000003Xp4oEAC","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CHOIX_NUMERO","attributeconfigurable__c":true,"attributedisplaysequence__c":"80","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"choix du numéro","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mr8oEAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"porter","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}],"values":[{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"},{"displayText":"porter un numéro","id":"647a5348-448c-9c60-8480-b1dbe111ea56","sequence":20,"value":"porter"},{"displayText":"personaliser le numéro","id":"82a431a9-43ae-349d-7a4b-cec24d482c65","sequence":30,"value":"personaliser"}],"selectedItem":{"displayText":"porter le numéro par défaut","id":"8dcfdd45-a5af-1724-212d-49d3a406245e","sequence":10,"value":"porter"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKy1EAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Profil IN","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZIEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}],"default":[],"selectedItem":{"displayText":"89075","id":"2e3eed33-4a59-7a0a-6c51-289bb076a13d","sequence":90,"value":"89075"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t250000064YH7AAM","attributeid__c":"a0X25000003WKxwEAG","attributecategoryid__c":"a0W25000003M2TZEA0","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL_IN","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U25000003mnZKEAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"MRE 2017_5292","id":"779f1b65-2267-d9b4-07ae-8306ce83f02c","sequence":10,"value":"MRE 2017_5292"},{"displayText":"VD_5291","id":"b085d4a1-1dbb-52ce-c140-e68a88804a52","sequence":20,"value":"VD_5291"},{"displayText":"Offre acquisition_647232","id":"e3b7bfb5-3c68-29da-75bd-1063c0491640","sequence":30,"value":"Offre acquisition_647232"},{"displayText":"Offre acquisition_20707","id":"fe1d1082-71e8-f0cc-fedb-c52fb6cc151e","sequence":40,"value":"Offre acquisition_20707"},{"displayText":"Offre acquisition_84001","id":"11645fa9-6a44-0354-63a9-c8f859280c73","sequence":50,"value":"Offre acquisition_84001"},{"displayText":"Offre acquisition_89124","id":"3e239e30-8d39-6d3b-e552-d3d25474bbde","sequence":60,"value":"Offre acquisition_89124"},{"displayText":"Offre acquisition_84002","id":"0e6d363e-c589-60b7-ab15-bbdec399c037","sequence":70,"value":"Offre acquisition_84002"},{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"},{"displayText":"Offre migration voix gratuite_4490","id":"54831ceb-294d-730a-10b5-610ac9124d21","sequence":90,"value":"Offre migration voix gratuite_4490"},{"displayText":"MRE 2020_2990","id":"e3b8bcb9-97eb-6a49-0712-13609c1320ec","sequence":100,"value":"MRE 2020_2990"}],"default":[],"selectedItem":{"displayText":"Offre acquisition_89075","id":"035421ff-2c10-df7e-4a3a-7e7fbf648c87","sequence":80,"value":"Offre acquisition_89075"}},"$$AttributeDefinitionEnd$$":null}]}';
            OrderItem newOrderitemMDN1 = new OrderItem(Product2Id = prodMDN1.Id, vlocity_cmt__JSONAttribute__c = JsonMDN1, PriceBookEntryId=customPrice3.Id, OrderId=neworder3.Id, Quantity=1, UnitPrice=customPrice3.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemMDN1;
            
            vlocity_cmt__Subscription__c newSubsc2=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223366',Inwib2c_Num_ro_de_la_ligne__c='0611223366',Name='TEST3',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubsc2;

               //Create and Insert Asset
            Asset asset3 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN1.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemMDN1.Id,
                vlocity_cmt__SubscriptionId__c = newSubsc2.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert asset3;
            
            newOrderitemMDN.vlocity_cmt__AssetId__c = asset3.Id;
            Update newOrderitemMDN1;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl3 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef3 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef3;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef3 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef3.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl3.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef3;

            vlocity_cmt__OrchestrationPlan__c planId3 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder3.Id);
            insert planId3;


            vlocity_cmt__FulfilmentRequest__c FRId3 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__OrderId__c=neworder3.Id);
            insert FRId3;

            vlocity_cmt__FulfilmentRequestLine__c FRLine3 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId3.Id); 
            insert FRLine3;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom3 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine3.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitemMDN1.Id);
            insert FRLineDecom3;

            vlocity_cmt__OrchestrationItem__c item7 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item7;

            vlocity_cmt__OrchestrationItem__c item8 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId3.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine3.Id,
            vlocity_cmt__OrderItemId__c = newOrderitemMDN1.Id);
            insert item8;

            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling4 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling4.add(item7);
            allItemsGenBilling4.add(item8);

            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            //INWIB2CCreateSubscription InwiItemCreate4 = new INWIB2CCreateSubscription();
           // InwiItemCreate4.executeBatch(allItemsGenBilling4);
            //////////////////////////////////////
            // JBEN - REHAB - 22052022 //
            order neworderRehab = new Order (Pricebook2Id = customPB2.Id, inwiB2C_TypeActeDeGestion__c='inwiB2C_Rehabilitation', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c2.id);
            insert neworderRehab;

            OrderItem newOrderitemRehab = new OrderItem(Product2Id = prodMDN.Id, vlocity_cmt__JSONAttribute__c = JsonMDN, PriceBookEntryId=customPrice2.Id, OrderId=neworderRehab.Id, Quantity=1, UnitPrice=customPrice2.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitemRehab;
            
            vlocity_cmt__Subscription__c newSubscRehab=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223377',Inwib2c_Num_ro_de_la_ligne__c='0611223355',Name='TEST2',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended');
            Insert newSubscRehab;

               //Create and Insert Asset
            Asset assetRehab = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prodMDN.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitemRehab.Id,
                vlocity_cmt__SubscriptionId__c = newSubscRehab.Id
                //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
                );
                insert assetRehab;
            
            newOrderitemRehab.vlocity_cmt__AssetId__c = assetRehab.Id;
            Update newOrderitemRehab;
            
            item7.vlocity_cmt__OrderItemId__c = newOrderitemRehab.Id;
            update item7;


            
			///////////////////////////////////////
            //Test.stopTest();
             //Modif inwiB2C_ChangementTypeLigne
            //neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementTypeLigne';
            //update neworderRehab;
            
			//INWIB2CCreateSubscription InwiItemCreateModifTypeLine = new INWIB2CCreateSubscription();
            //InwiItemCreateModifTypeLine.executeBatch(allItemsGenBilling4);
            
            //Modif PORTA OUT inwiB2C_PortaOut
           // neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_PortaOut';
           // update neworderRehab;
            
            //Test.stopTest();
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //INWIB2CCreateSubscription InwiItemCreateRehab = new INWIB2CCreateSubscription();
            //InwiItemCreateRehab.executeBatch(allItemsGenBilling4);
            
            /// Modif ligne 
          //  neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ModificationDeNumero';
          //  update neworderRehab;
            
			//INWIB2CCreateSubscription InwiItemCreateModifLine = new INWIB2CCreateSubscription();
           // InwiItemCreateModifLine.executeBatch(allItemsGenBilling4);
 ///////////////////////////////////////////////////////////////////////////////////////////////////    
            
            INWIB2CCreateSubscription InwiItemCreateportaout = new INWIB2CCreateSubscription();
           // InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            
            // Modif ChangementDeCarteSIM inwiB2C_ChangementDeCarteSIM
           // neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeCarteSIM';
           // update neworderRehab;
            
            //InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
  ////////////////////////////////////////////////////////////////////////////////////          
            // Modif ChangementDeTerminalModem inwiB2C_ChangementDeTerminalModem
          /*  neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_ChangementDeTerminalModem';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
            */
            
            // Modif Resiliation inwiB2C_Resiliation
            neworderRehab.inwiB2C_TypeActeDeGestion__c ='inwiB2C_Resiliation';
            update neworderRehab;
            
            InwiItemCreateportaout.executeBatch(allItemsGenBilling4);
        }
        
         @isTest(SeeAllData=false)
        public static void batchOrderTestMigrationRetentionPost() {
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            Test.startTest();
            vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
			insert VloPickList;
            vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
			insert VloPickList1;
            vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
			insert VloPickList2;
            vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList;
            
            vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList1;
            
            vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
            insert NewPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
            insert NewPickList3;
            //Product
            Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'Prepaye');
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
            Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
                 insert c;
            

            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id,inwiB2C_TypeDeMigration__c='InwiB2C_Migration_Retention_Cascade');
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNUUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_TypHandset","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type Handset","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}],"values":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"},{"value":"TERM","sequence":20,"id":"b1e73d9a-7aba-cd66-f5b8-bedaa7b3da92","displayText":"TERM"}],"selectedItem":{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OYtrUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_CUSTRISKPLAF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Plafond Risque Personnalisé","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":-999,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001AnFzUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":"-999","valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","default":"-999","value":"-999"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYupUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_ElligibleAuTypeLigne","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Elligible au type de ligne","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYuuUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_NUMERO_ADHERANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro adhérant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxklUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InDUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkmUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InEUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkvUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ENGAGEMENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Engagement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"0","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}],"values":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"},{"value":"12","sequence":20,"id":"43d82073-ac9e-d6e4-fd43-252ccd7619c5","displayText":"12 Mois"},{"value":"24","sequence":30,"id":"1874b54d-5b3d-6205-5fec-c5ac54e2c251","displayText":"24 Mois"}],"selectedItem":{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkyUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_GAMME_OFFRE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Gamme offre","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GALAXY","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}],"values":[{"value":"AMY","sequence":10,"id":"538aeaef-176d-2f05-c1aa-7a46eeb6fe46","displayText":"forfait Famille"},{"value":"BATMAN","sequence":20,"id":"da7bdac4-13d9-edd9-c1b3-89cd3a3c7221","displayText":"Batman"},{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"},{"value":"SW2","sequence":40,"id":"5ea7bea2-ea69-1f03-9458-4bbfd69eef24","displayText":"Star wars"},{"value":"PIZZA","sequence":50,"id":"d9f33766-032b-9ad5-3fd5-7d9444a61ce4","displayText":"Pizza"}],"selectedItem":{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlAUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NOMBRE_RECURENCE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre de récurrences pour remise","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86907,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InFUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86907","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}],"values":[{"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet","value":"86907","sequence":30},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlQUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_DIRHAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en Dh sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlYUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_POURCENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en % sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxllUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InCUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}],"values":[{"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public","value":"GP","sequence":40}],"selectedItem":{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTVUA4","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFAPP","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Application à partir de la nièm facture","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhDUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTaUAO","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFDIF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en différée","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNZUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_EXISTXGO","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Exist XGo","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"NON","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}],"values":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"},{"value":"OUI","sequence":20,"id":"16ef43d9-9e0b-20e6-aa23-e8bfbcf36257","displayText":"OUI"}],"selectedItem":{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}},"$$AttributeDefinitionEnd$$":null}]}';           
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
            OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem2;
             //Create Subscription 
            DateTime dateLimite = System.now();
            dateLimite = dateLimite.addDays(8); 
            Date dateLimiteSR = date.newinstance(dateLimite.year(), dateLimite.month(), dateLimite.day());
            vlocity_cmt__Subscription__c newSubsc1=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223344',Inwib2c_Num_ro_de_la_ligne__c='0611223344',Name='TEST',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active',InwiB2C_FMD__c=99,InwiB2C_FMS__c=100,InwiB2C_Code_de_transaction_FMD__c='1223',InwiB2C_Code_de_transaction_FMS__c='23456=',InwiB2C_date_limite_satisfait_rembours__c=dateLimiteSR,InwiB2C_Date_d_activation__c=dateLimite);
			Insert newSubsc1;
            //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id,
                vlocity_cmt__SubscriptionId__c=newSubsc1.Id
                );
                insert asset1;
            
            newOrderitem.vlocity_cmt__AssetId__c=asset1.Id;
            update newOrderitem;
            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef1;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef1;
             vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder.Id);
            insert planId1;


            vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__OrderId__c=neworder.Id);
            insert FRId1;



            vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
            insert FRLine1;
             vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
            insert FRLineDecom1;

            vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item3;

            System.debug('Item Name : ' +item3.Name);

            vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item4;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling1.add(item3);
            allItemsGenBilling1.add(item4);
            
            //END OF ORECHESTRATION PLAN
            INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
            InwiItemCreate1.executeBatch(allItemsGenBilling1);
            Test.stopTest();
    }
        
        @isTest(SeeAllData=false)
        public static void batchOrderTestMigrationPrePost() {
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            Test.startTest();
            vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
			insert VloPickList;
            vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
			insert VloPickList1;
            vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
			insert VloPickList2;
            vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList;
            
            vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList1;
            
            vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
            insert NewPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
            insert NewPickList3;
            //Product
            Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'Postpaye');
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
            Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
                 insert c;
                                                //Create Subscription 
            vlocity_cmt__Subscription__c newSubsc1=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223344',Inwib2c_Num_ro_de_la_ligne__c='0611223344',Name='TEST',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active');
			Insert newSubsc1;
            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id,inwiB2C_TypeDeMigration__c='InwiB2C_MigrationPrePostpayé',InwiB2C_Subscription_Migration__c = newSubsc1.Id);
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNUUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_TypHandset","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type Handset","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}],"values":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"},{"value":"TERM","sequence":20,"id":"b1e73d9a-7aba-cd66-f5b8-bedaa7b3da92","displayText":"TERM"}],"selectedItem":{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OYtrUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_CUSTRISKPLAF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Plafond Risque Personnalisé","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":-999,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001AnFzUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":"-999","valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","default":"-999","value":"-999"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYupUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_ElligibleAuTypeLigne","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Elligible au type de ligne","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYuuUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_NUMERO_ADHERANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro adhérant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxklUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InDUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkmUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InEUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkvUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ENGAGEMENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Engagement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"0","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}],"values":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"},{"value":"12","sequence":20,"id":"43d82073-ac9e-d6e4-fd43-252ccd7619c5","displayText":"12 Mois"},{"value":"24","sequence":30,"id":"1874b54d-5b3d-6205-5fec-c5ac54e2c251","displayText":"24 Mois"}],"selectedItem":{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkyUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_GAMME_OFFRE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Gamme offre","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GALAXY","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}],"values":[{"value":"AMY","sequence":10,"id":"538aeaef-176d-2f05-c1aa-7a46eeb6fe46","displayText":"forfait Famille"},{"value":"BATMAN","sequence":20,"id":"da7bdac4-13d9-edd9-c1b3-89cd3a3c7221","displayText":"Batman"},{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"},{"value":"SW2","sequence":40,"id":"5ea7bea2-ea69-1f03-9458-4bbfd69eef24","displayText":"Star wars"},{"value":"PIZZA","sequence":50,"id":"d9f33766-032b-9ad5-3fd5-7d9444a61ce4","displayText":"Pizza"}],"selectedItem":{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlAUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NOMBRE_RECURENCE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre de récurrences pour remise","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86907,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InFUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86907","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}],"values":[{"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet","value":"86907","sequence":30},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlQUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_DIRHAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en Dh sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlYUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_POURCENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en % sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxllUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InCUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}],"values":[{"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public","value":"GP","sequence":40}],"selectedItem":{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTVUA4","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFAPP","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Application à partir de la nièm facture","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhDUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTaUAO","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFDIF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en différée","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNZUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_EXISTXGO","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Exist XGo","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"NON","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}],"values":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"},{"value":"OUI","sequence":20,"id":"16ef43d9-9e0b-20e6-aa23-e8bfbcf36257","displayText":"OUI"}],"selectedItem":{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}},"$$AttributeDefinitionEnd$$":null}]}';           
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
           
            //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id,
                vlocity_cmt__ParentItemId__c = ''
                );
                insert asset1;
                        Asset asset2 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__SubscriptionId__c = newSubsc1.Id,
                vlocity_cmt__ParentItemId__c = ''
                );
                insert asset2;
            
            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef1;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef1;
             vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder.Id);
            insert planId1;


            vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__OrderId__c=neworder.Id);
            insert FRId1;



            vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
            insert FRLine1;
             vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
            insert FRLineDecom1;

            vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item3;

            System.debug('Item Name : ' +item3.Name);

            vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item4;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling1.add(item3);
            allItemsGenBilling1.add(item4);
            
            //END OF ORECHESTRATION PLAN
            INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
            InwiItemCreate1.executeBatch(allItemsGenBilling1);
            Test.stopTest();
    }

    ///////////////////////////////////////////////////////////////////////////
    @isTest(SeeAllData=false)
        public static void batchOrderAcqADSL() {
            Account testAccount = new Account(Name='Test Account');
            insert testAccount;
            Account site =new Account(Name='site Test', inwiB2C_Adresse_Facture_IAM__c='|55|;|0099;Lot Amal 2|;|00010;Lotissement Amal 2|;|08004;CASABLANCA AIN HARROUDA|;|08;CASA SIDI BERNOUSSI ZENATA|',InwiB2C_NomIAM__c='nom Test',InwiB2C_PrenomIAM__c='prenom Test', inwiB2C_numero_de_designation__c='522324578');
            insert site;
            Test.startTest();
            
            vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
			insert VloPickList;
            
            vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
			insert VloPickList1;
            
            vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
			insert VloPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList;
            
            vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList1;
            
            vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
            insert NewPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
            insert NewPickList3;
            
            system.debug('PICKLIST : '+ NewPickList2);

            
            Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'ADSL');
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
                        // create contract
                 Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
                 insert c;
            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id,vlocity_cmt__DefaultServiceAccountId__c=site.Id);
            insert neworder;
            
            InwiB2C_Sequence_Order_Number__c seqNum = new InwiB2C_Sequence_Order_Number__c(name='Sequence Degroupage',InwiB2C_Sequence__c=1);
            insert seqNum;
            InwiB2C_Sequence_Order_Number__c seqNumParam = new InwiB2C_Sequence_Order_Number__c(name='Sequence parametrage',InwiB2C_statut_ligne__c='LI',InwiB2C_Technologie__c='VULA');
            insert seqNumParam;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P5vUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CRINSTAL","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Créneau installation","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh73UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Date","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Date","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P65UAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DEBIT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Débit data","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh74UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6BUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DSLAMNAME","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nom du DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh75UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6HUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DSLSRCSTAT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Statut dégroupage de ladresse","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh76UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Ligne active","id":"6abebe37-889c-3985-9507-7a0c02bb7451","sequence":10,"value":"LA"},{"displayText":"Ligne inactive","id":"503b01a0-d2fa-29f0-80fa-a14acbeb9d84","sequence":20,"value":"LI"}],"default":[],"selectedItem":{"displayText":"Ligne active","id":"6abebe37-889c-3985-9507-7a0c02bb7451","sequence":10,"value":"LI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6PUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_FRAME","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro du Frame","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh79UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6VUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IDPORTDSLAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ID CRM du port DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7AUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6ZUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IRSID","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IRS ID IMS","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7BUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6tUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ODSLB2CTA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Technologie d’accès","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7FUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"BitStream","id":"3faf7532-4b3e-596f-32d6-80f01c72f86d","sequence":10,"value":"BITSTREAM"},{"displayText":"DP","id":"70fef684-d092-6884-3004-c222898ed8e4","sequence":20,"value":"DP"},{"displayText":"VULA","id":"88c896cd-83c3-bc40-e43a-130f9de09303","sequence":30,"value":"VULA"}],"default":[],"selectedItem":{"displayText":"VULA","id":"88c896cd-83c3-bc40-e43a-130f9de09303","sequence":30,"value":"VULA"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7GUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_POSITMDF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Position réglette de la paire","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7IUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"12345"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7NUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à lacquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":34403,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7UUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"34403","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}],"values":[{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}],"selectedItem":{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7QUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROVIDERADSL","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7JUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JUQhQAO","attributeid__c":"a0X3L0000010P7nUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_RESTDATA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Restriction","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001HgN8UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Bloqué","id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","sequence":10,"value":"Bloqué"},{"displayText":"Autorisé","id":"9c750118-8e12-899a-dda1-913db1492230","sequence":20,"value":"Autorisé"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7tUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_SLOT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro de Slot","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7MUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7wUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_SUBID","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Sub ID IMS","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7NUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P87UAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7VUAS","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}],"values":[{"value":"CI","sequence":10,"id":"a6710204-54cb-3e78-0589-475d24e6c869","displayText":"Collaborateur Inwi"},{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}],"selectedItem":{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P8AUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPPORT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de Port","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7PUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010lFTUAY","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NRA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nom du site ADSL","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001I49QUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text"},"$$AttributeDefinitionEnd$$":null}]}';           
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
            
                           //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef1;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef1;

            vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder.Id);
            insert planId1;


            vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__OrderId__c=neworder.Id);
            insert FRId1;



            vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
            insert FRLine1;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
            insert FRLineDecom1;

            vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item3;

            System.debug('Item Name : ' +item3.Name);

            vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item4;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling1.add(item3);
            allItemsGenBilling1.add(item4);
            
            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
            InwiItemCreate1.executeBatch(allItemsGenBilling1);
        }

        //////////////////////////////////////////////////////////////////////////////////////////////////////
        @isTest(SeeAllData=false)
        public static void batchOrderMigAdslFTTH() {
            Account testAccount = new Account(Name='Test Account');
            insert testAccount;

            Account site =new Account(Name='site Test', inwiB2C_Adresse_Facture_IAM__c='|55|;|0099;Lot Amal 2|;|00010;Lotissement Amal 2|;|08004;CASABLANCA AIN HARROUDA|;|08;CASA SIDI BERNOUSSI ZENATA|',InwiB2C_NomIAM__c='nom Test',InwiB2C_PrenomIAM__c='prenom Test', inwiB2C_numero_de_designation__c='522324578');
            insert site;

            Test.startTest();

            vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
			insert VloPickList;
            
            vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
			insert VloPickList1;
            
            vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
			insert VloPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList;
            
            vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList1;
            
            vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
            insert NewPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
            insert NewPickList3;
            
            system.debug('PICKLIST : '+ NewPickList2);

            
            Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'ADSL');
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

            vlocity_cmt__Subscription__c ligne=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='212511223344',Inwib2c_Num_ro_de_la_ligne__c='212511223344',Name='TEST');
            insert ligne;

            Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c;

            order neworder = new Order ( Pricebook2Id = customPB.Id,inwiB2C_Statut__c ='inwiB2C_EnCours', inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration',EffectiveDate = Date.today().addDays(-1), Status = 'Draft',contractId=c.id, AccountId =testAccount.Id,inwiB2C_TypeDeMigration__c='InwiB2C_Migration_ADSL_Vers_FTTH',InwiB2C_Subscription_Migration__c=ligne.Id,vlocity_cmt__DefaultServiceAccountId__c=site.Id);
            insert neworder;

            inwiB2C_OrderSubscription__c orderSub = new inwiB2C_OrderSubscription__c(inwiB2C_Subscription__c = ligne.Id,inwiB2C_Order__c=newOrder.Id);
            insert orderSub;

            InwiB2C_Sequence_Order_Number__c seqNum = new InwiB2C_Sequence_Order_Number__c(name='Sequence Degroupage',InwiB2C_Sequence__c=1);
            insert seqNum;

		 	InwiB2C_Commande_de_degroupage__c commandeDeg=new InwiB2C_Commande_de_degroupage__c(InwiB2C_Order__c =neworder.id);
            insert commandeDeg;	
            
            INWIB2C_DEMANDE_DEGROUPAGE__c demandeDeg = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_Commande_de_degroupage__c=commandeDeg.id,InwiB2C_ACTION__c='ADD',InwiB2C_ADRESSE__c='adresseTest',InwiB2C_Account__c=testAccount.Id,InwiB2C_AdresseIAMProposee__c='adresseTest',InwiB2C_Agence__c=testAccount.Id,InwiB2C_BAT__c='bat',InwiB2C_CCOM__c='com',InwiB2C_CLIENT_TYPE__c='B2C',InwiB2C_CQUARTIER__c='quartie',InwiB2C_CVOIE__c='voie',InwiB2C_CodeMotifRejet__c='29',InwiB2C_Commentaire__c='comm',InwiB2C_DEGROUPAGE_NUM__c=70000015,InwiB2C_Debit__c='20 Mb/s',InwiB2C_DetailErreur__c='err',InwiB2C_Dslamport__c='port',InwiB2C_ESC__c='esc',InwiB2C_ETAGE__c='etage',InwiB2C_FirstName__c='prenom',InwiB2C_MotifAnnulation__c='CNN',InwiB2C_Motif__c='motif',InwiB2C_NVOIE__c='nvoie',InwiB2C_Nationalid__c='123456',InwiB2C_NouvelleTechnologie__c='VULA',InwiB2C_NumeroDesignation__c='0511223344',InwiB2C_Order__c=neworder.Id,InwiB2C_PORTE__c='porte',InwiB2C_PartenaireCode__c='CMS01',InwiB2C_SEQ_NUM__c=1,InwiB2C_Site__c=testAccount.Id,InwiB2C_StatutDegroupageIAM__c='ok',InwiB2C_StatutLigneIam__c='LI',InwiB2C_Statutdegroupage__c='REJ',InwiB2C_Technologie__c='VULA',InwiB2C_categorieClient__c='R',InwiB2C_codeOpDemandeur__c='WNA',InwiB2C_codeRoutage__c='E2101');
            insert demandeDeg;

             String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P5vUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CRINSTAL","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Créneau installation","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh73UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Date","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Date","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P65UAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DEBIT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Débit data","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh74UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6BUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DSLAMNAME","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nom du DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh75UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6HUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DSLSRCSTAT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Statut dégroupage de ladresse","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh76UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Ligne active","id":"6abebe37-889c-3985-9507-7a0c02bb7451","sequence":10,"value":"LA"},{"displayText":"Ligne inactive","id":"503b01a0-d2fa-29f0-80fa-a14acbeb9d84","sequence":20,"value":"LI"}],"default":[],"selectedItem":{"displayText":"Ligne active","id":"6abebe37-889c-3985-9507-7a0c02bb7451","sequence":10,"value":"LI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6PUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_FRAME","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro du Frame","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh79UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6VUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IDPORTDSLAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ID CRM du port DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7AUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6ZUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IRSID","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IRS ID IMS","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7BUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6tUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ODSLB2CTA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Technologie d’accès","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7FUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"BitStream","id":"3faf7532-4b3e-596f-32d6-80f01c72f86d","sequence":10,"value":"BITSTREAM"},{"displayText":"DP","id":"70fef684-d092-6884-3004-c222898ed8e4","sequence":20,"value":"DP"},{"displayText":"VULA","id":"88c896cd-83c3-bc40-e43a-130f9de09303","sequence":30,"value":"VULA"}],"default":[],"selectedItem":{"displayText":"VULA","id":"88c896cd-83c3-bc40-e43a-130f9de09303","sequence":30,"value":"VULA"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7GUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_POSITMDF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Position réglette de la paire","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7IUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"12345"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7NUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à lacquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":34403,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7UUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"34403","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}],"values":[{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}],"selectedItem":{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7QUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROVIDERADSL","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7JUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JUQhQAO","attributeid__c":"a0X3L0000010P7nUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_RESTDATA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Restriction","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001HgN8UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Bloqué","id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","sequence":10,"value":"Bloqué"},{"displayText":"Autorisé","id":"9c750118-8e12-899a-dda1-913db1492230","sequence":20,"value":"Autorisé"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7tUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_SLOT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro de Slot","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7MUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7wUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_SUBID","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Sub ID IMS","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7NUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P87UAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7VUAS","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}],"values":[{"value":"CI","sequence":10,"id":"a6710204-54cb-3e78-0589-475d24e6c869","displayText":"Collaborateur Inwi"},{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}],"selectedItem":{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P8AUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPPORT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de Port","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7PUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010lFTUAY","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NRA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nom du site ADSL","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001I49QUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text"},"$$AttributeDefinitionEnd$$":null}]}';           
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
            
                           //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__ParentItemId__c = '',
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;
            Asset asset2 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                vlocity_cmt__SubscriptionId__c = ligne.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__ParentItemId__c = ''
                );
                insert asset2;

            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef1;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef1;

            vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder.Id);
            insert planId1;


            vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__OrderId__c=neworder.Id);
            insert FRId1;



            vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
            insert FRLine1;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
            insert FRLineDecom1;

            vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item3;

            System.debug('Item Name : ' +item3.Name);

            vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item4;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling1.add(item3);
            allItemsGenBilling1.add(item4);
            
            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
            InwiItemCreate1.executeBatch(allItemsGenBilling1);

            Test.stopTest();
        }

        @isTest(SeeAllData=false)
        public static void batchOrderDeconnecterServiceADSL() {
            Account testAccount = new Account(Name='Test Account');
            insert testAccount;

            Account site =new Account(Name='site Test', inwiB2C_Adresse_Facture_IAM__c='|55|;|0099;Lot Amal 2|;|00010;Lotissement Amal 2|;|08004;CASABLANCA AIN HARROUDA|;|08;CASA SIDI BERNOUSSI ZENATA|',InwiB2C_NomIAM__c='nom Test',InwiB2C_PrenomIAM__c='prenom Test', inwiB2C_numero_de_designation__c='522324578');
            insert site;

            Test.startTest();

            vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
			insert VloPickList;
            
            vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
			insert VloPickList1;
            
            vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
			insert VloPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList;
            
            vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList1;
            
            vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
            insert NewPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
            insert NewPickList3;
            
            system.debug('PICKLIST : '+ NewPickList2);

            
            Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'ADSL');
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

            vlocity_cmt__Subscription__c ligne=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='212511223344',Inwib2c_Num_ro_de_la_ligne__c='212511223344',Name='TEST');
            insert ligne;

            Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c;

            order neworder = new Order ( Pricebook2Id = customPB.Id,inwiB2C_Statut__c ='inwiB2C_EnCours', inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',EffectiveDate = Date.today().addDays(-1), Status = 'Draft',contractId=c.id, AccountId =testAccount.Id,inwiB2C_TypeActeDeGestion__c='InwiB2C_Remboursement_Offre',InwiB2C_Subscription_Migration__c=ligne.Id,vlocity_cmt__DefaultServiceAccountId__c=site.Id,InwiB2C_Offre__c='ADSL XTRA by inwi Jusqu\'à 20 Mega');
            insert neworder;

            inwiB2C_OrderSubscription__c orderSub = new inwiB2C_OrderSubscription__c(inwiB2C_Subscription__c = ligne.Id,inwiB2C_Order__c=newOrder.Id);
            insert orderSub;

            InwiB2C_Sequence_Order_Number__c seqNum = new InwiB2C_Sequence_Order_Number__c(name='Sequence Degroupage',InwiB2C_Sequence__c=1);
            insert seqNum;

			InwiB2C_Commande_de_degroupage__c commandeDeg=new InwiB2C_Commande_de_degroupage__c(InwiB2C_Order__c =neworder.id);
            insert commandeDeg;
            
            INWIB2C_DEMANDE_DEGROUPAGE__c demandeDeg = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_Commande_de_degroupage__c=commandeDeg.id,InwiB2C_ACTION__c='ADD',InwiB2C_ADRESSE__c='adresseTest',InwiB2C_Account__c=testAccount.Id,InwiB2C_AdresseIAMProposee__c='adresseTest',InwiB2C_Agence__c=testAccount.Id,InwiB2C_BAT__c='bat',InwiB2C_CCOM__c='com',InwiB2C_CLIENT_TYPE__c='B2C',InwiB2C_CQUARTIER__c='quartie',InwiB2C_CVOIE__c='voie',InwiB2C_CodeMotifRejet__c='29',InwiB2C_Commentaire__c='comm',InwiB2C_DEGROUPAGE_NUM__c=70000015,InwiB2C_Debit__c='20 Mb/s',InwiB2C_DetailErreur__c='err',InwiB2C_Dslamport__c='port',InwiB2C_ESC__c='esc',InwiB2C_ETAGE__c='etage',InwiB2C_FirstName__c='prenom',InwiB2C_MotifAnnulation__c='CNN',InwiB2C_Motif__c='motif',InwiB2C_NVOIE__c='nvoie',InwiB2C_Nationalid__c='123456',InwiB2C_NouvelleTechnologie__c='VULA',InwiB2C_NumeroDesignation__c='0511223344',InwiB2C_Order__c=neworder.Id,InwiB2C_PORTE__c='porte',InwiB2C_PartenaireCode__c='CMS01',InwiB2C_SEQ_NUM__c=1,InwiB2C_Site__c=testAccount.Id,InwiB2C_StatutDegroupageIAM__c='ok',InwiB2C_StatutLigneIam__c='LI',InwiB2C_Statutdegroupage__c='REJ',InwiB2C_Technologie__c='VULA',InwiB2C_categorieClient__c='R',InwiB2C_codeOpDemandeur__c='WNA',InwiB2C_codeRoutage__c='E2101');
            insert demandeDeg;

             String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P5vUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CRINSTAL","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Créneau installation","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh73UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Date","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Date","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P65UAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DEBIT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Débit data","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh74UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6BUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DSLAMNAME","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nom du DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh75UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6HUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DSLSRCSTAT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Statut dégroupage de ladresse","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh76UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Ligne active","id":"6abebe37-889c-3985-9507-7a0c02bb7451","sequence":10,"value":"LA"},{"displayText":"Ligne inactive","id":"503b01a0-d2fa-29f0-80fa-a14acbeb9d84","sequence":20,"value":"LI"}],"default":[],"selectedItem":{"displayText":"Ligne active","id":"6abebe37-889c-3985-9507-7a0c02bb7451","sequence":10,"value":"LI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6PUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_FRAME","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro du Frame","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh79UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6VUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IDPORTDSLAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ID CRM du port DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7AUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6ZUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IRSID","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IRS ID IMS","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7BUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6tUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ODSLB2CTA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Technologie d’accès","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7FUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"BitStream","id":"3faf7532-4b3e-596f-32d6-80f01c72f86d","sequence":10,"value":"BITSTREAM"},{"displayText":"DP","id":"70fef684-d092-6884-3004-c222898ed8e4","sequence":20,"value":"DP"},{"displayText":"VULA","id":"88c896cd-83c3-bc40-e43a-130f9de09303","sequence":30,"value":"VULA"}],"default":[],"selectedItem":{"displayText":"VULA","id":"88c896cd-83c3-bc40-e43a-130f9de09303","sequence":30,"value":"VULA"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7GUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_POSITMDF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Position réglette de la paire","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7IUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"12345"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7NUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à lacquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":34403,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7UUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"34403","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}],"values":[{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}],"selectedItem":{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7QUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROVIDERADSL","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7JUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JUQhQAO","attributeid__c":"a0X3L0000010P7nUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_RESTDATA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Restriction","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001HgN8UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Bloqué","id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","sequence":10,"value":"Bloqué"},{"displayText":"Autorisé","id":"9c750118-8e12-899a-dda1-913db1492230","sequence":20,"value":"Autorisé"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7tUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_SLOT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro de Slot","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7MUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7wUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_SUBID","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Sub ID IMS","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7NUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P87UAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7VUAS","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}],"values":[{"value":"CI","sequence":10,"id":"a6710204-54cb-3e78-0589-475d24e6c869","displayText":"Collaborateur Inwi"},{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}],"selectedItem":{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P8AUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPPORT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de Port","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7PUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010lFTUAY","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NRA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nom du site ADSL","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001I49QUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text"},"$$AttributeDefinitionEnd$$":null}]}';           
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
            
                           //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__ParentItemId__c = '',
                vlocity_cmt__SubscriptionId__c = ligne.Id,
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;
            Asset asset2 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                vlocity_cmt__SubscriptionId__c = ligne.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__ParentItemId__c = ''
                );
                insert asset2;
            newOrderitem.vlocity_cmt__AssetId__c = asset1.Id;
            update newOrderitem;
            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef1;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef1;

            vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder.Id);
            insert planId1;


            vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__OrderId__c=neworder.Id);
            insert FRId1;



            vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
            insert FRLine1;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
            insert FRLineDecom1;

            vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item3;

            System.debug('Item Name : ' +item3.Name);

            vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item4;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling1.add(item3);
            allItemsGenBilling1.add(item4);
            
            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
            InwiItemCreate1.executeBatch(allItemsGenBilling1);
             
          /*  newOrder.inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification';
            neworder.inwiB2C_TypeActeDeGestion__c ='InwiB2C_DéconnecterService';
            neworder.InwiB2C_Offre__c='ADSL XTRA by inwi Jusqu\'à 20 Mega';
            update newOrder;
            
			INWIB2CCreateSubscription InwiItemCreate2 = new INWIB2CCreateSubscription();
            InwiItemCreate2.executeBatch(allItemsGenBilling1);*/
            Test.stopTest();
        } 
        ///////////////////////////////////////////////////////////////////////
        @isTest(SeeAllData=false)
        public static void batchOrderResilDeg() {
            Account testAccount = new Account(Name='Test Account');
            insert testAccount;

            Account site =new Account(Name='site Test', inwiB2C_Adresse_Facture_IAM__c='|55|;|0099;Lot Amal 2|;|00010;Lotissement Amal 2|;|08004;CASABLANCA AIN HARROUDA|;|08;CASA SIDI BERNOUSSI ZENATA|',InwiB2C_NomIAM__c='nom Test',InwiB2C_PrenomIAM__c='prenom Test', inwiB2C_numero_de_designation__c='522324578');
            insert site;

            Test.startTest();

            vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
			insert VloPickList;
            
            vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
			insert VloPickList1;
            
            vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
			insert VloPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList;
            
            vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList1;
            
            vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
            insert NewPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
            insert NewPickList3;
            
            system.debug('PICKLIST : '+ NewPickList2);

            Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
            insert c;
            
            Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'ADSL');
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

            vlocity_cmt__Subscription__c ligne=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='212511223344',Inwib2c_Num_ro_de_la_ligne__c='212511223344',Name='TEST');
            insert ligne;

            order acqorder = new Order ( Pricebook2Id = customPB.Id,inwiB2C_Statut__c ='inwiB2C_EnCours', inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',EffectiveDate = Date.today().addDays(-1), Status = 'Draft',contractId=c.id, AccountId =testAccount.Id,vlocity_cmt__DefaultServiceAccountId__c=site.Id,InwiB2C_Offre__c='ADSL XTRA by inwi Jusqu\'à 20 Mega');
            insert acqorder;

            inwiB2C_OrderSubscription__c orderSub = new inwiB2C_OrderSubscription__c(inwiB2C_Subscription__c = ligne.Id,inwiB2C_Order__c=acqorder.Id);
            insert orderSub;

            InwiB2C_Sequence_Order_Number__c seqNum = new InwiB2C_Sequence_Order_Number__c(name='Sequence Degroupage',InwiB2C_Sequence__c=1);
            insert seqNum;
            
																																			
            
 			order neworder = new Order ( Pricebook2Id = customPB.Id,inwiB2C_Statut__c ='inwiB2C_Activation', inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',EffectiveDate = Date.today().addDays(-1), Status = 'Draft',contractId=c.id, AccountId =testAccount.Id,vlocity_cmt__DefaultServiceAccountId__c=site.Id,InwiB2C_Offre__c='ADSL XTRA by inwi Jusqu\'à 20 Mega',inwiB2C_TypeActeDeGestion__c='InwiB2C_ResiliationSuiteAnnulationDegroupage');
            insert neworder;
            
            InwiB2C_Commande_de_degroupage__c commandeDeg=new InwiB2C_Commande_de_degroupage__c(InwiB2C_Order__c =neworder.id);
            insert commandeDeg;
            
            INWIB2C_DEMANDE_DEGROUPAGE__c demandeDeg = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_Commande_de_degroupage__c=commandeDeg.id,InwiB2C_ACTION__c='ADD',InwiB2C_ADRESSE__c='adresseTest',InwiB2C_Account__c=testAccount.Id,InwiB2C_AdresseIAMProposee__c='adresseTest',InwiB2C_Agence__c=testAccount.Id,InwiB2C_BAT__c='bat',InwiB2C_CCOM__c='com',InwiB2C_CLIENT_TYPE__c='B2C',InwiB2C_CQUARTIER__c='quartie',InwiB2C_CVOIE__c='voie',InwiB2C_CodeMotifRejet__c='29',InwiB2C_Commentaire__c='comm',InwiB2C_DEGROUPAGE_NUM__c=70000015,InwiB2C_Debit__c='20 Mb/s',InwiB2C_DetailErreur__c='err',InwiB2C_Dslamport__c='port',InwiB2C_ESC__c='esc',InwiB2C_ETAGE__c='etage',InwiB2C_FirstName__c='prenom',InwiB2C_MotifAnnulation__c='CNN',InwiB2C_Motif__c='motif',InwiB2C_NVOIE__c='nvoie',InwiB2C_Nationalid__c='123456',InwiB2C_NouvelleTechnologie__c='VULA',InwiB2C_NumeroDesignation__c='0511223344',InwiB2C_Order__c=acqorder.Id,InwiB2C_PORTE__c='porte',InwiB2C_PartenaireCode__c='CMS01',InwiB2C_SEQ_NUM__c=1,InwiB2C_Site__c=testAccount.Id,InwiB2C_StatutDegroupageIAM__c='ok',InwiB2C_StatutLigneIam__c='LI',InwiB2C_Statutdegroupage__c='ANN',InwiB2C_Technologie__c='VULA',InwiB2C_categorieClient__c='R',InwiB2C_codeOpDemandeur__c='WNA',InwiB2C_codeRoutage__c='E2101');
			insert demandeDeg;
            
            inwiB2C_OrderSubscription__c orderSub2 = new inwiB2C_OrderSubscription__c(inwiB2C_Subscription__c = ligne.Id,inwiB2C_Order__c=neworder.Id);
            insert orderSub2;
            
             String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P5vUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CRINSTAL","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Créneau installation","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh73UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Date","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Date","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P65UAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DEBIT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Débit data","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh74UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6BUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DSLAMNAME","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nom du DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh75UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6HUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_DSLSRCSTAT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Statut dégroupage de ladresse","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh76UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Ligne active","id":"6abebe37-889c-3985-9507-7a0c02bb7451","sequence":10,"value":"LA"},{"displayText":"Ligne inactive","id":"503b01a0-d2fa-29f0-80fa-a14acbeb9d84","sequence":20,"value":"LI"}],"default":[],"selectedItem":{"displayText":"Ligne active","id":"6abebe37-889c-3985-9507-7a0c02bb7451","sequence":10,"value":"LI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6PUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_FRAME","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro du Frame","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh79UAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6VUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IDPORTDSLAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ID CRM du port DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7AUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6ZUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IRSID","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IRS ID IMS","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7BUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P6tUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ODSLB2CTA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Technologie d’accès","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7FUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"BitStream","id":"3faf7532-4b3e-596f-32d6-80f01c72f86d","sequence":10,"value":"BITSTREAM"},{"displayText":"DP","id":"70fef684-d092-6884-3004-c222898ed8e4","sequence":20,"value":"DP"},{"displayText":"VULA","id":"88c896cd-83c3-bc40-e43a-130f9de09303","sequence":30,"value":"VULA"}],"default":[],"selectedItem":{"displayText":"VULA","id":"88c896cd-83c3-bc40-e43a-130f9de09303","sequence":30,"value":"VULA"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7GUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_POSITMDF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Position réglette de la paire","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7IUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"12345"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7NUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à lacquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":34403,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7UUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"34403","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}],"values":[{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}],"selectedItem":{"displayText":"ADSL","id":"cde7c0c3-986b-9808-0d67-7aa2b3a92400","sequence":10,"value":"34403"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7QUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROVIDERADSL","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de DSLAM","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7JUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JUQhQAO","attributeid__c":"a0X3L0000010P7nUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_RESTDATA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Restriction","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001HgN8UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Bloqué","id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","sequence":10,"value":"Bloqué"},{"displayText":"Autorisé","id":"9c750118-8e12-899a-dda1-913db1492230","sequence":20,"value":"Autorisé"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7tUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_SLOT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro de Slot","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7MUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P7wUAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_SUBID","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Sub ID IMS","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7NUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P87UAE","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7VUAS","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}],"values":[{"value":"CI","sequence":10,"id":"a6710204-54cb-3e78-0589-475d24e6c869","displayText":"Collaborateur Inwi"},{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}],"selectedItem":{"value":"GP","sequence":40,"id":"760ea4a8-8d07-0f37-a073-7a889038085c","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010P8AUAU","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPPORT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de Port","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001Hh7PUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIcdQAG","attributeid__c":"a0X3L0000010lFTUAY","attributecategoryid__c":"a0W3L000003IhfzUAC","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NRA","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nom du site ADSL","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001I49QUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text"},"$$AttributeDefinitionEnd$$":null}]}';           
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
            
                           //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__ParentItemId__c = '',
                vlocity_cmt__SubscriptionId__c = ligne.Id,
                vlocity_cmt__OrderProductId__c = newOrderitem.Id
                );
                insert asset1;
            Asset asset2 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                vlocity_cmt__SubscriptionId__c = ligne.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__ParentItemId__c = ''
                );
                insert asset2;
            newOrderitem.vlocity_cmt__AssetId__c = asset1.Id;
            update newOrderitem;
            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef1;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef1;

            vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder.Id);
            insert planId1;


            vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__OrderId__c=neworder.Id);
            insert FRId1;



            vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
            insert FRLine1;


            vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
            insert FRLineDecom1;

            vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item3;

            System.debug('Item Name : ' +item3.Name);

            vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item4;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling1.add(item3);
            allItemsGenBilling1.add(item4);
            
            //END OF ORECHESTRATION PLAN
            
            //insert neworder;
            //Id bacthId2 = Database.executeBatch( new INWIB2CCreateSubscription() , 10 );
            INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
            InwiItemCreate1.executeBatch(allItemsGenBilling1);
             
          /*  newOrder.inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification';
            neworder.inwiB2C_TypeActeDeGestion__c ='InwiB2C_DéconnecterService';
            neworder.InwiB2C_Offre__c='ADSL XTRA by inwi Jusqu\'à 20 Mega';
            update newOrder;
            
			INWIB2CCreateSubscription InwiItemCreate2 = new INWIB2CCreateSubscription();
            InwiItemCreate2.executeBatch(allItemsGenBilling1);*/
            Test.stopTest();
        }
        @isTest(SeeAllData=false)
        public static void batchOrderTestSusFacturation() {
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            Test.startTest();
            vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
			insert VloPickList;
            
            
            vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList1;
           
            //Product
            Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'Prepaye');
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
            Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
                 insert c;
            

            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id,inwiB2C_TypeActeDeGestion__c='inwiB2C_SuspensionFacturationReseau');
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNUUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_TypHandset","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type Handset","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}],"values":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"},{"value":"TERM","sequence":20,"id":"b1e73d9a-7aba-cd66-f5b8-bedaa7b3da92","displayText":"TERM"}],"selectedItem":{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OYtrUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_CUSTRISKPLAF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Plafond Risque Personnalisé","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":-999,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001AnFzUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":"-999","valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","default":"-999","value":"-999"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYupUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_ElligibleAuTypeLigne","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Elligible au type de ligne","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYuuUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_NUMERO_ADHERANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro adhérant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxklUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InDUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkmUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InEUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkvUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ENGAGEMENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Engagement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"0","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}],"values":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"},{"value":"12","sequence":20,"id":"43d82073-ac9e-d6e4-fd43-252ccd7619c5","displayText":"12 Mois"},{"value":"24","sequence":30,"id":"1874b54d-5b3d-6205-5fec-c5ac54e2c251","displayText":"24 Mois"}],"selectedItem":{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkyUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_GAMME_OFFRE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Gamme offre","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GALAXY","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}],"values":[{"value":"AMY","sequence":10,"id":"538aeaef-176d-2f05-c1aa-7a46eeb6fe46","displayText":"forfait Famille"},{"value":"BATMAN","sequence":20,"id":"da7bdac4-13d9-edd9-c1b3-89cd3a3c7221","displayText":"Batman"},{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"},{"value":"SW2","sequence":40,"id":"5ea7bea2-ea69-1f03-9458-4bbfd69eef24","displayText":"Star wars"},{"value":"PIZZA","sequence":50,"id":"d9f33766-032b-9ad5-3fd5-7d9444a61ce4","displayText":"Pizza"}],"selectedItem":{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlAUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NOMBRE_RECURENCE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre de récurrences pour remise","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86907,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InFUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86907","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}],"values":[{"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet","value":"86907","sequence":30},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlQUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_DIRHAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en Dh sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlYUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_POURCENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en % sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxllUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InCUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}],"values":[{"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public","value":"GP","sequence":40}],"selectedItem":{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTVUA4","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFAPP","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Application à partir de la nièm facture","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhDUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTaUAO","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFDIF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en différée","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNZUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_EXISTXGO","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Exist XGo","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"NON","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}],"values":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"},{"value":"OUI","sequence":20,"id":"16ef43d9-9e0b-20e6-aa23-e8bfbcf36257","displayText":"OUI"}],"selectedItem":{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}},"$$AttributeDefinitionEnd$$":null}]}';           
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
            OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem2;
             //Create Subscription 
            DateTime dateLimite = System.now();
            dateLimite = dateLimite.addDays(8); 
            Date dateLimiteSR = date.newinstance(dateLimite.year(), dateLimite.month(), dateLimite.day());
            vlocity_cmt__Subscription__c newSubsc1=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223344',Inwib2c_Num_ro_de_la_ligne__c='0611223344',Name='TEST',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active',InwiB2C_FMD__c=99,InwiB2C_FMS__c=100,InwiB2C_Code_de_transaction_FMD__c='1223',InwiB2C_Code_de_transaction_FMS__c='23456=',InwiB2C_date_limite_satisfait_rembours__c=dateLimiteSR,InwiB2C_Date_d_activation__c=dateLimite);
			Insert newSubsc1;
            //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id,
                vlocity_cmt__SubscriptionId__c=newSubsc1.Id
                );
                insert asset1;
            
            newOrderitem.vlocity_cmt__AssetId__c=asset1.Id;
            update newOrderitem;
            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef1;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef1;
             vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder.Id);
            insert planId1;


            vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__OrderId__c=neworder.Id);
            insert FRId1;



            vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
            insert FRLine1;
             vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
            insert FRLineDecom1;

            vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item3;

            System.debug('Item Name : ' +item3.Name);

            vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item4;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling1.add(item3);
            allItemsGenBilling1.add(item4);
            
            //END OF ORECHESTRATION PLAN
            INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
            InwiItemCreate1.executeBatch(allItemsGenBilling1);
            Test.stopTest();
    }
              ////////////////////////////////////////////////////////////////////////////////
        @isTest(SeeAllData=false)
        public static void batchOrderTestMigrationPostPost() {
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            Test.startTest();
            vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
			insert VloPickList;
            
            vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
			insert VloPickList1;
            
            vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
			insert VloPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList;
            
            vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList1;
            
            vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
            insert NewPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
            insert NewPickList3;
            //Product
            Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'FTTH');
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
            Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
                 insert c;
            

            order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id,inwiB2C_TypeDeMigration__c='Migration Postpayé Postpayé');
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNUUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_TypHandset","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type Handset","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}],"values":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"},{"value":"TERM","sequence":20,"id":"b1e73d9a-7aba-cd66-f5b8-bedaa7b3da92","displayText":"TERM"}],"selectedItem":{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OYtrUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_CUSTRISKPLAF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Plafond Risque Personnalisé","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":-999,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001AnFzUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":"-999","valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","default":"-999","value":"-999"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYupUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_ElligibleAuTypeLigne","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Elligible au type de ligne","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYuuUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_NUMERO_ADHERANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro adhérant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxklUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InDUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkmUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InEUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkvUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ENGAGEMENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Engagement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"0","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}],"values":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"},{"value":"12","sequence":20,"id":"43d82073-ac9e-d6e4-fd43-252ccd7619c5","displayText":"12 Mois"},{"value":"24","sequence":30,"id":"1874b54d-5b3d-6205-5fec-c5ac54e2c251","displayText":"24 Mois"}],"selectedItem":{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkyUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_GAMME_OFFRE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Gamme offre","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GALAXY","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}],"values":[{"value":"AMY","sequence":10,"id":"538aeaef-176d-2f05-c1aa-7a46eeb6fe46","displayText":"forfait Famille"},{"value":"BATMAN","sequence":20,"id":"da7bdac4-13d9-edd9-c1b3-89cd3a3c7221","displayText":"Batman"},{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"},{"value":"SW2","sequence":40,"id":"5ea7bea2-ea69-1f03-9458-4bbfd69eef24","displayText":"Star wars"},{"value":"PIZZA","sequence":50,"id":"d9f33766-032b-9ad5-3fd5-7d9444a61ce4","displayText":"Pizza"}],"selectedItem":{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlAUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NOMBRE_RECURENCE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre de récurrences pour remise","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86907,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InFUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86907","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}],"values":[{"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet","value":"86907","sequence":30},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlQUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_DIRHAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en Dh sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlYUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_POURCENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en % sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxllUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InCUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}],"values":[{"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public","value":"GP","sequence":40}],"selectedItem":{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTVUA4","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFAPP","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Application à partir de la nièm facture","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhDUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTaUAO","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFDIF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en différée","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNZUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_EXISTXGO","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Exist XGo","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"NON","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}],"values":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"},{"value":"OUI","sequence":20,"id":"16ef43d9-9e0b-20e6-aa23-e8bfbcf36257","displayText":"OUI"}],"selectedItem":{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}},"$$AttributeDefinitionEnd$$":null}]}';           
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
            OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem2;
             //Create Subscription 
            DateTime dateLimite = System.now();
            dateLimite = dateLimite.addDays(8); 
            Date dateLimiteSR = date.newinstance(dateLimite.year(), dateLimite.month(), dateLimite.day());
            vlocity_cmt__Subscription__c newSubsc1=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223344',Inwib2c_Num_ro_de_la_ligne__c='0611223344',Name='TEST',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active',InwiB2C_FMD__c=99,InwiB2C_FMS__c=100,InwiB2C_Code_de_transaction_FMD__c='1223',InwiB2C_Code_de_transaction_FMS__c='23456=',InwiB2C_date_limite_satisfait_rembours__c=dateLimiteSR,InwiB2C_Date_d_activation__c=dateLimite);
			Insert newSubsc1;
            //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id,
                vlocity_cmt__SubscriptionId__c=newSubsc1.Id
                );
                insert asset1;
            
            newOrderitem.vlocity_cmt__AssetId__c=asset1.Id;
            update newOrderitem;
            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef1;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef1;
             vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder.Id);
            insert planId1;


            vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__OrderId__c=neworder.Id);
            insert FRId1;



            vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
            insert FRLine1;
             vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
            insert FRLineDecom1;

            vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item3;

            System.debug('Item Name : ' +item3.Name);

            vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item4;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling1.add(item3);
            allItemsGenBilling1.add(item4);
            
            //END OF ORECHESTRATION PLAN
            INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
            InwiItemCreate1.executeBatch(allItemsGenBilling1);
            Test.stopTest();
    }
        
        ///////////////////////////////////////////////////
        @isTest(SeeAllData=false)
        public static void batchOrderTestSynchroAsset() {
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            Test.startTest();
            vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
			insert VloPickList;
            vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
			insert VloPickList1;
            vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
			insert VloPickList2;
            vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList;
            
            vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
            insert NewPickList1;
            
            vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
            insert NewPickList2;
            
            vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
            insert NewPickList3;
            //Product
            Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'Postpaye');
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
            Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
                 insert c;
            
            order neworder = new Order (inwiB2C_Canal__c='inwiB2C_USSD',Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id,inwiB2C_TypeActeDeGestion__c='inwiB2C_Synchronisation_Assets');
            insert neworder;
            
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNUUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_TypHandset","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type Handset","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}],"values":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"},{"value":"TERM","sequence":20,"id":"b1e73d9a-7aba-cd66-f5b8-bedaa7b3da92","displayText":"TERM"}],"selectedItem":{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OYtrUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_CUSTRISKPLAF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Plafond Risque Personnalisé","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":-999,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001AnFzUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":"-999","valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","default":"-999","value":"-999"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYupUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_ElligibleAuTypeLigne","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Elligible au type de ligne","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYuuUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_NUMERO_ADHERANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro adhérant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxklUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InDUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkmUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InEUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkvUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ENGAGEMENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Engagement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"0","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}],"values":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"},{"value":"12","sequence":20,"id":"43d82073-ac9e-d6e4-fd43-252ccd7619c5","displayText":"12 Mois"},{"value":"24","sequence":30,"id":"1874b54d-5b3d-6205-5fec-c5ac54e2c251","displayText":"24 Mois"}],"selectedItem":{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkyUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_GAMME_OFFRE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Gamme offre","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GALAXY","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}],"values":[{"value":"AMY","sequence":10,"id":"538aeaef-176d-2f05-c1aa-7a46eeb6fe46","displayText":"forfait Famille"},{"value":"BATMAN","sequence":20,"id":"da7bdac4-13d9-edd9-c1b3-89cd3a3c7221","displayText":"Batman"},{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"},{"value":"SW2","sequence":40,"id":"5ea7bea2-ea69-1f03-9458-4bbfd69eef24","displayText":"Star wars"},{"value":"PIZZA","sequence":50,"id":"d9f33766-032b-9ad5-3fd5-7d9444a61ce4","displayText":"Pizza"}],"selectedItem":{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlAUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NOMBRE_RECURENCE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre de récurrences pour remise","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86907,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InFUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86907","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}],"values":[{"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet","value":"86907","sequence":30},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlQUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_DIRHAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en Dh sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlYUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_POURCENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en % sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxllUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InCUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}],"values":[{"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public","value":"GP","sequence":40}],"selectedItem":{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTVUA4","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFAPP","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Application à partir de la nièm facture","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhDUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTaUAO","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFDIF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en différée","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNZUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_EXISTXGO","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Exist XGo","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"NON","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}],"values":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"},{"value":"OUI","sequence":20,"id":"16ef43d9-9e0b-20e6-aa23-e8bfbcf36257","displayText":"OUI"}],"selectedItem":{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}},"$$AttributeDefinitionEnd$$":null}]}';           
            OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
            insert newOrderitem;
            InwiB2C_Trace_API__c trace = new InwiB2C_Trace_API__c(InwiB2C_API_Name__c='WS10',InwiB2C_OrderGenAssetId__c=neworder.Id);
            insert trace;
            //Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__OrderProductId__c = newOrderitem.Id,
                vlocity_cmt__ParentItemId__c = ''
                );
                insert asset1;
                        Asset asset2 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = testAccount.Id,
                InstallDate = System.Today(),
                Product2Id = prod.Id,
                UsageEndDate = System.Today(),
                vlocity_cmt__ParentItemId__c = ''
                );
                insert asset2;
            
            //ORCHESTRATION PLAN

            vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
            vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

            vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
            insert planDef1;

            vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
            vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
            Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
            vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

            insert itemDef1;
             vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
            vlocity_cmt__OrderId__c = neworder.Id);
            insert planId1;


            vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__OrderId__c=neworder.Id);
            insert FRId1;



            vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
                vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
            insert FRLine1;
             vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
            vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
            vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
            insert FRLineDecom1;

            vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item3;

            System.debug('Item Name : ' +item3.Name);

            vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

            vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
            vlocity_cmt__State__c='Completed',
            vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
            vlocity_cmt__OrderItemId__c = newOrderitem.Id);
            insert item4;


            List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
            allItemsGenBilling1.add(item3);
            allItemsGenBilling1.add(item4);
            
            //END OF ORECHESTRATION PLAN
            INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
            InwiItemCreate1.executeBatch(allItemsGenBilling1);
            Test.stopTest();
    }
// ILA 07/04/25
///////////////////////////////////////////////////
@isTest(SeeAllData=false)
public static void batchOrderTestMigrationCmpusPrep() {
    Account testAccount = new Account(Name='Test Account',inwib2c_UniversiteEtablissement__c='Université Chouaib Doukkali');
    insert testAccount;
    Test.startTest();
    vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
    insert VloPickList;
    
    vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
    insert VloPickList1;
    
    vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
    insert VloPickList2;
    
    vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
    insert NewPickList;
    
    vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
    insert NewPickList1;
    
    vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
    insert NewPickList2;
    
    vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
    insert NewPickList3;
    //Product
    Product2 prod = new Product2(Name = 'Laptop X200', 
                                 Family = 'Hardware',
                                 ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'Prepaye');
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
    Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
         insert c;
    

    order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Migration', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id,inwiB2C_TypeDeMigration__c='inwiB2C_Migration_Prepaye_vers_Campus',inwib2c_Canal__c='inwiB2C_MyInwi',Old_Account_id__c=testAccount.Id);
    insert neworder;
    
    String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNUUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_TypHandset","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type Handset","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}],"values":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"},{"value":"TERM","sequence":20,"id":"b1e73d9a-7aba-cd66-f5b8-bedaa7b3da92","displayText":"TERM"}],"selectedItem":{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OYtrUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_CUSTRISKPLAF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Plafond Risque Personnalisé","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":-999,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001AnFzUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":"-999","valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","default":"-999","value":"-999"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYupUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_ElligibleAuTypeLigne","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Elligible au type de ligne","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYuuUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_NUMERO_ADHERANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro adhérant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxklUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InDUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkmUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InEUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkvUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ENGAGEMENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Engagement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"0","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}],"values":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"},{"value":"12","sequence":20,"id":"43d82073-ac9e-d6e4-fd43-252ccd7619c5","displayText":"12 Mois"},{"value":"24","sequence":30,"id":"1874b54d-5b3d-6205-5fec-c5ac54e2c251","displayText":"24 Mois"}],"selectedItem":{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkyUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_GAMME_OFFRE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Gamme offre","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GALAXY","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}],"values":[{"value":"AMY","sequence":10,"id":"538aeaef-176d-2f05-c1aa-7a46eeb6fe46","displayText":"forfait Famille"},{"value":"BATMAN","sequence":20,"id":"da7bdac4-13d9-edd9-c1b3-89cd3a3c7221","displayText":"Batman"},{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"},{"value":"SW2","sequence":40,"id":"5ea7bea2-ea69-1f03-9458-4bbfd69eef24","displayText":"Star wars"},{"value":"PIZZA","sequence":50,"id":"d9f33766-032b-9ad5-3fd5-7d9444a61ce4","displayText":"Pizza"}],"selectedItem":{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlAUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NOMBRE_RECURENCE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre de récurrences pour remise","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86907,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InFUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86907","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}],"values":[{"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet","value":"86907","sequence":30},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlQUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_DIRHAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en Dh sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlYUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_POURCENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en % sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxllUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InCUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}],"values":[{"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public","value":"GP","sequence":40}],"selectedItem":{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTVUA4","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFAPP","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Application à partir de la nièm facture","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhDUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTaUAO","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFDIF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en différée","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNZUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_EXISTXGO","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Exist XGo","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"NON","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}],"values":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"},{"value":"OUI","sequence":20,"id":"16ef43d9-9e0b-20e6-aa23-e8bfbcf36257","displayText":"OUI"}],"selectedItem":{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}},"$$AttributeDefinitionEnd$$":null}]}';           
    OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
    insert newOrderitem;
    OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
    insert newOrderitem2;
     //Create Subscription 
    vlocity_cmt__Subscription__c newSubsc1=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223344',Inwib2c_Num_ro_de_la_ligne__c='0611223344',Name='TEST',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active'
    );
    Insert newSubsc1;
    //Create and Insert Asset
    Asset asset1 = new Asset(
        Name = 'Test Asset',
        Status = 'Installed',
        AccountId = testAccount.Id,
        InstallDate = System.Today(),
        Product2Id = prod.Id,
        UsageEndDate = System.Today(),
        vlocity_cmt__OrderProductId__c = newOrderitem.Id,
        vlocity_cmt__SubscriptionId__c=newSubsc1.Id
        );
        insert asset1;
    
    newOrderitem.vlocity_cmt__AssetId__c=asset1.Id;
    update newOrderitem;
    //ORCHESTRATION PLAN

    vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
    vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

    vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
    insert planDef1;

    vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
    vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
    Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
    vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

    insert itemDef1;
     vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
    vlocity_cmt__OrderId__c = neworder.Id);
    insert planId1;


    vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
    vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
    vlocity_cmt__OrderId__c=neworder.Id);
    insert FRId1;



    vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
        vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
    insert FRLine1;
     vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
    vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
    vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
    insert FRLineDecom1;

    vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
    vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
    vlocity_cmt__State__c='Completed',
    vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
    vlocity_cmt__OrderItemId__c = newOrderitem.Id);
    insert item3;

    System.debug('Item Name : ' +item3.Name);

    vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

    vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
    vlocity_cmt__State__c='Completed',
    vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
    vlocity_cmt__OrderItemId__c = newOrderitem.Id);
    insert item4;


    List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
    allItemsGenBilling1.add(item3);
    allItemsGenBilling1.add(item4);
    
    //END OF ORECHESTRATION PLAN
    INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
    InwiItemCreate1.executeBatch(allItemsGenBilling1);
    Test.stopTest();
}

@isTest(SeeAllData=false)
public static void batchOrderTestChgmtNumPorta() {
    Account testAccount = new Account(Name='Test Account');
    insert testAccount;
    Test.startTest();
    vlocity_cmt__Picklist__c VloPickList = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PLK_MODELE', name ='Test vlocity picklist');
    insert VloPickList;
    
    vlocity_cmt__Picklist__c VloPickList1 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_TYPE_LIGNE', name ='Test vlocity picklist 1');
    insert VloPickList1;
    
    vlocity_cmt__Picklist__c VloPickList2 = new vlocity_cmt__Picklist__c(vlocity_cmt__Code__c='INWIB2C_PKL_GAMME_OFFRE', name ='Test vlocity picklist 2');
    insert VloPickList2;
    
    vlocity_cmt__PicklistValue__c  NewPickList = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= 'Samsung Galaxy A01 CORE',name='Jo test', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
    insert NewPickList;
    
    vlocity_cmt__PicklistValue__c  NewPickList1 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList.Id, vlocity_cmt__Code__c ='InwiB2C_1');
    insert NewPickList1;
    
    vlocity_cmt__PicklistValue__c  NewPickList2 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='VIP', vlocity_cmt__PicklistId__c=VloPickList1.Id, vlocity_cmt__Code__c ='InwiB2C_2');
    insert NewPickList2;
    
    vlocity_cmt__PicklistValue__c  NewPickList3 = new vlocity_cmt__PicklistValue__c (vlocity_cmt__TextValue__c= '100001702',name='Galaxy', vlocity_cmt__PicklistId__c=VloPickList2.Id, vlocity_cmt__Code__c ='InwiB2C_3');
    insert NewPickList3;
    //Product
    Product2 prod = new Product2(Name = 'Laptop X200', 
                                 Family = 'Hardware',
                                 ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'Prepaye');
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
    Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
         insert c;
    

    order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id,inwiB2C_TypeActeDeGestion__c='inwiB2C_ChangementDeNumeroPorta');
    insert neworder;
    
    String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNUUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_TypHandset","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type Handset","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}],"values":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"},{"value":"TERM","sequence":20,"id":"b1e73d9a-7aba-cd66-f5b8-bedaa7b3da92","displayText":"TERM"}],"selectedItem":{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OYtrUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_CUSTRISKPLAF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Plafond Risque Personnalisé","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":-999,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001AnFzUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":"-999","valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","default":"-999","value":"-999"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYupUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_ElligibleAuTypeLigne","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Elligible au type de ligne","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYuuUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_NUMERO_ADHERANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro adhérant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxklUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InDUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkmUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InEUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkvUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ENGAGEMENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Engagement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"0","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}],"values":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"},{"value":"12","sequence":20,"id":"43d82073-ac9e-d6e4-fd43-252ccd7619c5","displayText":"12 Mois"},{"value":"24","sequence":30,"id":"1874b54d-5b3d-6205-5fec-c5ac54e2c251","displayText":"24 Mois"}],"selectedItem":{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkyUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_GAMME_OFFRE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Gamme offre","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GALAXY","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}],"values":[{"value":"AMY","sequence":10,"id":"538aeaef-176d-2f05-c1aa-7a46eeb6fe46","displayText":"forfait Famille"},{"value":"BATMAN","sequence":20,"id":"da7bdac4-13d9-edd9-c1b3-89cd3a3c7221","displayText":"Batman"},{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"},{"value":"SW2","sequence":40,"id":"5ea7bea2-ea69-1f03-9458-4bbfd69eef24","displayText":"Star wars"},{"value":"PIZZA","sequence":50,"id":"d9f33766-032b-9ad5-3fd5-7d9444a61ce4","displayText":"Pizza"}],"selectedItem":{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlAUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NOMBRE_RECURENCE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre de récurrences pour remise","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86907,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InFUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86907","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}],"values":[{"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet","value":"86907","sequence":30},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlQUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_DIRHAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en Dh sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlYUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_POURCENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en % sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxllUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InCUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}],"values":[{"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public","value":"GP","sequence":40}],"selectedItem":{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTVUA4","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFAPP","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Application à partir de la nièm facture","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhDUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTaUAO","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFDIF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en différée","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNZUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_EXISTXGO","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Exist XGo","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"NON","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}],"values":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"},{"value":"OUI","sequence":20,"id":"16ef43d9-9e0b-20e6-aa23-e8bfbcf36257","displayText":"OUI"}],"selectedItem":{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}},"$$AttributeDefinitionEnd$$":null}]}';           
    OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Disconnect', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
    insert newOrderitem;
    OrderItem newOrderitem2 = new OrderItem(vlocity_cmt__Action__c = 'Add', Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, orderid=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
    insert newOrderitem2;
     //Create Subscription 
    vlocity_cmt__Subscription__c newSubsc1=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223344',Inwib2c_Num_ro_de_la_ligne__c='0611223344',Name='TEST',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active'
    );
    Insert newSubsc1;
    //Create and Insert Asset
    Asset asset1 = new Asset(
        Name = 'Test Asset',
        Status = 'Installed',
        AccountId = testAccount.Id,
        InstallDate = System.Today(),
        Product2Id = prod.Id,
        UsageEndDate = System.Today(),
        vlocity_cmt__OrderProductId__c = newOrderitem.Id,
        vlocity_cmt__SubscriptionId__c=newSubsc1.Id
        );
        insert asset1;
    
    newOrderitem.vlocity_cmt__AssetId__c=asset1.Id;
    update newOrderitem;
    //ORCHESTRATION PLAN

    vlocity_cmt__ItemImplementation__c itemImpl1 = new vlocity_cmt__ItemImplementation__c(Name = 'Generate Bill Manual Task test',
    vlocity_cmt__Implementation__c = 'GenerateBillManualTasktest');

    vlocity_cmt__OrchestrationPlanDefinition__c planDef1 = new vlocity_cmt__OrchestrationPlanDefinition__c(Name ='Billing Test');
    insert planDef1;

    vlocity_cmt__OrchestrationItemDefinition__c itemDef1 = new vlocity_cmt__OrchestrationItemDefinition__c(
    vlocity_cmt__OrchestrationPlanDefinitionId__c =planDef1.Id, 
    Name = 'Generate Bill Manual Task',vlocity_cmt__itemImplementationId__c = itemImpl1.Id,
    vlocity_cmt__GlobalKey__c = 'ac70f77d-0446-eec4-4f8a-b375ae61e3a');

    insert itemDef1;
     vlocity_cmt__OrchestrationPlan__c planId1 = new vlocity_cmt__OrchestrationPlan__c(vlocity_cmt__State__c = 'In progress',
    vlocity_cmt__OrderId__c = neworder.Id);
    insert planId1;


    vlocity_cmt__FulfilmentRequest__c FRId1 = new vlocity_cmt__FulfilmentRequest__c(vlocity_cmt__Status__c = 'New',
    vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
    vlocity_cmt__OrderId__c=neworder.Id);
    insert FRId1;



    vlocity_cmt__FulfilmentRequestLine__c FRLine1 = new vlocity_cmt__FulfilmentRequestLine__c(vlocity_cmt__Action__c = 'Add',
        vlocity_cmt__FulfilmentRequestID__c = FRId1.Id); 
    insert FRLine1;
     vlocity_cmt__FulfilmentRequestLineDecompRelationship__c FRLineDecom1 = new vlocity_cmt__FulfilmentRequestLineDecompRelationship__c(
    vlocity_cmt__DestinationFulfilmentRequestLineId__c = FRLine1.Id, 
    vlocity_cmt__SourceOrderItemId__c = newOrderitem.Id);
    insert FRLineDecom1;

    vlocity_cmt__OrchestrationItem__c item3 = new vlocity_cmt__OrchestrationItem__c(Name = 'Generate Bill Manual Task',
    vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
    vlocity_cmt__State__c='Completed',
    vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
    vlocity_cmt__OrderItemId__c = newOrderitem.Id);
    insert item3;

    System.debug('Item Name : ' +item3.Name);

    vlocity_cmt__OrchestrationItem__c item4 = new vlocity_cmt__OrchestrationItem__c(Name = 'Manual task2',

    vlocity_cmt__OrchestrationPlanId__c = planId1.Id,
    vlocity_cmt__State__c='Completed',
    vlocity_cmt__FulfilmentRequestLineId__c = FRLine1.Id,
    vlocity_cmt__OrderItemId__c = newOrderitem.Id);
    insert item4;


    List<vlocity_cmt__OrchestrationItem__c> allItemsGenBilling1 = new List<vlocity_cmt__OrchestrationItem__c>();
    allItemsGenBilling1.add(item3);
    allItemsGenBilling1.add(item4);
    
    //END OF ORECHESTRATION PLAN
    INWIB2CCreateSubscription InwiItemCreate1 = new INWIB2CCreateSubscription();
    InwiItemCreate1.executeBatch(allItemsGenBilling1);
    Test.stopTest();
}



        
 }