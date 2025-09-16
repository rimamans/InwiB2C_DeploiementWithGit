public with sharing class InwiB2C_UpdateResiliationSuspensionBatch 
       implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date todayDate = System.today();

        return Database.getQueryLocator([
            SELECT Id, InwiB2C_Statut_Resil__c, 
                   inwiB2C_expectedDisconnectDate__c, 
                   inwiB2C_expectedSuspendDate__c
            FROM InwiB2C_Demande_de_resiliation__c
            WHERE 
                (InwiB2C_Statut_Resil__c = 'En attente de suspension' 
                 AND inwiB2C_expectedSuspendDate__c <= :todayDate)
                OR
                (InwiB2C_Statut_Resil__c = 'En attente de résiliation' 
                 AND inwiB2C_expectedDisconnectDate__c <= :todayDate)
        ]);
    }

    public void execute(Database.BatchableContext bc, 
                        List<InwiB2C_Demande_de_resiliation__c> scope) {
        for (InwiB2C_Demande_de_resiliation__c demande : scope) {
            if (demande.InwiB2C_Statut_Resil__c == 'En attente de suspension' 
                && demande.inwiB2C_expectedSuspendDate__c <= System.today()) {
                demande.InwiB2C_Statut_Resil__c = 'En cours de suspension';
            }
            if (demande.InwiB2C_Statut_Resil__c == 'En attente de résiliation' 
                && demande.inwiB2C_expectedDisconnectDate__c <= System.today()) {
                demande.InwiB2C_Statut_Resil__c = 'En cours de résiliation';
            }
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
    }
}