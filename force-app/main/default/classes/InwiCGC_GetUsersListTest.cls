@isTest
public class InwiCGC_GetUsersListTest {
    @isTest
    static void getUsersTest(){
        Schema.Location locationTest = new Schema.Location();
        locationTest.Name='locationTest';
        insert locationTest;
        
        Account parentAccount = new Account(Name='Test Account');
        insert parentAccount;

        
        Schema.Address addressTest = new Schema.Address();
        addressTest.ParentId = locationTest.Id;
        insert addressTest;
        
        Profile profilTest = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User userTest = new User(Alias = 'test', Email='test@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profilTest.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testgetUserList@testorg.com');
        insert userTest;
        
        Visit visitTest = new Visit(
            PlannedVisitStartTime=DateTime.now(),
            PlaceId=addressTest.Id,
            VisitorId=userTest.Id
        );
        insert visitTest;
        InwiCGC_GetUsersList.getUsers(visitTest.Id);
    }
    
    @isTest
    static void getCloseRetailStores(){
        Account AccountTest = new Account(Name='Test Account');
        insert AccountTest;
        Schema.RetailStore retailStoreTest = new Schema.RetailStore(Name='Retail Store Test',inwiCGC_TypeActivite__c='BT',AccountId=AccountTest.Id);
        retailStoreTest.City='Casablanca';
        retailStoreTest.country='Morocco';
        retailStoreTest.geocodeAccuracy='Block';
        retailStoreTest.latitude=33.559574722025225;
        retailStoreTest.longitude=-7.539961110579985;
        retailStoreTest.postalCode='20250';
        retailStoreTest.state='state';
        retailStoreTest.street='1 Boulevard Moulay Rachid';
        insert retailStoreTest;
        InwiCGC_GetUsersList.getCloseRetailStores(retailStoreTest.latitude,retailStoreTest.longitude);
    }

	@isTest
    static void getProfileTest(){
        Profile testProfile = [SELECT Id FROM Profile WHERE Name='CGC_User' LIMIT 1];
        User userTest = new User(Alias = 'test', Email='test@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = testProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testgetProfile@testorg.com');
        insert userTest;
        
        Test.startTest();
        String profileName = InwiCGC_GetUsersList.getProfile();
        Test.stopTest();
       }
    
    @isTest
    static void getVisitStatusTest(){
        Account parentAccount = new Account(Name='Visit Account');
        
        Contact contact=new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Test';
        insert contact;
        
        Account account=new Account();
        account.Name = 'Test' ;
        account.vlocity_cmt__PrimaryContactId__c= contact.Id;
        insert account ;
        
        Schema.RetailStore store = new Schema.RetailStore(
            Name='Test Store',
            inwiCGC_Region_AC__c='CA',
            inwiCGC_Flag__c='RTMU',
            inwiCGC_VilleAM__c='LISASFA',
            AccountId = account.Id
        );
        insert store;
        
		Profile p = [SELECT Id FROM Profile WHERE Name='CGC_RVR' LIMIT 1];
        User u = new User(
            Alias = 'aze12',
            Email = 'aze12@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'aze12Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName = 'aze12@test.com'
        );
        insert u;

        Visit v1 = new Visit(
            PlannedVisitStartTime = DateTime.now(),
            VisitorId = u.Id,
            AccountId = parentAccount.Id,
            Status = 'Completed',
            PlaceId = store.Id
        );
        insert v1;
        
        Test.startTest();
        String profileName = InwiCGC_GetUsersList.getVisitStatus(v1.Id);
        Test.stopTest();
    }

    @isTest
    static void checkManagerProfileAndRoleTest(){
        Profile testProfile = [SELECT Id FROM Profile WHERE Name='CGC_User' LIMIT 1];
        UserRole testRole = [SELECT Id FROM UserRole WHERE Name='Casa 1' LIMIT 1];
        
        
        User managerUser = new User(Alias = 'manager', Email='manager@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Manager', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = testProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='manager@testorg.com');
        insert managerUser;
        
        User userTest = new User(Alias = 'test', Email='test@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = testProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testcheckManager@testorg.com',
            ManagerId = managerUser.Id);
        insert userTest;
        
        Test.startTest();
        Boolean isManagerProfileAndRole = InwiCGC_GetUsersList.checkManagerProfileAndRole();
        Test.stopTest();
    }
}