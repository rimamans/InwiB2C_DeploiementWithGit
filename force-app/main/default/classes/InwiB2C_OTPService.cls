global with sharing class InwiB2C_OTPService implements vlocity_cmt.VlocityOpenInterface{

    global static final String ARGUMENTS = 'arguments';

    global static Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
        Boolean result = true;
        try
        {
            if(methodName.equals('sendOTP')){
              
                output.put('result',(map<String,Object>)sendOTP((String)inputs.get('recordId'),(String)inputs.get('otp'),(String)inputs.get('contact')));      
            
            }        
             else if(methodName.equals('resourceUrlOTP')){
           			 List<Object> arguments = (List<Object>)inputs.get(ARGUMENTS);
              		 output.put('result',(String)resourceUrlOTP());        
        } 
                                                   
            
        } catch(Exception e){
                        
        result = false;
                    
        }
            
       return result;
            
}

    @AuraEnabled(cacheable=true)
    public static  map<String,Object> sendOTP(String requestId,String Otp,String contact) {
       
        map<String,Object> result= new map<String,Object>();
        String receiver;
       
        List<INWIB2C_SMSSender__mdt> senderList = [Select Sender__c from INWIB2C_SMSSender__mdt];
       
        if(contact == null || contact=='')
            {List<vlocity_cmt__Subscription__c> subscriptions = [Select Inwib2c_Num_ro_de_la_ligne__c From vlocity_cmt__Subscription__c
                                                                Where Id=: requestId limit 1];
                                                                
            receiver = subscriptions[0].Inwib2c_Num_ro_de_la_ligne__c;
            }
         else 
            receiver = contact;
            
      
         
        String sender = senderList[0].Sender__c;
        String message = 'Cher client, afin de valider votre demande, veuillez communiquer ce  code '+OTP+' à votre conseiller client inwi.';
        String body='{ "content":"'+message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+receiver+'"}] }';
        System.debug('body'+body);
        SendMsg(body);
      
            
        result.put('error',false);
      
        
        
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static String resourceUrlOTP() {
        string URL=PageReference.forResource('OtpSmsService').getUrl();
        return   URL.substringBefore('?');
 
    }
    @future(callout=true)
    public static  void SendMsg(String body)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        map<String,Object> result= new map<String,Object>();
        request.setEndpoint('callout:SOA_URL/inwi-api/communicationManagement/v1/communicationMessage');
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        request.setHeader('canal', 'SF');
        request.setHeader('user', UserInfo.getName());
        request.setHeader('uuid', 'SF');
        request.setBody(body);
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 200)
            {  
                System.debug('Erreur: ' +response.getStatusCode() + ' ' + response.getStatus());
               
            } 
            else 
            {
               
                System.debug(response.getBody());
             
            }
        } catch(Exception e){
            System.debug('An exception occurred: ' + e.getMessage());
        }
     
      
    } 
}