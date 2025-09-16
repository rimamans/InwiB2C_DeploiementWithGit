@isTest
public class inwiB2c_executeVIPAsynchTest {
    @isTest(SeeAllData=true)
    public static void inwiB2c_executeVIPAsynchTest() {
        Test.startTest(); 

        String vipName = 'VIP_TEST';
        Map<String, Object> ipInput = new Map<String, Object>();
        Map<String, Object> ipOptions = new Map<String, Object>();
        
        Map<String, Object> Params = new Map<String, Object>();
        Params.put('Name',vipName);
        Params.put('ipInput',ipInput);
        Params.put('ipOptions',ipOptions);

        inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        Test.stopTest();

    }
}