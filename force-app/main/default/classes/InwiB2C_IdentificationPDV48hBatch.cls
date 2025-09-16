public class InwiB2C_IdentificationPDV48hBatch  implements Database.Batchable<sObject>, Database.AllowsCallouts {
    Datetime d;
    public InwiB2C_IdentificationPDV48hBatch(){
        
       d = datetime.now().addhours(-48);
      //   d = datetime.now().addMinutes(-5);
    }
    public Database.querylocator start(Database.BatchableContext bc){ 
        System.debug('Hours : ' + d);
        //get all identification after 48h
        if(!Test.isRunningTest()){
        return Database.getQueryLocator([SELECT Id,InwiB2C_jsonToUpdateClient__c,InwiB2C_jsonToUpdateContract__c ,
                                         InwiB2C_Subscription__c,inwiB2C_isClientMonoligne__c,InwiB2C_jsonToUpdateAdresse__c,
                                         InwiB2C_isCinExist__c,InwiB2C_MDN__c,InwiB2C_Contact__c,InwiB2C_AccountId__c FROM InwiB2C_Demande_IdentificationClient__c 
                                         WHERE CreatedDate < :d and InwiB2C_Statut__c='InwiB2C_Encours'
                                       // WHERE Id='a7W3M000000AZ6rUAG'
                                        ]);}
        else{
          return Database.getQueryLocator([SELECT Id,InwiB2C_jsonToUpdateClient__c,InwiB2C_jsonToUpdateContract__c ,
                                         InwiB2C_Subscription__c,inwiB2C_isClientMonoligne__c,InwiB2C_jsonToUpdateAdresse__c,
                                         InwiB2C_isCinExist__c,InwiB2C_MDN__c,InwiB2C_Contact__c,InwiB2C_AccountId__c FROM InwiB2C_Demande_IdentificationClient__c 
                                         WHERE InwiB2C_Statut__c='InwiB2C_Encours' limit 1
                                        ]);                                            
                                        }
            }
     public void execute(Database.BatchableContext bc,List<InwiB2C_Demande_IdentificationClient__c> scope){
         List<InwiB2C_Demande_IdentificationClient__c> identificationList =new List <InwiB2C_Demande_IdentificationClient__c>();
         List<InwiB2C_Identification_PDV_48h__e> Identification_PDV_48h_event = new List<InwiB2C_Identification_PDV_48h__e>();
      
         for (InwiB2C_Demande_IdentificationClient__c identification: scope){
             
          InwiB2C_Identification_PDV_48h__e  NewActionEvent = new InwiB2C_Identification_PDV_48h__e();
              NewActionEvent.InwiB2C_json_To_Update_Contract__c=identification.InwiB2C_jsonToUpdateContract__c;
              NewActionEvent.InwiB2C_json_To_Update_Client__c=identification.InwiB2C_jsonToUpdateClient__c;
              NewActionEvent.InwiB2C_jsonToUpdateAdresse__c= identification.InwiB2C_jsonToUpdateAdresse__c;
              NewActionEvent.InwiB2C_SubscriptionId__c=identification.InwiB2C_Subscription__c;
              NewActionEvent.InwiB2C_ContactId__c=identification.InwiB2C_Contact__c;
              NewActionEvent.InwiB2C_isCinExist__c=identification.InwiB2C_isCinExist__c	;
              NewActionEvent.InwiB2C_isClientMonoligne__c=identification.inwiB2C_isClientMonoligne__c;
              NewActionEvent.InwiB2C_AccountId__c=identification.InwiB2C_AccountId__c;
              NewActionEvent.InwiB2C_MDN__c=identification.InwiB2C_MDN__c;
              NewActionEvent.InwiB2C_IdDemande__c=identification.Id;
         	  Identification_PDV_48h_event.Add(NewActionEvent);
           
        }
          system.debug('eventaction'+Identification_PDV_48h_event);
		    
         List<Database.SaveResult> results = EventBus.publish(Identification_PDV_48h_event);
        
       system.debug('Identification List: '+identificationList);
     }
     public void finish(Database.BatchableContext bc){
	        
     }
}