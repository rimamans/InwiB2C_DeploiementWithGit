@isTest
private class InwiB2C_GetLabelAdresseIAMTest {
    @isTest(SeeAllData=true)
    public static void GetLabelAdresseIAMTest() {
        
        Map<String, Object> adressIamConcat = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        adressIamConcat.put('AdressIamConcat','|||||Complexe Akbib|Moujahidine|53001;TANGER MEDINA|53;TANGER');
        Boolean result = InwiB2C_GetLabeAdresseIAM.invokeMethod('GetLabelAdresseIAM', adressIamConcat, output, options);
    }
}