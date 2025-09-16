@isTest
public class inwiB2C_MigPostPostCallcheckoutTest {
 @isTest
     private static void testsample(){
         String input ='{"TraceId":"a6p3M0000004KM6QAM","Id":"8013M000000zaUIQAY"}';
         Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock()); 
         inwiB2C_MigPostPostCallcheckout.callVIP(input);
    }
}