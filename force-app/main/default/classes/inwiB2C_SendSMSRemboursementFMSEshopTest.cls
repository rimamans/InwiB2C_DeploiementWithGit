@isTest
public class inwiB2C_SendSMSRemboursementFMSEshopTest {
	@isTest
    static void testSendSMS() {

    Contact testContact = new Contact( FirstName = 'test' , LastName = 'test' , InwiB2C_Num_ro_de_contact__c = '212634567890');
    insert testContact;
    Account testAccount = new Account(Name = 'Test Account' , vlocity_cmt__PrimaryContactId__c = testContact.Id);
    insert testAccount;
         Order orderTest = new Order(
                inwiB2C_Statut__c = 'inwiB2C_Activation',
                EffectiveDate = Date.today().addDays(-1),
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
                Status = 'Draft',
                AccountId = testAccount.Id
            );

       insert orderTest;
        
       
       InwiB2C_Demande__c testDemandes = new InwiB2C_Demande__c();
       insert testDemandes;

       List<String> inputsList = new List<String>();
       String input = testAccount.InwiB2C_Num_ro_de_contact__c + ',inwi : Votre demande de remboursement d\'un montant de 0.00 dhs est en cours de traitement. Vous serez notifié une fois finalisée.,' + orderTest.Id + ','  + testAccount.Id;
       inputsList.add(input);
       Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock()); 
       inwiB2C_SendSMSRemboursementFMSEshop.SendSMS(inputsList);

    }
}