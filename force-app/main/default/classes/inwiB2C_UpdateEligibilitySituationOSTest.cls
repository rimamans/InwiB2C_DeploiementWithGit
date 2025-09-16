@isTest 
public class inwiB2C_UpdateEligibilitySituationOSTest {
 @isTest (SeeAllData=true)   
    private static void inwiB2C_UpdateEligibilitySituationOSTest(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock()); 
   		inwiB2C_UpdateEligibilitySituationOS cls = new inwiB2C_UpdateEligibilitySituationOS(); 
   
   		boolean result = cls.invokeMethod('callUpdateSituation',inputMap, outMap, options);
   		System.assertEquals(true, result);

    }
}