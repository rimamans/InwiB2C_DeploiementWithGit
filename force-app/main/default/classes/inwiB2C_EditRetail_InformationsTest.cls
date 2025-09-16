@isTest(SeeAllData=true)
public class inwiB2C_EditRetail_InformationsTest {
    @isTest
    static void testEditRetailInformations() {
        INWIB2C_GroupName__mdt groupName = [SELECT inwiB2C_BoutiqueId__c FROM INWIB2C_GroupName__mdt LIMIT 1];

        // Create test contact
        Contact contact = new Contact(FirstName = 'Test', LastName = 'Test');
        insert contact;

        // Create test account
        Account account = new Account(Name = 'Test', vlocity_cmt__PrimaryContactId__c = contact.Id);
        insert account;

        // Create test retail store (replace RetailStore with correct API name if custom)
        Schema.RetailStore RS = new Schema.RetailStore(
            Name = 'Test Store', 
            PrimaryContactId = contact.Id, 
            AccountId = account.Id
        );
        insert RS;

        // Create test user
        Profile profileTest = [SELECT Id FROM Profile WHERE Name = 'CGC_RVR' LIMIT 1];
        User userTest = new User(
            Alias = 'te123',
            Email = 'test@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profileTest.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testusesqhflr@test.com'
        );
        insert userTest;

        // Test case where imageFileId is null
        Test.startTest();
        inwiB2C_EditRetail_Informations.EditRetailInformations(
            RS.Id,              // paramId
            'UpdatedFirstName', // firstName
            'UpdatedLastName',  // lastName
            'UpdatedAccountName', // AccountName
            'BT',               // TypeActivite
            '34.57856',         // longitude
            '-6.63988',         // latitude
            '1234567891',       // MdnDealer
            userTest.Id,        // IdRVR
            '1234567892',       // MdnDealer2
            true,               // isDealer
            'UpdatedSegment',   // segmentDealer
            '0677889900',       // contactNumber1
            '0677889901',       // contactNumber2
            'CA',               // Region
            'RTMU',             // Localisation
            'LISASFA',          // Circuit
            true,               // isDealerIdentifier
            true,               // isDistributeurAppMobile
            null,               // imageUrl
            null                // imageFileId
        );

        // Insert a ContentVersion record to generate ContentDocumentId
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'test.jpg',
            VersionData = Blob.valueOf('Test file content'),
            IsMajorVersion = true
        );
        insert contentVersion;

        // Fetch the generated ContentDocumentId
        Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;

        inwiB2C_EditRetail_Informations.EditRetailInformations(
            RS.Id,              // paramId
            'UpdatedFirstName', // firstName
            'UpdatedLastName',  // lastName
            'UpdatedAccountName', // AccountName
            'BT',               // TypeActivite
            '34.57856',         // longitude
            '-6.63988',         // latitude
            '1234567891',       // MdnDealer
            userTest.Id,        // IdRVR
            '1234567892',       // MdnDealer2
            true,               // isDealer
            'UpdatedSegment',   // segmentDealer
            '0677889900',       // contactNumber1
            '0677889901',       // contactNumber2
            'CA',               // Region
            'RTMU',             // Localisation
            'LISASFA',          // Circuit
            true,               // isDealerIdentifier
            true,               // isDistributeurAppMobile
            'https://test.com/image.jpg', // imageUrl
            contentDocId        // imageFileId
        );
        Test.stopTest();
    }
}