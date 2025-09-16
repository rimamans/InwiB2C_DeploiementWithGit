global  class INWIB2C_SendSMSToPhone implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;
        try {
            if (methodName.equals('sendSMS')) {
                String orderId = (String) options.get('orderId');
                if (String.isBlank(orderId)) {
                    System.debug('L\'ID de commande est nul ou vide. Impossible de procéder à l\'envoi du SMS.');
                    return false;
                }
                
                // Call the sendSMS method
                sendSMS(inputMap, outMap, options);
            } else {
                result = false;
                System.debug('Méthode inconnue appelée: ' + methodName);
            }
        } catch (Exception e) {
            result = false;
            System.debug('Exception lors de l\'appel de la méthode: ' + e.getMessage());
        }
        return result;
    }

    public static void sendSMS(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        String orderId = (String) options.get('orderId');

        // Log message to verify method execution
        System.debug('Méthode sendSMS appelée pour orderId: ' + orderId);

        // Retrieve the first order's phone number
        String receiver;
        List<Order> orders = [SELECT Id, Account.vlocity_cmt__PersonContactId__r.Phone FROM Order WHERE Id = :orderId LIMIT 1];
        if (!orders.isEmpty()) {
            receiver = orders[0].Account.vlocity_cmt__PersonContactId__r.Phone;
                        System.debug('Phone Client: ' + receiver);

        } else {
            System.debug('Aucune commande trouvée avec l\'ID de commande fourni: ' + orderId);
            return;
        }

        // Query to retrieve sender details from custom metadata
        String sender = getSMSSender();
        if (sender == null) {
            System.debug('Aucun détail d\'expéditeur SMS trouvé dans les métadonnées.');
            return;
        }

        // Updated message (you can customize this message)
        String message = 'Cher(e) client(e), le remboursement a été bien effectué.';

        // Construct JSON body for SMS
        String body = '{ "content":"' + message + '", "sender": {"phoneNumber":"' + sender + '"}, "receiver": [{"phoneNumber":"' + receiver + '"}] }';
        System.debug('SMS Body: ' + body);

        // Call method to send SMS asynchronously
        sendSMSAsync(body, orderId);
    }

    @future(callout=true)
    public static void sendSMSAsync(String body, String orderId) {
        System.debug('Envoi SMS de manière asynchrone pour orderId: ' + orderId);

        if (String.isBlank(orderId)) {
            System.debug('L\'ID de commande est nul ou vide. Impossible de procéder à l\'envoi du SMS.');
            return;
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SOA_URL/inwi-api/communicationManagement/v1/communicationMessage');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('canal', 'SF');
        request.setHeader('user', UserInfo.getName());
        request.setHeader('uuid', 'SF');
        request.setBody(body);

        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 200) {
                System.debug('Erreur: ' + response.getStatusCode() + ' ' + response.getStatus());
            } else {
                System.debug(response.getBody());

                // Update SMS log status
                updateSMSLog(orderId, 'Envoyé');

                // Log success message
                System.debug('SMS envoyé avec succès pour l\'ID de commande: ' + orderId);
            }
        } catch (Exception e) {
            System.debug('Une exception s\'est produite lors de l\'envoi du SMS: ' + e.getMessage());

            // Update SMS log status in case of error
            updateSMSLog(orderId, 'Non envoyé');
        }
    }

   

    // Method to retrieve SMS sender information from custom metadata
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
     // Method to update SMS log status
     private static void updateSMSLog(String orderId, String status) {
        System.debug('Mise à jour du journal SMS. OrderId: ' + orderId + ', Statut: ' + status);

        if (String.isBlank(orderId)) {
            System.debug('L\'ID de commande est nul ou vide. Impossible de mettre à jour le journal SMS.');
            return;
        }
       else {
        System.debug('ID de commande.' +orderId );
        System.debug('status.' +status );

        INWIB2C_SMSLog__c smslog = new INWIB2C_SMSLog__c();
        
        smslog.INWIB2C_Date_d_envoie_SMS__c = System.today();
        smslog.INWIB2C_Statut_SMS__c = status;
        smslog.inwiB2C_OrderId__c = orderId;
        insert smslog;
        System.debug('After Insert.'  );

       } 
}}