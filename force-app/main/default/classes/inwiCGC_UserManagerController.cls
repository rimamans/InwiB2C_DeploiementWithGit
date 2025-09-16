public with sharing class inwiCGC_UserManagerController {
    @AuraEnabled(cacheable=true)
    public static List<User> getManagedUsers(Id currentUserId) {
        return [SELECT Id, Name, Profile.Name, ManagerId 
                FROM User 
                WHERE ManagerId = :currentUserId];
    }

    @AuraEnabled
    public static Map<String, Object> getSubordinateIdsAndAssessments(Id userId) {
        Map<String, Object> response = new Map<String, Object>();
        Set<Id> allSubordinateIds = new Set<Id>();


        List<User> currentUser = [SELECT Id, Name, Profile.Name FROM User WHERE Id = :userId];

        if (currentUser[0].Profile.Name == 'CGC_User') {
            allSubordinateIds.add(userId);
        } else {
            List<User> level1Subordinates = [SELECT Id, Name, Profile.Name FROM User WHERE ManagerId = :userId];
    
            for (User user : level1Subordinates) {
                if (user.Profile.Name == 'CGC_FDV_Manager') {
                    while (user.Profile.Name == 'CGC_FDV_Manager') {
                        allSubordinateIds.add(user.Id);
                        
                        List<User> fdvManagerSubordinates = [SELECT Id, Name, Profile.Name FROM User WHERE ManagerId = :user.Id];
                        
                        if (fdvManagerSubordinates.isEmpty()) {
                            break;
                        }
                        
                        user = fdvManagerSubordinates[0];
                        
                        for (User fdvSub : fdvManagerSubordinates) {
                            allSubordinateIds.add(fdvSub.Id);
                            if (fdvSub.Profile.Name == 'CGC_RVR') {
                            allSubordinateIds.add(fdvSub.Id);
    
                            List<User> level2Subordinates = [SELECT Id, Name, Profile.Name FROM User WHERE ManagerId = :fdvSub.Id];
                            for (User sub : level2Subordinates) {
                                allSubordinateIds.add(sub.Id);
    
                                if (sub.Profile.Name == 'CGC_User') {
                                    List<User> level3Subordinates = [SELECT Id FROM User WHERE ManagerId = :sub.Id];
                                    for (User subSub : level3Subordinates) {
                                        allSubordinateIds.add(subSub.Id);
    
                                        List<User> level4Subordinates = [SELECT Id FROM User WHERE ManagerId = :subSub.Id];
                                        for (User subUser : level4Subordinates) {
                                            allSubordinateIds.add(subUser.Id);
                                        }
                                    }
                                }
                            }
                        }
                        }
                    }}
    
                        
                    else if (user.Profile.Name == 'CGC_RVR') {
                    allSubordinateIds.add(user.Id);
    
                    List<User> level2Subordinates = [SELECT Id, Name, Profile.Name FROM User WHERE ManagerId = :user.Id];
                    for (User sub : level2Subordinates) {
                        allSubordinateIds.add(sub.Id);
    
                        if (sub.Profile.Name == 'CGC_User') {
                            List<User> level3Subordinates = [SELECT Id FROM User WHERE ManagerId = :sub.Id];
                            for (User subSub : level3Subordinates) {
                                allSubordinateIds.add(subSub.Id);
    
                                List<User> level4Subordinates = [SELECT Id FROM User WHERE ManagerId = :subSub.Id];
                                for (User subUser : level4Subordinates) {
                                    allSubordinateIds.add(subUser.Id);
                                }
                            }
                        }
                    }
                } else if (user.Profile.Name == 'CGC_User') {
                    allSubordinateIds.add(user.Id);
    
                    List<User> level2SubordinatesForUser = [SELECT Id FROM User WHERE ManagerId = :user.Id];
                    for (User subUser : level2SubordinatesForUser) {
                        allSubordinateIds.add(subUser.Id);
                    }
                }
            }
        }
        

        

        System.debug('Subordinate IDs: ' + allSubordinateIds);

        List<Visit> visits = [SELECT Id FROM Visit WHERE VisitorId IN :allSubordinateIds AND Status = 'Completed'];
        List<Id> visitIds = new List<Id>();
        for (Visit visit : visits) {
            visitIds.add(visit.Id);
        }

        System.debug('Visit IDs: ' + visitIds);

        List<RetailVisitKpi> assessments = [SELECT ActualIntegerValue, AssessmentIndDefinition.Name, Visit.VisitorId 
                                            FROM RetailVisitKpi 
                                            WHERE VisitId IN :visitIds];

        System.debug('Assessments: ' + assessments);

        Integer totalSIMVendu = 0;
        Integer totalSIMDealerVendu = 0;
        Integer totalSCVendu = 0;

        for (RetailVisitKpi assessment : assessments) {
            if (assessment.AssessmentIndDefinition.Name == 'Nombre de carte SIM vendu') {
                totalSIMVendu += assessment.ActualIntegerValue;
            } else if (assessment.AssessmentIndDefinition.Name == 'Nombre de carte SIM Dealer vendu') {
                totalSIMDealerVendu += assessment.ActualIntegerValue;
            } else if (assessment.AssessmentIndDefinition.Name == 'Nombre de SC vendu') {
                totalSCVendu += assessment.ActualIntegerValue;
            }
        }

        System.debug('Total SIM Vendu: ' + totalSIMVendu);
        System.debug('Total SIM Dealer Vendu: ' + totalSIMDealerVendu);
        System.debug('Total SC Vendu: ' + totalSCVendu);

        response.put('SIMVendu', totalSIMVendu);
        response.put('SIMDealerVendu', totalSIMDealerVendu);
        response.put('SCVendu', totalSCVendu);

        return response;
    }

}