global with sharing class MDNFileHandler  implements vlocity_cmt.VlocityOpenInterface{
    String errorsValidation='';
    public Boolean InvokeMethod(String methodName,Map<String,Object> input,Map<String,Object> output, Map<String,Object> options) {   
        Boolean result = true;
        try
        {
            system.debug('HELLO');
            if(methodName == 'ReadMDNFile'){
                output.put('List', ReadMDNFile(input));
            }
            if(methodName == 'ReadFCTFile'){
                output.put('List', ReadFCTFile(input));
            }
            if(methodName=='insertData'){
                output.put('List',insertData(input));
            }
            if(methodName=='getListByDocumentId'){
                output.put('List',getListByDocumentId(input));
            }
            if(methodName=='getListByDocumentIdCF'){
                output.put('List',getListByDocumentIdCF(input));
            }
            if(methodName=='processSelectedRows'){
                output.put('List',processSelectedRows(input));
            }
         }
        catch(Exception e)
       	{
           System.debug('MDNFileHandler:invokeMethod -> exception: '+e);
           result = false;
       	}
       
       return result;
    }

    private map<string,string> ReadMDNFile(Map<String, Object> input){
        Id contentDocumentId = (Id)input.get('contentDocumentId');
        String fileName =(String)input.get('fileName');
        String TypeChargement=(String)input.get('TypeChargement')=='CHMDN'?'inwiB2C_CHMDN':'inwiB2C_CHCF';
        Map<String, string> listPorta = new Map<String, string>();
         system.debug('contentDocumentId: '+contentDocumentId);
        if(contentDocumentId != null) {
             //insert file
             inwiB2C_Progress_TraitementMassifFichier__c file =new inwiB2C_Progress_TraitementMassifFichier__c(inwiB2C_Statut__c='inwiB2C_In_Progress',Nom_du_fichier__c=fileName, inwiB2C_DOCUMENT_ID__c=contentDocumentId,InwiB2C_Type_de_chargement__c=TypeChargement);
             insert file;
             
            ContentVersion contentVersionObj = [SELECT Id, Title, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            system.debug('contentVersionObj: '+contentVersionObj.Id);
            String data = Blob.valueOf(contentVersionObj.VersionData.toString()).toString();
            system.debug('DATA: '+data);
            list<String> recordsList = data.split('\n');
            Boolean hasError = false;
          
                  
            for(string mdn: recordsList){
                system.debug('Record: '+mdn);
                listPorta.put(mdn,mdn);
            }
          
        }   
       
         for(String key : listPorta.keySet()){
        System.debug('### lines.get(key) : ' + listPorta.get(key));
        System.debug('### >>> ' + listPorta.get(key));
    }
        return listPorta;
        
        
    }


    private map<string,string> ReadFCTFile(Map<String, Object> input){
        Id contentDocumentId = (Id)input.get('contentDocumentId');
        String fileName =(String)input.get('fileName');
        String TypeChargement=(String)input.get('TypeChargement')=='CHMDN'?'inwiB2C_CHMDN':'inwiB2C_CHCF';
        Map<String, string> listPorta = new Map<String, string>();
         system.debug('contentDocumentId: '+contentDocumentId);
        if(contentDocumentId != null) {
            inwiB2C_Progress_TraitementMassifFichier__c file =new inwiB2C_Progress_TraitementMassifFichier__c(inwiB2C_Statut__c='inwiB2C_In_Progress',Nom_du_fichier__c=fileName, inwiB2C_DOCUMENT_ID__c=contentDocumentId,InwiB2C_Type_de_chargement__c=TypeChargement);
            insert file;
            ContentVersion contentVersionObj = [SELECT Id, Title, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            system.debug('contentVersionObj: '+contentVersionObj.Id);
            String data = Blob.valueOf(contentVersionObj.VersionData.toString()).toString();
            system.debug('DATA: '+data);
            list<String> recordsList = data.split('\n');
            Boolean hasError = false;
          
            for(string fct: recordsList){
                system.debug('Record: '+fct);
                
                listPorta.put(fct,fct);
            }
        }   
       
         for(String key : listPorta.keySet()){
        System.debug('### lines.get(key) : ' + listPorta.get(key));
        System.debug('### >>> ' + listPorta.get(key));
    }
        return listPorta;
        
        
    }
    private Boolean insertData(Map<String, Object> input) { 
        Id contentDocumentId = (Id)input.get('contentDocumentId');
        String action = (String)input.get('action');
        String origine = (String)input.get('origine');
        String motif = (String)input.get('motif');
        String typechargement = (String)input.get('typechargement');
        Object dataObject = input.get('data');
        if(typechargement=='CHMDN'){
            List<Object> mdnListGeneric = (List<Object>) dataObject; 
            List<String> mdnValues = new List<String>();
            for (Object obj : mdnListGeneric) {
                Map<String, Object> mdnMap = (Map<String, Object>) obj;
                if (mdnMap.containsKey('value')){                
                    String mdnValue = (String) mdnMap.get('value');
                    mdnValue = mdnValue.replace('\\r', ''); 
                    System.debug('Nettoyage MDN: ' + mdnValue);
                    mdnValues.add(mdnValue);
                }
            }
            System.debug('mdnValues: ' + mdnValues);
            Integer TraitementSize = 200;
            List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c > traitementmassifInsert = new List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c >();
            for (Integer i = 0; i < mdnValues.size(); i += TraitementSize) {     
                for (Integer j = i; j < Math.min(i + TraitementSize, mdnValues.size()); j++) {
                    INWIB2C_TRAITEMENTMASSIF_FICHIER__c  traitementMassifRecord= new INWIB2C_TRAITEMENTMASSIF_FICHIER__c (
                        INWIB2C_ACTION__c=action,
                        INWIB2C_DOCUMENT_ID__c=contentDocumentId,
                        INWIB2C_MDN__c=mdnValues[j],
                        INWIB2C_Origin__c=origine,
                        INWIB2C_STATUT__c='Upload',
                        INWIB2C_Motif__c=motif
                    );
                    traitementmassifInsert.add(traitementMassifRecord);
                    if (traitementmassifInsert.size() == TraitementSize) {
                        insert traitementmassifInsert;
                        traitementmassifInsert.clear(); 
                    }
                        
                }
            }
            if(!traitementmassifInsert.isEmpty() ){
                insert traitementmassifInsert;
            }
           
        }

        if (typechargement == 'CHCF') {
            List<Object> cfListGeneric = (List<Object>) dataObject;
            List<String> cfValues = new List<String>();
            List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c > traitementmassifInsert = new List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c >();
            for (Object obj : cfListGeneric) {
                Map<String, Object> cfMap = (Map<String, Object>) obj;
                if (cfMap.containsKey('value')) {
                    String cfValue = ((String) cfMap.get('value')).trim().replace('\\r', '');
                    System.debug('Nettoyage CF: ' + cfValue);
                    cfValues.add(cfValue);
                }
            }
           

            Integer TraitementSize = 150;
            for (Integer i = 0; i < cfValues.size(); i += TraitementSize) {     
                for (Integer j = i; j < Math.min(i + TraitementSize, cfValues.size()); j++) {
 
                    INWIB2C_TRAITEMENTMASSIF_FICHIER__c traitementMassifRecord = 
                        new INWIB2C_TRAITEMENTMASSIF_FICHIER__c(
                            INWIB2C_ACTION__c = action,
                            INWIB2C_DOCUMENT_ID__c = contentDocumentId,
                            INWIB2C_Origin__c = origine,
                            INWIB2C_STATUT__c = 'Upload',
                            inwiB2C_Billing_Account__c = cfValues[j],
                            INWIB2C_Motif__c=motif                           
                        );

                
                    traitementmassifInsert.add(traitementMassifRecord);
                    if (traitementmassifInsert.size() == TraitementSize) {
                        insert traitementmassifInsert;
                        traitementmassifInsert.clear();
                    }
                }
            } 
            if (!traitementmassifInsert.isEmpty()) {
                insert traitementmassifInsert;
            }
        }
         //call event 
        List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> traitementMassif = [SELECT id ,inwiB2C_Billing_Account__c, INWIB2C_DOCUMENT_ID__c, INWIB2C_MDN__c , INWIB2C_STATUT__c,
                                                                    INWIB2C_Origin__c, INWIB2C_ACTION__c, INWIB2C_Motif__c,INWIB2C_SUBSCRIPTION_ID__c
                                                                    FROM INWIB2C_TRAITEMENTMASSIF_FICHIER__c
                                                                    WHERE INWIB2C_DOCUMENT_ID__c = :contentDocumentId
                                                                    AND INWIB2C_STATUT__c='Upload'
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
                traitementMassMap.put('billingAccount',traitementMassifList.inwiB2C_Billing_Account__c);
                traitementMassMap.put('origine',traitementMassifList.INWIB2C_Origin__c);
                traitementMassMap.put('typeChargement',typechargement);
                Traitements.add(traitementMassMap);
            }  
            inwiB2C_SMO_Massif__e apiEvent = new inwiB2C_SMO_Massif__e ();
            apiEvent.InwiB2C_DocumentId__c= contentDocumentId;
            apiEvent.InwiB2C_TraitementsList__c= JSON.serialize(Traitements);
            apiEvent.inwiB2C_typeChargement__c= typechargement;
            apiEvent.InwiB2C_STEP__c= typechargement=='CHMDN'?'SearchMDN_CHMDN':'SearchMDN_CHCF';
            EventBus.publish(apiEvent);
        }

        return true;
    }
    private List<Map<String, Object>> getListByDocumentId(Map<String, Object> input) {
        Id documentId = (Id) input.get('selectedFile');  
        String typechargement = (String)input.get('typechargement');
        Integer TraitementSize = 200;
        List<Map<String, Object>> result = new List<Map<String, Object>>();

            List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> traitementMassif = [SELECT id ,inwiB2C_Billing_Account__c, INWIB2C_DOCUMENT_ID__c, InwiB2C_Erreur__c,INWIB2C_MDN__c , INWIB2C_STATUT__c,
                INWIB2C_Origin__c, INWIB2C_ACTION__c, INWIB2C_Motif__c,INWIB2C_SUBSCRIPTION_ID__c,INWIB2C_SUBSCRIPTION_ID__r.InwiB2C_Date_d_activation__c, INWIB2C_SUBSCRIPTION_ID__r.inwiB2C_Statut__c,
                INWIB2C_SUBSCRIPTION_ID__r.Inwib2c_Offre__c
                FROM INWIB2C_TRAITEMENTMASSIF_FICHIER__c 
                WHERE INWIB2C_DOCUMENT_ID__c = :documentId
            ];
            String typechargementST=typechargement=='inwiB2C_CHCF' || typechargement=='Chargement par Compte de facturation'?'Chargement par Compte de facturation':'Chargement par MDN';
            for (INWIB2C_TRAITEMENTMASSIF_FICHIER__c traitementMassifs : traitementMassif) {
                Map<String, Object> subscriptionMap = new Map<String, Object>();
                subscriptionMap.put('Erreur', traitementMassifs.InwiB2C_Erreur__c);
                subscriptionMap.put('Statut', traitementMassifs.INWIB2C_STATUT__c=='Progress'?'MDN a selectionnée':traitementMassifs.INWIB2C_STATUT__c);
                subscriptionMap.put('Action', traitementMassifs.INWIB2C_ACTION__c);
                subscriptionMap.put('Origin', traitementMassifs.INWIB2C_Origin__c=='IMX'?'Recouvrement':traitementMassifs.INWIB2C_Origin__c);
                subscriptionMap.put('Motif', traitementMassifs.INWIB2C_Motif__c);
                subscriptionMap.put('MDN', traitementMassifs.INWIB2C_MDN__c);
                subscriptionMap.put('Type de chargement', typechargementST);
                subscriptionMap.put('UUID',documentId);
                if(typechargement=='Chargement par Compte de facturation'|| typechargement=='inwiB2C_CHCF'){
                    subscriptionMap.put('CompteFacturation', traitementMassifs.inwiB2C_Billing_Account__c);
                }
                result.add(subscriptionMap);
            }
        

        return result;
    }
    private List<Map<String, Object>> getListByDocumentIdCF(Map<String, Object> input) {
        Id documentId = (Id) input.get('selectedFile');  
        String typechargement = (String)input.get('typechargement');
        String action=(String)input.get('action');
        Integer TraitementSize = 200;
        List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> traitementMassif =new List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c>();
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        if(action=='edit'){
            traitementMassif = [SELECT id ,inwiB2C_Billing_Account__c, INWIB2C_DOCUMENT_ID__c, InwiB2C_Erreur__c,INWIB2C_MDN__c , INWIB2C_STATUT__c,
            INWIB2C_Origin__c, INWIB2C_ACTION__c, INWIB2C_Motif__c,INWIB2C_SUBSCRIPTION_ID__c,INWIB2C_SUBSCRIPTION_ID__r.InwiB2C_Date_d_activation__c, INWIB2C_SUBSCRIPTION_ID__r.inwiB2C_Statut__c,
            INWIB2C_SUBSCRIPTION_ID__r.Inwib2c_Offre__c
            FROM INWIB2C_TRAITEMENTMASSIF_FICHIER__c
            WHERE INWIB2C_DOCUMENT_ID__c =: documentId
            AND INWIB2C_STATUT__c=:'Progress'
        ];
        }else{
            traitementMassif = [SELECT id ,inwiB2C_Billing_Account__c, INWIB2C_DOCUMENT_ID__c, InwiB2C_Erreur__c,INWIB2C_MDN__c , INWIB2C_STATUT__c,
            INWIB2C_Origin__c, INWIB2C_ACTION__c, INWIB2C_Motif__c,INWIB2C_SUBSCRIPTION_ID__c,INWIB2C_SUBSCRIPTION_ID__r.InwiB2C_Date_d_activation__c, INWIB2C_SUBSCRIPTION_ID__r.inwiB2C_Statut__c,
            INWIB2C_SUBSCRIPTION_ID__r.Inwib2c_Offre__c
            FROM INWIB2C_TRAITEMENTMASSIF_FICHIER__c
            WHERE INWIB2C_DOCUMENT_ID__c = :documentId
            ];
        }
          
            String typechargementST=typechargement=='inwiB2C_CHCF' || typechargement=='Chargement par Compte de facturation'?'Chargement par Compte de facturation':'Chargement par MDN';
            for (INWIB2C_TRAITEMENTMASSIF_FICHIER__c traitementMassifs : traitementMassif) {
                Map<String, Object> subscriptionMap = new Map<String, Object>();
                subscriptionMap.put('IdTreatment',traitementMassifs.Id);
                subscriptionMap.put('UUID',documentId);
                subscriptionMap.put('Type de chargement', typechargementST);
                subscriptionMap.put('MDN', traitementMassifs.INWIB2C_MDN__c);
                subscriptionMap.put('Action', traitementMassifs.INWIB2C_ACTION__c);
                subscriptionMap.put('Origin', traitementMassifs.INWIB2C_Origin__c=='IMX'?'Recouvrement':traitementMassifs.INWIB2C_Origin__c);
                subscriptionMap.put('Motif', traitementMassifs.INWIB2C_Motif__c);
                subscriptionMap.put('Statut', traitementMassifs.INWIB2C_STATUT__c=='Progress'?'Souscription à sélectionner':traitementMassifs.INWIB2C_STATUT__c);
                subscriptionMap.put('CompteFacturation', traitementMassifs.inwiB2C_Billing_Account__c);
                subscriptionMap.put('Subscription', traitementMassifs.INWIB2C_SUBSCRIPTION_ID__c);
                subscriptionMap.put('StatutSub', traitementMassifs.INWIB2C_SUBSCRIPTION_ID__r.inwiB2C_Statut__c);
                subscriptionMap.put('DateActivationSub', traitementMassifs.INWIB2C_SUBSCRIPTION_ID__r.InwiB2C_Date_d_activation__c);
                subscriptionMap.put('Offre', traitementMassifs.INWIB2C_SUBSCRIPTION_ID__r.Inwib2c_Offre__c);
                subscriptionMap.put('Erreur', traitementMassifs.InwiB2C_Erreur__c);
                subscriptionMap.put('isDisabled', traitementMassifs.INWIB2C_STATUT__c=='Progress'?false:true);
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
                                                    AND INWIB2C_STATUT__c=:'Selected'
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
                traitementMassMap.put('idSouscription',traitementMassifList.INWIB2C_SUBSCRIPTION_ID__c);
                traitementMassMap.put('documentId',traitementMassifList.INWIB2C_DOCUMENT_ID__c);
                Traitements.add(traitementMassMap);
            }  
            inwiB2C_SMO_Massif__e apiEvent = new inwiB2C_SMO_Massif__e ();
            apiEvent.InwiB2C_DocumentId__c= contentDocumentId;
            apiEvent.InwiB2C_TraitementsList__c= JSON.serialize(Traitements);
            apiEvent.inwiB2C_typeChargement__c= 'CHCF';
            apiEvent.InwiB2C_STEP__c= 'TraitementMDN_CHCF';
            EventBus.publish(apiEvent);
        }

        return true;
    }
}