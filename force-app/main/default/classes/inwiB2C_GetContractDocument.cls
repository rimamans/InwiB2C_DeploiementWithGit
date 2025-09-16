/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-12-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class inwiB2C_GetContractDocument implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        Boolean result = true;

        try {
            if (methodName.equals('TransformJson')) {
                transformJson(inputMap, outMap);
            }
        } catch (Exception e) {
            result = false;
            outMap.put('error', e.getMessage());
        }
        return result;
    }
    
    public static void transformJson(Map<String, Object> inputMap, Map<String, Object> outMap) {
        Object jsonData = inputMap.get('jsonData');
        if (jsonData == null) {
            outMap.put('error', 'No data provided for transformation.');
            return;
        }

        List<Map<String, Object>> transformedData;
        if (jsonData instanceof Map<String, Object>) {
            transformedData = transformMapToKeyValue((Map<String, Object>) jsonData);
        } else if (jsonData instanceof List<Object>) {
            transformedData = transformJsonToKeyValue((List<Object>) jsonData);
        } else {
            outMap.put('error', 'Invalid jsonData format. Expected Map or List.');
            return;
        }

        outMap.put('transformedData', transformedData);
    }

    private static List<Map<String, Object>> transformMapToKeyValue(Map<String, Object> dataMap) {
        List<Map<String, Object>> transformedData = new List<Map<String, Object>>();
        for (String key : dataMap.keySet()) {
            Map<String, Object> fieldMap = new Map<String, Object>();
            fieldMap.put('fieldname', key);
            fieldMap.put('fieldvalue', String.valueOf(dataMap.get(key)));
            transformedData.add(fieldMap);
        }
        return transformedData;
    }

    private static List<Map<String, Object>> transformJsonToKeyValue(List<Object> jsonData) {
        List<Map<String, Object>> transformedData = new List<Map<String, Object>>();
        for (Object item : jsonData) {
            if (item instanceof Map<String, Object>) {
                transformedData.addAll(transformMapToKeyValue((Map<String, Object>) item));
            }
        }
        return transformedData;
    }

}