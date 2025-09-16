trigger inwiB2C_ActeurMarcheTrigger on inwiB2C_Acteur_Marche__c (after insert, after update) {
    
    Set<Id> storeIds = new Set<Id>();
    Set<Id> userIds  = new Set<Id>();
    for (inwiB2C_Acteur_Marche__c am : Trigger.new) {
        if (am.inwiB2C_Valide__c == true && am.inwiB2C_idStore__c != null) {
            storeIds.add(am.inwiB2C_idStore__c);
        }
        if (am.LastModifiedById != null) {
            userIds.add(am.LastModifiedById);
        }
    }
    
    // Map<Id, Schema.RetailStore> storesById = new Map<Id, Schema.RetailStore>();
    // if (!storeIds.isEmpty()) {
        //     List<Schema.RetailStore> storeList = [
        //         SELECT Id, Name, AccountId, LocationId, PrimaryContactId,
        //                Latitude, Longitude,
        //                inwiCGC_TypeActivite__c,
        //                inwiCGC_Region_AC__c,
        //                inwiCGC_VilleAM__c,
        //                InwiB2C_isDealer__c,
        //                inwib2c_Segment__c,
        //                inwiB2C_MDN__c,
        //                inwiB2C_MDN2__c,
        //                inwiCGC_Dealer_Identifier__c,
        //                inwiCGC_Distributeur_App__c,
        //                inwiCGC_Flag__c,
        //                inwiB2C_ImageAM__c
        
        //         FROM RetailStore
        //         WHERE Id IN :storeIds
        //     ];
        //     for (Schema.RetailStore rs : storeList) storesById.put(rs.Id, rs);
    // }
    
    //nouveau version
    
    Map<Id, Schema.RetailStore> storesById = new Map<Id, Schema.RetailStore>();
    if (!storeIds.isEmpty()) {
        List<Schema.RetailStore> storeList = [
            SELECT Id, Name, AccountId, LocationId, PrimaryContactId,
                   Latitude, Longitude,
                   inwiCGC_TypeActivite__c,
                   inwiCGC_Region_AC__c,
                   inwiCGC_VilleAM__c,
                   inwib2c_Segment__c,
                   inwiCGC_Distributeur__c,
                   inwiCGC_Flag__c,
                   inwiB2C_ImageAM__c
            FROM RetailStore
            WHERE Id IN :storeIds
        ];
        for (Schema.RetailStore rs : storeList) storesById.put(rs.Id, rs);
    }
    
    Map<Id, User> usersById = new Map<Id, User>();
    if (!userIds.isEmpty()) {
        List<User> userList = [
            SELECT Id, Profile.Name
            FROM User
            WHERE Id IN :userIds
        ];
        for (User u : userList) usersById.put(u.Id, u);
    }
    
    Map<Id, Schema.RetailStore> storesToUpdateMap    = new Map<Id, Schema.RetailStore>();
    Map<Id, Contact>            contactsToUpdateMap  = new Map<Id, Contact>();
    Map<Id, Schema.Location>    locationsToUpdateMap = new Map<Id, Schema.Location>();
    Map<Id, Account>            accountsToUpdateMap  = new Map<Id, Account>();
    
    for (inwiB2C_Acteur_Marche__c am : Trigger.new) {
        if (!(am.inwiB2C_Valide__c == true && am.inwiB2C_idStore__c != null)) continue;
        
        Schema.RetailStore rs = storesById.get(am.inwiB2C_idStore__c);
        if (rs == null) continue;
        
        // if (am.Name != null)                         rs.Name                         = am.Name;
        // if (am.inwiCGC_TypeActivite__c != null)      rs.inwiCGC_TypeActivite__c      = am.inwiCGC_TypeActivite__c;
        // if (am.inwiCGC_Region_AC__c != null)         rs.inwiCGC_Region_AC__c         = am.inwiCGC_Region_AC__c;
        // if (am.inwiCGC_VilleAM__c != null)           rs.inwiCGC_VilleAM__c           = am.inwiCGC_VilleAM__c;
        // if (am.inwib2c_IsDealer__c != null)          rs.InwiB2C_isDealer__c          = am.inwib2c_IsDealer__c;
        // if (am.inwib2c_Segment__c != null)           rs.inwib2c_Segment__c           = am.inwib2c_Segment__c;
        // if (am.inwiB2C_MDN_Dealer__c != null)        rs.inwiB2C_MDN__c               = am.inwiB2C_MDN_Dealer__c;
        // if (am.inwiB2C_MDN2__c != null)              rs.inwiB2C_MDN2__c              = am.inwiB2C_MDN2__c;
        // if (am.inwiCGC_Dealer_Identifier__c != null) rs.inwiCGC_Dealer_Identifier__c = am.inwiCGC_Dealer_Identifier__c;
        // if (am.inwiCGC_Distributeur_App__c != null)  rs.inwiCGC_Distributeur_App__c  = am.inwiCGC_Distributeur_App__c;
        // if (am.inwiCGC_Flag__c != null)              rs.inwiCGC_Flag__c              = am.inwiCGC_Flag__c;
        // if (am.inwiB2C_ImageAM__c != null)           rs.inwiB2C_ImageAM__c           = am.inwiB2C_ImageAM__c;
        // if (am.inwiB2C_localisationGeo__Latitude__s  != null) rs.Latitude  = (Double) am.inwiB2C_localisationGeo__Latitude__s;
        // if (am.inwiB2C_localisationGeo__Longitude__s != null) rs.Longitude = (Double) am.inwiB2C_localisationGeo__Longitude__s;
        
        //les nouveaux champs autorisé
        
        if (am.Name != null)                    rs.Name                    = am.Name;
        if (am.inwiCGC_TypeActivite__c != null) rs.inwiCGC_TypeActivite__c = am.inwiCGC_TypeActivite__c;
        if (am.inwiCGC_Region_AC__c != null)    rs.inwiCGC_Region_AC__c    = am.inwiCGC_Region_AC__c;
        if (am.inwiCGC_VilleAM__c != null)      rs.inwiCGC_VilleAM__c      = am.inwiCGC_VilleAM__c;
        if (am.inwib2c_Segment__c != null)      rs.inwib2c_Segment__c      = am.inwib2c_Segment__c;
        if (am.inwiCGC_Flag__c != null)         rs.inwiCGC_Flag__c         = am.inwiCGC_Flag__c;
        if (am.inwiCGC_Distributeur__c != null) rs.inwiCGC_Distributeur__c = am.inwiCGC_Distributeur__c;
        if (am.inwiB2C_ImageAM__c != null)      rs.inwiB2C_ImageAM__c      = am.inwiB2C_ImageAM__c;
        if (am.inwiB2C_localisationGeo__Latitude__s  != null) rs.Latitude  = (Double) am.inwiB2C_localisationGeo__Latitude__s;
        if (am.inwiB2C_localisationGeo__Longitude__s != null) rs.Longitude = (Double) am.inwiB2C_localisationGeo__Longitude__s;
        
        storesToUpdateMap.put(rs.Id, rs);
        
        if (rs.PrimaryContactId != null) {
            Contact c = contactsToUpdateMap.get(rs.PrimaryContactId);
            if (c == null) c = new Contact(Id = rs.PrimaryContactId);
            if (am.inwiB2C_FirstName__c      != null) c.FirstName  = am.inwiB2C_FirstName__c;
            if (am.inwiB2C_LastName__c       != null) c.LastName   = am.inwiB2C_LastName__c;
            if (am.inwiB2C_ContactPhone__c   != null) c.Phone      = am.inwiB2C_ContactPhone__c;
            if (am.inwiB2C_ContactPhone2__c  != null) c.OtherPhone = am.inwiB2C_ContactPhone2__c;
            contactsToUpdateMap.put(c.Id, c);
        }
        
        if (rs.LocationId != null) {
            Schema.Location loc = locationsToUpdateMap.get(rs.LocationId);
            if (loc == null) loc = new Schema.Location(Id = rs.LocationId);
            if (am.Name != null) loc.Name = am.Name;
            if (am.inwiB2C_localisationGeo__Latitude__s  != null) loc.Latitude  = am.inwiB2C_localisationGeo__Latitude__s;
            if (am.inwiB2C_localisationGeo__Longitude__s != null) loc.Longitude = am.inwiB2C_localisationGeo__Longitude__s;
            locationsToUpdateMap.put(loc.Id, loc);
        }
        
        // if (rs.AccountId != null) {
            //     Account acc = accountsToUpdateMap.get(rs.AccountId);
            //     if (acc == null) acc = new Account(Id = rs.AccountId);
            //     if (am.inwiB2C_AccountName__c != null) acc.Name                 = am.inwiB2C_AccountName__c;
            //     if (am.inwiB2C_MDN_Dealer__c  != null) acc.inwiB2C_NumDealer__c = am.inwiB2C_MDN_Dealer__c;
            //     accountsToUpdateMap.put(acc.Id, acc);
        // }
        
        //nouveau code
        if (rs.AccountId != null) {
            Account acc = accountsToUpdateMap.get(rs.AccountId);
            if (acc == null) acc = new Account(Id = rs.AccountId);
            if (am.inwiB2C_AccountName__c != null) acc.Name = am.inwiB2C_AccountName__c;
            accountsToUpdateMap.put(acc.Id, acc);
        }
    }
    
    if (!storesToUpdateMap.isEmpty())    update storesToUpdateMap.values();
    if (!contactsToUpdateMap.isEmpty())  update contactsToUpdateMap.values();
    if (!accountsToUpdateMap.isEmpty())  update accountsToUpdateMap.values();
    if (!locationsToUpdateMap.isEmpty() && !Test.isRunningTest()) update locationsToUpdateMap.values();
    
    Set<Id> amIdsNeedingApproval = new Set<Id>();
    Map<Id, Id> submitterByAm = new Map<Id, Id>();
    for (inwiB2C_Acteur_Marche__c am : Trigger.new) {
        if (am.inwiB2C_Valide__c == true) continue;
        User u = usersById.get(am.LastModifiedById);
        String p = (u != null && u.Profile != null) ? u.Profile.Name : null;
        if (p == 'CGC_RVR' || p == 'CGC_FDV_Manager') continue;
        amIdsNeedingApproval.add(am.Id);
        submitterByAm.put(am.Id, am.LastModifiedById);
    }
    
    if (!amIdsNeedingApproval.isEmpty()) {
        Set<Id> pendingTargets = new Set<Id>();
        for (ProcessInstance pi : [
            SELECT Id, TargetObjectId
            FROM ProcessInstance
            WHERE TargetObjectId IN :amIdsNeedingApproval
              AND Status = 'Pending'
        ]) {
            pendingTargets.add(pi.TargetObjectId);
        }
        
        List<Approval.ProcessSubmitRequest> reqs = new List<Approval.ProcessSubmitRequest>();
        for (Id amId : amIdsNeedingApproval) {
            if (pendingTargets.contains(amId)) continue;
            Approval.ProcessSubmitRequest r = new Approval.ProcessSubmitRequest();
            r.setComments('Submitting request for approval.');
            r.setObjectId(amId);
            r.setSubmitterId(submitterByAm.get(amId));
            r.setProcessDefinitionNameOrId('inwiCGC_acteurMarcheValidation');
            r.setSkipEntryCriteria(true);
            reqs.add(r);
        }
        
        for (Approval.ProcessSubmitRequest r : reqs) {
            Approval.process(r);
        }
    }
}