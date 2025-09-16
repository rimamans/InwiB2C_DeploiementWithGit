public without sharing class InwiB2C_VOCConditionVerification {
    @InvocableMethod
    public static List<Boolean> generateEventQuery(List<String> inputs) {
        List<Boolean> output = new List<Boolean>();  
        System.debug('list ' + inputs);
        System.debug('Inputs size: ' + inputs.size());

        if (inputs.size() == 0) {
            output.add(false);
            return output;
        }

        if(SystemFacade.isBatch() == true || SystemFacade.isFuture() == true){ 
            for(String input : inputs ){
             output.add(false);   
            }
            
            System.debug('stop bulk ');
            return output;
        }



        Set<String> eventSet = new Set<String>(); //set of event
        Map<String, Set<String>> eventToIdsMap = new Map<String, Set<String>>(); // map event recordIDs
        List<String> idsList =  new List<String>(); // list of IDs

        for(String input : inputs) {
            List<String> splitList = input.split(',');
            String eventParameter = splitList[0];
            String eventId = splitList[1];

            eventSet.add(eventParameter);
            IdsList.add(eventId);

            if (!eventToIdsMap.containsKey(eventParameter)) {
                eventToIdsMap.put(eventParameter, new Set<String>());
            }
            eventToIdsMap.get(eventParameter).add(eventId);
        }


        // fetch events configuration
        Map<String, List<InwiB2C_VOC_Event_Condition__c>> configurationsMap = new Map<String, List<InwiB2C_VOC_Event_Condition__c>>();
        List<InwiB2C_VOC_Event_Condition__c> allConfigurations = [
            SELECT InwiB2C_Object_Name__c, InwiB2C_Field_Name__c, InwiB2C_Search_Conditon__c, 
                   InwiB2C_Operator__c, InwiB2C_Condition_Number__c, InwiB2C_Logic__c, 
                   InwiB2C_Type__c, InwiB2C_Field_To_Select__c, InwiB2C_Event__c
            FROM InwiB2C_VOC_Event_Condition__c 
            WHERE InwiB2C_Type__c = 'Event' AND InwiB2C_Event__c IN :eventSet  
            ORDER BY InwiB2C_Event__c, InwiB2C_Condition_Number__c
        ];

        if (allConfigurations.isEmpty()) {
             for(String input : inputs ){
             output.add(false);   
            } 
            return output;
        }
        
        for (InwiB2C_VOC_Event_Condition__c config : allConfigurations) {
            if (!configurationsMap.containsKey(config.InwiB2C_Event__c)) {
                configurationsMap.put(config.InwiB2C_Event__c, new List<InwiB2C_VOC_Event_Condition__c>());
            }
            configurationsMap.get(config.InwiB2C_Event__c).add(config);
        }


        
         //Map<String, List<SObject>> eventToRecordsMap = new Map<String, List<SObject>>();
         List<String> queryList =  new List<String>();
         List<SObject> records = new List<SObject>();

        for (String eventParameter : configurationsMap.keySet()) {
           // List<InwiB2C_VOC_Event_Condition__c> configurations = configurationsMap.get(eventParameter);
            Set<String> eventIds = eventToIdsMap.get(eventParameter);
            String dynamicQuery = buildQuery(configurationsMap, eventIds);

            if (dynamicQuery != null) {
                queryList.add(dynamicQuery);
                List<SObject> queryResults = Database.query(dynamicQuery);
                    if (queryResults.isEmpty() == false) { 
                        records.addAll(queryResults);
                    }
            } 
        }
        

        for (String eventId : idsList) {

            Boolean matchFound = false;
            if (records != null) {
                for (SObject record : records) {
                    if (record.Id == eventId) {
                        matchFound = true;
                        break;
                    }
                }
            }
            output.add(matchFound);
        }
        
        
        System.debug('Records size: ' + output.size());
        System.debug('Output: ' + output);
        return output;
      }  



    public static String buildQuery(Map<String, List<InwiB2C_VOC_Event_Condition__c>> configurationsMap, Set<String> eventIds) {
        String dynamicQuery;
        for (String eventParameter : configurationsMap.keySet()) {
            List<InwiB2C_VOC_Event_Condition__c> configurations = configurationsMap.get(eventParameter);
            if (!configurations.isEmpty()) {
                String objectName = configurations[0].InwiB2C_Object_Name__c;
                dynamicQuery = 'SELECT Id';
                
               /* if (!String.isEmpty(configurations[0].InwiB2C_Field_To_Select__c)) {
                    dynamicQuery += ', ' + configurations[0].InwiB2C_Field_To_Select__c;
                }*/
                dynamicQuery += ' FROM ' + objectName + ' WHERE Id IN :eventIds';
                
                Map<Integer, String> conditionMap = new Map<Integer, String>();
                for (InwiB2C_VOC_Event_Condition__c config : configurations) {
                    Integer conditionNumberInteger = config.InwiB2C_Condition_Number__c.intValue();
                    String searchCondition;
                    //handle boolean field type
                    if(config.InwiB2C_Search_Conditon__c != null && (config.InwiB2C_Search_Conditon__c == '!true' || config.InwiB2C_Search_Conditon__c == '!false')){ //handle boolean field type
                        Boolean booleanSearchCondition = config.InwiB2C_Search_Conditon__c == '!true' ? true : false ; 
                        conditionMap.put(conditionNumberInteger, config.InwiB2C_Field_Name__c + ' ' + config.InwiB2C_Operator__c + ' ' + booleanSearchCondition);
                        }
                    //handle boolean field type
                    // add () to IN operator
                    else if(config.InwiB2C_Operator__c == 'IN'){
                        searchCondition = config.InwiB2C_Search_Conditon__c != null ? '(\'' + config.InwiB2C_Search_Conditon__c + '\')' : null;
                        conditionMap.put(conditionNumberInteger, config.InwiB2C_Field_Name__c + ' ' + config.InwiB2C_Operator__c + ' ' + searchCondition);
                    }
                    //
                    else{
                        searchCondition = config.InwiB2C_Search_Conditon__c != null ? '\'' + config.InwiB2C_Search_Conditon__c + '\'' : null;
                        conditionMap.put(conditionNumberInteger, config.InwiB2C_Field_Name__c + ' ' + config.InwiB2C_Operator__c + ' ' + searchCondition);
                    }
                    
                }
                
                String formulaWithConditions = configurations[0].InwiB2C_Logic__c;
                for (Integer conditionNumber : conditionMap.keySet()) {
                    formulaWithConditions = formulaWithConditions.replaceAll('\\b' + String.valueOf(conditionNumber) + '\\b', conditionMap.get(conditionNumber));
                }
                dynamicQuery += ' AND ' + formulaWithConditions;
                
                System.debug('Dynamic Query: ' + JSON.serialize(dynamicQuery));
                return dynamicQuery;
            }
        }
        return null;
    }

}