public with sharing class inwiCGC_DDVSController {
    @AuraEnabled
    public static List<Map<String, Object>> getDemandesDeVisiteWithManagersAndSales() {
        Id currentUserId = UserInfo.getUserId();
        Set<Id> subordinateIds = getAllSubordinateIds(currentUserId);

        List<Visit> visits = [
            SELECT Id, Name, PlannedVisitStartTime, VisitorId,
                inwiCGC_DemandeDeVisite__c, RetailStore.Name,
                RetailStore.inwiCGC_Region_AC__c, RetailStore.inwiCGC_Flag__c,
                RetailStore.inwiCGC_VilleAM__c
            FROM Visit
            WHERE VisitorId IN :subordinateIds
            AND Status = 'Completed'
            AND inwiCGC_DemandeDeVisite__c != null
        ];

        Set<Id> visitorIds = new Set<Id>();
        Set<Id> demandeDeVisiteIds = new Set<Id>();
        for (Visit visit : visits) {
            if (visit.VisitorId != null) {
                visitorIds.add(visit.VisitorId);
            }
            if (visit.inwiCGC_DemandeDeVisite__c != null) {
                demandeDeVisiteIds.add(visit.inwiCGC_DemandeDeVisite__c);
            }
        }

        List<User> visitors = [
            SELECT Id, Name, Manager.Name
            FROM User
            WHERE Id IN :visitorIds
        ];
        Map<Id, User> visitorMap = new Map<Id, User>(visitors);

        List<inwiCGC_DemandeDeVisite__c> demandesDeVisite = [
            SELECT Id, Name, Planned_Start_Time__c, Planned_End_Time__c,
                inwiCGC_Objectif_SIM__c, inwiCGC_Objectif_SIM_Dealer__c, inwiCGC_Objectif_SC__c, Owner.Name
            FROM inwiCGC_DemandeDeVisite__c
            WHERE Id IN :demandeDeVisiteIds
        ];
        Map<Id, inwiCGC_DemandeDeVisite__c> demandeMap = new Map<Id, inwiCGC_DemandeDeVisite__c>(demandesDeVisite);

        List<RetailVisitKpi> assessments = [
            SELECT VisitId, ActualIntegerValue, AssessmentIndDefinition.Name
            FROM RetailVisitKpi
            WHERE VisitId IN :visits
        ];

        Map<Id, Map<String, Integer>> visitSalesMap = new Map<Id, Map<String, Integer>>();
        for (RetailVisitKpi assessment : assessments) {
            if (!visitSalesMap.containsKey(assessment.VisitId)) {
                visitSalesMap.put(assessment.VisitId, new Map<String, Integer>{
                    'SIMVendu' => 0,
                    'SIMDealerVendu' => 0,
                    'SCVendu' => 0
                });
            }

            Map<String, Integer> salesValues = visitSalesMap.get(assessment.VisitId);
            if (assessment.AssessmentIndDefinition.Name == 'Nombre de carte SIM vendu') {
                salesValues.put('SIMVendu', salesValues.get('SIMVendu') + assessment.ActualIntegerValue);
            } else if (assessment.AssessmentIndDefinition.Name == 'Nombre de carte SIM Dealer vendu') {
                salesValues.put('SIMDealerVendu', salesValues.get('SIMDealerVendu') + assessment.ActualIntegerValue);
            } else if (assessment.AssessmentIndDefinition.Name == 'Nombre de SC vendu') {
                salesValues.put('SCVendu', salesValues.get('SCVendu') + assessment.ActualIntegerValue);
            }
        }

        List<Map<String, Object>> response = new List<Map<String, Object>>();
        for (Visit visit : visits) {
            if (!demandeMap.containsKey(visit.inwiCGC_DemandeDeVisite__c)) continue;

            Map<String, Object> visitMap = new Map<String, Object>();
            inwiCGC_DemandeDeVisite__c demande = demandeMap.get(visit.inwiCGC_DemandeDeVisite__c);

            visitMap.put('DemandeId', demande.Id);
            visitMap.put('DemandeName', demande.Name);
            visitMap.put('PlannedStartTime', demande.Planned_Start_Time__c);
            visitMap.put('PlannedEndTime', demande.Planned_End_Time__c);
            visitMap.put('ObjectifSIM', demande.inwiCGC_Objectif_SIM__c);
            visitMap.put('ObjectifSIMDealer', demande.inwiCGC_Objectif_SIM_Dealer__c);
            visitMap.put('ObjectifSC', demande.inwiCGC_Objectif_SC__c);
            visitMap.put('DDVOwner', demande.Owner.Name);

            visitMap.put('VisitId', visit.Id);
            visitMap.put('VisitName', visit.Name);
            visitMap.put('VisitorId', visit.VisitorId);
            visitMap.put('PlannedVisitStartTime', visit.PlannedVisitStartTime);
            visitMap.put('Region', visit.RetailStore.inwiCGC_Region_AC__c);
            visitMap.put('Route', visit.RetailStore.inwiCGC_Flag__c);
            visitMap.put('Circuit', visit.RetailStore.inwiCGC_VilleAM__c);
            visitMap.put('ActeurMarche', visit.RetailStore.Name);

            User visitor = visitorMap.get(visit.VisitorId);
            visitMap.put('VisitorName', visitor != null ? visitor.Name : null);
            visitMap.put('ManagerName', visitor != null && visitor.Manager != null ? visitor.Manager.Name : null);

            Map<String, Integer> salesValues = visitSalesMap.get(visit.Id);
            if (salesValues != null) {
                visitMap.put('SIMVendu', salesValues.get('SIMVendu'));
                visitMap.put('SIMDealerVendu', salesValues.get('SIMDealerVendu'));
                visitMap.put('SCVendu', salesValues.get('SCVendu'));
            } else {
                visitMap.put('SIMVendu', 0);
                visitMap.put('SIMDealerVendu', 0);
                visitMap.put('SCVendu', 0);
            }

            response.add(visitMap);
        }

        return response;
    }

    @AuraEnabled
    public static Map<Id, Map<String, Integer>> getTotalSalesByDemande(List<Id> demandeDeVisiteIds) {
        Set<Id> demandeDeVisiteIdSet = new Set<Id>(demandeDeVisiteIds);
    
        List<Visit> visits = [
            SELECT Id, inwiCGC_DemandeDeVisite__c
            FROM Visit
            WHERE inwiCGC_DemandeDeVisite__c IN :demandeDeVisiteIdSet
              AND Status = 'Completed'
        ];
    
        Set<Id> visitIds = new Set<Id>();
        for (Visit visit : visits) {
            visitIds.add(visit.Id);
        }
    
        List<RetailVisitKpi> assessments = [
            SELECT VisitId, ActualIntegerValue, AssessmentIndDefinition.Name
            FROM RetailVisitKpi
            WHERE VisitId IN :visitIds
        ];
    
        Map<Id, Map<String, Integer>> demandeSalesTotals = new Map<Id, Map<String, Integer>>();
        for (RetailVisitKpi assessment : assessments) {
            Id demandeId;
            for (Visit visit : visits) {
                if (visit.Id == assessment.VisitId) {
                    demandeId = visit.inwiCGC_DemandeDeVisite__c;
                    break;
                }
            }
    
            if (!demandeSalesTotals.containsKey(demandeId)) {
                demandeSalesTotals.put(demandeId, new Map<String, Integer>{
                    'TotalSIMVendu' => 0,
                    'TotalSIMDealerVendu' => 0,
                    'TotalSCVendu' => 0
                });
            }
    
            Map<String, Integer> demandeSales = demandeSalesTotals.get(demandeId);
            if (assessment.AssessmentIndDefinition.Name == 'Nombre de carte SIM vendu') {
                demandeSales.put('TotalSIMVendu', demandeSales.get('TotalSIMVendu') + assessment.ActualIntegerValue);
            } else if (assessment.AssessmentIndDefinition.Name == 'Nombre de carte SIM Dealer vendu') {
                demandeSales.put('TotalSIMDealerVendu', demandeSales.get('TotalSIMDealerVendu') + assessment.ActualIntegerValue);
            } else if (assessment.AssessmentIndDefinition.Name == 'Nombre de SC vendu') {
                demandeSales.put('TotalSCVendu', demandeSales.get('TotalSCVendu') + assessment.ActualIntegerValue);
            }
        }
    
        return demandeSalesTotals;
    }

    @AuraEnabled
    public static Map<Id, Map<String, String>> getVisitOwnerManagers(List<Id> visitorIds) {
        Map<Id, Map<String, String>> visitorHierarchyMap = new Map<Id, Map<String, String>>();
    
        for (Id visitorId : visitorIds) {
            Map<String, String> hierarchy = new Map<String, String>();
            Id currentId = visitorId;
            String currentRole = '';
            User currentUser;
    
            while (currentId != null) {
                currentUser = [
                    SELECT Id, Name, Profile.Name, UserRole.Name, ManagerId, Manager.Name, Manager.UserRole.Name
                    FROM User
                    WHERE Id = :currentId
                    LIMIT 1
                ];
    
                if (currentUser.Profile.Name == 'CGC_RVR') {
                    hierarchy.put('RVR', currentUser.Name);
                } else if (currentUser.UserRole.Name == 'Casa') {
                    hierarchy.put('MR', currentUser.Name);
                } else if (currentUser.UserRole.Name == 'Opération VI') {
                    hierarchy.put('OperationVI', currentUser.Name);
                } else if (currentUser.UserRole.Name == 'Manager VI') {
                    hierarchy.put('ManagerVI', currentUser.Name);
                } else if (currentUser.UserRole.Name == 'Canal VI') {
                    hierarchy.put('CanalVI', currentUser.Name);
                }
    
                currentId = currentUser.ManagerId;
            }
    
            visitorHierarchyMap.put(visitorId, hierarchy);
        }
    
        return visitorHierarchyMap;
    }
    

    @AuraEnabled(cacheable=true)
    public static String getCurrentUserRole() {
        User currentUser = [SELECT UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return currentUser.UserRole != null ? currentUser.UserRole.Name : null;
    }

    @TestVisible
    private static Set<Id> getAllSubordinateIds(Id userId) {
        Set<Id> allSubordinateIds = new Set<Id>();
        User currentUser = [SELECT Id, Name, Profile.Name FROM User WHERE Id = :userId LIMIT 1];
        
        if (currentUser.Profile.Name == 'CGC_User') {
            allSubordinateIds.add(userId);
        } else {
            List<User> level1Subordinates = [SELECT Id, Name, Profile.Name FROM User WHERE ManagerId = :userId];
            for (User user : level1Subordinates) {
                allSubordinateIds.add(user.Id);
                getSubordinatesRecursively(user.Id, allSubordinateIds);
            }
        }
        System.debug('Subordinate IDs: ' + allSubordinateIds);
        return allSubordinateIds;
    }

    @TestVisible
    private static void getSubordinatesRecursively(Id managerId, Set<Id> subordinateIds) {
        List<User> subordinates = [SELECT Id FROM User WHERE ManagerId = :managerId];
        for (User subordinate : subordinates) {
            subordinateIds.add(subordinate.Id);
            getSubordinatesRecursively(subordinate.Id, subordinateIds);
        }
    }
}