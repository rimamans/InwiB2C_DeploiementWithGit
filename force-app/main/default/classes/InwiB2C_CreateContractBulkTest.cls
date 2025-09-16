@isTest
public class InwiB2C_CreateContractBulkTest {
    @isTest
    private static void testCreateContractBulkMethod(){
       //Case req = INWIB2C_DataFactorySMS.createCasewithSubscription();
      // List<String> id = new List<String>();
      // id.add(req.Id);
       Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock());
        //InwiB2C_CreateContractBulk Cls = new InwiB2C_CreateContractBulk();
       InwiB2C_CreateContractBulk.createContractBulk();
    }
}