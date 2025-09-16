global class inwiB2C_ScheduleManageIdarSuspBatch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
          inwiB2C_ManageIdarSuspensionBatch b = new inwiB2C_ManageIdarSuspensionBatch(); 
          database.executebatch(b);
       }
}