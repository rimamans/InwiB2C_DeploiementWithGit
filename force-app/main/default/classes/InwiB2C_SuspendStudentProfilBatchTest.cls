@isTest
public class InwiB2C_SuspendStudentProfilBatchTest {
	 @isTest(SeeAllData = false)
    public static void InwiB2C_SuspendStudentProfilBatchTest(){
        //create Contact
        Contact testContact = new Contact();
		testContact.FirstName=''; 
        testContact.LastName='Dummy'; 
        testContact.Inwib2c_CIN__c='I00000';
        Insert testContact;
        //Create Account
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
		testAccount.vlocity_cmt__PrimaryContactId__c=testContact.Id;   
        insert testAccount;
        vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223355',
                                                                                  Inwib2c_Num_ro_de_la_ligne__c='0611223355',
                                                                                  Name='TEST2',inwiB2C_LegacyStatus__c='ACTIVE',
                                                                                  inwiB2C_Statut__c='InwiB2C_Active',
                                                                                  vlocity_cmt__Status__c='Active',
                                                                                 Inwib2c_type_de_sim__c='GSM',
                                                                                 InwiB2C_IMSI__c='123456789',
                                                                                 vlocity_cmt__AccountId__c=testAccount.Id);
        Insert newSubsc;
        InwiB2C_MDNOffreEtudiant__c newMDNOffreEtudiant = new InwiB2C_MDNOffreEtudiant__c();
        newMDNOffreEtudiant.InwiB2C_Date_de_creation__c=Date.today().addDays(-30);
        newMDNOffreEtudiant.InwiB2C_Statut__c='InwiB2C_Nouveau';
        newMDNOffreEtudiant.InwiB2C_MDN__c='212611223355';
        newMDNOffreEtudiant.InwiB2C_SubscriptionId__c=newSubsc.Id;
        insert newMDNOffreEtudiant;


        Id bacthId = Database.executeBatch( new InwiB2C_SuspendStudentProfilBatch() , 10 );
        
    }
}