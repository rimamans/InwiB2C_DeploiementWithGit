trigger InwiB2C_Insert_Histo_ActionTrigger on InwiB2C_Insert_Histo_Action__e (after insert) {

    List<String> SubIds = new List<String>();
    for (InwiB2C_Insert_Histo_Action__e event : Trigger.New) {

       SubIds.add(event.inwiB2C_SubscriptionId__c);
   
    }
     InwiB2C_CallRehabilitationVIP.CallVIP(SubIds);
    }