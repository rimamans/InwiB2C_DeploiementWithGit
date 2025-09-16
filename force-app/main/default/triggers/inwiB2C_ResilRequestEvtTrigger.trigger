trigger inwiB2C_ResilRequestEvtTrigger on inwiB2C_ResilRequestEvt__e (after insert) {
    system.debug('In trigger');
    String IP_ResilMassProcessing = 'inwib2c_InwiB2C_ResiliateBasedOnClientRequestVIP';
    for (inwiB2C_ResilRequestEvt__e event : Trigger.New) {
        
        if (event.inwiB2C_subsId__c != null && event.inwiB2C_Step__c !='SendSMS'){         
                 Map <String, Object> ipInput = new Map <String, Object> ();
                 Map <String, Object> ipOutput = new Map <String, Object> ();
                 Map <String, Object> ipOptions = new Map <String, Object> ();

                 ipInput.put('SubId', event.inwiB2C_subsId__c);
                 ipInput.put('requestId', event.inwiB2C_requestId__c);
                 
                 Map <String, Object> Params = new Map <String, Object> ();
                 Params.put('Name',IP_ResilMassProcessing);
                 Params.put('ipInput',ipInput);
                 Params.put('ipOptions',ipOptions);
                 //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
                 inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
            } 
        else if(event.inwiB2C_Step__c =='SendSMS')  {
              
                 String requestId = event.inwiB2C_requestId__c;
                 inwiB2C_SendSMS.SendSMS(requestId);
        }       
        }  
        
    }