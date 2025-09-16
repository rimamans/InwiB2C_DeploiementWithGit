@IsTest
public with sharing class InwiB2C_OTPServiceTest {
    public InwiB2C_OTPServiceTest() {

    }
    
 
    public static testMethod void testMethodSendOTP(){
            Test.startTest();
        Map<String,Object> input1 = new Map<String,Object>();
        Map<string,Object> output1 =new Map<string,object>();
        Map<string,Object> opt =new Map<string,object>();

        input1.put('otp','768559');
        input1.put('contact','21222222222');
        
        boolean y=InwiB2C_OTPService.invokeMethod('sendOTP',(map<String,Object>)input1,(map<String,Object>)output1,(map<String,Object>)opt);
       // output1=(Map<string,object>) InwiB2C_OTPService.sendOTP((List<String>)listId,'111111');
        Test.stopTest();  
    }
    public static testMethod void testMethodOTP() {
        /* Begin JBE */
        Test.startTest();
        Map<String,Object> input = new Map<String,Object>();
        Map<string,Object> output =new Map<string,object>();
        Map<string,Object> opt =new Map<string,object>();
        output.put('SaraAsm','ts');
        boolean x=InwiB2C_OTPService.invokeMethod('resourceUrlOTP',(map<String,Object>)input,(map<String,Object>)output,(map<String,Object>)opt);
        
        Test.stopTest();    
    }
}