global with sharing class InwiB2C_InvokeCreateDemandeFlow implements vlocity_cmt.VlocityOpenInterface2 {
    global static boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        
         Boolean result = true;    
        try{
            if(methodName.equals('invokeFlow')){
                invokeFlow(input, output, options);                                                      
            }     
        } catch(Exception e){
                       
            result = false;
                    
        }     
        return result;            
   }
    public static void invokeFlow(Map<String, Object> input,Map<String,Object> output, Map<String,Object> options){
        
        Flow.Interview.InwiB2C_Update_Demande_degroupage updateDemande = new Flow.Interview.InwiB2C_Update_Demande_degroupage(input);
		updateDemande.start();
        
    }

}