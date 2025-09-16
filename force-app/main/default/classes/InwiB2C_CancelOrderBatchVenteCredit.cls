global class  InwiB2C_CancelOrderBatchVenteCredit implements Schedulable {
   global void execute(SchedulableContext sc) {
      InwiB2C_BatchCancelOrderVenteCredit b = new InwiB2C_BatchCancelOrderVenteCredit(); 
      database.executebatch(b);
   }
}