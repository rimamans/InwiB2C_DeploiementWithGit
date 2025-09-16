global class InwiB2C_ScheduleSubsMassProcesBatch_IMX implements Schedulable {
    global void execute(SchedulableContext sc) {
        InwiB2C_SubsMassProcessingBatch_IMX b = new InwiB2C_SubsMassProcessingBatch_IMX(); 
       database.executebatch(b);
    }
 }