global class InwiB2C_Schedule_CreateMigratedSubs implements Schedulable {
   global void execute(SchedulableContext sc) {
      inwiB2C_CAM_CreateMigratedSubscriptions  b = new inwiB2C_CAM_CreateMigratedSubscriptions (); 
      database.executebatch(b);
   }

}