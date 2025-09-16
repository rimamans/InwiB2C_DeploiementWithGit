/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-21-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class InwiB2C_Calcule_FMD implements vlocity_cmt.VlocityOpenInterface{
  global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

    Boolean result = true;

    try{

      if (methodName.equals('Calculs_Values')){
        Calculs_Values(inputMap, outMap);
      }

    } catch (Exception e){

      result = false;

    }

    return result;
  }

  private void Calculs_Values(Map<String, object> input, Map<String, object> output){

    String status = '';

    Map<String, Object> inputt = (Map<String, Object>)JSON.deserializeUntyped(json.serialize(input));
    System.debug(inputt);

    Map<String, Object> CSOrderScor = (Map<String, Object>)inputt.get('CSOrderScor');

    String offer = (String) CSOrderScor.get('offre');
     Decimal engagementDuration = 0 ; 
      if( CSOrderScor.get('engagementDuration') != null) {
      engagementDuration = (Decimal) CSOrderScor.get('engagementDuration');
} else { 
if (offer == 'INWIB2C_OFFERING_FTTH50MG3MOIS_249DH'
|| offer == 'INWIB2C_OFFERING_FTTH200MG3MOIS_449DH'
|| offer == 'INWIB2C_OFFERING_FTTH100MG3MOIS_349DH'
|| offer == 'INWIB2C_OFFERING_FTTH200MG_649DH'
|| offer == 'INWIB2C_OFFERING_FTTH20MG_249DH'
|| offer == 'INWIB2C_OFFERING_FTTH100MG_449DH'
|| offer == 'INWIB2C_OFFERING_FTTH50MG_349DH'
|| offer == 'INWIB2C_OFFERING_FTTH500MG_749DH'
|| offer == 'INWIB2C_OFFERING_FTTH1Gb_949DH'
)
{
      engagementDuration = 12;
}

} 



    System.debug(engagementDuration);
    String handSetType = (String) CSOrderScor.get('handSetType');
    System.debug(handSetType);
    String targetOperator = (String) CSOrderScor.get('targetOperator');
    System.debug(targetOperator);
    String isBlackListed = (String) CSOrderScor.get('isBlackListed');
    System.debug(isBlackListed);
    Decimal seniority = (Decimal) CSOrderScor.get('seniority');
    System.debug(seniority);
    String typeClient = (String) CSOrderScor.get('typeClient');
    System.debug(typeClient);
    String isPorrtability = (String) CSOrderScor.get('isPorrtability');
    System.debug(isPorrtability);
      String Isterminal = (String) CSOrderScor.get('Isterminal');
    System.debug(Isterminal);
   //Acyl/Younes 31/01/2025 begin */
    String CodeArticle = (String) CSOrderScor.get('CodeArticle');
    System.debug(CodeArticle);
    String Canal = (String) CSOrderScor.get('Canal');
    System.debug(Canal);
    //Acyl/Younes 31/01/2025 end */


    // Y_MH offre 5G lot A begin
    Boolean Isidar5G = (Boolean) CSOrderScor.get('Isidar5G');
    System.debug(Isidar5G);
    // Y_MH offre 5G lot A end 



    List<Object> AdditionelCretera = (List<Object>)CSOrderScor.get('AdditionelCretera');

    for (Object inidividualEntries : AdditionelCretera){
      Map<String, Object> ind = (Map<String, Object>)inidividualEntries;
      String Code = (String) ind.get('Code');
      String Value = (String) ind.get('Value');
      system.debug(Code);
      system.debug(Value);
    }

    List<String> protabilityInClause = new List<String>{ 'ALL', isPorrtability };
    List<String> handSetInClause = new List<String>{ 'ALL', handSetType };
        //Acyl/Younes 31/01/2025 begin */
        if (Canal == null || CodeArticle == null) {
      InwiB2C_MONT_CAUT_FMSFMD__c CSOrderScorRep ;  
    try{
      CSOrderScorRep = [Select  InwiB2C_VALUE_CAUTION__c, VALUE_FMD__c, VALUE_FMS__c,InwiB2C_FNR__c
                                              from InwiB2C_MONT_CAUT_FMSFMD__c
                                              where InwiB2C_Code_Offre__c = :offer and InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration and InwiB2C_IS_PORTABILITY__c in:protabilityInClause and InwiB2C_ISBLACKLISTED__c = :isBlackListed and InwiB2C_M_Type_Client__c = :typeClient and InwiB2C_TYPE_HANDSET__c in:handSetInClause
                                               Order by InwiB2C_M_Type_Client__c desc
                                              LIMIT 1]; //Y_MH prioriser les autres Type sur ALL
} catch(Exception ex){ List<String>  Type_ClientInClause = new List<String>{ 'ALL', typeClient };
CSOrderScorRep = [Select  InwiB2C_VALUE_CAUTION__c, VALUE_FMD__c, VALUE_FMS__c,InwiB2C_FNR__c
                                              from InwiB2C_MONT_CAUT_FMSFMD__c
                                              where InwiB2C_Code_Offre__c = :offer and InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration and InwiB2C_IS_PORTABILITY__c in:protabilityInClause and InwiB2C_ISBLACKLISTED__c = :isBlackListed and InwiB2C_M_Type_Client__c in :Type_ClientInClause and InwiB2C_TYPE_HANDSET__c in:handSetInClause
                                              LIMIT 1];}

                                              output.put('VALUE_CAUTION', CSOrderScorRep.get('InwiB2C_VALUE_CAUTION__c'));
                                              output.put('FMD', CSOrderScorRep.get('VALUE_FMD__c'));
                                              output.put('FMS', CSOrderScorRep.get('VALUE_FMS__c'));
                                              output.put('FNR', CSOrderScorRep.get('InwiB2C_FNR__c'));
                                                 output.put('Id', CSOrderScorRep.get('Id'));
                                           //MTA 03/11/2023 Begin //
                                           output.put('Isterminal', (String) CSOrderScor.get('Isterminal'));
                                              //MTA 03/11/2023 END //
}
else {
//   InwiB2C_MONT_CAUT_CRETER__c CSOrderScorRep ;  
//   try{
//     CSOrderScorRep = [Select  InwiB2C_MONT_CAUT_FMSFMD__c,  InwiB2C_MONT_CAUT_FMSFMD__r.Id ,  InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_VALUE_CAUTION__c, InwiB2C_Code_Offre__c, InwiB2C_MONT_CAUT_FMSFMD__r.VALUE_FMS__c ,  InwiB2C_Code_Article__c, InwiB2C_Libell_Offre__c,  Name, InwiB2C_Prix_FMD__c, InwiB2C_Prix_FNR__c
//     from InwiB2C_MONT_CAUT_CRETER__c
//     where InwiB2C_Code_Offre__c  = :offer and InwiB2C_Canal__c =: Canal   and InwiB2C_Code_Article__c= :CodeArticle  and  InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration and InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_IS_PORTABILITY__c in:protabilityInClause and InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_ISBLACKLISTED__c = :isBlackListed and (InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c = :typeClient OR InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c='ALL') and InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_TYPE_HANDSET__c in:handSetInClause
//     LIMIT 1];
//     system.debug('CSOrderScorRep' + CSOrderScorRep);
// } catch(Exception ex){ List<String>  Type_ClientInClause = new List<String>{ 'ALL', typeClient };
// CSOrderScorRep = [Select  InwiB2C_MONT_CAUT_FMSFMD__c, InwiB2C_Code_Offre__c, InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_VALUE_CAUTION__c ,  InwiB2C_MONT_CAUT_FMSFMD__r.VALUE_FMS__c,  InwiB2C_Code_Article__c, InwiB2C_Libell_Offre__c,  Name, InwiB2C_Prix_FMD__c , InwiB2C_Prix_FNR__c
// from InwiB2C_MONT_CAUT_CRETER__c
// where InwiB2C_Code_Offre__c  = :offer and InwiB2C_Canal__c =: Canal  and InwiB2C_Code_Article__c= :CodeArticle  and  InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration and InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_IS_PORTABILITY__c in:protabilityInClause and InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_ISBLACKLISTED__c = :isBlackListed and (InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c = :typeClient OR InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c='ALL') and InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_TYPE_HANDSET__c in:handSetInClause
// LIMIT 1];}
// Y_MH offre 5G lot A begin
InwiB2C_MONT_CAUT_CRETER__c CSOrderScorRep;

try {
    // if (Isidar5G) {
    //     // Cas IDAR5G : GP ou ALL uniquement
    //     String typeClientFilter = (typeClient == 'GP') ? typeClient : 'ALL';

    //     CSOrderScorRep = [
    //         SELECT InwiB2C_MONT_CAUT_FMSFMD__c,
    //                InwiB2C_MONT_CAUT_FMSFMD__r.Id,
    //                InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_VALUE_CAUTION__c,
    //                InwiB2C_Code_Offre__c,
    //                InwiB2C_MONT_CAUT_FMSFMD__r.VALUE_FMS__c,
    //                InwiB2C_Prix_FMS__c,
    //                InwiB2C_Code_Article__c,
    //                InwiB2C_Libell_Offre__c,
    //                Name,
    //                InwiB2C_Prix_FMD__c,
    //                InwiB2C_Prix_FNR__c
    //         FROM InwiB2C_MONT_CAUT_CRETER__c
    //         WHERE InwiB2C_Code_Offre__c = :offer
    //           AND InwiB2C_Canal__c = :Canal
    //           AND InwiB2C_Code_Article__c = :CodeArticle
    //           AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration
    //           AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_IS_PORTABILITY__c IN :protabilityInClause
    //           AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_ISBLACKLISTED__c = :isBlackListed
    //           AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c = :typeClientFilter
    //           AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_TYPE_HANDSET__c IN :handSetInClause
    //         LIMIT 1
    //     ];
    // } else {
    //     // Cas standard avec typeClient OU ALL
    //     CSOrderScorRep = [
    //         SELECT InwiB2C_MONT_CAUT_FMSFMD__c,
    //                InwiB2C_MONT_CAUT_FMSFMD__r.Id,
    //                InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_VALUE_CAUTION__c,
    //                InwiB2C_Code_Offre__c,
    //                InwiB2C_MONT_CAUT_FMSFMD__r.VALUE_FMS__c,
    //                InwiB2C_Prix_FMS__c,
    //                InwiB2C_Code_Article__c,
    //                InwiB2C_Libell_Offre__c,
    //                Name,
    //                InwiB2C_Prix_FMD__c,
    //                InwiB2C_Prix_FNR__c
    //         FROM InwiB2C_MONT_CAUT_CRETER__c
    //         WHERE InwiB2C_Code_Offre__c = :offer
    //           AND InwiB2C_Canal__c = :Canal
    //           AND InwiB2C_Code_Article__c = :CodeArticle
    //           AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration
    //           AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_IS_PORTABILITY__c IN :protabilityInClause
    //           AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_ISBLACKLISTED__c = :isBlackListed
    //           AND (InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c = :typeClient OR InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c = 'ALL')
    //           AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_TYPE_HANDSET__c IN :handSetInClause
    //         LIMIT 1
    //     ];
    
     CSOrderScorRep = [
        SELECT InwiB2C_MONT_CAUT_FMSFMD__c,
               InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_VALUE_CAUTION__c,
               InwiB2C_Prix_FMS__c,
               InwiB2C_Code_Offre__c,
               InwiB2C_Code_Article__c,
               InwiB2C_Libell_Offre__c,
               Name,
               InwiB2C_Prix_FMD__c,
               InwiB2C_Prix_FNR__c
        FROM InwiB2C_MONT_CAUT_CRETER__c
        WHERE InwiB2C_Code_Offre__c = :offer
          AND InwiB2C_Canal__c = :Canal
          AND InwiB2C_Code_Article__c = :CodeArticle
          AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration
          AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_IS_PORTABILITY__c IN :protabilityInClause
          AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_ISBLACKLISTED__c = :isBlackListed
          AND (InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c = :typeClient OR InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c = 'ALL')
          AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_TYPE_HANDSET__c IN :handSetInClause
         Order by InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c desc // Y_MH prioriser les autres Type sur ALL
        LIMIT 1
    ];
    

    System.debug('CSOrderScorRep: ' + CSOrderScorRep);

} catch (Exception ex) {
    System.debug('Erreur lors de la récupération de CSOrderScorRep: ' + ex.getMessage());
}

// Y_MH offre 5G lot A end


output.put('VALUE_CAUTION', CSOrderScorRep.InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_VALUE_CAUTION__c);
output.put('FMD', CSOrderScorRep.get('InwiB2C_Prix_FMD__c'));
output.put('FMS', CSOrderScorRep.InwiB2C_Prix_FMS__c );
output.put('FNR', CSOrderScorRep.get('InwiB2C_Prix_FNR__c'));
output.put('Id', CSOrderScorRep.get('Id'));
//MTA 03/11/2023 Begin //
output.put('Isterminal', (String) CSOrderScor.get('Isterminal'));
//MTA 03/11/2023 END //

system.debug('CSOrderScorRep' + CSOrderScorRep);

}    //Acyl/Younes 31/01/2025 end */

  }

}