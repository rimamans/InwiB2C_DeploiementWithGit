@isTest
public class inwiB2C_IncrementationSequenceTest {
@isTest (SeeAllData=true)
     static void IncrementationSequenceTest(){
        Test.startTest(); 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
         new InwiB2C_IncrementaionSequence().invokeMethod('incrementation',inputMap,outMap,options);
         new InwiB2C_IncrementaionSequence().invokeMethod('insertsequence',inputMap,outMap,options);
     }
}