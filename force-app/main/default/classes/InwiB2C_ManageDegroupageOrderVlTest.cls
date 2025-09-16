@isTest
public class InwiB2C_ManageDegroupageOrderVlTest {
   @isTest(SeeAllData=false)
    public static void cloneDemandeDegVLTest(){
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        order neworder = new Order (inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder;
        InwiB2C_Commande_de_degroupage__c commandeDeg = new InwiB2C_Commande_de_degroupage__c ();
        insert commandeDeg;

        INWIB2C_DEMANDE_DEGROUPAGE__c demandeDeg= new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_Commande_de_degroupage__c=commandeDeg.Id);
        insert demandeDeg;
        
        Map<String,Object> inputCloneDeg = new Map<String,Object>();
        inputCloneDeg.put('InwiB2C_Commande_de_degroupage__c',commandeDeg.id);
        inputCloneDeg.put('InwiB2C_Order__c',neworder.id);
        inputCloneDeg.put('InwiB2C_Statutdegroupage__c','REU');
        inputCloneDeg.put('InwiB2C_typeCommande__c','RS1');
        inputCloneDeg.put('InwiB2C_CodeMotifRejet__c','motif');
        inputCloneDeg.put('InwiB2C_NouvelleTechnologie__c','VULA');
        inputCloneDeg.put('InwiB2C_Motif__c','RS1');
        inputCloneDeg.put('InwiB2C_MotifAnnulation__c','CNN');
        inputCloneDeg.put('InwiB2C_Commentaire__c','REU');
        inputCloneDeg.put('InwiB2C_numeroContact__c','RS1');
        inputCloneDeg.put('InwiB2C_codeRoutage__c','E2101');
        inputCloneDeg.put('InwiB2C_ADRESSE__c','REU');
        inputCloneDeg.put('InwiB2C_AdresseIAMProposee__c','RS1');
        inputCloneDeg.put('InwiB2C_BAT__c','motif');
        inputCloneDeg.put('InwiB2C_CCOM__c','REU');
        inputCloneDeg.put('InwiB2C_CQUARTIER__c','RS1');
        inputCloneDeg.put('InwiB2C_CVOIE__c','motif');
        inputCloneDeg.put('InwiB2C_ESC__c','REU');
        inputCloneDeg.put('InwiB2C_ETAGE__c','RS1');
        inputCloneDeg.put('InwiB2C_NVOIE__c','E2101');
        inputCloneDeg.put('InwiB2C_PORTE__c','REU');
        inputCloneDeg.put('InwiB2C_Technologie__c','VULA');
        inputCloneDeg.put('type','VULA');
		inputCloneDeg.put('newCommande','true');
        
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        InwiB2C_ManageDegroupageOrderVl.invokeMethod('cloneDemandeDeg',inputCloneDeg,output,options);
        InwiB2C_ManageDegroupageOrderVl.invokeMethod('createNewDegroupageOrder',inputCloneDeg,output,options);
        
    }

}