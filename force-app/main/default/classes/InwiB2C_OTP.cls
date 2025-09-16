/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class InwiB2C_OTP implements vlocity_cmt.VlocityOpenInterface {
   
  global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

 try{

   if(methodName.equals('GenerateOtp')){
          
     return GenerateOtp(inputMap,outMap,options);
    } else if(methodName.equals('Verifie')){
     return Verifie(inputMap,outMap,options);
    }
    else{
     return false;
    }    

      
  

 } catch (Exception e){

   return false;

 }


}


global boolean GenerateOtp( Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
  
  String canal  = (String) inputMap.get('canal');
  String mdn  = (String) inputMap.get('mdn');
  String mode = (String) inputMap.get('mode');
  String email = (String) inputMap.get('email');
  String orderid = (String) inputMap.get('orderid');
  String requestresilid = (String) inputMap.get('requestresilid');
  // //Y_MH MGEN3675A-Eclipse_Offre 5G Home B2C_LotA begin
  // String service = (String) inputMap.get('service') ; 
  // //Y_MH MGEN3675A-Eclipse_Offre 5G Home B2C_LotA end 

  

  Map<String, Object> result = new Map<String, Object>();
  String rand = string.valueof(Math.abs(Crypto.getRandomInteger()));
  String otp = rand.substring(0,6);
  result.put('OTP', otp);
  system.debug(result);
  
  // //Y_MH MGEN3675A-Eclipse_Offre 5G Home B2C_LotA begin
  // String message = '';
  // if(service == '5G') {
  //    message = 'Cher client, afin de valider votre demande, veuillez communiquer ce  code OTP 5G ' + otp + ' à votre conseiller client inwi.';
  // } else {
  //    message = 'Cher client, afin de valider votre demande, veuillez communiquer ce  code ' + otp + ' à votre conseiller client inwi.';
  // }
  //  //Y_MH MGEN3675A-Eclipse_Offre 5G Home B2C_LotA end 
  String message = 'Cher client, afin de valider votre demande, veuillez communiquer ce  code ' + otp + ' à votre conseiller client inwi.';
        
    // String message = otp;
       //  Decimal  StOtp =1;

     /*List<vlocity_cmt__Subscription__c>  getIdSub = new List<vlocity_cmt__Subscription__c>();
    
     if(!Test.isRunningTest()){
          getIdSub= [select Id, Inwib2c_Num_ro_de_la_ligne__c from vlocity_cmt__Subscription__c where Inwib2c_Num_ro_de_la_ligne__c = :mdn and inwiB2C_Statut__c = 'InwiB2C_Active' limit 1 ];
       }else{
         vlocity_cmt__Subscription__c newSubsc1=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='testNumber',Inwib2c_Num_ro_de_la_ligne__c='212123456789',Name='TEST',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active');
        
        getIdSub.add(newSubsc1);
     }
    
    
    Datetime dateNow = Datetime.now();
    InwiB2C_OTP__c newOtp = new InwiB2C_OTP__c(InwiB2C_DateCreation__c = dateNow,InwiB2C_DateExpiration__c = dateNow.addSeconds(300),InwiB2C_OTP__c = Decimal.valueOf(otp),InwiB2C_StatutOtp__c =StOtp,InwiB2C_Sending_Mode__c=mode);
     if(getIdSub.size() > 0){
         newOtp.InwiB2C_Subscription__c = getIdSub[0].Id;
     }
  
     */
    


    
   /* List<InwiB2C_OTP__c> getSt =[ SELECT Id,  InwiB2C_StatutOtp__c FROM InwiB2C_OTP__c WHERE  ( InwiB2C_DateExpiration__c < :dateNow)
                                  ];
     List<InwiB2C_OTP__c> studList =new List <InwiB2C_OTP__c>();
    for(InwiB2C_OTP__c UPotp : getSt){
    UPotp.InwiB2C_StatutOtp__c= 0;
        studList.add(UPotp);
    }
    */
     

    
     //outMap.put('OTP',otp);
  
  Datetime dateNow = Datetime.now();


  InwiB2C_OTP__c OtpStatut = new InwiB2C_OTP__c();  
  if (canal == 'Televente' && mdn != '') {
    List<InwiB2C_OTP__c> otpList = [SELECT Id, InwiB2C_StatutOtpTelevent__c 
                                     FROM InwiB2C_OTP__c 
                                     WHERE InwiB2C_MDN__c = :mdn 
                                     ORDER BY CreatedDate DESC 
                                     LIMIT 1];
    if (!otpList.isEmpty()) {
        OtpStatut = otpList[0];  
    } else {
        OtpStatut = new InwiB2C_OTP__c(); 
    }
}
  InwiB2C_OTP__c newOtp = new InwiB2C_OTP__c(InwiB2C_DateCreation__c = dateNow,InwiB2C_DateExpiration__c = dateNow.addSeconds(300),InwiB2C_OTP__c = Decimal.valueOf(otp),InwiB2C_StatutOtp__c =1,InwiB2C_Sending_Mode__c=mode);
  if(mode=='sms' && mdn!='' || mode=='undefined' && mdn!=''){
    try{
      INWIB2C_SMSPush__mdt pushsms = [SELECT password__c,login__c,Sender__c,creator__c FROM INWIB2C_SMSPush__mdt WHERE Sender__c ='Notifinwi' limit 1];

      // String body='{ "content":"'+message+'", "receiver": [{"phoneNumber":"'+mdn+'"}]' + ',"sender": {"phoneNumber": "220"}}';
      String body='{"CSOperationInfo":{"channel": "SFB2C","uuid": "3fcf5423-c997-eed5-3cd3-e947547d8b97","user": "'+UserInfo.getName()+'"},"CSSendSMSInteraction":{"CSSMS":{ "message":"'+message+'","password":"'+pushsms.password__c+'" , "login":"'+pushsms.login__c+'", "from":"'+pushsms.Sender__c+'", "creator":"'+pushsms.creator__c+'" ,"to":"'+mdn+'"}}}';
      system.debug(body);
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('callout:SOA_URL/CSInfrastructureMgm/NotificationMgmRest/sendPushSMS');
      request.setMethod('POST');
      request.setHeader('Content-Type','application/json;charset=UTF-8');
      request.setHeader('channel', 'SFB2C');
      request.setHeader('user', UserInfo.getName());
      request.setHeader('uuid', '111-888-999-666');
      
      request.setBody(body);
  
      // Send the request, and return a response
      HttpResponse res = http.send(request);
      system.debug( res);
      system.debug( 'body' + body);

    }catch(Exception e) {
      if (canal =='Televente') {
        OtpStatut.InwiB2C_StatutOtpTelevent__c = 'Non authentifié-Code non reçu';
        update OtpStatut;
      }
      System.debug('The following exception has occurred: TEST' + e.getMessage());
  
    }
    newOtp.InwiB2C_MDN__c = mdn;

  }else if(mode=='email' && email!=''){

      Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
      semail.setPlainTextBody(message);
      semail.setSubject('Vérification OTP');
      semail.setReplyTo('noreply@inwi.ma');
      semail.setSenderDisplayName('Support Inwi');
      String[] sendTo = new String[]{ email };
      semail.setToAddresses(sendTo);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ semail });
      newOTP.InwiB2C_Email__c=email;
  }

  system.debug(orderid);
  insert newOTP;
if(orderid!='' && orderid!='undefined' && orderid!=null ){
  Order order = [select Id,InwiB2C_OTP__c from Order where Id = :orderid LIMIT 1];
  order.InwiB2C_OTP__c = newOtp.Id;
  update order;
}
//CHB 24/08/2023

if(requestresilid!='' && requestresilid!='undefined' && requestresilid!=null ){
  system.debug( requestresilid);
  InwiB2C_Demande_de_resiliation__c Demande_de_resiliationList = [select Id,InwiB2C_OTP__c from InwiB2C_Demande_de_resiliation__c where Id =: requestresilid LIMIT 1];
  Demande_de_resiliationList.InwiB2C_OTP__c = newOtp.Id;
  update Demande_de_resiliationList;
}
  //newOrd.InwiB2C_OTP__c = newOTP.Id;
  //insert newOrd;

  // update getSt;
  //update getIdOrd;
    
return true;
}



public static boolean Verifie(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
     String canal = null;
     String mdn = null;
     Decimal SOtp = null;
     String email = null;
     if(inputMap.get('mdn')!=null)
         mdn = (String) inputMap.get('mdn');
     if(inputMap.get('codeOtp') != null ){
         SOtp  = Decimal.valueOf((String)inputMap.get('codeOtp'));
     }
     if(inputMap.get('email') != null ){
      email = (String) inputMap.get('email');
  }
  if(inputMap.get('canal') != null ){
    canal = (String) inputMap.get('canal');
  }


      system.debug(mdn);
      system.debug(SOtp);
      system.debug(email);
      system.debug(canal);
     Datetime dateNow = Datetime.now();

     InwiB2C_OTP__c OtpStatut = new InwiB2C_OTP__c();  
     OtpStatut = [SELECT Id,InwiB2C_StatutOtpTelevent__c FROM InwiB2C_OTP__c WHERE   InwiB2C_MDN__c =:mdn ORDER by CreatedDate desc limit 1];
    
     List<InwiB2C_OTP__c> optList = [SELECT Id, InwiB2C_Otp__c FROM InwiB2C_OTP__c WHERE InwiB2C_Otp__c =:SOtp AND InwiB2C_MDN__c =:mdn and InwiB2C_DateExpiration__c >:dateNow order by CreatedDate desc limit 1];
     system.debug(optList);
     List<InwiB2C_OTP__c> testOTP = [SELECT Id,InwiB2C_Otp__c FROM InwiB2C_OTP__c WHERE  InwiB2C_Otp__c =:SOtp and InwiB2C_Email__c =:email and InwiB2C_DateExpiration__c >:dateNow order by CreatedDate desc limit 1];
     system.debug(testOTP);
     //Decimal baseOTP = (Decimal) testOTP[0].InwiB2C_Otp__c;
     if(optList.size() > 0 || testOTP.size() > 0 ){
      outMap.put('otpOk', true);
      /*chb 04/04/2024 Ano B-15306 begin */
      outMap.put('idOTP', optList[0].Id);
      /*chb 04/04/2024 Ano B-15306 end */
      if (canal =='Televente') {
        OtpStatut.InwiB2C_StatutOtpTelevent__c = 'Authentifié';
        update OtpStatut;
      }
     }else{
      outMap.put('otpOk', false);
      if (canal =='Televente') {
        OtpStatut.InwiB2C_StatutOtpTelevent__c = 'Non authentifié-Code erroné';
      update OtpStatut;
      }
     }
     //outMap.put('otpOk', optList.size() > 0);
    
     return true;
    
  
 }

    
}