trigger inwiB2C_ExecuteMigrPrePostTrigger on inwiB2C_ExecuteMigrPrePostEvent__e (after insert) {
    for (inwiB2C_ExecuteMigrPrePostEvent__e event : Trigger.New) {
           if (event.InwiB2C_TraceId__c!= null){
                Map <String, Object> Params = new Map <String, Object> ();
                Map<String, Object> inputMap = new Map<String, Object> ();
                //chb ano B-17234 27/06/2024 begin */
                //Map<String, Object> outputMap = new Map<String, Object> ();
                Map<String, Object> optionsMap = new Map<String, Object> ();
                
                inputMap.put('TraceId',event.InwiB2C_TraceId__c);
                //optionsMap.put('useQueueableApexRemoting',true);
    
              // outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_TraitementMigPrePost', inputMap, optionsMap);
             
               /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
              
               Params.put('Name','inwib2c_InwiB2C_TraitementMigPrePost');
               Params.put('ipInput',inputMap);
               Params.put('ipOptions',optionsMap);
               system.debug('Params'+(String)JSON.serialize(Params));
               
               //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
               inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
               /* Call the IP via runIntegrationService, and save the output to ipOutput */
                   //chb ano B-17234 27/06/2024 end */
                   //Y_Mh begin add option volte in mig prepost 10_03_2025 */
             } else if(event.inwiB2C_OrderId__c != null && event.inwib2c_Option_Code__c != null) {
 Map<String, Object> Params = new Map<String, Object>();
            Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> optionsMap = new Map<String, Object>();

            
            inputMap.put('cartId',event.inwiB2C_OrderId__c);
            inputMap.put('OptionCode',event.inwib2c_Option_Code__c);
            
            Params.put('Name', 'inwib2c_inwiB2C_AddOptionInOrderMigrationPrePost');
            Params.put('ipInput', inputMap);
            Params.put('ipOptions', optionsMap);
            
            system.debug('Params' + (String) JSON.serialize(Params));
            
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String) JSON.serialize(Params));

 }//Y_Mh end add option volte in mig prepost 10_03_2025 */
             
          }
    
    }