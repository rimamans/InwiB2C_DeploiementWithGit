@isTest
public class InwiB2C_CallVocTest {
     @isTest
    static void testCallVIPOrder() {
          Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Order testOrder = new Order(
            inwiB2C_Statut__c = 'inwiB2C_Activee',
           // inwiB2C_TypeDeMigration__c = 'Migration Postpayé Postpayé',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert testOrder;
        testCallVIP('Order',  testOrder.Id); 
    }

    @isTest
    static void testCallVIPCase() {
        case testCase =new case(Type='Inwib2c_Reclamation',
                         Description='A',
                         Subject='B',
                         origin='C',
                         status ='Ouvert',
                         InwiB2C_TypeSpecialite__c='InwiB2C_Roaming',
                         Inwib2c_Cat_gorie__c='Inwib2c_Reseau_Reclamation');
        insert testCase;
        testCallVIP('Case', testCase.Id); 
    }

    @isTest
    static void testCallVIPResiliation() {
        vlocity_cmt__Subscription__c testSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0744245555',Inwib2c_Num_ro_de_la_ligne__c='0197765933',Name='TESTKAB');
        Insert testSubsc;
        InwiB2C_Demande_de_resiliation__c testRequest= new InwiB2C_Demande_de_resiliation__c(InwiB2C_Subscription__c = testSubsc.Id, inwiB2C_num_Ligne__c = testSubsc.Inwib2c_Num_ro_de_la_ligne__c );  
        Insert testRequest;
        testCallVIP('InwiB2C_Demande_de_resiliation__c', testRequest.Id); 
    }

    @isTest
    static void testCallVIPIdentification() {
		InwiB2C_Demande_IdentificationClient__c testRequest = new InwiB2C_Demande_IdentificationClient__c(InwiB2C_Nom__c='Test Name',InwiB2C_Prenom__c='test');
        insert testRequest;        
        testCallVIP('InwiB2C_Demande_IdentificationClient__c', testRequest.Id); 
    }

    @isTest
    static void testCallVIPAction() {
       INWIB2C_HIST_ACTION_LINE__c testAction = new INWIB2C_HIST_ACTION_LINE__c();
        insert testAction;
        testCallVIP('Action', testAction.Id); 
    }
    
    static void testCallVIP(String objectType, String objectId) {
        
        Test.startTest();
        InwiB2C_CallVoc.callVIP(new List<String>{objectType + ',' + objectId});
        Test.stopTest();
        

    }
}