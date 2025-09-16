/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-10-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Begin: RMA 22/032021

trigger InwiB2C_UpdateAccount on Account(after insert, after update) {
    List<InwiB2C_Account_VIP__c> AccountVIP = new List<InwiB2C_Account_VIP__c>(); 
    //For insert only
    Set<ID> AccountID = Trigger.newMap.keySet();
    List<Account> IdAcc= [SELECT id,Name, Inwib2c_VIP__c,vlocity_cmt__PersonContactId__r.FirstName,vlocity_cmt__PersonContactId__r.LastName,vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c FROM Account  WHERE ID in :AccountID  ];
    //if insert AccountConsumer with flag vip: insert in new tab AccountVIP                                 
    
    if(Trigger.isInsert){
        for(Account acc :IdAcc){
            if (acc.Inwib2c_VIP__c==true ){
                InwiB2C_Account_VIP__c c = new InwiB2C_Account_VIP__c(
                    Name = acc.name,
                    InwiB2C_FirstName__c=acc.vlocity_cmt__PersonContactId__r.FirstName,
                    InwiB2C_LastName__c=acc.vlocity_cmt__PersonContactId__r.LastName,
                    InwiB2C_CIN__c=acc.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,
                    Id_Account__c=acc.id
                );
                AccountVIP.add(c);
                
            }}       
        insert AccountVIP; 
        
    }
    
    
    //if update consumer to vip : insert in new tab AccountVIP
    List<vlocity_cmt__Subscription__c> Idsub= [SELECT Inwib2c_VIP__c,id,Name, vlocity_cmt__SubscriptionNumber__c FROM vlocity_cmt__Subscription__c  WHERE vlocity_cmt__AccountId__c in :AccountID  ];  
    List<InwiB2C_Account_VIP__c> ACCVIP= [select id,name,Id_Account__c from InwiB2C_Account_VIP__c  ];

    Set<ID> accountVIPTrueSet = new Set<ID> ();
    Set<ID> accountVIPFalseSet = new Set<ID> ();
    
    if(Trigger.isUpdate){
        
        List<InwiB2C_Account_VIP__c> AccountVIPTrue = new List<InwiB2C_Account_VIP__c>(); 
        List<InwiB2C_Account_VIP__c> AccountVIPfalse = new List<InwiB2C_Account_VIP__c>(); 
        List<vlocity_cmt__Subscription__c> SubVIPtrue = new List<vlocity_cmt__Subscription__c>(); 
        List<vlocity_cmt__Subscription__c> SubVIPfalse = new List<vlocity_cmt__Subscription__c>(); 
        
        
        for(Account acc :IdAcc){
            if (acc.Inwib2c_VIP__c==true &&  trigger.oldmap.get(acc.Id).Inwib2c_VIP__c== false){
                
                InwiB2C_Account_VIP__c c = new InwiB2C_Account_VIP__c(Name = acc.name,
                                                                      InwiB2C_FirstName__c=acc.vlocity_cmt__PersonContactId__r.FirstName,
                                                                      InwiB2C_LastName__c=acc.vlocity_cmt__PersonContactId__r.LastName,
                                                                      InwiB2C_CIN__c=acc.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,
                                                                      Id_Account__c=acc.id );
                
                AccountVIPTrue.add(c);
                accountVIPTrueSet.add(acc.Id);
                
                
            } 
            else if (acc.Inwib2c_VIP__c==false &&  trigger.oldmap.get(acc.Id).Inwib2c_VIP__c== true){
                for(InwiB2C_Account_VIP__c con :ACCVIP){
                    if(con.Id_Account__c==acc.id){
                        AccountVIPfalse.add(con);
                        accountVIPFalseSet.add(acc.Id);
                        
                    }
                }    
            }   
            
        }
        
        
        
        
        
        
        
        
        //if account is changed VIP : all Subscription related account changed to vip 
        
        insert AccountVIPTrue;  
        delete AccountVIPfalse;

        List<vlocity_cmt__Subscription__c> SubscriptionVIPTrue = [SELECT Inwib2c_VIP__c,id,Name, vlocity_cmt__SubscriptionNumber__c FROM vlocity_cmt__Subscription__c  WHERE vlocity_cmt__AccountId__c in :accountVIPTrueSet  ];  

        List<vlocity_cmt__Subscription__c> SubscriptionVIPFalse = [SELECT Inwib2c_VIP__c,id,Name, vlocity_cmt__SubscriptionNumber__c FROM vlocity_cmt__Subscription__c  WHERE vlocity_cmt__AccountId__c in :accountVIPFalseSet  ];  
//SubscriptionVIPTrue

        if (AccountVIPTrue.size()>0){
            for(vlocity_cmt__Subscription__c sub : SubscriptionVIPTrue){
                Sub.inwib2c_vip__c=true;
                SubVIPTrue.add(sub);
            }  
            Update(SubVIPTrue);
            
        }
        //SubscriptionVIPFalse
        if (AccountVIPfalse.size()>0){
            for(vlocity_cmt__Subscription__c sub : SubscriptionVIPFalse){
                Sub.inwib2c_vip__c=false;
                SubVIPfalse.add(sub);
            }  
            Update(SubVIPfalse);
            
        }
        
        
        
        
        
        
    }   
    
    
    
    
    
}
//END: RMA 22/032021