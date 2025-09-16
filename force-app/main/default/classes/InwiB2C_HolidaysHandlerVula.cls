global class InwiB2C_HolidaysHandlerVula implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;
        try {
            if (methodName.equals('getHolidays')) {
                getHolidays(outMap);
            }
        } catch (Exception e) {
            System.debug('Erreur Apex: ' + e.getMessage());
            result = false;
        }
        return result;
    }

    public static void getHolidays(Map<String, Object> outMap) {
        Set<Date> holidays = new Set<Date>();

        // Récupérer les jours fériés à partir de l'objet InwiB2C_Holidays__c
        for (InwiB2C_Holidays__c holiday : [
            SELECT inwib2c_date__c FROM InwiB2C_Holidays__c WHERE inwib2c_date__c >= TODAY
        ]) {
            holidays.add(holiday.inwib2c_date__c);
        }

        // Conversion en format String (ISO YYYY-MM-DD)
        List<String> holidaysList = new List<String>();
        for (Date holiday : holidays) {
            holidaysList.add(holiday.format()); 
        }

        // Ajouter la liste des jours fériés dans outMap
        outMap.put('holidays', holidaysList);
    }
}