/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-09-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class InwB2C_SDPRequestBatchJob implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    private List<InwiB2C_Demande_de_migration__c> scope;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, InwiB2C_Statut__c FROM InwiB2C_Demande_de_migration__c WHERE (InwiB2C_Statut__c = \'InwiB2C_ErreurNotificationSDP\' OR InwiB2C_Statut__c = \'InwiB2C_EnAttentEnvoiSDP\')';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<InwiB2C_Demande_de_migration__c> scope) {
        this.scope = scope;
        processSDPRequests();
    }
    
    private void processSDPRequests() {
        String procedureName = 'INWIB2C_handleSDPSubscriptionMigrationCam';

        
        List<InwiB2C_SDPEventRequest__e> eventList = new List<InwiB2C_SDPEventRequest__e>();


        for (InwiB2C_Demande_de_migration__c migration : scope) {
            // Changer le statut de la demande en "InwiB2C_EnAttenteRetourSDP"
            migration.InwiB2C_Statut__c = 'InwiB2C_EnAttenteRetourSDP';
        }

        if (!scope.isEmpty()) {
            update scope;
        }
        
        for (InwiB2C_Demande_de_migration__c migration : scope) {
            // Changer le statut de la demande en "InwiB2C_EnAttenteRetourSDP"
            /*migration.InwiB2C_Statut__c = 'InwiB2C_EnAttenteRetourSDP';
            
            // Appeler la VIP pour la demande actuelle
            List<String> demandeIds = new List<String>();
            demandeIds.add(migration.Id);
            Map<String, Object> ipInput = new Map<String, Object>();
            Map<String, Object> optionsMap = new Map<String, Object>();
            System.debug('Processing demandeId: ' + migration.Id);
            ipInput.put('demandeId', migration.Id);

            Map <String, Object> Params = new Map <String, Object> ();
            Params.put('Name',procedureName);
            Params.put('ipInput',ipInput);
            Params.put('ipOptions',optionsMap);
            
             
            //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
            //inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));

             Map<String, Object> ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, optionsMap);
            System.debug('VIP Response: ' + JSON.serialize(ipOutput));
            System.debug('VIPP Response: ' + String.valueOf(ipOutput.get('OKSdp')));
            System.debug('ipResponse: ' + String.valueOf(ipOutput.get('ipResponse')));
            
            if (ipOutput.get('OKSdp') != null) {
                Integer oksdp = Integer.valueOf(ipOutput.get('OKSdp'));
                System.debug('okssdp: ' + oksdp);
                
                if (oksdp == 1) {
                    System.debug('VIP request sent successfully for demandeId: ' + migration.Id);
                } else {
                    System.debug('Failed to send VIP request for demandeId: ' + migration.Id);
                }
            }*/


            InwiB2C_SDPEventRequest__e sdpEvent = new InwiB2C_SDPEventRequest__e();
            sdpEvent.DemandeId__c = migration.Id;
            eventList.add(sdpEvent);
        }

        if (!eventList.isEmpty()) {
            EventBus.publish(eventList);
        }

        
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch processing completed successfully.');
    }
}