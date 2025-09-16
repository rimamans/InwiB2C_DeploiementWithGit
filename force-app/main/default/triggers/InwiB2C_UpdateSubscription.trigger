/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 04-28-2022
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//BEGIN: RMA 22/03/2021
//MAJ if subscription update 

trigger InwiB2C_UpdateSubscription on vlocity_cmt__Subscription__c (after insert, after update){
    Set<ID> SubscriptionID = Trigger.newMap.keySet();
    //CHB 24/11/2023 Arret synch PS Prepaid
    //BEGIN: ABB 29/01/2024 TR: MC Arret synchro Postpaid
    List<vlocity_cmt__Subscription__c> Idsub= [SELECT inwib2c_inst_prod_id__c, inwiB2C_LegacyStatus__c,LastModifiedBy.Name, inwiB2C_Statut__c , vlocity_cmt__Status__c,InwiB2C_Id_profil__c,Inwib2c_ICC__c,Inwib2c_VIP__c,id,Name, vlocity_cmt__SubscriptionNumber__c,Inwib2c_Num_ro_de_la_ligne__c,vlocity_cmt__AccountId__c, inwiB2C_managedInSF__c ,INWIB2C_NoSynchronize__c FROM vlocity_cmt__Subscription__c  WHERE ID in: SubscriptionID AND  Inwib2C_Type_Offre__c not in ('InwiB2C_Prepaye','InwiB2C_Postpaye')];
    //END: ABB 29/01/2024 TR: MC Arret synchro Postpaid
    //B-9573 BEGIN
    inwiB2C_SubscriptionUpdateEvent__e subscriptionUpdateEvent = new inwiB2C_SubscriptionUpdateEvent__e();
    List<inwiB2C_SubscriptionUpdateEvent__e> subscriptionEventsList = new List<inwiB2C_SubscriptionUpdateEvent__e>();  
    List<inwiB2C_OrderSubscription__c> listOrderCam = [select Id,inwiB2C_Subscription__c from inwiB2C_OrderSubscription__c where inwiB2C_Subscription__c in: SubscriptionID and InwiB2C_Statut_Order__c <> 'Annulée' and inwiB2C_Order__r.inwiB2C_TypeDeMigration__c='InwiB2C_MigrationPrePostpayé' and inwiB2C_Order__r.InwiB2C_Type_Offer__c = 'Cameleon' and InwiB2C_Statut_Souscription__c  = 'EXPIRED' order by InwiB2C_Date_et_heure_Order__c desc];
    //B-9573 END
    //if insert new Subscription with flag VIP : insert in new tab SUbscriptionVIP
    //B-9573 DLE Begin
    if(Trigger.isUpdate){
        List<InwiB2C_Subscription_VIP__c> SubVIP = new List<InwiB2C_Subscription_VIP__c>(); 
             for(vlocity_cmt__Subscription__c Sub : Idsub){

            for (inwiB2C_OrderSubscription__c orderItemCam : listOrderCam){
                if (Sub.id == orderItemCam.inwiB2C_Subscription__c){
                    subscriptionUpdateEvent.inwiB2C_Action__c = 'DCAM';
                    subscriptionUpdateEvent.inwiB2C_icc1__c = trigger.oldmap.get(Sub.Id).Inwib2c_ICC__c;
                    subscriptionUpdateEvent.inwiB2C_icc2__c = Sub.Inwib2c_ICC__c;
                    subscriptionUpdateEvent.inwiB2C_mdn__c = Sub.Inwib2c_Num_ro_de_la_ligne__c;
                    subscriptionUpdateEvent.inwiB2C_oldmdn__c = trigger.oldmap.get(Sub.Id).Inwib2c_Num_ro_de_la_ligne__c;
                    subscriptionUpdateEvent.inwiB2C_subscriptionID__c = Sub.inwib2c_inst_prod_id__c;
                    subscriptionEventsList.add(subscriptionUpdateEvent);
                    system.debug(subscriptionUpdateEvent);
                }
            }
            List <Database.SaveResult> sRes = EventBus.publish(subscriptionEventsList);
        }
    }
    //B-9573 DLE END
    if(Trigger.isInsert){
        List<InwiB2C_Subscription_VIP__c> SubVIP = new List<InwiB2C_Subscription_VIP__c>(); 
        //  for(vlocity_cmt__Subscription__c Sub : [SELECT Inwib2c_VIP__c,id,Name, vlocity_cmt__SubscriptionNumber__c,vlocity_cmt__AccountId__r.name FROM vlocity_cmt__Subscription__c  WHERE ID =: trigger.new  ]){      
        for(vlocity_cmt__Subscription__c Sub : Idsub){
            
            
            if (Sub.inwib2c_vip__c==true ){
                InwiB2C_Subscription_VIP__c Subricption = new InwiB2C_Subscription_VIP__c(Inwib2c_Num_ro_de_la_ligne__c = sub.Inwib2c_Num_ro_de_la_ligne__c,
                                                                                          Name=sub.name,
                                                                                          InwiB2C_Subscription_Number__c=sub.vlocity_cmt__SubscriptionNumber__c,
                                                                                          InwiB2C_Id_Sub__c=sub.id
                                                                                          //  InwiB2C_Account_VIP__c=sub.vlocity_cmt__AccountId__c                                                 
                                                                                         );
                SubVIP.add(Subricption);
            }
            insert SubVIP;
        }
      
    }
    
    List<inwiB2C_OrderSubscription__c> ListOrders = [select InwiB2C_Type_acte_de_gestion__c, InwiB2C_Statut_Order__c,inwiB2C_Order__r.inwiB2C_TypeDeSuspension__c, inwiB2C_Subscription__c, InwiB2C_Date_et_heure_Order__c  from inwiB2C_OrderSubscription__c where inwiB2C_Subscription__c in: SubscriptionID and InwiB2C_Statut_Order__c <> 'Annulée' and (InwiB2C_Type_acte_de_gestion__c = 'Suspension' OR InwiB2C_Type_acte_de_gestion__c = 'PortaOut')  and inwiB2C_Subscription__r.inwiB2C_managedInSF__c = true and inwiB2C_Subscription__r.Inwib2C_Type_Offre__c='InwiB2C_Prepaye' order by InwiB2C_Date_et_heure_Order__c desc];
    
    List<inwiB2C_OrderSubscription__c> ListOrders2 = [select Id,inwiB2C_Order__c,inwiB2C_Subscription__c from inwiB2C_OrderSubscription__c where inwiB2C_Subscription__c in: SubscriptionID and InwiB2C_Statut_Order__c <> 'Annulée' and ((inwiB2C_Order__r.inwiB2C_TypeDeMigration__c='InwiB2C_MigrationPrePostpayé' OR inwiB2C_Order__r.inwiB2C_TypeDeMigration__c='InwiB2C_MigrationPost_Prepayé') OR (InwiB2C_Type_acte_de_gestion__c='inwiB2C_RegroupementCompte'  OR InwiB2C_Type_acte_de_gestion__c='inwiB2C_ChangementTitulaire')) order by InwiB2C_Date_et_heure_Order__c desc];
    //Update Subscription legacy JBEN 06072021
    if(Trigger.isUpdate){
        List<inwiB2C_SubscriptionUpdateEvent__e> SubEventsList = new List<inwiB2C_SubscriptionUpdateEvent__e>();        
        //List<inwiB2C_OrderSubscription__c> ListOrders = [select InwiB2C_Type_acte_de_gestion__c, InwiB2C_Statut_Order__c,inwiB2C_Order__r.inwiB2C_TypeDeSuspension__c, inwiB2C_Subscription__c, InwiB2C_Date_et_heure_Order__c  from inwiB2C_OrderSubscription__c where inwiB2C_Subscription__c in: SubscriptionID and InwiB2C_Statut_Order__c <> 'Annulée' and (InwiB2C_Type_acte_de_gestion__c = 'Suspension' OR InwiB2C_Type_acte_de_gestion__c = 'PortaOut')  and inwiB2C_Subscription__r.inwiB2C_managedInSF__c = true and inwiB2C_Subscription__r.Inwib2C_Type_Offre__c='InwiB2C_Prepaye' order by InwiB2C_Date_et_heure_Order__c desc];
        for(vlocity_cmt__Subscription__c Sub : Idsub){
            if (Sub.inwiB2C_managedInSF__c == true && Sub.INWIB2C_NoSynchronize__c == false){
                inwiB2C_SubscriptionUpdateEvent__e SubUpdateEvent = new inwiB2C_SubscriptionUpdateEvent__e();
                boolean sentToPs=true;
                //DEFINE THE ACTION
                //Cas Suspension
                for (inwiB2C_OrderSubscription__c OrderItem : ListOrders){
                    
                    if (Sub.Id == OrderItem.inwiB2C_Subscription__c){
                        if(OrderItem.InwiB2C_Type_acte_de_gestion__c == 'Suspension'){
                            
                            if(OrderItem.inwiB2C_Order__r.inwiB2C_TypeDeSuspension__c == 'International'){
                                SubUpdateEvent.inwiB2C_Action__c = 'SUSI';}
                            
                            else if(OrderItem.inwiB2C_Order__r.inwiB2C_TypeDeSuspension__c == 'Appels sortants'){
                                SubUpdateEvent.inwiB2C_Action__c = 'SUSA';} 
                            
                            else if(OrderItem.inwiB2C_Order__r.inwiB2C_TypeDeSuspension__c == 'Total'){
                                SubUpdateEvent.inwiB2C_Action__c = 'SUST';}
                        }
                        if(OrderItem.InwiB2C_Type_acte_de_gestion__c == 'PortaOut' && Sub.inwiB2C_LegacyStatus__c=='EXPIRED' && Sub.inwiB2C_Statut__c =='InwiB2C_Expired' && Sub.vlocity_cmt__Status__c=='Expired' && trigger.oldmap.get(Sub.Id).inwiB2C_LegacyStatus__c !='EXPIRED' && trigger.oldmap.get(Sub.Id).inwiB2C_Statut__c != 'InwiB2C_Expired' && trigger.oldmap.get(Sub.Id).vlocity_cmt__Status__c != 'Expired'){
                            SubUpdateEvent.inwiB2C_Action__c = 'PORE';
                        }
                        break;
                    }
                }
                
                for (inwiB2C_OrderSubscription__c OrderItem2 : ListOrders2){
                    if (Sub.Id == OrderItem2.inwiB2C_Subscription__c){
                        sentToPs = false;
                        system.debug('a ne pas envoyé');
                    }
                }
                
                if(Sub.Inwib2c_ICC__c != trigger.oldmap.get(Sub.Id).Inwib2c_ICC__c)
                    SubUpdateEvent.inwiB2C_Action__c = 'CHHA';
                
                else if(Sub.InwiB2C_Id_profil__c != trigger.oldmap.get(Sub.Id).InwiB2C_Id_profil__c)
                    SubUpdateEvent.inwiB2C_Action__c = 'MODF';
                
                else if(Sub.Inwib2c_Num_ro_de_la_ligne__c != trigger.oldmap.get(Sub.Id).Inwib2c_Num_ro_de_la_ligne__c)
                    SubUpdateEvent.inwiB2C_Action__c = 'CHNU';
                
                else if (Sub.inwiB2C_LegacyStatus__c=='ACTIVE' && trigger.oldmap.get(Sub.Id).inwiB2C_LegacyStatus__c !='ACTIVE' && Sub.inwiB2C_Statut__c =='InwiB2C_Active' && trigger.oldmap.get(Sub.Id).inwiB2C_Statut__c != 'InwiB2C_Active' && Sub.vlocity_cmt__Status__c=='Active' && trigger.oldmap.get(Sub.Id).vlocity_cmt__Status__c != 'Active')
                {
                    system.debug('CAS REHABILIATION');
                    SubUpdateEvent.inwiB2C_Action__c = 'REHA';
                }
                
                else if (Sub.inwiB2C_LegacyStatus__c=='Suspension cycle de vie' && trigger.oldmap.get(Sub.Id).inwiB2C_LegacyStatus__c !='Suspension cycle de vie')
                {   
                    system.debug('CAS SUSP CYCLE DE VIE');
                    SubUpdateEvent.inwiB2C_Action__c = 'SUSC';
                }
                
                else if (Sub.inwiB2C_LegacyStatus__c=='Suspension fraude' && trigger.oldmap.get(Sub.Id).inwiB2C_LegacyStatus__c !='Suspension fraude')
                {
                    system.debug('CAS SUSP FRAUDE');
                    SubUpdateEvent.inwiB2C_Action__c = 'SFRD';
                }
                
                else if (SubUpdateEvent.inwiB2C_Action__c != 'PORE'&& sentToPs==true && Sub.inwiB2C_LegacyStatus__c=='EXPIRED' && Sub.inwiB2C_Statut__c =='InwiB2C_Expired' && Sub.vlocity_cmt__Status__c=='Expired' && trigger.oldmap.get(Sub.Id).inwiB2C_LegacyStatus__c !='EXPIRED' && trigger.oldmap.get(Sub.Id).inwiB2C_Statut__c != 'InwiB2C_Expired' && trigger.oldmap.get(Sub.Id).vlocity_cmt__Status__c != 'Expired')
                    SubUpdateEvent.inwiB2C_Action__c = 'DISC';
                system.debug(SubUpdateEvent.inwiB2C_Action__c);
                //SubUpdateEvent.inwiB2C_Action__c = '';
                SubUpdateEvent.inwiB2C_icc1__c = trigger.oldmap.get(Sub.Id).Inwib2c_ICC__c;
                SubUpdateEvent.inwiB2C_icc2__c = Sub.Inwib2c_ICC__c;
                SubUpdateEvent.inwiB2C_mdn__c = Sub.Inwib2c_Num_ro_de_la_ligne__c;
                SubUpdateEvent.inwiB2C_oldmdn__c = trigger.oldmap.get(Sub.Id).Inwib2c_Num_ro_de_la_ligne__c;
                SubUpdateEvent.inwiB2C_subscriptionID__c = Sub.inwib2c_inst_prod_id__c;
                //TEST IF HANDLINGACTION IS SET 
                if (SubUpdateEvent.inwiB2C_Action__c != null )
                {
                    SubEventsList.add(SubUpdateEvent);
                    system.debug(SubUpdateEvent);
                }
                //Database.SaveResult sresult = EventBus.publish(SubUpdateEvent);
            }
        }
        system.debug('before publish');
        List <Database.SaveResult> sresult = EventBus.publish(SubEventsList);
        system.debug('event published');
    }       
    
    if(Trigger.isUpdate){
        //if update new Subscription with flag VIP : insert in new tab SUbscriptionVIP
        //   List<Contact> ct = new List <Contact>();
        List<InwiB2C_Subscription_VIP__c> SubcrVIP = new List<InwiB2C_Subscription_VIP__c>(); 
        for(vlocity_cmt__Subscription__c Sub : Idsub){
            if (Sub.inwib2c_vip__c==true &&  trigger.oldmap.get(Sub.Id).inwib2c_vip__c== false){
                InwiB2C_Subscription_VIP__c c = new InwiB2C_Subscription_VIP__c(Inwib2c_Num_ro_de_la_ligne__c = sub.Inwib2c_Num_ro_de_la_ligne__c,
                                                                                Name=sub.name,
                                                                                InwiB2C_Subscription_Number__c=sub.vlocity_cmt__SubscriptionNumber__c,
                                                                                InwiB2C_Id_Sub__c=sub.id
                                                                                // InwiB2C_Account_VIP__c=sub.vlocity_cmt__AccountId__c                                               
                                                                               );
                SubcrVIP.add(c);
            }            
        }
        insert SubcrVIP; 
    }     
    
    //Subscription VIP changed: not VIP   
    List<InwiB2C_Subscription_VIP__c> VIPS= [select id,name,InwiB2C_Id_Sub__c from InwiB2C_Subscription_VIP__c  ];
    list<InwiB2C_Subscription_VIP__c> contoUpdate=new list<InwiB2C_Subscription_VIP__c>();
    
    Set<boolean> strSet = new Set<boolean>(); 
    
    for(vlocity_cmt__Subscription__c Sub : Idsub){
        strSet.add(Sub.Inwib2c_VIP__c);
    }
    for(vlocity_cmt__Subscription__c SUBVIP :Idsub){
        // new AccountVIP
        if(Trigger.isUpdate){            
            set<id> SubidSet = new set<id>();
            
            if(SUBVIP.Inwib2c_VIP__c!= trigger.oldmap.get(SUBVIP.Id).Inwib2c_VIP__c)
            {
                SubidSet .add(SUBVIP.id);
            }
            for(InwiB2C_Subscription_VIP__c VIP :VIPS){
                if(VIP.InwiB2C_Id_Sub__c==SUBVIP.id && VIP.name==SUBVIP.name && SUBVIP.Inwib2c_VIP__c==false &&  trigger.oldmap.get(SUBVIP.Id).Inwib2c_VIP__c== true){
                    contoUpdate.add(VIP);               
                }
            }
        }   
    }    
    delete contoUpdate;
    //End:  RMA 22/03/2021   
}