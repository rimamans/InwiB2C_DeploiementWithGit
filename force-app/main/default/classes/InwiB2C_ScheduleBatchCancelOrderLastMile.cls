global class InwiB2C_ScheduleBatchCancelOrderLastMile implements Schedulable {
    global void execute(SchedulableContext sc) {
        InwiB2C_BatchCancelOrderLastMile b = new InwiB2C_BatchCancelOrderLastMile(); 
       database.executebatch(b);
    }
 }