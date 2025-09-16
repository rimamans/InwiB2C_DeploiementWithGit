public with sharing class InwiB2C_ChargementFileMassifBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Requête pour récupérer les enregistrements avec statut 'Ready'
        return Database.getQueryLocator([ 
            SELECT id,
                Inwib2c_Segment_Dealer_c__c, 
                ParentId__c,
                inwiB2C_Typehandler__c, 
                InwiB2C_Statut__c, 
                FirstName__c, 
                LastName__c, 
                InwiB2C_CIN__c, 
                InwiB2C_Type_CIN_c__c, 
                InwiB2C_Code_Dealer__c, 
                PartenaireNumContact1__c, 
                Partenaire_Num_Contact2__c,   
                inwib2c_AdresseMail__c, 
                InwiB2C_Region__c,  
                InwiB2C_Address__c, 
                InwiB2C_Quartier__c, 
                inwiB2C_Ville__c, 
                inwib2c_Geolocalisation_Longitude__c, 
                inwib2c_Geolocalisation_Latitude__c,
                InwiB2C_Vendeur__c, InwiB2C_Canal__c, InwiB2C_SousRegion__c, InwiB2C_Flag_Rural_Urbain__c
            FROM Chargement_de_fichierAM_en_masse__c 
            WHERE InwiB2C_Statut__c = 'Ready' 
            LIMIT 200
        ]);
    }
    
    public void execute(Database.BatchableContext BC, List<Chargement_de_fichierAM_en_masse__c> scope) {
        List<Chargement_de_fichierAM_en_masse__c> updatedRequests = new List<Chargement_de_fichierAM_en_masse__c>();
        List<InwiB2C_ChargementFileEvent__e> fileEvents = new List<InwiB2C_ChargementFileEvent__e>();

        for (Chargement_de_fichierAM_en_masse__c record : scope) {
            // Créer un événement de plateforme pour chaque enregistrement
            InwiB2C_ChargementFileEvent__e fileEvent = new InwiB2C_ChargementFileEvent__e();
            fileEvent.InwiB2C_Segment_Dealer__c = record.Inwib2c_Segment_Dealer_c__c;
            fileEvent.ParentId__c = record.ParentId__c;
            fileEvent.inwiB2C_Typehandler__c = record.inwiB2C_Typehandler__c;
            fileEvent.FirstName__c = record.FirstName__c;
            fileEvent.LastName__c = record.LastName__c;
            fileEvent.InwiB2C_CIN__c = record.InwiB2C_CIN__c;
            fileEvent.InwiB2C_Type_CIN_c__c = record.InwiB2C_Type_CIN_c__c;
            fileEvent.InwiB2C_Code_Dealer__c = record.InwiB2C_Code_Dealer__c;
            fileEvent.PartenaireNumContact1__c = record.PartenaireNumContact1__c;
            fileEvent.Partenaire_Num_Contact2__c = record.Partenaire_Num_Contact2__c;
            fileEvent.inwiB2c_AdresseMail__c = record.inwiB2c_AdresseMail__c;
            fileEvent.InwiB2C_Region__c = record.InwiB2C_Region__c;
            fileEvent.InwiB2C_Address__c = record.InwiB2C_Address__c;
            fileEvent.InwiB2C_Quartier__c = record.InwiB2C_Quartier__c;
            fileEvent.inwiB2C_Ville__c = record.inwiB2C_Ville__c;
            fileEvent.InwiB2C_Vendeur__c = record.InwiB2C_Vendeur__c;
            fileEvent.InwiB2C_Canal__c = record.InwiB2C_Canal__c;
            fileEvent.InwiB2C_SousRegion__c = record.InwiB2C_SousRegion__c;
            fileEvent.InwiB2C_Flag_Rural_Urbain__c = record.InwiB2C_Flag_Rural_Urbain__c;
            fileEvent.inwib2c_Geolocalisation_Longitude__c = record.inwib2c_Geolocalisation_Longitude__c;
            fileEvent.inwib2c_Geolocalisation_Latitude__c = record.inwib2c_Geolocalisation_Latitude__c;
            fileEvent.inwiB2C_idRecord__c=record.id;
            fileEvents.add(fileEvent);

            record.InwiB2C_Statut__c = 'Submitted'; // Mise à jour de l'état
            updatedRequests.add(record);
        }

        // Mise à jour des enregistrements
       if (!updatedRequests.isEmpty()) {
            try {
                update updatedRequests;
            } catch (DmlException e) {
                System.debug('Error updating records: ' + e.getMessage());
            }
        }

        // Publication des événements de plateforme
        if (!fileEvents.isEmpty()) {
            try {
                List<Database.SaveResult> publishResults = EventBus.publish(fileEvents);
                for (Database.SaveResult result : publishResults) {
                    if (!result.isSuccess()) {
                        System.debug('Failed to publish event: ' + result.getErrors());
                    }
                }
            } catch (Exception e) {
                System.debug('Error publishing events: ' + e.getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext BC) {
        // Aucune action supplémentaire après la fin du traitement.
    }
}