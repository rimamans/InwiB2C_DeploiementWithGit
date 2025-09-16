@isTest
public class INWIB2C_CancelDRTriggerTest {

    @isTest
    public static void CancelDemandeResiliationTest() {
        //Test.startTest();

        InwiB2C_Demande_de_resiliation__c demande = new InwiB2C_Demande_de_resiliation__c();

        INWIB2C_CancelDemandeResiliation__e  cancelDemandeResiliation = new INWIB2C_CancelDemandeResiliation__e ();
        cancelDemandeResiliation.idrequesttocancel__c = demande.id;
        cancelDemandeResiliation.motifcancel__c ='AnnulationTestt';
        Test.startTest();
        EventBus.publish(cancelDemandeResiliation);
        Test.stopTest();
       /* Map<String, Object> DRinputs = new Map<String, Object>();
        Map<String, Object> DRoutput = new Map<String, Object>(); 
        Map<String, Object> DRoptions = new Map<String, Object>();

        DRinputs.put('idrequesttocancel', demande.id);
        DRinputs.put('motifcancel', 'AnnulationTestt');*/
        



        //List <Database.SaveResult> sresult = cancelDemandeResiliation.publish( DRinputs, DRoutput, DRoptions);
       //Boolean result = cancelDemandeResiliation.Publish('CancelDemandeResiliationTest', DRinputs, DRoutput, DRoptions);
       
        //Test.stopTest();
        }
}