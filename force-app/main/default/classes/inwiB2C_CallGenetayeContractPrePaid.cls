/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-31-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class inwiB2C_CallGenetayeContractPrePaid implements vlocity_cmt.VlocityOpenInterface {
    
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> optionsMap) {
        if (methodName.equals('generateContractPrePaid')) {
            //generateContractPrePaid(inputMap, outputMap);
            outputMap.put('result', generateContractPrePaid(inputMap));
        } else if (methodName.equals('checkSubscription')) {
            outputMap.put('showButton', checkSubscription(inputMap));
        }
          
        return true;
    }

    public Map<String,Object>  generateContractPrePaid(Map<String,Object> inp) {
        //String req = (String) inp.get('requete');
        // A-TA B-24756 insertion de la trace de  génération 31/01/2025 begin
        String subsc = (String) inp.get('souscriptionID');
        // A-TA B-24756 insertion de la trace de  génération 31/01/2025 end 
        Map<String,Object> out =new  Map<String,Object>();
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setEndpoint('callout:SOA_URL/inwi-api/ServiceOrderManagement/v1/serviceOrder/editContractPrePaid');
            request.setMethod('POST');
        
            request.setHeader('canal', 'SF');
            request.setHeader('content-type', 'application/json');
            request.setHeader('user', 'SF');
            request.setHeader('uuid', INWIB2C_GenerateTransactionCode.generate());
            request.setBody(JSON.serialize(inp));
            request.setTimeout(60000);

          
                response = http.send(request);
            
               // Parse the JSON response
               if (response.getStatusCode() != 200) {
                   System.debug('The status code returned was not expected: ' +
                   response.getStatusCode() + ' ' + response.getStatus());
                       
                   
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
       
                   out.put('result',result ) ;
                   // A-TA B-24756 insertion de la trace de  génération 31/01/2025 begin

                   inwiB2C_TraceGenerateContractDealer__c trace = new inwiB2C_TraceGenerateContractDealer__c(
                    inwiB2C_Subscription__c = subsc,
                    inwiB2C_ContractDealerGenerated__c  = true
                   );
                   insert trace;
                   // A-TA B-24756 31/01/2025 insertion de la trace de  génération end 

                   
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
        vlocity_cmt__Subscription__c subsc = [ select id, Inwib2C_Type_Offre__c, Inwib2c_Offre__c, InwiB2C_Contract__r.inwib2c_Identification__c, InwiB2C_Contract__r.inwib2c_Qualification__c from vlocity_cmt__Subscription__c where id = :subId ];
        // Contract contract = [ select id, inwib2c_Identification__c, inwib2c_Qualification__c from Contract where id  = :subsc.InwiB2C_Contract__c ];
        Boolean showButton = (subsc.Inwib2C_Type_Offre__c == 'InwiB2C_Prepaye' && !subsc.Inwib2c_Offre__c.contains('Dealer') && subsc.InwiB2C_Contract__r.inwib2c_Identification__c && subsc.InwiB2C_Contract__r.inwib2c_Qualification__c);
        Map<String,Object> output = new  Map<String,Object>();
        output.put('showButton', showButton);
        return output;
    }

}