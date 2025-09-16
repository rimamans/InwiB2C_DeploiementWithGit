global  class InwiB2C_SharingDemandeRecyclageFTTH implements vlocity_cmt.VlocityOpenInterface2{
   
    global static boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> outputMap, Map<String,Object> optionsMap) {
        if (methodName.equals('searchDemandeRecyclage')) {
            outputMap.put('result', searchDemandeRecyclage(input, outputMap, optionsMap));
            System.debug('result' + outputMap);
        } 
          
        return true;
    }

    public static List<Object> searchDemandeRecyclage(Map<String,Object> input, Map<String,Object> outputMap, Map<String,Object> optionsMap){
        //Créer une Map pour stocker uniquement les valeurs non vides
        Map<String,Object> inputValide=new Map<String,Object>();

        //Parcourir toutes l'input pour vérifier si les valeurs ne sont pas vides
        for(String iter1 : input.keySet()){
            if(input.get(iter1)!=''){
                inputValide.put(iter1,input.get(iter1));
            }        
        }
        
        //construire la requête dynamique
        Integer size =inputValide.size();
        Integer i=0;
          // Initialisation de la requête SOQL de base
        String req='Select id,InwiB2C_client__c,InwiB2C_client__r.Name ,InwiB2C_client__r.Inwib2c_CIN__c,InwiB2C_commande__c,InwiB2C_commande__r.OrderNumber,InwiB2C_Statut__c, InwiB2C_Compteur_de_rep_chage__c,InwiB2C_Motif_d_chec_de_raccordement__c from InwiB2C_Demande_de_recyclage_FTTH__c where ';
       //Parcourir la Map d'entrées validées pour construire les conditions
        for(String iter2 : inputValide.keySet()){
            if(i== 0){
			 req = req+iter2+'= \''+inputValide.get(iter2)+'\'';
             i++;
             } 
             else{
                req = req+' and '+iter2+'= \''+inputValide.get(iter2)+'\'';
                i++;
             }    
         }	
            
        req = req+' and InwiB2C_Motif_d_chec_de_raccordement__c != null and InwiB2C_commande__r.InwiB2C_Type_Offer__c =\'FTTH\' limit 50 ';
        System.debug('Requête générée : ' + req);
        //return new List<Object>();
       
      //executer la requete
        List<InwiB2C_Demande_de_recyclage_FTTH__c> request = DataBase.query(req);
        List<Object> requestList = new List<Object>();
       
        if(!request.isEmpty()){
           //Construire une liste des objets pour l'affichage
           Map<String, Object> listobject = new Map<String,Object>();
          
          for(InwiB2C_Demande_de_recyclage_FTTH__c iter3 : request){
           //transformer le record en une map String/object
           listobject=(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(iter3));
           //construire un objet pour chaque record
           Map<String, Object> recordObject = new Map<String,Object>();
           //verifier l'affichage des boutons
           if(iter3.InwiB2C_Statut__c == 'A recycler'){
            recordObject.put('CancelDisabled',true);
            recordObject.put('ReycleDisabled',true); 
           }
           else{
            recordObject.put('ReycleDisabled',false);
            recordObject.put('CancelDisabled',false);
           }
              
           
           for(String iter4 :listobject.keySet()){
               
               recordObject.put(iter4,listobject.get(iter4));
                }
            //Ajouter l'objet a la liste retournée
            requestList.add(recordObject);
              System.debug('resultat ' + requestList );
            }
                
        }
        return requestList;
        //outputMap.put('liste', requestList);
       
        
    }

}