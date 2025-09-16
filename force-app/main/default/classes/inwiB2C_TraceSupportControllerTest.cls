@isTest
private class inwiB2C_TraceSupportControllerTest {

    @testSetup
    static void setupTestData() {
        inwiB2C_TraceSupportVulaAdressIntrouvabl__c record = new inwiB2C_TraceSupportVulaAdressIntrouvabl__c(
            inwiB2C_LoginSFCDC__c = UserInfo.getUserName(),
            inwiB2C_dateEnvoi__c = Date.today(),
            inwiB2C_dateReception__c = Date.today(),
            inwiB2C_ProvinceValue__c = 'CASA',
            inwiB2C_ProvinceCode__c = '01',
            inwiB2C_CommuneValue__c = 'Maarif',
            inwiB2C_CommuneCode__c = '02',
            inwiB2C_QuartierValue__c = 'Quartier A',
            inwiB2C_QuartierCode__c = '02',
            inwiB2C_VoieValue__c = 'Rue 123',
            inwiB2C_VoieCode__c = '12'
        );
        insert record;
    }

    @isTest
    static void testInvokeMethodWithAllInputs() {
        Map<String, Object> input = new Map<String, Object>{
            'loginCDC' => UserInfo.getUserName(),
            'dateEnvoi' => String.valueOf(Date.today()),
            'dateReception' => String.valueOf(Date.today()),
            'province' => 'Casablanca'
        };
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Boolean result = (new inwiB2C_TraceSupportController()).InvokeMethod('getFilteredTraceSupport', input, output, options);
        List<Object> results = (List<Object>)output.get('List');
    }

    @isTest
    static void testInvokeMethodWithoutLoginCDC() {
        Map<String, Object> input = new Map<String, Object>{
            'dateEnvoi' => String.valueOf(Date.today()),
            'province' => 'Casablanca'
        };
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Boolean result = (new inwiB2C_TraceSupportController()).InvokeMethod('getFilteredTraceSupport', input, output, options);
    }
}