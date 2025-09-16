global class inwiB2C_RecyclageDemandePartage implements vlocity_cmt.VlocityOpenInterface {
    
    
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        Boolean result = true;
        
        
        try{
            if (methodName.equals('RecycleDemandePartage')){
               RecycleDemandePartage(inputMap, outMap, options);
            }
             if (methodName.equals('continueAfterAPICall')){
               continueAfterAPICall(inputMap, outMap, options);
            }

        } catch (Exception e){
            result = false;
        }

        return result;
    }
    
    public static void RecycleDemandePartage(Map<String, Object> inputParams, Map<String, Object> outMap, Map<String, Object> options){
        Map<String, Object> lwcData = (Map<String, Object>) inputParams.get('lwcDemande');
        System.debug('Received lwcData: ' + JSON.serializePretty(lwcData));
        String statut = (String) lwcData.get('InwiB2C_Statut_demande__c')?? '';
        //String statut = 'REJ';
        
        Map<String, Object> results = new Map<String, Object>();
        
        InwiB2C_WorkDaysCounter workDaysCounter = new InwiB2C_WorkDaysCounter();
        InwiB2C_SharingRequestManagementVI sharingRequestManager = new InwiB2C_SharingRequestManagementVI();
        Integer delaiRecyclageJour = Integer.valueOf([SELECT inwiB2C_value__c, Label FROM inwiB2C_Parametre_Demande_Partage__mdt where Label = 'delaiRecyclageJour' limit 1].inwiB2C_value__c ) * 24 ;
        Integer delaiRecyclageHeure = Integer.valueOf([SELECT inwiB2C_value__c, Label FROM inwiB2C_Parametre_Demande_Partage__mdt where Label = 'delaiRecyclageHeure' limit 1].inwiB2C_value__c ) ;
        Integer nombreMaxRecyclage = Integer.valueOf([SELECT inwiB2C_value__c, Label FROM inwiB2C_Parametre_Demande_Partage__mdt where Label = 'NbrMaxRecyclage' limit 1].inwiB2C_value__c ) ;

        String codeMotif = (String) lwcData.get('InwiB2C_Code_Motif__c') ?? '';
        //String codeMotif = '24';
            
		System.debug('delaiRecyclageJour'+ delaiRecyclageJour);
        System.debug('delaiRecyclageHeure'+ delaiRecyclageHeure);
        System.debug('nombreMaxRecyclage'+ nombreMaxRecyclage);
        
         Integer compteurRecyclage;
        try {
            //String compteurValue = (String) lwcData.get('InwiB2C_Compteur_recyclage__c');
            compteurRecyclage = Integer.valueOf(lwcData.get('InwiB2C_Compteur_recyclage__c'));
        } catch (Exception e) {
            compteurRecyclage = 0; // Default value in case of an error
        }
        
        if (statut == 'Annulee_Delai_Reg' || statut == 'Annulee_3_Susp' || (statut == 'DEF' && (codeMotif == '21' || codeMotif == '22' || codeMotif == '23') )) {
           results = createNewSharingNumberAndCallAPINewOrder(lwcData);
        }
        if (statut == 'REJ') {
           results = createNewSharingNumber(lwcData);
        }
        else if (statut == 'SUS') {
            
            String createdDateString = (String) lwcData.get('CreatedDate');
            createdDateString = createdDateString.replace('Z', '').replace('T', ' ').substring(0, 19);
			DateTime suspensionDate = DateTime.valueOfGMT(createdDateString);
           
            if(nombreMaxRecyclage <= compteurRecyclage){
       
                results = createNewSharingNumber(lwcData);
            }

            else if (codeMotif == '24' || codeMotif == '25') {
                results = keepSameSharingNumber(lwcData);
            } else {
                Integer hoursSinceSuspension = InwiB2C_WorkDaysCounter.countTotalDaysForWorkingDays(suspensionDate);
                //Integer workDaysSinceSuspension = hoursSinceSuspension / 24; 

                if (hoursSinceSuspension > (delaiRecyclageJour + delaiRecyclageHeure)) {
                    results = createNewSharingNumberAndCallAPINewOrder(lwcData);
                } else {
                    results = keepSameSharingNumber(lwcData);
                }
            }
        } 
        else if (statut == 'InwiB2C_EnErreur') {
            
            String ndAttributDemande = (String)lwcData.get('InwiB2C_nd_Attribut__c') ?? '';
            String numeroDesignationDemande = (String)lwcData.get('InwiB2C_NumeroDesignation__c') ?? '';
            inwiB2C_demande_partage__c lastSuspendedDemande = [
                select id , CreatedDate 
                from inwiB2C_demande_partage__c  
                where InwiB2C_Statut_demande__c ='SUS'  and ( InwiB2C_nd_Attribut__c =: ndAttributDemande ) //B-29237
                 // or InwiB2C_NumeroDesignation__c =: numeroDesignationDemande )
                Order by InwiB2C_Numero_Partage__c desc,InwiB2C_Sequence__c desc 
                limit 1
                                                              ];
            DateTime lastSuspensionDate = (DateTime) lastSuspendedDemande.CreatedDate;
            Integer hoursSinceLastSuspension = InwiB2C_WorkDaysCounter.countTotalDaysForWorkingDays(lastSuspensionDate);
            //Integer workDaysSinceLastSuspension = hoursSinceLastSuspension / 24;

            if(nombreMaxRecyclage <= compteurRecyclage){
                results = createNewSharingNumber(lwcData);
            }
            else if (hoursSinceLastSuspension > (delaiRecyclageJour + delaiRecyclageHeure)) {
                results = createNewSharingNumber(lwcData);
            } else {
                results = keepSameSharingNumber(lwcData);
            }
        }
        
        outMap.put('result',results);
        
    }
 

   private static Map<String, Object> createNewSharingNumber(Map<String, Object> lwcData) {
       
        Integer compteurRecyclage;
         try {
            compteurRecyclage = Integer.valueOf(lwcData.get('InwiB2C_Compteur_recyclage__c'));
        } catch (Exception e) {
            compteurRecyclage = 0; 
        }
       
       //Create new Demande Recyl with old sharing number
       InwiB2C_SharingRequestManagement.cloneSharingRequest(
            new Map<String, Object>{
                'InwiB2C_Statut_demande__c' => 'InwiB2C_Recyclee',
                'newCommande' => false,
                'InwiB2C_Commande_de_partage__c' => lwcData.get('InwiB2C_Commande_de_partage__c'),
                'InwiB2C_Compteur_recyclage__c' => compteurRecyclage + 1
            }
        );
       //Create new Demande with new sharing Number
       Map<String, Object> inputMapCloneDemande = new Map<String, Object>{
           'InwiB2C_Statut_demande__c' => 'NOU',
           'newCommande' => true

       };
           
        inputMapCloneDemande = getFieldsFromInput(inputMapCloneDemande , lwcData , InwiB2C_demande_partage__c.SObjectType);
       //////////////////Reset Counter//////////////////////////////////////
       inputMapCloneDemande.put('InwiB2C_Compteur_recyclage__c',0);
       //////////////////Reset Counter//////////////////////////////////////
       System.debug('inputMapCloneDemande ' +JSON.serializePretty(inputMapCloneDemande));

        Id IdNewDemande = InwiB2C_SharingRequestManagement.cloneSharingRequest(inputMapCloneDemande);
       // Call Api
       
       inwiB2C_demande_partage__c newDemandePartage = [select id ,InwiB2C_Commande_de_partage__c,InwiB2C_Numero_Partage__c, CreatedDate 
                                                       from inwiB2C_demande_partage__c   
                                                       where Id =: IdNewDemande 
                                                       limit 1];
       
       Map <String, Object> apiIpInput = callRecycleAPI(lwcData , newDemandePartage);
       System.debug('apiIpInput'+ apiIpInput);
       return new Map<String, Object>{
            'newCommandePartage' => newDemandePartage.InwiB2C_Commande_de_partage__c,
             'apiIpInput' => apiIpInput,
             'methodeName' => 'createNewSharingNumber',
             'procedureName' => 'inwib2c_RecycleSharingRequestVULA'
        };
       /*
       String apiStatus = (String)apiResult.get('statut');
       String statusNewDemande = apiStatus == 'OK' ? 'SOU' : 'InwiB2C_EnErreur';
       String apiErrorMessage = (String)apiResult.get('reasonMessage');
       
       // Create new Demande based on Api return
        Map<String, Object> inputMapApiDemande = new Map<String, Object>{
            'InwiB2C_Statut_demande__c' => statusNewDemande,
                'newCommande' => false,
                'InwiB2C_Commande_de_partage__c' => newDemandePartage.InwiB2C_Commande_de_partage__c,
                'InwiB2C_lineId__c'=> apiResult.get('InwiB2C_lineId__c') ?? '',
                'InwiB2C_Motif__c'=> apiErrorMessage
       };
           If (apiStatus == 'OK'){
               inputMapApiDemande.put('InwiB2C_Compteur_recyclage__c',Integer.valueOf(lwcData.get('InwiB2C_Compteur_recyclage__c') ?? 0 )  + 1);
           }
        inputMapApiDemande = getFieldsFromInput(inputMapApiDemande , lwcData , InwiB2C_demande_partage__c.SObjectType);
        Id IdDemandeRecAPI = InwiB2C_SharingRequestManagement.cloneSharingRequest(inputMapApiDemande);
     
       return new Map<String, Object>{
            'statutRecyclage' => apiStatus,
            'ErreurRecyclage' => apiErrorMessage,
            'IdDemandeRec' => IdDemandeRecAPI
        };*/
    }
   private static Map<String, Object> createNewSharingNumberAndCallAPINewOrder(Map<String, Object> lwcData) {
       
        Integer compteurRecyclage;
         try {
            compteurRecyclage = Integer.valueOf(lwcData.get('InwiB2C_Compteur_recyclage__c'));
        } catch (Exception e) {
            compteurRecyclage = 0; 
        }
       
       //Create new Demande Recyl with old sharing number
       InwiB2C_SharingRequestManagement.cloneSharingRequest(
            new Map<String, Object>{
                'InwiB2C_Statut_demande__c' => 'InwiB2C_Recyclee',
                'newCommande' => false,
                'InwiB2C_Commande_de_partage__c' => lwcData.get('InwiB2C_Commande_de_partage__c'),
                'InwiB2C_Compteur_recyclage__c' => compteurRecyclage + 1
            }
        );
       //Create new Demande with new sharing Number
       Map<String, Object> inputMapCloneDemande = new Map<String, Object>{
           'InwiB2C_Statut_demande__c' => 'NOU',
           'newCommande' => true

       };
           
        inputMapCloneDemande = getFieldsFromInput(inputMapCloneDemande , lwcData , InwiB2C_demande_partage__c.SObjectType);
       //////////////////Reset Counter//////////////////////////////////////
       inputMapCloneDemande.put('InwiB2C_Compteur_recyclage__c',0);
       //////////////////Reset Counter//////////////////////////////////////
       System.debug('inputMapCloneDemande ' +JSON.serializePretty(inputMapCloneDemande));

        Id IdNewDemande = InwiB2C_SharingRequestManagement.cloneSharingRequest(inputMapCloneDemande);
       // Call Api
       
       inwiB2C_demande_partage__c newDemandePartage = [select id ,InwiB2C_Commande_de_partage__c,InwiB2C_Numero_Partage__c, CreatedDate 
                                                       from inwiB2C_demande_partage__c   
                                                       where Id =: IdNewDemande 
                                                       limit 1];
       
       Map <String, Object> apiIpInput = callNewOrderAPI(lwcData , newDemandePartage);
       System.debug('apiIpInput'+ apiIpInput);
       return new Map<String, Object>{
            'newCommandePartage' => newDemandePartage.InwiB2C_Commande_de_partage__c,
             'apiIpInput' => apiIpInput,
             'methodeName' => 'createNewSharingNumberAndCallAPINewOrder',
             'procedureName' => 'inwib2c_RequestSharingVULARecyclage'
        };
    }
    
   private static Map<String, Object> keepSameSharingNumber(Map<String, Object> lwcData) {
       
       
       //Create new Demande Recyl with old sharing number
       //
       
       Map<String, Object> inputMapCloneDemande = new Map<String, Object>{
           'InwiB2C_Statut_demande__c' => 'InwiB2C_Recyclee_IN',
           'newCommande' => false
               
       };
        inputMapCloneDemande = getFieldsFromInput(inputMapCloneDemande , lwcData , InwiB2C_demande_partage__c.SObjectType);
        System.debug('inputMapCloneDemande ' + JSON.serializePretty(inputMapCloneDemande));
        Id IdNewDemande = InwiB2C_SharingRequestManagement.cloneSharingRequest(inputMapCloneDemande);
       
       // Call Api
       inwiB2C_demande_partage__c newDemandePartage = [select id ,InwiB2C_Commande_de_partage__c,InwiB2C_Numero_Partage__c, CreatedDate 
                                                       from inwiB2C_demande_partage__c   
                                                       where Id =: IdNewDemande 
                                                       limit 1];
       Map <String, Object> apiIpInput = callRecycleAPI(lwcData , newDemandePartage);
       System.debug('apiIpInput'+ apiIpInput);
       
       
       return new Map<String, Object>{
            'newCommandePartage' => newDemandePartage.InwiB2C_Commande_de_partage__c,
             'apiIpInput' => apiIpInput,
             'methodeName' => 'keepSameSharingNumber',
             'procedureName' => 'inwib2c_RecycleSharingRequestVULA'
        };
      /* String apiStatus = (String)apiResult.get('statut');
       //String apiStatus = 'OK';
       String statusNewDemande = apiStatus == 'OK' ? 'SOU' : 'InwiB2C_EnErreur';
       String apiErrorMessage = (String)apiResult.get('reasonMessage');
       
       // Create new Demande based on Api return
       Map<String, Object> inputMapApiDemande = new Map<String, Object>{
            'InwiB2C_Statut_demande__c' => statusNewDemande,
                'newCommande' => false,
                'InwiB2C_lineId__c'=> apiResult.get('InwiB2C_lineId__c') ?? '',
                'InwiB2C_Motif__c'=> apiErrorMessage
       };
           If (apiStatus == 'OK'){
               inputMapApiDemande.put('InwiB2C_Compteur_recyclage__c',Integer.valueOf(lwcData.get('InwiB2C_Compteur_recyclage__c') ?? 0 )  + 1);
           }
        inputMapApiDemande = getFieldsFromInput(inputMapApiDemande , lwcData , InwiB2C_demande_partage__c.SObjectType);
        Id IdDemandeRec = InwiB2C_SharingRequestManagement.cloneSharingRequest(inputMapApiDemande);
       return new Map<String, Object>{
            'statutRecyclage' => apiStatus,
            'ErreurRecyclage' => apiErrorMessage,
            'IdDemandeRec' => IdDemandeRec
        };*/
    }
    
    
   public static Map<String, Object> callRecycleAPI( Map<String, Object> requestData , inwiB2C_demande_partage__c newDemandePartag) {
       
       String operator = (String) requestData.get('InwiB2C_Operateur_Infrastructure__c');
       String operatorRequest = operator == 'ORANGE' ? 'oma' : 'iam';
       Map<String, Object> inputMap = new Map<String, Object>();
        
        String procedureName = 'inwib2c_RecycleSharingRequestVULA';
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();
       
       String compteurRecyclage;
        try {
            Integer compteurValue = Integer.valueOf(requestData.get('InwiB2C_Compteur_recyclage__c'));
            compteurRecyclage = String.valueOf((compteurValue != null ) ? compteurValue + 1 : 1);
        } catch (Exception e) {
            compteurRecyclage = '1'; 
        }
        



        Object numVoieObj = requestData.get('InwiB2C_Numero_de_la_voie__c');
        String numVoie;

        if (numVoieObj instanceof String) {
            numVoie = (String) numVoieObj; 
        } else if (numVoieObj instanceof Integer) {
            numVoie = String.valueOf((Integer) numVoieObj); 
        } else {
            numVoie = null; 
        }
       
       
       Object longitudeObj = requestData.get('inwib2c_longitude__c');
        String longitude;

        if (longitudeObj instanceof String) {
            longitude = (String) longitudeObj; 
        } else if (longitudeObj instanceof Decimal ) {
            longitude = String.valueOf((Decimal) longitudeObj); 
        }else if (longitudeObj instanceof Integer) {
            longitude = String.valueOf((Integer) longitudeObj); 
        } else {
            longitude = null; 
        }
       
       
       
       Object latitudeObj = requestData.get('inwib2c_latitude__c');
        String latitude;

        if (latitudeObj instanceof String) {
            latitude = (String) latitudeObj; 
        } else if (latitudeObj instanceof Decimal ) {
            latitude = String.valueOf((Decimal) latitudeObj); 
        }else if (latitudeObj instanceof Integer) {
            latitude = String.valueOf((Integer) latitudeObj); 
        } else {
            latitude = null; 
        }
        
        if (operator == 'IAM') {
            Map<String, Object> iamPayload = new Map<String, Object>{
                'orderIdOC' =>  newDemandePartag.InwiB2C_Numero_Partage__c,
                'recyclingDate' => newDemandePartag.CreatedDate,
                'phoneNumber' => (String) requestData.get('InwiB2C_numeroContact__c'),
                'address' => new Map<String, Object>{
                    'codeProvince' => (String) requestData.get('InwiB2C_Code_Province__c'),
                    'codeCommune' => (String) requestData.get('InwiB2C_Code_Commune__c'),
                    'codeQuartier' => (String) requestData.get('InwiB2C_Code_Quartier__c'),
                    'codeVoie' => (String) requestData.get('InwiB2C_Code_Voie__c'),
                    'numVoie' => numVoie
                },
                'installationAppointment' => (String) requestData.get('InwiB2C_rendezvous__c'),
                'recyclingNumber' => compteurRecyclage,  
                'comment' => (String) requestData.get('InwiB2C_Commentaire__c') ?? 'Comment'
            };
           inputMap = iamPayload;
        } 
       
       
       else if (operator == 'Orange' || operator == 'ORANGE') {
            Map<String, Object> orangePayload = new Map<String, Object>{
                'orderIdOC' =>  newDemandePartag.InwiB2C_Numero_Partage__c,
                'recyclingDate' => newDemandePartag.CreatedDate,
                'lineId' => (String) requestData.get('InwiB2C_lineId__c'),
                'phoneNumber' => (String) requestData.get('InwiB2C_numeroContact__c'),
                'address' => new Map<String, Object>{
                    'city' => (String) requestData.get('inwib2c_city__c'),
                    'district' => (String) requestData.get('inwiB2C_district__c'),
                    'street' => (String) requestData.get('inwib2c_street__c'),
                    'plateId' => (String) requestData.get('inwib2c_projetid__c'),
                    'building' => (String) requestData.get('inwib2c_building__c'),
                    'coordinate' => new Map<String, Object>{
                        'longitude' =>longitude, // (String) requestData.get('inwib2c_longitude__c'),
                        'latitude' => latitude // (String) requestData.get('inwib2c_latitude__c')
                    }
                },
                'installationAppointment' => (String) requestData.get('InwiB2C_rendezvous__c')
            };
            inputMap = orangePayload;
        }
       ipInput.put('operator', operatorRequest );
            ipInput.put('Inputs', inputMap );
       System.debug('ipInput'+ ipInput);

        /*try {
            
            
  
            
            //callVIP(JSON.serialize(ipInput));

            System.debug('output'+ ipOutput);
                     
        } catch (Exception e) {
            System.debug('Request failed: ' + e.getMessage());
        }*/
       return ipInput;
    }
   public static Map<String, Object> callNewOrderAPI( Map<String, Object> requestData , inwiB2C_demande_partage__c newDemandePartag) {
       
       //Map<String, Object> inputMap = new Map<String, Object>();
        
        String procedureName = 'inwib2c_RecycleSharingRequestVULA';
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();
       
          

		ipInput.put('appointmentDate', requestData.get('InwiB2C_Order__c') );
       ipInput.put('OrderId', requestData.get('InwiB2C_Order__c') );
       //ipInput.put('Inputs', inputMap );
       System.debug('ipInput'+ ipInput);
       return ipInput;
    }
    
    
    
    public static Map<String, Object> getFieldsFromInput(Map<String, Object> existingMap, Map<String, Object> lwcData, SObjectType sObjectType) {
    
        //Set<String> validFields = sObjectType.getDescribe().fields.getMap().keySet();
        
        Map<String, Schema.SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
        Set<String> validFields = new Set<String>();
        
        for (String fieldName : fieldsMap.keySet()) {
            validFields.add(fieldsMap.get(fieldName).getDescribe().getName());
        }
    	//System.debug(JSON.serializePretty(validFields));
        
        for (String field : validFields) {
            Schema.SObjectField fieldSchema = fieldsMap.get(field);
            if (fieldSchema.getDescribe().isUpdateable() && lwcData.containsKey(field)) {
                Object value = lwcData.get(field);
                if (value != null && !existingMap.containsKey(field) && (!(value instanceof String) || String.valueOf(value).trim() != '')) {
                    existingMap.put(field, value);
                }
            }
        }
        //System.debug(JSON.serializePretty(existingMap));
        return existingMap;
    }
    
    public static void continueAfterAPICall(Map<String, Object> inputParams, Map<String, Object> outMap, Map<String, Object> options){
        
       String methodeName = (String) inputParams.get('methodeName');
       Map<String, Object> lwcData = (Map<String, Object>) inputParams.get('lwcData');
        Map<String, Object> apiResult = (Map<String, Object>) inputParams.get('apiResult');
        
        // Create new Demande based on Api return
       String apiStatus = (String)apiResult.get('status') ?? (String)apiResult.get('statut');
       //String apiStatus = 'OK';
       String statusNewDemande = apiStatus == 'OK' || apiStatus == '1' ? 'SOU' : 'InwiB2C_EnErreur';
       String apiErrorMessage =  apiStatus == 'OK' || apiStatus == '1' ? '' :  apiStatus + ' ' + ((String)apiResult.get('message') ?? 'Une erreur s\'est produite lors du recyclage de la demande')  + ' ' + ((String)apiResult.get('reason') ?? '') ;
       Integer compteurRecyclage;
        try {
            compteurRecyclage = Integer.valueOf(lwcData.get('InwiB2C_Compteur_recyclage__c'));
        } catch (Exception e) {
            compteurRecyclage = 0; 
        }
       String newCommandePartage = (String)inputParams.get('newCommandePartage');
       
       // Create new Demande based on Api return
        Map<String, Object> inputMapApiDemande = new Map<String, Object>{
            'InwiB2C_Statut_demande__c' => statusNewDemande,
                'newCommande' => false,
                'InwiB2C_lineId__c'=> (String) lwcData.get('InwiB2C_lineId__c') ?? '',
                'InwiB2C_Motif__c'=> apiErrorMessage
       };
          
			If (methodeName == 'createNewSharingNumber' || methodeName == 'createNewSharingNumberAndCallAPINewOrder'){
               inputMapApiDemande.put('InwiB2C_Commande_de_partage__c', newCommandePartage );
               inputMapApiDemande.put('InwiB2C_Compteur_recyclage__c', 0);
               compteurRecyclage = 0;
           }
            If (apiStatus == 'OK' || apiStatus == '1'){
               inputMapApiDemande.put('InwiB2C_Compteur_recyclage__c',compteurRecyclage  + 1);
           }
        
        inputMapApiDemande = getFieldsFromInput(inputMapApiDemande , lwcData , InwiB2C_demande_partage__c.SObjectType);
        Id IdDemandeRecAPI;
        If ( methodeName != 'createNewSharingNumberAndCallAPINewOrder'){
        	IdDemandeRecAPI = InwiB2C_SharingRequestManagement.cloneSharingRequest(inputMapApiDemande);
        }
        else {
           Id OrderId = (Id) lwcData.get('InwiB2C_Order__c') ;
           IdDemandeRecAPI = [Select Id from inwiB2C_demande_partage__c 
                              where InwiB2C_Order__c =: OrderId
                              ORDER by CreatedDate desc ,  InwiB2C_Sequence__c 
                               Limit 1].Id;
        }
        
        outMap.put('result',new Map<String, Object>{
            'statutRecyclage' => apiStatus,
            'ErreurRecyclage' => apiErrorMessage,
            'IdDemandeRec' => IdDemandeRecAPI
        });
                      
    }
}