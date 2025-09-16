@isTest
global class inwiB2C_Deferred_MigrationTest {

    
    @isTest(SeeAllData=false)
     public static void TransformJsonTest()
    {
          Test.startTest();
       Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Integer CycledeFacturation = 18;
     
        inputMap.put('Cycle',CycledeFacturation);
        new inwiB2C_Deferred_Migration().invokeMethod('TransformJson',inputMap, outMap, options);
          Test.stopTest();
    }
}