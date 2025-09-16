@isTest
public class MDNFileHandlerTest {
    
    @isTest(SeeAllData=false)
     public static void ReadMDNFileTest()
    {
        Test.startTest();
         Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
       
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'test description';
        cv.PathOnClient ='test_file.txt';
        cv.Title = 'test file';
        cv.versiondata=Blob.valueOf('2126588889999');
        insert cv;
        Id idDocument = cv.ContentDocumentId; 
        ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        inputMap.put('contentDocumentId',document.Id);
        new MDNFileHandler().invokeMethod('ReadMDNFile',inputMap, outMap, options);
          Test.stopTest();
    }

}