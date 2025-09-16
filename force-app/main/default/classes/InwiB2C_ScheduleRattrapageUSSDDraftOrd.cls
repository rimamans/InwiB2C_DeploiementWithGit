global class InwiB2C_ScheduleRattrapageUSSDDraftOrd implements Schedulable {
    global void execute(SchedulableContext sc) {
        InwiB2C_RattrapageUSSDDraftOrder b = new InwiB2C_RattrapageUSSDDraftOrder(); 
        database.executebatch(b,100);
        
     }
}