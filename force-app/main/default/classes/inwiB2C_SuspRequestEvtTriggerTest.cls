@isTest
public class inwiB2C_SuspRequestEvtTriggerTest {

       @isTest(SeeAllData=true)
        public static void inwiB2C_SuspRequestEvtTriggerTest() {
       
        Test.startTest();
            
          
             //Insert Subscription
        vlocity_cmt__Subscription__c Sub = new vlocity_cmt__Subscription__c(); 
        Sub.inwiB2C_Statut__c = 'InwiB2C_Active';
        Sub.vlocity_cmt__SubscriptionNumber__c = '09i1M000000BIaRQAW';
        Sub.inwib2c_vip__c = false;
        Sub.inwiB2C_OptionIdentification__c = false;
        Sub.inwiB2C_managedInSF__c = true;
        Sub.InwiB2C_A_r_silier__c = false;
        Sub.Blacklist__c = false;
        insert Sub;
        // Insert request
        InwiB2C_Demande_de_resiliation__c lstRequest= new InwiB2C_Demande_de_resiliation__c();            
            lstRequest.InwiB2C_Statut_Resil__c ='En attente de suspension';
            lstRequest.InwiB2C_Date_de_signature__c = Date.valueOf('2022-04-13');
            lstRequest.InwiB2C_Subscription__c = Sub.Id;            
            insert lstRequest;
              List<InwiB2C_Demande_de_resiliation__c> ListRequestToInsert = new  List<InwiB2C_Demande_de_resiliation__c>();
            ListRequestToInsert.add(lstRequest);
            
             inwiB2C_SuspRequestEvt__e Request_Event = new inwiB2C_SuspRequestEvt__e();
            for(InwiB2C_Demande_de_resiliation__c Req :ListRequestToInsert ){
            Request_Event.inwiB2C_requestId__c = Req.Id;
                }
            List<Database.SaveResult> results = EventBus.publish(new List<inwiB2C_SuspRequestEvt__e>{Request_Event});
            
         Test.stopTest();
    }
}