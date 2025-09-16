public with sharing class inwiCGC_OTPController {
    @AuraEnabled(cacheable=false)
    public static Map<String, Object> generateOtpLwc(String mdn, String mode, String canal, String email, String orderId, String requestResilId) {
        Map<String, Object> response = new Map<String, Object>();
        try {
            if (String.isBlank(mode)) mode = 'sms';
            String rand = String.valueOf(Math.abs(Crypto.getRandomInteger()));
            String otp = rand.substring(0, 6);
            String message = 'Cher client, afin de valider votre demande, veuillez communiquer ce code ' + otp + ' à votre conseiller client inwi.';
            Datetime dateNow = Datetime.now();
            InwiB2C_OTP__c newOtp = new InwiB2C_OTP__c(
                InwiB2C_DateCreation__c   = dateNow,
                InwiB2C_DateExpiration__c = dateNow.addSeconds(300),
                InwiB2C_OTP__c            = Decimal.valueOf(otp),
                InwiB2C_StatutOtp__c      = 1,
                InwiB2C_Sending_Mode__c   = mode
            );
            if ((mode == 'sms' || mode == 'undefined') && !String.isBlank(mdn)) {
                try {
                    INWIB2C_SMSPush__mdt pushsms = [
                        SELECT password__c, login__c, Sender__c, creator__c
                        FROM INWIB2C_SMSPush__mdt
                        WHERE Sender__c = 'Notifinwi'
                        LIMIT 1
                    ];
                    String body = '{"CSOperationInfo":{"channel":"SFB2C","uuid":"3fcf5423-c997-eed5-3cd3-e947547d8b97","user":"' + UserInfo.getName() + '"},"CSSendSMSInteraction":{"CSSMS":{"message":"' + message + '","password":"' + pushsms.password__c + '","login":"' + pushsms.login__c + '","from":"' + pushsms.Sender__c + '","creator":"' + pushsms.creator__c + '","to":"' + mdn + '"}}}';
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint('callout:SOA_URL/CSInfrastructureMgm/NotificationMgmRest/sendPushSMS');
                    request.setMethod('POST');
                    request.setHeader('Content-Type','application/json;charset=UTF-8');
                    request.setHeader('channel','SFB2C');
                    request.setHeader('user', UserInfo.getName());
                    request.setHeader('uuid','111-888-999-666');
                    request.setBody(body);
                    http.send(request);
                    newOtp.InwiB2C_MDN__c = mdn;
                } catch (Exception e) {}
            } else if (mode == 'email' && !String.isBlank(email)) {
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                semail.setPlainTextBody(message);
                semail.setSubject('Vérification OTP');
                semail.setReplyTo('noreply@inwi.ma');
                semail.setSenderDisplayName('Support Inwi');
                semail.setToAddresses(new String[]{ email });
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ semail });
                newOtp.InwiB2C_Email__c = email;
            }
            insert newOtp;
            if (!String.isBlank(orderId)) {
                Order order = [SELECT Id, InwiB2C_OTP__c FROM Order WHERE Id = :orderId LIMIT 1];
                order.InwiB2C_OTP__c = newOtp.Id;
                update order;
            }
            if (!String.isBlank(requestResilId)) {
                InwiB2C_Demande_de_resiliation__c dr = [SELECT Id, InwiB2C_OTP__c FROM InwiB2C_Demande_de_resiliation__c WHERE Id = :requestResilId LIMIT 1];
                dr.InwiB2C_OTP__c = newOtp.Id;
                update dr;
            }
            response.put('success', true);
            response.put('message', 'OTP envoyé avec succès');
            response.put('otpId', newOtp.Id);
        } catch (Exception e) {
            response.put('success', false);
            response.put('message', e.getMessage());
        }
        return response;
    }

    @AuraEnabled(cacheable=false)
    public static Map<String, Object> verifyOtpLwc(String mdn, String codeOtp, String email, String canal) {
        Map<String, Object> out = new Map<String, Object>();
        Map<String, Object> input = new Map<String, Object>{
            'mdn' => mdn,
            'codeOtp' => codeOtp,
            'email' => email,
            'canal' => canal
        };
        Map<String, Object> opts = new Map<String, Object>();
        Boolean called = InwiB2C_OTP.Verifie(input, out, opts);
        Boolean ok = (out.containsKey('otpOk') && (Boolean) out.get('otpOk') == true);
        return new Map<String, Object>{
            'called' => called,
            'ok'     => ok,
            'idOTP'  => out.get('idOTP')
        };
    }
}