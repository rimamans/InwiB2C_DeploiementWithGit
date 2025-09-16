global with sharing  class InwiB2C_BlackListMotif implements vlocity_cmt.VlocityOpenInterface {


    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
            
        Boolean result = true;
            
        try{
            
            if(methodName.equals('populateLabelsDR_Motif')){
                populateLabelsDR_Motif(inputMap, outMap, options);
            
             // your implementation, use outMap to send response back to OmniScript                                                                  
            
            }
           
        } catch(Exception e){
                       
            result = false;
                    
        }
             
        return result;
                  
   }


    public static void populateLabelsDR_Motif(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

       
        Map<String, String> MotifLabels = new Map<String, String>();


        // Récupération des labels de Statut de Case dans une Map
        for (PickListEntry pe : InwiB2C_BlackList__c.InwiB2C_Motif__c.getDescribe().getPicklistValues()) {
            MotifLabels.put(pe.getValue(), pe.getLabel());

        }
        
       
        //Récupération du contenu du chanmp caseAll
        Map<String,Object> BlackListAll = (Map<String,Object>) inputMap.get('BlackList');

        // Récupération du contenu du champ List
        List <Map<String, Object>> BlackList =  (List <Map<String, Object>>) BlackListAll.get('List');

        // parcours de la liste des Cases en input
        for (Map<String, Object> BlackItem: BlackList) {
            //récupération de la valeur du champ Statut
            String statutCode = (String) BlackItem.get ('Motif');

            // récupération du label du champ statut sur base de la valeur en entrée
            String MotifLabel = MotifLabels.get(statutCode);

            // Ajour d'un champ StatutLabel au Case
            BlackItem.put('MotifLabel', MotifLabel);



        }
        



        outMap.put('BlackListAll',BlackListAll);
        


    }


        




  


}