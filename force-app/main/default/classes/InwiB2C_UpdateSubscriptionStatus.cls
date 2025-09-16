global class InwiB2C_UpdateSubscriptionStatus implements vlocity_cmt.VlocityOpenInterface {
    global boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        
        Boolean result = true;    
       try{
           
           if(methodName == 'updateStatus'){
              output.put('result',updateStatus(input));
           }     
       } catch(Exception e){
                      
           result = false;
                   
       }     
       return true;            
  }    
    Map<String, Object> updateStatus(Map<String, Object> input){
        Id actionid = (String) input.get('actionid');
        String action = (String) input.get('action');
        INWIB2C_HIST_ACTION_LINE__c subs = [Select inwiB2C_SubscriptionId__c,inwiB2C_STATUT__c from INWIB2C_HIST_ACTION_LINE__c where id=:actionid];
        vlocity_cmt__Subscription__c subscriptionToUpdate = 
        [SELECT Id,inwiB2C_LegacyStatus__c,inwiB2C_Statut__c FROM vlocity_cmt__Subscription__c 
         WHERE id=:subs.inwiB2C_SubscriptionId__c];
        if(action=='suspension'){
        // Update the status.
        subscriptionToUpdate.inwiB2C_Statut__c='InwiB2C_SuspendueFacturation';
        subscriptionToUpdate.inwiB2C_LegacyStatus__c='Suspendue facturation';
        }else{
        // Update the status.
            subscriptionToUpdate.inwiB2C_Statut__c='InwiB2C_Active';
            subscriptionToUpdate.inwiB2C_LegacyStatus__c='Active';
        }
        //update status of action!
        subs.inwiB2C_STATUT__c='OK';
        update  as system subs;

        // Make the update call.
        update as system subscriptionToUpdate; 
        return input;
    }
}