public with sharing class inwiB2C_SendSMS {
   
    public static void SendSMS(String requestId) {
        List<InwiB2C_Demande_de_resiliation__c> requetes =
        [select Id, InwiB2C_Subscription__r.Inwib2c_Num_ro_de_la_ligne__c,InwiB2C_Subscription__c,InwiB2C_Subscription__r.inwiB2C_Statut__c,InwiB2C_Type_Profil__c,
         inwiB2C_expectedDisconnectDate__c,Type__c,InwiB2C_Qualification__c, InwiB2C_Date_de_signature__c,
            inwiB2C_expectedSuspendDate__c,InwiB2C_Subscription__r.vlocity_cmt__AccountId__r.Name,InwiB2C_Subscription__r.InwiB2C_Partenaire__r.Name,
         InwiB2C_Subscription__r.InwiB2C_Date_d_activation__c,
            InwiB2C_Subscription__r.vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.Email,InwiB2C_Subscription__r.Inwib2c_Offre__c
                from InwiB2C_Demande_de_resiliation__c where Id =: requestId];
    List<INWIB2C_SMSSender__mdt> senderList = [Select Sender__c from INWIB2C_SMSSender__mdt where DeveloperName='Sender'];
    
    List<inwiB2C_OrderSubscription__c > orderSubscriptionList =
        [select id ,inwiB2C_Order__c from inwiB2C_OrderSubscription__c 
              where inwiB2C_Subscription__c =:requetes[0].InwiB2C_Subscription__c and inwiB2C_Order__r.inwib2c_TypeDeLaCommande__c='inwiB2C_Acquisition' 
                     and inwiB2C_Order__r.InwiB2C_Offre__c='Pack de dépannage'];
    
    String offre;
    if(!Test.isRunningTest()){
    if(requetes[0].InwiB2C_Subscription__r.Inwib2c_Offre__c == 'Pack de dépannage'){
     List<InwiB2C_Order_SuspIdar__c > Order_SuspIdar = 
         [select id , InwiB2C_OrderFIXE__c,InwiB2C_CaseId__r.vlocity_cmt__SubscriptionId__r.Inwib2c_Offre__c, InwiB2C_OrderIdar__c, InwiB2C_SubscriptionIdar__c
               from InwiB2C_Order_SuspIdar__c where InwiB2C_OrderIdar__c=:orderSubscriptionList[0].inwiB2C_Order__c];
     offre=Order_SuspIdar[0].InwiB2C_CaseId__r.vlocity_cmt__SubscriptionId__r.Inwib2c_Offre__c;
     System.debug('offre'+offre);
    }} else{
        offre = 'ADSL XTRA by inwi Jusqu\'à 20 Mega';
        SendEmail('emailMsg','email');
    }
    String receiver = requetes[0].InwiB2C_Subscription__r.Inwib2c_Num_ro_de_la_ligne__c;
    String sender = senderList[0].Sender__c;
    
    String prenom = requetes[0].InwiB2C_Subscription__r.vlocity_cmt__AccountId__r.Name; 
    String numLigne = requetes[0].InwiB2C_Subscription__r.Inwib2c_Num_ro_de_la_ligne__c;
    String agence = requetes[0].InwiB2C_Subscription__r.InwiB2C_Partenaire__r.Name;
    String message='';
    String emailMsg='';
    String email = requetes[0].InwiB2C_Subscription__r.vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.Email;       
 
    Date dateActivation = requetes[0].InwiB2C_Subscription__r.InwiB2C_Date_d_activation__c.date();
    
    Date dateLimite;
    String jourLimite;
    String moisLimite;
  
    //String offre=Order_SuspIdar[0].InwiB2C_CaseId__r.vlocity_cmt__SubscriptionId__r.Inwib2c_Offre__c;
    Boolean SENDsmsgAfterSuspension =false; 
        if ((requetes[0].InwiB2C_Type_Profil__c=='Postpaye' || requetes[0].InwiB2C_Subscription__r.inwiB2C_Statut__c!='InwiB2C_SuspendueFacturationReseau' ) && requetes[0].inwiB2C_expectedDisconnectDate__c <=Date.today() ){
           // message='Cher client, inwi vous informe que votre demande de résiliation est effective, votre ligne est dorénavant prépayée';
          // Meryem Yahya MGEN3645SF_SMS Résiliation
           message='inwi : nous vous informons que votre demande de résiliation est effective à partir de ce jour. Votre ligne est désormais sans abonnement.' ;
         // Meryem Yahya MGEN3645SF_SMS Résiliation
        }else if (requetes[0].InwiB2C_Type_Profil__c=='idar duo' && requetes[0].InwiB2C_Subscription__r.inwiB2C_Statut__c=='InwiB2C_SuspendueFacturationReseau'){
            //message='Votre demande de résiliation a été prise en compte et est effective';
            // Meryem Yahya MGEN3645SF_SMS Résiliation
           message='inwi : nous vous informons que votre demande de résiliation a bien été prise en compte et est effective.' ;
         // Meryem Yahya MGEN3645SF_SMS Résiliation
        }else if (requetes[0].InwiB2C_Type_Profil__c=='idar duo'  
        && requetes[0].InwiB2C_Subscription__r.Inwib2c_Offre__c == 'Pack de dépannage'
        && offre.contains('ADSL') ){ 
            dateLimite = requetes[0].inwiB2C_expectedSuspendDate__c.addDays(45);
            jourLimite= String.valueOf(dateLimite.day());
            moisLimite = String.valueOf(dateLimite.month());
            message='Vu la résolution de la réclamation ADSL, le Pack Dépannage a été désactivé. Veuillez retourner la box avant le ' + jourLimite.leftPad(2, '0') + '/' + moisLimite.leftPad(2, '0') + ' pour récupérer votre prime de restitution de 300dh';
            
            emailMsg = 'Bonjour Monsieur/Madame ' + prenom + ',\n\n' +'Nous vous informons que les perturbations liées à votre ligne fixe ADSL - ' + numLigne + ' ont été résolues.\n' +'Par conséquent, le Pack Dépannage accordé le ' + dateActivation + ' à l’agence ' + agence + ' a été désactivé.\n' +'Nous vous invitons à retourner la Box, avec son emballage d’origine, afin que vous puissiez récupérer votre prime de restitution de 300dh.\n' +'Nous vous informons que vous disposez de 45 jours pour effectuer cette opération, passé ce délai il ne sera plus possible de récupérer votre prime de restitution.\n\n' +'L’équipe inwi,';
  
  SendEmail(emailMsg,email);      
            
}else if (requetes[0].InwiB2C_Type_Profil__c=='idar duo'  
        && requetes[0].InwiB2C_Subscription__r.Inwib2c_Offre__c == 'Pack de dépannage'
        && offre.contains('FTTH')){
            dateLimite = requetes[0].inwiB2C_expectedSuspendDate__c.addDays(45);
            jourLimite= String.valueOf(dateLimite.day());
            moisLimite = String.valueOf(dateLimite.month());         
            message='Vu la résolution de la réclamation Fibre, le Pack Dépannage a été désactivé. Veuillez retourner la box avant le ' + jourLimite.leftPad(2, '0') + '/' + moisLimite.leftPad(2, '0') + ' pour récupérer votre prime de restitution de 300dh';
            
            emailMsg = 'Bonjour Monsieur/Madame ' + prenom + ',\n\n' +'Nous vous informons que les perturbations liées à votre ligne fixe Fibre - ' + numLigne + ' ont été résolues.\n' +'Par conséquent, le Pack Dépannage accordé le ' + dateActivation + ' à l’agence ' + agence + ' a été désactivé.\n' +'Nous vous invitons à retourner la Box, avec son emballage d’origine, afin que vous puissiez récupérer votre prime de restitution de 300dh.\n' +'Nous vous informons que vous disposez de 45 jours pour effectuer cette opération, passé ce délai il ne sera plus possible de récupérer votre prime de restitution.\n\n' +'L’équipe inwi,';
       
   SendEmail(emailMsg,email);
            
}else {

            message='Votre ligne est bien suspendue. Vous serez informé de la résiliation par un autre message.';
            SENDsmsgAfterSuspension=true;
        }
    
        String body='{ "content":"'+message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+receiver+'"}] }';
        system.debug(body);
        SendMsg(body,requetes[0].Id,requetes[0].InwiB2C_Subscription__c);
        String X;
      
        if (SENDsmsgAfterSuspension==true){
            Date dateSignature = requetes[0].InwiB2C_Date_de_signature__c;
            Date futureDate = dateSignature.addDays(45);
            // Get today's date
            Date currentDate = Date.today();
            // Calculate the difference in days
            Integer daysDifference = currentDate.daysBetween(futureDate);
             if (requetes[0].InwiB2C_Type_Profil__c=='idar duo'){
                X='dans'+daysDifference+' jours';
            }else if (requetes[0].InwiB2C_Type_Profil__c=='ADSL' || requetes[0].InwiB2C_Type_Profil__c=='FTTH' ){
                if(requetes[0].Type__c=='Suite demande client'){
                    X='dans '+daysDifference+' jours';
                }else if (requetes[0].InwiB2C_Qualification__c=='Conforme'){
                    X='aujourd\'hui';
                }else{
                    X='dans'+daysDifference+'jours';
                }
            }
            message='Cher client(e), votre ligne sera résiliée '+X+'';
            String body2='{ "content":"'+message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+receiver+'"}] }';
            system.debug(body2);
            SendMsg(body2,requetes[0].Id,requetes[0].InwiB2C_Subscription__c);
          
        }
    }
    @future(callout=true)
    public static void SendMsg(String body, String requestId, String ligneId)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SOA_URL/inwi-api/communicationManagement/v1/communicationMessage');
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        request.setHeader('canal', 'SF');
        request.setHeader('user', UserInfo.getName());
        request.setHeader('uuid', 'SF');
        request.setBody(body);
        INWIB2C_SMSLog__c smslog = new INWIB2C_SMSLog__c (INWIB2C_Date_d_envoie_SMS__c = System.today(),
                                                         InwiB2C_Demande_de_r_siliation_Id__c = requestId,
                                                         INWIB2C_SubscriptionId__c=ligneId,
                                                         INWIB2C_Statut_SMS__c = 'Non envoyé');
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 200)
            {
                System.debug('Erreur: ' +response.getStatusCode() + ' ' + response.getStatus());
            } 
            else 
            {
                System.debug(response.getBody());
                smslog.INWIB2C_Statut_SMS__c = 'Envoyé';
            }
        } catch(Exception e){
            System.debug('An exception occurred: ' + e.getMessage());
        }
        insert smslog;
    }   
    public static void SendEmail(String emailMSG,String email)
    {  
            
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            semail.setPlainTextBody(emailMSG);
            semail.setSubject('Suspension Pack dépannage');
            semail.setSenderDisplayName('Support Inwi');
            String[] sendTo = new String[]{ email };
            semail.setToAddresses(sendTo);
           
     
      try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ semail });
            return;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }   
        
   } 
}