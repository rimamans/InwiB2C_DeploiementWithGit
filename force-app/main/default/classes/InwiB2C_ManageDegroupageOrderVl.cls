global class InwiB2C_ManageDegroupageOrderVl implements vlocity_cmt.VlocityOpenInterface2 {
    global static boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        
         Boolean result = true;    
        try{
            if(methodName.equals('createNewDegroupageOrder'))
                CallcreateNewDegroupageOrder(input, output, options); 
            if(methodName.equals('cloneDemandeDeg'))
                CallcloneDemandeDeg(input, output, options); 
            
        } catch(Exception e){
                       
            result = false;
                    
        }     
        return result;            
   }
    public static void CallcreateNewDegroupageOrder(Map<String, Object> input,Map<String,Object> output, Map<String,Object> options){
        String orderId=input.get('orderId').toString();
        String typeComm=input.get('type').toString();
        InwiB2C_ManageDegroupageOrder.createNewDegroupageOrder(orderId,typeComm);
        
    }
     public static void CallcloneDemandeDeg(Map<String, Object> input,Map<String,Object> output, Map<String,Object> options){
       String commandeId= InwiB2C_ManageDegroupageOrder.cloneDemandeDeg(input);
         output.put('newCommandeDeg',commandeId);
        
    }
    

}