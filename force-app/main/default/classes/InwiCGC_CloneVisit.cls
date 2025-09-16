public with sharing class InwiCGC_CloneVisit {
    @AuraEnabled
    public static void cloneVisitForUsers(String recordId, List<String> selectedUserIds) {
        Visit originalVisit = [SELECT Id, AccountId, ActualVisitEndTime, ActualVisitStartTime, AddressId, ContactId, ContextId, inwiCGC_DemandeDeVisite__c, LocationId, Name, OwnerId, PlaceId, PlannedVisitEndTime, PlannedVisitStartTime, RecordTypeId, RetailStoreId, ServiceResourceId, Status, StatusRemarks, UserId, VisitorId, VisitPriority FROM Visit WHERE Id = :recordId LIMIT 1];        
        List <AssessmentTask> originalAssessmentTasks = [SELECT AssessmentTaskDefinition.Description, EndTime, IsRequired, Name, OwnerId, ParentId, SequenceNumber, StartTime, Status, TaskDefinitionId, TaskType FROM AssessmentTask WHERE ParentId = :recordId];        
        List<ActionPlan> originalActionPlans = [SELECT ActionPlanTemplateVersionId, ActionPlanState, ActionPlanType, ActualEndDate, ActualStartDate, EndDate, IsUsingHolidayHours, Name, Ownerid,RecordCreationType, RecurringScheduleId, ScheduleFrequency, StartDate, StatusCode  FROM ActionPlan WHERE TargetId = :recordId];
        List<Visit> clonedVisits = new List<Visit>();
        List <AssessmentTask> clonedAssessmentTasksFinal = new List <AssessmentTask> ();
        List <ActionPlan> clonedActionPlanFinal = new List <ActionPlan> ();
        for (String selectedUserId : selectedUserIds) {
            Visit clonedVisit = originalVisit.clone(false, true, false, true);
            clonedVisit.VisitorId = selectedUserId;
            clonedVisit.OwnerId = selectedUserId;
            clonedVisit.ActualVisitStartTime = null;
            clonedVisit.ActualVisitEndTime = null;
            clonedVisit.Status = 'Planned';
            clonedVisit.inwiCGC_ParentVisitId__c = recordId;
            clonedVisits.add(clonedVisit);
        }        
        if (clonedVisits.size() > 0){
            insert clonedVisits;
            //System.debug(JSON.serialize(clonedVisits));
            for (Visit visit : clonedVisits) {
                //List <AssessmentTask> clonedAssessmentTasks = originalAssessmentTasks.clone();
                for (AssessmentTask task: originalAssessmentTasks){
                    AssessmentTask clonedTask = task.clone(false, true, false, true);
                    clonedTask.ParentId = visit.id;
                    clonedAssessmentTasksFinal.add(clonedTask);
                }
                for (ActionPlan actionPlan: originalActionPlans){
                    ActionPlan clonedActionPlan = actionPlan.clone(false, true, false, true);
                    clonedActionPlan.TargetId = visit.id;
                    clonedActionPlanFinal.add(clonedActionPlan);
                }
                //clonedAssessmentTasksFinal.addAll(clonedAssessmentTasks);
            }
            System.debug(JSON.serialize(clonedAssessmentTasksFinal));
            if (clonedAssessmentTasksFinal.size() > 0){
                //insert clonedAssessmentTasksFinal;
            }
            if (clonedActionPlanFinal.size() > 0){
                insert clonedActionPlanFinal;
            }
        }
    }
    
    @AuraEnabled
    public static void cloneVisitAndAssignRetailStore(String recordId, Id retailStoreId){
        Visit originalVisit = [SELECT AccountId, ActualVisitEndTime, ActualVisitStartTime, AddressId, ContactId, ContextId, inwiCGC_DemandeDeVisite__c, LocationId, Name, OwnerId, PlaceId, PlannedVisitEndTime, PlannedVisitStartTime, RecordTypeId, RetailStoreId, ServiceResourceId, Status, StatusRemarks, UserId, VisitorId, VisitPriority FROM Visit WHERE Id = :recordId LIMIT 1];
        List <AssessmentTask> originalAssessmentTasks = [SELECT AssessmentTaskDefinition.Description, EndTime, IsRequired, Name, OwnerId, ParentId, SequenceNumber, StartTime, Status, TaskDefinitionId, TaskType FROM AssessmentTask WHERE ParentId = :recordId];
        List<ActionPlan> originalActionPlans = [SELECT ActionPlanTemplateVersionId, ActionPlanState, ActionPlanType, ActualEndDate, ActualStartDate, EndDate, IsUsingHolidayHours, Name, Ownerid,RecordCreationType, RecurringScheduleId, ScheduleFrequency, StartDate, StatusCode  FROM ActionPlan WHERE TargetId = :recordId];
        List<Visit> clonedVisits = new List<Visit>();
        List <AssessmentTask> clonedAssessmentTasksFinal = new List <AssessmentTask> ();
        List <ActionPlan> clonedActionPlanFinal = new List <ActionPlan> ();
        Visit clonedVisit = originalVisit.clone(false, true, false, true);
        clonedVisit.PlaceId = retailStoreId;
        clonedVisit.ActualVisitStartTime = null;
        clonedVisit.ActualVisitEndTime = null;
        clonedVisit.Status = 'Planned';
        clonedVisit.inwiCGC_ParentVisitId__c = recordId;
        clonedVisits.add(clonedVisit);
        if (clonedVisits.size() > 0){
            insert clonedVisits;
            //System.debug(JSON.serialize(clonedVisits));
            for (Visit visit : clonedVisits) {
                //List <AssessmentTask> clonedAssessmentTasks = originalAssessmentTasks.clone();
                for (AssessmentTask task: originalAssessmentTasks){
                    AssessmentTask clonedTask = task.clone(false, true, false, true);
                    clonedTask.ParentId = visit.id;
                    clonedAssessmentTasksFinal.add(clonedTask);
                }
                for (ActionPlan actionPlan: originalActionPlans){
                    ActionPlan clonedActionPlan = actionPlan.clone(false, true, false, true);
                    clonedActionPlan.TargetId = visit.id;
                    clonedActionPlanFinal.add(clonedActionPlan);
                }
                //clonedAssessmentTasksFinal.addAll(clonedAssessmentTasks);
            }
            //System.debug(JSON.serialize(clonedAssessmentTasksFinal));
            if (clonedAssessmentTasksFinal.size() > 0){
                //insert clonedAssessmentTasksFinal;
            }   
            if (clonedActionPlanFinal.size() > 0){
                insert clonedActionPlanFinal;
            }
        }
    }

    @AuraEnabled(cacheable=true)
    public static ActionPlan getActionPlanByVisitId(String recordId) {
        List<ActionPlan> actionPlans = [
            SELECT Id, Name, TargetId 
            FROM ActionPlan 
            WHERE TargetId = :recordId 
            LIMIT 1
        ];
        
        if (actionPlans.isEmpty()) {
            System.debug('No Action Plan found for Visit ID: ' + recordId);
            return null;
        } else {
            System.debug('Found Action Plan: ' + actionPlans[0]);
            return actionPlans[0];
        }
    }


}