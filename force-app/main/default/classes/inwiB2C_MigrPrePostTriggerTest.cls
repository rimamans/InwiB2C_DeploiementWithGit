@isTest
private class inwiB2C_MigrPrePostTriggerTest {

    @isTest(SeeAllData=true)
    static void createOrderTest() {
        

        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

    
        String requestBody = '{"CSOperationInfo":{"channel":"test","user":"test","uuid":"test"},"CSCreateSMO":{"mdn":"212648117908","actionType":"PREPOST","submit":true,"waitPayment":true,"codeOffre":"INWIB2C_OFFERING_199DH_APL","billingAccount":"0013L00000bPrfpQAC"}}';


        inwib2c_TraceDemandeEshop__c panier = new inwib2c_TraceDemandeEshop__c(
            inwib2c_AccountId__c = testAccount.Id,
            inwib2c_Request_body__c = requestBody,
            InwiB2C_submite__c = true,
            InwiB2C_waitpayment__c = false
        );
        insert panier;

      
        inwiB2C_MigrPrePost__e createOrder = new inwiB2C_MigrPrePost__e(
            inwiB2C_panierId__c = panier.Id,
            inwiB2C_step__c = 'createOrder'
        );
        inwiB2C_MigrPrePost__e updateATT = new inwiB2C_MigrPrePost__e(
            inwiB2C_panierId__c = panier.Id,
            inwiB2C_step__c = 'updateAttributes'
        );
        inwiB2C_MigrPrePost__e addVolteEvt = new inwiB2C_MigrPrePost__e(
            inwiB2C_panierId__c = panier.Id,
            inwiB2C_step__c = 'addVolte'
        );

        Test.startTest();
        Database.SaveResult res1 = EventBus.publish(createOrder);
        Database.SaveResult res2 = EventBus.publish(updateATT);
        Database.SaveResult res3 = EventBus.publish(addVolteEvt);
        Test.stopTest();
        
       
        System.assertEquals('createOrder', createOrder.inwiB2C_step__c);
        System.assertEquals('updateAttributes', updateATT.inwiB2C_step__c);
        System.assertEquals('addVolte', addVolteEvt.inwiB2C_step__c);
    }
}