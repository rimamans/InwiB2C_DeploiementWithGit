/** 
 * description: classe apex pour le parcours inwiB2C_RecyclageCommandeFTTH pour la recherche des demandes avec gestion d'affichage des boutons ( recycler/ annuler)
 * author : slimani rosa 
 * last modify by : Khaoula kanboua  10/02/2025
 
*/
/*SL-R begin */
global class inwiB2C_StatutLigneDemandeRecycl implements vlocity_cmt.VlocityOpenInterface {
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> optionsMap) {
       
        Boolean result = true;

        try{
            if (methodName.equals('getStatutDemande')) {
                getStatutDemande(inputMap,outputMap,optionsMap);
                System.debug('result' + outputMap);
            } 
            if (methodName == 'getMotif')
        {
            List<Object> arguments = (List<Object>)inputMap.get('arguments');
            outputMap.put('result', getMotif(arguments));
        }
        if (methodName.equals('getMotifEchec')) {
            getMotifEchec(inputMap,outputMap,optionsMap);
            System.debug('result' + outputMap);
        } 
       
        }
        catch (Exception e){
            result = false;
        }
          
        return result;
    } 

    
    //Récupère les valeurs de picklist pour le champ InwiB2C_Statut__c et les ajoute dans la map de sortie sous forme de liste

    public static void getStatutDemande(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap) {
        List<String> statutList = new List<String>();

        // Récupère les données du champ de InwiB2C_Statut__c'
        Schema.DescribeFieldResult StatLabel = InwiB2C_Demande_de_recyclage_FTTH__c.InwiB2C_Statut__c.getDescribe();
       List<Schema.PicklistEntry>  Label= StatLabel.getPicklistValues();
        // liste de maps contenant les labels et valeurs
       List <Map <String,String>> statut = new List <Map <String,String>> ();
     
       for (Schema.PicklistEntry stat : Label ){
           
           Map <String,String> statutMap  = new Map <String,String> ();
           statutMap.put('label', stat.getLabel());
           statutMap.put('value', stat.getLabel());
           statut.add(statutMap);
      }
      outputMap.put('statutList',statut) ;
        
     }
     

 /*SL-R end */



 /*KA-K begin */


   // Récupère les valeurs de picklist pour le champ 'InwiB2C_Motif_d_chec_de_raccordement__c' et les ajoute dans la map de sortie sous forme de liste
    public static Boolean getMotif(List<Object> arguments) {
    // Le motif est le premier élément de la liste des arguments
    if (arguments == null || arguments.isEmpty()) {
        // Si aucun argument n'est passé, retourner false
        return false; 
    }
   // Récupérer le motif depuis la liste des arguments
    String inputMotif = (String) arguments.get(0); 
    
    // Obtenir la liste des motifs valides depuis le picklist
    List<Map<String, String>> motifs = new List<Map<String, String>>();
    
    // Récupération des valeurs du picklist
    Schema.DescribeFieldResult MotifLabel = InwiB2C_Demande_de_recyclage_FTTH__c.InwiB2C_Motif_d_chec_de_raccordement__c.getDescribe();
    List<Schema.PicklistEntry> labelList = MotifLabel.getPicklistValues();

    // Remplir la liste des motifs
    for (Schema.PicklistEntry motif1 : labelList) {
        Map<String, String> motifMap = new Map<String, String>();
        motifMap.put('label', motif1.getLabel());
        motifMap.put('value', motif1.getValue());
        motifs.add(motifMap);
    }
    
    // Parcourir la liste des motifs pour vérifier si l'entrée existe dans le champ 'value' de l'une des maps
    for (Map<String, String> motifMap : motifs) {
        if (motifMap.get('value').equals(inputMotif)) {
            return true;
        }
    }

    return false; 
}

     /*KA-K end */

     /*recuperer la liste des motifs dans l'objet */
     public static void getMotifEchec(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap) {
        List<String> motifEchecList = new List<String>();

        // Récupère les données du champ de InwiB2C_Motif_d_chec_de_raccordement__c'
        Schema.DescribeFieldResult MotifEchecLabel = InwiB2C_Demande_de_recyclage_FTTH__c.InwiB2C_Motif_d_chec_de_raccordement__c.getDescribe();
       List<Schema.PicklistEntry>  label= MotifEchecLabel.getPicklistValues();
        // liste de maps contenant les labels et valeurs
       List <Map <String,String>> motifEchec = new List <Map <String,String>> ();
     
       for (Schema.PicklistEntry motif : label ){
           
           Map <String,String> motifEchecMap  = new Map <String,String> ();
           motifEchecMap.put('label', motif.getLabel());
           motifEchecMap.put('value', motif.getLabel());
           motifEchec.add(motifEchecMap);
      }
      outputMap.put('motifList',motifEchec) ;
        
     }
     

}