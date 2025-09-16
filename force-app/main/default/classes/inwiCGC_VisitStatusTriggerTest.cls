@isTest
public class inwiCGC_VisitStatusTriggerTest {
    @isTest
    static void testVisitStatusHandler() {
        // Setup test data
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Create a test user
        User testUser = new User(
            Alias = 'tuser',
            Email = 'testsqduser@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testusqdqsser@test.com'
        );
        insert testUser;
        
        Schema.Location locationTest = new Schema.Location();
        locationTest.Name = 'locationTest';
        insert locationTest;

        Schema.Address addressTest = new Schema.Address();
        addressTest.ParentId = locationTest.Id;
        insert addressTest;

        // Create Visits
        
        
        Account acc = new Account(Name='Parent Account Test');
        insert acc;
        Schema.RetailStore store = new Schema.RetailStore(
            Name='Test Store',
            inwiCGC_Region_AC__c='CA',
            inwiCGC_Flag__c='RTMU',
            inwiCGC_VilleAM__c='LISASFA',
            AccountId = acc.Id
        );
        insert store;
        
        
        Visit PrentplannedVisit = new Visit(
            Status = 'Planned',
            PlaceId = store.Id,
            VisitorId = testUser.Id,
            PlannedVisitStartTime = DateTime.now(),
            OwnerId = testUser.Id
        );
        insert PrentplannedVisit;
        
        Visit plannedVisit = new Visit(
            Status = 'Planned',
            PlaceId = store.Id,
            VisitorId = testUser.Id,
            PlannedVisitStartTime = DateTime.now(),
            OwnerId = testUser.Id,
            inwiCGC_ParentVisitId__c = PrentplannedVisit.Id 
        );
        insert plannedVisit;

        //Schema.Address addressTestRS = new Schema.Address();
        //addressTestRS.ParentId = store.Id;
        //insert addressTestRS;

        Visit inProgressVisit = new Visit(
            Status = 'InProgress',
            PlaceId = store.Id,
            VisitorId = testUser.Id,
            PlannedVisitStartTime = DateTime.now(),
            OwnerId = testUser.Id,
            inwiCGC_ParentVisitId__c = plannedVisit.Id
        );
        insert inProgressVisit;
        
        AssessmentTask assessmentTask = new AssessmentTask();
            assessmentTask.ParentId = plannedVisit.Id;
            assessmentTask.Name = 'Evaluation VI Terrain';
            assessmentTask.TaskType = 'InventoryCheck';
            insert assessmentTask;

        // Create RetailVisitKpi
        AssessmentIndicatorDefinition simDef = new AssessmentIndicatorDefinition(Name = 'Nombre de carte SIM vendu');
        insert simDef;
        
        AssessmentIndicatorDefinition simDDef = new AssessmentIndicatorDefinition(Name = 'Nombre de carte SIM Dealer vendu');
        insert simDDef;
        
        AssessmentIndicatorDefinition scDef = new AssessmentIndicatorDefinition(Name = 'Nombre de SC vendu');
        insert scDef;

        RetailVisitKpi incompleteKpi = new RetailVisitKpi(
            VisitId = plannedVisit.Id,
            AssessmentIndDefinitionId = simDef.Id,
            ActualIntegerValue = null,
            AssessmentTaskId = assessmentTask.Id
        );
        insert incompleteKpi;

        RetailVisitKpi completeKpi = new RetailVisitKpi(
            VisitId = inProgressVisit.Id,
            AssessmentIndDefinitionId = simDef.Id,
            ActualIntegerValue = 10,
            AssessmentTaskId = assessmentTask.Id
        );
        insert completeKpi;
        
        RetailVisitKpi completeKpi3 = new RetailVisitKpi(
            VisitId = inProgressVisit.Id,
            AssessmentIndDefinitionId = simDDef.Id,
            ActualIntegerValue = 10,
            AssessmentTaskId = assessmentTask.Id
        );
        insert completeKpi3;
        
        RetailVisitKpi completeKpi4 = new RetailVisitKpi(
            VisitId = inProgressVisit.Id,
            AssessmentIndDefinitionId = scDef.Id,
            ActualIntegerValue = 10,
            AssessmentTaskId = assessmentTask.Id
        );
        insert completeKpi4;

        // Run tests
        Test.startTest();

        // Update visit to trigger validation logic
        inProgressVisit.Status = 'Completed';
        update inProgressVisit;
        // Test valid completion
        plannedVisit.Status = 'Completed';
        update plannedVisit;

        // Test missing RetailStoreId validation
        Visit invalidVisit = new Visit(
            PlannedVisitStartTime = DateTime.now(),
            Status = 'Planned',
            VisitorId = testUser.Id,
            PlaceId = addressTest.Id,
            OwnerId = testUser.Id,
            inwiCGC_ParentVisitId__c = null
        );
        insert invalidVisit;

        invalidVisit.Status = 'InProgress';
        try {
            update invalidVisit;
            System.assert(false, 'Expected an exception for missing RetailStoreId.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Vous devez sélectionner un magasin de détail avant de pouvoir exécuter une visite.'));
        }

        Test.stopTest();
    }
}