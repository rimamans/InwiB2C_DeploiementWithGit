/**
 * @description: ano B-14342
 * @last modified on  : 12-02-2024
 * @last modified by  : Chadia bani
**/
public class InwiB2C_SendSMSResilRequest {
    @InvocableMethod
    public static void SendSMSResilRequest(List<Id> requestId) {
        System.debug('process ok');
        List<InwiB2C_Demande_de_resiliation__c> requetes = [select Id, InwiB2C_Subscription__c,InwiB2C_Subscription__r.Inwib2c_Num_ro_de_la_ligne__c,InwiB2C_Statut_Resil__c,inwiB2C_Statut_d_approbation__c,InwiB2C_Date_pr_vue_de_r_siliation__c,InwiB2C_Type_Profil__c ,inwiB2C_expectedDisconnectDate__c, inwiB2C_expectedSuspendDate__c from InwiB2C_Demande_de_resiliation__c where Id in: requestId];
        List<Id> SubId= new List<Id>();
        List<String> SubMDN= new List<String>();

      /*B-14342 CHB Begin */
       // List<vlocity_cmt__Subscription__c> subscriptions = [Select Inwib2c_Num_ro_de_la_ligne__c From vlocity_cmt__Subscription__c
                                                           // Where Id in: SubId];
         List<INWIB2C_SMSSender__mdt> senderList = [Select Sender__c from INWIB2C_SMSSender__mdt];
            String sender = senderList[0].Sender__c;
            String receiver;
            String message = '';
            String messagerefused;
      for ( InwiB2C_Demande_de_resiliation__c reqList : requetes) {
             receiver = reqList.InwiB2C_Subscription__r.Inwib2c_Num_ro_de_la_ligne__c;
             //sender = senderList[0].Sender__c;
            // Date resildate = requetes[0].InwiB2C_Date_pr_vue_de_r_siliation__c;
            // Date todaydate = Date.today();
            // String messageapprooved = 'Cher client(e), votre ligne sera résiliée dans '+nbjours+' jours';
             messagerefused = 'Votre demande de résiliation n’est pas validée, prière de prendre contact avec votre boutique.';
            if(reqList.inwiB2C_Statut_d_approbation__c == 'Approuvée' ){
                if(reqList.InwiB2C_Statut_Resil__c =='En attente de résiliation'|| reqList.InwiB2C_Type_Profil__c=='Postpaye'){
                    Integer nbjoursResil = Date.today().daysBetween(reqList.inwiB2C_expectedDisconnectDate__c);
                    message = 'Cher client(e), votre ligne sera résiliée dans '+nbjoursResil+' jours';
                }else{
                    Integer nbjoursSusp = Date.today().daysBetween(reqList.inwiB2C_expectedSuspendDate__c);
                    if(nbjoursSusp==0){
                        message = 'Cher client(e), votre ligne sera suspendue aujourd\'hui';
                    }else{
                    message = 'Cher client(e), votre ligne sera suspendue dans '+ nbjoursSusp +' jours';}
                }
            }else if(reqList.inwiB2C_Statut_d_approbation__c == 'Refusée'){
                message = messagerefused;
            }
        
        
            String body='{ "content":"'+message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+receiver+'"}] }';
            system.debug(body);
            SendMsg(body,reqList.Id,reqList.InwiB2C_Subscription__c);
            
        } }
    /*B-14342 CHB End */
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
}