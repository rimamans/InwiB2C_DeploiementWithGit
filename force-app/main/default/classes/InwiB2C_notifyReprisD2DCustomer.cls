/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-03-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class InwiB2C_notifyReprisD2DCustomer implements vlocity_cmt.VlocityOpenInterface  {

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        Boolean result = true;

        try{

            if (methodName.equals('notifyD2DCustomer')){
                notify_D2DCustomer(inputMap, outMap, options);

             

            } 

        } catch (Exception e){

            result = false;

        }

        return result;
    }
    public static void notify_D2DCustomer(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {

       // Récupérer l'utilisateur actuel
       Id currentUserId = UserInfo.getUserId();
        
       // Récupérer le profil de l'utilisateur actuel
       User currentUser = [SELECT Id, Name, Profile.Name FROM User WHERE Id = :currentUserId LIMIT 1];
       String currentUserName = currentUser.Name;
       String currentUserProfileName = currentUser.Profile.Name;

       // Afficher les informations de l'utilisateur actuel dans les journaux de débogage
       System.debug('Current User ID: ' + currentUserId);
       System.debug('Current User Name: ' + currentUserName);
       System.debug('Current User Profile Name: ' + currentUserProfileName);

 

        

        String mdn = (String) inputMap.get('mdn');
        String posId = (String) inputMap.get('posId');
        String orderid = (String) inputMap.get('orderid');
      
      
        Map<String, Object> result = new Map<String, Object>();
    
        system.debug(result);
        Blob randomBytes = Crypto.generateAESKey(128); // Generate random bytes
        String globalKey = EncodingUtil.base64Encode(randomBytes);
        
        System.debug('Global Key: ' + globalKey);
       
        
        String orderNumber = '';

        if (!String.isBlank(orderid)) {
            List<Order> orders = [SELECT Id, OrderNumber FROM Order WHERE Id = :orderid LIMIT 1];
            if (orders.size() > 0) {
                orderNumber = orders[0].OrderNumber;
            }
        }

     // Récupérer l'e-mail à partir de AccountContactRelation en tant qu'administrateur
     String email = '';
     List<AccountContactRelation> accountContactRelations = [SELECT Id, contact.inwicgc_usercgc__r.email FROM AccountContactRelation WHERE AccountId = :posId AND Roles ='inwiB2C_ChefEquipe' LIMIT 1];
     if (accountContactRelations.size() > 0) {
         email = accountContactRelations[0].contact.inwicgc_usercgc__r.email;
         System.debug('email user CGC : ' + email);
     }

        String message = 'La commande "' + orderNumber + '" est validée par le back office. Merci de procéder à la livraison au client';

      
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
            semail.setSubject('Door to Door Notification');
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