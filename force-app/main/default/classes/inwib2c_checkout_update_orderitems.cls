public with sharing class inwib2c_checkout_update_orderitems{
    @future(callout = true)
    public static void callVIP(List<String> input){
        System.debug(input);
        for (String item : input){
          /*  System.debug(item);
            Map<String, Object> ipInput = new Map<String, Object>();
            ipInput.put('Id', item);
            ipInput.put('inwiB2C_orderId__c', item);
            ipInput.put('OrderId', item);
            Map<String, Object> ipOutput2 = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_update_orderitem_billing_account', ipInput, null));
            Map<String, Object> ipOutput = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_inwib2c_checkoutAPI', ipInput, null));
			*/
            // SAS - B-5218 update Status resiliation 16-08-2022 begin
            Map<String, Object> ipInput2 = new Map<String, Object>();
            ipInput2.put('Status', 'Clôturée');
            ipInput2.put('OrderId', item);
            Map<String, Object> ipOutput3 = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_UpdateRetentionStatusAfterApplyOffer', ipInput2, null));
             // SAS - B-5218 update Status resiliation 16-08-2022 end
        }
    }

}