public with sharing class InwiB2C_GenerationRecuPaiementE_Recharge {
    public String SubscriptionId {get;set;}
        public String num {get; set;}
    public String montant {get;set;}
    public String transactionCode {get;set;}
    public String typePay {get;set;}
    public String typeRecharge {get;set;}

 Map <String, Object> ipInput = new Map <String, Object> ();
    public  Map <String, Object> ipOutput {get;set;}
    Map <String, Object> ipOptions = new Map <String, Object> ();
    
    
        public String keys {get; set;}

    
    
    public InwiB2C_GenerationRecuPaiementE_Recharge() {

        // Get params
        SubscriptionId= Apexpages.currentPage().getParameters().get('subscriptionid');
        montant= Apexpages.currentPage().getParameters().get('montant');
        transactionCode=Apexpages.currentPage().getParameters().get('transcode');
        typePay = Apexpages.currentPage().getParameters().get('typepaiement');
        typeRecharge = Apexpages.currentPage().getParameters().get('typerecharge');
     // String procedureName = 'inwib2c_GetInfo_E_Recharge';
   
        System.debug('ID SubscriptionId IS :'+ SubscriptionId);

        // Call VPI
                System.debug(' ipOutput ddd :');

       String   procedureName = 'inwib2c_InwiB2C_GetInfo_E_Recharge';
            ipInput.put('SubscriptionId', SubscriptionId);
          ipOutput =  (Map <String, Object>) (vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions));
        System.debug(' ipInput IS :'+ ipInput);
        System.debug(' ipOutput IS :'+ ipOutput);

  //   numLigne= ipOutput.get('numLigne');
                 //   Num = (String) ipOutput.get('numLigne');
   
  for (String item : ipOutput.keySet()) {
            System.debug(' keys IS :'+ keys);

         keys = keys + item;
      }

    }


}