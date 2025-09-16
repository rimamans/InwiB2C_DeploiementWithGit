/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger InwiB2C_OrderSharingRulesTrigger on Order (after insert, after update){
    /*String UserContact;
     String UserAccount;
     List<String> UsersSameAgence = new List<String>();
     List<String> UsersOtherAgence = new List<String>();
     List<String> ContactSameAccount = new List<String>();
     List<String> ContactOtherAccount = new List<String>();
     List<OrderShare> OrderSharesList = new List<OrderShare>();
     //All Lists of Users, Accounts and Contacts to avoid SOQL inside loops
     List<User> UsersList= [Select Id, ContactId, Contact.AccountId from User where ContactId != ''];
     List<Account> AccountList = [Select Id from Account];
     List<Contact> ContactList = [Select Id, AccountId from Contact where AccountId != ''];*/
    // Jawad-L Start
    List<OrderShare> OrderSharesList = new List<OrderShare>();
    // Build List on Order Contact Id
    List<Id> OrderContactIdList = new List<Id>();
    for (Order currentOrder : Trigger.new ){
        OrderContactIdList.add(currentOrder.OwnerId);
    }
    // Get List of Order Users
    List<User> UserList = [Select Id, ContactId, Contact.AccountId, UserRoleId
                            from User
                            where Id in:OrderContactIdList and UserRole.DeveloperName != 'Generique'];
    Map<Id, User> userListMap = new Map<Id, User>();
    List<Id> roleList = new List<Id>();
    for (User currentUser : UserList){
        userListMap.put(currentUser.Id, currentUser);
        roleList.add(currentUser.UserRoleId);
    }
    Map<Id, List<User>> usersByRole = new Map<Id, List<User>>();
    List<User> userRoleList = [Select Id, ContactId, Contact.AccountId, UserRoleId
                               from User
                               where UserRoleId in:roleList and IsActive = true];
    for (User userRole : userRoleList){
        if (usersByRole.containsKey(userRole.UserRoleId)){
            List<User> tempUserList = usersByRole.get(userRole.UserRoleId);
            tempUserList.add(userRole);
        } else{
            List<User> tempUserList = new List<User>();
            tempUserList.add(userRole);
            usersByRole.put(userRole.UserRoleId, tempUserList);
        }
    }
    // Get Id of the all User custom Group
    Group allUsersGroup = [select id, Name
                           from Group
                           where Name = 'inwiB2C_AllUsers'];


  //MHA B-18532 20240722 Start

    // Collect Order IDs from Trigger
    Set<Id> orderIds = new Set<Id>();
    for (Order order : Trigger.new) {
        orderIds.add(order.Id);
        System.debug('Order ID: ' + order.Id);
    }

    // Query Orders to get queue information
    Map<Id, String> orderToQueueMap = new Map<Id, String>();
    List<Order> ordersWithQueue = [SELECT Id, inwib2c_Partenaire__r.InwiB2C_CelluleBO__r.InwiB2C_Queue__c,inwib2c_Partenaire__r.InwiB2C_AgenceValidationBO__r.InwiB2C_Queue__c 
                                   FROM Order
                                   WHERE Id IN :orderIds];
    System.debug('OrdersWithQueue: ' + ordersWithQueue);

    for (Order order : ordersWithQueue) {
        /*DLE  MGEN3631 25/01/2025 begin */
        // String queueName = order.inwib2c_Partenaire__r.InwiB2C_CelluleBO__r.InwiB2C_Queue__c;
        String queueName = order.inwib2c_Partenaire__r.InwiB2C_AgenceValidationBO__r.InwiB2C_Queue__c;
         /*DLE MGEN3631 25/01/2025 end */
        orderToQueueMap.put(order.Id, queueName);
        System.debug('Queue Name for Order ' + order.Id + ': ' + queueName);
    }

    // Retrieve Group IDs based on queue names
    Map<String, Id> queueNameToIdMap = new Map<String, Id>();
    List<Group> groupList = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN :orderToQueueMap.values()];
    System.debug('GroupList: ' + groupList);

    for (Group grp : groupList) {
        queueNameToIdMap.put(grp.DeveloperName, grp.Id);
    }
    System.debug('QueueNameToIdMap: ' + queueNameToIdMap);

  //MHA  B-18532 20240722  End


    //Manage Access for Order
    for (Order currentOrder : Trigger.new ){
        if (currentOrder.inwiB2C_Canal__c != 'inwiB2C_USSD' && currentOrder.inwiB2C_Canal__c != 'inwiB2C_FirstCall' && currentOrder.inwiB2C_Canal__c != 'inwiB2C_DIGITAL' && currentOrder.inwiB2C_Canal__c != 'inwiB2C_Dealer' ){
            // (or) type commande != acquisition
            // MHA B-14422 20240719 replaced call 
            //if (currentOrder.inwib2c_TypeDeLaCommande__c != 'inwiB2C_Acquisition' || currentOrder.inwiB2C_Statut__c == 'inwiB2C_Activee' || currentOrder.inwiB2C_Statut__c == 'inwiB2C_Activation' || currentOrder.inwiB2C_Statut__c == 'inwiB2C_Conforme' || currentOrder.inwiB2C_Statut__c == 'inwiB2C_NonConforme' || (currentOrder.inwib2c_TypeDeLaCommande__c == 'inwiB2C_Acquisition'  && currentOrder.inwiB2C_Canal__c == 'inwiB2C_Eshop') ||(currentOrder.inwib2c_TypeDeLaCommande__c == 'inwiB2C_Acquisition'  && currentOrder.inwiB2C_Canal__c=='inwiB2C_D2D' && currentOrder.InwB2C_Statut_livraison_D2D__c == 'Inwib2c_Commande_A_Livrer')|| (currentOrder.inwib2c_TypeDeLaCommande__c == 'inwiB2C_Acquisition'  && currentOrder.inwiB2C_Canal__c == 'inwiB2C_Televente') ){
            if (currentOrder.inwib2c_TypeDeLaCommande__c != 'inwiB2C_Acquisition' || currentOrder.inwiB2C_Statut__c == 'inwiB2C_Activee' || currentOrder.inwiB2C_Statut__c == 'inwiB2C_Activation' || currentOrder.inwiB2C_Statut__c == 'inwiB2C_Conforme' || currentOrder.inwiB2C_Statut__c == 'inwiB2C_NonConforme' || (currentOrder.inwib2c_TypeDeLaCommande__c == 'inwiB2C_Acquisition'  && currentOrder.inwiB2C_Canal__c == 'inwiB2C_Eshop') ||(currentOrder.inwib2c_TypeDeLaCommande__c == 'inwiB2C_Acquisition'  && currentOrder.inwiB2C_Canal__c == 'inwiB2C_Televente') ){
               
             
                //Grant Access to All
                OrderShare cs = new OrderShare();
                cs.OrderId = currentOrder.Id;
                cs.UserOrGroupId = allUsersGroup.Id;
                cs.OrderAccessLevel = 'Edit';
                OrderSharesList.add(cs);
            }   

        //MHA  B-18532 20240722  start

            else if (currentOrder.inwiB2C_Canal__c == 'inwiB2C_D2D') {
              String queueName = orderToQueueMap.get(currentOrder.Id);
              System.debug('QueueName++++++' + currentOrder.Id + ': ' + queueName);
              Id queueId = queueNameToIdMap.get(queueName);
              if (queueId != null) {
                  OrderShare queueShare = new OrderShare();
                  queueShare.OrderId = currentOrder.Id;
                  queueShare.UserOrGroupId = queueId;
                  queueShare.OrderAccessLevel = 'Edit';
                  OrderSharesList.add(queueShare);
                  System.debug('Added OrderShare for queue: ' + queueShare);
              } else {
                // à partir du owner, recuperer l'agence, puis récupérer l'agence BO, tu recupère la liste des utilisateurs des BO la liste des users du distributeur
                  System.debug('Queue ID not found for queue name: ' + queueName);
              }
              
          }
       // MHA  B-18532 20240722  End
         else{
                //Grant Access to POS Team
                User orderUser = userListMap.get(currentOrder.CreatedById);
                if (orderUser != null){
                    List<User> tempListOfUsersWithSameRole = usersByRole.get(orderUser.UserRoleId);
                    for (User tempUserWithSameRole : tempListOfUsersWithSameRole){
                        OrderShare cs = new OrderShare();
                        cs.OrderId = currentOrder.Id;
                        cs.UserOrGroupId = tempUserWithSameRole.Id;
                        cs.OrderAccessLevel = 'Edit';
                        OrderSharesList.add(cs);
                    }
                  
                }
                
            }
        }
    }
    // Jawad-L END
    /*
     for(Order c : Trigger.new) {
     //Get the contact of the user
     for (User u: UsersList)
     {
     if (u.Id == c.CreatedById)
     {
     UserContact = u.ContactId;
     UserAccount = contact.AccountId;
     break;
     }
     }
     //Get the Account of the user's Contact
     for (contact contact: ContactList)
     {
     if (UserContact == contact.Id)
     {
     UserAccount = contact.AccountId;
     break;
     }
     }
     //Get the contacts with the chosen account in a list 'ContactSameAccount' and the others on another list 'ContactOtherAccount'
     for (contact contact: ContactList)
     {
     if (UserAccount == contact.AccountId)
     {
     ContactSameAccount.add(contact.Id);
     }
     else
     {
     ContactOtherAccount.add(contact.Id);
     }
     }
     //Get the users having the same account on a list 'UsersSameAgence' and the other on another list 'UsersOtherAgence'
     for (User u: UsersList)
     {
     for (String cont: ContactSameAccount){
     if (cont == u.ContactId)
     {
     UsersSameAgence.add(u.Id);
     }
     }
     for (String con: ContactOtherAccount){
     if (con == u.ContactId)
     {
     UsersOtherAgence.add(u.Id);
     }
     }
     }
     //If INSERT, share order with Users having the same Contact - READ
     if (Trigger.isInsert)
     {
     for (String SameAgence: UsersSameAgence)
     {
     OrderShare cs = new OrderShare();
     cs.OrderId = c.Id;
     cs.UserOrGroupId = SameAgence; // hardcoding other user's id
     cs.OrderAccessLevel = 'Read';
     OrderSharesList.add(cs);
     }
     }
     //If STATUS has one of the 3 values, Share with other users - READ
     if (c.inwiB2C_Statut__c == 'inwiB2C_Activation' || c.inwiB2C_Statut__c == 'inwiB2C_Conforme' || c.inwiB2C_Statut__c == 'inwiB2C_NonConforme')
     {
     for (String OtherUser: UsersOtherAgence)
     {
     OrderShare cs = new OrderShare();
     cs.OrderId = c.Id;
     cs.UserOrGroupId = OtherUser; // hardcoding other user's id
     cs.OrderAccessLevel = 'Read';
     OrderSharesList.add(cs);
     }
     }
     }
     */
    //Insert the Order Sharing rules for the order(s) created
    if (OrderSharesList.size() > 0){
        Database.insert (OrderSharesList, false);
    }
}