@isTest
public class InwiB2C_ExecTraitMigPrePostTriggerTest {
    
    @testSetup
    static void setupTestData() {
        // Préparation des données de test si nécessaire
    }

    @isTest
    static void testExecuteSMO_WithTraceId() {
        // Création d'un enregistrement de trace pour tester la condition InwiB2C_TraceId__c
        InwiB2C_Trace_API__c trace = new InwiB2C_Trace_API__c(
            InwiB2C_MDN__c = '212648069781',
            InwiB2C_request_body__c = '{"CSExecuteMigPrePost":{"Ins":"a4k0C0000008jD3QAI","MDN":"212648078653","billingAccount":"0010C00000VXWibQAH","fmsReference":"1234567","fmsAmount":"214","Profil":"54234","productId":"86908","Code_offre":"INWIB2C_OFFERING_99DH_APL"},"CSOperationInfo":{"user":"SF","channel":"myInwi","uuid":"13412452345234"}}'
        );
        insert trace;

        // Création de l'événement avec InwiB2C_TraceId__c
        inwiB2C_ExecuteMigrPrePostEvent__e EventItem = new inwiB2C_ExecuteMigrPrePostEvent__e(
            InwiB2C_TraceId__c = trace.Id
        );

        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();

        // Vérification que l'événement est publié avec succès
        System.assert(results.isSuccess(), 'L\'événement avec TraceId doit être publié avec succès.');
    }

    @isTest
    static void testExecuteSMO_WithOrderIdAndOptionCode() {
        // Création de l'événement avec inwiB2C_OrderId__c et inwib2c_Option_Code__c
        inwiB2C_ExecuteMigrPrePostEvent__e EventItem = new inwiB2C_ExecuteMigrPrePostEvent__e(
            inwiB2C_OrderId__c = '801Vd00000H05xDIAR',
            inwib2c_Option_Code__c = 'INWIB2C_MOB02_Volte'
        );

        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();

        // Vérification que l'événement est publié avec succès
        System.assert(results.isSuccess(), 'L\'événement avec OrderId et OptionCode doit être publié avec succès.');
    }
}