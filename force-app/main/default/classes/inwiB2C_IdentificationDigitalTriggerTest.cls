@isTest(SeeAllData=true)
public class inwiB2C_IdentificationDigitalTriggerTest {
 @isTest(SeeAllData = true)
    public static void inwiB2C_IdentificationDigitalTriggerTest(){
         Map<String,Object> outMap,options,inputMap= new  Map<String,Object>();
        Account acc1 = new Account(Name='old Account');
        insert acc1;
        Account acc2 = new Account(Name='new Account');
        insert acc2;
        Contract cont = new Contract(AccountId=acc1.Id);
        insert cont;
        vlocity_cmt__Subscription__c sub = new vlocity_cmt__Subscription__c(InwiB2C_Contract__c=cont.Id,vlocity_cmt__SubscriptionNumber__c='212678945612');
        insert sub;
		//Create and Insert Asset
            Asset asset1 = new Asset(
                Name = 'Test Asset',
                Status = 'Installed',
                AccountId = acc1.Id,
                InstallDate = System.Today(),
                
                UsageEndDate = System.Today(),
                vlocity_cmt__SubscriptionId__c  = sub.Id
                );
                insert asset1;
        InwiB2C_Subscription_contract__c subC = new InwiB2C_Subscription_contract__c(InwiB2C_Contract__c=cont.Id);
        insert subC;

        Map<String,Object> linkingInput = new  Map<String,Object>();


        linkingInput.put('idContract',cont.Id);
        linkingInput.put('idAccount',acc2.Id);
        
        
		List<inwiB2C_IdentificationDigitalMyInwi__e> eventItems = new List<inwiB2C_IdentificationDigitalMyInwi__e>();
        inwiB2C_IdentificationDigitalMyInwi__e  EventItem = new inwiB2C_IdentificationDigitalMyInwi__e (inwiB2C_step__c='IdentificationMyInwi',inwiB2C_AccountId__c=acc2.Id,inwb2c_idContract__c=cont.Id,inwiB2C_icc__c='123456789123456789',inwiB2C_idSubscription__c=sub.Id,inwiB2C_mdn__c='212678945612');
        eventItems.add(EventItem);
        inwiB2C_IdentificationDigitalMyInwi__e  EventItem2 = new inwiB2C_IdentificationDigitalMyInwi__e (inwiB2C_step__c='IdentificationAvecSIM',inwiB2C_AccountId__c=acc2.Id,inwb2c_idContract__c=cont.Id,inwiB2C_icc__c='123456789123456789',inwiB2C_idSubscription__c=sub.Id,inwiB2C_mdn__c='212678945612');
        eventItems.add(EventItem2);
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Database.SaveResult results2 = EventBus.publish(EventItem2);
        
      // Test.startTest();
      // 
         Test.stopTest();
        System.assertEquals(EventItem.inwiB2C_step__c, 'IdentificationMyInwi');
        System.assertEquals(EventItem2.inwiB2C_step__c, 'IdentificationAvecSIM');
        
    }
    
}