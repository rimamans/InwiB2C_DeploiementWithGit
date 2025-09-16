trigger inwiCGC_DemandeDeVisiteTrigger on inwiCGC_DemandeDeVisite__c(after update) {
    inwiCGC_DemandeDeVisiteTriggerHandler handler = new inwiCGC_DemandeDeVisiteTriggerHandler();
    
    if(!Trigger.New.isEmpty()){
        for(inwiCGC_DemandeDeVisite__c demandeVisite : Trigger.new) {
            if (Trigger.isAfter) {
                if (Trigger.isUpdate) {
                    handler.afterUpdate(demandeVisite);
                }
            }
        }
    }
}