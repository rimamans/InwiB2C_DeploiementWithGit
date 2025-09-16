global class InwiB2C_ScheduleResiliateRequestBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        InwiB2C_ResiliateRequestBatch b = new InwiB2C_ResiliateRequestBatch(); 
       database.executebatch(b);
    }
 }