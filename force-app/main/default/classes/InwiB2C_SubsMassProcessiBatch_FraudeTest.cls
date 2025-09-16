@IsTest
public class InwiB2C_SubsMassProcessiBatch_FraudeTest {

        @TestSetup
        public static void setupData() {
    
        }
        
       
      
    public static testMethod void batchOrderTest() {

        Test.startTest();
        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware',
                                     ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'Postpaid');
        insert prod;

        Product2 prodrfs = new Product2(Name = 'voice', 
                                     Family = 'RFS',
                                     ProductCode='INWIB2C_RFS_VOICE',vlocity_cmt__Type__c= 'Postpaid');
        insert prodrfs;
        
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
        /*Contract c=new Contract(AccountId=testAccount.Id,InwiB2C_statut_contrat__c='Initialise');
        insert c;
        
        order neworderRehab = new Order (Pricebook2Id = customPB.Id, inwiB2C_TypeActeDeGestion__c='inwiB2C_Rehabilitation', inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id,contractId=c.id);
        insert neworderRehab;*/

        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNUUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_TypHandset","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type Handset","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}],"values":[{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"},{"value":"TERM","sequence":20,"id":"b1e73d9a-7aba-cd66-f5b8-bedaa7b3da92","displayText":"TERM"}],"selectedItem":{"value":"SIM","sequence":10,"id":"1a7101d9-b3e5-f5d0-686a-9b0cb29f6d5f","displayText":"SIM"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OYtrUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_CUSTRISKPLAF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Plafond Risque Personnalisé","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":-999,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001AnFzUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":"-999","valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","default":"-999","value":"-999"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYupUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_ElligibleAuTypeLigne","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Elligible au type de ligne","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OYuuUAG","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_NUMERO_ADHERANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numéro adhérant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001B4AxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxklUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InDUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkmUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InEUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkvUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_ENGAGEMENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Engagement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"0","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}],"values":[{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"},{"value":"12","sequence":20,"id":"43d82073-ac9e-d6e4-fd43-252ccd7619c5","displayText":"12 Mois"},{"value":"24","sequence":30,"id":"1874b54d-5b3d-6205-5fec-c5ac54e2c251","displayText":"24 Mois"}],"selectedItem":{"value":"0","sequence":10,"id":"102adc19-1a03-524e-4b70-c98179eea478","displayText":"Sans engagement"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxkyUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_GAMME_OFFRE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Gamme offre","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In8UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GALAXY","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}],"values":[{"value":"AMY","sequence":10,"id":"538aeaef-176d-2f05-c1aa-7a46eeb6fe46","displayText":"forfait Famille"},{"value":"BATMAN","sequence":20,"id":"da7bdac4-13d9-edd9-c1b3-89cd3a3c7221","displayText":"Batman"},{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"},{"value":"SW2","sequence":40,"id":"5ea7bea2-ea69-1f03-9458-4bbfd69eef24","displayText":"Star wars"},{"value":"PIZZA","sequence":50,"id":"d9f33766-032b-9ad5-3fd5-7d9444a61ce4","displayText":"Pizza"}],"selectedItem":{"value":"GALAXY","sequence":30,"id":"8e3bbf72-9f98-7c03-3b3c-0eb48a0ccada","displayText":"Galaxy"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlAUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_NOMBRE_RECURENCE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre de récurrences pour remise","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013In9UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86907,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InFUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86907","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}],"values":[{"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet","value":"86907","sequence":30},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"value":"86907","sequence":30,"id":"a9497403-58b5-e252-54ad-5cc902e7afcb","displayText":"Forfait 49dhs Internet"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlQUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_DIRHAM","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en Dh sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InAUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxlYUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_REMISE_POURCENT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en % sur abonnement","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InBUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000NxllUAC","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_TYPE_LIGNE","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de ligne","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013InCUAU","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"GP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}],"values":[{"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public","value":"GP","sequence":40}],"selectedItem":{"value":"GP","sequence":40,"id":"52bed3eb-3bd1-82aa-59a3-c4239906e71e","displayText":"Grand Public"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTVUA4","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFAPP","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Application à partir de la nièm facture","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhDUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3M0000009wpdQAA","attributeid__c":"a0X3M000000OZTaUAO","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_ABOFORFDIF","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Remise en différée","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001CqhIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Single Value","value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Number","uiDisplayType":"Single Value","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJtQAI","attributeid__c":"a0X3M000000OaNZUA0","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_DC_EXISTXGO","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Exist XGo","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M000001EaTLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"NON","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}],"values":[{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"},{"value":"OUI","sequence":20,"id":"16ef43d9-9e0b-20e6-aa23-e8bfbcf36257","displayText":"OUI"}],"selectedItem":{"value":"NON","sequence":10,"id":"3d5eea6f-36fa-2de1-6f3a-47df1308f4d9","displayText":"NON"}},"$$AttributeDefinitionEnd$$":null}]}';  
        
        String jsonInvItemStr='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K0000006PazUAE","attributeuniquecode__c":"INWIB2C_ATT_DC_VOICE","attributedisplayname__c":"T_Voice","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":""},"Name":"T_Voice","Code":"INWIB2C_ATT_DC_VOICE","Filterable":false,"SegmentValue":"","$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K0000006Pb0UAE","attributeuniquecode__c":"INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_IN","attributedisplayname__c":"T_VoiceServiceLevelIn","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":"Bloqué"},"Name":"T_VoiceServiceLevelIn","Code":"INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_IN","Filterable":false,"SegmentValue":"Bloqué","$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K0000006Pb1UAE","attributeuniquecode__c":"INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_OUT","attributedisplayname__c":"T_VoiceServiceLevelOut","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":"Autorisé"},"Name":"T_VoiceServiceLevelOut","Code":"INWIB2C_ATT_DC_VOICE_SERVICE_LEVEL_OUT","Filterable":false,"SegmentValue":"Autorisé","$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K000000TFSFUA4","attributeuniquecode__c":"INWIB2C_ATT_DC_CodeProductBCS","attributedisplayname__c":"T_CodeProductBCS","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":""},"Name":"T_CodeProductBCS","Code":"INWIB2C_ATT_DC_CodeProductBCS","Filterable":false,"SegmentValue":"","$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K0000006PaXUAU","attributeuniquecode__c":"INWIB2C_ATT_DC_MRC","attributedisplayname__c":"T_MRC","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":""},"Name":"T_MRC","Code":"INWIB2C_ATT_DC_MRC","Filterable":false,"SegmentValue":"","$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K0000006PagUAE","attributeuniquecode__c":"INWIB2C_ATT_DC_NRC","attributedisplayname__c":"T_NRC","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":""},"Name":"T_NRC","Code":"INWIB2C_ATT_DC_NRC","Filterable":false,"SegmentValue":"","$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K0000006PakUAE","attributeuniquecode__c":"INWIB2C_ATT_DC_OSS_AP","attributedisplayname__c":"T_OSSAP","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":"FALSE"},"Name":"T_OSSAP","Code":"INWIB2C_ATT_DC_OSS_AP","Filterable":false,"SegmentValue":"FALSE","$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K0000006PalUAE","attributeuniquecode__c":"INWIB2C_ATT_DC_OSS_AP_CODE","attributedisplayname__c":"T_OSSAPCode","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":""},"Name":"T_OSSAPCode","Code":"INWIB2C_ATT_DC_OSS_AP_CODE","Filterable":false,"SegmentValue":"","$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K0000006PanUAE","attributeuniquecode__c":"INWIB2C_ATT_DC_OSS_SERVICE","attributedisplayname__c":"T_OSSService","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":"TRUE"},"Name":"T_OSSService","Code":"INWIB2C_ATT_DC_OSS_SERVICE","Filterable":false,"SegmentValue":"TRUE","$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K0000006PaoUAE","attributeuniquecode__c":"INWIB2C_ATT_DC_OSS_SERVICE_CODE","attributedisplayname__c":"T_OSSServiceCode","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":"VOICE"},"Name":"T_OSSServiceCode","Code":"INWIB2C_ATT_DC_OSS_SERVICE_CODE","Filterable":false,"SegmentValue":"VOICE","$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"categorycode__c":"INWIB2C_ACAT_MOBILE","attributeid__c":"a0X4K000000TFSKUA4","attributeuniquecode__c":"INWIB2C_ATT_DC_T_ExistBCS","attributedisplayname__c":"T_ExistBCS","id":"","objectid__c":"","objecttype__c":null,"categoryname__c":"Category","valuedatatype__c":"Text","displaysequence__c":null,"attributecategoryid__c":"","attributedisplaysequence__c":null,"hasrule__c":false,"isactive__c":true,"ishidden__c":false,"isreadonly__c":false,"isquerydriven__c":false,"isconfigurable__c":true,"attributefilterable__c":true,"attributeconfigurable__c":true,"isrequired__c":false,"formatmask__c":null,"valueinnumber__c":null,"querycode__c":null,"querylabel__c":null,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"","value":""},"Name":"T_ExistBCS","Code":"INWIB2C_ATT_DC_T_ExistBCS","Filterable":false,"SegmentValue":"","$$AttributeDefinitionEnd$$":null}]}';
        
       /* OrderItem newOrderitemRehab = new OrderItem(Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, PriceBookEntryId=customPrice.Id, OrderId=neworderRehab.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
        insert newOrderitemRehab;*/
        
        vlocity_cmt__Subscription__c newSubscRehab=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='212611223377',Inwib2c_Num_ro_de_la_ligne__c='212611223377',Name='TEST1',inwiB2C_LegacyStatus__c='Suspendue',inwiB2C_Statut__c='InwiB2C_Suspended',vlocity_cmt__Status__c='Suspended', inwiB2C_managedInSF__c = true);
        Insert newSubscRehab;
        vlocity_cmt__Subscription__c newSubscSusc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='212611223376',Inwib2c_Num_ro_de_la_ligne__c='212611223376',Name='TEST2',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active', inwiB2C_managedInSF__c = true);
        Insert newSubscSusc;
        vlocity_cmt__Subscription__c newSubscSusp=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='212611223375',Inwib2c_Num_ro_de_la_ligne__c='212611223375',Name='TEST3',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active', inwiB2C_managedInSF__c = true);
        Insert newSubscSusp;
        vlocity_cmt__Subscription__c newSubscSfprd=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='212611223374', Inwib2c_Num_ro_de_la_ligne__c='212611223374',Name='TEST4', inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active', inwiB2C_managedInSF__c = true);
        Insert newSubscSfprd;
        vlocity_cmt__Subscription__c newSubscResil=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='212611223373',Inwib2c_Num_ro_de_la_ligne__c='212611223373',Name='TEST5',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active', inwiB2C_managedInSF__c = true);
        Insert newSubscResil;
        
        //Create and Insert Asset
        Asset assetRehab = new Asset(
            Name = 'Test Asset',
            Status = 'Installed',
            AccountId = testAccount.Id,
            InstallDate = System.Today(),
            Product2Id = prod.Id,
            vlocity_cmt__JSONAttribute__c= JsonAttr,
            vlocity_cmt__SubscriptionId__c = newSubscRehab.Id
            //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
        );
        insert assetRehab;
        assetRehab.vlocity_cmt__RootItemId__c = assetRehab.id;
        update assetRehab;

        Asset assetSusc = new Asset(
            Name = 'Test Asset',
            Status = 'Installed',
            AccountId = testAccount.Id,
            InstallDate = System.Today(),
            Product2Id = prod.Id,
            vlocity_cmt__JSONAttribute__c= JsonAttr,
            vlocity_cmt__SubscriptionId__c = newSubscSusc.Id
            //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
        );
        insert assetSusc;
        assetSusc.vlocity_cmt__RootItemId__c = assetSusc.id;
        update assetSusc;

        Asset assetSusp = new Asset(
            Name = 'Test Asset',
            Status = 'Installed',
            AccountId = testAccount.Id,
            InstallDate = System.Today(),
            Product2Id = prod.Id,
            vlocity_cmt__JSONAttribute__c= JsonAttr,
            vlocity_cmt__SubscriptionId__c = newSubscSusp.Id
            //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
        );
        insert assetSusp;
        assetSusp.vlocity_cmt__RootItemId__c = assetSusp.id;
        update assetSusp;

        Asset assetSfprd = new Asset(
            Name = 'Test Asset',
            Status = 'Installed',
            AccountId = testAccount.Id,
            InstallDate = System.Today(),
            Product2Id = prod.Id,
            vlocity_cmt__JSONAttribute__c= JsonAttr,
            vlocity_cmt__SubscriptionId__c = newSubscSfprd.Id
            //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
        );
        insert assetSfprd;
        assetSfprd.vlocity_cmt__RootItemId__c = assetSfprd.id;
        update assetSfprd;

        Asset assetResil = new Asset(
            Name = 'Test Asset',
            Status = 'Installed',
            AccountId = testAccount.Id,
            InstallDate = System.Today(),
            Product2Id = prod.Id,
            vlocity_cmt__JSONAttribute__c= JsonAttr,
            vlocity_cmt__SubscriptionId__c = newSubscResil.Id
            //vlocity_cmt__OrderProductId__r.OrderId = newOrderitemMDN.Id,
        );
        insert assetResil;
        assetResil.vlocity_cmt__RootItemId__c = assetResil.id;
        update assetResil;

        vlocity_cmt__InventoryItem__c invItemRehab = new vlocity_cmt__InventoryItem__c (
            Name = 'Test Inv',
            vlocity_cmt__AccountId__c = testAccount.Id,
            vlocity_cmt__ActivationDate__c = System.Today(),
            vlocity_cmt__ProductId__c = prodrfs.id,
            vlocity_cmt__ServiceAccountId__c = testAccount.Id,
            vlocity_cmt__BillingAccountId__c = testAccount.Id
        );

        insert invItemRehab;

        vlocity_cmt__InventoryItemDecompositionRelationship__c invdecompRehab = new vlocity_cmt__InventoryItemDecompositionRelationship__c(
            vlocity_cmt__DestinationInventoryItemId__c = invItemRehab.Id,
            vlocity_cmt__SourceAssetId__c = assetRehab.id
        );
        insert invdecompRehab;

        vlocity_cmt__InventoryItem__c invItemSusc = new vlocity_cmt__InventoryItem__c (
            Name = 'Test Inv',
            vlocity_cmt__AccountId__c = testAccount.Id,
            vlocity_cmt__ActivationDate__c = System.Today(),
            vlocity_cmt__ProductId__c = prodrfs.id,
            vlocity_cmt__JSONAttribute__c= jsonInvItemStr,
            vlocity_cmt__ServiceAccountId__c = testAccount.Id,
            vlocity_cmt__BillingAccountId__c = testAccount.Id
        );

        insert invItemSusc;

        vlocity_cmt__InventoryItemDecompositionRelationship__c invdecompSusc = new vlocity_cmt__InventoryItemDecompositionRelationship__c(
            vlocity_cmt__DestinationInventoryItemId__c = invItemSusc.Id,
            vlocity_cmt__SourceAssetId__c = assetSusc.id
        );
        insert invdecompSusc;

        vlocity_cmt__InventoryItem__c invItemSusp = new vlocity_cmt__InventoryItem__c (
            Name = 'Test Inv',
            vlocity_cmt__AccountId__c = testAccount.Id,
            vlocity_cmt__ActivationDate__c = System.Today(),
            vlocity_cmt__ProductId__c = prodrfs.id,
            vlocity_cmt__JSONAttribute__c= jsonInvItemStr,
            vlocity_cmt__ServiceAccountId__c = testAccount.Id,
            vlocity_cmt__BillingAccountId__c = testAccount.Id
        );

        insert invItemSusp;

        vlocity_cmt__InventoryItemDecompositionRelationship__c invdecompSusp = new vlocity_cmt__InventoryItemDecompositionRelationship__c(
            vlocity_cmt__DestinationInventoryItemId__c = invItemSusp.Id,
            vlocity_cmt__SourceAssetId__c = assetSusp.id
        );
        insert invdecompSusp;

        vlocity_cmt__InventoryItem__c invItemSfprd = new vlocity_cmt__InventoryItem__c (
            Name = 'Test Inv',
            vlocity_cmt__AccountId__c = testAccount.Id,
            vlocity_cmt__ActivationDate__c = System.Today(),
            vlocity_cmt__ProductId__c = prodrfs.id,
            vlocity_cmt__JSONAttribute__c= jsonInvItemStr,
            vlocity_cmt__ServiceAccountId__c = testAccount.Id,
            vlocity_cmt__BillingAccountId__c = testAccount.Id
        );

        insert invItemSfprd;

        vlocity_cmt__InventoryItemDecompositionRelationship__c invdecompSfprd = new vlocity_cmt__InventoryItemDecompositionRelationship__c(
            vlocity_cmt__DestinationInventoryItemId__c = invItemSfprd.Id,
            vlocity_cmt__SourceAssetId__c = assetSfprd.id
        );
        insert invdecompSfprd;

        vlocity_cmt__InventoryItem__c invItemResil = new vlocity_cmt__InventoryItem__c (
            Name = 'Test Inv',
            vlocity_cmt__AccountId__c = testAccount.Id,
            vlocity_cmt__ActivationDate__c = System.Today(),
            vlocity_cmt__ProductId__c = prodrfs.id,
            vlocity_cmt__JSONAttribute__c= jsonInvItemStr,
            vlocity_cmt__ServiceAccountId__c = testAccount.Id,
            vlocity_cmt__BillingAccountId__c = testAccount.Id
        );

        insert invItemResil;

        vlocity_cmt__InventoryItemDecompositionRelationship__c invdecompResil = new vlocity_cmt__InventoryItemDecompositionRelationship__c(
            vlocity_cmt__DestinationInventoryItemId__c = invItemResil.Id,
            vlocity_cmt__SourceAssetId__c = assetResil.id
        );
        insert invdecompResil;





        INWIB2C_SUBSMASSPROCESSING__c newSubsMassProcess1 = new INWIB2C_SUBSMASSPROCESSING__c (INWIB2C_STATUT__c= 'NEW', INWIB2C_MDN__c = '212611223377', INWIB2C_MOTIF__c ='REHAB', INWIB2C_ACTION__c = 'REHAB', INWIB2C_Origin__c = 'FRAUDE');
        Insert newSubsMassProcess1;
        INWIB2C_SUBSMASSPROCESSING__c newSubsMassProcess2 = new INWIB2C_SUBSMASSPROCESSING__c (INWIB2C_STATUT__c= 'NEW', INWIB2C_MDN__c = '212611223376', INWIB2C_MOTIF__c ='SUSC', INWIB2C_ACTION__c = 'SUSC', INWIB2C_Origin__c = 'FRAUDE');
        Insert newSubsMassProcess2;
        INWIB2C_SUBSMASSPROCESSING__c newSubsMassProcess3 = new INWIB2C_SUBSMASSPROCESSING__c (INWIB2C_STATUT__c= 'NEW', INWIB2C_MDN__c = '212611223375', INWIB2C_MOTIF__c ='SUSP', INWIB2C_ACTION__c = 'SUSP', INWIB2C_Origin__c = 'FRAUDE');
        Insert newSubsMassProcess3;	
	
        INWIB2C_SUBSMASSPROCESSING__c newSubsMassProcess4 = new INWIB2C_SUBSMASSPROCESSING__c (INWIB2C_STATUT__c= 'NEW', INWIB2C_MDN__c = '212611223374', INWIB2C_MOTIF__c ='SFRD', INWIB2C_ACTION__c = 'SFRD', INWIB2C_Origin__c = 'FRAUDE');
        Insert newSubsMassProcess4;	

        INWIB2C_SUBSMASSPROCESSING__c newSubsMassProcess5 = new INWIB2C_SUBSMASSPROCESSING__c (INWIB2C_STATUT__c= 'NEW', INWIB2C_MDN__c = '212611223373', INWIB2C_MOTIF__c ='RESIL', INWIB2C_ACTION__c = 'RESIL', INWIB2C_Origin__c = 'FRAUDE');
        Insert newSubsMassProcess5;	
   
        
        Id bacthId = Database.executeBatch( new InwiB2C_SubsMassProcessingBatch_Fraude() , 10 );
        
        /*newSubsMassProcess.INWIB2C_ACTION__c ='SUSC';
        update newSubsMassProcess;
        Id bacthIdSusc = Database.executeBatch( new InwiB2C_SubsMassProcessingBatch() , 10 );
        newSubsMassProcess.INWIB2C_ACTION__c ='SFRD';
        update newSubsMassProcess;
        Id bacthIdSfrd = Database.executeBatch( new InwiB2C_SubsMassProcessingBatch() , 10 );
        Test.stopTest();
        newSubsMassProcess.INWIB2C_ACTION__c ='RESIL';
        update newSubsMassProcess;
        Id bacthIdResil = Database.executeBatch( new InwiB2C_SubsMassProcessingBatch() , 10 );*/
       
    }
}