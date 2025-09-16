global with sharing class InwiB2C_UTFileHandler implements vlocity_cmt.VlocityOpenInterface{
    public Boolean InvokeMethod(String methodName,Map<String,Object> input,Map<String,Object> output, Map<String,Object> options) {   
        Boolean result = true;
        try
        {
            if(methodName == 'ReadFile'){
                output.put('Retour', ReadFile(input));
            }
         }
        catch(Exception e)
       	{
           System.debug('MDNFileHandler:invokeMethod -> exception: '+e);
           result = false;
       	}
       
       return result;
    }
    private map<string,Object> ReadFile(Map<String, Object> input){
        //Id contentDocumentId = '0693L000002TWtKQAW';
        Boolean error = false;
		String msg;
		Map<String,Integer> headerMap = new Map<String,Integer>();
        Id contentDocumentId = (Id)input.get('contentDocumentId');
        String fileName = (String)input.get('fileName');
        Map<String,Object> output =new Map<String,Object>();
        List<Object> demandes = new List<Object>();
        Integer size;
        if(contentDocumentId != null) {
            ContentVersion contentVersionObj = [SELECT Id, Title, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            String data = Blob.valueOf(contentVersionObj.VersionData.toString()).toString();
            //system.debug('DATA: '+data);
            list<String> recordsList = data.split('\n');
            //system.debug(recordsList.size());
            size=recordsList.size()-1;
            if(size == -1 || size == 0 ||size == 1 || String.isBlank(data)){
                error = true;
                msg = 'le fichier ne contient aucune ligne ';
            }
            else if(size > 200){
                error = true;
                msg = 'le fichier depasse 200 lignes ';
            }
            else if(!recordsList[0].contains('Nd') || !recordsList[0].contains('Mac') || !recordsList[0].contains('Technologie source') || !recordsList[0].contains('Technologie cible')){
                error = true;
                msg = 'Merci d\'ajouter l\'êntete suivant : Nd;Mac;Technologie source;Technologie cible';
            }
            else{
                list<String> header = recordsList[0].split(';');
                for(Integer j=0;j<4;j++){
                    if(header[j].indexOf('\r') != -1)
                    	headerMap.put(header[j].substring(0,header[j].indexOf('\r')),j);
                    else 	
                        headerMap.put(header[j],j);
                }
                
                //insert file
                InwiB2C_Update_Techno_File__c file =new InwiB2C_Update_Techno_File__c(InwiB2C_Statut__c='In Progress',Name=fileName, InwiB2C_UIID__c=contentDocumentId);
                insert file;
                
                List<InwiB2C_Changement_de_techno_en_masse__c> listCT= new List<InwiB2C_Changement_de_techno_en_masse__c>();
                for(Integer i=1;i<recordsList.size();i++){
                    system.debug('ligne: '+recordsList[i]);
                    list<String> donnee = recordsList[i].split(';');
                    for (String tmp : donnee){
                        if(String.isBlank(tmp)){
                            error = true;
                			msg = 'Un des parametres est manquant';
                        	break;
                        }

                    }
                    //get techno source
                    String technoSourceTMP;
                    if(donnee[headerMap.get('Technologie source')].toLowercase().contains('vula'))
                        technoSourceTMP='VULA';
                    else
                    technoSourceTMP ='BitStream';
                    //get techno cible
                    String technoCibleTMP;
                    if(donnee[headerMap.get('Technologie cible')].toLowercase().contains('vula'))
                            technoCibleTMP='VULA'; 
                    	else
                            technoCibleTMP='BitStream';
                    
                    //format ND
                    String erreur='';
                    Pattern NdPattern = Pattern.compile('^05[0-9]{8}');
					Matcher NdMatcher = NdPattern.matcher(donnee[0]);
                    if(!NdMatcher.matches())
                        erreur='Format ND invalide';
                    
                    //create record
                    InwiB2C_Changement_de_techno_en_masse__c CTRecord= new InwiB2C_Changement_de_techno_en_masse__c(
                        InwiB2C_Nd__c=donnee[0],
                        InwiB2C_Mac__c=donnee[1],
                        InwiB2C_Technologie_source__c=technoSourceTMP,
                        InwiB2C_Technologie_Cible__c=technoCibleTMP,
                        InwiB2C_Statut__c='Waiting',
                        InwiB2C_UIID__c=contentDocumentId,
                        InwiB2C_Erreur__c=erreur
                    );
                    listCT.add(CTRecord);
                    
                }
                //insert records
                insert listCT;
                output.put('demandes',listCT);
            }
        }
        output.put('error',error);
        if(error == true){
            output.put('Message',msg);
        }
    	else{
            List<InwiB2C_Changement_de_techno_en_masse__c> CTRecords = [Select Id,InwiB2C_Nd__c from InwiB2C_Changement_de_techno_en_masse__c where InwiB2C_UIID__c=:contentDocumentId order by createddate desc limit 50];
			for (InwiB2C_Changement_de_techno_en_masse__c CT : CTRecords ){
    			Map<String,String> demande = new Map<String,String>();
    			demande.put('RecordId',CT.Id);
    			demande.put('ND',CT.InwiB2C_Nd__c);
    			demandes.add(demande);
			}
            InwiB2C_Controle_CT_Massif__e CTEvent= new InwiB2C_Controle_CT_Massif__e(InwiB2C_documentId__c=contentDocumentId,InwiB2C_demandesList__c=JSON.serialize(demandes),InwiB2C_fileSize__c=size,InwiB2C_Counter__c=0);
            EventBus.publish(CTEvent);

        }
        return output;
                    
    }}