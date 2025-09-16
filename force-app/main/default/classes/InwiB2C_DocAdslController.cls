/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class InwiB2C_DocAdslController {
            public List<Integer> loopList{ get; set; }
            public Map<String, Object> output{ get; set; }
            public String keys{ get; set; }
            public String transactions {get;set;}
        
            public InwiB2C_DocAdslController() {

         Map<String, Object> input = new Map<String, Object>();
                // Call vip
                input.put('orderid', Apexpages.currentPage().getParameters().get('orderid'));
                // input.put('OrderIdNew', Apexpages.currentPage().getParameters().get('NewOrderid'));
        
                output = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('InwiB2C_GetInfoDocBonLivraisonFromOrderid', input, null));
                System.debug(output);
                // Get response keys
                for (String item : output.keySet()){
                    keys = keys + item + '-';
                }
                System.debug(keys);


                loopList = new List<Integer>{ 0, 1,2 };
                
    }
}