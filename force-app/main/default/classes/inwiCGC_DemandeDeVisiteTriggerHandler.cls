public class inwiCGC_DemandeDeVisiteTriggerHandler {
    private static Boolean isExecuting = false;
    public void afterUpdate(inwiCGC_DemandeDeVisite__c demandeVisite){
        if (!isExecuting) {
            if ((demandeVisite.Status__c == 'inwiCGC_Valide') && (demandeVisite.inwiCGC_CreationAutomatique__c == true)) {
                isExecuting = true;
                User currentRole = [select Name, id, UserRoleId from User where id =: demandeVisite.OwnerId LIMIT 1];
                List<UserRole> subordinateRoles = [SELECT Id FROM UserRole WHERE PortalType = 'None' AND ParentRoleId=:currentRole.UserRoleId];
                List<User> subordinateUsers = [SELECT Id, UserRoleId, UserRole.Name FROM User WHERE IsActive=true AND profile.Name in('CGC_RVR', 'CGC_FDV_Manager') AND UserRoleId=:subordinateRoles];
                if (!subordinateRoles.isEmpty()) {
                    List<inwiCGC_DemandeDeVisite__c> duplicateDemandes = duplicateDemande(demandeVisite, subordinateUsers);
                    insert duplicateDemandes;
                    isExecuting = false;
                }
            }
        }
    }
    
    public static List<inwiCGC_DemandeDeVisite__c> duplicateDemande(inwiCGC_DemandeDeVisite__c  demandeVisite, List<User> users) {
        List<inwiCGC_DemandeDeVisite__c> duplicatedRecords = new List<inwiCGC_DemandeDeVisite__c>();
        for (User user : users) {
            inwiCGC_DemandeDeVisite__c duplicatedDemande = demandeVisite.clone(false, true, false, false);
            duplicatedDemande.Name = user.UserRole.Name + ' - ' + demandeVisite.name;
            duplicatedDemande.OwnerId = user.Id;
            duplicatedDemande.Status__c = 'inwiCGC_EnCours'; 
            duplicatedDemande.Parent__c = demandeVisite.id;
            duplicatedRecords.add(duplicatedDemande);
        }
        return duplicatedRecords;
    }
}