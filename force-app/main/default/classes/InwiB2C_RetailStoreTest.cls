@isTest
public class InwiB2C_RetailStoreTest {
    @isTest
    static void InwiB2C_RetailStoreTest(){
        Test.startTest(); 
        Contact contact=new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Test';
        insert contact;
        
        Account account=new Account();
        account.Name = 'Test' ;
        account.vlocity_cmt__PrimaryContactId__c= contact.Id;
        insert account ;
        
        Schema.RetailStore RS = new  Schema.RetailStore();
        RS.Name='Name';
        RS.PrimaryContactId=contact.Id;
        RS.AccountId=account.Id;
        insert RS;
        
        Profile profilTest = [SELECT Id FROM Profile WHERE Name = 'CGC_RVR']; 
        User userTest = new User(
            Alias = 'test', 
            Email = 'test@testorg.com', 
            EmailEncodingKey = 'UTF-8', 
            LastName = 'Testing', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', 
            ProfileId = profilTest.Id, 
            TimeZoneSidKey = 'America/Los_Angeles', 
            UserName = 'testgetUserList@testorg.com'
        );
        insert userTest;
        
        InwiB2C_RetailStore.RetailStoreRecord('firstName', 'lastName', 'Name', 'BT', '33.57856', '-7.63988', '1234567891', '1234567891', 'Grossiste', false, '0611223322', '0611223311', userTest.Id, 'CA', 'RTMU', 'LISASFA', true, true, null, 'sahatel', null);
		InwiB2C_RetailStore.GetRetailStoreInformations(RS.Id);
    }
    
    @isTest
    static void cloneVisitAndAssignNewRetailStore(){
        Schema.Location locationTest = new Schema.Location();
        locationTest.Name = 'locationTest';
        insert locationTest;
        
        Account parentAccount = new Account(Name = 'Test Account');
        insert parentAccount;
        
        Schema.Address addressTest = new Schema.Address();
        addressTest.ParentId = locationTest.Id;
        insert addressTest;
        
        Profile profilTest = [SELECT Id FROM Profile WHERE Name = 'Standard User']; 
        User userTest = new User(
            Alias = 'test', 
            Email = 'test@testorg.com', 
            EmailEncodingKey = 'UTF-8', 
            LastName = 'Testing', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', 
            ProfileId = profilTest.Id, 
            TimeZoneSidKey = 'America/Los_Angeles', 
            UserName = 'testgetUserList@testorg.com'
        );
        insert userTest;
        
        Visit visitTest = new Visit(
            PlannedVisitStartTime = DateTime.now(),
            PlaceId = addressTest.Id,
            VisitorId = userTest.Id
        );
        insert visitTest;
        
        AssessmentTask assessmentTask = new AssessmentTask();
        assessmentTask.ParentId = visitTest.Id;
        assessmentTask.Name = 'Evaluation VI Terrain';
        assessmentTask.TaskType = 'InventoryCheck';
        insert assessmentTask;
        
        ActionPlanTemplate plantemplate = new ActionPlanTemplate();
        plantemplate.TargetEntityType = 'Visit';
        plantemplate.UniqueName = 'Mod_le_VI_Terrain_0c45a20d_ba1a_11ee_aeac_d9c21f7bd413';
        plantemplate.ActionPlanType = 'Retail';        
        plantemplate.Name = 'Modèle VI Terrain';
        insert plantemplate;
        
        ActionPlanTemplateVersion templateVersion = new ActionPlanTemplateVersion();
        templateVersion.ActionPlanTemplateId = plantemplate.Id;
        templateVersion.Name = 'Modèle VI Terrain';
        templateVersion.Status = 'Final';
        insert templateVersion;
        
        ActionPlan actionPlan = new ActionPlan();
        actionPlan.TargetId = visitTest.Id;
        actionPlan.Name = 'Modèle VI Terrain';
        actionPlan.ActionPlanTemplateVersionId = templateVersion.Id;
        actionPlan.ActionPlanType = 'Retail';
        actionPlan.StartDate = DateTime.now().date();
        insert actionPlan;
        
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
        
        Test.startTest();
        InwiB2C_RetailStore.cloneVisitAndAssignNewRetailStore(visitTest.Id, retailStoreTest.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testGetRVRName() {
        Profile rvrProfile = [SELECT Id FROM Profile WHERE Name = 'CGC_RVR' LIMIT 1];
        User rvrUser = new User(
            Alias = 'rvrtest', 
            Email = 'rvr@test.com', 
            EmailEncodingKey = 'UTF-8', 
            LastName = 'RVRUser', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', 
            ProfileId = rvrProfile.Id, 
            TimeZoneSidKey = 'America/Los_Angeles', 
            UserName = 'rvr@test.com'
        );
        insert rvrUser;

        Test.startTest();
        String rvrName = InwiB2C_RetailStore.getRVRName();
        Test.stopTest();
    }

    @isTest
    static void testGetRegions() {
        inwiCGC_RegionAM__c region = new inwiCGC_RegionAM__c(Name = 'CA');
        insert region;

        Test.startTest();
        List<inwiCGC_RegionAM__c> regions = InwiB2C_RetailStore.getRegions();
        Test.stopTest();

        System.assert(regions.size() > 0);
    }

    @isTest
    static void testGetLocalisationsByRegion() {
        inwiCGC_RegionAM__c region = new inwiCGC_RegionAM__c(Name = 'CA', inwiCGC_Flag__c = 'RTMU');
        insert region;

        Test.startTest();
        List<String> localisations = InwiB2C_RetailStore.getLocalisationsByRegion('CA');
        Test.stopTest();

        System.assert(localisations.contains('RTMU'));
    }

    @isTest
    static void testGetCircuitsByLocalisation() {
        inwiCGC_RegionAM__c region = new inwiCGC_RegionAM__c(Name = 'CA', inwiCGC_Flag__c = 'RTMU', inwiCGC_CircuitAM__c = 'LISASFA');
        insert region;

        Test.startTest();
        List<Map<String, String>> circuits = InwiB2C_RetailStore.getCircuitsByLocalisation('RTMU', 'CA');
        Test.stopTest();

        System.assert(circuits.size() > 0);
    }
}