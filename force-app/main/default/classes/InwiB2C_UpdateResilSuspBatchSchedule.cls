public class InwiB2C_UpdateResilSuspBatchSchedule implements Schedulable {
    public void execute(SchedulableContext sc) {
        InwiB2C_UpdateResiliationSuspensionBatch b = new InwiB2C_UpdateResiliationSuspensionBatch();
        Database.executeBatch(b);
    }
}