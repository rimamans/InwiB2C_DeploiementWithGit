/**
 * This class exposes extends the Default System Interface class used by Order Management to
 * make a synchronous callout to an Integration Procedure (rather than a direct REST API call).
 *
 * The general flow is as follows:
 * 
 *  -----------    ------------------    ------------    -----------------------
 * | Orch Item |  | System Interface |  | this Class |  | Integration Procedure |
 *  -----------    ------------------    ------------    -----------------------
 *       |                 |                   |                    |
 *       |     execute     |                   |                    |
 *       |---------------->|    startBatch()   |                    |
 *       |                 |------------------>|                    |
 *       |                 |                   |                    |
 *       |                 |   executeItem()   |                    |
 *       |                 |------------------>|      call IP       |
 *       |                 |                   |------------------->|
 *       |                 |                   |                    |<----------> Do integration stuff
 *       |                 |                   |      response      |
 *       |                 | processResponse() |<-------------------|
 *       |                 |<------------------|                    |
 *       |                 |                   |                    |
 *       |                 |    endBatch()     |                    |
 *       |     complete    |------------------>|                    |
 *       |<----------------|                   |                    |
 *       |                 |                   |                    |
 *       
 *
 */
global class IntegrationProcedureSystemInterface extends vlocity_cmt.DefaultSystemInterface {

   /**
    * Default Constructor
    */
   global IntegrationProcedureSystemInterface() {
   	
       super();
   }

   /**
    * This method is a part of the ISystemInterface. It is invoked at the start of the batch
    * 
    * @param url   base URL the batch is started for
    * @param path  path this batch is started for
    */
   global override void startBatch(String url, String path) {}

   /**
    * Executes a Callout OrchestrationItem
    * 
    * @param url   base URL to send the request to (in this class it is ignored as we'll be calling an Integration Procedure)
    * @param path  path to send the request to (in this class it is interpreted as the Integration Procedure API Key)
    * @param item  OrchestrationItem that needs to be executed
    */
   global override void executeItem(String url, String path, vlocity_cmt__OrchestrationItem__c item) {

       System.debug(' - Orchestration Item -> ' + JSON.serialize(item.getPopulatedFieldsAsMap()));
       
       // Get the Order SObject - the technique will differ depending on if this orchestration item is related to an Order Item or a Fulfillment Request Line
       Id orderId = null;
       if (item.vlocity_cmt__OrderItemId__c != null) orderId = item.vlocity_cmt__OrderItemId__r.OrderId;
       else {
           
           vlocity_cmt__OrchestrationItem__c orchItem = [SELECT vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.Id FROM vlocity_cmt__OrchestrationItem__c WHERE Id = :item.Id];
           orderId = orchItem.vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.Id;
       }
       vlocity_cmt.XOMOrderDomainObject orderObj = ((vlocity_cmt.XOMOrderService)vlocity_cmt.XOMObjectFactory.getService(Order.SObjectType)).getObject(orderId, true);
       
     
       Map<String, Object> ipInput   = (Map<String, Object>)JSON.deserializeUntyped(super.generatePayload(item, orderObj));
       Map<String, Object> ipOptions = new Map<String, Object>();
       
       // Add any extra information to the payload that might be useful and otherwise not available via the DataRaptors configured in the Callout
       ipInput.put('orchestration_item_id',   item.Id);
       ipInput.put('orchestration_item_name', item.Name);       
       
       // Call the Integration Procedure
       System.debug(' - Attempting to call Integration Procedure "' + path + '"');
       System.debug(' - IP Input -> ' + JSON.serialize(ipInput));

       Map<String, Object> ipOutput = new Map<String, Object>();

       if(!Test.isRunningTest()){     
        ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(path, ipInput, ipOptions); 
       }else{
        ipOutput.put('status','1');

       }
        
       
       system.debug(ipOutput);

      try
        {
            //Check if the VIP is Active
            String vipError = (String) ipOutput.get('error');
           

            if (vipError != null)
            {
                    throw new DefaultInterfaceUnrecoverableException (vipError);
            }
		
            String sysError = String.valueOf(ipOutput.get('status'));
            system.debug('ipOutput' + ipOutput );
            system.debug('sysError' + sysError);
           if (sysError != '1' && sysError != '305' )
            {
                    //The call is not successful but we need just to log the request and response error.
                    processResponse(item, ipInput, ipOutput);
                    throw new DefaultInterfaceUnrecoverableException ('Le système cible a renvoyé le code erreur suivant: ' + sysError);
            }


            // The call is successful, let's give subclasses a chance to process response
            processResponse(item, ipInput, ipOutput);

        }
        catch (CalloutException e)
        {
            throw new vlocity_cmt.XOMOrchestrationInterfaces.SystemInterfaceRecoverableException ('Callout exception '
                    + e + ': trying to retry');
        }
   }

   /**
    * This method is called from executeItem to handle the response from the Integration Procedure.
    * By default it does nothing (but some logging), but it could be customized to do something more.
    *
    * @param item      The Orchestration Item
    * @param ipInput   The request sent to the Integration Procedure
    * @param ipOutput  The response from the Integration Procedure
    */
   global virtual void processResponse(vlocity_cmt__OrchestrationItem__c item, Map<String, Object> ipInput, Map<String, Object> ipOutput) {

       // Do nothing by default
       System.debug(' - IP Output -> ' + JSON.serialize(ipOutput));

       // For debugging, store the Request in the Orchestration Item SObject
       item.vlocity_cmt__Request__c = JSON.serialize(ipInput);
       item.vlocity_cmt__Response__c = JSON.serialize(ipOutput);
       update item;

   }
   
   /**
    * This method is called at the end of the batch
    * 
    * @param url   base URL for the batch
    * @param path  path for the batch
    */
   global override void endBatch(String url, String path) {}   
}