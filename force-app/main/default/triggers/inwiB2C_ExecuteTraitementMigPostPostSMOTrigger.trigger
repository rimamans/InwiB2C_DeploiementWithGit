trigger inwiB2C_ExecuteTraitementMigPostPostSMOTrigger on inwiB2C_ExecuteTraitementMigPostPostSMO__e (after insert) {
for (inwiB2C_ExecuteTraitementMigPostPostSMO__e event : Trigger.New) {
       if (event.InwiB2C_TraceId__c!= null){
         //chb ano B-17234 27/06/2024 Begin */
     
            Map<String, Object> inputMap = new Map<String, Object> ();
            //Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            Map <String, Object> Params = new Map <String, Object> ();
            inputMap.put('TraceId',event.InwiB2C_TraceId__c);
            //optionsMap.put('useQueueableApexRemoting',true);
 
           //outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_TraitementMigPostPost', inputMap, optionsMap);
           Params.put('Name','inwib2c_InwiB2C_TraitementMigPostPost');
           Params.put('ipInput',inputMap);
           Params.put('ipOptions',optionsMap);
           //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
           inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
           /* Call the IP via runIntegrationService, and save the output to ipOutput */
          //chb ano B-17234 27/06/2024 end */
         }
         
      }

}