trigger inwiB2C_DepassementOLA on Case (after update ) {

    Map<Id, Case> caseOldMap = Trigger.oldMap;
   

    List<Task> taskList = new List<Task> ();


    for(Case caseNew:Trigger.new)
    {
        system.debug('for');
        Case oldCase = caseOldMap.get(caseNew.Id);
    system.debug(oldCase +'oldcase');
        if (caseNew.Depacement_OLA__c  && !oldCase.Depacement_OLA__c &&(((String)caseNew.OwnerId).contains('005')) ) {
            User user = [Select ManagerId from User where Id = :caseNew.ownerId ];

            String parentNotification = (user.ManagerId !=null)? user.ManagerId: caseNew.ownerId;
system.debug( 'aaa');

            Task newTask = new Task ();
            newTask.WhatId = caseNew.Id;

            newTask.Subject = 'Le Case suivant est de dépassement de OLA';
            newTask.Status = 'Open';
            newTask.Priority = 'High';

            newTask.OwnerId = parentNotification;


            taskList.add(newTask);

            

        }
    }

    /*if (FeedItemList.size()>0) {         
        insert FeedItemList;                
    }   */

    if (taskList.size()>0){
        insert taskList;
    }

}