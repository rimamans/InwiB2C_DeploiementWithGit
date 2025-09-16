trigger inwiB2C_SubsMassProcessingTrigger on inwiB2C_SubsMassProcessingEvt__e (after insert) {
     String IP_SubsMassProcessing = 'inwib2c_InwiB2C_SubsMassProcessing';
     String IP_SubsMassNotification = 'inwib2c_InwiB2C_SubsMassNotification';

   for (inwiB2C_SubsMassProcessingEvt__e event : Trigger.New) {
      

   if (event.inwiB2C_MDN__c != null && event.inwiB2C_step__c == 'ResilPostPaye' ){

       
             Map <String, Object> ipInput = new Map <String, Object> ();
             Map <String, Object> ipOutput = new Map <String, Object> ();
             Map <String, Object> ipOptions = new Map <String, Object> ();
             
            /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
            ipInput.put('SubId', event.inwiB2C_MDN__c);
            ipInput.put('SubsAction', event.inwiB2C_Action__c);
            ipInput.put('MassProcessId', event.inwiB2C_SubMassId__c);
                
            String inputSerialized = JSON.serialize(ipInput);
            system.debug('INPUT FOR inputSerialized : '+ inputSerialized);
            InwiB2C_RunResiliationVIPSubsMass.RunResiliationVIPSubsMass(inputSerialized);
     
     }     
     /* Call the IP for SOA notification */
     else if (event.inwiB2C_MDN__c != null && event.inwiB2C_step__c == 'Notification' ){

       
             Map <String, Object> ipInput = new Map <String, Object> ();
             Map <String, Object> ipOutput = new Map <String, Object> ();
             Map <String, Object> ipOptions = new Map <String, Object> ();
             
             /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
            //ipInput.put('mdn', event.inwiB2C_MDN__c);  
            //ipInput.put('action', event.inwiB2C_Action__c);   
     
             
             /* Call the IP via runIntegrationService, and save the output to ipOutput */
             ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(IP_SubsMassNotification, ipInput, ipOptions);
     
     }     
   }
}