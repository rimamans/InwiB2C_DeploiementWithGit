/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-08-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class InwIB2C_UpdateStatutSubscriptionTest {
    @isTest
    static void testInvokeMethod() {
        // Créer un enregistrement de test pour l'objet vlocity_cmt__Subscription__c
        vlocity_cmt__Subscription__c testSubscription = new vlocity_cmt__Subscription__c(
            Name = 'Test Subscription',
            vlocity_cmt__Status__c = 'Active',
            vlocity_cmt__SubscriptionNumber__c = 'SUB12345'

        );
        insert testSubscription;

        // Appeler la méthode invokeMethod pour exécuter publishEvent sur l'enregistrement de test
        Map<String, Object> input = new Map<String, Object>();
        input.put('subscriptionId', testSubscription.Id);

        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Boolean result = InwIB2C_UpdateStatutSubscription.invokeMethod('publishEvent', input, output, options);

        // Vérifier que la méthode a renvoyé true (succès)
        System.assertEquals(true, result);

        // Vérifier que l'enregistrement de test a été mis à jour avec le statut 'Expired'
        vlocity_cmt__Subscription__c updatedSubscription = [SELECT Id,vlocity_cmt__Status__c FROM vlocity_cmt__Subscription__c WHERE Id = :testSubscription.Id];
        System.assertEquals('Expired', updatedSubscription.vlocity_cmt__Status__c);
    }
}