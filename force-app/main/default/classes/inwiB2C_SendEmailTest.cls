@isTest
public class inwiB2C_SendEmailTest{
  private class RestMock implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      String fullJson = 'your Json Response';

      HTTPResponse res = new HTTPResponse();
      res.setHeader('Content-Type', 'text/json');
      res.setBody(fullJson);
      res.setStatusCode(200);
      return res;
    }

  }

  @isTest(SeeAllData = true)
  static void testThatEmailWasSent(){

    Test.setMock(HttpCalloutMock.class, new RestMock());
    Test.startTest();
    System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');

    //methodThatSendsEmail();
    Integer invocations = Limits.getEmailInvocations();

    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    String Email = 'rimamansour@live.fr';
    String invoiceId = '12345678899';
    String attName = 'FacturePDF.PDF';
    inputMap.put('email', Email);
    inputMap.put('invoiceId', invoiceId);
    inputMap.put('attName', attName);
    // String result = 'Testa aaa';
    // outMap.put('pdf', result);


    SendEmail.send(inputMap, outMap, options);
    System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
    Test.stopTest();
  }

  // @isTest(SeeAllData = true)
  // static void sendEmailTest(){
  //   Test.setMock(HttpCalloutMock.class, new RestMock());
  //   Test.startTest();
  //   SendEmail cls = new SendEmail();
  //   Map<String, Object> outMap = new Map<String, Object>();
  //   Map<String, Object> options = new Map<String, Object>();
  //   Map<String, Object> inputMap = new Map<String, Object>();
  //   String Email = 'rimamansour@live.fr';
  //   String invoiceId = '12345678899';
  //   String attName = 'FacturePDF.PDF';
  //   inputMap.put('Email', Email);
  //   inputMap.put('invoiceId', invoiceId);
  //   inputMap.put('attName', attName);
  //   boolean result = cls.invokeMethod('Send', inputMap, outMap, options);
  //   Test.StopTest();
  // }
}