/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-05-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger InwiB2C_CancelOrderAndOrchePlanTrigger on InwiB2C_CancelOrderAndOrchestarionPlan__e (after insert) {

for (InwiB2C_CancelOrderAndOrchestarionPlan__e eventRecord : Trigger.New) {
    try {

        InwiB2C_CancelOrderAndOrchestarionPlan.CancelOrderAndOrchePlan(
            eventRecord.InwiB2C_OrderId__c, 
            eventRecord.InwiB2C_OrchestrationPlanId__c
        );
    } catch (Exception e) {
        System.debug('Erreur lors de l\'annulation de la commande et du plan d\'orchestration : ' + e.getMessage());
    }
}
    
}