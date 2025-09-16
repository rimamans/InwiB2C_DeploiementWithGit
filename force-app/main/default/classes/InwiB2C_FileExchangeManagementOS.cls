global with sharing class InwiB2C_FileExchangeManagementOS implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try{
            if(methodName.equals('retrieveDocument')){
                retrieveDocument(inputMap, outMap, options);
            }
            
            else if(methodName.equals('sendDocument'))  {
                sendDocument(inputMap, outMap, options);

            }
            else if(methodName.equals('getIdType'))  {
                getidType(inputMap, outMap, options);

            }                              
            else {}                            
            
        } catch(Exception e){
            result = false;
        }
        return result;
   }

   public static void getIdType(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
    System.debug(JSON.serialize(inputMap));

    System.debug('in getIdType');

    String recordId = (String) inputMap.get('recordId');

    Id entityId = (Id)recordId;
// chb 06/06/2025 ajout d'une requete pour verifier si le canal d'identification est inwiB2C_VI begin*/
    List<InwiB2C_Demande_identification__c> demandeIdentification = [
        SELECT Id
        FROM InwiB2C_Demande_identification__c
        WHERE Id = :entityId
        AND InwiB2C_Canal__c = 'inwiB2C_VI'
    ];
// chb 06/06/2025 ajout d'une requete pour verifier si le canal d'identification est inwiB2C_VI end*/
    Schema.sObjectType entityType = entityId.getSObjectType();

    if (entityType == Opportunity.sObjectType ) {
        outMap.put('objectType','OPPORTUNITY' ) ;
    }else if (entityType == Order.sObjectType ) {
        outMap.put('objectType','ORDER' ) ;
    }else if (entityType == Contract.sObjectType ) {
        outMap.put('objectType','CONTRACT' ) ;
    }else if (entityType == Account.sObjectType ) {
        outMap.put('objectType','CUSTOMER' ) ;
    }else if (entityType == InwiB2C_Demande__c.sObjectType ) {
        outMap.put('objectType','CUSTOMER');
    }else if (entityType == InwiB2C_DemandeDesidentification__c.sObjectType ) {
        outMap.put('objectType','ORDER');}
         //chb 04/06/2025 iDENTIFICATION api vi
    else if (entityType == InwiB2C_Demande_identification__c.sObjectType && !demandeIdentification.isEmpty()) {
        outMap.put('objectType','CASE');}
        //chb 04/06/2025 iDENTIFICATION api vi
    else if (entityType == InwiB2C_Demande_de_resiliation__c.sObjectType ) {
        outMap.put('objectType','CONTRACT');}
    else if (entityType == InwiB2C_Demande_de_migration__c.sObjectType ) {
        outMap.put('objectType','CONTRACT');}
    else {
        outMap.put('objectType','UNKNOWN' ) ;
    }

    /*
    Switch on entityType{
        when  Opportunity.sObjectType{
            outMap.put('objectType','OPPORTUNITY' ) ;

        }
        when  Order.sObjectType{
            outMap.put('objectType','ORDER' ) ;

        }
        when  Contract.sObjectType{
            outMap.put('objectType','CONTRACT' ) ;

        }
        when  Account.sObjectType{
            outMap.put('objectType','CUSTOMER' ) ;

        }
    }*/

    

   }

   

   public static void retrieveDocument(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
    System.debug(JSON.serialize(inputMap));

    System.debug('in retrieveDocument');

    

    String recordId = (String) inputMap.get('recordId');
    String typeDoc = (String) inputMap.get('typeDoc');
       System.debug('TypeDocRecu'+ typeDoc );
       System.debug('recordId'+ recordId );
       //outMap.put('typeDocRECU',typeDoc ) ;
       
       //outMap.put('recordIdRECU',recordId ) ;


    try{
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndpoint('callout:SOA_URL/inwi-api/documentManagement/v1/document/'+ recordId + '?type='+typeDoc);


        request.setMethod('GET');
        
        request.setHeader('canal', 'SF');
        request.setHeader('user', 'SF');
        request.setHeader('uuid', INWIB2C_GenerateTransactionCode.generate());
        request.setTimeout(60000);
        if(!Test.isRunningTest()){
         response = http.send(request);
        }else{
            response.setStatusCode(200);
            response.setHeader('errorName', 'ErrorName');
            response.setStatus('OK');
            response.setHeader('Fromocr', 'azer');
            response.setHeader('document-id', '1234');
            response.setHeader('Document-Type', 'DocType');
            response.setHeader('Content-Type', 'ContentType');
            response.setHeader('Content-Disposition', 'ContentDisposition');
            response.setHeader('Content-Length', '12');
            response.setHeader('Document-Extention', 'DocumentExtention');
            response.setHeader('Document-Visibility', 'DocumentVisibility');
        }
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
                
            
            outMap.put('errorCode',response.getStatusCode() ) ;
            outMap.put('errorName',response.getStatus() ) ;

            outMap.remove('error');
            outMap.put('error','KO : '+ response.getStatusCode() + ' ' + response.getStatus() ) ;

                
        } else {
            System.debug('OK: ');
            //System.debug('response.getHeaderKeys(): ' + response.getHeaderKeys());
            //System.debug(' response.getHeader(Document-Name)' + response.getHeader('Document-Name'));


      //      outMap.put('getHeaderKeys',response.getHeaderKeys() ) ;


            Map<String,String> result = new Map<String,String>{
                
                'File'=>EncodingUtil.Base64Encode(response.getBodyAsBlob()),
                'Fromocr'=>response.getHeader('Fromocr'),
                'DocumentExtention'=>response.getHeader('Document-Extention'),
                'DocumentVisibility'=>response.getHeader('Document-Visibility'),
                'DocumentId'=>response.getHeader('document-id'),
                'DocumentType'=>response.getHeader('Document-Type'),
                'ContentType'=>response.getHeader('Content-Type'),
                'ContentDisposition'=>response.getHeader('Content-Disposition'),
                'ContentLength'=>response.getHeader('Content-Length')

            };

            outMap.put('result',result ) ;
        }

    }catch (Exception e){
        outMap.put('errorCode',e.getTypeName() ) ;
        outMap.put('errorName',e.getMessage() ) ;

        outMap.remove('error');
        outMap.put('error','KO : '+ e.getMessage() + ' ' + e.getTypeName() ) ;

    }
    

}


@AuraEnabled
public static void sendDocument(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
    System.debug(JSON.serialize(inputMap));
    System.debug('in the sendDocument');

    String docTypeId = (String) inputMap.get('docTypeId');
    System.debug('docTypeId: ' + docTypeId);

    String docTypeLabel = (String) inputMap.get('docTypeLabel');
    System.debug('docTypeLabel: ' + docTypeLabel);


    String Fullbase64Image = (String) inputMap.get('base64Image');

    /*String firstPArt = Fullbase64Image.split(',', 2)[0];
    String base64Image = Fullbase64Image.split(',', 2)[1];
    System.debug('firstPArt: ' + firstPArt);
*/

    String base64Image = Fullbase64Image;


    String docName = (String) inputMap.get('docName');



    //String extention = firstPArt.split('/', 2)[1].left(3) ;

   // String extention = docName.split('.', 2)[1] ;
    
    Integer dotIndex = docName.lastIndexOf('.');

	// Extract the extension
	String extention = (dotIndex != -1) ? docName.substring(dotIndex + 1) : '';
    System.debug('extention: ' + extention);

    System.debug('base64Image: ' + base64Image);


    List<Object> documentCharacteristic = (List<Object>) inputMap.get('documentCharacteristic');
    System.debug('documentCharacteristic:');
    System.debug(JSON.serialize(documentCharacteristic));
 /*
    Blob  blobImg;
   
    String b64Img = 'data:image/png;base64,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'
;

    try {
     blobImg = EncodingUtil.base64Decode(base64Image);
  
    } catch (Exception e) {
        System.debug('Exception');
        System.debug(e);

    } 
    System.debug('after blobImg');
*/
    try{
        System.debug('in try');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SOA_URL/inwi-api/documentManagement/v1/document/uploadDocument/');


        request.setMethod('POST');

        request.setHeader('Content-Type', 'application/json');        

        request.setHeader('Accept', '*/*');
        request.setHeader('Accept-Encoding', 'gzip, deflate, br');
        request.setHeader('canal', 'SF');
        request.setHeader('User', 'SF');
        request.setHeader('UUID', '123434');


        Map < String, Object> bodyMap = new Map < String, Object> ();

        bodyMap.put('file', base64Image);
        bodyMap.put('documentCharacteristic', documentCharacteristic);
        bodyMap.put('documentExtention', extention);
        bodyMap.put('documentVisibility', 'OUI');
        bodyMap.put('fromOcr', 'false');
        bodyMap.put('documentName', docName);
        bodyMap.put('documentType', docTypeId);
        
        System.debug('bodyMap: ');
        System.debug(bodyMap);

        string jsonstring = JSON.serialize(bodyMap);
/*        System.debug('jsonstring: ');
//        System.debug(jsonstring);


        String body = '        { ' +
        '"documentType": "CIN_ou_passeport", ' +
        '"documentExtention": "png", ' +
        '"documentName": "atos", ' +
        '"fromOcr": "true", ' +
        '"documentVisibility": "OUI", ' +
        '  "documentCharacteristic": [ ' +
        '        { ' +
        '              "businessReferenceType": "ORDER",   ' +
        '            "businessReference": "007"' +
        '        }' +
        '      ],'+

        '"file":' + '"'+ base64Image+'"'
        +'}'      ;
        
        System.debug('body : ');
        System.debug(body);

      //  outMap.put('thebodySent',body);
*/
        request.setBody(jsonstring);
        request.setTimeout(60000);
        HttpResponse response = http.send(request);

        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
            System.debug(JSON.serialize(response.getBody()));
                
            
            outMap.put('errorCode',response.getStatusCode() ) ;
            outMap.put('errorName',response.getStatus() ) ;

            outMap.remove('error');
            outMap.put('error','KO : '+ response.getStatusCode() + ' ' + response.getStatus() ) ;               
        } else {
            System.debug('OK: ');

           // outMap.put('getHeaderKeys',response.getHeaderKeys() ) ;
           Map<String,String> resultHeader = new Map<String,String>();

            for (String i : response.getHeaderKeys()) 
                resultHeader.put(i,response.getHeader(i));

            //outMap.put('resultHeader',resultHeader ) ;
            outMap.put('resultBody',response.getBody() ) ;
        }

    }catch (Exception e){
        outMap.put('errorCode',e.getTypeName() ) ;
        outMap.put('errorName',e.getMessage() ) ;

        outMap.remove('error');
        outMap.put('error','KO : '+ e.getMessage() + ' ' + e.getTypeName() ) ;

    }
    

}
}