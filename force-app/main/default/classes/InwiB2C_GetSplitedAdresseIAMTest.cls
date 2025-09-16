@isTest
private class InwiB2C_GetSplitedAdresseIAMTest {

    @isTest(SeeAllData=true)
    static void GetSplitedAdresseIAMTest() {
        
        Map<String, Object> adressIamConcat = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        adressIamConcat.put('AdressIamConcat','|||||0045;Complexe Akbib|00010;Moujahidine|53001;TANGER MEDINA|53;TANGER');
        Boolean result =InwiB2C_GetSplitedAdresseIAM.invokeMethod('GetSplitedAdresseIAM', adressIamConcat, output, options);
    }
}