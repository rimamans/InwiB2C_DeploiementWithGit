public with sharing class InwiCGC_GetUsersList {
    @AuraEnabled(cacheable=true)
    public static List<User> getUsers(String recordId) {
        // Visit visitRecord = [SELECT VisitorId FROM Visit WHERE Id = :recordId LIMIT 1];
        // if (String.valueOf(visitRecord.VisitorId).length() != 18) {
        //     return new List<User>();
        // }
        String currentUserId = UserInfo.getUserId();
        return [SELECT Id, Name FROM User WHERE ManagerId = :currentUserId AND IsActive = true];
    }

    /*@AuraEnabled(cacheable=true)
    public static List<RetailStore> getAdresses(Decimal longitude, Decimal latitude) {
       // List<RetailStore> stores = [SELECT id, Name, Address, inwiCGC_TypeActivite__c, DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') FROM RetailStore WHERE DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') < 50 ORDER BY DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') asc LIMIT 10];
        List<RetailStore> retailStores = [SELECT id, Name, inwiCGC_TypeActivite__c FROM RetailStore   LIMIT 10];
        return retailStores;
    }*/

    @AuraEnabled(cacheable=true)
    public static List<Schema.RetailStore> getCloseRetailStores(Decimal latitude, Decimal longitude) {
        List<Schema.RetailStore> retaiStoreList = [SELECT id, Name, Address, inwiCGC_TypeActivite__c, inwiCGC_Status__c, DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') FROM RetailStore WHERE DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') < 0.2 AND inwiCGC_Status__c = 'inwiCGC_Accepte' ORDER BY DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') asc LIMIT 10];

        System.debug( JSON.serialize(retaiStoreList));
        return retaiStoreList;
    }

    @AuraEnabled(cacheable = true)
    public static string getProfile(){
        Id profileId = UserInfo.getProfileId();
        String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
        system.debug('Profile Name'+profileName);

        return profileName;
    }

    @AuraEnabled(cacheable = true)
    public static string getVisitStatus(String visitId){
        String visitStatus = [SELECT Id, Status From Visit Where Id = :VisitId].Status;
        
        return visitStatus;
    }

    

    @AuraEnabled(cacheable = true)
    public static Boolean checkManagerProfileAndRole() {
        String currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT ManagerId FROM User WHERE Id = :currentUserId LIMIT 1];

        if (currentUser.ManagerId != null) {
            User managerUser = [SELECT Profile.Name, UserRole.Name FROM User WHERE Id = :currentUser.ManagerId LIMIT 1];
            if (managerUser.Profile.Name == 'CGC_User' && managerUser.UserRole.Name == 'Casa 1') {
                return true;
            }
        }
        return false;
    }


}