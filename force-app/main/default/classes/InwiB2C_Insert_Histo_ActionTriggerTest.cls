@isTest
public class InwiB2C_Insert_Histo_ActionTriggerTest {

    @isTest(SeeAllData=true)
        public static void inwiB2C_UpdateInvoicSuspensionBatchTest() {
       
        Test.startTest();
            
          
             //Insert Subscription
        vlocity_cmt__Subscription__c Sub = new vlocity_cmt__Subscription__c(); 
        Sub.inwiB2C_Statut__c = 'InwiB2C_SuspendueFacturation';
        Sub.vlocity_cmt__SubscriptionNumber__c = '09i1M000000BIaRQAW';
        Sub.inwib2c_vip__c = false;
        Sub.inwiB2C_OptionIdentification__c = false;
        Sub.inwiB2C_managedInSF__c = true;
        Sub.InwiB2C_A_r_silier__c = false;
        Sub.Blacklist__c = false;
        insert Sub;
        // Insert Action
        INWIB2C_HIST_ACTION_LINE__c act1= new INWIB2C_HIST_ACTION_LINE__c(
        inwiB2C_SubscriptionId__c = Sub.Id,
        inwiB2C_TypeModification__c ='InwiB2C_suspensionDeFacturation'     
            );
        insert act1;
              List<INWIB2C_HIST_ACTION_LINE__c> ListActionsToInsert = new  List<INWIB2C_HIST_ACTION_LINE__c>();
            ListActionsToInsert.add(act1);
               /*   [ SELECT Id,inwiB2C_SubscriptionId__r.inwiB2C_Statut__c,inwiB2C_SubscriptionId__c,inwiB2C_TypeModification__c,createddate
          From INWIB2C_HIST_ACTION_LINE__c 
          Where inwiB2C_TypeModification__c = 'InwiB2C_suspensionDeFacturation'
          And inwiB2C_SubscriptionId__r.inwiB2C_Statut__c = 'InwiB2C_SuspendueFacturation' limit 1];*/
            
            INWIB2C_HIST_ACTION_LINE__c act = new INWIB2C_HIST_ACTION_LINE__c();
            
             InwiB2C_Insert_Histo_Action__e Action_Event = new InwiB2C_Insert_Histo_Action__e();
            for(INWIB2C_HIST_ACTION_LINE__c Action :ListActionsToInsert ){
            Action_Event.inwiB2C_SubscriptionId__c = Action.inwiB2C_SubscriptionId__c;
                }
            List<Database.SaveResult> results = EventBus.publish(new List<InwiB2C_Insert_Histo_Action__e>{Action_Event});
            
         Test.stopTest();
    }
}