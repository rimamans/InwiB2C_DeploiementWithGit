global with sharing   class inwiB2C_InvoiceIntegration  implements vlocity_cmt.VlocityOpenInterface{
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
			
        Boolean result = true;
			
        try{
			
            if(methodName.equals('getInvoice')){
                getInvoice(inputMap, outMap, options);
			
             // your implementation, use outMap to send response back to OmniScript                                                                  
			
            }else {
			
            // your implementation, use outMap to send response back to OmniScript                   
			
            }                              
			
        } catch(Exception e){result = false;
			        
        }
			 
        return result;
			      
   }

   public static void getInvoice(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug(JSON.serialize(inputMap));

        System.debug('in getInvoice');

        String invoiceId = (String) inputMap.get('invoiceId');


        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SOA_URL/inwi-api/documentManagement/v1/document/'+ invoiceId + '?type=invoice');


            request.setMethod('GET');
            
            request.setHeader('canal', 'SF');
            request.setHeader('user', 'SF');
            request.setHeader('uuid', INWIB2C_GenerateTransactionCode.generate());
            request.setTimeout(60000);

            HttpResponse response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
                    
                
                outMap.put('errorCode',response.getStatusCode() ) ;
                outMap.put('errorName',response.getStatus() ) ;

                outMap.remove('error');
                outMap.put('error','KO' ) ;

                    
                    
                    
            } else {
                System.debug('OK: ');

                // Transformation en Base64 pour réponse dans le JSON
                String result = EncodingUtil.Base64Encode( response.getBodyAsBlob()  );

                outMap.put('pdf',result ) ;
            
            }

        }catch (Exception e){
            outMap.put('errorCode',e.getTypeName() ) ;
            outMap.put('errorName',e.getMessage() ) ;

            outMap.remove('error');
            outMap.put('error','KO' ) ;

        }
        

   }
    

}