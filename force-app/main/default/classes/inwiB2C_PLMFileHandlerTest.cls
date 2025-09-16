@IsTest
public class inwiB2C_PLMFileHandlerTest {
    @TestSetup
    static void setupTestData() {
        String csvData = 'Code Article,Start Date,End Date,Price,Canal\n' +
                         'ART1,2023-01-01,2023-12-31,100.00,Online\n' +
                         'ART2,2023-02-01,2023-11-30,200.00,Store';
        ContentVersion cv = new ContentVersion(
            Title = 'Test.csv',
            PathOnClient = 'Test.csv',
            VersionData = Blob.valueOf(csvData),
            IsMajorVersion = true
        );
        insert cv;
        
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        Id contentDocumentId = cv.ContentDocumentId;
        
        inwiB2C_TraitementMassifFichier_PLM__c fileRecord = new inwiB2C_TraitementMassifFichier_PLM__c(
            inwiB2C_Statut__c = 'inwiB2C_In_Progress',
            Nom_du_fichier__c = 'Test.csv',
            inwiB2C_DOCUMENT_ID__c = contentDocumentId
        );
        insert fileRecord;
        
        List<InwiB2C_PriceListeMasse__c> existingRecords = new List<InwiB2C_PriceListeMasse__c>{
            new InwiB2C_PriceListeMasse__c(
                inwiB2C_code_article__c = 'ART1',
                inwiB2C_start_date__c = Date.newInstance(2022, 1, 1),
                inwiB2C_end_date__c = Date.newInstance(2022, 12, 31),
                inwiB2C_Price__c = 50.00,
                inwiB2C_canal__c = 'Online',
                inwiB2C_DOCUMENT_ID__c = contentDocumentId
            )
        };
        insert existingRecords;
    }

    @IsTest
    static void testReadPLMFile_Success() {
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];
        inwiB2C_PLMFileHandler handler = new inwiB2C_PLMFileHandler();
        Map<String, Object> input = new Map<String, Object>{
            'contentDocumentId' => cv.ContentDocumentId,
            'fileName' => 'Test.csv'
        };
        Map<String, Object> output = new Map<String, Object>();
        
        Test.startTest();
        Boolean result = handler.InvokeMethod('ReadPLMFile', input, output, null);
        Test.stopTest();
        
        System.assert(result, 'Method should succeed');
        List<String> records = (List<String>) output.get('List');
        System.assertEquals(3, records.size(), 'Should parse 3 lines');
    }

    @IsTest
    static void testReadPLMFile_InvalidContentDocument() {
        inwiB2C_PLMFileHandler handler = new inwiB2C_PLMFileHandler();
        Map<String, Object> input = new Map<String, Object>{
            'contentDocumentId' => '069XXXXXXXXXXXX',
            'fileName' => 'Test.csv'
        };
        Map<String, Object> output = new Map<String, Object>();
        
        Test.startTest();
        Boolean result = handler.InvokeMethod('ReadPLMFile', input, output, null);
        Test.stopTest();
        
        System.assert(!result, 'Method should fail due to invalid ContentDocument');
    }

    @IsTest
    static void testInsertPLMData_InsertNew() {
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];
        List<String> csvData = new List<String>{
            'Code Article,Start Date,End Date,Price,Canal',
            'ART3,2023-03-01,2023-10-31,300.00,Online'
        };
        inwiB2C_PLMFileHandler handler = new inwiB2C_PLMFileHandler();
        Map<String, Object> input = new Map<String, Object>{
            'contentDocumentId' => cv.ContentDocumentId,
            'data' => csvData
        };
        Map<String, Object> output = new Map<String, Object>();
        
        Test.startTest();
        Boolean result = handler.InvokeMethod('InsertPLMData', input, output, null);
        Test.stopTest();
        
        System.assert(result, 'Insert should succeed');
        List<InwiB2C_PriceListeMasse__c> newRecords = [SELECT Id FROM InwiB2C_PriceListeMasse__c WHERE inwiB2C_code_article__c = 'ART3'];
        System.assertEquals(1, newRecords.size(), 'New record should be inserted');
    }

    @IsTest
    static void testInsertPLMData_UpdateExisting() {
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];
        List<String> csvData = new List<String>{
            'Code Article,Start Date,End Date,Price,Canal',
            'ART1,2024-01-01,2024-12-31,150.00,Store'
        };
        inwiB2C_PLMFileHandler handler = new inwiB2C_PLMFileHandler();
        Map<String, Object> input = new Map<String, Object>{
            'contentDocumentId' => cv.ContentDocumentId,
            'data' => csvData
        };
        Map<String, Object> output = new Map<String, Object>();
        
        Test.startTest();
        Boolean result = handler.InvokeMethod('InsertPLMData', input, output, null);
        Test.stopTest();
        
        System.assert(result, 'Update should succeed');
        InwiB2C_PriceListeMasse__c updatedRec = [SELECT inwiB2C_Price__c FROM InwiB2C_PriceListeMasse__c WHERE inwiB2C_code_article__c = 'ART1'];
        System.assertEquals(150.00, updatedRec.inwiB2C_Price__c, 'Price should be updated');
    }

    @IsTest
    static void testInsertPLMData_InvalidData() {
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];
        List<String> csvData = new List<String>{
            'Code Article,Start Date,End Date,Price,Canal',
            'ART4,invalid-date,2023-12-31,invalid,Store'
        };
        inwiB2C_PLMFileHandler handler = new inwiB2C_PLMFileHandler();
        Map<String, Object> input = new Map<String, Object>{
            'contentDocumentId' => cv.ContentDocumentId,
            'data' => csvData
        };
        Map<String, Object> output = new Map<String, Object>();
        
        Test.startTest();
        Boolean result = handler.InvokeMethod('InsertPLMData', input, output, null);
        Test.stopTest();
        
        System.assert(result, 'Method should handle parsing errors');
        List<InwiB2C_PriceListeMasse__c> records = [SELECT Id FROM InwiB2C_PriceListeMasse__c WHERE inwiB2C_code_article__c = 'ART4'];
        System.assertEquals(0, records.size(), 'No records should be inserted');
    }

    @IsTest
    static void testGetRecordsByDocumentId() {
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];
        List<InwiB2C_PriceListeMasse__c> records = new List<InwiB2C_PriceListeMasse__c>();
        for (Integer i = 0; i < 250; i++) {
            records.add(new InwiB2C_PriceListeMasse__c(
                inwiB2C_code_article__c = 'BULK' + i,
                inwiB2C_start_date__c = Date.today(),
                inwiB2C_end_date__c = Date.today().addDays(30),
                inwiB2C_Price__c = 100 + i,
                inwiB2C_canal__c = 'Bulk',
                inwiB2C_DOCUMENT_ID__c = cv.ContentDocumentId
            ));
        }
        insert records;
        
        inwiB2C_PLMFileHandler handler = new inwiB2C_PLMFileHandler();
        Map<String, Object> input = new Map<String, Object>{'documentId' => cv.ContentDocumentId};
        Map<String, Object> output = new Map<String, Object>();
        
        Test.startTest();
        Boolean result = handler.InvokeMethod('getRecordsByDocumentId', input, output, null);
        Test.stopTest();
        
        System.assert(result, 'Method should succeed');
        List<Map<String, Object>> recordsList = (List<Map<String, Object>>) output.get('List');
        System.assertEquals(251, recordsList.size(), 'Should return all 250 + 1 existing records');
    }

    @IsTest
    static void testGetDocStatusesForMultipleIds() {
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];
        Id docId1 = cv.ContentDocumentId;
        ContentVersion cv2 = new ContentVersion(
            Title = 'Test2.csv',
            PathOnClient = 'Test2.csv',
            VersionData = Blob.valueOf('Header\nART5,2023-01-01,2023-12-31,500.00,Store'),
            IsMajorVersion = true
        );
        insert cv2;
        cv2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv2.Id];
        Id docId2 = cv2.ContentDocumentId;
        insert new InwiB2C_PriceListeMasse__c(
            inwiB2C_code_article__c = 'ART5',
            inwiB2C_DOCUMENT_ID__c = docId2,
            InwiB2C_Status__c = 'Processed'
        );
        
        inwiB2C_PLMFileHandler handler = new inwiB2C_PLMFileHandler();
        Map<String, Object> input = new Map<String, Object>{
            'docIds' => new List<Id>{docId1, docId2}
        };
        Map<String, Object> output = new Map<String, Object>();
        
        Test.startTest();
        Boolean result = handler.InvokeMethod('getDocStatusesForMultipleIds', input, output, null);
        Test.stopTest();
        
        System.assert(result, 'Method should succeed');
        Map<Id, String> statusMap = (Map<Id, String>) output.get('DocStatusMap');
        System.assertEquals('En attente de traitement', statusMap.get(docId1), 'Doc1 should be pending');
        System.assertEquals('Traitement terminé', statusMap.get(docId2), 'Doc2 should be processed');
    }

    @IsTest
    static void testInvokeMethod_InvalidMethod() {
        inwiB2C_PLMFileHandler handler = new inwiB2C_PLMFileHandler();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        
        Test.startTest();
        Boolean result = handler.InvokeMethod('InvalidMethod', input, output, null);
        Test.stopTest();
        
        System.assert(result, 'Invalid method should return true without exception');
    }
}