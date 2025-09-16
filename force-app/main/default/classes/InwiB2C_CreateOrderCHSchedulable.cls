global class InwiB2C_CreateOrderCHSchedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
        InwiB2C_CreateOrderCH_TechnlogieBatch b = new InwiB2C_CreateOrderCH_TechnlogieBatch(); 
        database.executebatch(b,100);
        
     }
}