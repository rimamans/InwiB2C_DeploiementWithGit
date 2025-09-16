@isTest
public class inwiB2C_ExecuteTraitemeSwapEsimTrigrTest {
 public static testMethod void testExecuteSMO() {
      inwib2c_TraceDemandeEshop__c  trace = new inwib2c_TraceDemandeEshop__c ();
     		trace.InwiB2C_request_body__c= '{"CSOperationInfo":{"channel":"galaxie","user":"Amine bouremma test","uuid":"a6e40d9c-a371-448a-97af-dcf84c4beb4c"},"CSCreateSMO":{"ICC":"89876543234532","Motif":"SWAP_SIM_ESIM","actionType":"CHSIM","codeArticle":"23456373445","imsi":"987654","ki":"12345","mdn":"212648122284","ocsid":"234567","puk":"23454","submite":"N","typesim":"ESMD","waitpayment":"O"}}';  
            insert trace;
            

            
            InwiB2C_CreateSMOSwapEsimAsynchrone__e  EventItem = new InwiB2C_CreateSMOSwapEsimAsynchrone__e (InwiB2C_PanierId__c=trace.Id);
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
        
 }
}