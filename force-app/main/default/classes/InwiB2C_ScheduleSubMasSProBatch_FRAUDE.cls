global class InwiB2C_ScheduleSubMasSProBatch_FRAUDE implements Schedulable { 
        global void execute(SchedulableContext sc) {
            InwiB2C_SubsMassProcessingBatch_Fraude b = new InwiB2C_SubsMassProcessingBatch_Fraude(); 
           database.executebatch(b);
        }
}