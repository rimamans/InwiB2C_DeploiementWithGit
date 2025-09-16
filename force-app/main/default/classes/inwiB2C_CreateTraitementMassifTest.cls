@isTest
public class inwiB2C_CreateTraitementMassifTest {

      @isTest(SeeAllData=false)
     public static void applyTraitmentMassif()
    {
          Test.startTest();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> deserialized = new Map<String, Object>();
        
        //Insert Subscription
        vlocity_cmt__Subscription__c  subscription = new vlocity_cmt__Subscription__c ();
        subscription.Inwib2c_Num_ro_de_la_ligne__c = '212647859612';
        subscription.vlocity_cmt__SubscriptionNumber__c = '02i5M000000BIaRQAW';
        subscription.inwib2c_vip__c = false;
        subscription.inwiB2C_OptionIdentification__c = false;
        subscription.inwiB2C_managedInSF__c = true;
        subscription.InwiB2C_A_r_silier__c = false;
        subscription.Blacklist__c = false;
        subscription.InwiB2C_IMSI__c = '123456789';
        insert subscription;
        //Insrt Asset
        Asset asset = new Asset();
        asset.vlocity_cmt__SubscriptionId__c = subscription.Id;
        asset.Name = 'Internet sur Mobile';
        insert asset;
        // Insert INWIB2C_TRAITEMENTMASSIF_FICHIER__c
        INWIB2C_TRAITEMENTMASSIF_FICHIER__c T1 = new INWIB2C_TRAITEMENTMASSIF_FICHIER__c();
        T1.INWIB2C_MDN__c = '212647859612';
        T1.INWIB2C_STATUT__c = 'Upload';
        insert T1;
        // Add mdn to List
        String mdn= '212647859612';
        List<Object> listMDN = new List<Object>();
        Map<String, Object> mdnMAP = new Map<String, Object>();
        mdnMAP.put('mdn',mdn);
        listMDN.add(mdnMAP);
        deserialized.put('data', listMDN);
        deserialized.put('action', 'SUST');
        deserialized.put('motif', 'Usageindu');
        deserialized.put('origine', 'Fraude');
        input.put('mdnList', deserialized);
        
         new inwiB2C_CreateTraitementMassif().invokeMethod('applyTraitment',input, outMap, options);
        
        
        Test.stopTest();
    }
}