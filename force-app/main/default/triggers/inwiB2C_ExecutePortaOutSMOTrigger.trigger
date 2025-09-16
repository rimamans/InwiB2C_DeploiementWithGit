trigger inwiB2C_ExecutePortaOutSMOTrigger on InwiB2C_TraitementPortaOutSMO__e (after insert) {


   for (InwiB2C_TraitementPortaOutSMO__e event : Trigger.New) {
       if (event.TraceId__c != null){
       
         String IP_ExecutePortaOut = 'inwib2c_InwiB2C_TraitementPortaOut';
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('TraceId',event.TraceId__c);
           // optionsMap.put('useQueueableApexRemoting',true);

            system.debug('Trigger inwiB2C_ExecutePortaOutSMOTrigger ');
            
            System.debug(inputMap);
            Map <String, Object> Params = new Map <String, Object> ();
             Params.put('Name',IP_ExecutePortaOut);
             Params.put('ipInput',inputMap);
             Params.put('ipOptions',optionsMap);
             
            //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
           //outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_TraitementPortaOut', inputMap, optionsMap);
           //system.debug(outputMap);
         }
         
      }

}