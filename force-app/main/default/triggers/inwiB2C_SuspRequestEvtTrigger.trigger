trigger inwiB2C_SuspRequestEvtTrigger on inwiB2C_SuspRequestEvt__e (after insert) {

    List<String> RequestIds = new List<String>();
    for (inwiB2C_SuspRequestEvt__e event : Trigger.New) {
        system.debug(event.inwiB2C_requestId__c);
        RequestIds.add(event.inwiB2C_requestId__c);

        InwiB2C_CallSuspensionVIPs.CallVIP(event.inwiB2C_requestId__c, event.inwiB2C_subsId__c);
   
    }
     
}