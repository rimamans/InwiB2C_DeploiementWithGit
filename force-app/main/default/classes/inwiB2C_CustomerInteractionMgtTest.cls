@isTest
public  class inwiB2C_CustomerInteractionMgtTest {

    @isTest
    public static void  customerinteractionTest() {

        Account account= new Account();
        Contact contact = new Contact();

        contact.FirstName = 'Test FirstName CTI';
        contact.LastName = 'Test LastName CTI';

        insert contact;

        account.name = 'Test Account';
        account.vlocity_cmt__PersonContactId__c = contact.id;

        insert account;

        
        Map<String , Object> ctiInput = new Map<String , Object>();

        ctiInput.put('ctiIteractionNumber', '123456789');

        Map<String , Object> data = new Map<String , Object>();


        data.put('ctiSource', 'inwiB2C_Appel_entrant');
        data.put('ctiEmailSource', null);
        data.put('ctiFacebookId', null);
        data.put('ctiTwitterId', null);
        data.put('ctiMDN', '212542345234');

        ctiInput.put('data', data);




        String interactionId = inwiB2C_CustomerInteractionMgt.createCustomerInteraction(account.id, ctiInput);

        vlocity_cmt__CustomerInteraction__c interaction = [SELECT inwiB2C_CTI_Media__c, inwiB2C_CTI_MDN__c, inwiB2C_SourceEmail__c, inwiB2C_CTIInteractionId__c, inwiB2C_FacebookId__c, inwiB2C_TwitterId__c from vlocity_cmt__CustomerInteraction__c where Id = : interactionId];

        if (interaction != null){
            System.assertEquals(interaction.inwiB2C_CTI_Media__c, 'inwiB2C_Appel_entrant');
            System.assertEquals(interaction.inwiB2C_CTIInteractionId__c, '123456789');
            System.assertEquals(interaction.inwiB2C_CTI_MDN__c, '212542345234');

        }
        
       String transferedCall = 'inwiB2C_Savedesk'; 
       String unhandledCall = 'inwiB2C_Plaisantin';
        
       vlocity_cmt__CustomerInteraction__c  CustomerInteractionTest = [SELECT vlocity_cmt__Status__c, inwiB2C_CTI_Media__c, inwiB2C_CTI_MDN__c, inwiB2C_SourceEmail__c, inwiB2C_CTIInteractionId__c, inwiB2C_FacebookId__c, inwiB2C_TwitterId__c from vlocity_cmt__CustomerInteraction__c limit 1];
       inwiB2C_CustomerInteractionMgt.updateCustomerInteraction(CustomerInteractionTest.id,unhandledCall, transferedCall);
        
       vlocity_cmt__CustomerInteraction__c  CustomerInteractionTest2 = [SELECT vlocity_cmt__Status__c,inwiB2C_unhandledCall__c , inwiB2C_TransferedCall__c   from vlocity_cmt__CustomerInteraction__c where Id = :CustomerInteractionTest.id];
        
		System.assertEquals(CustomerInteractionTest2.vlocity_cmt__Status__c, 'Completed');
        System.assertEquals(CustomerInteractionTest2.inwiB2C_unhandledCall__c, 'inwiB2C_Plaisantin');
        System.assertEquals(CustomerInteractionTest2.inwiB2C_TransferedCall__c, 'inwiB2C_Savedesk');

    }
}