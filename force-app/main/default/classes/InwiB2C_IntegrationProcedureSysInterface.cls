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
global class InwiB2C_IntegrationProcedureSysInterface extends vlocity_cmt.DefaultSystemInterface {

   /**
    * Default Constructor
    */
   global InwiB2C_IntegrationProcedureSysInterface() {
   	
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
       
       Map<String, Object> ipInput = new Map<String, Object>();
        if (!Test.isRunningTest()) {
      		ipInput   = (Map<String, Object>)JSON.deserializeUntyped(super.generatePayload(item, orderObj));
        }
       Map<String, Object> ipOptions = new Map<String, Object>();
       
       // Add any extra information to the payload that might be useful and otherwise not available via the DataRaptors configured in the Callout
       ipInput.put('orchestration_item_id',   item.Id);
       ipInput.put('orchestration_item_name', item.Name);       
       
       // Call the Integration Procedure
       System.debug(' - Attempting to call Integration Procedure "' + path + '"');
       System.debug(' - IP Input -> ' + JSON.serialize(ipInput));
       Map<String, Object> ipOutput = new Map<String, Object>(); 
       if(!Test.isRunningTest()){     
        try{
        ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(path, ipInput, ipOptions); 
        }catch(TypeException e)
        {
            throw new vlocity_cmt.XOMOrchestrationInterfaces.SystemInterfaceRecoverableException ('Conversion exception '+ e + ': trying to retry');
        }
        }else{
           ipOutput = (Map<String, Object>)JSON.deserializeUntyped(url);
        } 
            String sysError = String.valueOf(ipOutput.get('status'));
		
           //Get execution success status
            Boolean successStatus = true;
            for(String key:ipOutput.keySet()){
                if(key == 'success') successStatus = (Boolean)ipOutput.get('success');  
            }

            //Serialize output if success status is false
            String  recoverableError;
            if(successStatus == false){
                recoverableError = (String)JSON.serialize(ipOutput);
            }
            
           //Update request,response and state after the call
           if (sysError != '305')
            {
          // H-M Ticket B-15313 force l'etape pour le cas on recois le  message":"Check contract status !!! Contract may be already suspended."
          // deserialize recoverableError to extract the message  
          String message = '';
          if (recoverableError != null) {
              // Désérialiser le JSON dans un type non typé (Map ou List)
              Object deserialized = JSON.deserializeUntyped(recoverableError);
          
              // Vérifier si le type désérialisé est une Map
              if (deserialized instanceof Map<String, Object>) {
                  Map<String, Object> errorMap = (Map<String, Object>) deserialized;
          
                  // Vérifier si 'result' est présent dans la Map
                  if (errorMap.containsKey('result')) {
                      Object result = errorMap.get('result');
          
                      // Vérifier si 'result' est une carte (Map)
                      if (result instanceof Map<String, Object>) {
                          Map<String, Object> resultMap = (Map<String, Object>) result;
          
                          if (resultMap.containsKey('message')) {
                              message = (String) resultMap.get('message');
                          }
                      }
                      // Si 'result' est une liste, parcourir la liste
                      else if (result instanceof List<Object>) {
                          List<Object> resultList = (List<Object>) result;
          
                          // Parcourir la liste et vérifier les objets à l'intérieur
                          for (Object listItem : resultList) {
                              if (listItem instanceof Map<String, Object>) {
                                  Map<String, Object> resultMap = (Map<String, Object>) listItem;
          
                                  if (resultMap.containsKey('message')) {
                                      message = (String) resultMap.get('message');
                                      break;
                                  }
                              }
                          }
                      }
                  }
              }
          }
          
          // Si le message spécifique est présent, traiter la réponse
          if (message.contains('Check contract status !!! Contract may be already suspended.')) {
            processResponse(item, ipInput, ipOutput);
         } 
          
         // H-M Ticket B-15313 END 
              else if (sysError == '0' || sysError == null || (recoverableError != null && (recoverableError.contains('503') || recoverableError.contains('500'))))
                {
                    //The call is not successful but we need to retry and to log the request and response error.
                    if(!Test.isRunningTest()){
                        processResponse(item, ipInput, ipOutput);
                        throw new vlocity_cmt.XOMOrchestrationInterfaces.SystemInterfaceRecoverableException('Le système cible a renvoyé le code erreur suivant: ' + sysError);
   
                    } else  processResponse(item, ipInput, ipOutput);

                } else if (sysError == '1') { processResponse(item, ipInput, ipOutput); }

                else{
                        if(!Test.isRunningTest()) throw new DefaultInterfaceUnrecoverableException ('Le système cible a renvoyé le code erreur suivant: ' + sysError);
                        else  processResponse(item, ipInput, ipOutput);
                    }       
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