public with sharing class Inwib2c_ScheduleCreateMassInventoryItems implements Schedulable {
   public void execute(SchedulableContext sc) {
      Inwib2c_CreateMassInventoryItems b = new Inwib2c_CreateMassInventoryItems(); 
      database.executebatch(b,200);
   }
}