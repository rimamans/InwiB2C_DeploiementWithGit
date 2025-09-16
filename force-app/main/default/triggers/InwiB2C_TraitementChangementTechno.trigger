trigger InwiB2C_TraitementChangementTechno on InwiB2C_Traitement_changement_techno__e (after insert) {
for (InwiB2C_Traitement_changement_techno__e event : Trigger.New) {
       if (event.InwiB2C_subscriptionId__c != null){
       
     
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('subscriptionId',event.InwiB2C_subscriptionId__c);
            inputMap.put('technoSource',event.InwiB2C_technologie_source__c);
            inputMap.put('technoCible',event.InwiB2C_technologie_cible__c);
            inputMap.put('demandeId',event.InwiB2C_demandeId__c);
            inputMap.put('type',event.InwiB2C_Type__c);
            optionsMap.put('useQueueableApexRemoting',true);

           outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_CreateUpdateTechnoOrder', inputMap, optionsMap);
         
         }}
}