@isTest
public class InwiB2C_OfferPermissionSetFilterTest {
  
    @testSetup
    static void setupTestData() {
        PermissionSet acquisitionPermissionSet = new PermissionSet(
            Name = 'Show_BehiaAcquisition',
            Label = 'Show Offer in Acquisition Permission Set'
        );
        insert acquisitionPermissionSet;
        
        PermissionSet acquisitionPermissionSet1 = new PermissionSet(
            Name = 'Show_Behia',
            Label = 'Show Offer Permission Set'
        );
        insert acquisitionPermissionSet1;
    
        // Create mock User with assigned Permission Set
        User testUser = new User(
            Alias = 'tuser',
            Email = 'testuser@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name LIKE '%Administra%'].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser@InwiB2C_OfferPermissionSetFilterTest.com'
        );
        insert testUser;
    
        User testUser1 = new User(
            Alias = 'tuser1',
            Email = 'testuser1@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test1',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name LIKE '%Administra%'].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser1@InwiB2C_OfferPermissionSetFilterTest.com'
        );
        insert testUser1;
        
        PermissionSetAssignment psAssignment = new PermissionSetAssignment(
            AssigneeId = testUser.Id,
            PermissionSetId = acquisitionPermissionSet.Id
        );
        insert psAssignment;
        
        PermissionSetAssignment psAssignment1 = new PermissionSetAssignment(
            AssigneeId = testUser.Id,
            PermissionSetId = acquisitionPermissionSet1.Id
        );
        insert psAssignment1;
    }
  
 @isTest
  static void testConstructPermissionSetsOfferFilter(){
    InwiB2C_OfferPermissionSetFilter cls = new InwiB2C_OfferPermissionSetFilter();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> inputMap = new Map<String, Object>();
      
    User testUser = [SELECT Id FROM User WHERE Alias = 'tuser' LIMIT 1];
    User testUser1 = [SELECT Id FROM User WHERE Alias = 'tuser1' LIMIT 1];
    boolean result;
      
    System.runAs(testUser) {
		inputMap.put('typeParcours','');
        result = cls.invokeMethod('constructPermissionSetsOfferFilter', inputMap, outMap, options);
        inputMap.put('typeParcours','Acquisition');
        result = cls.invokeMethod('constructPermissionSetsOfferFilter', inputMap, outMap, options);
        inputMap.put('typeParcours','test');
        result = cls.invokeMethod('constructPermissionSetsOfferFilter', inputMap, outMap, options);
        inputMap.put('typeParcours','test');
        result = cls.invokeMethod('testmethode', inputMap, outMap, options);
    }
    System.runAs(testUser1) {
        inputMap.put('typeParcours','Acquisition');
        result = cls.invokeMethod('constructPermissionSetsOfferFilter', inputMap, outMap, options);
    }
  }
}