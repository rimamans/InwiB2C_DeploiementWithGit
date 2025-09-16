global class inwiB2C_SchuExecAsyncLimitedAPIBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        inwiB2C_ExecAsyncLimitedAPIBatch b = new inwiB2C_ExecAsyncLimitedAPIBatch(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
        rescheduleJob();
    }



private void rescheduleJob(){
        
    inwiB2C_SchuExecAsyncLimitedAPIBatch scheduledJob = new inwiB2C_SchuExecAsyncLimitedAPIBatch();
      Datetime sysTime = System.now().addMinutes(30);
      String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
      System.schedule('inwiB2C_SchuExecAsyncLimitedAPIBatch', cronExpression ,scheduledJob);
  }
}