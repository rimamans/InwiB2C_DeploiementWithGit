@isTest
public class InwiB2C_FTTHPassLogGeneration_Test {
@isTest (SeeAllData=true)
    static void InwiB2C_FTTHPassLogGeneration_Test(){
        Test.startTest();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        inputMap.put('ordernbr','123456');
        new inwiB2C_FTTHPassLogGeneration().invokeMethod('GenerateLogMdp',inputMap,outMap,options);
        //result.put('LG123456', login);
        //result.put('AZERTY123456azer', mdp);
        Test.stopTest();
    }
}