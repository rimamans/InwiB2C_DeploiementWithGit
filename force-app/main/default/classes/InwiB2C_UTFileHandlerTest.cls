@isTest
public class InwiB2C_UTFileHandlerTest {
    @isTest(SeeAllData=false)
    //Empty File
    public static void ReadUTFileEmptyTest()
    {
        Test.startTest();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'test description';
        cv.PathOnClient ='test_file.txt';
        cv.Title = 'test file';
        cv.versiondata=Blob.valueOf('123');
        insert cv;
        Id idDocument = cv.ContentDocumentId; 
        ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        inputMap.put('contentDocumentId',document.Id);
        new InwiB2C_UTFileHandler().invokeMethod('ReadFile',inputMap, outMap, options);
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=false)
    //No Header File
    public static void ReadUTFileNoHeadetTest()
    {
        Test.startTest();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'test description';
        cv.PathOnClient ='test_file.txt';
        cv.Title = 'test file';
        cv.versiondata=Blob.valueOf('0522324455;5E:FF:56:A2:AF:15;VULA;Bitstream \n 0522324455;5E:FF:56:A2:AF:15;VULA;Bitstream');
        insert cv;
        Id idDocument = cv.ContentDocumentId; 
        ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        inputMap.put('contentDocumentId',document.Id);
        new InwiB2C_UTFileHandler().invokeMethod('ReadFile',inputMap, outMap, options);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=false)
    // File KO
    public static void ReadUTFileKOTest()
    {
        Test.startTest();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'test description';
        cv.PathOnClient ='test_file.txt';
        cv.Title = 'test file';
        String csvString = 'Nd;Mac;Technologie source;Technologie cible\n;5E:FF:56:A2:AF:15;VULA;Bitstream\n0522324455;;VULA;Bitstream';
        //csvString += ';5E:FF:56:A2:AF:15;VULA;Bitstream';
        //csvString += '0522324455;;VULA;Bitstream';
        cv.versiondata=Blob.valueOf(csvString);
        system.debug('test: '+Blob.valueOf(csvString));
        insert cv;
        Id idDocument = cv.ContentDocumentId; 
        ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        inputMap.put('contentDocumentId',document.Id);
        new InwiB2C_UTFileHandler().invokeMethod('ReadFile',inputMap, outMap, options);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=false)
    // File OK
    public static void ReadUTFileOKTest()
    {
        Test.startTest();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'test description';
        cv.PathOnClient ='test_file.txt';
        cv.Title = 'test file';
        String csvString = 'Nd;Mac;Technologie source;Technologie cible\n522324455;5E:FF:56:A2:AF:15;BitStream;vula\r\n0537326387;5E:FF:56:A2:AF:16;BitStream;vula';
        cv.versiondata=Blob.valueOf(csvString);
        insert cv;
        Id idDocument = cv.ContentDocumentId; 
        ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        inputMap.put('contentDocumentId',document.Id);
        new InwiB2C_UTFileHandler().invokeMethod('ReadFile',inputMap, outMap, options);
        Test.stopTest();
    }


}