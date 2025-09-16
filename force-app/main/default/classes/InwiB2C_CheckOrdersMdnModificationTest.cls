@isTest 
public class InwiB2C_CheckOrdersMdnModificationTest {
      
        @isTest(seeAllData=true)
        Static void testMethodCheckOrders2()
        {
            
        Account testAccount  = new Account ();
        testAccount.Name = 'TestOxygeneParam';
        testAccount.AccountNumber = '123456';
        Insert testAccount;    
    
        vlocity_cmt__Subscription__c testSubscription = new vlocity_cmt__Subscription__c();
        testSubscription.vlocity_cmt__AccountId__c = testAccount.Id;
        testSubscription.Inwib2c_Num_ro_de_la_ligne__c = '212600000021';
        testSubscription.vlocity_cmt__SubscriptionNumber__c = 	'212600000021';
        Insert testSubscription;
           
          
        Map<String,Object> outMap = new  Map<String,Object>();
        Map<String,Object> options = new  Map<String,Object>();
        Map<String,Object> options1 = new  Map<String,Object>();
        Map<String,Object> options2 = new  Map<String,Object>();
        Map<String,Object> inputMap = new  Map<String,Object>();   
            
         options.put('SubscriptionId',testSubscription.id );
         options.put('typeNumero', 'Normal');
         options.put('CycledeFacturation', '01');
            
         options1.put('SubscriptionId',testSubscription.id );
         options1.put('typeNumero', 'Normal');
         options1.put('CycledeFacturation', '19');
            
         options2.put('SubscriptionId',testSubscription.id );
         options2.put('typeNumero', 'Gold');
         options2.put('CycledeFacturation', '01');
            

            
        InwiB2C_CheckOrdersMdnModification cls = new InwiB2C_CheckOrdersMdnModification(); 
            
        boolean result = cls.invokeMethod('CheckOrderBeforeMdnChange',inputMap, outMap, options);
        boolean result1 = cls.invokeMethod('CheckOrderBeforeMdnChange',inputMap, outMap, options1);
        boolean result2 = cls.invokeMethod('CheckOrderBeforeMdnChange',inputMap, outMap, options2);
    	}
    
}