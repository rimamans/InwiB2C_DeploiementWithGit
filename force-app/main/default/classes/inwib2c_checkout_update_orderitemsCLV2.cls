public class inwib2c_checkout_update_orderitemsCLV2 {
 @InvocableMethod
  public static void callVIP(List<Id> orderIdList){
    for (Id  orderId : orderIdList) {

      inwib2c_checkout_update_orderitemsCLV2.update_orderitem_billing_account(orderId);
      inwib2c_checkout_update_orderitemsCLV2.checkoutAPI(orderId);
      
               
    } 
  }

  //@future(callout=true)
  public static void update_orderitem_billing_account(Id orderId){

    System.debug('in update_orderitem_billing_accoun');

    Map<String, Object> ipInput = new Map<String, Object>();
    //ipInput.put('Id', orderId);
   // ipInput.put('inwiB2C_orderId__c', orderId);
    ipInput.put('OrderId', orderId);
    Map<String, Object> ipOptions = new Map<String, Object>();
    Map <String, Object> output =  (Map <String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_update_orderitem_billing_account', ipInput, ipOptions));
  }
     @future(callout=true)
  public static void checkoutAPI(Id orderId){

    System.debug('in checkoutAPI');

    Map<String, Object> ipInput = new Map<String, Object>();
    ipInput.put('Id', orderId);
    ipInput.put('inwiB2C_orderId__c', orderId);
    ipInput.put('OrderId', orderId);
    Map<String, Object> ipOptions = new Map<String, Object>();
    Map <String, Object> output =  (Map <String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_inwib2c_checkoutAPI', ipInput, ipOptions));
  }
}