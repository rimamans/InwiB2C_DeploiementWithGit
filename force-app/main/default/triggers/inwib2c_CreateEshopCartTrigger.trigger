trigger inwib2c_CreateEshopCartTrigger on inwib2c_createEshop__e (after insert) {
  for (inwib2c_createEshop__e event : Trigger.New) {
    Map <String, Object> Params = new Map <String, Object> ();
                Map <String, Object> options = new Map <String, Object> ();
                Map <String, Object> ipInput = new Map <String, Object> ();
                Map <String, Object> outMap = new Map <String, Object> ();
                
               //ipInput.put('inputMap',event.bodyJson__c);
                       //ipInput.put('TraceId',event.TraceId__c);
                        
                //Map <String, Object> ipInputbody = new Map <String, Object>
                //ipInputbody.put('bodyJson',event.bodyJson__c);
                
                Map <String, Object> inputMap = new Map <String, Object> ();
                 //inputMap.put('bodyJson',event.bodyJson__c);
                 inputMap.put('TraceId',event.TraceId__c);
                 String traceId =event.TraceId__c;
               
                //(new inwib2c_CreateOrderEshopV2()).invokeMethod('CreateOrderEshopV2',inputMap,outMap, options);
                (new inwib2c_CreateOrderEshop()).invokeMethod('CreateOrderEshop',inputMap,outMap, options);
                //(new inwib2c_CreateOrderEshopV2()).CreateOrderEshopV2(inputMap);
                //inwib2c_CreateOrderEshopV2.CreateOrderEshopV2(traceId);

               
               //System.debug('ipOptions'+ipOutput);
               //System.debug('Trace'+traceId);
                






  
  
}
}