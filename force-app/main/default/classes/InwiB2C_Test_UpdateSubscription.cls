@isTest
public class InwiB2C_Test_UpdateSubscription {
@isTest(SeeAllData=true)
    static void MethodTestPositive() {
     //CHB 27/07/2023
     vlocity_cmt__Subscription__c testSubscription = new vlocity_cmt__Subscription__c();
        testSubscription.Inwib2c_Num_ro_de_la_ligne__c = '212600000021';
        testSubscription.Name = 'Test';
        testSubscription.vlocity_cmt__SubscriptionNumber__c = 	'212600000021';
        testSubscription.inwib2c_vip__c=true;
       
        Insert testSubscription;
            testSubscription.inwiB2C_LegacyStatus__c='ACTIVE';
        testSubscription.inwiB2C_Statut__c ='InwiB2C_Active';
        testSubscription.vlocity_cmt__Status__c='Active';
        update testSubscription;
        if (testSubscription.inwib2c_vip__c=true){
            
            InwiB2C_Subscription_VIP__c Subricption = new InwiB2C_Subscription_VIP__c(Inwib2c_Num_ro_de_la_ligne__c = testSubscription.name,
                    Name=testSubscription.name,
                    InwiB2C_Subscription_Number__c=testSubscription.vlocity_cmt__SubscriptionNumber__c,
                     InwiB2C_Account_VIP__c=testSubscription.vlocity_cmt__AccountId__c                                                 
                    );
        }
        
        
        
       vlocity_cmt__Subscription__c testSubscription2 = new vlocity_cmt__Subscription__c();
        testSubscription2.Inwib2c_Num_ro_de_la_ligne__c = '21261';
        testSubscription2.Name = 'Test2';
        testSubscription2.vlocity_cmt__SubscriptionNumber__c = 	'212';
        testSubscription2.inwib2c_vip__c=false;
        Insert testSubscription2;
        testSubscription2.inwib2c_vip__c=true;
        testSubscription2.inwiB2C_managedInSF__c = true;
        //testSubscription2.Inwib2c_Num_ro_de_la_ligne__c = '212655334499';
        update testSubscription2;
        testSubscription2.Inwib2c_Num_ro_de_la_ligne__c = '212655334499';
        update testSubscription2;
        testSubscription2.Inwib2c_ICC__c = '123345252626262662';
        update testSubscription2;
        testSubscription2.InwiB2C_Id_profil__c = 'ProfileIdTest';
        update testSubscription2;
        testSubscription2.inwiB2C_LegacyStatus__c='Suspension cycle de vie';
        update testSubscription2;
        // CHB 27/06/2023 
        if (testSubscription2.inwib2c_vip__c=true){
            
            InwiB2C_Subscription_VIP__c Subricption2 = new InwiB2C_Subscription_VIP__c(Inwib2c_Num_ro_de_la_ligne__c = testSubscription2.Inwib2c_Num_ro_de_la_ligne__c,
                    Name=testSubscription2.name,
                    InwiB2C_Subscription_Number__c=testSubscription2.vlocity_cmt__SubscriptionNumber__c
                    );
            insert Subricption2;
        }
        
        vlocity_cmt__Subscription__c testSubscription3 = new vlocity_cmt__Subscription__c();
        testSubscription3.Inwib2c_Num_ro_de_la_ligne__c = '21266661';
        testSubscription3.Name = 'Test2';
        testSubscription3.vlocity_cmt__SubscriptionNumber__c = 	'21266';
        testSubscription3.inwib2c_vip__c=false;
        Insert testSubscription3;
        testSubscription3.inwib2c_vip__c=true;
        testSubscription3.inwiB2C_managedInSF__c = true;
        //testSubscription2.Inwib2c_Num_ro_de_la_ligne__c = '212655334499';
        update testSubscription3;
        testSubscription3.Inwib2c_Num_ro_de_la_ligne__c = '212675334499';
        update testSubscription3;
        testSubscription3.Inwib2c_ICC__c = '123345252626262662';
        update testSubscription3;
        testSubscription3.InwiB2C_Id_profil__c = 'ProfileIdTest';
        update testSubscription3;
        testSubscription3.inwiB2C_LegacyStatus__c='Suspension fraude';
          update testSubscription3;
          if (testSubscription3.inwib2c_vip__c=true){
            
            InwiB2C_Subscription_VIP__c Subscription3 = new InwiB2C_Subscription_VIP__c(Inwib2c_Num_ro_de_la_ligne__c = testSubscription3.Inwib2c_Num_ro_de_la_ligne__c,
                    Name=testSubscription3.name,
                    InwiB2C_Subscription_Number__c=testSubscription3.vlocity_cmt__SubscriptionNumber__c
                    );
            insert Subscription3;
                
             
        }   
             
         //}
         
          
    }}