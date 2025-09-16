@isTest 
public class inwiB2C_FormatCodeSFTest {
@isTest (SeeAllData=true)
    static void inwiB2C_FormatCodeSFTest() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        new inwiB2C_FormatCodeSF().invokeMethod('convertCode',inputMap,outMap,options);
        inputMap.put('RIB','002810123456789123456700');
        new inwiB2C_FormatCodeSF().invokeMethod('CheckRib',inputMap,outMap,options);
        new inwiB2C_FormatCodeSF().invokeMethod('CheckBlacklist',inputMap,outMap,options);
    }}