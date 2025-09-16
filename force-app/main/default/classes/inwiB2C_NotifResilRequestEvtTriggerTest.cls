@isTest
public class inwiB2C_NotifResilRequestEvtTriggerTest {
  public static testMethod void inwiB2C_NotifResilRequestEvtTriggerTest() {

        vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0712225555',Inwib2c_Num_ro_de_la_ligne__c='0177662233',Name='TESTKAB');
        Insert newSubsc;
        InwiB2C_Demande_de_resiliation__c newRequest= new InwiB2C_Demande_de_resiliation__c(InwiB2C_Subscription__c = newSubsc.Id,inwiB2C_num_Ligne__c = newSubsc.Inwib2c_Num_ro_de_la_ligne__c );  
        Insert newRequest;

        inwiB2C_NotifResilRequestEvt__e eventItem = new inwiB2C_NotifResilRequestEvt__e(inwiB2C_requestIdNotif__c=newRequest.Id,inwiB2C_subsIdNotif__c=newRequest.InwiB2C_Subscription__c,inwiB2C_numLigne__c=newRequest.inwiB2C_num_Ligne__c,inwiB2C_nbrofDays__c='7');     
 
      
        Test.startTest();
        Database.SaveResult results = EventBus.publish(eventItem);
        Test.stopTest();

    }
}