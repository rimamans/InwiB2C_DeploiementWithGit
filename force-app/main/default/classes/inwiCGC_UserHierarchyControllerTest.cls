@isTest
public class inwiCGC_UserHierarchyControllerTest {
    @testSetup
    static void setupTestData() {
        Profile cgcUserProfile = [SELECT Id FROM Profile WHERE Name='CGC_User' LIMIT 1];
        Profile rvrProfile = [SELECT Id FROM Profile WHERE Name='CGC_RVR' LIMIT 1];
        Profile fdvProfile = [SELECT Id FROM Profile WHERE Name='CGC_FDV_Manager' LIMIT 1];
        Profile stdProfile = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];

        User fdvUser = new User(
            Alias = 'fdvuser',
            Email='fdvuser@test.com',
            EmailEncodingKey='UTF-8',
            LastName='FDV',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = fdvProfile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='fdvuser@test.com'
        );
        insert fdvUser;

        User rvrUser = new User(
            Alias = 'rvruser',
            Email='rvruser@test.com',
            EmailEncodingKey='UTF-8',
            LastName='RVR',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = rvrProfile.Id,
            ManagerId = fdvUser.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='rvruser@test.com'
        );
        insert rvrUser;

        User cgcUser = new User(
            Alias = 'cgcuser',
            Email='cgcuser@test.com',
            EmailEncodingKey='UTF-8',
            LastName='CGC',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = cgcUserProfile.Id,
            ManagerId = rvrUser.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='cgcuser@test.com'
        );
        insert cgcUser;
        
        User cgcUserSub = new User(
            Alias = 'cgcusub',
            Email='cgcusub@test.com',
            EmailEncodingKey='UTF-8',
            LastName='CGCSub',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = cgcUserProfile.Id,
            ManagerId = cgcUser.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='cgcusub@test.com'
        );
        insert cgcUserSub;

        inwiCGC_DemandeDeVisite__c demandeParent = new inwiCGC_DemandeDeVisite__c(
            Name='Parent Demande',
            OwnerId = fdvUser.Id,
            inwiCGC_Objectif_SIM__c = 100,
            inwiCGC_Objectif_SC__c = 200,
            inwiCGC_Objectif_SIM_Dealer__c = 300,
            Planned_End_Time__c = Datetime.now().addDays(10),
            Planned_Start_Time__c = Datetime.now()
        );
        insert demandeParent;

        inwiCGC_DemandeDeVisite__c demandeChild = new inwiCGC_DemandeDeVisite__c(
            Name='Child Demande',
            OwnerId = rvrUser.Id,
            Parent__c = demandeParent.Id,
            inwiCGC_Objectif_SIM__c = 50,
            inwiCGC_Objectif_SC__c = 150,
            inwiCGC_Objectif_SIM_Dealer__c = 250,
            Planned_End_Time__c = Datetime.now().addDays(5),
            Planned_Start_Time__c = Datetime.now()
        );
        insert demandeChild;

        inwiCGC_DemandeDeVisite__c demandeCgc = new inwiCGC_DemandeDeVisite__c(
            Name='CGC Demande',
            OwnerId = cgcUser.Id,
            Parent__c = demandeChild.Id,
            inwiCGC_Objectif_SIM__c = 20,
            inwiCGC_Objectif_SC__c = 60,
            inwiCGC_Objectif_SIM_Dealer__c = 80,
            Planned_End_Time__c = Datetime.now().addDays(2),
            Planned_Start_Time__c = Datetime.now()
        );
        insert demandeCgc;
        
        inwiCGC_DemandeDeVisite__c demandeCgcSub = new inwiCGC_DemandeDeVisite__c(
            Name='CGC Sub Demande',
            OwnerId = cgcUserSub.Id,
            Parent__c = demandeCgc.Id,
            inwiCGC_Objectif_SIM__c = 10,
            inwiCGC_Objectif_SC__c = 30,
            inwiCGC_Objectif_SIM_Dealer__c = 40,
            Planned_End_Time__c = Datetime.now().addDays(1),
            Planned_Start_Time__c = Datetime.now()
        );
        insert demandeCgcSub;

        Schema.Location locationTest = new Schema.Location();
        locationTest.Name='locationTest';
        insert locationTest;

        Account parentAccount = new Account(Name='Test Account');
        insert parentAccount;

        Schema.Address addressTest = new Schema.Address();
        addressTest.ParentId = locationTest.Id;
        insert addressTest;

        Visit visit1 = new Visit(
            PlannedVisitStartTime=DateTime.now(),
            PlaceId=addressTest.Id,
            VisitorId=cgcUserSub.Id,
            inwiCGC_DemandeDeVisite__c = demandeCgcSub.Id,
            Status='Completed'
        );
        insert visit1;

        List<RetailVisitKpi> existingKpis = [
            SELECT Id, AssessmentIndDefinitionId, AssessmentIndDefinition.Name
            FROM RetailVisitKpi
            WHERE AssessmentIndDefinition.Name IN (
                'Nombre de carte SIM vendu', 
                'Nombre de carte SIM Dealer vendu', 
                'Nombre de SC vendu'
            )
            LIMIT 3
        ];

        Id simVenduDefId = null;
        Id simDealerVenduDefId = null;
        Id scVenduDefId = null;

        for (RetailVisitKpi k : existingKpis) {
            if (k.AssessmentIndDefinition.Name == 'Nombre de carte SIM vendu') simVenduDefId = k.AssessmentIndDefinitionId;
            if (k.AssessmentIndDefinition.Name == 'Nombre de carte SIM Dealer vendu') simDealerVenduDefId = k.AssessmentIndDefinitionId;
            if (k.AssessmentIndDefinition.Name == 'Nombre de SC vendu') scVenduDefId = k.AssessmentIndDefinitionId;
        }

        if (simVenduDefId != null) {
            insert new RetailVisitKpi(VisitId=visit1.Id, AssessmentIndDefinitionId=simVenduDefId, ActualIntegerValue=5);
        }
        if (simDealerVenduDefId != null) {
            insert new RetailVisitKpi(VisitId=visit1.Id, AssessmentIndDefinitionId=simDealerVenduDefId, ActualIntegerValue=3);
        }
        if (scVenduDefId != null) {
            insert new RetailVisitKpi(VisitId=visit1.Id, AssessmentIndDefinitionId=scVenduDefId, ActualIntegerValue=2);
        }

        User stdUser = new User(
            Alias='testusr',
            Email='test@test.org',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId=stdProfile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='testusr@test.org'
        );
        insert stdUser;

        User managedUser = new User(
            Alias='mgdusr',
            Email='mgdusr@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='ManagedUser',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId=cgcUserProfile.Id,
            ManagerId=stdUser.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='mgdusr@testorg.com'
        );
        insert managedUser;

        User noSubsFDV = new User(
            Alias='nosubfdv',
            Email='nosubfdv@test.com',
            EmailEncodingKey='UTF-8',
            LastName='NoSubsFDV',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = fdvProfile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='nosubfdv@test.com'
        );
        insert noSubsFDV;

        inwiCGC_DemandeDeVisite__c noChildDemande = new inwiCGC_DemandeDeVisite__c(
            Name='No Child Demande',
            OwnerId = rvrUser.Id,
            inwiCGC_Objectif_SIM__c = 500,
            inwiCGC_Objectif_SC__c = 700,
            inwiCGC_Objectif_SIM_Dealer__c = 900,
            Planned_End_Time__c = Datetime.now().addDays(3),
            Planned_Start_Time__c = Datetime.now()
        );
        insert noChildDemande;

        User noVisitsUser = new User(
            Alias='novisits',
            Email='novisits@test.com',
            EmailEncodingKey='UTF-8',
            LastName='NoVisits',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = cgcUserProfile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='novisits@test.com'
        );
        insert noVisitsUser;

        inwiCGC_DemandeDeVisite__c noVisitsDemande = new inwiCGC_DemandeDeVisite__c(
            Name='No Visits Demande',
            OwnerId = noVisitsUser.Id,
            inwiCGC_Objectif_SIM__c = 10,
            inwiCGC_Objectif_SC__c = 20,
            inwiCGC_Objectif_SIM_Dealer__c = 30,
            Planned_End_Time__c = Datetime.now().addDays(1),
            Planned_Start_Time__c = Datetime.now()
        );
        insert noVisitsDemande;
    }

    @isTest
    static void testGetManagedUsers_StdUser() {
        User stdUser = [SELECT Id FROM User WHERE Alias='testusr' LIMIT 1];
        Test.startTest();
        List<User> managed = inwiCGC_UserHierarchyController.getManagedUsers(stdUser.Id);
        Test.stopTest();
        System.assertNotEquals(0, managed.size());
    }

    @isTest
    static void testGetManagedUsers_FDVUser() {
        User fdvUser = [SELECT Id FROM User WHERE Alias='fdvuser' LIMIT 1];
        Test.startTest();
        List<User> managed = inwiCGC_UserHierarchyController.getManagedUsers(fdvUser.Id);
        Test.stopTest();
        System.assertNotEquals(0, managed.size());
    }

    @isTest
    static void testGetManagedUsers_NoSubsFDVUser() {
        User noSubsFDV = [SELECT Id FROM User WHERE Alias='nosubfdv' LIMIT 1];
        Test.startTest();
        List<User> managed = inwiCGC_UserHierarchyController.getManagedUsers(noSubsFDV.Id);
        Test.stopTest();
        System.assertEquals(0, managed.size());
    }

    @isTest
    static void testGetObjectivesForUserRows_MatchingParent() {
        User cgcUser = [SELECT Id FROM User WHERE Alias='cgcuser' LIMIT 1];
        inwiCGC_DemandeDeVisite__c childDemande = [SELECT Id, Parent__c FROM inwiCGC_DemandeDeVisite__c WHERE OwnerId = :cgcUser.Id LIMIT 1];
        List<Id> userIds = new List<Id>{ cgcUser.Id };
        Test.startTest();
        Map<Id, Map<String, Object>> objectivesMap = inwiCGC_UserHierarchyController.getObjectivesForUserRows(userIds, childDemande.Parent__c);
        Test.stopTest();
        System.assertEquals(true, objectivesMap.containsKey(cgcUser.Id));
    }

    @isTest
    static void testGetObjectivesForUserRows_NoMatchingParent() {
        User cgcUser = [SELECT Id FROM User WHERE Alias='cgcuser' LIMIT 1];
        Id fakeParentId = Id.valueOf('a0D000000000XYZ');
        List<Id> userIds = new List<Id>{ cgcUser.Id };
        Test.startTest();
        Map<Id, Map<String, Object>> objectivesMap = inwiCGC_UserHierarchyController.getObjectivesForUserRows(userIds, fakeParentId);
        Test.stopTest();
        System.assertEquals(false, objectivesMap.containsKey(cgcUser.Id));
    }

    @isTest
    static void testGetSubordinateObjectives_WithDemande() {
        User cgcUserSub = [SELECT Id FROM User WHERE Alias='cgcusub' LIMIT 1];
        inwiCGC_DemandeDeVisite__c cgcSubDemande = [SELECT Id FROM inwiCGC_DemandeDeVisite__c WHERE OwnerId = :cgcUserSub.Id LIMIT 1];
        Test.startTest();
        Map<String, Object> subobjs = inwiCGC_UserHierarchyController.getSubordinateObjectives(cgcUserSub.Id, cgcSubDemande.Id);
        Test.stopTest();
        System.assert(subobjs.containsKey('OwnerId'));
    }

    @isTest
    static void testGetSubordinateObjectives_NoDemande() {
        User cgcUserSub = [SELECT Id FROM User WHERE Alias='cgcusub' LIMIT 1];
        Test.startTest();
        Map<String, Object> subobjs = inwiCGC_UserHierarchyController.getSubordinateObjectives(cgcUserSub.Id, null);
        Test.stopTest();
        System.assert(subobjs.containsKey('SubordinateObjectives'));
    }

    @isTest
    static void testGetSubordinateObjectives_CGC_UserNoSubs() {
        Profile cgcProfile = [SELECT Id FROM Profile WHERE Name='CGC_User' LIMIT 1];
        User loneCGCUser = new User(
            Alias='lonecgc',
            Email='lonecgc@test.com',
            EmailEncodingKey='UTF-8',
            LastName='LoneCGC',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId=cgcProfile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='lonecgc@test.com'
        );
        insert loneCGCUser;

        inwiCGC_DemandeDeVisite__c loneDemande = new inwiCGC_DemandeDeVisite__c(
            Name='Lone Demande',
            OwnerId = loneCGCUser.Id,
            inwiCGC_Objectif_SIM__c = 10,
            inwiCGC_Objectif_SC__c = 20,
            inwiCGC_Objectif_SIM_Dealer__c = 30,
            Planned_End_Time__c = Datetime.now().addDays(1),
            Planned_Start_Time__c = Datetime.now()
        );
        insert loneDemande;

        Test.startTest();
        Map<String, Object> subobjs = inwiCGC_UserHierarchyController.getSubordinateObjectives(loneCGCUser.Id, loneDemande.Id);
        Test.stopTest();
        System.assert(subobjs.containsKey('OwnerId'));
    }

    @isTest
    static void testGetSubordinateObjectives_FDVUser() {
        User fdvUser = [SELECT Id FROM User WHERE Alias='fdvuser' LIMIT 1];
        inwiCGC_DemandeDeVisite__c parentDemande = [SELECT Id FROM inwiCGC_DemandeDeVisite__c WHERE OwnerId = :fdvUser.Id LIMIT 1];
        Test.startTest();
        Map<String, Object> objs = inwiCGC_UserHierarchyController.getSubordinateObjectives(fdvUser.Id, parentDemande.Id);
        Test.stopTest();
        System.assert(objs.containsKey('OwnerId'));
    }

    @isTest
    static void testGetSubordinateSalesValues_WithDemande() {
        User cgcUserSub = [SELECT Id FROM User WHERE Alias='cgcusub' LIMIT 1];
        inwiCGC_DemandeDeVisite__c cgcSubDemande = [SELECT Id FROM inwiCGC_DemandeDeVisite__c WHERE OwnerId = :cgcUserSub.Id LIMIT 1];
        Test.startTest();
        Map<String, Object> salesValues = inwiCGC_UserHierarchyController.getSubordinateSalesValues(cgcUserSub.Id, cgcSubDemande.Id);
        Test.stopTest();
        System.assert(salesValues.containsKey('SIMVendu'));
    }

    @isTest
    static void testGetSubordinateSalesValues_NoDemande() {
        User cgcUser = [SELECT Id FROM User WHERE Alias='cgcuser' LIMIT 1];
        Test.startTest();
        Map<String, Object> salesValues = inwiCGC_UserHierarchyController.getSubordinateSalesValues(cgcUser.Id, null);
        Test.stopTest();
        System.assert(salesValues.containsKey('SIMVendu'));
    }

    @isTest
    static void testGetSubordinateSalesValues_RVRNoChildren() {
        User rvrUser = [SELECT Id FROM User WHERE Alias='rvruser' LIMIT 1];
        User noSubsFDV = [SELECT Id FROM User WHERE Alias='nosubfdv' LIMIT 1];
        Test.startTest();
        Map<String, Object> salesValues = inwiCGC_UserHierarchyController.getSubordinateSalesValues(rvrUser.Id, null);
        Test.stopTest();
        System.assert(salesValues.containsKey('SIMVendu'));
    }

    @isTest
    static void testGetSubordinateSalesValues_NoVisits() {
        User noVisitsUser = [SELECT Id FROM User WHERE Alias='novisits' LIMIT 1];
        inwiCGC_DemandeDeVisite__c noVisitsDemande = [SELECT Id FROM inwiCGC_DemandeDeVisite__c WHERE OwnerId=:noVisitsUser.Id LIMIT 1];
        Test.startTest();
        Map<String, Object> salesValues = inwiCGC_UserHierarchyController.getSubordinateSalesValues(noVisitsUser.Id, noVisitsDemande.Id);
        Test.stopTest();
        System.assert(salesValues.containsKey('SIMVendu'));
    }

    @isTest
    static void testFindAllLastDemandesDeVisite_MultipleLevels() {
        User fdvUser = [SELECT Id FROM User WHERE Alias='fdvuser' LIMIT 1];
        inwiCGC_DemandeDeVisite__c parentDemande = [SELECT Id FROM inwiCGC_DemandeDeVisite__c WHERE OwnerId=:fdvUser.Id LIMIT 1];
        Test.startTest();
        inwiCGC_UserHierarchyController.getSubordinateSalesValues(fdvUser.Id, parentDemande.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetDemandesDeVisite() {
        Test.startTest();
        List<inwiCGC_UserHierarchyController.WrapperDemandeDeVisite> demandes = inwiCGC_UserHierarchyController.getDemandesDeVisite();
        Test.stopTest();
    }
}