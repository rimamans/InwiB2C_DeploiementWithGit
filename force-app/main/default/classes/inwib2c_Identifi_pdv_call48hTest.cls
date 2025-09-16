@isTest
public class inwib2c_Identifi_pdv_call48hTest {
    @isTest
     private static void testsample(){
         String input ='{"MDN":"212644587854"}';
         Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock()); 
         inwib2c_Identifi_pdv_call48h.callVIP(input);
    }

}