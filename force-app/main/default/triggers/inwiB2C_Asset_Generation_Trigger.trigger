trigger inwiB2C_Asset_Generation_Trigger on inwiB2C_Asset_Generation__e (after insert) {
 for (inwiB2C_Asset_Generation__e event : Trigger.New) {
     
          if (event.AssetId__c != null ){
               Id orderId;
            ///////////////////////////////CreateOrder///////////////////////////////
                   
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            Map<String, Object> data = new Map<String, Object> ();
         
            data.put('accountId', (Id)event.AccountId__c);
            data.put('subaction', 'assetToOrder');
            data.put('source', event.Source__c);
            data.put('requestDateTime',Datetime.now().format('yyyy-MM-dd\' \'HH:mm:ss'));
            data.put('id', (Id)event.AssetId__c );

            inputMap.put('inputMap',(Map<String, Object>)data);
            inputMap.put('TraceId',event.inwiB2C_TraceId__c);

            optionsMap.put('useQueueableApexRemoting',true);

            System.debug('AssetToOrderRequest');
            System.debug(JSON.serialize(inputMap));

            if(!Test.isRunningTest()) {  
                //createOrder.invokeMethod('assetToOrder', inputMap, outputMap, options);
                outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_inwiB2C_ExecuteSynchAsset', inputMap, optionsMap);
                System.debug('AssetToOrderResponse');
                System.debug(JSON.serialize(outputMap));
                orderId = (String) outputMap.get('OrderId');
               }
              else {
                  list<Object>result= new list<Object>();
                  result.add('fields');
                  outputMap.put('result',result);
                  orderId=event.OrderId__c;
                  
              }
          
           /*   
           
        JSONParser parser = JSON.createParser(json.serialize(outputMap, true));
            while (parser.nextToken() != Null) {
                if (parser.getCurrentName() == 'result') {
                    parser.nextToken();  
                  while (parser.nextToken() != Null) {
                        if (parser.getCurrentName() == 'fields') {
                            while (parser.nextToken() != Null) {                                  
                                    if (parser.getCurrentName() == 'cartId') {
                                    orderId = Id.valueOf(parser.getText());
                                   break;
                                 }
                            parser.nextToken();
                        }
                        }
                        parser.nextToken();
                    }

                    break;
                } 
            }*/
              
         // }
          /*
                event.OrderId__c=orderId;
          List<Order> ord =[SELECT Id, inwiB2C_TypeActeDeGestion__c,inwiB2C_Statut__c, inwib2c_TypeDeLaCommande__c FROM Order WHERE Id =:orderId limit 1];
            if(ord.size()>0){
                ord[0].inwiB2C_TypeActeDeGestion__c ='inwiB2C_Synchronisation_Assets';
                ord[0].inwiB2C_Statut__c = 'inwiB2C_Activee';
                ord[0].inwib2c_TypeDeLaCommande__c='inwiB2C_Modification';
                Update ord;
             }
            
             }*/
              
           ///////////////////////////////Checkout///////////////////////////////
           /* Map<String, Object> inputMapChOut = new Map<String, Object> ();
            Map<String, Object> outputMapChOut = new Map<String, Object> ();
            Map<String, Object> optionsMapChOut = new Map<String, Object> ();

           
            inputMapChOut.put('cartId',orderId);
            inputMapChOut.put('ContextId',orderId);
            inputMapChOut.put('methodName','checkout');
            
            vlocity_cmt.CpqAppHandler submitOrderCartsItem = new vlocity_cmt.CpqAppHandler();
            submitOrderCartsItem.invokeMethod('checkout', inputMapChOut, outputMapChOut, null);*/
            /*
             Map<String, Object> inputMapChOut = new Map<String, Object> ();
             Map<String, Object> outputMapChOut = new Map<String, Object> ();
             Map<String, Object> optionsMapChOut = new Map<String, Object> ();
                                   
             inputMapChOut.put('Id',event.OrderId__c);

              //{"isDebug":true, "chainable":false, "resetCache":false, "ignoreCache":true, "queueableChainable":false, "useQueueableApexRemoting":false}
                                   
             optionsMapChOut.put('useQueueableApexRemoting',true);
             outputMapChOut = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_CheckoutOrderAPI', inputMapChOut, optionsMapChOut);
             System.debug('CheckoutResponse');
             List <Object>  messages = (List <Object>) outputMapChOut.get('messages');

             if (messages != null){
                    System.debug('messages size : '+ messages.size());

                     for (Object m:messages){
                         Map <String, Object> mm = (Map <String, Object>) m;
                         String message = (String)mm.get('message');
                         System.debug(message);
                                        }

                                   }
                                   
          */
          
          }
        }
          
        
}