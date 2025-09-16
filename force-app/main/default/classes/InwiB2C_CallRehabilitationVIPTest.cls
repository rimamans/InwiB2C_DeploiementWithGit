@isTest
public class InwiB2C_CallRehabilitationVIPTest {
@isTest(SeeAllData=true)
        public static void InwiB2C_CallRehabilitationVIPTest() {
       
        Test.startTest(); 
              //Insert Subscription
        vlocity_cmt__Subscription__c Sub = new vlocity_cmt__Subscription__c(); 
        Sub.inwiB2C_Statut__c = 'InwiB2C_SuspendueFacturation';
        Sub.vlocity_cmt__SubscriptionNumber__c = '02i7M000000BIaRQAW';
        Sub.inwib2c_vip__c = false;
        Sub.inwiB2C_OptionIdentification__c = false;
        Sub.inwiB2C_managedInSF__c = true;
        Sub.InwiB2C_A_r_silier__c = false;
        Sub.Blacklist__c = false;
        insert Sub;
            system.debug('Sub'+Sub.Id);
        // Insert Action
        INWIB2C_HIST_ACTION_LINE__c action= new INWIB2C_HIST_ACTION_LINE__c(
        inwiB2C_SubscriptionId__c = Sub.Id,
        inwiB2C_TypeModification__c ='InwiB2C_suspensionDeFacturation'
            );
            insert action;
             List<INWIB2C_HIST_ACTION_LINE__c> ListActionsToInsert = new  List<INWIB2C_HIST_ACTION_LINE__c>();
            ListActionsToInsert.add(action);
                 /*[ SELECT Id,inwiB2C_SubscriptionId__r.inwiB2C_Statut__c,inwiB2C_SubscriptionId__c,inwiB2C_TypeModification__c,createddate
          From INWIB2C_HIST_ACTION_LINE__c 
          Where inwiB2C_TypeModification__c = 'InwiB2C_suspensionDeFacturation'
          And inwiB2C_SubscriptionId__r.inwiB2C_Statut__c = 'InwiB2C_SuspendueFacturation' limit 1];*/
           
            List<String> Ids = new List <String>();   
            for(INWIB2C_HIST_ACTION_LINE__c act: ListActionsToInsert ){
                system.debug('inwiB2C_SubscriptionId__c'+act.inwiB2C_SubscriptionId__c);
                Ids.Add(act.inwiB2C_SubscriptionId__c);
            }
          
            InwiB2C_CallRehabilitationVIP.CallVIP(Ids);
            Test.stopTest();
    }
}