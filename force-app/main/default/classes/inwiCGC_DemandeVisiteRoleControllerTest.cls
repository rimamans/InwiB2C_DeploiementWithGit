@isTest
public class inwiCGC_DemandeVisiteRoleControllerTest {
    
    @TestSetup
    static void setupTestData() {
        
        // Query Profile
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%CGC_FDV_Manager%'];
        
        // Create Root Role
        UserRole rootRole = new UserRole(Name = 'TestRole');
        insert rootRole;

        // Create Subordinate Role
        UserRole subordinateRole = new UserRole(Name = 'SubordinateRole', ParentRoleId = rootRole.Id);
        insert subordinateRole;
        
        // Create Unassigned Role
        UserRole subordinateRole2 = new UserRole(Name = 'SubordinateRole2', ParentRoleId = rootRole.Id);
        insert subordinateRole2;

        // Create Test User with Root Role
        User testUserRootRole = new User(
            Alias = 'Alias1',
            Email = 'test@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestUser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'test@inwiCGC_DemandeVisiteRoleControllerTest.com',
            UserRoleId = rootRole.Id,
            ProfileId = p.Id
        );
        insert testUserRootRole;

        // Create Test User with Subordinate Role
        User testUserSubordinateRole = new User(
            Alias = 'Alias2',
            Email = 'test2@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestUser2',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'test2@inwiCGC_DemandeVisiteRoleControllerTest.com',
            UserRoleId = subordinateRole.Id,
            ProfileId = p.Id
        );
        insert testUserSubordinateRole;
        
        // Create Test User without Role
        User testUserNoRole = new User(
            Alias = 'Alias3',
            Email = 'test2@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestUser2',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'test3@inwiCGC_DemandeVisiteRoleControllerTest.com',
            ProfileId = p.Id
        );
        insert testUserNoRole;
    }
    
   @isTest
    static void testGetRoleHierarchy(){

        UserRole rootRole = [SELECT Id, Name FROM UserRole WHERE Name = 'TestRole' LIMIT 1];
        User currentRole = [select Name, id, UserRoleId , UserRole.Name from User where UserRoleId=: rootRole.Id LIMIT 1];
        
 
        
        inwiCGC_DemandeDeVisite__c testDemandeVisite = new inwiCGC_DemandeDeVisite__c();

        testDemandeVisite.Name = 'Test Demand';
        testDemandeVisite.Planned_Start_Time__c = System.now();
        testDemandeVisite.Planned_End_Time__c = System.now().addDays(2);
        testDemandeVisite.inwiCGC_Descriptif__c = 'Test descreption';
        testDemandeVisite.inwiCGC_Objectif_SIM__c = 100;
        testDemandeVisite.Status__c = 'inwiCGC_Valide'; 
        testDemandeVisite.OwnerId = currentRole.Id;
        insert testDemandeVisite;

        String result = InwiCGC_DemandeDeVisiteRoleController.getRoleHierarchy(testDemandeVisite.Id);
        System.debug('result '+ result );
        System.assertNotEquals(null, result, 'Result should not be null');
            
    }
    
    
   @isTest
    static void testCreateDemandesVisiteWithSubRole() {

        UserRole rootRole = [SELECT Id, Name FROM UserRole WHERE Name = 'TestRole' LIMIT 1];
        List<UserRole> subordinateRoles = [SELECT Id ,Name FROM UserRole WHERE ParentRoleId=:rootRole.id];
        User subordinateUserRoles = [select Name, id, UserRoleId , UserRole.Name from User where UserRoleId IN :subordinateRoles LIMIT 1];
        User currentRole = [select Name, id, UserRoleId , UserRole.Name from User where UserRoleId=:rootRole.Id LIMIT 1];
        
        System.debug('rootRole '+ rootRole );
       
  
        inwiCGC_DemandeDeVisite__c testDemandeVisite = new inwiCGC_DemandeDeVisite__c();

        testDemandeVisite.Name = 'Test Demand';
        testDemandeVisite.Planned_Start_Time__c = System.now();
        testDemandeVisite.Planned_End_Time__c = System.now().addDays(2);
        testDemandeVisite.inwiCGC_Descriptif__c = 'Test descreption';
        testDemandeVisite.inwiCGC_Objectif_SIM__c = 100;
        testDemandeVisite.Status__c = 'inwiCGC_Valide'; 
        testDemandeVisite.OwnerId = currentRole.Id;
        insert testDemandeVisite;

        Map<String, Object> result = InwiCGC_DemandeDeVisiteRoleController.createDemandesVisite('[{"id":"' + subordinateUserRoles.UserRoleId + '","label":"Test Role","Objectif":"100","Descriptif":"test","isChecked":true}]', testDemandeVisite.Id);

        
    }
    
     @isTest
    static void testCreateDemandesVisiteNoSubRole() {

        UserRole rootRole = [SELECT Id, Name FROM UserRole WHERE Name = 'TestRole' LIMIT 1];
        User currentRole = [select Name, id, UserRoleId , UserRole.Name from User where UserRoleId=:rootRole.Id LIMIT 1];
        
        
        UserRole unassignedRoles = [SELECT Id, Name FROM UserRole WHERE Name = 'SubordinateRole2'  limit 1];
  
        inwiCGC_DemandeDeVisite__c testDemandeVisite = new inwiCGC_DemandeDeVisite__c();

        testDemandeVisite.Name = 'Test Demand';
        testDemandeVisite.Planned_Start_Time__c = System.now();
        testDemandeVisite.Planned_End_Time__c = System.now().addDays(2);
        testDemandeVisite.inwiCGC_Descriptif__c = 'Test descreption';
        testDemandeVisite.inwiCGC_Objectif__c = 100;
        testDemandeVisite.Status__c = 'inwiCGC_Valide'; 
        testDemandeVisite.OwnerId = currentRole.Id;
        insert testDemandeVisite;

        Map<String, Object> result = InwiCGC_DemandeDeVisiteRoleController.createDemandesVisite('[{"id":"' + unassignedRoles.Id + '","label":"Test Role","Objectif":"100","Descriptif":"test","isChecked":true}]', testDemandeVisite.Id);

    
            System.assertEquals(false, result.get('response'), 'Response should be false');
            List<String> errorMessages = new List<String>();
            errorMessages.add('Aucun utilisateur avec les roles sélectionné n\'as été trouvé');
            System.assertEquals(errorMessages, result.get('message'));
        
        System.debug('result '+ result );
        
    }
    
    
     @isTest
    static void testDuplicateDemande() {
    
        UserRole rootRole = [SELECT Id, Name FROM UserRole WHERE Name = 'TestRole' LIMIT 1];
        List<UserRole> subordinateRoles = [SELECT Id, Name FROM UserRole WHERE ParentRoleId = :rootRole.Id];
        User subordinateUserRoles = [SELECT Name, Id, UserRoleId, UserRole.Name FROM User WHERE UserRoleId IN :subordinateRoles LIMIT 1];
        User currentRole = [SELECT Name, Id, UserRoleId, UserRole.Name FROM User WHERE UserRoleId = :rootRole.Id LIMIT 1];
        
        inwiCGC_DemandeDeVisite__c testDemandeVisite = new inwiCGC_DemandeDeVisite__c();
        testDemandeVisite.Name = 'Test Demand';
        testDemandeVisite.Planned_Start_Time__c = System.now();
        testDemandeVisite.Planned_End_Time__c = System.now().addDays(2);
        testDemandeVisite.inwiCGC_Descriptif__c = 'Test description';
        testDemandeVisite.inwiCGC_Objectif_SIM__c = 100;
        testDemandeVisite.Status__c = 'inwiCGC_Valide'; 
        testDemandeVisite.OwnerId = currentRole.Id;
        insert testDemandeVisite;
    
        InwiCGC_DemandeDeVisiteRoleController.UserWithRoleInfo testUserWithRoleInfo = new InwiCGC_DemandeDeVisiteRoleController.UserWithRoleInfo();
        testUserWithRoleInfo.userId = subordinateUserRoles.Id; // Use subordinate user's Id
        testUserWithRoleInfo.userRoleId = subordinateUserRoles.UserRoleId;
        testUserWithRoleInfo.userRoleName = subordinateUserRoles.UserRole.Name;
    
        testUserWithRoleInfo.objectifSIM = '50';
        testUserWithRoleInfo.objectifSIMDealer = '30';
        testUserWithRoleInfo.objectifSC = '20';
    
        List<InwiCGC_DemandeDeVisiteRoleController.UserWithRoleInfo> userInfoList = new List<InwiCGC_DemandeDeVisiteRoleController.UserWithRoleInfo>{ testUserWithRoleInfo };
    
        List<inwiCGC_DemandeDeVisite__c> result = InwiCGC_DemandeDeVisiteRoleController.duplicateDemande(testDemandeVisite, userInfoList);
    
        // Validate the result
        System.assertEquals(1, result.size(), 'Should have one duplicated record.');
        inwiCGC_DemandeDeVisite__c duplicatedRecord = result[0];
        System.assertEquals(subordinateUserRoles.UserRole.Name + ' - ' + testDemandeVisite.Name, duplicatedRecord.Name, 'Name should match.');
        System.assertEquals('inwiCGC_EnCours', duplicatedRecord.Status__c, 'Status should be updated.');
        System.assertEquals(Decimal.valueOf('50'), duplicatedRecord.inwiCGC_Objectif_SIM__c, 'Objectif SIM should match.');
        System.assertEquals(Decimal.valueOf('30'), duplicatedRecord.inwiCGC_Objectif_SIM_Dealer__c, 'Objectif SIM Dealer should match.');
        System.assertEquals(Decimal.valueOf('20'), duplicatedRecord.inwiCGC_Objectif_SC__c, 'Objectif SC should match.');
    }


}