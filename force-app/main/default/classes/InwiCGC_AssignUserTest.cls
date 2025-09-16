@isTest
public class InwiCGC_AssignUserTest {
    @isTest
    static void testAssignVisitForUsers() {

        Schema.Location locationTest = new Schema.Location();
        locationTest.Name='locationTest';
        insert locationTest;
        
        Account parentAccount = new Account(Name='Test Account');
        insert parentAccount;
        
        Schema.Address addressTest = new Schema.Address();
        addressTest.ParentId = locationTest.Id;
        insert addressTest;
        
        Profile profilTest = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User userTest = new User(Alias = 'test',
                                 Email='test@testorg.com',
                                 EmailEncodingKey='UTF-8',
                                 LastName='Testing',
                                 LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US',
                                 ProfileId = profilTest.Id,
                                 TimeZoneSidKey='America/Los_Angeles',
                                 UserName='testgetUserList@inwib2c.fdv.com');
        insert userTest;
        
        User newUser = new User(Alias = 'newUser',
                                Email='newUser@test.com',
                                EmailEncodingKey='UTF-8',
                                LastName='NewUser',
                                LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US',
                                ProfileId = profilTest.Id,
                                TimeZoneSidKey='America/Los_Angeles',
                                UserName='newUser@inwib2c.fdv.com');
        insert newUser;
        
        Visit visitTest = new Visit(
            PlannedVisitStartTime=DateTime.now(),
            PlaceId=addressTest.Id,
            VisitorId=userTest.Id
        );
        
        insert visitTest;
        Test.startTest();
        InwiCGC_AssignUser.assignVisitForUsers(visitTest.Id, newUser.Id);
        Test.stopTest();
    }
}