@isTest
public class InwiCGC_CloneVisitTest {
    @isTest
    static void cloneVisitForUsers(){
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
        
        User userTest1 = new User(Alias = 'test1', Email='test1@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = profilTest.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='testgetUserList1@testorg.com');
        insert userTest1;
        
        User userTest2 = new User(Alias = 'test2', Email='test2@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = profilTest.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='testgetUserList2@testorg.com');
        insert userTest2;
        
        List<String> selectedUserIds = new List<String>{userTest1.Id, userTest2.Id};
            Test.startTest();
        InwiCGC_CloneVisit.cloneVisitForUsers(visitTest.Id, selectedUserIds);
        Test.stopTest();
    }
    
    @isTest
    static void cloneVisitAndAssignRetailStore() {
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
        
        Account AccountTest = new Account(Name='Test Account');
        insert AccountTest;
        
        Schema.RetailStore retailStoreTest = new Schema.RetailStore(Name='Retail Store Test', inwiCGC_TypeActivite__c='BT', AccountId=AccountTest.Id);
        retailStoreTest.City='Casablanca';
        retailStoreTest.country='Morocco';
        retailStoreTest.geocodeAccuracy='Block';
        retailStoreTest.latitude=33.559574722025225;
        retailStoreTest.longitude=-7.539961110579985;
        retailStoreTest.postalCode='20250';
        retailStoreTest.state='state';
        retailStoreTest.street='1 Boulevard Moulay Rachid';
        retailStoreTest.InwiCGC_IdRVR__c = userTest.Id;
        insert retailStoreTest;
        
        ActionPlan actionPlan = new ActionPlan();
        actionPlan.TargetId = visitTest.Id;
        actionPlan.Name = 'Modèle VI Terrain';
        actionPlan.ActionPlanTemplateVersionId = templateVersion.Id;
        actionPlan.ActionPlanType = 'Retail';
        actionPlan.StartDate = DateTime.now().date();
        insert actionPlan;
        
        Test.startTest();
        InwiCGC_CloneVisit.cloneVisitAndAssignRetailStore(visitTest.Id, retailStoreTest.Id);
        Test.stopTest();
    }
}