global class inwiB2C_DemandePartageDateHandler implements vlocity_cmt.VlocityOpenInterface{
    
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        Boolean result = true;

        try{
            if (methodName.equals('calculateRecyclageDates')){
               calculateRecyclageDates(inputMap, outMap, options);
            }

        } catch (Exception e){
            result = false;
        }

        return result;
    }
    
	public static void calculateRecyclageDates(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
 
        Integer hour = null;
        Integer maxDay = null;
        Integer minDay = null;

         List<inwiB2C_Parametre_Demande_Partage__mdt> metadataRecords = [
            SELECT inwiB2C_value__c, Label 
            FROM inwiB2C_Parametre_Demande_Partage__mdt
        ];
             
         for (inwiB2C_Parametre_Demande_Partage__mdt record : metadataRecords) {
            if (record.Label == 'Hour') {
                hour = Integer.valueOf(record.inwiB2C_value__c) ?? 1;
            } else if (record.Label == 'maxDay') {
                maxDay = Integer.valueOf(record.inwiB2C_value__c) ?? 11;
            } else if (record.Label == 'minDay') {
                minDay = Integer.valueOf(record.inwiB2C_value__c) ?? 1;
            }
         }

        InwiB2C_DRFunction drFunction = new InwiB2C_DRFunction();
        
        String formattedDateTime = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

        DateTime minDateTemp = (DateTime)drFunction.calculWorkingDay(new List<Object>{
            formattedDateTime, minDay
        });

        
        DateTime minDateRecyclage = (DateTime)drFunction.AddHours( new List<Object>{
            minDateTemp.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''), Hour
        });

  
        DateTime maxDateRecyclage = (DateTime)drFunction.calculWorkingDay(new List<Object>{
            formattedDateTime, maxDay
        });

        Set<Date> holidays = new Set<Date>();
        for (InwiB2C_Holidays__c holiday : [SELECT inwib2c_date__c FROM InwiB2C_Holidays__c WHERE inwib2c_date__c >= Today ]) {
            holidays.add(holiday.inwib2c_date__c);
        }

        Map<String, Object> results = new Map<String, Object>{
            'minDateRecyclage' => minDateRecyclage,
            'maxDateRecyclage' => maxDateRecyclage,
            'holidays' => holidays
        };
       outMap.put('result', results);
    }

}