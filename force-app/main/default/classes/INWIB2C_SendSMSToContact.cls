global with sharing class INWIB2C_SendSMSToContact implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;
        try {
            if (methodName.equals('sendSMS')) {
                String IdContact = (String) options.get('IdContact');
                if (String.isBlank(IdContact)) {
                    System.debug('L\'ID de contact est nul ou vide. Impossible de procéder à l\'envoi du SMS.');
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
        String IdContact = (String) options.get('IdContact');

        // Log message to verify method execution
        System.debug('Méthode sendSMS appelée pour IdContact: ' + IdContact);

        // Retrieve the contact's phone number
        String receiver;
        List<Contact> contacts = [SELECT Id, InwiB2C_Num_ro_de_contact__c FROM Contact WHERE Id = :IdContact LIMIT 1];
        if (!contacts.isEmpty()) {
            receiver = contacts[0].InwiB2C_Num_ro_de_contact__c;
        } else {
            System.debug('Aucun contact trouvé avec l\'ID de contact fourni: ' + IdContact);
            return;
        }

        // Query to retrieve sender details from custom metadata
        String sender = getSMSSender();
        if (sender == null) {
            System.debug('Aucun détail d\'expéditeur SMS trouvé dans les métadonnées.');
            return;
        }

        // Updated message (you can customize this message)
        String message = 'CA fournir par la MOA';

        // Construct JSON body for SMS
        String body = '{ "content":"' + message + '", "sender": {"phoneNumber":"' + sender + '"}, "receiver": [{"phoneNumber":"' + receiver + '"}] }';
        System.debug('SMS Body: ' + body);

        // Call method to send SMS asynchronously
        sendSMSAsync(body, IdContact);
    }

    @future(callout=true)
    public static void sendSMSAsync(String body, String IdContact) {
        System.debug('Envoi SMS de manière asynchrone pour IdContact: ' + IdContact);

        if (String.isBlank(IdContact)) {
            System.debug('L\'ID de contact est nul ou vide. Impossible de procéder à l\'envoi du SMS.');
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
                updateSMSLog(IdContact, 'Envoyé');

                // Log success message
                System.debug('SMS envoyé avec succès pour l\'ID de contact: ' + IdContact);
            }
        } catch (Exception e) {
            System.debug('Une exception s\'est produite lors de l\'envoi du SMS: ' + e.getMessage());

            // Update SMS log status in case of error
            updateSMSLog(IdContact, 'Non envoyé');
        }
    }

    // Method to update SMS log status
    private static void updateSMSLog(String IdContact, String status) {
        System.debug('Mise à jour du journal SMS. IdContact: ' + IdContact + ', Statut: ' + status);

        if (String.isBlank(IdContact)) {
            System.debug('L\'ID de contact est nul ou vide. Impossible de mettre à jour le journal SMS.');
            return;
        }

        INWIB2C_SMSLog__c smslog = new INWIB2C_SMSLog__c(
           
            INWIB2C_Date_d_envoie_SMS__c = System.today(),
            INWIB2C_Statut_SMS__c = status


        );
        try {
            insert smslog;
        } catch (DmlException e) {
            System.debug('Erreur lors de l\'insertion du journal SMS: ' + e.getMessage());
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
}