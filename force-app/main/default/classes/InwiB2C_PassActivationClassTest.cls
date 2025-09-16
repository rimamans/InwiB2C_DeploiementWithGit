@isTest
global class InwiB2C_PassActivationClassTest {
    @isTest(SeeAllData=false)
     public static void InwiB2C_PassActivationClassTest()
    {
        Test.startTest();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        inputMap.put('mdn','212630514789');
        inputMap.put('subscriptionId','SubIdTest');
        inputMap.put('accountId','AccountIdTest');
        
         new InwiB2C_PassActivationClass().invokeMethod('ActivatePassMyINWI',inputMap, outMap, options);
        Test.stopTest();
        
    }

}