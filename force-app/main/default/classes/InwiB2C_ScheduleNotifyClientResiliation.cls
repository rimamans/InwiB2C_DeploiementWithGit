global class InwiB2C_ScheduleNotifyClientResiliation implements Schedulable {
    global void execute(SchedulableContext sc) {
        InwiB2C_NotifyClientBeforeResiliation b = new InwiB2C_NotifyClientBeforeResiliation(); 
       database.executebatch(b);
    }
 }