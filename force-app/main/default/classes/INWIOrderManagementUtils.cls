// global class INWIOrderManagementUtils implements vlocity_cmt.VlocityOpenInterface{
// global static final String ARGUMENTS = 'arguments';
//     global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
//     	if (methodName == 'callSoaAPI'){
// 			String url = (String)inputs.get('url');
//             Map<String, Object> input = (Map<String, Object>)inputs.get('input');
//             string user = (String)inputs.get('user');
//             string uuid = (String)inputs.get('uuid');
//             string canal = (String)inputs.get('canal');
//             string contentType = (String)inputs.get('contenttype');
//             string method = (String)inputs.get('method');
//             string orchestrationId = (String)inputs.get('orchid');
//             //System.debug(url+' '+input);
//             string jsonstring = JSON.serialize(input);
//             //putCartItems(attributesToUpdate,quoteLineId);
//             //callSoaAPI(url,jsonstring);
            
//             output.put('Result',callSoaAPI(url,jsonstring,user,uuid,method,contentType,canal,orchestrationId));
//         }
//         return true;
//   	}
    
//     public Map<String,Object> callSoaAPI(String url,String input,String user, String uuid,String method,string contentType,string canal,string orchestrationId){
//     //Unrecognized symbol '"', which is not a valid Apex identifier.
// 	Http h = new Http();
//     HttpRequest req = new HttpRequest();
//     Integer size = input.length();
//     String requestSize =String.ValueOf(size);   
//     req.setEndpoint(url);
//     req.setMethod(method);
// 	req.setHeader('Content-Type', contentType);
//     req.setHeader('canal', canal);
//     req.setHeader('user', user);
//     req.setHeader('uuid', uuid);
//     if(method != 'GET') req.setHeader('Content-Length', requestSize);
//     req.setBody(input);
//     req.setTimeout(120000); 
//     HttpResponse response = h.send(req);
//     System.debug('request '+input);
//     System.debug('response '+response.getBody());
//     System.debug('size '+requestSize);
//     System.debug('orchestrationId '+orchestrationId);
//     Map<String, Object> responseSoa  = new Map<String, Object> ();
//         //(Map<String, Object>)JSON.deserializeUntyped(response.getBody());
//     try {

//     	responseSoa = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
// 	}
// 	catch (Exception e) {
//     	// Handle this exception here
//     	responseSoa.put('status','0');
//         responseSoa.put('errorMessage',response.getBody());
// 	}
//     return responseSoa;
// }
     
// }

global class INWIOrderManagementUtils implements vlocity_cmt.VlocityOpenInterface{
    global static final String ARGUMENTS = 'arguments';
        global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
            if (methodName == 'callSoaAPI'){
                String url = (String)inputs.get('url');
                Map<String, Object> input = (Map<String, Object>)inputs.get('input');
                string user = (String)inputs.get('user');
                string uuid = (String)inputs.get('uuid');
                string canal = (String)inputs.get('canal');
                string contentType = (String)inputs.get('contenttype');
                string method = (String)inputs.get('method');
                // string orchestrationId = (String)inputs.get('orchid');
                //System.debug(url+' '+input);
                string jsonstring = JSON.serialize(input);
                //putCartItems(attributesToUpdate,quoteLineId);
                //callSoaAPI(url,jsonstring);
                
                output.put('Result',callSoaAPI(url,jsonstring,user,uuid,method,contentType,canal));
            }
            return true;
          }
        
        public Map<String,Object> callSoaAPI(String url,String input,String user, String uuid,String method,string contentType,string canal){
        //Unrecognized symbol '"', which is not a valid Apex identifier.
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        Integer size = input.length();
        String requestSize =String.ValueOf(size);   
        req.setEndpoint(url);
        req.setMethod(method);
        req.setHeader('Content-Type', contentType);
        req.setHeader('canal', canal);
        req.setHeader('user', user);
        req.setHeader('uuid', uuid);
        if(method != 'GET') req.setHeader('Content-Length', requestSize);
        req.setBody(input);
        req.setTimeout(120000); 
        HttpResponse response = h.send(req);
        System.debug('request '+input);
        System.debug('response '+response.getBody());
        System.debug('size '+requestSize);
        Map<String, Object> responseSoa  = new Map<String, Object> ();
            //(Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        try {
    
            responseSoa = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        }
        catch (Exception e) {
            // Handle this exception here
            responseSoa.put('status','0');
            responseSoa.put('errorMessage',response.getBody());
        }
        return responseSoa;
    }
         
    }