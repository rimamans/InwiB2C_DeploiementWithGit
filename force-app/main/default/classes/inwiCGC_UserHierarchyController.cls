public with sharing class inwiCGC_UserHierarchyController {
    
    @AuraEnabled(cacheable=true)
    public static List<User> getManagedUsers(Id currentUserId) {
        return [SELECT Id, Name, Profile.Name, ManagerId 
                FROM User 
                WHERE ManagerId = :currentUserId];
    }

    @AuraEnabled
    public static Map<Id, Map<String, Object>> getObjectivesForUserRows(List<Id> userIds, Id parentDemandeId) {
        Map<Id, Map<String, Object>> objectivesMap = new Map<Id, Map<String, Object>>();

        List<inwiCGC_DemandeDeVisite__c> demandes = [
            SELECT Id, OwnerId, Parent__c, inwiCGC_Objectif_SIM__c, inwiCGC_Objectif_SIM_Dealer__c, inwiCGC_Objectif_SC__c
            FROM inwiCGC_DemandeDeVisite__c
            WHERE OwnerId IN :userIds
        ];

        for (inwiCGC_DemandeDeVisite__c demande : demandes) {
            Id matchingDemandeId = findMatchingParent(demande, parentDemandeId);
            
            if (matchingDemandeId != null) {
                Map<String, Object> objectivesData = new Map<String, Object>();
                objectivesData.put('objectifSIM', demande.inwiCGC_Objectif_SIM__c);
                objectivesData.put('objectifSIMDealer', demande.inwiCGC_Objectif_SIM_Dealer__c);
                objectivesData.put('objectifSC', demande.inwiCGC_Objectif_SC__c);
                objectivesMap.put(demande.OwnerId, objectivesData);
            }
        }

        return objectivesMap;
    }

    private static Id findMatchingParent(inwiCGC_DemandeDeVisite__c demande, Id targetParentId) {
        if (demande.Parent__c == targetParentId) {
            return demande.Id;
        } else if (demande.Parent__c != null) {
            inwiCGC_DemandeDeVisite__c parentDemande = [
                SELECT Id, Parent__c 
                FROM inwiCGC_DemandeDeVisite__c 
                WHERE Id = :demande.Parent__c 
                LIMIT 1
            ];
            
            return findMatchingParent(parentDemande, targetParentId);
        }
        return null;
    }



    @AuraEnabled
    public static Map<String, Object> getSubordinateObjectives(Id userId, Id demandeDeVisiteId) {
        Map<String, Object> response = new Map<String, Object>();
        Set<Id> allSubordinateIds = getAllSubordinateIds(userId);
        
        if (demandeDeVisiteId != null) {
            inwiCGC_DemandeDeVisite__c parentDemande = [
                SELECT Id, OwnerId, inwiCGC_Objectif_SIM__c, inwiCGC_Objectif_SC__c, inwiCGC_Objectif_SIM_Dealer__c
                FROM inwiCGC_DemandeDeVisite__c
                WHERE Id = :demandeDeVisiteId
                LIMIT 1
            ];
            response.put('OwnerId', parentDemande.OwnerId);
            response.put('ObjectifSIM', parentDemande.inwiCGC_Objectif_SIM__c);
            response.put('ObjectifSC', parentDemande.inwiCGC_Objectif_SC__c);
            response.put('ObjectifSIMDealer', parentDemande.inwiCGC_Objectif_SIM_Dealer__c);
        }
    
        Map<Id, Map<String, Object>> subordinateObjectives = fetchChildDemandes(demandeDeVisiteId, allSubordinateIds);
        response.put('SubordinateObjectives', subordinateObjectives);
        
        return response;
    }
    
    private static Map<Id, Map<String, Object>> fetchChildDemandes(Id parentDemandeId, Set<Id> subordinateIds) {
        Map<Id, Map<String, Object>> objectivesMap = new Map<Id, Map<String, Object>>();
        
        List<inwiCGC_DemandeDeVisite__c> childDemandes = [
            SELECT Id, OwnerId, Parent__c, inwiCGC_Objectif_SIM__c, inwiCGC_Objectif_SIM_Dealer__c, inwiCGC_Objectif_SC__c
            FROM inwiCGC_DemandeDeVisite__c
            WHERE Parent__c = :parentDemandeId AND OwnerId IN :subordinateIds
        ];

        for (inwiCGC_DemandeDeVisite__c demande : childDemandes) {
            Map<String, Object> objectivesData = new Map<String, Object>();
            objectivesData.put('objectifSIM', demande.inwiCGC_Objectif_SIM__c);
            objectivesData.put('objectifSIMDealer', demande.inwiCGC_Objectif_SIM_Dealer__c);
            objectivesData.put('objectifSC', demande.inwiCGC_Objectif_SC__c);
            objectivesMap.put(demande.OwnerId, objectivesData);

            Set<Id> furtherSubordinates = new Set<Id>{demande.OwnerId};
            Map<Id, Map<String, Object>> furtherObjectives = fetchChildDemandes(demande.Id, furtherSubordinates);
            objectivesMap.putAll(furtherObjectives);
        }

        return objectivesMap;
    }

    

    @AuraEnabled
    public static Map<String, Object> getSubordinateSalesValues(Id userId, Id demandeDeVisiteId) {
        Map<String, Object> response = new Map<String, Object>();
        Set<Id> allSubordinateIds = getAllSubordinateIds(userId);
        
        List<Id> lastDemandeDeVisiteId = (demandeDeVisiteId != null) ? findAllLastDemandesDeVisite(demandeDeVisiteId) : null;

        List<Visit> visits;
        if (lastDemandeDeVisiteId != null) {
            visits = [
                SELECT Id, inwiCGC_DemandeDeVisite__c, VisitorId
                FROM Visit
                WHERE VisitorId IN :allSubordinateIds
                AND Status = 'Completed'
                AND inwiCGC_DemandeDeVisite__c = :lastDemandeDeVisiteId
            ];
        } else {
            visits = [
                SELECT Id, inwiCGC_DemandeDeVisite__c, VisitorId
                FROM Visit
                WHERE VisitorId IN :allSubordinateIds
                AND Status = 'Completed'
            ];
        }
        
        List<Id> visitIds = new List<Id>();
        for (Visit visit : visits) {
            visitIds.add(visit.Id);
        }
        
        List<RetailVisitKpi> assessments = [
            SELECT ActualIntegerValue, AssessmentIndDefinition.Name, Visit.VisitorId
            FROM RetailVisitKpi
            WHERE VisitId IN :visitIds
        ];
        
        Map<Id, Map<String, Integer>> subordinateSalesValues = new Map<Id, Map<String, Integer>>();
        Integer totalSIMVendu = 0;
        Integer totalSIMDealerVendu = 0;
        Integer totalSCVendu = 0;
        
        for (RetailVisitKpi assessment : assessments) {
            Map<String, Integer> salesValues = subordinateSalesValues.get(assessment.Visit.VisitorId);
            if (salesValues == null) {
                salesValues = new Map<String, Integer>{
                    'SIMVendu' => 0,
                    'SIMDealerVendu' => 0,
                    'SCVendu' => 0
                };
            }
            
            if (assessment.AssessmentIndDefinition.Name == 'Nombre de carte SIM vendu') {
                salesValues.put('SIMVendu', salesValues.get('SIMVendu') + assessment.ActualIntegerValue);
                totalSIMVendu += assessment.ActualIntegerValue;
            } else if (assessment.AssessmentIndDefinition.Name == 'Nombre de carte SIM Dealer vendu') {
                salesValues.put('SIMDealerVendu', salesValues.get('SIMDealerVendu') + assessment.ActualIntegerValue);
                totalSIMDealerVendu += assessment.ActualIntegerValue;
            } else if (assessment.AssessmentIndDefinition.Name == 'Nombre de SC vendu') {
                salesValues.put('SCVendu', salesValues.get('SCVendu') + assessment.ActualIntegerValue);
                totalSCVendu += assessment.ActualIntegerValue;
            }
            
            subordinateSalesValues.put(assessment.Visit.VisitorId, salesValues);
        }
        
        response.put('SIMVendu', totalSIMVendu);
        response.put('SIMDealerVendu', totalSIMDealerVendu);
        response.put('SCVendu', totalSCVendu);
        response.put('SubordinateSalesValues', subordinateSalesValues);
        
        return response;
    }
    
    
private static List<Id> findAllLastDemandesDeVisite(Id parentDemandeId) {
    List<Id> allLastDemandesIds = new List<Id>();
    Set<Id> subordinateUserIds = getAllSubordinateIds(UserInfo.getUserId());
    List<Id> currentLevelIds = new List<Id>{parentDemandeId};
    
    while (!currentLevelIds.isEmpty()) {
        List<inwiCGC_DemandeDeVisite__c> childDemandes = [
            SELECT Id, OwnerId, Parent__c
            FROM inwiCGC_DemandeDeVisite__c
            WHERE Parent__c IN :currentLevelIds
            AND OwnerId IN :subordinateUserIds
        ];
        
        if (childDemandes.isEmpty()) {
            allLastDemandesIds.addAll(currentLevelIds);
            break;
        } else {
            currentLevelIds.clear();
            for (inwiCGC_DemandeDeVisite__c child : childDemandes) {
                currentLevelIds.add(child.Id);
            }
        }
    }
    
    return allLastDemandesIds;
}

    
    
    
    

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

    private static void getSubordinatesRecursively(Id managerId, Set<Id> subordinateIds) {
        List<User> subordinates = [SELECT Id FROM User WHERE ManagerId = :managerId];
        for (User subordinate : subordinates) {
            subordinateIds.add(subordinate.Id);
            getSubordinatesRecursively(subordinate.Id, subordinateIds);
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<WrapperDemandeDeVisite> getDemandesDeVisite() {
        String currentUserId = UserInfo.getUserId();

        List<inwiCGC_DemandeDeVisite__c> userDemandes = [
            SELECT Id, Name, Owner.Name 
            FROM inwiCGC_DemandeDeVisite__c 
            WHERE OwnerId = :currentUserId
        ];

        List<WrapperDemandeDeVisite> wrappedDemandes = new List<WrapperDemandeDeVisite>();
        for (inwiCGC_DemandeDeVisite__c demande : userDemandes) {
            wrappedDemandes.add(new WrapperDemandeDeVisite(demande.Id, demande.Name, demande.Owner.Name));
        }

        return wrappedDemandes;
    }

    public class WrapperDemandeDeVisite {
        @AuraEnabled public Id Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String OwnerName;
        
        public WrapperDemandeDeVisite(Id id, String name, String ownerName) {
            this.Id = id;
            this.Name = name;
            this.OwnerName = ownerName;
        }
    }
}