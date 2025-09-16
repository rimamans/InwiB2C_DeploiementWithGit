trigger INWIB2C_CancelDemandeResiliationTrigger on INWIB2C_CancelDemandeResiliation__e (after insert) {
        
        
        
         for (INWIB2C_CancelDemandeResiliation__e event : Trigger.New) { 
                Map <String, Object> ipInput = new Map <String, Object> ();
                Map <String, Object> ipOptions = new Map <String, Object> ();
                Map <String, Object> ipOutput = new Map <String, Object> ();                           
                ipInput.put('idrequesttocancel',event.idrequesttocancel__c);
                ipInput.put('motifcancel',event.motifcancel__c);
                ipInput.put('subscriptionid',event.subscriptionid__c);
                System.debug('input ipInput'+ipInput);
                (new inwiB2C_CancelDemandeResiliation()).invokeMethod('cancelDemandeResilaition',ipInput, ipOutput, ipOptions);
                System.debug('ipOutput'+ipOutput);
                List<vlocity_cmt__Subscription__c > SubsList =new List <vlocity_cmt__Subscription__c >();
                SubsList.add(new vlocity_cmt__Subscription__c (id = event.subscriptionid__c, InwiB2C_A_r_silier__c  = false));
                //system.debug('listSubCancel'+SubsList);
                update SubsList;
         }
          
}