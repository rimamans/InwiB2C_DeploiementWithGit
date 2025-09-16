global with sharing  class inwiB2C_CustomerInteractionMgtOS    implements vlocity_cmt.VlocityOpenInterface {


    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
            
        Boolean result = true;
            
        try{
            
            if(methodName.equals('createInteraction')){
                createInteraction(inputMap, outMap, options);
            
             // your implementation, use outMap to send response back to OmniScript                                                                  
            
            }else if(methodName.equals('updateInteraction')){
                updateInteraction(inputMap, outMap, options);
            
             // your implementation, use outMap to send response back to OmniScript                                                                  
            
            }                              
            
        } catch(Exception e){
                       
            result = false;
                    
        }
             
        return result;
                  
   }


    public static void createInteraction(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        System.debug(JSON.serialize(inputMap));
            
        
        String ctiIteractionNumber = (String) inputMap.get('ctiIteractionNumber');
        String ctiSource = (String) inputMap.get('ctiSource');
        String ctiEmailSource = (String) inputMap.get('ctiEmailSource');
        String ctiFacebookId;
        try{

            ctiFacebookId = String.valueOf((Long) inputMap.get('ctiFacebookId'));

        }catch (Exception e) {
            ctiFacebookId = (String) inputMap.get('ctiFacebookId');
        }
        
        //String ctiFacebookId = (String) inputMap.get('ctiFacebookId');
        String ctiTwitterId = (String) inputMap.get('ctiTwitterId');
        String ctiMDN;
        try{

            ctiMDN = String.valueOf((Long) inputMap.get('ctiMDN'));

        }catch (Exception e) {
            ctiMDN = (String) inputMap.get('ctiMDN');
        }
        //String ctiMDN = String.valueOf((Long) inputMap.get('ctiMDN'));
        String accountid = (String) inputMap.get('accountid');
        String contactId = (String) inputMap.get('contactId');
        String unhandledCall = (String) inputMap.get('unhandledCall');
        String transferedCall = (String) inputMap.get('transferedCall');
        String status = (String) inputMap.get('status');
        

        Map<String , Object> ctiInput = new Map<String , Object>();
        ctiInput.put('ctiIteractionNumber', ctiIteractionNumber);

        Map<String , Object> data = new Map<String , Object>();

        data.put('ctiSource',ctiSource);
        data.put('ctiEmailSource',ctiEmailSource);
        data.put('ctiFacebookId',ctiFacebookId);
        data.put('ctiTwitterId',ctiTwitterId);
        data.put('ctiMDN',ctiMDN);
        data.put('contactId',contactId);
        data.put('unhandledCall',unhandledCall);
        data.put('transferedCall',transferedCall);
        data.put('status',status);

        ctiInput.put('data', data);

        System.debug(JSON.serialize(ctiInput));

        String vlocityInteractionId = inwiB2C_CustomerInteractionMgt.createCustomerInteraction(accountid,ctiInput );


        outMap.put('vlocityInteractionId', vlocityInteractionId);

        
    }

    public static void updateInteraction(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        System.debug(JSON.serialize(inputMap));
            
        
        String unhandledCall = (String) inputMap.get('unhandledCall');
        String transferedCall = (String) inputMap.get('transferedCall');
        String vlocityInteractionId = (String) inputMap.get('vlocityInteractionId');
        

        inwiB2C_CustomerInteractionMgt.updateCustomerInteraction(vlocityInteractionId,unhandledCall, transferedCall );

        
    }


    
}