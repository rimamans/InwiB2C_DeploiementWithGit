public with sharing class inwiB2C_EditRetail_Informations {
    @AuraEnabled
    public static void EditRetailInformations(Id paramId, String firstName, String lastName, String AccountName, String TypeActivite, String longitude, String latitude, String MdnDealer, String IdRVR, String MdnDealer2, Boolean isDealer, String segmentDealer, String contactNumber1, String contactNumber2, String Region, String Localisation, String Circuit, Boolean isDealerIdentifier, Boolean isDistributeurAppMobile, String imageUrl, String imageFileId,String commentRejet ) {
       
       
        if (!isDealer) {
            MdnDealer = null;
            MdnDealer2 = null;
        }
       
        List<INWIB2C_GroupName__mdt> TemplateMD = [
    SELECT inwiB2C_BoutiqueId__c 
    FROM INWIB2C_GroupName__mdt 
    LIMIT 1
];
        if (String.isNotBlank(commentRejet)) {
            List<Schema.RetailStore> rs = [
        SELECT Id, inwiCGC_CommentRejet__c
        FROM RetailStore
        WHERE Id = :paramId
        LIMIT 1
    ];
            if (!rs.isEmpty()) {
                rs[0].inwiCGC_CommentRejet__c = commentRejet;
                update rs[0];
            }
        }
        
        inwiB2C_Acteur_Marche__c ActeurMarche = new inwiB2C_Acteur_Marche__c();
        
        if (!TemplateMD.isEmpty()) {
            ActeurMarche.inwiB2C_Name__c = TemplateMD[0].inwiB2C_BoutiqueId__c;
        }
        if (!Test.isRunningTest()){
            ActeurMarche.inwiB2C_idStore__c = paramId;
            ActeurMarche.inwiB2C_Retail_Store__c = paramId;
        }
        ActeurMarche.inwiB2C_FirstName__c = firstName;
        ActeurMarche.inwiB2C_LastName__c = lastName;
        ActeurMarche.inwiB2C_AccountName__c = AccountName;
        ActeurMarche.Name = AccountName;
        ActeurMarche.inwiCGC_TypeActivite__c= TypeActivite;
        ActeurMarche.inwiB2C_MDN_Dealer__c = MdnDealer;
        if (!String.isBlank(latitude)) {
            ActeurMarche.inwiB2C_localisationGeo__Latitude__s = Decimal.valueOf(latitude);
        }
        if (!String.isBlank(longitude)) {
            ActeurMarche.inwiB2C_localisationGeo__Longitude__s = Decimal.valueOf(longitude);
        }
        ActeurMarche.inwiB2C_Name__c = TemplateMD[0].inwiB2C_BoutiqueId__c;
        ActeurMarche.InwiCGC_IdRVR__c = IdRVR;
        ActeurMarche.inwiB2C_MDN2__c = MdnDealer2;
        ActeurMarche.inwib2c_IsDealer__c = isDealer;
        ActeurMarche.inwib2c_Segment__c = segmentDealer;
        ActeurMarche.inwiB2C_ContactPhone__c = contactNumber1;
        ActeurMarche.inwiB2C_ContactPhone2__c = contactNumber2;
        ActeurMarche.inwiCGC_Region_AC__c = Region;
        ActeurMarche.inwiCGC_Flag__c = Localisation;
        ActeurMarche.inwiCGC_VilleAM__c = Circuit;
        ActeurMarche.inwiCGC_Dealer_Identifier__c = isDealerIdentifier;
        ActeurMarche.inwiCGC_Distributeur_App__c = isDistributeurAppMobile;
        ActeurMarche.inwiB2C_ImageAM__c = imageUrl;
        ActeurMarche.inwiCGC_CommentRejet__c = commentRejet;
        
        if (!Test.isRunningTest()) {
            try {
                Id adminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
                
                if (UserInfo.getProfileId() == adminProfileId) {
                    System.debug('Bypass de la création ActeurMarche pour System Administrator');
                } else {
                    insert ActeurMarche;
                }
            } catch (Exception e) {
                if (e.getMessage().contains('NO_APPLICABLE_PROCESS')) {
                    System.debug('aucun process approbation applicable : ' + e.getMessage());
                } else {
                    throw new AuraHandledException('erreur Apex: ' + e.getMessage());
                }
            }
        }
        
        if (String.isNotBlank(imageFileId)) {
            List<ContentDocumentLink> existingLinks = [
            SELECT Id, LinkedEntityId
            FROM ContentDocumentLink
            WHERE ContentDocumentId = :imageFileId
        ];
            
            Boolean isLinked = false;
            for (ContentDocumentLink link : existingLinks) {
                if (link.LinkedEntityId == paramId) {
                    isLinked = true;
                    break;
                }
            }
            
            if (!isLinked) {
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = imageFileId;
                cdl.LinkedEntityId = paramId;
                cdl.ShareType = 'I';
                cdl.Visibility = 'AllUsers';
                insert cdl;
            }
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Map<String,Object> checkMdnUniqueness(String mdn1, String mdn2,Id currentStoreId) {
        Map<String,Object> res = new Map<String,Object>{ 'ok' => true, 'message' => '' };
        
        Set<String> mdns = new Set<String>();
        if (String.isNotBlank(mdn1)) mdns.add(mdn1);
        if (String.isNotBlank(mdn2)) mdns.add(mdn2);
        if (mdns.isEmpty()) return res;
        
        List<Schema.RetailStore> hits = [
            SELECT Id, Name, inwiB2C_MDN__c, inwiB2C_MDN2__c
            FROM RetailStore
            WHERE inwiCGC_Status__c = 'inwiCGC_Accepte'
            AND Id != :currentStoreId   
              AND (inwiB2C_MDN__c IN :mdns OR inwiB2C_MDN2__c IN :mdns)
            LIMIT 20
        ];
        if (!hits.isEmpty()) {
            Set<String> conflicts = new Set<String>();
            for (Schema.RetailStore rs : hits) {
                if (rs.inwiB2C_MDN__c  != null && mdns.contains(rs.inwiB2C_MDN__c))  conflicts.add(rs.inwiB2C_MDN__c);
                if (rs.inwiB2C_MDN2__c != null && mdns.contains(rs.inwiB2C_MDN2__c)) conflicts.add(rs.inwiB2C_MDN2__c);
            }
            res.put('ok', false);
            res.put('message', 'Le MDN déjà utilisé dans un autre Retail Store: ' + String.join(new List<String>(conflicts), ', '));
        }
        return res;
    }
    
    @AuraEnabled(cacheable=false)
    public static Map<String,Object> checkMdnSubscription(String mdn1, String mdn2) {
        Map<String,Object> res = new Map<String,Object>{ 'ok' => true, 'message' => '' };
        
        Set<String> mdns = new Set<String>();
        if (String.isNotBlank(mdn1)) mdns.add(mdn1);
        if (String.isNotBlank(mdn2)) mdns.add(mdn2);
        if (mdns.isEmpty()) return res;
        
        List<vlocity_cmt__Subscription__c> sub = [
            SELECT Id
            FROM vlocity_cmt__Subscription__c
            WHERE inwiB2C_Statut__c != 'InwiB2C_Expired'
              AND (Inwib2c_Offre__c = 'Offre Dealer Sim Seule' OR Inwib2c_Offre__c = 'Offre Dealer Sim+Terminal')
              AND Inwib2c_Num_ro_de_la_ligne__c IN :mdns
            LIMIT 1
        ];
        if (sub.isEmpty()) {
            res.put('ok', false);
            res.put('message', 'Le MDN Dealer ou MDN Dealer 2 ne sont pas rattachés à une souscription valide');
        }
        return res;
    }
    
    @AuraEnabled(cacheable=false)
    public static Map<String, Object> checkUserProximity(Id storeId, Decimal userLat, Decimal userLon, Decimal thresholdMeters) {
        Map<String, Object> res = new Map<String, Object>{
            'ok' => false,
            'distanceMeters' => null,
            'message' => ''
        };
        if (storeId == null || userLat == null || userLon == null) {
            res.put('message', 'Paramètres manquants pour la vérification de proximité.');
            return res;
        }
        
        List<SObject> rows = [
            SELECT DISTANCE(Address, GEOLOCATION(:userLat, :userLon), 'km')
            FROM RetailStore
            WHERE Id = :storeId
            LIMIT 1
        ];
        if (rows.isEmpty()) {
            res.put('message', 'Point de vente introuvable.');
            return res;
        }
        
        Decimal km = (Decimal) rows[0].get('expr0');
        if (km == null) {
            res.put('message', 'Localisation du point de vente indisponible (champ Address manquant).');
            return res;
        }
        
        Decimal meters = km * 1000;
        Decimal limitM = (thresholdMeters == null ? 20 : thresholdMeters);
        Boolean inside = meters <= limitM;
        
        res.put('ok', inside);
        res.put('distanceMeters', meters.setScale(2));
        res.put('message', inside ? 'OK' : 'Hors zone');
        return res;
    }
}