/**
 * @description       : getOption
 * @author            : Chadia bani
 * @group             : 
 * @last modified on  : 23-04-2024
 * @last modified by  : CHB
**/
global class inwiB2C_AddOptionInOrder implements vlocity_cmt.VlocityOpenInterface{
   
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
        Boolean result = true;
        try{

        if (methodName.equals('getOption')){
            getOption(inputs, output);
        }
  
      } catch (Exception e){
  
        result = false;
  
      }
  
      return result;
    }
   
    private void getOption(Map<String, Object> inputMap, Map<String, Object> outMap){
        List<Map<String, Object>> outputList = new List<Map<String, Object>>();

        Map <String, Object> responseMap = new Map <String, Object> ();
       Map <String, Object> inputMapGet = new Map <String, Object> ();
      //  Map<String, Object> adjustMap = new Map<String, Object> ();
        //get params
       String cartId = (String) inputMap.get('cartId');
       String OptionCode = (String) inputMap.get('OptionCode');
       vlocity_cmt.CpqAppHandler getCartsItems = new vlocity_cmt.CpqAppHandler();
        /* Structure input 
       "cartId": "%cartId%",
        "includeAttachment": false,
        "methodName": "getCartsItems",
        "pagesize": 20*/
        inputMapGet.put('cartId',cartId);
        inputMapGet.put('includeAttachment',false);
        inputMapGet.put('methodName','getCartsItems');
        inputMapGet.put('pagesize',20);
        getCartsItems.invokeMethod('getCartsItems', inputMapGet, responseMap, null);
        System.debug('apres invoke ');
        if (responseMap.containsKey('records')) {
            List<Object> records = (List<Object>) responseMap.get('records');
            System.debug('records ' + records);
        }
        System.debug('records aapres records');
        outMap.put('result',responseMap);
    
    }
}