global with sharing class CreateContentNote implements vlocity_cmt.VlocityOpenInterface{
    
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
                    
        Boolean result = true;

        try{

            if (methodName.equals('CreateContentNote')){
                CreateContentNote(inputMap, outMap, options);
                // your implementation, use outMap to send response back to OmniScript
            } 

        } catch (Exception e){

            result = false;

        }

        return result;
    }
    
    public static boolean CreateContentNote(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        boolean succes = true;
        try{
            Id caseId = (String) inputMap.get('caseId');
        ContentNote noteRecord = new ContentNote();
        noteRecord.Title   = 'Azerty';
        String body        = 'ContentNote - Sample';
        noteRecord.Content = Blob.valueOf(body.escapeHTML4());
        insert noteRecord;
        ContentDocumentLink link = new ContentDocumentLink();
        link.ContentDocumentId   = noteRecord.id;
        link.LinkedEntityId      = caseId;
        link.ShareType           = 'V';
        link.Visibility          = 'InternalUsers';
        insert link;
        }catch(exception e){
            succes = false;
        }
        return succes;
    }
}