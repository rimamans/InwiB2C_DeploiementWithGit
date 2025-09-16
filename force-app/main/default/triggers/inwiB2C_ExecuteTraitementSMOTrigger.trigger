trigger inwiB2C_ExecuteTraitementSMOTrigger on inwiB2C_ExecuteTraitementSMO__e (after insert) {


   for (inwiB2C_ExecuteTraitementSMO__e event : Trigger.New) {
       if (event.TraceId__c != null){
         //chb ano B-17234 27/06/2024 Begin */
            Map <String, Object> Params = new Map <String, Object> ();

            Map<String, Object> inputMap = new Map<String, Object> ();
            //Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('TraceId',event.TraceId__c);
            //optionsMap.put('useQueueableApexRemoting',true);

           //outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_TraitementSMO', inputMap, optionsMap);
           Params.put('Name','inwib2c_InwiB2C_TraitementSMO');
           Params.put('ipInput',inputMap);
           Params.put('ipOptions',optionsMap);
           system.debug('Params'+(String)JSON.serialize(Params));
           
           //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
           inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
           /* Call the IP via runIntegrationService, and save the output to ipOutput */
               //chb ano B-17234 27/06/2024 end */
         
         }
         
      }

}