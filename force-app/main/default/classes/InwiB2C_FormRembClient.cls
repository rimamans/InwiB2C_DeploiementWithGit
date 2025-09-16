/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-01-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class InwiB2C_FormRembClient {

    public Map<String, Object> output{ get; set; }

    public String keys{ get; set; }
    public String transactions {get;set;}

    public InwiB2C_FormRembClient() {
 Map<String, Object> input = new Map<String, Object>();
        // Call vip
        input.put('IdDemande', Apexpages.currentPage().getParameters().get('demandeid'));
        // input.put('OrderIdNew', Apexpages.currentPage().getParameters().get('NewOrderid'));
        transactions= Apexpages.currentPage().getParameters().get('trancation');

        output = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('InwiB2C_GetInformationDocRembClientByOrderId', input, null));
        System.debug(output);
        // Get response keys
        for (String item : output.keySet()){
            keys = keys + item + '-';
        }
        System.debug(keys);

        
    }

    }