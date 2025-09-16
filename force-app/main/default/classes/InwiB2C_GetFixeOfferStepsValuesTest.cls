@isTest
public class InwiB2C_GetFixeOfferStepsValuesTest {
   static testMethod void getStetpsTest(){
        InwiB2C_Fixe_Order_step__c step1=new InwiB2C_Fixe_Order_step__c(InwiB2C_Code_Step__c='1',InwiB2C_statut__c='tes1',InwiB2C_Step__c='test1',InwiB2C_Type_offre__c='ADSL');
        insert step1;
        InwiB2C_Fixe_Order_step__c step2=new InwiB2C_Fixe_Order_step__c(InwiB2C_Code_Step__c='2',InwiB2C_statut__c='tes1,test2',InwiB2C_Step__c='test1',InwiB2C_hasCondition__c=true,InwiB2C_variableName__c='isExistingND',InwiB2C_Operator__c='==',InwiB2C_Conditon__c='true',InwiB2C_Type_offre__c='ADSL');
        insert step2;
        InwiB2C_Fixe_Order_step__c step3=new InwiB2C_Fixe_Order_step__c(InwiB2C_Code_Step__c='3',InwiB2C_statut__c='tes1,,{X}',InwiB2C_Step__c='test1',InwiB2C_hasVariable__c=true,InwiB2C_variableName__c='isExistingND',InwiB2C_Type_offre__c='ADSL');
        insert step3;
        InwiB2C_Fixe_Order_step__c step4=new InwiB2C_Fixe_Order_step__c(InwiB2C_Code_Step__c='4',InwiB2C_statut__c='tes1,,{X}',InwiB2C_Step__c='test1',InwiB2C_hasVariable__c=true,InwiB2C_variableName__c='isExistingND',InwiB2C_Type_de_Parcours__c='LastMile',InwiB2C_Type_offre__c='ADSL');
        insert step4;
        InwiB2C_Fixe_Order_step__c step5=new InwiB2C_Fixe_Order_step__c(InwiB2C_Code_Step__c='5',InwiB2C_statut__c='tes1',InwiB2C_Step__c='test1',InwiB2C_hasVariable__c=false,InwiB2C_Type_de_Parcours__c='RollBack',InwiB2C_Type_offre__c='ADSL');
        insert step5;
        
        InwiB2C_Fixe_Order_step__c subStep1=new InwiB2C_Fixe_Order_step__c(InwiB2C_Code_Step__c='3A',InwiB2C_Parent_step__c='3',InwiB2C_statut__c='tes1',InwiB2C_Step__c='test1');
        insert subStep1;
        InwiB2C_Fixe_Order_step__c subStep2=new InwiB2C_Fixe_Order_step__c(InwiB2C_Code_Step__c='3B',InwiB2C_Parent_step__c='3',InwiB2C_statut__c='tes1,test2',InwiB2C_Step__c='test1',InwiB2C_hasCondition__c=true,InwiB2C_variableName__c='isExistingND',InwiB2C_Operator__c='==',InwiB2C_Conditon__c='true',InwiB2C_Type_offre__c='ADSL');
        insert subStep2;
        InwiB2C_Fixe_Order_step__c subStep3=new InwiB2C_Fixe_Order_step__c(InwiB2C_Code_Step__c='3C',InwiB2C_Parent_step__c='3',InwiB2C_statut__c='tes1,{X}',InwiB2C_Step__c='test1',InwiB2C_hasVariable__c=true,InwiB2C_variableName__c='isExistingND',InwiB2C_Type_offre__c='ADSL');
        insert subStep3;
        InwiB2C_Fixe_Order_step__c subStep4=new InwiB2C_Fixe_Order_step__c(InwiB2C_Code_Step__c='1A',InwiB2C_Parent_step__c='1',InwiB2C_statut__c='tes1,{X}',InwiB2C_Step__c='test1',InwiB2C_hasVariable__c=true,InwiB2C_variableName__c='isExistingND',InwiB2C_Type_offre__c='ADSL');
        insert subStep4;
        
        
        
        
        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                         Family = 'Hardware',
                                         ProductCode='INWIB2C_OFFERING_SIM',vlocity_cmt__Type__c= 'ADSL');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
            
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = prod.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;
            
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prod.Id,
        UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        order neworder = new Order (Pricebook2Id = customPB.Id, inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id,inwiB2C_Canal__c='Point de vente');
        insert neworder;
        
        OrderItem newOrderitem = new OrderItem(vlocity_cmt__Action__c = 'Add', vlocity_cmt__Product2Id__c = prod.Id, PriceBookEntryId=customPrice.Id, OrderId=neworder.Id, Quantity=1, UnitPrice=customPrice.UnitPrice, ServiceDate=Date.Today());
        insert newOrderitem;
        
       
    	String jsonString='{"orderId":"'+neworder.Id+'","steps":{"canal":"EMAIL","cdcEmail":"dd@inwi.ma","changeEvents":[{"changeEvent":{"eventOccursTime":"2024-10-04 10:00:00.0","sequenceId":1,"workfLowStep":"EVENT_4"}},{"changeEvent":{"eventOccursTime":"2024-11-04 10:00:00.0","sequenceId":3,"subEvents":[{"subEvent":{"eventOccursTime":"2023-10-05 10:05:00.0","sequenceId":8,"workflowStep":"SUB_EVENT_2B"}},{"subEvent":{"eventOccursTime":"2024-10-04 10:05:00.0","sequenceId":2,"workflowStep":"SUB_EVENT_2A"}},{"subEvent":{"eventOccursTime":"2024-11-05 10:10:00.0","sequenceId":9,"workflowStep":"SUB_EVENT_2C"}}],"workfLowStep":"EVENT_2"}}],"clientLastName":"Doe","clientfirstName":"John","contactPhone":"212654344466","crcEmail":"ddd@inwi.ma","customerAddressL1":"123 Main St","customerAddressL2":"Apt 1","d2dEmail":"ddc@inwi.ma","deadlineNotification":"5","installationDate":"2023-10-04 10:00:00.0","isExistingND":"true","nd":"ND12345","offerCode":"ADSL_B2C","orderExternalId":"ABC123","orderId":"80126000008mEYCAA3","orderType":"LASTMILE","returnDeadline":"2022-12-31 00:00:00.0","timeSlot":"AM","topINS":"INS12345"}}';        
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
    	Map<String,Object> output = new Map<String,Object>();
    	Map<String,Object> options = new Map<String,Object>();
        InwiB2C_GetFixeOfferStepsValues.invokeMethod('getSteps',input,output,options);
        
        String jsonString2='{"orderId":"'+neworder.Id+'","steps":{"canal":"EMAIL","cdcEmail":"dd@inwi.ma","changeEvents":[{"changeEvent":{"eventOccursTime":"2024-10-04 10:00:00.0","sequenceId":1,"subEvents":[{"subEvent":{"eventOccursTime":"2023-10-05 10:05:00.0","sequenceId":8,"workflowStep":"SUB_EVENT_4B"}},{"subEvent":{"eventOccursTime":"2024-10-04 10:05:00.0","sequenceId":2,"workflowStep":"SUB_EVENT_4A"}},{"subEvent":{"eventOccursTime":"2024-11-05 10:10:00.0","sequenceId":9,"workflowStep":"SUB_EVENT_4C"}},{"subEvent":{"eventOccursTime":"2024-10-04 10:05:00.0","sequenceId":2,"workflowStep":"SUB_EVENT_4A"}},{"subEvent":{"eventOccursTime":"2024-11-05 10:10:00.0","sequenceId":12,"workflowStep":"SUB_EVENT_3F"}}],"workfLowStep":"EVENT_1"}},{"changeEvent":{"eventOccursTime":"2024-11-04 10:00:00.0","sequenceId":3,"workfLowStep":"EVENT_4"}}],"clientLastName":"Doe","clientfirstName":"John","contactPhone":"212654344466","crcEmail":"ddd@inwi.ma","customerAddressL1":"123 Main St","customerAddressL2":"Apt 1","d2dEmail":"ddc@inwi.ma","deadlineNotification":"5","installationDate":"2023-10-04 10:00:00.0","isExistingND":"true","nd":"ND12345","offerCode":"ADSL_B2C","orderExternalId":"ABC123","orderId":"80126000008mEYCAA3","orderType":"Rollback ADSL vers IDAR","returnDeadline":"2022-12-31 00:00:00.0","timeSlot":"AM","topINS":"INS12345"}}';
        Map<String, Object> input2 = (Map<String, Object>)JSON.deserializeUntyped(jsonString2);
    	Map<String,Object> output2 = new Map<String,Object>();
    	Map<String,Object> options2 = new Map<String,Object>();
        InwiB2C_GetFixeOfferStepsValues.invokeMethod('getSteps',input2,output2,options2);
               
        String jsonString3='{"orderId":"'+neworder.Id+'","steps":{"canal":"EMAIL","cdcEmail":"dd@inwi.ma","changeEvents":[{"changeEvent":{"eventOccursTime":"2024-10-04 10:00:00.0","sequenceId":1,"workfLowStep":"EVENT_1"}},{"changeEvent":{"eventOccursTime":"2024-11-04 10:00:00.0","sequenceId":3,"workfLowStep":"EVENT_2"}},{"changeEvent":{"eventOccursTime":"2024-11-04 10:00:00.0","sequenceId":3,"workfLowStep":"EVENT_3","subEvents":[{"subEvent":{"eventOccursTime":"2023-10-05 10:05:00.0","sequenceId":8,"workflowStep":"SUB_EVENT_3B"}},{"subEvent":{"eventOccursTime":"2024-10-04 10:05:00.0","sequenceId":2,"workflowStep":"SUB_EVENT_3B"}},{"subEvent":{"eventOccursTime":"2024-11-05 10:10:00.0","sequenceId":9,"workflowStep":"SUB_EVENT_3C"}}]}}],"clientLastName":"Doe","clientfirstName":"John","contactPhone":"212654344466","crcEmail":"ddd@inwi.ma","customerAddressL1":"123 Main St","customerAddressL2":"Apt 1","d2dEmail":"ddc@inwi.ma","deadlineNotification":"5","installationDate":"2023-10-04 10:00:00.0","isExistingND":"true","nd":"ND12345","offerCode":"ADSL_B2C","orderExternalId":"ABC123","orderId":"80126000008mEYCAA3","orderType":"","returnDeadline":"2022-12-31 00:00:00.0","timeSlot":"AM","topINS":"INS12345"}}';
        Map<String, Object> input3 = (Map<String, Object>)JSON.deserializeUntyped(jsonString3);
    	Map<String,Object> output3 = new Map<String,Object>();
    	Map<String,Object> options3 = new Map<String,Object>();
        InwiB2C_GetFixeOfferStepsValues.invokeMethod('getSteps',input3,output3,options3);
        
        
    }
    
    static testMethod void getOrderTest(){
         List<String> ordredEvents = InwiB2C_GetFixeOfferStepsValues.getOrder('LastMile','FTTH');
    }
    
    static testMethod void getEventIndexTest(){
         Integer index = InwiB2C_GetFixeOfferStepsValues.getEventIndex('LastMile','FTTH','2');
    }

}