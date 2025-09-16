global with sharing class InwiB2C_AttachmentsManagement {

    
    @future(callout = true)
        public static void attachmentsAssignment(String idOldContract, String idNewContract,String oldBusinessReferenceType,String newBusinessReferenceType ) {

            System.debug('start attachmentsAssignment:');                 

            Map <String, Object> retreiveListInput = new Map <String, Object> ();
            Map <String, Object> retreiveListOptions = new Map <String, Object> ();
  
            retreiveListInput.put('businessReferenceType', oldBusinessReferenceType);
            retreiveListInput.put('businessReference', idOldContract);
  
  
            Map <String, Object> retreiveListOutput = new Map <String, Object>();
  
            System.debug('retreiveListInput:');                 
            System.debug(retreiveListInput);                 

            System.debug('retreiveListOptions:');                 
            System.debug(retreiveListOptions);                 


            if(!Test.isRunningTest()){
                retreiveListOutput =(Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_retreiveListDocument',retreiveListInput, retreiveListOptions);

            }else{
                retreiveListOutput.put('success', true);
                List<Object> documents = new List<Object>();
                Map<String,Object> document = new Map<String,Object>();
                document.put('uploadSource', 'SF');
                document.put('uploadDate', '2021-06-03T11:21:36Z[UTC');
                document.put('fromOcr', false);
                document.put('documentVisibility', true);
                document.put('documentType', '00001');
                document.put('documentId', 1541);
                document.put('documentExtention', '.png');
                document.put('documentName', 'test.png');
                documents.add(document);
                retreiveListOutput.put('documents', documents);
                
            }
            

            System.debug('retreiveListOutput:');                 
            System.debug(retreiveListOutput);                 

            if(retreiveListOutput.get('success')==false){
                System.debug('success:'+retreiveListOutput.get('success'));                 
                System.debug('error:'+retreiveListOutput.get('error'));                 
            }else{
                System.debug('retreiveListOutput.get(documents):');                 
                System.debug(retreiveListOutput.get('documents'));       
                


                List<Object> listDocsToUpdate = (List<Object>)retreiveListOutput.get('documents');
                
                    if(!(listDocsToUpdate==null))

                for (Object doc : listDocsToUpdate) {
                    Map <String, Object> theDoc = (Map <String, Object>)doc;

                    Map <String, Object> InsertIndexDocOutput = new Map <String, Object>();
                    Map <String, Object> InsertIndexDocOptions = new Map <String, Object>();
                    Map <String, Object> InsertIndexDocInput = new Map <String, Object>();

                    System.debug('theDoc');       
                    System.debug(theDoc);       


                    System.debug('theDoc.get(documentId)');       
                    System.debug(theDoc.get('documentId'));       

                    InsertIndexDocInput.put('businessReferenceType',newBusinessReferenceType);
                    InsertIndexDocInput.put('documentID',theDoc.get('documentId'));
                    InsertIndexDocInput.put('businessReference',idNewContract);

                    if(!Test.isRunningTest())
                        InsertIndexDocOutput =(Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InsertIndexDocument',InsertIndexDocInput, InsertIndexDocOptions);


                }

       


        }
        
}


}