trigger inwiB2C_IdentificationDigitalMyInwiTrigger  on inwiB2C_IdentificationDigitalMyInwi__e (after insert) {
        String IP_SynchroniseClient = 'Inwi_InwiB2C_ReCreateCustomerLegacy';
        
        String LinkingInput;
        String setInputLegacy;
        
         for (inwiB2C_IdentificationDigitalMyInwi__e event : Trigger.New) {
            //Pour identification MyInwi IP(Identification Digital WS07 cas Multiligne)

            if(event.inwiB2C_step__c.equals('IdentificationMyInwi')) {
                //CHB 23112023 Arret Synchronisation PS
               /* Map <String, Object> Params = new Map <String, Object> ();  
                Map <String, Object> ipInput = new Map <String, Object> ();
                System.debug('input inwiB2C_AccountId__c'+event.inwiB2C_AccountId__c);
                ipInput.put('AccountId', event.inwiB2C_AccountId__c);
                Params.put('Name',IP_SynchroniseClient );
                Params.put('ipInput',ipInput);
                Params.put('ipOptions',ipOptions);
                inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
                 */
                Map <String, Object> ipOptions = new Map <String, Object> (); 
                Map <String, Object> ipOutput = new Map <String, Object> (); 
                Map <String, Object> ipInputLinking = new Map <String, Object> ();
                ipInputLinking.put('icc',event.inwiB2C_icc__c);
                ipInputLinking.put('idContract',event.inwb2c_idContract__c);
                ipInputLinking.put('idSubscription',event.inwiB2C_idSubscription__c);
                ipInputLinking.put('mdn',event.inwiB2C_mdn__c);
                ipInputLinking.put('idAccount',event.inwiB2C_AccountId__c);
                Map <String, Object> ipInputMap = new Map <String, Object> ();
                ipInputMap.put('linkingInput',ipInputLinking);
                 
                 
                // ipInputLinking.put('linkingInput',event.inwiB2C_LinkingInput__c);
                System.debug('input LinkingInput'+ipInputMap);
                (new inwiB2C_CreateContractIdentification()).invokeMethod('changeAccountOfContract_OS',ipInputMap, ipOutput, ipOptions);
                System.debug('ipOptions'+ipOutput);
                String NewContractId =String.valueOf(ipOutput.get('ContractId'));
                Map <String, Object> ParamsIPUpdateContract = new Map <String, Object> ();
                Map <String, Object> ipInputIPUpdateContract = new Map <String, Object> ();
                ipInputIPUpdateContract.put('fieldstoupdate',event.inwiB2C_ContractToUpdate__c);
                ipInputIPUpdateContract.put('id',NewContractId);
                Map <String, Object> nodetosend = new Map <String, Object> ();
                nodetosend.put('input',ipInputIPUpdateContract);
                ParamsIPUpdateContract.put('Name','inwib2c_UpdateContractAfterCreate');
                ParamsIPUpdateContract.put('ipInput',nodetosend);
                ParamsIPUpdateContract.put('ipOptions',ipOptions);
                inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(ParamsIPUpdateContract));
                
                }
                //Pour Identification PDV AVEC CARTE SIM IP(Update_IdentificationPDV48h)
            else if(event.inwiB2C_step__c.equals('IdentificationAvecSIM')){

                Map <String, Object> Params = new Map <String, Object> ();
                Map <String, Object> ipOptions = new Map <String, Object> ();
                Map <String, Object> ipInput = new Map <String, Object> ();
                Map <String, Object> ipOutput = new Map <String, Object> ();
                Map <String, Object> ipInputLinking = new Map <String, Object> ();
                            
                ipInputLinking.put('icc',event.inwiB2C_icc__c);
                ipInputLinking.put('idContract',event.inwb2c_idContract__c);
                ipInputLinking.put('idSubscription',event.inwiB2C_idSubscription__c);
                ipInputLinking.put('mdn',event.inwiB2C_mdn__c);
                ipInputLinking.put('idAccount',event.inwiB2C_AccountId__c);
                Map <String, Object> ipInputMap = new Map <String, Object> ();
               
                ipInputMap.put('linkingInput',ipInputLinking);
                System.debug('input LinkingInput'+ipInputMap);
               
               
                (new inwiB2C_CreateContractIdentification()).invokeMethod('changeAccountOfContract_OS',ipInputMap, ipOutput, ipOptions);
                System.debug('ipOptions'+ipOutput);
               
               
                String NewContractId =String.valueOf(ipOutput.get('ContractId'));
                Map <String, Object> ParamsIPUpdateContract = new Map <String, Object> ();
                Map <String, Object> ipInputIPUpdateContract = new Map <String, Object> ();
                ipInputIPUpdateContract.put('fieldstoupdate',event.inwiB2C_ContractToUpdate__c);
                ipInputIPUpdateContract.put('id',NewContractId);
               
                Map <String, Object> nodetosend = new Map <String, Object> ();
                nodetosend.put('input',ipInputIPUpdateContract);
                ParamsIPUpdateContract.put('Name','inwib2c_UpdateContractAfterCreate');
                ParamsIPUpdateContract.put('ipInput',nodetosend);
                ParamsIPUpdateContract.put('ipOptions',ipOptions);
                inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(ParamsIPUpdateContract));
                  
              }
          }
}