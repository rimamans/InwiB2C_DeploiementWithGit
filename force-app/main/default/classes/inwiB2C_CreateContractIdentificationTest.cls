@isTest
public class inwiB2C_CreateContractIdentificationTest {
 
   @isTest 
    static void testChangeAccountOfContract_OS() {

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
        
        inputMap.put('linkingInput',linkingInput);


        (new inwiB2C_CreateContractIdentification()).invokeMethod('changeAccountOfContract_OS',inputMap, outMap, options);

//        System.assertEquals('Normal', pri);
    }

    
    
    
    @isTest 
    static void testAttachmentsAssignment_OS() {

        Map<String,Object> outMap,options,inputMap= new  Map<String,Object>();


        Account acc1 = new Account(Name='old Account');
        insert acc1;
    
        Account acc2 = new Account(Name='new Account');
        insert acc2;

        Contract cont = new Contract(AccountId=acc1.Id);
        insert cont;
    
        Contract cont2 = new Contract(AccountId=acc2.Id);
        insert cont2;




        inputMap.put('idoldrecord',cont.Id);
		inputMap.put('idnewrecord',cont2.Id);
        
        inputMap.put('oldbrt','CONTRACT');
		inputMap.put('newbrt','CONTRACT');



        (new inwiB2C_CreateContractIdentification()).invokeMethod('attachmentsAssignment_OS',inputMap, outMap, options);

//        System.assertEquals('Normal', pri);
    }
}