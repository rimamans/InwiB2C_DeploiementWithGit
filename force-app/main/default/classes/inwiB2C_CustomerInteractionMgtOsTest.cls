@isTest
public  class inwiB2C_CustomerInteractionMgtOsTest {

    @isTest(SeeAllData=true)
    public static void  customerinteractionTest() {

        
        Map<String,Object> outMap = new  Map<String,Object>();
        Map<String,Object> options = new  Map<String,Object>();
        Map<String,Object> input = new  Map<String,Object>();

        Account testAccount  = new Account ();
        testAccount.Name = 'TestOxygeneParam';
        testAccount.AccountNumber = '123456';
        Insert testAccount;

		input.put('ctiIteractionNumber', 'test');
        input.put('ctiSource', null);
        input.put('ctiEmailSource', null);
        input.put('ctiFacebookId', 'test');
        input.put('ctiTwitterId', 'test');
        input.put('accountid', testAccount.Id );
        input.put('contactId', null);
        input.put('unhandledCall', null);
        input.put('transferedCall', null);
        input.put('status', null);


   inwiB2C_CustomerInteractionMgtOS cls = new inwiB2C_CustomerInteractionMgtOS(); 
   
    boolean result = cls.invokeMethod('createInteraction',input, outMap, options);
    System.assertEquals(true, result);
     
    }
    
        @isTest(SeeAllData=true)
    public static void  UpdateinteractionTest() {
        
        Map<String,Object> outm = new  Map<String,Object>();
        Map<String,Object> opts = new  Map<String,Object>();
        Map<String,Object> inputmap = new  Map<String,Object>();
        

        inputmap.put('unhandledCall', 'inwiB2C_Plaisantin');
        inputmap.put('transferedCall', 'inwiB2C_Savedesk');
        
        vlocity_cmt__CustomerInteraction__c CustomerInteractionTest = new vlocity_cmt__CustomerInteraction__c();
        
        CustomerInteractionTest.inwiB2C_CTI_MDN__c = '2123423423423';
        
        insert CustomerInteractionTest;
        
        
        
        
        //vlocity_cmt__CustomerInteraction__c  CustomerInteractionTest = [SELECT inwiB2C_CTI_Media__c,Id, inwiB2C_CTI_MDN__c, inwiB2C_SourceEmail__c, inwiB2C_CTIInteractionId__c, inwiB2C_FacebookId__c, inwiB2C_TwitterId__c from vlocity_cmt__CustomerInteraction__c limit 1];
   
        inputmap.put('vlocityInteractionId', CustomerInteractionTest.Id);
        
        inwiB2C_CustomerInteractionMgtOS cls = new inwiB2C_CustomerInteractionMgtOS(); 
        boolean result = cls.invokeMethod('updateInteraction',inputmap, outm, opts);
        System.assertEquals(true, result);
        
        vlocity_cmt__CustomerInteraction__c  updatedInteraction = [SELECT inwiB2C_unhandledCall__c ,  inwiB2C_TransferedCall__c  from vlocity_cmt__CustomerInteraction__c where ID = :CustomerInteractionTest.Id];
        System.assertEquals('inwiB2C_Plaisantin', updatedInteraction.inwiB2C_unhandledCall__c);
        System.assertEquals('inwiB2C_Savedesk', updatedInteraction.inwiB2C_TransferedCall__c);
        
        
    
    }
}