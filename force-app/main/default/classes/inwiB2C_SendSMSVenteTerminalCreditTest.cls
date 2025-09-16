@isTest
private class inwiB2C_SendSMSVenteTerminalCreditTest {

    @isTest
    static void testSendSMS() {

    Contact testContact = new Contact( FirstName = 'test' , LastName = 'test' , InwiB2C_Num_ro_de_contact__c = '21234567890');
    insert testContact;
    Account testAccount = new Account(Name = 'Test Account' , vlocity_cmt__PrimaryContactId__c = testContact.Id);
      insert testAccount;
         Order orderTest = new Order(
                inwiB2C_Statut__c = 'inwiB2C_Activation',
                EffectiveDate = Date.today().addDays(-1),
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
                Status = 'Draft',
                AccountId = testAccount.Id,
                inwiB2C_Num_dossier__c ='12345'
            );

       insert orderTest;

       List<String> orderIds = new List<String>();
       orderIds.add(orderTest.Id);
       Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock()); 
       inwiB2C_SendSMSVenteTerminalCredit.SendSMS(orderIds);

    }
}