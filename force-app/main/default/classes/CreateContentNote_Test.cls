@isTest
private class CreateContentNote_Test {

    @isTest
    static void testInvokeMethod_Success() {
  
        CreateContentNote contentNoteCreator = new CreateContentNote();
    
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('caseId', 'testCaseId'); 

        Map<String, Object> outMap = new Map<String, Object>();

  
        Boolean result = contentNoteCreator.invokeMethod('CreateContentNote', inputMap, outMap, new Map<String, Object>());


 
    }

    @isTest
    static void testInvokeMethod_Exception() {
   
        CreateContentNote contentNoteCreator = new CreateContentNote();

    
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('invalidKey', 'invalidValue'); 
        Map<String, Object> outMap = new Map<String, Object>();
        
        Boolean result = contentNoteCreator.invokeMethod('CreateContentNote', inputMap, outMap, new Map<String, Object>());


    }
}