/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-26-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class inwib2c_GetCurrentItemEshop implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        Boolean result = true;
        try{
            if (methodName.equals('get_CurrentItem')){
                get_CurrentItem(inputMap, outMap, options);
            }
        } catch (Exception e){
            result = false;
        }
        return result;
    }
    public static void get_CurrentItem(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        // String bodyJson = (String) inputMap.get('bodyCart');
        // Map<String, Object> inputJsonMap = (Map<String, Object>) JSON.deserializeUntyped(bodyJson);
       Map<String, Object> inputJsonMap = (Map<String, Object>) inputMap.get('bodyCart');
       String offrePrincipale= (String) inputMap.get('offreStart');
       System.debug('vlcCart1'+inputJsonMap);
       System.debug('offreStart'+offrePrincipale);
        //List<Map<String, Object>> records = (List<Map<String, Object>>) inputJsonMap.get('records');
        List<Object> records = (List<Object>) inputJsonMap.get('records');
    List<Map<String, Object>> filteredRecords = new List<Map<String, Object>>();
    boolean hasAddedFirstTerminalRecord = false; // Flag to track if the first 'Terminal' record has been added
    // for (Map<String, Object> record : records) {
    //     Map<String, Object> product2 = (Map<String, Object>) record.get('Product2');
    //     String productType = (String) product2.get('vlocity_cmt__Type__c');
    //     if ('Postpaye'.equals(productType)) {
    //         filteredRecords.add(record);
    //     }
    // }
    for (Object subRecordObj : records){
        Map<String, Object> subRecord = (Map<String, Object>) subRecordObj;
        Map<String, Object> product2 = (Map<String, Object>) subRecord.get('Product2');
        String productType = (String) product2.get('vlocity_cmt__Type__c');
        if ('Postpaye'.equals(productType) || 'Prepaye'.equals(productType) || 'Home'.equals(productType) || 'idar duo'.equals(productType)|| 'FTTH'.equals(productType)|| 'ADSL'.equals(productType) || 'Cameleon'.equals(productType)) {
            filteredRecords.add(subRecord);
        }
        // if ('Terminal'.equals(offrePrincipale)) {
        //     filteredRecords.add(subRecord);
        // }
        else if ('Terminal'.equals(offrePrincipale) && !hasAddedFirstTerminalRecord || 'Disque Dur'.equals(offrePrincipale) && !hasAddedFirstTerminalRecord || 'ChromeCast'.equals(offrePrincipale) && !hasAddedFirstTerminalRecord || 'Montre Connectée'.equals(offrePrincipale) && !hasAddedFirstTerminalRecord || 'Attribution point d’accès'.equals(offrePrincipale) && !hasAddedFirstTerminalRecord) {
            filteredRecords.add(subRecord);
            hasAddedFirstTerminalRecord = true; // Set the flag to true after adding the first 'Terminal' record
        }
    }
        // Create a new map with the key 'records' and set the filteredRecords list as its value
    Map<String, Object> result = new Map<String, Object>();
    result.put('records', filteredRecords);
    // Put the result map in the outMap with the key 'filteredRecords'
    outMap.put('filteredRecords', result);
    }
}