global with sharing class inwiB2C_CFDataController implements vlocity_cmt.VlocityOpenInterface {

    global Boolean InvokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        Boolean result = true;

        try {
            if (methodName == 'getDataByDocumentId') {
                output.put('List', getSubscriptionsByDocumentId(input));
            } else if (methodName == 'processSelectedRows') {
                output.put('List', processSelectedRows(input));
            }else if(methodName == 'checkProcessBatch'){
                output.put('result', checkProcessBatch(input));
            }
        } catch (Exception e) {
            System.debug('Exception in InvokeMethod: ' + e.getMessage());
            result = false;
        }

        return result;
    }
 

    private List<Map<String, Object>> getSubscriptionsByDocumentId(Map<String, Object> input) {
        Id documentId = (Id) input.get('documentId');  
        Integer TraitementSize = 200;
        List<Map<String, Object>> result = new List<Map<String, Object>>();
/*
        Map<String, Id> billingAccountToTreatmentIdMap = new Map<String, Id>();
        for (INWIB2C_TRAITEMENTMASSIF_FICHIER__c record : allRecords) {
            if (record.INWIB2C_Billing_Account__c != null) {
                billingAccountToTreatmentIdMap.put(record.INWIB2C_Billing_Account__c, record.Id);
            }
        }

        Set<String> billingAccountsSet = new Set<String>();
        for (INWIB2C_TRAITEMENTMASSIF_FICHIER__c record : allRecords) {
            if (record.INWIB2C_Billing_Account__c != null) {
                billingAccountsSet.add(record.INWIB2C_Billing_Account__c);
            }
        }

        List<String> billingAccounts = new List<String>(billingAccountsSet);
       

        for (Integer i = 0; i < billingAccounts.size(); i += TraitementSize) {
            List<String> currentBatch = new List<String>();

            for (Integer j = i; j < Math.min(i + TraitementSize, billingAccounts.size()); j++) {
                currentBatch.add(billingAccounts[j]);
            }

            List<vlocity_cmt__Subscription__c> subscriptions = [
                SELECT Id, 
                    vlocity_cmt__BillingAccountId__r.AccountNumber, 
                    Inwib2c_Num_ro_de_la_ligne__c, 
                    Inwib2c_Offre__c, 
                    inwiB2C_Statut__c, 
                    CreatedDate
                FROM vlocity_cmt__Subscription__c
                WHERE vlocity_cmt__BillingAccountId__r.AccountNumber IN :currentBatch
                AND inwiB2C_Statut__c NOT IN ('InwiB2C_Expired', 'InwiB2C_ResylCycleVie')
            ];
*/
            List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> traitementMassif = [SELECT id ,inwiB2C_Billing_Account__c, INWIB2C_DOCUMENT_ID__c, INWIB2C_MDN__c , INWIB2C_STATUT__c,
                INWIB2C_Origin__c, INWIB2C_ACTION__c, INWIB2C_Motif__c,INWIB2C_SUBSCRIPTION_ID__c,INWIB2C_SUBSCRIPTION_ID__r.InwiB2C_Date_d_activation__c, INWIB2C_SUBSCRIPTION_ID__r.inwiB2C_Statut__c,
                INWIB2C_SUBSCRIPTION_ID__r.Inwib2c_Offre__c
                FROM INWIB2C_TRAITEMENTMASSIF_FICHIER__c
                WHERE INWIB2C_DOCUMENT_ID__c = :documentId
                AND INWIB2C_STATUT__c='MDN no Selected'
            ];
            for (INWIB2C_TRAITEMENTMASSIF_FICHIER__c traitementMassifs : traitementMassif) {
                Map<String, Object> subscriptionMap = new Map<String, Object>();
                subscriptionMap.put('Id', traitementMassifs.Id);
                subscriptionMap.put('CompteFacturation', traitementMassifs.inwiB2C_Billing_Account__c);
                subscriptionMap.put('MDN', traitementMassifs.INWIB2C_MDN__c);
                subscriptionMap.put('Offre', traitementMassifs.INWIB2C_SUBSCRIPTION_ID__r.Inwib2c_Offre__c);
                subscriptionMap.put('Statut', traitementMassifs.INWIB2C_SUBSCRIPTION_ID__r.inwiB2C_Statut__c);
                subscriptionMap.put('DateCreation', traitementMassifs.INWIB2C_SUBSCRIPTION_ID__r.InwiB2C_Date_d_activation__c);
                subscriptionMap.put('IdTreatment',traitementMassifs.Id);
                result.add(subscriptionMap);
            }
        

        return result;
    }



    private Boolean processSelectedRows(Map<String, Object> input) {
        List<String> selectedRowIds = new List<String>();
        List<Object> rawSelectedRowIds = (List<Object>) input.get('selectedRowIds');
        Id contentDocumentId = (Id) input.get('contentDocumentId');
        
        List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> recordTraitementMassifUpdate = new List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c>();
        
        // Vérifiez que tous les IDs sont bien ajoutés
        for (Object id : rawSelectedRowIds) {
            String recordId = (String) id;
            INWIB2C_TRAITEMENTMASSIF_FICHIER__c recordTraitementMassif = new INWIB2C_TRAITEMENTMASSIF_FICHIER__c(
                Id = recordId,
                INWIB2C_STATUT__c = 'Selected'
            );
            recordTraitementMassifUpdate.add(recordTraitementMassif);
        }
        
        // Log de confirmation
        System.debug('Total d\'enregistrements à mettre à jour : ' + recordTraitementMassifUpdate.size());
        
        List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> recordListMassif = new List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c>();
        for (Integer i = 0; i < recordTraitementMassifUpdate.size(); i++) {
            recordListMassif.add(recordTraitementMassifUpdate[i]);
        
            // Mise à jour par lots de 200
            if (recordListMassif.size() == 200 || i == recordTraitementMassifUpdate.size() - 1) {
                try {
                    update recordListMassif;
                    System.debug('Mise à jour réussie pour le lot de 200 enregistrements.');
                } catch (DmlException e) {
                    System.debug('Erreur lors de la mise à jour des enregistrements : ' + e.getMessage());
                }
                recordListMassif.clear();
            }
        }
          //call event 
          List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> traitementMassif = [SELECT id ,inwiB2C_Billing_Account__c, INWIB2C_DOCUMENT_ID__c, INWIB2C_MDN__c , INWIB2C_STATUT__c,
                                                    INWIB2C_Origin__c, INWIB2C_ACTION__c, INWIB2C_Motif__c,INWIB2C_SUBSCRIPTION_ID__c
                                                    FROM INWIB2C_TRAITEMENTMASSIF_FICHIER__c
                                                    WHERE INWIB2C_DOCUMENT_ID__c = :contentDocumentId
                                                    AND INWIB2C_STATUT__c='Selected'
                                                    LIMIT 60];
        if (traitementMassif.size() > 0){
            List<String> listMDN =new List<String>();
            List<Map<String, String>> mdnMap = new List<Map<String, String>>();
            List<Object> Traitements = new List<Object>();
            for (INWIB2C_TRAITEMENTMASSIF_FICHIER__c traitementMassifList : traitementMassif) {
                Map<String,String> traitementMassMap = new Map<String,String>();
                traitementMassMap.put('mdn', traitementMassifList.INWIB2C_MDN__c);
                traitementMassMap.put('idTraitement',traitementMassifList.id);
                traitementMassMap.put('motif',traitementMassifList.INWIB2C_Motif__c);
                traitementMassMap.put('action',traitementMassifList.INWIB2C_ACTION__c);
                traitementMassMap.put('documentId',traitementMassifList.INWIB2C_DOCUMENT_ID__c);
                Traitements.add(traitementMassMap);
            }  
            inwiB2C_SMO_Massif__e apiEvent = new inwiB2C_SMO_Massif__e ();
            apiEvent.InwiB2C_DocumentId__c= contentDocumentId;
            apiEvent.InwiB2C_TraitementsList__c= JSON.serialize(Traitements);
            apiEvent.inwiB2C_typeChargement__c= 'ChCF';
            apiEvent.InwiB2C_STEP__c= 'Selected';
            EventBus.publish(apiEvent);
        }

        /*
        Id contentDocumentId = (Id) input.get('contentDocumentId');
        Integer TraitementSize = 200;
    
        List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> traitementRecords = [
            SELECT Id, INWIB2C_Billing_Account__c, INWIB2C_MDN__c, 
                   INWIB2C_STATUT__c, INWIB2C_SUBSCRIPTION_ID__c
            FROM INWIB2C_TRAITEMENTMASSIF_FICHIER__c
            WHERE INWIB2C_DOCUMENT_ID__c = :contentDocumentId
            ORDER BY CreatedDate DESC
        ];
    
        List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> toUpdate = new List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c>();
    
        for (INWIB2C_TRAITEMENTMASSIF_FICHIER__c record : traitementRecords) {
            record.INWIB2C_STATUT__c = selectedRowIds.contains(record.Id) ? 'Selected' : 'Canceled';
            toUpdate.add(record);
    
            if (toUpdate.size() == TraitementSize) {
                update toUpdate;
                toUpdate.clear();
            }
        }
    
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    
        List<Map<String, String>> traitementMaps = new List<Map<String, String>>();
        for (INWIB2C_TRAITEMENTMASSIF_FICHIER__c record : traitementRecords) {
            Map<String, String> traitementMap = new Map<String, String>();
            traitementMap.put('mdn', record.INWIB2C_MDN__c);
            traitementMap.put('idTraitement', record.Id);
            traitementMap.put('subscriptionId', record.INWIB2C_SUBSCRIPTION_ID__c);
            traitementMaps.add(traitementMap);
        }
        //CHB
        if (!traitementRecords.isEmpty()) {
            List<Map<String, String>> traitementsList = new List<Map<String, String>>();
            for (INWIB2C_TRAITEMENTMASSIF_FICHIER__c traitement : traitementRecords) {
                Map<String, String> traitementMassMap = new Map<String, String>();
                traitementMassMap.put('mdn', traitement.INWIB2C_MDN__c);
                traitementMassMap.put('idTraitement', traitement.Id);
                traitementMassMap.put('motif', traitement.INWIB2C_Motif__c);
                traitementMassMap.put('action', traitement.INWIB2C_ACTION__c);
                traitementMassMap.put('documentId', traitement.INWIB2C_DOCUMENT_ID__c);
                traitementMassMap.put('billingAccount', traitement.INWIB2C_Billing_Account__c);
                traitementsList.add(traitementMassMap);
            }
    
            inwiB2C_SMO_Massif__e apiEvent = new inwiB2C_SMO_Massif__e();
            apiEvent.InwiB2C_DocumentId__c = contentDocumentId;
            apiEvent.InwiB2C_TraitementsList__c = JSON.serialize(traitementsList);
            //apiEvent.inwiB2C_ChargementCF__c = true;
            EventBus.publish(apiEvent);
        }
    */
        return true;
    }
    private Boolean checkProcessBatch(Map<String, Object> input) {

        Id contentDocumentId = (Id)input.get('contentDocumentId');
        List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> traitementMassif = [SELECT id ,inwiB2C_Billing_Account__c, INWIB2C_DOCUMENT_ID__c, INWIB2C_MDN__c , INWIB2C_STATUT__c,
        INWIB2C_Origin__c, INWIB2C_ACTION__c, INWIB2C_Motif__c,INWIB2C_SUBSCRIPTION_ID__c
        FROM INWIB2C_TRAITEMENTMASSIF_FICHIER__c
        WHERE INWIB2C_DOCUMENT_ID__c = :contentDocumentId
        AND INWIB2C_STATUT__c='initialisé'
        LIMIT 1];
        if(traitementMassif.size() > 0){

                return false;
            }else{
                return true;
            }
        }
    
}