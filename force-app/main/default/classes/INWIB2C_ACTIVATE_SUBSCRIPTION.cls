global class INWIB2C_ACTIVATE_SUBSCRIPTION implements vlocity_cmt.XOMOrchestrationInterfaces.IAutoTask{

    global void executeBatch(List < vlocity_cmt__OrchestrationItem__c > items) {
        vlocity_cmt__OrchestrationItem__c OrchPLan = [select id, vlocity_cmt__OrderItemId__c from vlocity_cmt__OrchestrationItem__c where id =: items[0].id LIMIT 1];
        String orditemId = OrchPLan.vlocity_cmt__OrderItemId__c;
        ActivateSubscription(orditemId);
  
    }

    public static void ActivateSubscription (Id orditemId){
        OrderItem parent = [Select id,OrderId  from OrderItem where id =: orditemId ];
        //Asset parentAsset = [Select id,vlocity_cmt__OrderProductId__c,vlocity_cmt__SubscriptionId__c  from Asset where vlocity_cmt__OrderProductId__c  =: orditemId];
        inwiB2C_OrderSubscription__c orderSub = [Select id,inwiB2C_Order__c,inwiB2C_Subscription__c  from inwiB2C_OrderSubscription__c where inwiB2C_Order__c  =: parent.OrderId and inwiB2C_Subscription__r.inwiB2C_Statut__c='InwiB2C_EncoursDactivation' ];
        vlocity_cmt__Subscription__c sub = [Select id,inwiB2C_LegacyStatus__c,inwiB2C_Statut__c,vlocity_cmt__SubscriptionNumber__c from vlocity_cmt__Subscription__c where Id =: orderSub.inwiB2C_Subscription__c];
        Order order = [Select id,inwiB2C_Statut__c from Order where id =: parent.OrderId];

        Date dateLimiteSR;
        InwiB2C_delai_stdr_satisfait_rembourse__mdt delai = [Select id,InwiB2C_delai__c from InwiB2C_delai_stdr_satisfait_rembourse__mdt where DeveloperName='InwiB2C_Satisfait_ou_Rembourse'];
        DateTime dateLimite = System.now();
        dateLimite = dateLimite.addDays(Integer.valueOf(delai.InwiB2C_delai__c));
        dateLimiteSR = date.newinstance(dateLimite.year(), dateLimite.month(), dateLimite.day());
        
        DateTime activationDate = Datetime.now();
       
        sub.inwiB2C_LegacyStatus__c = 'ACTIVE';
        sub.inwiB2C_Statut__c = 'InwiB2C_Active';
        sub.InwiB2C_Date_d_activation__c = activationDate;
        sub.InwiB2C_date_limite_satisfait_rembours__c = dateLimiteSR;
        //sub.vlocity_cmt__SubscriptionNumber__c = parentAsset.id;
        Update sub;

        //parentAsset.vlocity_cmt__SubscriptionId__c = sub.Id;
        //update parentAsset;

        order.inwiB2C_Statut__c = 'inwiB2C_Activation';
        update order;
        //check if exist pack depanage  or daye one DLE 04/02/2023 begin
        List <InwiB2C_Order_SuspIdar__c> Listdepanagedayeone = [SELECT id FROM InwiB2C_Order_SuspIdar__c
            WHERE InwiB2C_OrderFIXE__c =: parent.OrderId and InwiB2C_Statut__c= 'New'];
        
        List<InwiB2C_Order_SuspIdar__c> Listdepanagedayeonetoupdate = new List<InwiB2C_Order_SuspIdar__c>();
        if (Listdepanagedayeone.size() > 0) 
        { 
        for (InwiB2C_Order_SuspIdar__c Listdepanagedayeoneitem: Listdepanagedayeone) 
        {
            Listdepanagedayeonetoupdate.add(new InwiB2C_Order_SuspIdar__c (id= Listdepanagedayeoneitem.id,InwiB2C_Statut__c  = 'Ready'));
         }
         update Listdepanagedayeonetoupdate;                      
        }
        //check if exist pack depanage  or daye one DLE 04/02/2023 end

        
    }
}