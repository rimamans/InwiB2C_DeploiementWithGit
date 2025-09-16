global with sharing class InwiB2C_CheckEligibilityMigrCamConnect implements vlocity_cmt.VlocityOpenInterface {
    
 global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options) {
         if (methodName == 'CheckEligibility'){
            checkEligibility(inputs, output, options);
        }

        return true;
    }
    private void checkEligibility(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
        
         String mdn1 = (String) input.get('mdn1');
         String mdn2 = (String) input.get('mdn2');
        
        vlocity_cmt__Subscription__c record1 = new vlocity_cmt__Subscription__c();
        InwiB2C_Demande_IdentificationClient__c record2 = new InwiB2C_Demande_IdentificationClient__c();
        //CHB ANO B-14457 begin */
       /* Set<String> PrepayeProfileIds = new Set<String>{
            '5291', '5292', '84001', '5291-45', '5291-50', '5291-51', '5291-53', '5291-55', '84001-45',
            '84001-51', '84001-55', '5291-56', '84001-56', '618', '84001-60', '5291-60', '84001-42',
            '84001-40', '84001-30', '84001-25', '84001-22', '84001-20', '84001-13', '84001-12', '84001-11',
            '5291-54', '5291-48', '5291-42', '81505-26', '84001-71'
        };*/
        Set<String> PrepayeProfileIds = new Set<String>{
            '5291', '5292', '84001','84002','647232','2990','2015','618'
        }; 
        //CHB ANO B-14457 end */
        Set<String> CampusProfileIds = new Set<String>{
            '20707'
        };
        
        if (!isValidPhoneNumberFormat(mdn1) || !isValidPhoneNumberFormat(mdn2)){ 
            output.put('Eligible', false);
      		output.put('code', 'ERROR2');
            output.put('reason', 'Format de numéro de téléphone invalide.');

            return;
           }
        
         List<vlocity_cmt__Subscription__c> records1 = [select id,vlocity_cmt__AccountId__c, vlocity_cmt__AccountId__r.Inwib2c_CIN__c,
                                                        vlocity_cmt__AccountId__r.Name,
                                                 InwiB2C_Id_profil__c, Inwib2c_Num_ro_de_la_ligne__c,   
                                                 vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__c ,
                                                 vlocity_cmt__AccountId__r.vlocity_cmt__PrimaryContactId__c,
                                                 vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c//CHB ANO B-14392 22/02/2024
                                                 from vlocity_cmt__Subscription__c 
                                                 where Inwib2c_Num_ro_de_la_ligne__c = :mdn1 ];

        
         List<InwiB2C_Demande_IdentificationClient__c> records2 = [SELECT Id, InwiB2C_MDN__c, InwiB2C_Statut__c, 
                                                               InwiB2C_Subscription__r.InwiB2C_Id_profil__c, 
                                                               InwiB2C_Piece_identite__c, InwiB2C_AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c, Name
                                                               FROM InwiB2C_Demande_IdentificationClient__c
                                                               WHERE InwiB2C_MDN__c = :mdn2]; 
        
       
        if (records2.size() > 0) record2 = records2[0];
        if (records1.size() > 0) record1 = records1[0];
        
        if (records1.isEmpty()){
            output.put('Eligible', false);
      		output.put('reason', 'Mdn1 non trouvé');
            output.put('code', 'ERROR3');
            return;
        }
        
        else if (String.isBlank(record1.vlocity_cmt__AccountId__c) || record1.vlocity_cmt__AccountId__r.Name.contains('Dummy')  || record1.vlocity_cmt__AccountId__r.Name.contains('DUMMY') ){
            output.put('Eligible', false);
      		output.put('reason', 'Mdn1 non identifié');
            output.put('code', 'ERROR3');
            return;
        }
        else if (records2.isEmpty()){
            output.put('Eligible', false);
            output.put('code', 'ERROR3');
      		output.put('reason', 'Mdn2 non identifié');
            return;
        }//CHB ANO B-14392 22/02/2024 BEGIN */
      /*  else if(String.isBlank(record1.vlocity_cmt__AccountId__r.Inwib2c_CIN__c) || 
                (String.isBlank(record2.InwiB2C_Piece_identite__c) && String.isBlank(record2.InwiB2C_AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c)) ||
                (record1.vlocity_cmt__AccountId__r.Inwib2c_CIN__c != record2.InwiB2C_Piece_identite__c && 
                 record1.vlocity_cmt__AccountId__r.Inwib2c_CIN__c != record2.InwiB2C_AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c ) )*/
        else if(record1.vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c != record2.InwiB2C_AccountId__r.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c ){
        //CHB ANO B-14392 22/02/2024 end */
            output.put('Eligible', false);
            output.put('code', 'ERROR4');
      		output.put('reason', 'Numéro d\'identité non identique pour les deux MDNs.');
            return;
        }
        
        else if ( String.isBlank(record1.InwiB2C_Id_profil__c) || !PrepayeProfileIds.contains(record1.InwiB2C_Id_profil__c)) {
                      
            output.put('Eligible', false); 
            output.put('code', 'ERROR5');
      		output.put('reason', 'Mdn1 non éligible.');
            return;
    }
        else if (String.isBlank(record2.InwiB2C_Statut__c) || !record2.InwiB2C_Statut__c.equals('InwiB2C_Finalisé')  || String.isBlank(record2.InwiB2C_Subscription__c) || String.isBlank(record2.InwiB2C_Subscription__r.InwiB2C_Id_profil__c) || !CampusProfileIds.contains(record2.InwiB2C_Subscription__r.InwiB2C_Id_profil__c)) {
                      
            output.put('Eligible', false); 
            output.put('code', 'ERROR5');
      		output.put('reason', 'Mdn2 non éligible.');
            return;
        }else{
             output.put('Eligible', true); 
        }
    }
        
     private static Boolean isValidPhoneNumberFormat(String phoneNumber) {
        // Validate phone number format  "212XXXXXXXXX" 
        Pattern pattern = Pattern.compile('^212\\d{9}$');
        Matcher matcher = pattern.matcher(phoneNumber);
        return matcher.matches();
    }
}