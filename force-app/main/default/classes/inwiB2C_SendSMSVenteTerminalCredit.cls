public  class inwiB2C_SendSMSVenteTerminalCredit {
    @InvocableMethod
    public static void SendSMS(List<Id> OrderIds) {

        System.debug('process ok');
        List<Order> orders = [select Id, inwiB2C_Num_dossier__c, AccountId , Account.InwiB2C_Num_ro_de_contact__c from Order where Id in: OrderIds];
  
        List<INWIB2C_SMSSender__mdt> senderList = [Select Sender__c from INWIB2C_SMSSender__mdt];

        String receiver = orders[0].Account.InwiB2C_Num_ro_de_contact__c ;
        String sender = senderList[0].Sender__c;

        String message = 'Félicitations! Votre demande de crédit N°'+orders[0].inwiB2C_Num_dossier__c+', a été acceptée par Wafasalaf. RDV à votre agence inwi pour finaliser la procédure et récupérer votre smartphone';


        String body='{ "content":"'+message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+receiver+'"}] }';
        system.debug(body);
        SendMsg(body,orders[0].Id,orders[0].AccountId);
        
    }
    
    @future(callout=true)
    public static void SendMsg(String body, String orderId, String clientId)
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
                                                          inwiB2C_OrderId__c = orderId, inwiB2C_ClientId__c=clientId,
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