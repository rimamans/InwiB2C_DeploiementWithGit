trigger inwib2c_UpdateConfirmationPaiementPricetrigger on inwib2c_PaiementConfirmationAdjustPrice__e (after insert) {
 for (inwib2c_PaiementConfirmationAdjustPrice__e event : Trigger.New) {
                Map <String, Object> optionsMap= new Map <String, Object> ();
                Map <String, Object> ipInput = new Map <String, Object> ();
                Map <String, Object> outputMap = new Map <String, Object> ();
                Map <String, Object> Params = new Map <String, Object> ();
                     
                      optionsMap.put('useQueueableApexRemoting',true);
                       Params.put('orderid',event.inwib2c_cartId__c);
                       Params.put('itemid',event.inwib2c_ItemId__c);
                       Params.put('prix',event.inwib2c_Price__c);
                       Params.put('ipOptions',optionsMap);
                       System.debug('Params'+Params );
                      
                      inwib2c_Updatepriceasy.inwib2c_Updatepriceasy((String)JSON.serialize(Params));
                       
                    
               
               
              
               }

}