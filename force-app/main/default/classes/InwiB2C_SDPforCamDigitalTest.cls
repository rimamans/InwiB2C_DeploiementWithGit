/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class InwiB2C_SDPforCamDigitalTest {

    @isTest(SeeAllData=true)
    static void callSDPTest() {
        // makeup JDD
        InwiB2C_Demande_de_migration__c demande = new InwiB2C_Demande_de_migration__c(
            InwiB2C_Client__c='0013L00000Y63AYQAZ',
            InwiB2C_Compte_de_facturation__c='0013L00000Y6EPdQAN',
            InwiB2C_Canal__c='inwiB2C_MyInwi',
            InwiB2C_Offre__c='Forfait 30j 49dhs 1h+11GO+WA',
            InwiB2C_Nouveau_Profil__c='	86931',
            InwiB2C_Code_nouvel_offre__c='INWIB2C_OFFERING_CAM_FORFAIT30J49RS',
            InwiB2C_Nouvel_offre__c='Forfait FLEXI 49dh RS',
            InwiB2C_Souscription__c='a4k3L0000003ebEQAQ',
            InwiB2C_Profil__c='86932',
            InwiB2C_Mdn__c='212648114463',
            InwiB2C_Statut__c='InwiB2C_EnAttenteRetourSDP'
        );
        insert demande;
        // run tests
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        input.put('demandeId', demande.Id);
        InwiB2C_SDPforCamDigital.callSDP(input, output, options);
    }
}