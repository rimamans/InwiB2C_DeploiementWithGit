@IsTest
public with sharing class inwiB2C_CAM_CreateMigratedSubTest {
    @IsTest
    public static void batchTest() {
         	//create an account
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;     
        

        
        List<vlocity_cmt__Subscription__c> subscriptions = new List<vlocity_cmt__Subscription__c>();

        vlocity_cmt__Subscription__c subscription = new vlocity_cmt__Subscription__c();
        subscription.Name = '123';
        subscription.Inwib2c_Num_ro_de_la_ligne__c = '123';
        subscription.Inwib2c_Offre__c ='Forfait 30j 49dhs 1h+11GO+WA';           
        subscription.vlocity_cmt__SubscriptionNumber__c ='123';
        subscription.inwiB2C_Statut__c ='InwiB2C_Active';
        subscription.inwiB2C_LegacyStatus__c='ACTIVE';
        
        subscriptions.add(subscription);
        insert subscriptions;
        
        String jsonString ='{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JkdsQAC","attributeid__c":"a0X3L0000019UgoUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_ENRTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Entrant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JP3TUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"values":[{"value":"Bloqué","sequence":10,"id":"43e2e36a-e5a4-2d69-b957-f5b1d06675ea","displayText":"Bloqué"},{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}],"selectedItem":{"value":"Autorisé","sequence":20,"id":"9c750118-8e12-899a-dda1-913db1492230","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JkdsQAC","attributeid__c":"a0X3L0000019UgpUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_APPELS_SORTANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"15","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Appels Sortant","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JP3UUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Autorisé","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}],"values":[{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"},{"value":"Bloqué","sequence":20,"id":"d3de20ec-60cd-5534-35e7-2acbfa148988","displayText":"Bloqué"},{"value":"International Bloqué","sequence":30,"id":"835f14db-82c1-34fe-9f08-172e00f7cb9b","displayText":"International Bloqué"}],"selectedItem":{"value":"Autorisé","sequence":10,"id":"da3453d9-e137-b5df-235d-160aa0822ad9","displayText":"Autorisé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a2f3L000000JkdsQAC","attributeid__c":"a0X3L0000019UgrUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_CALL_TRANSFER_LEVEL","attributeconfigurable__c":true,"attributedisplaysequence__c":"199","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"CallTransferLevel","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JP3VUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"CFD","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"CFD","sequence":20,"id":"eb242534-5fb3-c941-18a8-fde5432debd4","displayText":"Call Forwarding Default"}],"values":[{"value":"CFB","sequence":10,"id":"480dc9bc-c2a1-e35b-e3f4-f3cf24524316","displayText":"Call Forwarding Busy"},{"value":"CFD","sequence":20,"id":"eb242534-5fb3-c941-18a8-fde5432debd4","displayText":"Call Forwarding Default"},{"value":"CFNRC","sequence":30,"id":"a945830a-25fe-9749-a801-f17ff0857ea1","displayText":"Call Forwarding Not Reachable"},{"value":"CFNRY","sequence":40,"id":"6acfef9f-eedb-d514-b294-adb940cf681c","displayText":"Call Forwarding No Reply"},{"value":"CFU","sequence":50,"id":"9da61170-22a6-d671-83a0-140df63c2655","displayText":"Call Forwarding Unconditional"}],"selectedItem":{"value":"CFD","sequence":20,"id":"eb242534-5fb3-c941-18a8-fde5432debd4","displayText":"Call Forwarding Default"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LId9QAG","attributeid__c":"a0X3L0000019UiPUAU","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"null","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":86933,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JPuTUAW","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86933","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"86933","sequence":70,"id":"15ff561f-f5e0-c0c4-df45-6f1ad78035ac","displayText":"99 Dh appel avec inwi VF"}],"values":[{"value":"86930","sequence":10,"id":"2ff3254a-b3cc-c938-ba35-317e160708b0","displayText":"Forfait 30j 49dh Appels"},{"value":"86931","sequence":20,"id":"19d29f30-3f98-6dfb-ed94-7e4912cf4f8b","displayText":"Forfait 30j 49dh RS"},{"value":"86932","sequence":30,"id":"c195707c-9764-7552-37e7-11cb3ecfd337","displayText":"Forfait 30j 49dh internet"},{"value":"86935","sequence":40,"id":"6936bcde-c60b-3d7c-f55f-c4c8f6a0659b","displayText":"Forfait 30j 99dh 18Go  5h   illimité WA"},{"value":"86937","sequence":50,"id":"0bf405a6-9e99-438b-c91b-fc33daf952af","displayText":"Forfait 30j 99dh 15G0  2h  illimité RS et appels inwi"},{"value":"86936","sequence":60,"id":"1639210c-e693-c7b5-216f-d056221bbb8c","displayText":"Forfait 30j 99dh max internet"},{"value":"86933","sequence":70,"id":"15ff561f-f5e0-c0c4-df45-6f1ad78035ac","displayText":"99 Dh appel avec inwi VF"},{"value":"86934","sequence":80,"id":"dd6de925-26fb-bd84-d495-016a2be38013","displayText":"99 Dh appel avec WA VF"}],"selectedItem":{"value":"86933","sequence":70,"id":"15ff561f-f5e0-c0c4-df45-6f1ad78035ac","displayText":"99 Dh appel avec inwi VF"}},"$$AttributeDefinitionEnd$$":null}]}'; 
  
        List<Asset> Assets =  new List<Asset>();
        Asset asset = new asset();
        asset.Name = 'Test Asset';
        asset.AccountId = testAccount.Id;
        asset.vlocity_cmt__JSONAttribute__c = jsonString;
        asset.vlocity_cmt__SubscriptionId__c =subscription.Id; 
        Assets.add(asset);
        insert Assets;
        
           
       List<vlocity_cmt__Picklist__c> Picklists =  new List<vlocity_cmt__Picklist__c>();
        
        vlocity_cmt__Picklist__c Picklist = new vlocity_cmt__Picklist__c();
        Picklist.Name = 'test123';        
        Picklists.add(Picklist);
        insert Picklists;
        
        
       List<vlocity_cmt__PicklistValue__c> PicklistValues =  new List<vlocity_cmt__PicklistValue__c>();
        
        vlocity_cmt__PicklistValue__c PicklistValue = new vlocity_cmt__PicklistValue__c();
        PicklistValue.vlocity_cmt__PicklistId__c = Picklist.Id;
        PicklistValue.vlocity_cmt__TextValue__c = '86930';
        PicklistValue.vlocity_cmt__Code__c ='INWIB2C_PLI_86930';
        
        PicklistValues.add(PicklistValue);
        insert PicklistValues;  
       
        List<InwiB2C_Demande_de_migration__c> demandes = new List<InwiB2C_Demande_de_migration__c>();

        // Créez les demandes de migration et ajoutez-les à la liste 'demandes'
        InwiB2C_Demande_de_migration__c demandeMigration = new InwiB2C_Demande_de_migration__c();
        demandeMigration.InwiB2C_Souscription__c = subscription.Id; 
        demandeMigration.InwiB2C_Code_nouvel_offre__c = 'INWIB2C_OFFERING_CAM_FORFAIT30J99DHILLIMITEAPPEL';
        demandeMigration.InwiB2C_Nouvel_offre__c = 'Forfait 30j 99dhs 11h+11GO+inwi';
        demandeMigration.InwiB2C_Statut__c = 'InwiB2C_NotifieSDP';
        demandeMigration.InwiB2C_Canal__c ='Point de vente';
        demandeMigration.InwiB2C_Nouveau_Profil__c ='86930';
        demandeMigration.InwiB2C_Prix_Offre__c= 49;
        demandeMigration.InwiB2C_Profil__c='86932';
        demandeMigration.InwiB2C_Offre__c  ='Forfait 30j 49dhs 1h+11GO+WA'; 
        demandeMigration.InwiB2C_FraisFacture__c =198;
        demandes.add(demandeMigration);

        // Insérez les enregistrements de demande de migration
        insert demandes;

        Test.startTest();

        // Exécutez le batch de création des souscriptions migrées
        inwiB2C_CAM_CreateMigratedSubscriptions batch = new inwiB2C_CAM_CreateMigratedSubscriptions();
        Database.executeBatch(batch);

        Test.stopTest();
    }
}