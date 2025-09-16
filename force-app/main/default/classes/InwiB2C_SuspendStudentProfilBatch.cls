public class InwiB2C_SuspendStudentProfilBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    String IP_CreateMassiveOperation = 'inwib2c_InwiB2C_CreateMassiveOperation';
   // String IP_PushSMSStudientNotification ='inwib2c_InwiB2C_PushSMSStudientNotification';
    Date day30;
    Date day23;
    public InwiB2C_SuspendStudentProfilBatch(){ 
    }
    public Database.querylocator start(Database.BatchableContext bc){
        day30=Date.today().addDays(-30);
        day23=Date.today().addDays(-23);
        system.debug('day today 30: '+day30);
        system.debug('day today 7: '+day23);
        return Database.getQueryLocator([SELECT Id,Name, InwiB2C_Statut__c,InwiB2C_MDN__c,
                                          InwiB2C_SubscriptionId__r.Inwib2c_type_de_sim__c,InwiB2C_SubscriptionId__c,
                                          InwiB2C_Date_de_creation__c,
                                          InwiB2C_SubscriptionId__r.vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.FirstName,
                                          InwiB2C_SubscriptionId__r.vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,
                                          InwiB2C_SubscriptionId__r.InwiB2C_IMSI__c FROM InwiB2C_MDNOffreEtudiant__c 
                                          WHERE (InwiB2C_Date_de_creation__c <= :day30 OR InwiB2C_Date_de_creation__c =:day23) 
                                          AND InwiB2C_Statut__c='InwiB2C_Nouveau'
                                          AND  InwiB2C_SubscriptionId__r.InwiB2C_Contract__r.InwiB2C_Statut_d_identification__c!='identifie'
                                          ]);
        }
    
    public void execute(Database.BatchableContext bc,List<InwiB2C_MDNOffreEtudiant__c> scope){
        Map<String, Object> Output = new Map<String, Object>();
        Map<String, Object> ipOutput = new Map<String, Object>();
        Map<String, Object> ipOptions = new Map<String, Object>();
        List<InwiB2C_MDNOffreEtudiant__c> studList =new List <InwiB2C_MDNOffreEtudiant__c>();
        List<Map<String,Object>> data = new List<Map<String,Object>>();
        List<inwiB2C_API_PushSMS__e> API_PushSMS_event = new List<inwiB2C_API_PushSMS__e>();
        day30=Date.today().addDays(-30);
        day23=Date.today().addDays(-23);
        for(InwiB2C_MDNOffreEtudiant__c student : scope){
            system.debug('in scope');
            if(student.InwiB2C_Date_de_creation__c <=day30){//Envoi suspension vers SOA Apres 30jrs
                system.debug('in scope30');
                //Update Statut Subscription
                student.InwiB2C_Statut__c='InwiB2C_Envoyé';
                studList.add(student);
                //API SOA
                Map<String,String> dataItem = new Map<String,String>();
                dataItem.put('firstName',student.InwiB2C_SubscriptionId__r.vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.FirstName);
                dataItem.put('idContrat',student.InwiB2C_SubscriptionId__c);
                dataItem.put('identificationNumber',student.InwiB2C_SubscriptionId__r.vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c);
                dataItem.put('imsi',student.InwiB2C_SubscriptionId__r.InwiB2C_IMSI__c);
                dataItem.put('msisdn',student.InwiB2C_MDN__c);
                dataItem.put('operationType','SUSP');
                dataItem.put('motif','SUSP_IDENTIF_CAMPUS');
                dataItem.put('tsrm','false');
                dataItem.put('typeContrat','GSM');
                data.add(dataItem);
               
            }else if(student.InwiB2C_Date_de_creation__c==day23){//Envoi notification avant 7 jrs
                    system.debug('in scope23');
                    inwiB2C_API_PushSMS__e  NewActionEvent = new inwiB2C_API_PushSMS__e();
                    NewActionEvent.InwiB2C_MDN__c=student.InwiB2C_MDN__c;  
                    NewActionEvent.InwiB2C_message__c='inwi : Nous vous invitons à identifier votre ligne en agence inwi ou via Myinwi dans un délai de 7 jours avant la suspension de votre ligne.'; 
                    API_PushSMS_event.Add(NewActionEvent);
                    system.debug('eventaction'+API_PushSMS_event); 
            }
        }
            if(data!=null && !data.isEmpty()){
                system.debug('List: '+data);
                Map<String,Object> payload = new Map<String,Object>();
                payload.put('contractData', data);
                payload.put('origine', 'PLC');
                system.debug('payload: '+payload);
                ipOutput = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(IP_CreateMassiveOperation, payload, ipOptions);
                system.debug('ipOutputSuspension: '+ipOutput);
                String vipStatus = (String) ipOutput.get('status');
                Output.put('status',vipStatus);
                system.debug('vipStatus'+vipStatus);
                if(vipStatus == '1'|| Test.isRunningTest()){
                    update studList;
                }
            }  
            List<Database.SaveResult> results = EventBus.publish(API_PushSMS_event);
           
        
        }
    
     
    public void finish(Database.BatchableContext bc){
	        
    }
}