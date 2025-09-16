global with sharing  class InwiB2C_CanalLabels implements vlocity_cmt.VlocityOpenInterface {
//BeGIN RMA 20/12/2021

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
            
        Boolean result = true;
            
        try{
            
            if(methodName.equals('labelCanal')){
                labelCanal(inputMap, outMap, options);
            
             // your implementation, use outMap to send response back to OmniScript                                                                  
            
            }
          
        } catch(Exception e){
                       
            result = false;
                    
        }
             
        return result;
                  
   }


    public static void labelCanal(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

       

        Map<String, String> CanalLabels = new Map<String, String>();

        
         for (PickListEntry pe : Order.InwiB2C_Canal__c.getDescribe().getPicklistValues()) {
          CanalLabels.put(pe.getValue(), pe.getLabel());

        }
        
     
       

        List <Map<String, Object>> subList = (List <Map<String, Object>>) inputMap.get('List');
       

        for (Map<String, Object> Item: subList) {
            system.debug('aaaaa');

            //récupération de la valeur du champ Statut
            String canalCode = (String) Item.get ('Canal');
            // récupération du label du champ statut sur base de la valeur en entrée
            String canalLabel = CanalLabels.get(canalCode);
            // Ajour d'un champ StatutLabel au DR
            Item.put('canalLabel', canalLabel);

           
          
        }


        outMap.put('List',subList );



// END RMA 22/12/2021



    }


        




  


}