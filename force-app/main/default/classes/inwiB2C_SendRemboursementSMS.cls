public with sharing class inwiB2C_SendRemboursementSMS {
    
    public inwiB2C_SendRemboursementSMS(id OrderId) {
        System.debug('Processus de traitement démarré.');
        
        // Récupérer les détails de l'Order avec l'ID fourni
        Order order = [SELECT id, Account.vlocity_cmt__PersonContactId__r.Phone 
                       FROM Order 
                       WHERE id = :OrderId];
        
        // Vérifier si l'Order a été trouvé
        if (order == null) {
            System.debug('Aucun order trouvé pour l\'ID fourni.');
            return;
        }
        
        // Récupérer le numéro de téléphone du destinataire à partir de l'Order
        String receiver = order.Account.vlocity_cmt__PersonContactId__r.Phone;
        
        // Récupérer les détails de l'expéditeur SMS depuis les métadonnées
        String sender = getSMSSender();
        
        // Message à envoyer
        String message = 'Cher(e) client(e), le remboursement a été bien effectué.';
        
        // Construire le corps JSON du SMS
        String body = '{ "content":"' + message + '", "sender": {"phoneNumber":"' + sender + '"}, "receiver": [{"phoneNumber":"' + receiver + '"}] }';
        System.debug(body);
        
        // Appeler la méthode pour envoyer le SMS de manière asynchrone
        SendMsg(body, order.id);
    }
    
    @future(callout=true)
    public static void SendMsg(String body, Id OrderId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SOA_URL/inwi-api/communicationManagement/v1/communicationMessage');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('canal', 'SF');
        request.setHeader('user', UserInfo.getName());
        request.setHeader('uuid', 'SF');
        request.setBody(body);
        
        INWIB2C_SMSLog__c smslog = new INWIB2C_SMSLog__c(
            INWIB2C_Date_d_envoie_SMS__c = System.today(),
            INWIB2C_Statut_SMS__c = 'Non envoyé'
        );
        
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 200) {
                System.debug('Erreur: ' + response.getStatusCode() + ' ' + response.getStatus());
            } else {
                System.debug(response.getBody());
                smslog.INWIB2C_Statut_SMS__c = 'Envoyé';
            }
        } catch (Exception e) {
            System.debug('Une exception s\'est produite: ' + e.getMessage());
        }
        
        insert smslog;
    }
    
    // Méthode pour récupérer le numéro de téléphone de l'expéditeur SMS à partir des métadonnées
    private static String getSMSSender() {
        List<INWIB2C_SMSSender__mdt> senderList = [
            SELECT Sender__c 
            FROM INWIB2C_SMSSender__mdt 
            LIMIT 1
        ];
        
        if (!senderList.isEmpty()) {
            return senderList[0].Sender__c;
        } else {
            System.debug('Aucun détail d\'expéditeur SMS trouvé dans les métadonnées.');
            return null;
        }
    }
}