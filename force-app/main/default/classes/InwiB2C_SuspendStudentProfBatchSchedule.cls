global class InwiB2C_SuspendStudentProfBatchSchedule  implements Schedulable {
	global void execute(SchedulableContext sc) {
      InwiB2C_SuspendStudentProfilBatch b = new InwiB2C_SuspendStudentProfilBatch(); 
      database.executebatch(b);
   }
}