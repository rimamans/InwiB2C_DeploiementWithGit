public without sharing class InwiB2C_VOCToLabel {
    @InvocableMethod
		public static List<String> ToLabel(List<String> inputs) {
            
        List<String> results = new List<String>();
        Map<String, Map<String, String>> queryMap = new Map<String, Map<String, String>>();  
        Map<String, String> inputMap = new Map<String, String>();
            
         Map<String, Map<String, Set<String>>> groupedInputs = new Map<String, Map<String, Set<String>>>();
            
        for (String input : inputs) {
            List<String> arguments = input.split(',');
            System.debug(arguments);
            if (arguments.size() != 3) {
                results.add(input);
                continue;
            }
            
            
            String objectName = String.valueOf(arguments[0]);
            String fieldName = String.valueOf(arguments[1]);
            String recordId = String.valueOf(arguments[2]);
            
            if (!groupedInputs.containsKey(objectName)) {
                groupedInputs.put(objectName, new Map<String, Set<String>>());
            }
            if (!groupedInputs.get(objectName).containsKey(fieldName)) {
                groupedInputs.get(objectName).put(fieldName, new Set<String>());
            }
            groupedInputs.get(objectName).get(fieldName).add(recordId);
            
        }
            
        
        // Query records for each object and field combination
        Map<String, Map<String, Map<Id, String>>> labelMap = new Map<String, Map<String, Map<Id, String>>>();
        for (String objectName : groupedInputs.keySet()) {
            for (String fieldName : groupedInputs.get(objectName).keySet()) {
                Set<String> recordIds = groupedInputs.get(objectName).get(fieldName);
                if (recordIds.isEmpty()) continue;

                try {
                    String query = 'SELECT Id, toLabel(' + fieldName + ') fieldLabel  FROM ' + objectName + ' WHERE Id IN :recordIds';
                    System.debug('query ' + query);
                    List<SObject> records = Database.query(query);
                    System.debug('records ' + records);

                    if (!labelMap.containsKey(objectName)) {
                        labelMap.put(objectName, new Map<String, Map<Id, String>>());
                    }
                    if (!labelMap.get(objectName).containsKey(fieldName)) {
                        labelMap.get(objectName).put(fieldName, new Map<Id, String>());
                    }

                    for (SObject record : records) {
                        labelMap.get(objectName).get(fieldName).put(record.Id, String.valueOf(record.get('fieldLabel')).trim().replace('\t',' '));
                    }
                } catch (Exception e) {
                    System.debug('Error querying ' + objectName + ': ' + e.getMessage());
                }
            }
        }

        
       // Build results based on queried data
        for (String input : inputs) {
            List<String> arguments = input.split(',');
            if (arguments.size() != 3) {
                results.add(input);
                continue;
            }
            String objectName = arguments[0];
            String fieldName = arguments[1];
            String recordId = arguments[2];

            if (labelMap.containsKey(objectName) && labelMap.get(objectName).containsKey(fieldName) &&
                labelMap.get(objectName).get(fieldName).containsKey(recordId)) {
                results.add(labelMap.get(objectName).get(fieldName).get(recordId));
            } else {
                results.add('champ'); 
            }
        }
          
        
        return results;

      }  

}