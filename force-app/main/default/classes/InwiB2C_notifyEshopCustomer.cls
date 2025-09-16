global with sharing class InwiB2C_notifyEshopCustomer implements vlocity_cmt.VlocityOpenInterface  {

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        Boolean result = true;

        try{

            if (methodName.equals('notifyEshopCustomer')){
                notify_eshopCustomer(inputMap, outMap, options);

             

            } 

        } catch (Exception e){

            result = false;

        }

        return result;
    }
    public static void notify_eshopCustomer(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {


        String mdn = (String) inputMap.get('mdn');
        String email = (String) inputMap.get('email');
        String orderid = (String) inputMap.get('orderid');
      
      
        Map<String, Object> result = new Map<String, Object>();
    
        system.debug(result);
        Blob randomBytes = Crypto.generateAESKey(128); // Generate random bytes
        String globalKey = EncodingUtil.base64Encode(randomBytes);
        
        System.debug('Global Key: ' + globalKey);
       
        

        
        String message = 'Cher client, Vous pouvez récupérez votre pack au niveau de l’agence';
              
        
          
      
           if(mdn!=''){
          try{
            String body='{"sender":{"phoneNumber": "220"},"receiver":[{"phoneNumber":"'+mdn+'"}], "content":"' +message+'", "requestId":"'+orderid+'","status":1}';
            system.debug(body);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SOA_URL/inwi-api/communicationManagement/v1/communicationMessage');
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json;charset=UTF-8');
            request.setHeader('channel', 'SF');
            request.setHeader('user', UserInfo.getName());
            request.setHeader('uuid', '111-888-999-666');
            request.setBody(body);
            
            // Send the request, and return a response
            HttpResponse res = http.send(request);
            system.debug( res);
          }catch(Exception e) {
            System.debug('The following exception has occurred: TEST' + e.getMessage());
          }
         
      
         }
         if(email!=''){
      
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            semail.setPlainTextBody(message);
            semail.setSubject('Eshop Notification');
            //semail.setReplyTo('noreply@inwi.ma');
            semail.setSenderDisplayName('Support Inwi');
            String[] sendTo = new String[]{ email };
            semail.setToAddresses(sendTo);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ semail });
        }
      
        system.debug(orderid);
        outMap.put('NotificationResult', mdn);
       
      
    }
}