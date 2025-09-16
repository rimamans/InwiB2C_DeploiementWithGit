/**
 * @author            : LAKRARI Imane
 * @created on		  :	26-10-2023
 * @last modified on  : 27-06-2024
**/
public with sharing class InwiB2C_ChangementTechnoMassifBatch implements Database.Batchable<sObject>{
    
    public Database.querylocator start(Database.BatchableContext BC){
        //traiter les demandes de changement de techno avec statut submitted
        return Database.getQueryLocator([Select id,InwiB2C_Technologie_Cible__c,InwiB2C_Ancien_Demande_degroupage__c,InwiB2C_Statut__c,InwiB2C_Technologie_source__c,InwiB2C_Subscription__c  from InwiB2C_Changement_de_techno_en_masse__c  where InwiB2C_Statut__c = 'Submitted' limit 200]);
    }
    
    public void execute(Database.BatchableContext BC, List<InwiB2C_Changement_de_techno_en_masse__c> scope){
        
        List<InwiB2C_Changement_de_techno_en_masse__c> UTRequests = new List<InwiB2C_Changement_de_techno_en_masse__c>();
        List<InwiB2C_Traitement_changement_techno__e> chtEvents = new List<InwiB2C_Traitement_changement_techno__e>();

        for (InwiB2C_Changement_de_techno_en_masse__c demandeCT : scope){

            //platform event de la creation de la commande 
            InwiB2C_Traitement_changement_techno__e UTEvent = new InwiB2C_Traitement_changement_techno__e();
            UTEvent.InwiB2C_demandeId__c = demandeCT.InwiB2C_Ancien_Demande_degroupage__c;
            UTEvent.InwiB2C_technologie_cible__c = demandeCT.InwiB2C_Technologie_Cible__c;
            UTEvent.InwiB2C_technologie_source__c = demandeCT.InwiB2C_Technologie_source__c;
            UTEvent.InwiB2C_subscriptionId__c = demandeCT.InwiB2C_Subscription__c;
            UTEvent.InwiB2C_Type__c = 'Massif';
            chtEvents.add(UTEvent);

            
            //changer le statut des demandes de changement de techno traitées
            demandeCT.InwiB2C_Statut__c ='Done';
            UTRequests.add(demandeCT);
        }

        update UTRequests;

        if(!chtEvents.isEmpty()){
            system.debug(chtEvents.size());
                List <Database.SaveResult> publishEvents = EventBus.publish(chtEvents);
            }

        
    }
    
    public void finish(Database.BatchableContext BC){}
    

}