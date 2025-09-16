/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-09-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class INWIOrderManagementUtilsTest {
    

    @isTest static void invokeMethodeTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new INWIOrderManagementUtilsMock());
        String methodName = 'callSoaAPI'; 
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('url','api/productOrderingManagement/v1/productOrder/createBillingMobileContract');
        inputMap.put('uuid','uuid12345');
        inputMap.put('user','classe de test');
        inputMap.put('canal','SF');
        inputMap.put('method','post');
        inputMap.put('contenttype','application/json');
        inputMap.put('orchestrationId','a384K000000d1E8QAI');

        
        Map<String,Object> outMap = new Map<String,Object>(); 
        Map<String,Object> options = new Map<String,Object>();
        INWIOrderManagementUtils orderManagementUtils = new INWIOrderManagementUtils();
        boolean result = orderManagementUtils.invokeMethod(methodName, inputMap, outMap, options);
        System.assertEquals(true,result);
        Test.stopTest();
    }

}