@isTest
public class inwiB2C_InvoiceIntegrationTest {

          @isTest(SeeAllData=true)
   	static void MethodePositive()
{
    Map<String,Object> outMap = new  Map<String,Object>();
 	Map<String,Object> options = new  Map<String,Object>();
    Map<String,Object> inputMap = new  Map<String,Object>();

    Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock()); 
    //INWIB2C_SendSMSCase.SendSMS(id);
	
    inwiB2C_InvoiceIntegration cls = new inwiB2C_InvoiceIntegration(); 
   
   boolean result = cls.invokeMethod('getInvoice',inputMap, outMap, options);
   System.assertEquals(true, result);

}
}