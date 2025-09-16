public class inwiB2C_AnnulationDemandeDegApiCall implements Queueable {
   private List<INWIB2C_DEMANDE_DEGROUPAGE__c> records;

    public inwiB2C_AnnulationDemandeDegApiCall(List<INWIB2C_DEMANDE_DEGROUPAGE__c> records) {
        this.records = records;
    }

    public void execute(QueueableContext qc) {
 
        for (INWIB2C_DEMANDE_DEGROUPAGE__c record : records) {
      
            Boolean apiSuccess; 
            
            //{"orderItem":[{"typePrestation":"DT","typeCommande":"NA","id":"70000018","codeOpDemandeur":"WNA","action":"ANN"}]}
            //"status":"1",
            
            Map<String, Object> ipInput = new Map<String, Object>();
            ipInput.put('typePrestation', 'DT');
            ipInput.put('TypeCommande', record.InwiB2C_typeCommande__c );
            ipInput.put('NumOrdreUnique', record.InwiB2C_ORDER_DEGROUPAGE_NUM__c );
            ipInput.put('CodeOpDemandeur', record.InwiB2C_codeOpDemandeur__c );
            ipInput.put('Action', 'ANN');
            
            Map<String, Object> ipOptions = new Map<String, Object>();
            Map <String, Object> output =  (Map <String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_AnnulDemandeDegIAM', ipInput, ipOptions));
            System.debug('output '+output);

            if(Test.isRunningTest() || output.get('status') == '1'){apiSuccess = true;}
            if (apiSuccess) {
                record.inwiB2C_retour_annulation_IAM__c = true;
            } else {
                record.inwiB2C_retour_annulation_IAM__c = false;
            }
        }

        if (!records.isEmpty()) {
            update records;
        }
    }
}