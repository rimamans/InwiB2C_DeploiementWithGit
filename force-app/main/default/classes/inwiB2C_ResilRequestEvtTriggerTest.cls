@isTest
public class inwiB2C_ResilRequestEvtTriggerTest {
  public static testMethod void inwiB2C_ResilRequestEvtTriggerTest() {

    vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0744245555',Inwib2c_Num_ro_de_la_ligne__c='0197765933',Name='TESTKAB');
        Insert newSubsc;
        InwiB2C_Demande_de_resiliation__c newRequest= new InwiB2C_Demande_de_resiliation__c(InwiB2C_Subscription__c = newSubsc.Id,inwiB2C_num_Ligne__c = newSubsc.Inwib2c_Num_ro_de_la_ligne__c );  
        Insert newRequest;
        inwiB2C_ResilRequestEvt__e eventItem = new inwiB2C_ResilRequestEvt__e(inwiB2C_requestId__c=newRequest.Id,inwiB2C_subsId__c=newRequest.InwiB2C_Subscription__c);          
        Test.startTest();
        Database.SaveResult results = EventBus.publish(eventItem);
        Test.stopTest();

    
}
}