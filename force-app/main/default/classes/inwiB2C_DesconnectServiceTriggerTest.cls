@isTest
public class inwiB2C_DesconnectServiceTriggerTest {
    @testSetup
    static void setup() {
        
    }

    @isTest
    static void testTriggerExecution() {
        // Start test context
        Test.startTest();
        
       
        InwiB2C_VulaDesconnectService__e eventRecord = new InwiB2C_VulaDesconnectService__e(
            Trace_Id__c = 'a6pAd000000sc9xIAA',
            Step__c = 'SetGeneration'
        );

        // Insertion de l'événement pour déclencher le trigger
        Database.SaveResult result = EventBus.publish(eventRecord);

        // Vérification que l'insertion a réussi
        System.assert(result.isSuccess(), 'L\'événement doit être publié avec succès');

        Test.stopTest();
        
        
    }
}