public with sharing class inwiB2C_MandatDegroupageFTTHController {

    public Map<String, Object> output{ get; set; }
    public String keys{ get; set; }
    public String transactions {get;set;}



    public inwiB2C_MandatDegroupageFTTHController() {


        Map<String, Object> input = new Map<String, Object>();
                // Call vip
                input.put('orderid', Apexpages.currentPage().getParameters().get('orderid'));
                
        
                output = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_GetInfoDocMandatDegroupageFTTH', input, null));
                System.debug(output);
                // Get response keys
                for (String item : output.keySet()){
                    keys = keys + item + '-';
                }
                System.debug(keys);


    }
}