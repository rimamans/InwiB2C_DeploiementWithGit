public class inwiCGC_CreateVisitsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String email;
    String query;
    
    public inwiCGC_CreateVisitsBatch()
    {
        query = 'SELECT id, inwiCGC_ActionPlanTemplate__c, inwiCGC_HeureDebut__c, inwiCGC_HeureFin__c, inwiCGC_Jours__c, inwiCGC_JourMensuelle__c, inwiCGC_Periodicite__c, inwiCGC_RVR_RDZ__c, inwiCGC_Retail_Store__c FROM inwiCGC_RecurrenceVisites__c WHERE inwiCGC_DateDebutPeriodicite__c <= TODAY AND inwiCGC_DateFinPeriodicite__c >= TODAY';
    }
    
    public Database.querylocator start(Database.BatchableContext BC){   
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<inwiCGC_RecurrenceVisites__c> scope){
        String[] jours;
        List<Visit> visits = new List<Visit>();
        Visit visit;
        Date dayVisit;
        for (inwiCGC_RecurrenceVisites__c item : scope) {
            if (item.inwiCGC_Periodicite__c == 'Mensuelle') {
                Date monthStart = date.today().toStartofMonth();
                system.debug(item.inwiCGC_JourMensuelle__c);
                if (date.today() < monthStart.addDays(Integer.ValueOf(item.inwiCGC_JourMensuelle__c)-1)) {
                    visit = New visit();
                    dayVisit = monthStart.addDays(Integer.ValueOf(item.inwiCGC_JourMensuelle__c)-1);
                    system.debug('IF' +dayVisit);
                    visit.PlannedVisitStartTime = DateTime.newInstance(dayVisit.year(), dayVisit.month(), dayVisit.day(), item.inwiCGC_HeureDebut__c.hour(), item.inwiCGC_HeureDebut__c.minute(), item.inwiCGC_HeureDebut__c.second());
                    visit.PlannedVisitEndTime = DateTime.newInstance(dayVisit.year(), dayVisit.month(), dayVisit.day(), item.inwiCGC_HeureFin__c.hour(), item.inwiCGC_HeureFin__c.minute(), item.inwiCGC_HeureFin__c.second());
                    visit.PlaceId = item.inwiCGC_Retail_Store__c; 
                    visit.VisitorId = item.inwiCGC_RVR_RDZ__c;  
                    visits.add(visit);
                }
                else {
                    visit = New visit();
                    dayVisit = monthStart.addDays(Integer.ValueOf(item.inwiCGC_JourMensuelle__c)-1).addMonths(1);
                    system.debug('ELSE' +dayVisit);
                    visit.PlannedVisitStartTime = DateTime.newInstance(dayVisit.year(), dayVisit.month(), dayVisit.day(), item.inwiCGC_HeureDebut__c.hour(), item.inwiCGC_HeureDebut__c.minute(), item.inwiCGC_HeureDebut__c.second());
                    visit.PlannedVisitEndTime = DateTime.newInstance(dayVisit.year(), dayVisit.month(), dayVisit.day(), item.inwiCGC_HeureFin__c.hour(), item.inwiCGC_HeureFin__c.minute(), item.inwiCGC_HeureFin__c.second());
                    visit.PlaceId = item.inwiCGC_Retail_Store__c; 
                    visit.VisitorId = item.inwiCGC_RVR_RDZ__c;  
                    visits.add(visit); 
                }
            }
            else if (item.inwiCGC_Periodicite__c == 'Hebdomadaire') {
                jours = item.inwiCGC_Jours__c.split(';');
                Integer daysUntilNext;
                datetime dt;
                Integer dayOfWeek;
                    for (String jour : jours) {
                        system.debug(jour);
                        visit = New visit();
                        Date weekStart = date.today().toStartofWeek();
                        if (weekStart > date.today()) {
                            dayOfWeek = weekStart.daysBetween(date.Today());
                            daysUntilNext = 7-dayOfWeek+Integer.valueOf(jour);
                        }
                        else {
                            weekStart = date.today().addDays(7).toStartofWeek();
                            dayOfWeek = weekStart.daysBetween(date.Today());
                            daysUntilNext = 7-dayOfWeek+Integer.valueOf(jour);
                        }
                        
                        system.debug(daysUntilNext);
                        dayVisit = date.today().addDays(daysUntilNext);
                        visit.PlannedVisitStartTime = DateTime.newInstance(dayVisit.year(), dayVisit.month(), dayVisit.day(), item.inwiCGC_HeureDebut__c.hour(), item.inwiCGC_HeureDebut__c.minute(), item.inwiCGC_HeureDebut__c.second());
                        visit.PlannedVisitEndTime = DateTime.newInstance(dayVisit.year(), dayVisit.month(), dayVisit.day(), item.inwiCGC_HeureFin__c.hour(), item.inwiCGC_HeureFin__c.minute(), item.inwiCGC_HeureFin__c.second());
                        visit.PlaceId = item.inwiCGC_Retail_Store__c; 
                        visit.VisitorId = item.inwiCGC_RVR_RDZ__c;  
                        visits.add(visit);
                    }
            }
        }
        Insert visits;   
    }
    
    public void finish(Database.BatchableContext BC){
        AsyncApexJob a = [SELECT a.TotalJobItems, a.Status, a.NumberOfErrors, a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById, a.CompletedDate
                          FROM AsyncApexJob a
                          WHERE id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] email = new String[]{''};
            mail.setToAddresses(email);
        mail.setReplyTo('');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed'+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    
}