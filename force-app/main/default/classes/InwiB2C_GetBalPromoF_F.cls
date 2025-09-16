global with sharing class InwiB2C_GetBalPromoF_F implements vlocity_cmt.VlocityOpenInterface {

   global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
            
        if (methodName == 'getBal') {
            outMap.put('result', getBal(inputMap));
        }         
        return true;                 
   }
    
    
   Map<String,Object> getBal(Map<String,Object> inputMap) {
            system.debug('input'+inputMap);
    
        Map<String,Object> bucket = (Map<String,Object>) inputMap;
                system.debug('inputlist'+bucket);
    
    //Map<String, Object> jsonObj = (Map<String, Object>) JSON.deserializeUntyped(jsonStr);
    
    
    Map<String, Object> originalJson =  (Map<String,Object>) bucket ;
    //Map<String, Object> originalJson = (Map<String, Object>) JSON.deserializeUntyped('{"bucket": [{ "properties": {"M_BAL_TYPE": "e7c8ae16000cTba9daa572bd","M_BAL_AFTER": "0","M_MOTIF_RECH": "1041","M_LINE_ID": "212666867764","M_TRANSACTION": "Balance","M_BAL_DEBITEE": "3000:1000;4000:30;5041:40;","M_TRANSAC_DATE": "2022-06-11 08:40:35", "M_AMOUNT_CON": "14" }, "product": [], "bucketCounter": [],"bucketBalance": []}, { "properties": {"M_BAL_TYPE": "e7c8ae16000cTba9daa572bd","M_BAL_AFTER": "0","M_MOTIF_RECH": "1041","M_LINE_ID": "212666867764","M_TRANSACTION": "Balance","M_BAL_DEBITEE": "3000:1000;4000:30;5041:40;","M_TRANSAC_DATE": "2022-06-11 08:40:35", "M_AMOUNT_CON": "14" }, "product": [], "bucketCounter": [],"bucketBalance": []}]}');
             
       system.debug('originalJson'+originalJson); 
        // Get the 'bucket' array from the original JSON
        List<Object> originalBucket = (List<Object>)originalJson.get('bucket');
        
        // Iterate over each item in the 'bucket' array and transform its 'properties' object
        List<Object> transformedBucket = new List<Object>();
       
           Map<String, String> ballanceMap = new Map<String, String>();
       		ballanceMap.put('2291', 'F&F voix');
            ballanceMap.put('5240', 'F&F sms');

        
        for (Object bucketItem : originalBucket) {
            Map<String, Object> originalProperties = (Map<String, Object>)((Map<String, Object>)bucketItem).get('properties');
            Map<String, Object> transformedProperties = new Map<String, Object>();
            
            // Copy over the properties that don't need to be transformed
            transformedProperties.put('M_BAL_TYPE', originalProperties.get('M_BAL_TYPE'));
            transformedProperties.put('M_BAL_AFTER', originalProperties.get('M_BAL_AFTER'));
            transformedProperties.put('M_MOTIF_RECH', originalProperties.get('M_MOTIF_RECH'));
            transformedProperties.put('M_LINE_ID', originalProperties.get('M_LINE_ID'));
            transformedProperties.put('M_TRANSACTION', originalProperties.get('M_TRANSACTION'));
            transformedProperties.put('M_BAL_DEBITEE', originalProperties.get('M_BAL_DEBITEE'));
            transformedProperties.put('M_TRANSAC_DATE', originalProperties.get('M_TRANSAC_DATE'));
            transformedProperties.put('M_AMOUNT_CON', originalProperties.get('M_AMOUNT_CON'));
            
            String serviceId =originalProperties.get('M_MOTIF_RECH').toString();
            String serviceName = ballanceMap.get(serviceId);
            transformedProperties.put('M_MOTIF_RECH_LIBELLE', serviceName);
            
            List<String> dataList = ((String) originalProperties.get('M_BAL_DEBITEE')).split(';');
            System.debug(dataList);
            List<Map<String, Object>> finalList = new List<Map<String, Object>>();
                for (String item : dataList) {
                    List<String> nameValue = item.split(':');
                    Map<String, Object> obj = new Map<String, Object>();
                    obj.put('name', nameValue[0]);
                    obj.put('value', nameValue[1]);
                    finalList.add(obj);
                }
            transformedProperties.put('listbal', finalList);       
            transformedBucket.add(transformedProperties);
            
            system.debug('transformedProperties'+transformedProperties);
            }
        
            system.debug('transformedBucket'+transformedBucket);               
           
           Map<String, Object> transformedJson = new Map<String, Object>();
           transformedJson.put('bucket', transformedBucket);
           system.debug('transformedJson'+transformedJson);  
            
          return transformedJson;
    }
}