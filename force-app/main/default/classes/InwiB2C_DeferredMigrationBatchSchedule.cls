public class InwiB2C_DeferredMigrationBatchSchedule implements Schedulable{
	public void execute(SchedulableContext sc) {
      InwiB2C_DeferredMigrationBatch b = new InwiB2C_DeferredMigrationBatch(); 
      database.executebatch(b);
   }
}