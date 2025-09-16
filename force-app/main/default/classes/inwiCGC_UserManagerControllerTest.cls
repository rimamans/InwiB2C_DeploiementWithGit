@isTest(SeeAllData=true)
public class inwiCGC_UserManagerControllerTest {
    @isTest
    static void testUserManagerController() {
        // Fetch Profiles
        Profile fdvManagerProfile = [SELECT Id FROM Profile WHERE Name = 'CGC_FDV_Manager' LIMIT 1];
        Profile rvrProfile = [SELECT Id FROM Profile WHERE Name = 'CGC_RVR' LIMIT 1];
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'CGC_User' LIMIT 1];
        
        User topFDVManager = new User(
            Alias = 'fdvmgr',
            Email = 'fdvmgr@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'FDVManager',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = fdvManagerProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'fdvmgr@testorg.com'
        );
        insert topFDVManager;
        
        User subFDVManager1 = new User(
            Alias = 'fdvsub1',
            Email = 'fdvsub1@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'FDVManagerSub1',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = fdvManagerProfile.Id,
            ManagerId = topFDVManager.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'fdvsub1@testorg.com'
        );
        User subFDVManager2 = new User(
            Alias = 'fdvsub2',
            Email = 'fdvsub2@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'FDVManagerSub2',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = fdvManagerProfile.Id,
            ManagerId = topFDVManager.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'fdvsub2@testorg.com'
        );
        insert new List<User>{subFDVManager1, subFDVManager2};
            
            User rvrUser1 = new User(
                Alias = 'rvrusr1',
                Email = 'rvrusr1@testorg.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'RVRUser1',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = rvrProfile.Id,
                ManagerId = subFDVManager1.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'rvrusr1@testorg.com'
            );
        User rvrUser2 = new User(
            Alias = 'rvrusr2',
            Email = 'rvrusr2@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'RVRUser2',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = rvrProfile.Id,
            ManagerId = subFDVManager2.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'rvrusr2@testorg.com'
        );
        insert new List<User>{rvrUser1, rvrUser2};
            
            User cgcUser1 = new User(
                Alias = 'cgcusr1',
                Email = 'cgcusr1@testorg.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'CGCUser1',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = userProfile.Id,
                ManagerId = rvrUser1.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'cgcusr1@testorg.com'
            );
        User cgcUser2 = new User(
            Alias = 'cgcusr2',
            Email = 'cgcusr2@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'CGCUser2',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = userProfile.Id,
            ManagerId = rvrUser2.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'cgcusr2@testorg.com'
        );
        insert new List<User>{cgcUser1, cgcUser2};
            
            User cgcUser3 = new User(
                Alias = 'cgcusr3',
                Email = 'cgcusr3@testorg.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'CGCUser3',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = userProfile.Id,
                ManagerId = cgcUser1.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'cgcusr3@testorg.com'
            );
        insert cgcUser3;
        
        Schema.Location locationTest = new Schema.Location();
        locationTest.Name = 'locationTest';
        insert locationTest;
        
        Schema.Address addressTest = new Schema.Address();
        addressTest.ParentId = locationTest.Id;
        insert addressTest;
        
        
        Schema.AssessmentIndicatorDefinition assIndDef1 = new Schema.AssessmentIndicatorDefinition();
        assIndDef1.Name = 'Nombre de carte SIM vendu';
        assIndDef1.DataType = 'Number';
        assIndDef1.Description = 'Nombre de carte SIM vendu';
        insert assIndDef1;
        Id simVenduDefId =  assIndDef1.id;
        
        Schema.AssessmentIndicatorDefinition assIndDef2 = new Schema.AssessmentIndicatorDefinition();
        assIndDef2.Name = 'Nombre de carte SIM Dealer vendu';
        assIndDef2.DataType = 'Number';
        assIndDef2.Description = 'Nombre de carte SIM Dealer vendu';        
        insert assIndDef2;
        Id simDealerVenduDefId =  assIndDef2.id;
        
        Schema.AssessmentIndicatorDefinition assIndDef3 = new Schema.AssessmentIndicatorDefinition();
        assIndDef3.Name = 'Nombre de SC vendu';
        assIndDef3.DataType = 'Number';
        assIndDef3.Description = 'Nombre de SC vendu';   
        insert assIndDef3;
        Id scVenduDefId =  assIndDef3.id;
        
        //Id simVenduDefId = [SELECT Id FROM AssessmentIndicatorDefinition WHERE Name = 'Nombre de carte SIM vendu' LIMIT 1].Id;
        //Id simDealerVenduDefId = [SELECT Id FROM AssessmentIndicatorDefinition WHERE Name = 'Nombre de carte SIM Dealer vendu' LIMIT 1].Id;
        //Id scVenduDefId = [SELECT Id FROM AssessmentIndicatorDefinition WHERE Name = 'Nombre de SC vendu' LIMIT 1].Id;
        
        Test.startTest();
        
        for (User user : new List<User>{rvrUser1, rvrUser2, cgcUser1, cgcUser2, cgcUser3}) {
            Visit visit = new Visit(
                PlannedVisitStartTime = DateTime.now(),
                VisitorId = user.Id,
                PlaceId = addressTest.Id,
                Status = 'InProgress'
            );
            insert visit;
            
            AssessmentTask assessmentTask = new AssessmentTask();
            assessmentTask.ParentId = visit.Id;
            assessmentTask.Name = 'Evaluation VI Terrain';
            assessmentTask.TaskType = 'InventoryCheck';
            insert assessmentTask;
            
            RetailVisitKpi simVenduKpi = new RetailVisitKpi(
                VisitId = visit.Id,
                ActualIntegerValue = 5,
                AssessmentIndDefinitionId = simVenduDefId,
                AssessmentTaskId = assessmentTask.Id
            );
            insert simVenduKpi;
            
            RetailVisitKpi simDealerVenduKpi = new RetailVisitKpi(
                VisitId = visit.Id,
                ActualIntegerValue = 3,
                AssessmentIndDefinitionId = simDealerVenduDefId,
                AssessmentTaskId = assessmentTask.Id
            );
            insert simDealerVenduKpi;
            
            RetailVisitKpi scVenduKpi = new RetailVisitKpi(
                VisitId = visit.Id,
                ActualIntegerValue = 10,
                AssessmentIndDefinitionId = scVenduDefId,
                AssessmentTaskId = assessmentTask.Id
            );
            insert scVenduKpi;
        }
        
        inwiCGC_UserManagerController.getSubordinateIdsAndAssessments(topFDVManager.Id);
        inwiCGC_UserManagerController.getSubordinateIdsAndAssessments(subFDVManager1.Id);
        inwiCGC_UserManagerController.getSubordinateIdsAndAssessments(rvrUser1.Id);
        inwiCGC_UserManagerController.getSubordinateIdsAndAssessments(cgcUser1.Id);
        inwiCGC_UserManagerController.getSubordinateIdsAndAssessments(cgcUser3.Id);
        
        inwiCGC_UserManagerController.getManagedUsers(topFDVManager.Id);
        inwiCGC_UserManagerController.getManagedUsers(subFDVManager1.Id);
        inwiCGC_UserManagerController.getManagedUsers(rvrUser1.Id);
        inwiCGC_UserManagerController.getManagedUsers(cgcUser1.Id);
        inwiCGC_UserManagerController.getManagedUsers(cgcUser3.Id);
        
        Test.stopTest();
    }
}