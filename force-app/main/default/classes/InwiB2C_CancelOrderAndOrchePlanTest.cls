@IsTest
private class InwiB2C_CancelOrderAndOrchePlanTest {

    // 1. Test du chemin SUCCESS
    @IsTest
    static void testInvokeMethodCancelOrder() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Order testOrder = new Order(
            Name = 'Test Order',
            Status = 'Draft',
            EffectiveDate = Date.today(),
            AccountId = testAccount.Id,
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition'
        );
        insert testOrder;

        vlocity_cmt__OrchestrationPlan__c testPlan = new vlocity_cmt__OrchestrationPlan__c(
            vlocity_cmt__State__c = 'InProgress'
        );
        insert testPlan;

        Map<String,Object> inputMap = new Map<String,Object>{
            'orderId' => testOrder.Id,
            'orchestrationPlanId' => testPlan.Id
        };
        Map<String,Object> outputMap = new Map<String,Object>();
        Map<String,Object> optionMap = new Map<String,Object>();

        Test.startTest();
        Boolean result = InwiB2C_CancelOrderAndOrchestarionPlan.invokeMethod('CancelOrderAndOrchePlan', inputMap, outputMap, optionMap);
        Test.stopTest();

        System.assertEquals(true, result);
        System.assertEquals(true, outputMap.containsKey('status'));

        Order updatedOrder = [
            SELECT inwib2c_DetailMotif__c, vlocity_cmt__OrderStatus__c, inwiB2C_Statut__c, inwib2c_MotifAnnulation__c
            FROM Order
            WHERE Id = :testOrder.Id
        ];
        System.assertEquals('Annulation dégroupage', updatedOrder.inwib2c_DetailMotif__c);
        System.assertEquals('Cancelled', updatedOrder.vlocity_cmt__OrderStatus__c);
        System.assertEquals('inwiB2C_Annulee', updatedOrder.inwiB2C_Statut__c);
        System.assertEquals('inwib2c_AutreMotif', updatedOrder.inwib2c_MotifAnnulation__c);

        vlocity_cmt__OrchestrationPlan__c updatedPlan = [
            SELECT vlocity_cmt__State__c FROM vlocity_cmt__OrchestrationPlan__c
            WHERE Id = :testPlan.Id
        ];
        System.assertEquals('Frozen', updatedPlan.vlocity_cmt__State__c);
    }

    // 2. Test d’un methodName incorrect
    @IsTest
    static void testInvokeMethod_InvalidMethodName() {
        Map<String,Object> inputMap = new Map<String,Object>{
            'orderId' => '001000000000001',
            'orchestrationPlanId' => 'a1B000000000002'
        };
        Map<String,Object> outputMap = new Map<String,Object>();
        Map<String,Object> optionMap = new Map<String,Object>();

        Test.startTest();
        Boolean result = InwiB2C_CancelOrderAndOrchestarionPlan.invokeMethod('InvalideNom', inputMap, outputMap, optionMap);
        Test.stopTest();

        System.assertEquals(true, result); 
        System.assertEquals(0, outputMap.size());
    }

    // 3. Test de cas d’exception → `catch` exécuté
    @IsTest
    static void testInvokeMethod_Exception() {
    Map<String,Object> inputMap = new Map<String,Object>{
        'orderId' => 'd8568562', 
        'orchestrationPlanId' => 'hejdcjnk4'
    };
    Map<String,Object> outputMap = new Map<String,Object>();
    Map<String,Object> optionMap = new Map<String,Object>();

    Test.startTest();
    Boolean result = InwiB2C_CancelOrderAndOrchestarionPlan.invokeMethod('CancelOrderAndOrchePlan', inputMap, outputMap, optionMap);
    Test.stopTest();

    System.assertEquals(false, result);
    System.assertEquals('ERROR', outputMap.get('status'));
   }

}