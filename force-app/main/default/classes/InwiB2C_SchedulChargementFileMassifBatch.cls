global class InwiB2C_SchedulChargementFileMassifBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        InwiB2C_ChargementFileMassifBatch b =new InwiB2C_ChargementFileMassifBatch();
        database.executebatch(b);
    }
}