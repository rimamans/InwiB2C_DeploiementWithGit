global with sharing class inwiB2C_UpdateEligibilitySituationOS implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try{
            if(methodName.equals('callUpdateSituation')){
                callUpdateSituation(inputMap, outMap, options);
            }
            
            else {}                            
            
        } catch(Exception e){result = false;
        }
        return result;
    }

    public static void callUpdateSituation(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        System.debug('In callUpdateSituation: ');
        System.debug(JSON.serialize(inputMap));

        String body='{ "cin":"'+ inputMap.get('cin') +'", "cne":"'+ inputMap.get('cne') +'","action":"'+ inputMap.get('action') +'","mdn":"'+ inputMap.get('mdn') +'","offerType":"'+ inputMap.get('offerType') +'","orderType":"'+ inputMap.get('orderType') +'"}';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SOA_URL/inwi-api/productOfferingQualification/v1/productOfferingQualification/eligibility/situation?_HttpMethod=PATCH');
        request.setHeader('canal', 'SF');
        request.setHeader('user', UserInfo.getName());
        request.setHeader('uuid', 'SFB2C');
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('PATCH');
        request.setHeader('X-HTTP-Method-Override','PATCH');
        request.setTimeout(60000);
        
        request.setBody(body);
  
        try {
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() != 200)
            {
                System.debug('Erreur: ' +response.getStatusCode() + ' ' + response.getStatus());
                System.debug('Body: ' +response.getBody() );
                Map<String,String> bodyMap = (Map<String,String>)JSON.deserialize(response.getBody(), Map<String,String>.class);

                outMap.put('code', bodyMap.get('code'));
                outMap.put('message', bodyMap.get('message'));
                outMap.put('reason', bodyMap.get('reason'));

                

            } 
            else 
            {
                System.debug('Reponse update eligibility situation' + ' ' + response.getHeaderKeys() );
                System.debug('Body: ' +response.getBody() );
                Map<String,String> bodyMap = (Map<String,String>)JSON.deserialize(response.getBody(), Map<String,String>.class);

                outMap.put('status', bodyMap.get('status'));
            }
        } catch(Exception e){
            System.debug('An exception occurred: ' + e.getMessage());
        }
    }
}