// Trigger for catching InwiB2C_replaceOffer__e events.
trigger inwiB2C_ReplaceOfferTrigger on InwiB2C_replaceOffer__e (after insert) {

   for (InwiB2C_replaceOffer__e event : Trigger.New) {
       if (event.inwiB2C_OrderId__c != null && event.inwiB2C_step__c.equals('checkout')){
       
     
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();

           
            inputMap.put('cartId',event.inwiB2C_OrderId__c);
            inputMap.put('ContextId',event.inwiB2C_OrderId__c);
            inputMap.put('methodName','checkout');
            
            vlocity_cmt.CpqAppHandler submitOrderCartsItem = new vlocity_cmt.CpqAppHandler();
            submitOrderCartsItem.invokeMethod('checkout', inputMap, outputMap, null);
            
       }
  
             else if (event.InwiB2C_OrderId__c != null && event.inwiB2C_step__c.equals('replaceoffer')){
             // call VIP replcace offer
             
             Map <String, Object> vipInput = new Map <String, Object> ();
             Map <String, Object> vipOutput = new Map <String, Object> ();
             Map <String, Object> vipOptions = new Map <String, Object> ();
             
             
            vipInput.put('methodName', event.InwiB2C_methodName__c);
            vipInput.put('items', event.InwiB2C_items__c);
            vipInput.put('cartId', event.InwiB2C_cartId__c);
            vipInput.put('price', event.InwiB2C_price__c);
            vipInput.put('validate', event.InwiB2C_validate__c);
            vipInput.put('includeAttachment', event.InwiB2C_includeAttachment__c);
            vipInput.put('pagesize', String.valueOf(event.InwiB2C_pagesize__c));
            vipInput.put('lastRecordId', event.InwiB2C_lastRecordId__c);
            vipInput.put('hierarchy', String.valueOf(event.InwiB2C_hierarchy__c));
            vipInput.put('query', event.InwiB2C_query__c);
            vipInput.put('replaceIntentSpecification', event.InwiB2C_replaceIntentSpecification__c);
            
            
            system.debug('event.InwiB2C_replaceIntentSpecification__c:');
            System.debug(JSON.serialize(event.InwiB2C_replaceIntentSpecification__c));

            system.debug('INPUT FOR REPLACE OFFRE: ');
            System.debug(JSON.serialize(vipInput));

            vipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_replaceOffer', vipInput, vipOptions);
             
            system.debug('OUTPUT OF  REPLACE OFFRE: '+ vipOutput + '  ' + 'inwib2c_InwiB2C_replaceOffer');

             
             }
   }
}