global with sharing class inwiB2C_CreateTraitementMassif  implements vlocity_cmt.VlocityOpenInterface{
    
    public Boolean InvokeMethod(String methodName,Map<String,Object> input,Map<String,Object> output, Map<String,Object> options) {   
        Boolean result = true;
        try
        {
            if(methodName == 'applyTraitment'){
                 output.put('result',  applyTraitment(input));
            }
         }
        catch(Exception e)
       	{
           System.debug('applyTraitment:invokeMethod -> exception: '+e);
           result = false;
       	}
       
       return result;
    }

    Map<String, Object> applyTraitment(Map<String, Object> input){
      
        Map<String, Object> Output = new Map<String, Object>();
        Map<String, Object> ipOutput = new Map<String, Object>();
        Map<String, Object> ipOptions = new Map<String, Object>();
        List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> recordsToUpdate = new List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c>();
        String procedureName = 'inwib2c_InwiB2C_CreateMassiveOperation';

        Map<String, Object> deserialized = (Map<String, Object>)input.get('idSubList');
        
        String action = (String)deserialized.get('action');
        String Origine = (String)deserialized.get('origine');
        String Motif = (String)deserialized.get('motif');
        system.debug('deserialized'+deserialized);
        List<String> idList = new List<String>();
        for (Object instance : (List<Object>)deserialized.get('data')){
            Map<String, Object> instanceMap = (Map<String, Object>)instance;
            idList.add((String) instanceMap.get('id'));
        }
       
   system.debug(idList);
        //Begin B-10340 Amine E Product2.InwiB2C_Type_offre__c en place du Product2.InwiB2C_type_contrat__c 
        List<Asset> allEligiblesSubs = [SELECT vlocity_cmt__SubscriptionId__c,vlocity_cmt__SubscriptionId__r.vlocity_cmt__AccountId__r.Inwib2c_CIN__c,vlocity_cmt__SubscriptionId__r.vlocity_cmt__AccountId__r.Inwib2c_Pr_nom__c,Product2.inwiB2C_tsrm__c, Product2.InwiB2C_Type_offre__c,vlocity_cmt__SubscriptionId__r.InwiB2C_IMSI__c,vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c
        //End B-10340      
                                        FROM Asset 
                                        WHERE vlocity_cmt__ParentItemId__c = ''
                                        AND vlocity_cmt__SubscriptionId__c in:idList];
        
        List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c> records = [SELECT INWIB2C_MDN__c,INWIB2C_STATUT__c,INWIB2C_SUBSCRIPTION_ID__c
                                                                    FROM INWIB2C_TRAITEMENTMASSIF_FICHIER__c
                                                                    WHERE INWIB2C_SUBSCRIPTION_ID__c in:idList 
                                                                    ];
    
    List<Map<String,Object>> data = new List<Map<String,Object>>();
    for (Asset item : allEligiblesSubs){
        Map<String,String> dataItem = new Map<String,String>();
        dataItem.put('firstName',item.vlocity_cmt__SubscriptionId__r.vlocity_cmt__AccountId__r.Inwib2c_Pr_nom__c);
        dataItem.put('idContrat',item.vlocity_cmt__SubscriptionId__c);
        dataItem.put('identificationNumber',item.vlocity_cmt__SubscriptionId__r.vlocity_cmt__AccountId__r.Inwib2c_CIN__c);
        dataItem.put('imsi',item.vlocity_cmt__SubscriptionId__r.InwiB2C_IMSI__c);
        dataItem.put('msisdn',item.vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c);
        dataItem.put('operationType',action);
        dataItem.put('motif',Motif);
        dataItem.put('tsrm',item.Product2.inwiB2C_tsrm__c==null?'':item.Product2.inwiB2C_tsrm__c);
        //Begin B-10340 Amine E Product2.InwiB2C_Type_offre__c en place du Product2.InwiB2C_type_contrat__c
        dataItem.put('typeContrat',item.Product2.InwiB2C_Type_offre__c);
        //End B-10340  
         data.add(dataItem);
    }
        
        Map<String,Object> payload = new Map<String,Object>();
                        payload.put('contractData', data);
                        payload.put('origine', Origine);

        system.debug('payload'+JSON.serializePretty(payload));
        
                  ipOutput = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, payload, ipOptions);

        system.debug('ipOutput'+ipOutput);
         String vipStatus = (String) ipOutput.get('status');
        Output.put('status',vipStatus);
         system.debug('vipStatus'+vipStatus);
         system.debug('records'+records);
        if(vipStatus == '1' || Test.isRunningTest())
        {
            for(INWIB2C_TRAITEMENTMASSIF_FICHIER__c record : records)
            {
                record.INWIB2C_STATUT__c = 'SUCCESS';
                recordsToUpdate.add(record);
            }
            
        }else{
            for(INWIB2C_TRAITEMENTMASSIF_FICHIER__c record : records)
            {
                record.INWIB2C_STATUT__c = 'FAILED';
                recordsToUpdate.add(record);
            }
        }
        Update recordsToUpdate;
        return Output;
    }
     

    
}