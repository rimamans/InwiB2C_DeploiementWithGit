global class inwib2c_ScheduleIdent implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new InwiB2C_IdentificationPDV48hBatch());
    }
}