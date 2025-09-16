@isTest
public class inwiB2C_StatutLigneDemandeRecyclTest {

    @isTest
    static void testdemanderecyclage() {
        InwiB2C_Demande_de_recyclage_FTTH__c demande = new InwiB2C_Demande_de_recyclage_FTTH__c();
        demande.InwiB2C_ND__c = '123';
        demande.InwiB2C_work_order_Id__c = '198';
        demande.InwiB2C_Statut__c = 'recyclée';
        demande.InwiB2C_Motif_d_chec_de_raccordement__c = 'Hors plaque';

        insert demande;

        Test.startTest();
        
       
        Map<String, Object> inputMap = new Map<String, Object>(); 
        Map<String, Object> outputMap = new Map<String, Object>(); 
        Map<String, Object> optionsMap = new Map<String, Object>();
        
       String methodName = 'getStatutDemande'; 
        
        inwiB2C_StatutLigneDemandeRecycl invoker = new inwiB2C_StatutLigneDemandeRecycl();
        Boolean result = invoker.invokeMethod(methodName, inputMap, outputMap, optionsMap);

   
        List<Map<String, String>> statutList = (List<Map<String, String>>) outputMap.get('statutList');

          methodName = 'getMotif';
        inputMap.put('arguments', new List<Object>{demande.InwiB2C_Motif_d_chec_de_raccordement__c});
        result = invoker.invokeMethod(methodName, inputMap, outputMap, optionsMap);


        Boolean motifValid = (Boolean) outputMap.get('result');
        System.assert(motifValid, 'Le motif de raccordement doit être valide');
        
        methodName = 'getMotifEchec';
        result = invoker.invokeMethod(methodName, inputMap, outputMap, optionsMap);
        List<Map<String, String>> motifList = (List<Map<String, String>>) outputMap.get('motifList');

    }
}