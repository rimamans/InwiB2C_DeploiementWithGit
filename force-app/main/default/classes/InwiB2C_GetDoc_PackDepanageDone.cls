/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-14-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class InwiB2C_GetDoc_PackDepanageDone{
    public Map<String, Object> output{ get; set; }

    public String keys{ get; set; }
    public String transactions {get;set;}

    //public String code_transaction{ get; set; }

  //  public String date_facture{ get; set; }

 //   public String mode_paiement{ get; set; }
    //public String name{ get; set; }

 //   public List<Map<String, Object>> lignes{ get; set; }

   // public Decimal total_ttc{ get; set; }

    public InwiB2C_GetDoc_PackDepanageDone(){
        Map<String, Object> input = new Map<String, Object>();
        // Call vip
        input.put('OrderId', Apexpages.currentPage().getParameters().get('orderid'));
        input.put('CaseId', Apexpages.currentPage().getParameters().get('caseid'));
        input.put('OldOrderId', Apexpages.currentPage().getParameters().get('oldorderid'));


        output = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('InwiB2C_GetInfoFor_DepD1', input, null));
        System.debug(output);
        // Get response keys
        for (String item : output.keySet()){
            keys = keys + item + '-';
        }
        System.debug(keys);

        
    }

}