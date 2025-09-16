@isTest
private class InwiB2C_GetMappingSFSN_Test {
    @isTest
    static void testSearchMapping() {
        // Create test data
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('caseCategory', 'Inwib2c_Assistance/service _HelpDesk');
        inputs.put('caseDetail', 'pas de connexion');
        inputs.put('caseQualificationAUDA', false);
        inputs.put('caseTypeOffre', 'ADSL');
        inputs.put('caseTypeSpecialit', 'Data _HelpDesk _Assistance/service	');

        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        Map<String, Object> inputs2 = new Map<String, Object>();
        inputs2.put('caseCategory', 'Inwib2c_Assistance/service _HelpDesk');
        inputs2.put('caseDetail', 'Autres');
        inputs2.put('caseQualificationAUDA', false);
        inputs2.put('caseTypeOffre', 'FTTH');
        inputs2.put('caseTypeSpecialit', 'All');

        Map<String, Object> output2 = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();
        
        // Create an instance of the class to test
        InwiB2C_GetMappingSFSN mappingInstance = new InwiB2C_GetMappingSFSN();
        InwiB2C_GetMappingSFSN newmappingInstance = new InwiB2C_GetMappingSFSN();

        // Call the method to test
        Boolean result = mappingInstance.invokeMethod('SearchMapping', inputs, output, options);
		Boolean newresult = newmappingInstance.invokeMethod('SearchMapping', inputs2, output2, options2);
        
        
        InwiB2C_Typologie_Mapping_SF_SN__c typlogie = new InwiB2C_Typologie_Mapping_SF_SN__c(
        InwiB2C_CategorieSF__c='Inwib2c_Assistance/service _HelpDesk',
        InwiB2C_DetailSF__c='pas de connexion',
        InwiB2C_Type_de_offreSF__c='ADSL',
        InwiB2C_Type_de_specialiteSF__c='Data _HelpDesk _Assistance/service'
        );
        
		insert typlogie;
        
        InwiB2C_Typologie_Mapping_SF_SN__c newtyplogie = new InwiB2C_Typologie_Mapping_SF_SN__c(
        InwiB2C_CategorieSF__c='Inwib2c_Assistance/service _HelpDesk',
        InwiB2C_DetailSF__c='Autres',
        InwiB2C_Type_de_offreSF__c='FTTH',
        InwiB2C_Type_de_specialiteSF__c='All'
        );
        
		insert newtyplogie;
    }
}