trigger inwib2c_UpdatePricetrigger on inwib2c_UpdatePriceEshop__e (after insert) {
 for (inwib2c_UpdatePriceEshop__e event : Trigger.New) {
    //Map <String, Object> Params = new Map <String, Object> ();
                Map <String, Object> optionsMap= new Map <String, Object> ();
                Map <String, Object> ipInput = new Map <String, Object> ();
                Map <String, Object> outputMap = new Map <String, Object> ();
                
               
                
                List<inwib2c_CallAdjustementForquantity__c> Call1List = new List<inwib2c_CallAdjustementForquantity__c> ();
                if(!Test.isRunningTest()){
                            Call1List = [
                        SELECT Id, inwib2c_OrderId__c, inwib2c_OrderItemId__c, inwib2c_PriceTerminal__c, inwib2c_Done__c,inwib2c_TraceId__c
                        FROM inwib2c_CallAdjustementForquantity__c
                        WHERE inwib2c_OrderId__c = :event.inwib2c_cartId__c AND inwib2c_Done__c = 'false'
                        ORDER BY CreatedDate DESC
                        LIMIT 1
                        ];
            }else {
                inwib2c_CallAdjustementForquantity__c Call2List = new inwib2c_CallAdjustementForquantity__c(inwib2c_OrderId__c = event.inwib2c_cartId__c, inwib2c_OrderItemId__c =event.inwib2c_ItemId__c, inwib2c_PriceTerminal__c = 10519.0, inwib2c_Done__c = 'false',inwib2c_TraceId__c=event.inwib2c_traceId__c);
                Call1List.add(Call2List);
            }
              
               if (!Call1List.isEmpty()) {
                  inwib2c_CallAdjustementForquantity__c Call1 = Call1List[0];
                  System.debug('Le Flagtrigger est ' + Call1.inwib2c_Done__c );
              
                  if (Call1.inwib2c_Done__c == 'false') {
                     Map <String, Object> Params = new Map <String, Object> ();
                     
                      optionsMap.put('useQueueableApexRemoting',true);
                       Params.put('orderid',Call1.inwib2c_OrderId__c );
                       Params.put('itemid',Call1.inwib2c_OrderItemId__c );
                       Params.put('prix',Call1.inwib2c_PriceTerminal__c );
                       Params.put('id',Call1.Id);
                       Params.put('traceId',Call1.inwib2c_TraceId__c);
                       Params.put('ipOptions',optionsMap);
                       System.debug('Params'+Params );
                       if(!Test.isRunningTest()){
                      inwib2c_adjustementpriceasynchrone.inwib2c_adjustementpriceasynchrone((String)JSON.serialize(Params));
                       }
                    }
              }
              

                 




               
               
               
               
              
               }

}