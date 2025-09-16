public class inwiCGC_DemandeDeVisiteRoleController {
    @AuraEnabled(cacheable=true)
    public static String getRoleHierarchy(Id recordId) {
        Map<String, Object> response = new Map<String, Object>();
        System.debug('id'+ recordId);
        inwiCGC_DemandeDeVisite__c demandeVisite = [Select id, OwnerId from inwiCGC_DemandeDeVisite__c Where id =: recordId  LIMIT 1];   
        System.debug('demandeVisite '+demandeVisite);
        User currentRole = [select Name, id, UserRoleId, UserRole.Name from User where id =: demandeVisite.OwnerId LIMIT 1];
        System.debug('currentRole '+currentRole);
        List<UserRole> subordinateRoles = [SELECT Id, Name FROM UserRole WHERE PortalType = 'None' AND ParentRoleId=:currentRole.UserRoleId];
        UserRole rootRole = [SELECT Id, Name FROM UserRole WHERE Id = :currentRole.UserRoleId LIMIT 1];
        NodeRole nodes = constructTree(rootRole);
        response.put('treeRoles', nodes);
        response.put('ownerRole', currentRole.UserRole.Name);
        List<Map<String, Object>> descendantRoles = new List<Map<String, Object>>();
        for (UserRole descendant : subordinateRoles) {
            Map<String, Object> roleInfo = new Map<String, Object>();
            roleInfo.put('id', descendant.Id);
            roleInfo.put('label', descendant.Name);
            roleInfo.put('isChecked', false);
            descendantRoles.add(roleInfo);
        }
        response.put('descendantRoles', descendantRoles);
        
        return JSON.serialize(response);
    }
    
    
    @AuraEnabled
    public static Map<String, Object> createDemandesVisite(String selectedRolesJson, Id recordId) {
        System.debug('selectedRolesJson' + selectedRolesJson);
        List<NodeRole> selectedRoles = (List<NodeRole>) JSON.deserialize(selectedRolesJson, List<NodeRole>.class);
        System.debug('selectedRoles' + selectedRoles);
        Map<Id, String[]> roleInfoMap = new Map<Id, String[]>();
        List<String> roleIds = new List<String>();
        for (NodeRole role : selectedRoles) {
            if(role.isChecked == true){
                System.debug('role.isChecked' + role.isChecked);
                roleIds.add(role.id); 
                // Added additional fields: Objectif_SIM, Objectif_SIM_Dealer, Objectif_SC
                roleInfoMap.put(role.Id, new String[]{
                    role.Objectif_SIM,
                    role.Objectif_SIM_Dealer,
                    role.Objectif_SC
                });
            }   
        }
        List<User> subordinateUsers;
        if (isCasaRoleSelected(roleIds)) {
            subordinateUsers = [SELECT Id, UserRoleId, UserRole.Name FROM User WHERE IsActive = true AND Profile.Name = 'CGC_RVR' AND UserRoleId IN :roleIds];
        } else {
            subordinateUsers = [SELECT Id, UserRoleId, UserRole.Name FROM User WHERE IsActive = true AND UserRoleId IN :roleIds];
        }
        System.debug('subordinateUsers' + subordinateUsers);
        Map<String, Object> response = new Map<String, Object>();    
        List<String> errorMessages = new List<String>();
        List<UserWithRoleInfo> usersWithRoleInfo = new List<UserWithRoleInfo>();
        
        try {
            if (!subordinateUsers.isEmpty()) {
                inwiCGC_DemandeDeVisite__c demandeVisite = [Select id, Name, OwnerId, Planned_End_Time__c, Planned_Start_Time__c, Status__c, inwiCGC_TypeObjectif__c from inwiCGC_DemandeDeVisite__c Where id =: recordId  LIMIT 1];  
                for (User user : subordinateUsers) {
                    UserWithRoleInfo userWithRoleInfo = new UserWithRoleInfo();
                    userWithRoleInfo.userId = user.Id;
                    userWithRoleInfo.userRoleId = user.UserRoleId;
                    userWithRoleInfo.userRoleName = user.UserRole.Name;
                    if (roleInfoMap.containsKey(user.UserRoleId)) {
                        String[] roleInfo = roleInfoMap.get(user.UserRoleId);
                        userWithRoleInfo.objectifSIM = roleInfo[0]; // Added 10/06/2024 by Soufiane BOUTKHIL
                        userWithRoleInfo.objectifSIMDealer = roleInfo[1]; // Added 10/06/2024 by Soufiane BOUTKHIL
                        userWithRoleInfo.objectifSC = roleInfo[2]; // Added 10/06/2024 by Soufiane BOUTKHIL
                    } else {    
                        userWithRoleInfo.objectifSIM = ''; // Added 10/06/2024 by Soufiane BOUTKHIL
                        userWithRoleInfo.objectifSIMDealer = ''; // Added 10/06/2024 by Soufiane BOUTKHIL
                        userWithRoleInfo.objectifSC = ''; // Added 10/06/2024 by Soufiane BOUTKHIL
                    }    
                    usersWithRoleInfo.add(userWithRoleInfo);
                }
                
                List<inwiCGC_DemandeDeVisite__c> duplicateDemandes = duplicateDemande(demandeVisite, usersWithRoleInfo);
                System.debug('duplicateDemandes' + duplicateDemandes);
                Database.SaveResult[] results = Database.insert(duplicateDemandes, false);
                System.debug('results' + results);
                
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()) {
                        List<Database.Error> errors = result.getErrors();
                        for (Database.Error error : errors) {
                            String errorMessage = error.getMessage();
                            errorMessages.add(errorMessage);
                        }
                        response.put('messages', errorMessages);
                        response.put('response', false);
                        return response;
                    }
                }
                response.put('response', true);
                demandeVisite.Status__c = 'inwiCGC_Valide';
                update demandeVisite;
            }
            else {
                errorMessages.add('Aucun utilisateur avec les roles sélectionné n\'as été trouvé');
                response.put('message', errorMessages);
                response.put('response', false);
                return response;
            }
        }
        catch (Exception e) {       
            response.put('response', false);
            errorMessages.add(e.getMessage());
            System.debug('Error Message: ' + e.getMessage());
            response.put('message', errorMessages);
            return response;
        }
        return response;
    }
    
    private static Boolean isCasaRoleSelected(List<String> roleIds) {
        Set<String> casaRoles = new Set<String>{'Casa 1', 'Casa 2', 'Casa 3', 'Casa 4', 'Casa 5'};
        for (String roleId : roleIds) {
            UserRole role = [SELECT Id, Name FROM UserRole WHERE Id = :roleId LIMIT 1];
            if (casaRoles.contains(role.Name)) {
                return true;
            }
        }
        return false;
    }
    
        
    public class NodeRole {
        @AuraEnabled public String id;
        @AuraEnabled public String label;
        @AuraEnabled public List<NodeRole> children;
        @AuraEnabled public Boolean isChecked = false;
        @AuraEnabled public String Descriptif;
        @AuraEnabled public String Objectif;
        @AuraEnabled public String objectif_SIM; // New 10/06/2024
        @AuraEnabled public String objectif_SIM_Dealer; // New 10/06/2024
        @AuraEnabled public String objectif_SC; // New 10/06/2024
    }
    
    public class UserWithRoleInfo {
        @AuraEnabled public Id userId;
        @AuraEnabled public Id userRoleId;
        @AuraEnabled public String userRoleName;
        @AuraEnabled public String objectifSIM; // Added 10/06/2024 by Soufiane BOUTKHIL
        @AuraEnabled public String objectifSIMDealer; // Added 10/06/2024 by Soufiane BOUTKHIL
        @AuraEnabled public String objectifSC; // Added 10/06/2024 by Soufiane BOUTKHIL
    }
  
    
    public static List<inwiCGC_DemandeDeVisite__c> duplicateDemande(inwiCGC_DemandeDeVisite__c demandeVisite, List<UserWithRoleInfo> users) {
        List<inwiCGC_DemandeDeVisite__c> duplicatedRecords = new List<inwiCGC_DemandeDeVisite__c>();        
        for (UserWithRoleInfo user : users) {
            inwiCGC_DemandeDeVisite__c duplicatedDemande = demandeVisite.clone(false, true, false, false);
            duplicatedDemande.OwnerId = user.userId;
            duplicatedDemande.Name = user.userRoleName + ' - ' + demandeVisite.Name;
            duplicatedDemande.Status__c = 'inwiCGC_EnCours'; 
            duplicatedDemande.Planned_Start_Time__c = demandeVisite.Planned_Start_Time__c;
            duplicatedDemande.Planned_End_Time__c = demandeVisite.Planned_End_Time__c;
            duplicatedDemande.Parent__c = demandeVisite.id;
            duplicatedDemande.inwiCGC_TypeObjectif__c = demandeVisite.inwiCGC_TypeObjectif__c;
            duplicatedDemande.inwiCGC_Objectif_SIM__c = Decimal.valueOf(user.objectifSIM); 
            duplicatedDemande.inwiCGC_Objectif_SIM_Dealer__c = Decimal.valueOf(user.objectifSIMDealer);
            duplicatedDemande.inwiCGC_Objectif_SC__c = Decimal.valueOf(user.objectifSC);

            duplicatedRecords.add(duplicatedDemande);
        }
        return duplicatedRecords;
    }
    
    /* private static NodeRole constructTree(UserRole role) {
NodeRole node = new NodeRole();
node.id = role.Id;
node.label = role.Name;
//node.children = new List<NodeRole>();

List<UserRole> childRoles = [SELECT Id, Name FROM UserRole WHERE ParentRoleId = :role.Id];

if (!childRoles.isEmpty()) {
node.children = new List<NodeRole>();
for (UserRole childRole : childRoles) {
node.children.add(constructTree(childRole));
}
}
return node;
}*/
    public static NodeRole constructTree(UserRole role) {
        NodeRole rootNode = new NodeRole();
        rootNode.id = role.Id;
        rootNode.label = role.Name;
        rootNode.children = new List<NodeRole>();
        Map<Id, List<UserRole>> childRolesMap = new Map<Id, List<UserRole>>();
        for (UserRole childRole : [SELECT Id, Name,PortalType, ParentRoleId FROM UserRole]) {   
            
            if(childRole.ParentRoleId == role.Id && childRole.PortalType == 'None'){
                if (!childRolesMap.containsKey(childRole.ParentRoleId)) {
                    childRolesMap.put(childRole.ParentRoleId, new List<UserRole>());
                }
                childRolesMap.get(childRole.ParentRoleId).add(childRole);
            }
        }
        fetchChildRoles(rootNode, role.Id, childRolesMap);
        return rootNode;
    }
    
    private static void fetchChildRoles(NodeRole parentNode, Id parentRoleId, Map<Id, List<UserRole>> childRolesMap) {
        if (childRolesMap.containsKey(parentRoleId)) {
            for (UserRole childRole : childRolesMap.get(parentRoleId)) {
                NodeRole childNode = new NodeRole();
                childNode.id = childRole.Id;
                childNode.label = childRole.Name;
                childNode.children = new List<NodeRole>();
                parentNode.children.add(childNode);           
                //fetchChildRoles(childNode, childRole.Id, childRolesMap); // tree
            }
        }
    }
}