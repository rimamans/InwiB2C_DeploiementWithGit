@isTest
public class InwiB2C_getDemandesDegroupageTest {
    
        static testMethod void TransformJsonOSS()
{
    Account client = new Account(Name='client');
    insert client;
    Account agence = new Account(Name='agence');
    insert agence;
    Account site = new Account(Name='site');
    insert site;
    INWIB2C_DEMANDE_DEGROUPAGE__c demande = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_NumeroDesignation__c='14',InwiB2C_Agence__c=agence.Id,InwiB2C_numeroContact__c='prenom',InwiB2C_Statutdegroupage__c='ACC',InwiB2C_dateOrdre__c=Date.newInstance(2023, 04, 24),InwiB2C_DEGROUPAGE_NUM__c=70000016);
    insert demande;
    String jsonString = '{"startDate":"2023-03-01","endDate":"2023-04-26","InwiB2C_Agence__c":"0013L00000V69MAQAZ","InwiB2C_numeroContact__c":"prenom","InwiB2C_Statutdegroupage__c":"ACC","InwiB2C_StatutLigneIam__c":"LA","InwiB2C_Order__c":"8013L00000224QjQAI","InwiB2C_NumeroDesignation__c":"14","InwiB2C_LastName__c":"nom","InwiB2C_DEGROUPAGE_NUM__c":"70000016","InwiB2C_Account__c":"0013L00000V7EgDQAV","InwiB2C_dateOrdre__c":"2023-04-24"}';
    Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
    Map<String,Object> output = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    InwiB2C_getDemandesDegroupage.invokeMethod('getDemandes',input,output,options);
    String jsonString1 = '{"startDate":"2023-03-01"}';
    Map<String, Object> input1 = (Map<String, Object>)JSON.deserializeUntyped(jsonString1);
    InwiB2C_getDemandesDegroupage.invokeMethod('getDemandes',input1,output,options);
    String jsonString2 = '{"endDate":"2023-04-26"}';
    Map<String, Object> input2 = (Map<String, Object>)JSON.deserializeUntyped(jsonString2);
    InwiB2C_getDemandesDegroupage.invokeMethod('getDemandes',input2,output,options);
    String jsonString3 = '{"InwiB2C_DEGROUPAGE_NUM__c":"70000016"}';
    Map<String, Object> input3 = (Map<String, Object>)JSON.deserializeUntyped(jsonString3);
    InwiB2C_getDemandesDegroupage.invokeMethod('getDemandes',input3,output,options);


}

    }