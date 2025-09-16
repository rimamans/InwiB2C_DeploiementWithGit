public with sharing class InwiB2C_RetailStore {
    @AuraEnabled
    public static Id RetailStoreRecord(String firstName, String lastName, String Name, String ActivityType, String longitude, String latitude, String MdnDealer, String MdnDealer2, String segmentDealer, String statusRS, Boolean isDealer, String contactNumber1, String contactNumber2, String IdRVR, String Region, String Localisation, String Circuit, Boolean isDealerIdentifier, Boolean isDistributeurAppMobile, String imageUrl, String distributeur, String imageFileId){
        
        List<INWIB2C_GroupName__mdt> TemplateMD = [select inwiB2C_BoutiqueId__c from INWIB2C_GroupName__mdt];
        List<INWIB2C_StoreProduct__mdt> TemplateMDProduct = [select inwiB2C_ProductId__c from INWIB2C_StoreProduct__mdt];
        
        Contact contact = new Contact();
        contact.FirstName = firstName;
        contact.LastName = lastName;
        contact.Phone = contactNumber1;
        contact.OtherPhone = contactNumber2;
        insert contact;
        
        Account account = new Account();
        account.Name = Name;
        account.vlocity_cmt__PrimaryContactId__c = contact.Id;
        account.InwiB2C_Segment_Dealer__c = segmentDealer;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partenaire').getRecordTypeId();
        account.RecordTypeId = devRecordTypeId;
        insert account;
        
        contact.AccountId = account.Id;
        update contact;
        Schema.Location newLocation = new Schema.Location(Name = Name);
        insert newLocation;
        
        Schema.RetailStore store = new Schema.RetailStore();
        store.Name = Name;
        store.AccountId = account.Id;
        store.PrimaryContactId = contact.Id;
        store.LocationId = newLocation.Id;
        
        // if (!Test.isRunningTest()) {
            //     store.RetailLocationGroupId = TemplateMD[0].inwiB2C_BoutiqueId__c;
        // }
        store.inwiCGC_TypeActivite__c = ActivityType;
        store.Latitude = Decimal.valueOf(latitude);
        store.Longitude = Decimal.valueOf(longitude);
        store.inwiB2C_MDN__c = MdnDealer;
        store.inwiB2C_MDN2__c = MdnDealer2;
        store.InwiB2C_isDealer__c = isDealer;
        store.InwiB2C_Segment__c = segmentDealer;
        store.inwiCGC_Status__c = statusRS;
        store.inwiCGC_IdRVR__c = IdRVR;
        store.inwiCGC_Region_AC__c = Region;
        store.inwiCGC_Flag__c = Localisation;
        store.inwiCGC_VilleAM__c = Circuit;
        store.inwiCGC_Distributeur_App__c = isDistributeurAppMobile;
        store.inwiCGC_Dealer_Identifier__c = isDealerIdentifier;
        store.inwiB2C_ImageAM__c = imageUrl;
        store.inwiCGC_Distributeur__c = distributeur;
        
    //     // verification Mdn dealer et mdn dealer2 nexiste pas dans un autre retail store
    //     Set<String> mdns = new Set<String>();
    //     if (String.isNotBlank(MdnDealer))  mdns.add(MdnDealer);
    //     if (String.isNotBlank(MdnDealer2)) mdns.add(MdnDealer2);

    //     if (!mdns.isEmpty()) {
    //         List<Schema.RetailStore> existingStores = [
    //             SELECT Id, Name, inwiB2C_MDN__c, inwiB2C_MDN2__c
    //             FROM RetailStore
    //             WHERE inwiCGC_Status__c = 'inwiCGC_Accepte'
    //             AND (
    //                     inwiB2C_MDN__c  IN :mdns
    //                 OR inwiB2C_MDN2__c IN :mdns
    //             )
    //             LIMIT 10
    //         ];

    //         if (!existingStores.isEmpty()) {
    //             Set<String> clashes = new Set<String>();
    //             for (Schema.RetailStore rs : existingStores) {
    //                 if (rs.inwiB2C_MDN__c  != null && mdns.contains(rs.inwiB2C_MDN__c))  clashes.add(rs.inwiB2C_MDN__c);
    //                 if (rs.inwiB2C_MDN2__c != null && mdns.contains(rs.inwiB2C_MDN2__c)) clashes.add(rs.inwiB2C_MDN2__c);
    //             }
    //             String which = String.join(new List<String>(clashes), ', ');
    //             throw new AuraHandledException(
    //                 (which != null && which != '')
    //                 ? 'Le MDN déjà utilisé dans un autre Retail Store: ' + which
    //                 : 'Le MDN Dealer ou MDN Dealer 2 existe déjà dans un autre Retail Store.'
    //             );
    //         }
    //     }


        
    //     // verification MDN dealer et Mdn Dealer 2 sont bien rataché a une souscription valide
        
    //     if (String.isNotBlank(MdnDealer) || String.isNotBlank(MdnDealer2)) {
    //         List<vlocity_cmt__Subscription__c> souscription = [
    //     SELECT Id, Name, Inwib2c_Offre__c, InwiB2C_MDN__c, InwiB2C_MDN_Dealer__c, 
    //            Inwib2c_Num_ro_de_la_ligne__c, InwiB2C_Statut__c, InwiB2C_SegmentMarche__c
    //     FROM vlocity_cmt__Subscription__c
    //     WHERE inwiB2C_Statut__c != 'InwiB2C_Expired'
    //     AND (Inwib2c_Offre__c = 'Offre Dealer Sim Seule' OR Inwib2c_Offre__c = 'Offre Dealer Sim+Terminal')
    //     AND (Inwib2c_Num_ro_de_la_ligne__c = :MdnDealer OR Inwib2c_Num_ro_de_la_ligne__c = :MdnDealer2)
    //     LIMIT 1
    // ];
            
    //         if (souscription.isEmpty()) {
    //             throw new AuraHandledException(
    //                 'Le MDN Dealer ou MDN Dealer 2 ne sont pas rattaché à une souscription'
    //                 );
    //         }
    //     }
        
        
        
    //     // verification MDN dealer 1 et 2 sont differents ou non 
        
    //     if (String.isNotBlank(MdnDealer) && String.isNotBlank(MdnDealer2) && MdnDealer == MdnDealer2) {
    //         throw new AuraHandledException(
    //             'MDN Dealer 1 et 2 doivent etre differents'
    //             );
    //     }

        insert store;

        // Id rvrId;
        // try { rvrId = (Id) Id.valueOf(IdRVR); } catch (Exception ex) { rvrId = null; }
        // notifyRvrOnRsCreate(rvrId, store.Id, store.Name);

        
        
        
        
        InStoreLocation storeLocation = new InStoreLocation();
        storeLocation.Name = 'Main';
        storeLocation.Category = 'Generic';
        storeLocation.RetailStoreId = store.Id;
        storeLocation.LocationId = newLocation.Id;
        insert storeLocation;
        
        StoreProduct productStore = new StoreProduct();
        productStore.ProductId = TemplateMDProduct[0].inwiB2C_ProductId__c;
        productStore.RetailStoreId = store.Id;
        productStore.InStoreLocationId = storeLocation.Id;
        productStore.StartDate = System.Today();
        if (!Test.isRunningTest()) {
            insert productStore;
        }
        
        if (String.isNotBlank(imageFileId)) {
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = imageFileId;
            cdl.LinkedEntityId = store.Id;
            cdl.ShareType = 'I';
            cdl.Visibility = 'AllUsers';
            insert cdl;
        }
        
        return store.Id;
    }

    @AuraEnabled(cacheable=false)
    public static Map<String,Object> checkMdnsDifferent(String mdn1, String mdn2) {
        Map<String,Object> res = new Map<String,Object>{ 'ok' => true, 'message' => '' };
        if (String.isNotBlank(mdn1) && String.isNotBlank(mdn2) && mdn1 == mdn2) {
            res.put('ok', false);
            res.put('message', 'MDN Dealer 1 et 2 doivent être différents');
        }
        return res;
    }

    @AuraEnabled(cacheable=false)
    public static Map<String,Object> checkMdnUniqueness(String mdn1, String mdn2) {
        Map<String,Object> res = new Map<String,Object>{ 'ok' => true, 'message' => '' };

        Set<String> mdns = new Set<String>();
        if (String.isNotBlank(mdn1)) mdns.add(mdn1);
        if (String.isNotBlank(mdn2)) mdns.add(mdn2);
        if (mdns.isEmpty()) return res;

        List<Schema.RetailStore> hits = [
            SELECT Id, Name, inwiB2C_MDN__c, inwiB2C_MDN2__c
            FROM RetailStore
            WHERE inwiCGC_Status__c = 'inwiCGC_Accepte'
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



    
    @AuraEnabled
    public static map<String,Object> GetRetailStoreInformations(Id recordId2 ){
        List<Schema.RetailStore> InfoStore = [SELECT Id, Name, inwiCGC_TypeActivite__c, inwiB2C_MDN__c, inwiB2C_MDN2__c, PrimaryContact.FirstName, PrimaryContact.LastName, PrimaryContact.Phone, PrimaryContact.OtherPhone,inwiCGC_Dealer_Identifier__c,inwiCGC_Distributeur_App__c, InwiB2C_isDealer__c, InwiB2C_Segment__c,inwiCGC_VilleAM__c,inwiCGC_Region_AC__c,inwiCGC_Flag__c, inwiB2C_ImageAM__c, inwiCGC_Distributeur__c from RetailStore where Id=:recordId2 LIMIT 1];
        map<String,Object> InfoActeurMarche= new map<String,Object> ();
        InfoActeurMarche.put('Id',InfoStore[0].Id);
        InfoActeurMarche.put('FirstName',InfoStore[0].PrimaryContact.FirstName);
        InfoActeurMarche.put('LastName',InfoStore[0].PrimaryContact.LastName);
        InfoActeurMarche.put('Name',InfoStore[0].Name);
        InfoActeurMarche.put('MdnDealer',InfoStore[0].inwiB2C_MDN__c);
        InfoActeurMarche.put('TypeActivite',InfoStore[0].inwiCGC_TypeActivite__c);
        InfoActeurMarche.put('MdnDealer2',InfoStore[0].inwiB2C_MDN2__c);
        InfoActeurMarche.put('isDealer',InfoStore[0].inwib2c_IsDealer__c);
        InfoActeurMarche.put('Segment',InfoStore[0].inwib2c_Segment__c);
        InfoActeurMarche.put('contactNumber1',InfoStore[0].PrimaryContact.Phone);
        InfoActeurMarche.put('contactNumber2',InfoStore[0].PrimaryContact.OtherPhone);
        InfoActeurMarche.put('isDealerIdentifier',InfoStore[0].inwiCGC_Dealer_Identifier__c);
        InfoActeurMarche.put('isDistributeurAppMobile',InfoStore[0].inwiCGC_Distributeur_App__c);
        InfoActeurMarche.put('Region',InfoStore[0].inwiCGC_Region_AC__c);
        InfoActeurMarche.put('Localisation',InfoStore[0].inwiCGC_Flag__c);
        InfoActeurMarche.put('Circuit',InfoStore[0].inwiCGC_VilleAM__c);
        InfoActeurMarche.put('imageUrl',InfoStore[0].inwiB2C_ImageAM__c);
        InfoActeurMarche.put('distributeur',InfoStore[0].inwiCGC_Distributeur__c);
        return InfoActeurMarche;
    }
    
    @AuraEnabled
    public static void cloneVisitAndAssignNewRetailStore(String recordId, Id retailStoreId){
        Visit originalVisit = [SELECT AccountId, ActualVisitEndTime, ActualVisitStartTime, AddressId, ContactId, ContextId, inwiCGC_DemandeDeVisite__c, LocationId, Name, OwnerId, PlaceId, PlannedVisitEndTime, PlannedVisitStartTime, RecordTypeId, RetailStoreId, ServiceResourceId, Status, StatusRemarks, UserId, VisitorId, VisitPriority FROM Visit WHERE Id = :recordId LIMIT 1];
        List <AssessmentTask> originalAssessmentTasks = [SELECT AssessmentTaskDefinition.Description, EndTime, IsRequired, Name, OwnerId, ParentId, SequenceNumber, StartTime, Status, TaskDefinitionId, TaskType FROM AssessmentTask WHERE ParentId = :recordId];
        List<ActionPlan> originalActionPlans = [SELECT ActionPlanTemplateVersionId, ActionPlanState, ActionPlanType, ActualEndDate, ActualStartDate, EndDate, IsUsingHolidayHours, Name, Ownerid,RecordCreationType, RecurringScheduleId, ScheduleFrequency, StartDate, StatusCode  FROM ActionPlan WHERE TargetId = :recordId];
        List<Visit> clonedVisits = new List<Visit>();
        List <AssessmentTask> clonedAssessmentTasksFinal = new List <AssessmentTask> ();
        List <ActionPlan> clonedActionPlanFinal = new List <ActionPlan> ();
        Visit clonedVisit = originalVisit.clone(false, true, false, true);
        clonedVisit.PlaceId = retailStoreId;
        clonedVisit.ActualVisitStartTime = null;
        clonedVisit.ActualVisitEndTime = null;
        clonedVisit.Status = 'Planned';
        clonedVisit.inwiCGC_ParentVisitId__c = recordId;
        //Latest Modification : Assign the AccountId of the Retail Store to the cloned visit
        clonedVisit.AccountId = [SELECT AccountId FROM RetailStore WHERE Id = :retailStoreId LIMIT 1].AccountId;
        clonedVisits.add(clonedVisit);
        if (clonedVisits.size() > 0){
            insert clonedVisits;
            System.debug(JSON.serialize(clonedVisits));
            for (Visit visit : clonedVisits) {
                //List <AssessmentTask> clonedAssessmentTasks = originalAssessmentTasks.clone();
                for (AssessmentTask task: originalAssessmentTasks){
                    AssessmentTask clonedTask = task.clone(false, true, false, true);
                    clonedTask.ParentId = visit.id;
                    clonedAssessmentTasksFinal.add(clonedTask);
                }
                for (ActionPlan actionPlan: originalActionPlans){
                    ActionPlan clonedActionPlan = actionPlan.clone(false, true, false, true);
                    clonedActionPlan.TargetId = visit.id;
                    clonedActionPlanFinal.add(clonedActionPlan);
                }
                //clonedAssessmentTasksFinal.addAll(clonedAssessmentTasks);
            }
            System.debug(JSON.serialize(clonedAssessmentTasksFinal));
            if (clonedAssessmentTasksFinal.size() > 0){
                //insert clonedAssessmentTasksFinal;
            }
            if (clonedActionPlanFinal.size() > 0){
                insert clonedActionPlanFinal;
            }
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static String getRVRName() {
        String currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT ManagerId, Profile.Name FROM User WHERE Id = :currentUserId LIMIT 1];
        
        if (currentUser == null || currentUser.ManagerId == null) {
            return null;
        }
        
        User managerUser = [SELECT Id, ManagerId, Profile.Name FROM User WHERE Id = :currentUser.ManagerId LIMIT 1];
        
        if (currentUser.Profile.Name == 'CGC_User') {
            if (managerUser != null) {
                if (managerUser.Profile.Name == 'CGC_RVR') {
                    return managerUser.Id;
                } else {
                    User secondLevelManagerUser = [SELECT Id, Profile.Name FROM User WHERE Id = :managerUser.ManagerId LIMIT 1];
                    if (secondLevelManagerUser != null && secondLevelManagerUser.Profile.Name == 'CGC_RVR') {
                        return secondLevelManagerUser.Id;
                    }
                }
            }
        }
        
        return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<inwiCGC_RegionAM__c> getRegions() {
        List<inwiCGC_RegionAM__c> allRegions = [
            SELECT Id, Name FROM inwiCGC_RegionAM__c
        ];
        
        Map<String, inwiCGC_RegionAM__c> uniqueRegionsMap = new Map<String, inwiCGC_RegionAM__c>();
        
        for (inwiCGC_RegionAM__c region : allRegions) {
            uniqueRegionsMap.put(region.Name, region);
        }
        
        return uniqueRegionsMap.values();
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getLocalisationsByRegion(String regionName) {
        List<inwiCGC_RegionAM__c> regionData = [
            SELECT inwiCGC_Flag__c 
            FROM inwiCGC_RegionAM__c 
            WHERE Name = :regionName
        ];
        Set<String> localisations = new Set<String>();
        for (inwiCGC_RegionAM__c entry : regionData) {
            localisations.add(entry.inwiCGC_Flag__c);
        }
        return new List<String>(localisations);
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getCircuitsByLocalisation(String selectedLocalisation, String selectedRegion) {
        List<inwiCGC_RegionAM__c> circuits = [
            SELECT Id, Name, inwiCGC_CircuitAM__c 
            FROM inwiCGC_RegionAM__c 
            WHERE inwiCGC_Flag__c = :selectedLocalisation
            AND Name = :selectedRegion
        ];
        
        List<Map<String, String>> circuitOptions = new List<Map<String, String>>();
        
        for (inwiCGC_RegionAM__c circuit : circuits) {
            if (circuit.inwiCGC_CircuitAM__c != null) {
                Map<String, String> option = new Map<String, String>();
                option.put('label', circuit.inwiCGC_CircuitAM__c);
                option.put('value', circuit.inwiCGC_CircuitAM__c);
                circuitOptions.add(option);
            }
        }
        
        return circuitOptions;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getCurrentUserProfileName() {
        return [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
    }
        
    // private static void notifyRvrOnRsCreate(Id recipientUserId, Id retailStoreId, String retailStoreName) {
    //     if (recipientUserId == null || retailStoreId == null) return;
    //     String prof = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
    //     if (prof != 'CGC_User') return;

    //     try {
    //         CustomNotificationType t = [
    //             SELECT Id
    //             FROM CustomNotificationType
    //             WHERE DeveloperName = 'CGCloud_Bell_Notif'
    //             LIMIT 1
    //         ];

    //         Messaging.CustomNotification n = new Messaging.CustomNotification();
    //         n.setNotificationTypeId(t.Id);
    //         n.setTitle('تم إنشاء نقطة بيع جديدة');
    //         n.setBody(
    //             'عزيزي التاجر، تم إنشاء المتجر "' + retailStoreName +
    //             '"، وسيتواصل معكم فريقنا لتقريب خدماتنا في الدوائر القريبة. شكراً لتعاونكم.'
    //         );
    //         n.setTargetId(retailStoreId);
    //         n.setRecipientIds(new List<Id>{ recipientUserId });

    //         Messaging.sendNotification(new List<Messaging.CustomNotification>{ n });
    //     } catch (Exception e) {
    //     }
    // }


    
}