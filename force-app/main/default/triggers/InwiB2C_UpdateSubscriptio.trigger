//BEGIN: RMA 22/03/2021
//MAJ if subscription update 

trigger InwiB2C_UpdateSubscriptio on vlocity_cmt__Subscription__c (after insert, after update, after delete){
    /*
//if insert new Subscription with flag VIP : insert in new tab SUbscriptionVIP
   if(Trigger.isInsert){
       List<InwiB2C_Subscription_VIP__c> SubVIP = new List<InwiB2C_Subscription_VIP__c>(); 
  //  for(vlocity_cmt__Subscription__c Sub : [SELECT Inwib2c_VIP__c,id,Name, vlocity_cmt__SubscriptionNumber__c,vlocity_cmt__AccountId__r.name FROM vlocity_cmt__Subscription__c  WHERE ID =: trigger.new  ]){

    for(vlocity_cmt__Subscription__c Sub : trigger.new){
                                        
    
    if (Sub.inwib2c_vip__c==true ){
        InwiB2C_Subscription_VIP__c Subricption = new InwiB2C_Subscription_VIP__c(Inwib2c_Num_ro_de_la_ligne__c = sub.Inwib2c_Num_ro_de_la_ligne__c,
                    Name=sub.name,
                    InwiB2C_Subscription_Number__c=sub.vlocity_cmt__SubscriptionNumber__c
                   //  InwiB2C_Account_VIP__c=sub.vlocity_cmt__AccountId__c                                                 
                    );

        SubVIP.add(Subricption);
         
         }}
   insert SubVIP; 
         }
       
       
     if(Trigger.isUpdate){
//if update new Subscription with flag VIP : insert in new tab SUbscriptionVIP

 //   List<Contact> ct = new List <Contact>();
            List<InwiB2C_Subscription_VIP__c> SubcrVIP = new List<InwiB2C_Subscription_VIP__c>(); 
    for(vlocity_cmt__Subscription__c Sub : trigger.new){
         if (Sub.inwib2c_vip__c==true &&  trigger.oldmap.get(Sub.Id).inwib2c_vip__c== false){
        InwiB2C_Subscription_VIP__c c = new InwiB2C_Subscription_VIP__c(Inwib2c_Num_ro_de_la_ligne__c = sub.Inwib2c_Num_ro_de_la_ligne__c,
                    Name=sub.name,
                    InwiB2C_Subscription_Number__c=sub.vlocity_cmt__SubscriptionNumber__c
                   // InwiB2C_Account_VIP__c=sub.vlocity_cmt__AccountId__c                                               
                    );

        SubcrVIP.add(c);
           
         }
           
        
        }
          insert SubcrVIP; 
}     
       
       
       
       
       
       
       
       
 

    
    
    
    

    
    
    
    
    
 //Subscription VIP changed: not VIP   
    
   Set<boolean> strSet = new Set<boolean>(); 

    for(vlocity_cmt__Subscription__c Sub : Trigger.New){
        strSet.add(Sub.Inwib2c_VIP__c);

    }
    for(vlocity_cmt__Subscription__c SUBVIP : [SELECT Inwib2c_VIP__c,id,Name, vlocity_cmt__SubscriptionNumber__c FROM vlocity_cmt__Subscription__c  WHERE ID =: trigger.new  ]){
      // new AccountVIP
        if(Trigger.isUpdate){    
    
    
      set<id> SubidSet = new set<id>();
       list<InwiB2C_Subscription_VIP__c> contoUpdate=new list<InwiB2C_Subscription_VIP__c>();

              if(SUBVIP.Inwib2c_VIP__c!= trigger.oldmap.get(SUBVIP.Id).Inwib2c_VIP__c)
              {
               SubidSet .add(SUBVIP.id);
            }

     for(InwiB2C_Subscription_VIP__c VIP :[select id,name from InwiB2C_Subscription_VIP__c ]){
       for(vlocity_cmt__Subscription__c Sub:trigger.new){
           if(VIP.name==Sub.name && Sub.Inwib2c_VIP__c==false &&  trigger.oldmap.get(Sub.Id).Inwib2c_VIP__c== true){
             contoUpdate.add(VIP);
              
                   }

}} 
            delete contoUpdate;
            }}
            
    
    
    
    
    
    
   //End:  RMA 22/03/2021
    
    
    */
}