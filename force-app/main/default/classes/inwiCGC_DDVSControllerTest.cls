@isTest
public class inwiCGC_DDVSControllerTest {

    private static User createUser(String profileName, String userName, Id managerId, Id userRoleId) {
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName LIMIT 1];
        User u = new User(
            Alias = userName.left(5),
            Email = userName + '@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = userName,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName = userName + '@test.com'
        );
        if (managerId != null) {
            u.ManagerId = managerId;
        }
        if (userRoleId != null) {
            u.UserRoleId = userRoleId;
        }
        insert u;
        return u;
    }

    private static User createUser(String profileName, String userName, Id managerId) {
        return createUser(profileName, userName, managerId, null);
    }

    private static Schema.RetailStore createRetailStore() {
        Account acc = new Account(Name='Parent Account Test');
        insert acc;
        Schema.RetailStore store = new Schema.RetailStore(
            Name='Test Store',
            inwiCGC_Region_AC__c='CA',
            inwiCGC_Flag__c='RTMU',
            inwiCGC_VilleAM__c='LISASFA',
            AccountId = acc.Id
        );
        insert store;
        return store;
    }

    private static inwiCGC_DemandeDeVisite__c createDemande(Id ownerId) {
        inwiCGC_DemandeDeVisite__c d = new inwiCGC_DemandeDeVisite__c(
            Name='Test Demande',
            OwnerId = ownerId,
            Planned_Start_Time__c=DateTime.now(),
            Planned_End_Time__c=DateTime.now().addDays(1),
            inwiCGC_Objectif_SIM__c=100,
            inwiCGC_Objectif_SIM_Dealer__c=50,
            inwiCGC_Objectif_SC__c=30
        );
        insert d;
        return d;
    }

    private static Visit createVisit(inwiCGC_DemandeDeVisite__c demande, Id visitorId, Id storeId) {
        Account parentAccount = new Account(Name='Visit Account');
        insert parentAccount;
        Visit v = new Visit(
            PlannedVisitStartTime = DateTime.now(),
            VisitorId = visitorId,
            AccountId = parentAccount.Id,
            Status = 'Completed',
            PlaceId = storeId,
            inwiCGC_DemandeDeVisite__c = demande.Id
        );
        insert v;
        return v;
    }

    @isTest
    static void testAsCGCUserNoNonSetup() {
        User cgcUser = createUser('CGC_User','cgcusr',null);
        System.runAs(cgcUser) {
            Test.startTest();
            List<Map<String, Object>> result = inwiCGC_DDVSController.getDemandesDeVisiteWithManagersAndSales();
            Set<Id> subs = inwiCGC_DDVSController.getAllSubordinateIds(UserInfo.getUserId());
            inwiCGC_DDVSController.getSubordinatesRecursively(UserInfo.getUserId(), subs);
            String roleName = inwiCGC_DDVSController.getCurrentUserRole();
            Test.stopTest();
        }
    }

    @isTest
    static void testAsFDVWithSubsNoNonSetup() {
        User fdvManager = createUser('CGC_FDV_Manager','fdvUsr',null);
        User cgcSub = createUser('CGC_User','cgcSubF',fdvManager.Id);
        System.runAs(fdvManager) {
            Test.startTest();
            List<Map<String, Object>> result = inwiCGC_DDVSController.getDemandesDeVisiteWithManagersAndSales();
            Set<Id> subs = inwiCGC_DDVSController.getAllSubordinateIds(UserInfo.getUserId());
            inwiCGC_DDVSController.getSubordinatesRecursively(UserInfo.getUserId(), subs);
            Test.stopTest();
        }
    }

    @isTest
    static void testWithDataNonSetupOnly() {
        User cgcUser = createUser('CGC_User','cgcDataUser',null);
        System.runAs(cgcUser) {
            Schema.RetailStore store = createRetailStore();
            inwiCGC_DemandeDeVisite__c demande1 = createDemande(UserInfo.getUserId());
            Visit visit1 = createVisit(demande1, UserInfo.getUserId(), store.Id);
            Id simVenduDefId = null;
            Id simDealerDefId = null;
            Id scVenduDefId = null;
            List<RetailVisitKpi> existingKpis = [
                SELECT Id, AssessmentIndDefinitionId, AssessmentIndDefinition.Name 
                FROM RetailVisitKpi 
                WHERE AssessmentIndDefinition.Name IN ('Nombre de carte SIM vendu','Nombre de carte SIM Dealer vendu','Nombre de SC vendu')
                LIMIT 3
            ];
            for (RetailVisitKpi k : existingKpis) {
                if (k.AssessmentIndDefinition.Name == 'Nombre de carte SIM vendu') simVenduDefId = k.AssessmentIndDefinitionId;
                if (k.AssessmentIndDefinition.Name == 'Nombre de carte SIM Dealer vendu') simDealerDefId = k.AssessmentIndDefinitionId;
                if (k.AssessmentIndDefinition.Name == 'Nombre de SC vendu') scVenduDefId = k.AssessmentIndDefinitionId;
            }
            if (simVenduDefId != null) {
                insert new RetailVisitKpi(VisitId=visit1.Id, AssessmentIndDefinitionId=simVenduDefId, ActualIntegerValue=10);
            }
            if (simDealerDefId != null) {
                insert new RetailVisitKpi(VisitId=visit1.Id, AssessmentIndDefinitionId=simDealerDefId, ActualIntegerValue=5);
            }
            if (scVenduDefId != null) {
                insert new RetailVisitKpi(VisitId=visit1.Id, AssessmentIndDefinitionId=scVenduDefId, ActualIntegerValue=7);
            }
            Test.startTest();
            List<Map<String, Object>> result = inwiCGC_DDVSController.getDemandesDeVisiteWithManagersAndSales();
            System.assertNotEquals(null, result);
            Map<Id, Map<String, Integer>> totals = inwiCGC_DDVSController.getTotalSalesByDemande(new List<Id>{demande1.Id});
            System.assertNotEquals(null, totals);
            Map<Id, Map<String, String>> hierarchy = inwiCGC_DDVSController.getVisitOwnerManagers(new List<Id>{UserInfo.getUserId()});
            System.assertNotEquals(null, hierarchy);
            String roleName = inwiCGC_DDVSController.getCurrentUserRole();
            Set<Id> subs = inwiCGC_DDVSController.getAllSubordinateIds(UserInfo.getUserId());
            inwiCGC_DDVSController.getSubordinatesRecursively(UserInfo.getUserId(), subs);
            Test.stopTest();
        }
    }

    @isTest
    static void testTotalSalesByDemande_NoVisits() {
        User cgcUser = createUser('CGC_User','cgcNoVisitUser',null);
        System.runAs(cgcUser) {
            inwiCGC_DemandeDeVisite__c demandeNoVisits = new inwiCGC_DemandeDeVisite__c(
                Name='Demande No Visits',
                OwnerId=UserInfo.getUserId(),
                Planned_Start_Time__c=DateTime.now(),
                Planned_End_Time__c=DateTime.now().addDays(1),
                inwiCGC_Objectif_SIM__c=300,
                inwiCGC_Objectif_SIM_Dealer__c=120,
                inwiCGC_Objectif_SC__c=90
            );
            insert demandeNoVisits;
            Test.startTest();
            Map<Id, Map<String, Integer>> totalsNoVisits = inwiCGC_DDVSController.getTotalSalesByDemande(new List<Id>{demandeNoVisits.Id});
            System.assertNotEquals(null, totalsNoVisits);
            Set<Id> subs = inwiCGC_DDVSController.getAllSubordinateIds(UserInfo.getUserId());
            inwiCGC_DDVSController.getSubordinatesRecursively(UserInfo.getUserId(), subs);
            Test.stopTest();
        }
    }

    @isTest
    static void testGetVisitOwnerManagers_RVRUser() {
        User rvrUser = createUser('CGC_RVR','rvrUsr2',null);
        System.runAs(rvrUser) {
            Test.startTest();
            Map<Id, Map<String, String>> hierarchy = inwiCGC_DDVSController.getVisitOwnerManagers(new List<Id>{rvrUser.Id});
            System.assertNotEquals(null, hierarchy);
            Set<Id> subs = inwiCGC_DDVSController.getAllSubordinateIds(rvrUser.Id);
            inwiCGC_DDVSController.getSubordinatesRecursively(rvrUser.Id, subs);
            Test.stopTest();
        }
    }

    @isTest
    static void testMultipleKPIsInTotalSalesByDemande() {
        User cgcUser = createUser('CGC_User','cgcMultiKPIUser',null);
        System.runAs(cgcUser) {
            Account acc = new Account(Name='Test Acc Multiple');
            insert acc;
            Schema.RetailStore st = new Schema.RetailStore(
                Name='Test Store Multiple',
                inwiCGC_Region_AC__c='CS',
                inwiCGC_Flag__c='RTMR',
                inwiCGC_VilleAM__c='Rehamna',
                AccountId = acc.Id
            );
            insert st;
            inwiCGC_DemandeDeVisite__c d1 = new inwiCGC_DemandeDeVisite__c(
                Name='Multi KPI Demande',
                OwnerId=UserInfo.getUserId(),
                Planned_Start_Time__c=DateTime.now(),
                Planned_End_Time__c=DateTime.now().addDays(1),
                inwiCGC_Objectif_SIM__c=100,
                inwiCGC_Objectif_SIM_Dealer__c=200,
                inwiCGC_Objectif_SC__c=300
            );
            insert d1;
            Visit v1 = new Visit(
                PlannedVisitStartTime=DateTime.now(),
                VisitorId=UserInfo.getUserId(),
                AccountId=acc.Id,
                Status='Completed',
                PlaceId = st.Id,
                inwiCGC_DemandeDeVisite__c=d1.Id
            );
            insert v1;
            Id simV=null, simD=null, scV=null;
            List<RetailVisitKpi> defs = [
                SELECT AssessmentIndDefinitionId, AssessmentIndDefinition.Name
                FROM RetailVisitKpi
                WHERE AssessmentIndDefinition.Name IN (
                    'Nombre de carte SIM vendu',
                    'Nombre de carte SIM Dealer vendu',
                    'Nombre de SC vendu'
                )
                LIMIT 3
            ];
            for (RetailVisitKpi rk: defs) {
                if (rk.AssessmentIndDefinition.Name=='Nombre de carte SIM vendu') simV=rk.AssessmentIndDefinitionId;
                if (rk.AssessmentIndDefinition.Name=='Nombre de carte SIM Dealer vendu') simD=rk.AssessmentIndDefinitionId;
                if (rk.AssessmentIndDefinition.Name=='Nombre de SC vendu') scV=rk.AssessmentIndDefinitionId;
            }
            if (simV!=null) insert new RetailVisitKpi(VisitId=v1.Id, AssessmentIndDefinitionId=simV, ActualIntegerValue=15);
            if (simD!=null) insert new RetailVisitKpi(VisitId=v1.Id, AssessmentIndDefinitionId=simD, ActualIntegerValue=25);
            if (scV!=null) insert new RetailVisitKpi(VisitId=v1.Id, AssessmentIndDefinitionId=scV, ActualIntegerValue=35);
            Test.startTest();
            Map<Id, Map<String,Integer>> totalMap = inwiCGC_DDVSController.getTotalSalesByDemande(new List<Id>{d1.Id});
            System.assertNotEquals(null, totalMap);
            Test.stopTest();
        }
    }

    @isTest
    static void testGetVisitOwnerManagers_MultipleLevels() {
        // Query user roles with the expected names
        Id canalViRoleId = [SELECT Id FROM UserRole WHERE Name = 'Canal VI' LIMIT 1].Id;
        Id managerViRoleId = [SELECT Id FROM UserRole WHERE Name = 'Manager VI' LIMIT 1].Id;
        Id operationViRoleId = [SELECT Id FROM UserRole WHERE Name = 'Opération VI' LIMIT 1].Id;
        Id casaRoleId = [SELECT Id FROM UserRole WHERE Name = 'Casa' LIMIT 1].Id;

        User canalViUser = createUser('CGC_FDV_Manager','canalVIUser',null, canalViRoleId);
        User managerViUser = createUser('CGC_FDV_Manager','managerVIUser',canalViUser.Id, managerViRoleId);
        User operationViUser = createUser('CGC_FDV_Manager','operationVIUser',managerViUser.Id, operationViRoleId);
        User casaUser = createUser('CGC_FDV_Manager','casaUser',operationViUser.Id, casaRoleId);
        User rvrUser = createUser('CGC_RVR','rvrUserComplex',casaUser.Id); // RVR profile
        User cgcLeaf = createUser('CGC_User','cgcLeafUser',rvrUser.Id); // CGC_User profile
        System.runAs(cgcLeaf) {
            Test.startTest();
            Map<Id, Map<String, String>> hierarchy = inwiCGC_DDVSController.getVisitOwnerManagers(new List<Id>{cgcLeaf.Id});
            System.assertNotEquals(null, hierarchy);
            System.assertNotEquals(null, hierarchy.get(cgcLeaf.Id));
            Test.stopTest();
        }
    }

    @isTest
    static void testNoKpiDefinitionsFound() {
        User cgcUser = createUser('CGC_User','cgcNoKPIUser',null);
        System.runAs(cgcUser) {
            Schema.RetailStore store = createRetailStore();
            inwiCGC_DemandeDeVisite__c demande2 = createDemande(UserInfo.getUserId());
            Visit visit2 = createVisit(demande2, UserInfo.getUserId(), store.Id);
            Test.startTest();
            List<Map<String, Object>> result = inwiCGC_DDVSController.getDemandesDeVisiteWithManagersAndSales();
            System.assertNotEquals(null, result);
            Test.stopTest();
        }
    }

    @isTest
    static void testMultipleVisitsOneDemande() {
        User cgcUser = createUser('CGC_User','cgcMultiVisits',null);
        System.runAs(cgcUser) {
            Schema.RetailStore store = createRetailStore();
            inwiCGC_DemandeDeVisite__c demande = createDemande(UserInfo.getUserId());
            Visit visitA = createVisit(demande, UserInfo.getUserId(), store.Id);
            Visit visitB = createVisit(demande, UserInfo.getUserId(), store.Id);
            Id simV=null, simD=null, scV=null;
            List<RetailVisitKpi> defs = [
                SELECT AssessmentIndDefinitionId, AssessmentIndDefinition.Name
                FROM RetailVisitKpi
                WHERE AssessmentIndDefinition.Name IN (
                    'Nombre de carte SIM vendu',
                    'Nombre de carte SIM Dealer vendu',
                    'Nombre de SC vendu'
                )
                LIMIT 3
            ];
            for (RetailVisitKpi rk: defs) {
                if (rk.AssessmentIndDefinition.Name=='Nombre de carte SIM vendu') simV=rk.AssessmentIndDefinitionId;
                if (rk.AssessmentIndDefinition.Name=='Nombre de carte SIM Dealer vendu') simD=rk.AssessmentIndDefinitionId;
                if (rk.AssessmentIndDefinition.Name=='Nombre de SC vendu') scV=rk.AssessmentIndDefinitionId;
            }
            if (simV!=null) {
                insert new RetailVisitKpi(VisitId=visitA.Id, AssessmentIndDefinitionId=simV, ActualIntegerValue=5);
                insert new RetailVisitKpi(VisitId=visitB.Id, AssessmentIndDefinitionId=simV, ActualIntegerValue=10);
            }
            if (simD!=null) {
                insert new RetailVisitKpi(VisitId=visitA.Id, AssessmentIndDefinitionId=simD, ActualIntegerValue=2);
                insert new RetailVisitKpi(VisitId=visitB.Id, AssessmentIndDefinitionId=simD, ActualIntegerValue=8);
            }
            if (scV!=null) {
                insert new RetailVisitKpi(VisitId=visitA.Id, AssessmentIndDefinitionId=scV, ActualIntegerValue=1);
                insert new RetailVisitKpi(VisitId=visitB.Id, AssessmentIndDefinitionId=scV, ActualIntegerValue=4);
            }
            Test.startTest();
            Map<Id, Map<String,Integer>> totalMap = inwiCGC_DDVSController.getTotalSalesByDemande(new List<Id>{demande.Id});
            System.assertNotEquals(null, totalMap);
            Test.stopTest();
        }
    }

    @isTest
    static void testNoUserRole() {
        User noRoleUser = createUser('CGC_User','noRoleUser',null);
        noRoleUser = [SELECT Id, UserRoleId FROM User WHERE Id=:noRoleUser.Id LIMIT 1];
        if (noRoleUser.UserRoleId != null) {
        }

        System.runAs(noRoleUser) {
            Test.startTest();
            String roleName = inwiCGC_DDVSController.getCurrentUserRole();
            System.assertEquals(null, roleName);
            Test.stopTest();
        }
    }
}