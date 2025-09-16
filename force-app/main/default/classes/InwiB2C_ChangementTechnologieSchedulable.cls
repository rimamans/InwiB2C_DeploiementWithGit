global class InwiB2C_ChangementTechnologieSchedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
        InwiB2C_ChangementTechnologieBatch b = new InwiB2C_ChangementTechnologieBatch(); 
        database.executebatch(b);
        
     }
}