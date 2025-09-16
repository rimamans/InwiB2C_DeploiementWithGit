public with sharing class InwiCGC_AssignUser {
    @AuraEnabled
    public static void assignVisitForUsers(String recordId, String selectedUserId){
        Visit visitToUpdate = [SELECT Id FROM Visit WHERE Id = :recordId LIMIT 1];
        visitToUpdate.VisitorId = selectedUserId;
        visitToUpdate.OwnerId = selectedUserId;
        update visitToUpdate;
    }
}