public class inwiB2C_SendSMSRemboursementFMSEshop {
    @InvocableMethod
    public static void SendSMS(List<String> inputs) {
        System.debug('Inputs ' +	 inputs);

        List<INWIB2C_SMSSender__mdt> senderList = [Select Sender__c from INWIB2C_SMSSender__mdt];
        String receiver = (String) inputs[0].split(',')[0] ?? '';
        String sender = senderList[0].Sender__c;
        String message = (String) inputs[0].split(',')[1] ?? '';
        String orderId = (String) inputs[0].split(',')[2] ?? '';
        //String ligneId = (String) inputs[0].split(',')[3] ?? '';
        String clientId = (String) inputs[0].split(',')[3]?? '' ;

        String body='{ "content":"'+message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+receiver+'"}] }';
        system.debug(body);
        SendMsg(body,orderId,clientId);
        
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
                                                          inwiB2C_ClientId__c= clientId,inwiB2C_OrderId__c=orderId,
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