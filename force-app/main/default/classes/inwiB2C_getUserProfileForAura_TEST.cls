@isTest
public with sharing class inwiB2C_getUserProfileForAura_TEST {

    @isTest(SeeAllData=true)
    public static void testingGetUserProfileForAura() {
        inwiB2C_getUserProfileForAura.fetchUserProfile();
    }
}