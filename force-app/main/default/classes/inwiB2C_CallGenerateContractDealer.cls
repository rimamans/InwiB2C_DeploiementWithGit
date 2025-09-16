global with sharing class inwiB2C_CallGenerateContractDealer implements vlocity_cmt.VlocityOpenInterface {
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> optionsMap) {
        if (methodName.equals('generateContractDealer')) {
            outputMap.put('result', generateContractDealer(inputMap));
            System.debug('result' + outputMap);
        } else if (methodName.equals('checkSubscription')) {
            outputMap.put('showButton', checkSubscription(inputMap));
        } else if (methodName.equals('updateTraceDuplicata')) {
            outputMap.put('result', updateTraceDuplicata(inputMap));
        }
        return true;
    }

    public Map<String,Object>  generateContractDealer(Map<String,Object> inp) {
        String req = (String) inp.get('requete');
        Map<String,Object> out =new  Map<String,Object>();
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setEndpoint('callout:SOA_URL/inwi-api/ServiceOrderManagement/v1/serviceOrder/editContractDealer');
            request.setMethod('POST');
request.setHeader('Accept-Encoding', 'gzip, deflate');
            request.setHeader('canal', 'SF');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('user', 'SF');
            request.setHeader('uuid', INWIB2C_GenerateTransactionCode.generate());
            request.setBody(JSON.serialize(inp));
            System.debug('body : ' + request.getBody());
            request.setTimeout(120000);

            if(!Test.isRunningTest()){
                response = http.send(request);
            }
            // Vérifier la taille de la réponse
    Blob responseBlob = response.getBodyAsBlob();
    Integer responseSize = responseBlob.size();
    System.debug('Response size: ' + responseSize + ' bytes');

    if (responseSize > 6000000) {
         out.put('result','La réponse API dépasse la limite autorisée de 6 Mo.' );
        throw new CalloutException('La réponse API dépasse la limite autorisée de 6 Mo.');
    }
               // Parse the JSON response
               if (response.getStatusCode() != 200) {
                   System.debug('The status code returned was not expected: ' +
                   response.getStatusCode() + ' ' + response.getStatus());
                   System.debug('responseapi : ' + response.getBody());
                       
                   
                   out.put('errorCode',response.getStatusCode() ) ;
                   out.put('errorName',response.getStatus() ) ;
                   out.remove('error');
                   out.put('error','KO : '+ response.getStatusCode() + ' ' + response.getStatus() ) ;
       
                       
               } else {
                   System.debug('OK: ');
                
                   Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                   System.debug('responseMap content: ' + responseMap.get('content'));
                   System.debug('responseMap name: ' + responseMap.get('name'));

                   Map<String,Object> result = new Map<String,Object>();

                   result.put('content',  responseMap.get('content'));
                   result.put('name',  responseMap.get('name'));
       
                   out.put('result',result );
                   
               }
        } catch (Exception e){
            out.put('errorCode',e.getTypeName() ) ;
            out.put('errorName',e.getMessage() ) ;
    
            out.remove('error');
            out.put('error','KO : '+ e.getMessage() + ' ' + e.getTypeName() ) ;
            
    
        }
        return out;
    }

    public Map<String,Object> checkSubscription(Map<String,Object> input) {
        String subId = (String) input.get('subscriptionId');
        vlocity_cmt__Subscription__c subsc = [ select id, inwiB2C_Statut__c, Inwib2c_Offre__c, InwiB2C_Contract__r.inwib2c_Identification__c, InwiB2C_Contract__r.inwib2c_Qualification__c from vlocity_cmt__Subscription__c where id = :subId ];
        // Contract contract = [ select id, inwib2c_Identification__c, inwib2c_Qualification__c from Contract where id  = :subsc.InwiB2C_Contract__c ];
        Boolean showButton = (
            subsc.Inwib2c_Offre__c.contains('Dealer') && 
            subsc.InwiB2C_Contract__r.inwib2c_Identification__c && 
            subsc.InwiB2C_Contract__r.inwib2c_Qualification__c &&
            subsc.inwiB2C_Statut__c == 'InwiB2C_Active'
        );
        Map<String,Object> output = new  Map<String,Object>();
        output.put('showButton', showButton);
        return output;
    }

    public Map<String,Object> updateTraceDuplicata(Map<String,Object> input) {
        String subsId = (String) input.get('subscriptionId');
        inwiB2C_TraceGenerateContractDealer__c trace = new inwiB2C_TraceGenerateContractDealer__c(
            inwiB2C_Subscription__c = subsId,
            inwiB2C_ContractDealerGenerated__c  = true
        );
        insert trace;

        INWIB2C_HIST_ACTION_LINE__c action = new INWIB2C_HIST_ACTION_LINE__c(
            inwiB2C_Action__c = 'generation duplicata dealer',
            inwiB2C_SubscriptionId__c = subsId
       );
        insert action;

        Map<String,Object> result = new Map<String,Object>{
            'action' => action.inwiB2C_Action__c,
            'subscription' => action.inwiB2C_SubscriptionId__c
        };
        return result;
    }
}