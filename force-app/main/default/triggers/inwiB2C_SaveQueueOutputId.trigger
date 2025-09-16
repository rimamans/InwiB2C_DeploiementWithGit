trigger inwiB2C_SaveQueueOutputId on BOLevel2Profiles__c (before insert , before update) {

   List <Group> queueList =  [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'];
system.debug(queueList +'queuelist');


   Map<String,String> queueByNameMap = new Map<String,String> ();
   system.debug('start');

   for (Group queue:queueList){
     system.debug('pllll');

        if (! queueByNameMap.containsKey(queue.Name) ){
            queueByNameMap.put(queue.Name, queue.Id);
        }
   }

   for (BOLevel2Profiles__c Level2Queue: Trigger.new){

        Level2Queue.QueueOutputId__c = queueByNameMap.get(Level2Queue.QueueOutput__c);
   }
}