global with sharing class inwiB2C_TraitementSMOMassif implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        Boolean result = true;
        try {
           if(methodName == 'traitementMDN_CHCF'){
                traitementMDN_CHCF(inputMap, outMap, options);
            }
        } catch (Exception e) {
            System.debug('Exception in InvokeMethod: ' + e.getMessage());
            result = false;
        }

        return result;
    }
    public static void traitementMDN_CHCF(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        String idTraitement = (String) inputMap.get('inputList'); 
        system.debug('idTraitement'+idTraitement);
        Map<String,Object>  listResult = new Map<String,Object>();
        outMap.put('tess',listResult);
    }


}