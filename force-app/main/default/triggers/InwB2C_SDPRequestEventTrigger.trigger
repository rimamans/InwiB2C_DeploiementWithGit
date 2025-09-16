/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-10-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/


trigger InwB2C_SDPRequestEventTrigger on InwiB2C_SDPEventRequest__e (after insert) {

    String procedureName = 'INWIB2C_handleSDPSubscriptionMigrationCam';

    for (InwiB2C_SDPEventRequest__e  event : Trigger.new) {

        if (event.DemandeId__c != null ) {
            Map<String, Object> ipInput = new Map<String, Object>();
            Map<String, Object> optionsMap = new Map<String, Object>();

            ipInput.put('demandeId', event.DemandeId__c);

            Map <String, Object> Params = new Map <String, Object> ();
            Params.put('Name',procedureName);
            Params.put('ipInput',ipInput);
            Params.put('ipOptions',optionsMap);
            

            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
            

           // Map<String, Object> ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, null);
            /*System.debug('VIP Response: ' + ipOutput);
            System.debug('VIPP Response: ' + String.valueOf(ipOutput.get('OKSdp')));
            System.debug('ipResponse: ' + String.valueOf(ipOutput.get('ipResponse')));*/
        }
    }

}