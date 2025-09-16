global class MyPicklistOptions implements vlocity_cmt.VlocityOpenInterface {

    public Boolean invokeMethod(String methodName, 
                                Map<String, Object> input, 
                                Map<String, Object> outMap, 
                                Map<String, Object> options) {
                                    
        if(methodName.equals('AccountNames')) {
            // extraire les valeurs TypeUser et Distributeur
            Map<String, Object> step1Map = (Map<String, Object>) input.get('Step1');
            Map<String, Object> step2Map = (Map<String, Object>) input.get('Step2');

            String typeUser = (String) step1Map.get('TypeUser');
            Id distributorId = (Id) step2Map.get('Distributeur');
            
            
            String sObjectApiName = 'Account'; // Objet dont on extrait

            String sQuery;
            if (String.isEmpty(typeUser)) {
                sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + 
                         ' WHERE RecordType.Name = \'Partenaire\' ' + 
                         'AND inwiB2C_TypePartenaire__c = \'inwiB2C_Agence\' ' + 
                         'ORDER BY CreatedDate DESC LIMIT 5';
                
            } else if (typeUser == 'Utilisateur BO') {
                sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + 
                         ' WHERE RecordType.Name = \'Partenaire\' ' + 
                         'AND inwiB2C_TypePartenaire__c = \'inwiB2C_Agence\' ' +
                         'AND InwiB2C_IsBoAgence__c = true ' + 
                         'AND ParentId = :distributorId ' + 
                         'ORDER BY CreatedDate DESC LIMIT 5';
                       
            } else if (typeUser == 'Animateur' || typeUser == 'Livreur') {
                sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + 
                         ' WHERE RecordType.Name = \'Partenaire\' ' + 
                         'AND inwiB2C_TypePartenaire__c = \'inwiB2C_Agence\' ' + 
                         'AND InwiB2C_IsBoAgence__c = false ' + 
                         'AND InwiB2C_CelluleBO__c != null ' + 
                         'AND ParentId = :distributorId ' + 
                         'ORDER BY CreatedDate DESC LIMIT 5';
            } 
            
            System.debug('SOQL Query: ' + sQuery);
            
            List<Account> accounts = Database.query(sQuery);
            List<Map<String, String>> UIoptions = new List<Map<String, String>>();
            
            for(Account acc : accounts) {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('name', acc.Id);
                tempMap.put('value', acc.Name);
                
                UIoptions.add(tempMap);
            }
            
            outMap.put('options', UIoptions);
             
        }
        
        return true;
    }
}