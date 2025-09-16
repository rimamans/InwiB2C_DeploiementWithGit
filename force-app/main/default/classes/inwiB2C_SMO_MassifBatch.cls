public class inwiB2C_SMO_MassifBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    public inwiB2C_SMO_MassifBatch() {
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT id ,  inwiB2C_Billing_Account__c, INWIB2C_DOCUMENT_ID__c, INWIB2C_MDN__c , INWIB2C_STATUT__c,
        INWIB2C_Origin__c, INWIB2C_ACTION__c, INWIB2C_Motif__c,INWIB2C_SUBSCRIPTION_ID__c
        FROM INWIB2C_TRAITEMENTMASSIF_FICHIER__c 
        WHERE INWIB2C_STATUT__c =:'Ready' LIMIT 200]);
    }
    public void execute(Database.BatchableContext BC,  List<INWIB2C_TRAITEMENTMASSIF_FICHIER__c>  scope) {
        List<Map<String, Object>> listIdSOA = new List<Map<String, Object>>();
        List<Map<Id, Object>> listSUBId = new List<Map<Id, Object>>();
        Map <String, Object> inputMap = new Map <String, Object> ();
        Map <String, Object> outputMap = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();
        List<inwiB2C_SMO_Massif__e> sMOMassListPE = new List<inwiB2C_SMO_Massif__e>();  
    
        String motif;
        String origine;
        String action;
        for(INWIB2C_TRAITEMENTMASSIF_FICHIER__c data : scope){
            if(data.INWIB2C_ACTION__c=='REHA' || data.INWIB2C_ACTION__c=='REHAI' ||data.INWIB2C_ACTION__c=='REHAB' ||data.INWIB2C_ACTION__c=='REHA_ROAM_DATA' 
            ||data.INWIB2C_ACTION__c=='REHAE' ||data.INWIB2C_ACTION__c=='SUSA' ||data.INWIB2C_ACTION__c=='SUSAE'
            || data.INWIB2C_ACTION__c=='SUSAI' ||data.INWIB2C_ACTION__c=='SUS_ROAM_DATA' || data.INWIB2C_ACTION__c=='SUST' ){
                Map<String, Object> idSubMap = new Map<String, Object>();
                idSubMap.put('id', data.INWIB2C_SUBSCRIPTION_ID__c);
                listIdSOA.add(idSubMap);
                motif=data.INWIB2C_Motif__c;
                origine=data.INWIB2C_Origin__c;
                //chb B-22960 17/12/2024
               // action=data.INWIB2C_ACTION__c=='REHA' || data.INWIB2C_ACTION__c=='REHAI' || data.INWIB2C_ACTION__c=='REHA_ROAM_DATA' || data.INWIB2C_ACTION__c=='REHAE' ?'REHAB':data.INWIB2C_ACTION__c=='SUSA' || data.INWIB2C_ACTION__c=='SUSAE' || data.INWIB2C_ACTION__c=='SUSAI' || data.INWIB2C_ACTION__c=='SUS_ROAM_DATA'?'SUSP':data.INWIB2C_ACTION__c;
               action=data.INWIB2C_ACTION__c=='REHA' ?'REHAB':data.INWIB2C_ACTION__c=='SUSA' || data.INWIB2C_ACTION__c=='SUSAE'?'SUSP':data.INWIB2C_ACTION__c;
           
            }
            if(data.INWIB2C_ACTION__c=='RESIL' || data.INWIB2C_ACTION__c=='DECONN' || data.INWIB2C_ACTION__c=='RESILD'){
                data.INWIB2C_STATUT__c='SUCCESS';
                inwiB2C_SMO_Massif__e sMOMassObjPE = new inwiB2C_SMO_Massif__e();
                sMOMassObjPE.inwiB2C_SubscriptionID__c = data.INWIB2C_SUBSCRIPTION_ID__c;
                sMOMassObjPE.inwiB2C_Action__c = data.INWIB2C_ACTION__c;
                sMOMassObjPE.inwiB2C_Motif__c = data.INWIB2C_Motif__c;
                sMOMassObjPE.InwiB2C_STEP__c='RESILVIP';
                System.debug('inserting in the list');
                sMOMassListPE.add(sMOMassObjPE);

            }
        }
      
        if (listIdSOA.size() > 0) {
            Map <String, Object> ParamsSOA = new Map <String, Object> ();
            inputMap.put('data', listIdSOA);
            inputMap.put('motif', motif);
            inputMap.put('action', action);
            inputMap.put('origine', origine);
            ParamsSOA.put('idSubList',inputMap);
            inwiB2C_CreateTraitementMassif traitementMassif = new inwiB2C_CreateTraitementMassif();
            traitementMassif.invokeMethod('applyTraitment',ParamsSOA, ipOptions, null);
        }
        if (sMOMassListPE.size() > 0) {
                System.debug('we are here2');
                List<Database.SaveResult> resultsSubsMassPE = EventBus.publish(sMOMassListPE);
                System.debug('we are here2');   
           //inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
            update scope;
        }
    }

    public void finish(Database.BatchableContext BC) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] email = new String[]{'prod.salesforceb2c@inwi.ma'};
        mail.setToAddresses(email);
        mail.setReplyTo('prod.salesforceb2c@inwi.ma');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process ');
        mail.setPlainTextBody('The Batch Apex job ');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}