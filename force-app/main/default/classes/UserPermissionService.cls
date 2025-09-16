global class UserPermissionService implements vlocity_cmt.VlocityOpenInterface {

    @future
    public static void assignPermissionSetLicensesFuture(String userId) {
        try {
            if (String.isBlank(userId)) {
                throw new IllegalArgumentException('L\'ID de l\'utilisateur est requis.');
            }

            // Les noms des Permission Set Licenses à récupérer
            List<String> permSetLicenseNames = new List<String>{'ActionPlansPsl','IndustriesVisitPsl', 'LightningRetailExecutionStarterPsl', 'SFMaps_Maps_Advanced', 'SFMaps_Maps_LiveMobileTracking'};

            // Récupérer les IDs des Permission Set Licenses en fonction des noms
            List<PermissionSetLicense> permSetLicenseList = [
                SELECT Id, DeveloperName 
                FROM PermissionSetLicense 
                WHERE DeveloperName IN :permSetLicenseNames
            ];

            if (permSetLicenseList.isEmpty()) {
                throw new IllegalArgumentException('Aucun des Permission Set Licenses spécifiés n\'a été trouvé.');
            }

            List<PermissionSetLicenseAssign> pslaList = new List<PermissionSetLicenseAssign>();

            for (PermissionSetLicense permSetLicense : permSetLicenseList) {
                PermissionSetLicenseAssign psla = new PermissionSetLicenseAssign(
                    AssigneeId = userId,
                    PermissionSetLicenseId = permSetLicense.Id
                );
                pslaList.add(psla);
            }

            insert pslaList;

        } catch (DmlException e) {
            System.debug('Erreur lors de l\'attribution des Permission Set Licenses : ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Erreur inattendue : ' + e.getMessage());
        }
    }

    @future 
    public static void assignPermissionSetsFuture(String userId, String userType, String produit) {
        try {
            if (String.isBlank(userId) || String.isBlank(userType)) {
                throw new IllegalArgumentException('L\'ID de l\'utilisateur et le type d\'utilisateur sont requis.');
            }

            // Les noms des Permission Sets à récupérer
            List<String> permSetNames = new List<String>{'ActionPlans','LightningRetailExecutionStarterPsl','CGCloud_Mobility_Addon','CGCloud_Sales_User','Sync_User', 'MapsUser','Advanced','LiveMobile'};
                
            if (userType == 'Livreur') {
                permSetNames.add('fdvlivreuradsl');
            }
            if(produit == 'ADSL') {
                 permSetNames.add('fdvanimateuradsl');
            }else if (produit== 'FTTH'){
                 permSetNames.add('fdvanimateurftth');
            }

            // Récupérer les IDs des Permission Sets en fonction des noms
            List<PermissionSet> permSetList = [
                SELECT Id, Name 
                FROM PermissionSet 
                WHERE Name IN :permSetNames
            ];

            if (permSetList.isEmpty()) {
                throw new IllegalArgumentException('Aucun des Permission Sets spécifiés n\'a été trouvé.');
            }

            List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();

            for (PermissionSet permSet : permSetList) {
                PermissionSetAssignment psa = new PermissionSetAssignment(
                    AssigneeId = userId,
                    PermissionSetId = permSet.Id
                );
                psaList.add(psa);
            }

            insert psaList;

        } catch (DmlException e) {
            System.debug('Erreur lors de l\'attribution des Permission Sets : ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Erreur inattendue : ' + e.getMessage());
        }
    }

    public Boolean invokeMethod(String methodName, 
                                Map<String, Object> input, 
                                Map<String, Object> outMap, 
                                Map<String, Object> options) {
                                    
        if (methodName.equals('AssignPermissionSetLicenses')) {
            try {
                String userId = (String) input.get('UserId');
                
                if (String.isBlank(userId)) {
                    outMap.put('status', 'L\'ID de l\'utilisateur est vide ou null.');
                    return false;
                }
                
                // Appel de la méthode future pour les Permission Set Licenses
                UserPermissionService.assignPermissionSetLicensesFuture(userId);
                
                outMap.put('status', 'Les Permission Set Licenses seront assignés à l\'utilisateur.');
                
            } catch (Exception e) {
                outMap.put('status', 'Erreur inattendue : ' + e.getMessage());
                return false;
            }
        } else if (methodName.equals('AssignPermissionSets')) {
            try {
                String userId = (String) input.get('UserId');
                String userType = (String) input.get('TypeUser');
                String produit = (String) input.get('Produit') ;
                
                if (String.isBlank(userId) || String.isBlank(userType)) {
                    outMap.put('status', 'L\'ID de l\'utilisateur ou le type d\'utilisateur est vide ou null.');
                    return false;
                }
                
                // Appel de la méthode future pour les Permission Sets
                UserPermissionService.assignPermissionSetsFuture(userId, userType, produit);
                
                outMap.put('status', 'Les Permission Sets seront assignés à l\'utilisateur.');
                
            } catch (Exception e) {
                outMap.put('status', 'Erreur inattendue : ' + e.getMessage());
                return false;
            }
        } else {
            outMap.put('status', 'Méthode non trouvée : ' + methodName);
            return false;
        }
        
        return true;
    }
}