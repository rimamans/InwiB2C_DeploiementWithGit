trigger inwiB2C_SaveQueueId on inwiB2C_ProfileQueueMgt__c (before insert , before update) {

   List <Group> queueList =  [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'];

   Map<String,String> queueByNameMap = new Map<String,String> ();

   for (Group queue:queueList){

        if (! queueByNameMap.containsKey(queue.Name) ){
            queueByNameMap.put(queue.Name, queue.Id);
        }
   }

   for (inwiB2C_ProfileQueueMgt__c profileQueue: Trigger.new){

        profileQueue.inwiB2CQueue_Id__c = queueByNameMap.get(profileQueue.inwiB2C_Queue__c);
   }

}