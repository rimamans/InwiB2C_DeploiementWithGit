//DLE 05/10/2020 begin
public virtual with sharing class INWIB2C_HTTPCalloutBuilder { 
  @TestVisible private Boolean loggingErrorsEnabled = true;
    @TestVisible public String endpoint;
    @TestVisible private String method;
    @TestVisible private integer timeOut;
    @TestVisible private boolean compressed;
    @TestVisible private Integer expectedStatusCode;
    @TestVisible private Map<String, String> headers = new Map<String, String>();
    @TestVisible private String calloutErrorTitle = 'Callout Error';
    @TestVisible private HTTPResponse response;
    @TestVisible private String requestBody;
    @TestVisible public String responseBody;
    @TestVisible public Integer responseCode;
    @TestVisible public Boolean isSuccessful;
    public Enum Method {
      GET,
      POST,
      PATCH
    }
    
    public INWIB2C_HTTPCalloutBuilder setEndpoint(String endpoint){
      this.endpoint = endpoint;
      return this;
    }
    
    public INWIB2C_HTTPCalloutBuilder setMethod(Method methodType){
      this.method = methodType.name();
      return this;
    }
    
    public INWIB2C_HTTPCalloutBuilder setExpectedStatusCode(Integer expectedStatusCode){
      this.expectedStatusCode = expectedStatusCode;
      return this;
    }

     public INWIB2C_HTTPCalloutBuilder setTimeOut(Integer timeOut){
      this.timeOut = timeOut;
      return this;
    }
     public INWIB2C_HTTPCalloutBuilder setCompressed(boolean compressed){
      this.compressed = compressed;
      return this;
    }
    
    public INWIB2C_HTTPCalloutBuilder addHeader(String key, String value){
      this.headers.put(key, value);
      return this;
    }
    
    public INWIB2C_HTTPCalloutBuilder setBody(String body){
      this.requestBody = body;
      return this;
    }
    
    public INWIB2C_HTTPCalloutBuilder updateErrorTitle(String title){
      this.calloutErrorTitle += ': ' + title;
      return this;
    }
    
    public INWIB2C_HTTPCalloutBuilder disableErrorLogging(){
      this.loggingErrorsEnabled = false;
      return this;
    }
    
    public INWIB2C_HTTPCalloutBuilder sendCallout(){
       String body = null;
       HttpRequest req = new HttpRequest();
       HTTPResponse resp = new HTTPResponse();
       req.setEndpoint(this.endpoint);
         req.setMethod(this.method);
       if(this.timeOut != null) req.setTimeout(this.timeOut);
       if(this.compressed != null) req.setCompressed(this.compressed);
       for(String key: this.headers.keySet()){
          req.setHeader(key, this.headers.get(key));
       }
       system.debug('######## before sending the request what is the endpoint : ' + endpoint);
         if(this.requestBody != null)req.setBody(this.requestBody);
         Http http = new Http();
        system.debug('######## Request : '+req);
        //##LMO - 25/06/2019 - Start Catch Failed Callout for Interface LOGs##
        try{
            resp = http.send(req);
        }catch(Exception e){
            requestBody = (this.requestBody != null) ? this.requestBody : '';
            responseBody = e.getMessage()+ 'Line NUmber ' + e.getLineNumber();
            endpoint = (this.endpoint != null) ? this.endpoint : '';
        }
        try{
            processResponse(resp);  
        }catch(Exception e){
            requestBody = (this.requestBody != null) ? this.requestBody : '';
            responseBody = e.getMessage()+ 'Line NUmber ' + e.getLineNumber();
            endpoint = (this.endpoint != null) ? this.endpoint : '';
        }
        try{
         INWIB2C_InsertSynchInterfaceLog.execute(requestBody,responseBody,endpoint) ; 
        }catch(Exception e){
          System.debug('The following exception has occurred: ' + e.getMessage());
        }
        //##LMO - 25/06/2019 - Finish Catch Failed Callout for Interface LOGs##
        system.debug('####### afer processing the response ####### : ' + this) ; 
        return this;  
     }
    
    @TestVisible private void processResponse (HTTPResponse res){
        this.response = res;
        system.debug('######## Response ' +this.response );
        this.responseBody = this.response.getBody();
        this.responseCode = this.response.getStatusCode();
        this.isSuccessful = (this.responseCode == this.expectedStatusCode);
       
        if(!this.isSuccessful && loggingErrorsEnabled){
          system.debug(this.calloutErrorTitle+': '+this.responseBody); 
                /** Log for Debug unsuccessful Suspend Orders**/  
         if(endpoint.contains('XOM_SuspendSubscription')){   
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();          
                String[] toAddresses = new String[] {'elhaddad.amine@gmail.com','larbi.mouhibbi@gmail.com'};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Log for unsuscessfull Suspended subscription request');
                mail.setPlainTextBody('responsebody :  \n' + responseBody + '\n' + '\n' + 'calling endpoint XOM_SuspendSubscription with Subscriton id : \n ' + endpoint);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            }
        } 
        else{
           parseBody();  
            /** Log for Debug successful Suspend Orders**/ 
           if(endpoint.contains('XOM_SuspendSubscription')){   
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();          
                String[] toAddresses = new String[] {'elhaddad.amine@gmail.com','larbi.mouhibbi@gmail.com'};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Log for suscessfull Suspended subscription request');
                mail.setPlainTextBody('responsebody :  \n' + responseBody + '\n' + '\n' + 'calling endpoint XOM_SuspendSubscription with Subscriton id : \n ' + endpoint);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            }
        }  
    }
   
    protected virtual void parseBody(){}
    
    public Map<String, Object> deserializeJsonBody(){
      return (Map<String,Object>) JSON.deserializeUntyped(this.responseBody);
    }
}
//DLE 05/10/2020 end