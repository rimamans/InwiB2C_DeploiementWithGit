@isTest
public class inwiB2C_UpdateInvoicSuspensionBatchTest {
@isTest(SeeAllData=true)
        public static void inwiB2C_UpdateInvoicSuspensionBatchTest() {
       
        Test.startTest();
            //Insert Subscription
        vlocity_cmt__Subscription__c Sub = new vlocity_cmt__Subscription__c(); 
        Sub.inwiB2C_Statut__c = 'InwiB2C_SuspendueFacturation';
        Sub.vlocity_cmt__SubscriptionNumber__c = '02i1M000000BIaRQAW';
        Sub.inwib2c_vip__c = false;
        Sub.inwiB2C_OptionIdentification__c = false;
        Sub.inwiB2C_managedInSF__c = true;
        Sub.InwiB2C_A_r_silier__c = false;
        Sub.Blacklist__c = false;
        insert Sub;
            system.debug('Sub'+Sub.Id);
        // Insert Action
        INWIB2C_HIST_ACTION_LINE__c act= new INWIB2C_HIST_ACTION_LINE__c(
        inwiB2C_SubscriptionId__c = Sub.Id,
        inwiB2C_TypeModification__c ='InwiB2C_suspensionDeFacturation'
                
            );
            insert act;
              /*[ SELECT Id,inwiB2C_SubscriptionId__r.inwiB2C_Statut__c,inwiB2C_SubscriptionId__c,inwiB2C_TypeModification__c,createddate
          From INWIB2C_HIST_ACTION_LINE__c 
          Where inwiB2C_TypeModification__c = 'InwiB2C_suspensionDeFacturation'
          And inwiB2C_SubscriptionId__r.inwiB2C_Statut__c = 'InwiB2C_SuspendueFacturation' limit 1];*/
            
         Id bacthId2 = Database.executeBatch( new inwiB2C_UpdateInvoicingSuspensionBatch(0));
         Test.stopTest();
    }
}