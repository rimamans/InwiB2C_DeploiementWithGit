trigger inwiCGC_VisitStatusTrigger on Visit (before update) {

    Set<Id> visitIds = new Set<Id>();
    for (Visit visit : Trigger.new) {
        visitIds.add(visit.Id);
    }

    Map<Id, Visit> visitMap = new Map<Id, Visit>(
        [SELECT Id, RetailStoreId, inwiCGC_ParentVisitId__c 
         FROM Visit 
         WHERE Id IN :visitIds]
    );

    Map<Id, List<RetailVisitKpi>> kpiMap = new Map<Id, List<RetailVisitKpi>>();
    for (RetailVisitKpi kpi : [
        SELECT ActualIntegerValue, ActualStringValue, AssessmentIndDefinition.Name, VisitId 
        FROM RetailVisitKpi 
        WHERE VisitId IN :visitIds
    ]) {
        if (!kpiMap.containsKey(kpi.VisitId)) {
            kpiMap.put(kpi.VisitId, new List<RetailVisitKpi>());
        }
        kpiMap.get(kpi.VisitId).add(kpi);
    }

    for (Visit visit : Trigger.new) {
        Visit oldVisit = Trigger.oldMap.get(visit.Id);
        Visit queriedVisit = visitMap.get(visit.Id); 

        if (visit.Status != oldVisit.Status) {

            if (queriedVisit.RetailStoreId == null) {
                visit.addError('Vous devez sélectionner un magasin de détail avant de pouvoir exécuter une visite.');
            } 
            else if (queriedVisit.inwiCGC_ParentVisitId__c == null) {
                visit.addError('Visite mère ne peut pas être exécutée.');
            }
        }

        if (oldVisit.Status == 'InProgress' && visit.Status == 'Completed') {
            Boolean tasksIncomplete = false;

            List<RetailVisitKpi> kpiList = kpiMap.get(visit.Id);
            if (kpiList != null) {
                for (RetailVisitKpi kpi : kpiList) {
                    String kpiName = kpi.AssessmentIndDefinition.Name;
                    if ((kpiName == 'Nombre de carte SIM vendu' || 
                         kpiName == 'Nombre de carte SIM Dealer vendu' || 
                         kpiName == 'Nombre de SC vendu') && 
                         kpi.ActualIntegerValue == null) {
                        tasksIncomplete = true;
                        break;
                    }
                }
            }

            if (tasksIncomplete) {
                visit.addError('Vous ne pouvez pas terminer la visite sans avoir complété toutes les tâches d\'évaluation.');
            }
        }
    }
}