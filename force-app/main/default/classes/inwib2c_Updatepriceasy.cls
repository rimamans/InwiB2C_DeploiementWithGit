public with sharing class inwib2c_Updatepriceasy {
    @future(callout = true)
    public static void  inwib2c_Updatepriceasy(String paramsSerialized) {
        Map<String, Object> Params = ( Map<String, Object>)JSON.deserializeUntyped(paramsSerialized);
        String orderid = (String) Params.get('orderid');
        String itemid = (String) Params.get('itemid');
        Double prix= (Double) Params.get('prix');

        System.debug('orderidfuture' + orderid);
        System.debug('itemidfuture' + itemid);
        

               Map <String, Object> optionsMap= new Map <String, Object> ();
                Map <String, Object> ipInput = new Map <String, Object> ();
                Map <String, Object> outputMap = new Map <String, Object> ();
                Map <String, Object> inputMap = new Map <String, Object> ();
                Map<String, Object> adjustMap = new Map<String, Object> ();
                List<Object> adjustList = new List<Object> ();
                adjustMap.put('AdjustmentMethod','Absolute');
                adjustMap.put('AdjustmentType','Override');
                adjustMap.put('AdjustmentCode','');
                adjustMap.put('DetailType','OVERRIDE');
                adjustMap.put('Field','vlocity_cmt__OneTimeCharge__c');
                adjustMap.put('PricingVariableCode','OT_STD_PRC');
                adjustMap.put('AdjustmentValue',prix);
                adjustList.add(adjustMap);
                inputMap.put('cartId',orderid);
                inputMap.put('id',itemid);
                inputMap.put('adjustments',adjustList);
                inputMap.put('methodName','applyAdjustment');
                System.debug('Constructed inputParams in future: ' + inputMap);
                 vlocity_cmt.CpqAppHandler applyAdjustmentItem = new vlocity_cmt.CpqAppHandler();
                 applyAdjustmentItem.invokeMethod('applyAdjustment', inputMap, outputMap, null);
                 System.debug('Output Map after applying adjustment future: ' + outputMap);
                
                }
}