global class inwiB2C_getUserProfileForAura {
    @AuraEnabled
    public static Profile fetchUserProfile() {
        //User u = [select id,Name from User where id =: userInfo.getUserId()];
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:UserInfo.getProfileId()];
        return profile;
    }
}