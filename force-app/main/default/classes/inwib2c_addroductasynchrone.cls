public without sharing class inwib2c_addroductasynchrone {
    @future(callout = true)
    public static void  inwib2c_addroductasynchrone(String paramsSerialized) {
        Map<String, Object> Params = ( Map<String, Object>)JSON.deserializeUntyped(paramsSerialized);
        String cartId = (String) Params.get('orderid');
        String itemId = (String) Params.get('itemid');
        String PanierId = (String) Params.get('PanierId');
        String TraceId = (String) Params.get('TraceId');
    

        System.debug('orderidfuture' + cartId);
        System.debug('itemidfuture' + itemId);
        System.debug('PanierId' + PanierId);
        System.debug('TraceId' + TraceId);
        
        
        
           
               // Amine Bouremma Build input JSON
               Map<String, Object> inputMap = new Map<String, Object>();
               Map <String, Object> outputMap = new Map <String, Object> ();
               Map <String, Object> optionsMap= new Map <String, Object> ();
               inputMap.put('cartId', cartId);
              List<Map<String, String>> items = new List<Map<String, String>>();
              Map<String, String> item = new Map<String, String>();
                item.put('itemId', itemId);
                items.add(item);
                inputMap.put('items', items);
                inputMap.put('price', false);
                inputMap.put('validate', false);
                inputMap.put('methodName','postCartsItems');
                optionsMap.put('useQueueableApexRemoting',true);
                System.debug('Constructed inputParams in future: ' + inputMap);
                 vlocity_cmt.CpqAppHandler postCartsItemsItem = new vlocity_cmt.CpqAppHandler();
                 postCartsItemsItem.invokeMethod('postCartsItems', inputMap, outputMap, optionsMap);
                 System.debug('Output Amine Brm after applying postCartItems future: ' + outputMap);
                
                 //Call Vip 
                 String procedureName = 'Inwi_InwiB2C_TraitementCreateSMODigita';
                 Map <String, Object> ipInput = new Map <String, Object> ();
                 Map <String, Object> ipOutput = new Map <String, Object> ();
                 Map <String, Object> ipOptions = new Map <String, Object> ();
                     ipInput.put('OrderId', cartId);
                     ipInput.put('PanierId', PanierId);
                     ipInput.put('TraceId', TraceId);
                     System.debug('InputVIP' +ipInput);

               ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('Inwi_InwiB2C_TraitementCreateSMODigita', ipInput, ipOptions);

            System.debug('OutputVIP' +ipOutput);
           
            System.debug(JSON.serialize(ipOutput));
                
               
               
                
                }
}