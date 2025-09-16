public with sharing class InwiB2C_FormulaireRemb{
    public Map<String, Object> output{ get; set; }

    public String keys{ get; set; }
    public String transactions {get;set;}

    //public String code_transaction{ get; set; }

  //  public String date_facture{ get; set; }

 //   public String mode_paiement{ get; set; }
    //public String name{ get; set; }

 //   public List<Map<String, Object>> lignes{ get; set; }

   // public Decimal total_ttc{ get; set; }

    public InwiB2C_FormulaireRemb(){
        Map<String, Object> input = new Map<String, Object>();
        // Call vip
        input.put('orderid', Apexpages.currentPage().getParameters().get('orderid'));
        transactions= Apexpages.currentPage().getParameters().get('trancation');

        output = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_formualireRemb', input, null));
        System.debug(output);
        // Get response keys
        for (String item : output.keySet()){
            keys = keys + item + '-';
        }
        System.debug(keys);

        
    }

}