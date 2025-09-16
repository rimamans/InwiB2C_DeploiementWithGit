global with sharing class inwiB2C_TraceSupportController implements vlocity_cmt.VlocityOpenInterface {

    global Boolean InvokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        Boolean result = true;
        try {
            if (methodName == 'getFilteredTraceSupport') {
                output.put('List', getFilteredRecords(input));
            } else if (methodName == 'getCurrentUserProfile') {
                output.put('Profile', getCurrentUserProfile());
            }
        } catch (Exception e) {
            System.debug('Exception in InvokeMethod: ' + e.getMessage());
            result = false;
        }
        return result;
    }

    private static List<inwiB2C_TraceSupportVulaAdressIntrouvabl__c> getFilteredRecords(Map<String, Object> input) {
        String loginCDC = (String) input.get('loginCDC');
        String dateEnvoiStr = (String) input.get('dateEnvoi');
        String dateReceptionStr = (String) input.get('dateReception');
        String province = (String) input.get('province');

        List<String> conditions = new List<String>();

        if (String.isNotBlank(loginCDC)) {
            conditions.add('inwiB2C_LoginSFCDC__c = \'' + String.escapeSingleQuotes(loginCDC) + '\'');
        } else {
            conditions.add('inwiB2C_LoginSFCDC__c = \'' + UserInfo.getUserName() + '\'');
            system.debug('No loginCDC provided, using current user: ' + UserInfo.getUserName());
        }

        if (String.isNotBlank(dateEnvoiStr)) {
            String cleanedEnvoi = dateEnvoiStr.replaceAll(':', '/');
            Date dateEnvoi = Date.valueOf(cleanedEnvoi);
            conditions.add('inwiB2C_dateEnvoi__c = ' + String.valueOf(dateEnvoi));
        }

        if (String.isNotBlank(dateReceptionStr)) {
            String cleanedReception = dateReceptionStr.replaceAll(':', '/');
            Date dateReception = Date.valueOf(cleanedReception);
            conditions.add('inwiB2C_dateReception__c = ' + String.valueOf(dateReception));
        }

        if (String.isNotBlank(province)) {
            conditions.add('inwiB2C_ProvinceValue__c = \'' + String.escapeSingleQuotes(province) + '\'');
        }

        String query = 'SELECT Id, Name, inwiB2C_LoginSFCDC__c, inwiB2C_dateEnvoi__c, inwiB2C_dateReception__c,' +
                       'inwiB2C_ProvinceValue__c, inwiB2C_ProvinceCode__c, inwiB2C_CommuneValue__c, inwiB2C_CommuneCode__c,' +
                       'inwiB2C_QuartierValue__c, inwiB2C_QuartierCode__c, inwiB2C_VoieValue__c, inwiB2C_VoieCode__c,' +
                       'CreatedDate, CreatedBy.Name FROM inwiB2C_TraceSupportVulaAdressIntrouvabl__c';

        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }

        query += ' ORDER BY CreatedDate DESC';

        System.debug('Generated Query: ' + query);
        return Database.query(query);
    }
    private static String getCurrentUserProfile() {
        return [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
    }

    // private static List<String> getUniqueLoginsCDC() {
    //     Set<String> uniqueLogins = new Set<String>();

    //     for (inwiB2C_TraceSupportVulaAdressIntrouvabl__c record : [
    //         SELECT inwiB2C_LoginSFCDC__c
    //         FROM inwiB2C_TraceSupportVulaAdressIntrouvabl__c
    //         WHERE inwiB2C_LoginSFCDC__c != null
    //     ]) {
    //         uniqueLogins.add(record.inwiB2C_LoginSFCDC__c);
    //     }

    //     return new List<String>(uniqueLogins);
    // }

}