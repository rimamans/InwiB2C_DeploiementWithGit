@isTest
public class inwib2c_push_sms_calloutTest {
    @isTest
     private static void testsample(){
         String input ='{"mdn":"212644587854"}';
         Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock()); 
         inwib2c_push_sms_callout.callVIP(input);
    }
}