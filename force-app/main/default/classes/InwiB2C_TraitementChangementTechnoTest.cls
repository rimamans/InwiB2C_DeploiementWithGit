@isTest
public class InwiB2C_TraitementChangementTechnoTest {
 public static testMethod void testTrigger() {
        
       
        Account agence = new Account(Name='agence');
        insert agence;

        vlocity_cmt__Subscription__c testSubscription = new vlocity_cmt__Subscription__c(vlocity_cmt__SubscriptionNumber__c = '212648109644');
        insert testSubscription;
        

        INWIB2C_DEMANDE_DEGROUPAGE__c testDemande = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_NumeroDesignation__c='14',InwiB2C_Agence__c=agence.Id,InwiB2C_numeroContact__c='prenom',InwiB2C_Statutdegroupage__c='ACC',InwiB2C_dateOrdre__c=Date.today(),InwiB2C_DEGROUPAGE_NUM__c=70000016);
        insert testDemande; 

       
        InwiB2C_Traitement_changement_techno__e newEvent = new InwiB2C_Traitement_changement_techno__e(
            InwiB2C_subscriptionId__c = testSubscription.Id,
            InwiB2C_demandeId__c = testDemande.Id,
            InwiB2C_Type__c = 'Massif'
        );
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(newEvent);
        Test.stopTest();
 }
}