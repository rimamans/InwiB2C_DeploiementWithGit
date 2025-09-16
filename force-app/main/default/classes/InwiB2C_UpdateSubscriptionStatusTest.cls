@isTest
public class InwiB2C_UpdateSubscriptionStatusTest {
  @isTest(SeeAllData=true)
   	static void updatestatut()
{

    Account testAccount = new Account();
    testAccount.Name = 'TestPromo';
    insert testAccount;

    vlocity_cmt__Subscription__c newSubsc1 = new vlocity_cmt__Subscription__c(Inwib2c_Offre__c = 'offer1', vlocity_cmt__SubscriptionNumber__c = '212561948623', Inwib2c_Num_ro_de_la_ligne__c = '0611223344', Name = 'TEST', inwiB2C_LegacyStatus__c = 'ACTIVE', inwiB2C_Statut__c = 'InwiB2C_Active', vlocity_cmt__Status__c = 'Active', vlocity_cmt__AccountId__c = testAccount.Id);
    insert newSubsc1;

    INWIB2C_HIST_ACTION_LINE__c action= new INWIB2C_HIST_ACTION_LINE__c();
    action.inwiB2C_SubscriptionId__c = newSubsc1.Id;
    insert action;


    Map<String, Object> output = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> input = new Map<String, Object>();
    input.put('actionid',action.Id);
    input.put('action','suspension');
	InwiB2C_UpdateSubscriptionStatus cls= new InwiB2C_UpdateSubscriptionStatus();
	cls.invokeMethod('updateStatus',input,output,options);	
       

}
}