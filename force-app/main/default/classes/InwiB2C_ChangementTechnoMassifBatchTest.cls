@isTest
public class InwiB2C_ChangementTechnoMassifBatchTest {
    @isTest(SeeAllData=false)
    public static void executeBatch(){
        vlocity_cmt__Subscription__c sub = new vlocity_cmt__Subscription__c(vlocity_cmt__SubscriptionNumber__c='test123');
        insert sub;
        InwiB2C_Commande_de_degroupage__c commandeDeg = new InwiB2C_Commande_de_degroupage__c();
        insert commandeDeg;
        INWIB2C_DEMANDE_DEGROUPAGE__c demande = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_Commande_de_degroupage__c=commandeDeg.id,InwiB2C_StatutLigneIam__c='LI');
        insert demande;
        InwiB2C_Sequence_Order_Number__c seq = new InwiB2C_Sequence_Order_Number__c(InwiB2C_typePrestation__c='BTLI',InwiB2C_Debit__c='20 Mb/s',InwiB2C_qualiteService__c='P0P1',InwiB2C_statut_ligne__c='LI',InwiB2C_Technologie__c='BITSTREAM');
        insert seq;
        InwiB2C_Changement_de_techno_en_masse__c e = new InwiB2C_Changement_de_techno_en_masse__c(InwiB2C_Technologie_Cible__c='Bitstream',InwiB2C_Technologie_source__c='VULA',
                                                                                                  InwiB2C_Statut__c = 'Submitted',InwiB2C_Ancien_Demande_degroupage__c=demande.Id,
                                                                                                 InwiB2C_Subscription__c=sub.Id);
        insert e;
        Test.startTest();
        InwiB2C_ChangementTechnoMassifBatch ba= new InwiB2C_ChangementTechnoMassifBatch();
        Id jobid= Database.executeBatch(ba,5);
        Test.stopTest();
    }
}