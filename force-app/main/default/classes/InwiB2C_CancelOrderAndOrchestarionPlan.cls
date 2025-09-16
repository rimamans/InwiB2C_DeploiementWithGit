/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-09-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class InwiB2C_CancelOrderAndOrchestarionPlan implements vlocity_cmt.VlocityOpenInterface2 {

    global static Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,object> optionMap ) {
        Boolean result = true; 

        try {
            if (methodName.equals('CancelOrderAndOrchePlan')) {
                Id orderId = (Id) inputMap.get('orderId');
                Id orchestrationPlanId = (Id) inputMap.get('orchestrationPlanId');


                InwiB2C_CancelOrderAndOrchestarionPlan__e eventObj = new InwiB2C_CancelOrderAndOrchestarionPlan__e(
                    InwiB2C_OrderId__c = orderId,
                    InwiB2C_OrchestrationPlanId__c = orchestrationPlanId
                );
                Database.SaveResult sr = EventBus.publish(eventObj);

                if (sr.isSuccess()) {
                    System.debug('[invokeMethod] Événement publié avec succès.');
                    outputMap.put('status', 'SUCCESS');
                     outputMap.put('message', 'Événement publié avec succès.');
                } else {
                    System.debug('[invokeMethod] Échec de la publication.');
                    result = false;
                    outputMap.put('status', 'FAILURE');
                    outputMap.put('message', 'Erreur lors de la publication de l’événement.');
                }
            }
        } catch (Exception e) {
            System.debug('Erreur dans invokeMethod : ' + e.getMessage());
            result = false;
            outputMap.put('status', 'ERROR');
            outputMap.put('message', e.getMessage());
        }

        return result;
    }

    public static void CancelOrderAndOrchePlan(Id orderId, Id orchestrationPlanId) {
        try {
            Order orderObj = [SELECT Id, inwib2c_DetailMotif__c, vlocity_cmt__OrderStatus__c, inwiB2C_Statut__c, inwib2c_MotifAnnulation__c FROM Order WHERE Id = :orderId];
            vlocity_cmt__OrchestrationPlan__c planObj = [SELECT Id, vlocity_cmt__State__c FROM vlocity_cmt__OrchestrationPlan__c WHERE Id = :orchestrationPlanId];

            if (orderObj != null && planObj != null) {
                orderObj.inwib2c_DetailMotif__c = 'Annulation dégroupage';
                orderObj.vlocity_cmt__OrderStatus__c = 'Cancelled';
                orderObj.inwiB2C_Statut__c = 'inwiB2C_Annulee';
                orderObj.inwib2c_MotifAnnulation__c = 'inwib2c_AutreMotif';
                update orderObj;

                planObj.vlocity_cmt__State__c = 'Frozen';
                update planObj;

                System.debug('[cancelOrderAndOrchPlan] Mise à jour terminée');
            }
        } catch (Exception e) {
            System.debug('[cancelOrderAndOrchPlan] Erreur : ' + e.getMessage());
        }
    }
}