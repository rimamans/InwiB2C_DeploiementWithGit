public with sharing class InwiB2C_RecuPaiementSAV {

    public Map<String, Object> output{ get; set; }

    public String keys{ get; set; }
    

    public InwiB2C_RecuPaiementSAV() {
 		Map<String, Object> input = new Map<String, Object>();
        // Call vip
        
        input.put('orderid', Apexpages.currentPage().getParameters().get('orderid'));
        
        System.debug('input ' +input);
        output = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_recu_paiement_terminal_SAV', input, null)); 
                      
         System.debug('output '+output);
        // Get response keys
        for (String item : output.keySet()){
            keys = keys + item + '-';
        }
        System.debug(keys);

        
    }

    }