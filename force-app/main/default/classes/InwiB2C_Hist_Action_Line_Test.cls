@isTest
public class InwiB2C_Hist_Action_Line_Test {

     @isTest(SeeAllData=true)
   	static void InsertHistoryAction()
{
    Map<String,Object> outMap = new  Map<String,Object>();
 	Map<String,Object> options = new  Map<String,Object>();
    Map<String,Object> inputMap = new  Map<String,Object>();

    options.put('Mdn', '0011223344');
    options.put('AssetID', 'TESTCLASS');
    options.put('MontantOperation', 100);
    options.put('ActionOperation', 'Deblocage');
    options.put('SubActionOperation', 'Test Deblocage');
    options.put('StatutOperation', 'success');
    options.put('ErrorCodeOperation', 'NA');
   InwiB2C_OperationHistory cls = new InwiB2C_OperationHistory(); 
   
    boolean result = cls.invokeMethod('AddOperationHistory',inputMap, outMap, options);
    //System.assertEquals(true, result);

    //System.debug(outMap);

}
    
}