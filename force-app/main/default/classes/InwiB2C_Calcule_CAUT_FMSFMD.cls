/**
 * @description       : B-14377
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 19-02-2024
 * @last modified by  : Chadia bani
**/
global class InwiB2C_Calcule_CAUT_FMSFMD implements vlocity_cmt.VlocityOpenInterface{
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
    Double fmd=0;
    Map<String, Object> inputt = (Map<String, Object>)JSON.deserializeUntyped(json.serialize(input));
    System.debug(inputt);

    Map<String, Object> CSOrderScor = (Map<String, Object>)inputt.get('CSOrderScor');

    String offer = (String) CSOrderScor.get('offre');
    Decimal engagementDuration = (Decimal) CSOrderScor.get('engagementDuration');
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
    // Y_MH offre 5G lot A begin
    Boolean Isidar5G = (Boolean) CSOrderScor.get('Isidar5G');
    System.debug(Isidar5G);
        // Y_MH offre 5G lot A end 


    // Begin ACYL/YOUNES
    String CodeArticle = (String) CSOrderScor.get('CodeArticle');
    System.debug(CodeArticle);
    String Canal = (String) CSOrderScor.get('Canal');
    System.debug(Canal);
    // End ACYL/YOUNES


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
    // Begin ACYL/YOUNES -- condition canal et code artcile vide -- End
    if (Canal == null || CodeArticle == null) {
    InwiB2C_MONT_CAUT_FMSFMD__c CSOrderScorRep = [Select InwiB2C_VALUE_CAUTION__c, VALUE_FMD__c, VALUE_FMS__c,InwiB2C_FNR__c
                                              from InwiB2C_MONT_CAUT_FMSFMD__c
                                              where InwiB2C_Code_Offre__c = :offer and InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration and InwiB2C_IS_PORTABILITY__c in:protabilityInClause and InwiB2C_ISBLACKLISTED__c = :isBlackListed and (InwiB2C_M_Type_Client__c = :typeClient OR InwiB2C_M_Type_Client__c='ALL') and InwiB2C_TYPE_HANDSET__c in:handSetInClause
                                              Order by InwiB2C_M_Type_Client__c desc // Meryem Yahya prioriser les autres Type sur ALL
                                              LIMIT 1];

    system.debug('CSOrderScorRep' + CSOrderScorRep);

    Id Id = (Id) CSOrderScor.get('Id');
    Id Idterm = (Id) CSOrderScor.get('terminalId');
    if (CSOrderScorRep != null){
//CHB 19/02/2024 ano B-14377 begin */
    /*  OrderItem orderItem = [Select id, InwiB2C_FMS__c, InwiB2C_FMD__c,InwiB2C_FNR__c
                       from OrderItem
                       where Id = :Id
                       limit 1];*/
        OrderItem orderItem = [Select id, InwiB2C_FMS__c, InwiB2C_FMD__c,InwiB2C_FNR__c,InwiB2C_FMS_Catalogue__c,InwiB2C_FMD_Catalogue__c
        from OrderItem
        where Id = :Id
        limit 1];
//CHB 19/02/2024 ano B-14377 End */
        //ILA 07/07/2023 maj du fnr sur un attribut via un DR Post Start
     /* OrderItem orderItemTerminal = [Select id, InwiB2C_FMS__c, InwiB2C_FMD__c,InwiB2C_FNR__c
                       from OrderItem666
                       where Id = :Idterm
                       limit 1];*/
        Map<String,String> fnr=new Map<String,String>();
        //ILA 07/07/2023 End
      orderItem.InwiB2C_FMS__c = CSOrderScorRep.VALUE_FMS__c;
      //CHB 19/02/2024 ano B-14377 begin*/
      orderItem.InwiB2C_FMS_Catalogue__c= CSOrderScorRep.VALUE_FMS__c;
      //CHB 19/02/2024 ano B-14377 end*/
      //orderItem.InwiB2C_FMD__c = CSOrderScorRep.VALUE_FMD__c;
        if (Isterminal == 'TRUE'){
                  orderItem.InwiB2C_FMD__c = CSOrderScorRep.VALUE_FMD__c;
                //CHB 19/02/2024 ano B-14377 begin */
                  orderItem.InwiB2C_FMD_Catalogue__c= CSOrderScorRep.VALUE_FMD__c;
                //CHB 19/02/2024 ano B-14377 end*/
            		//ILA 07/07/2023 maj du fnr sur un attribut via un DR Post
                  //orderItemTerminal.InwiB2C_FNR__c = CSOrderScorRep.InwiB2C_FNR__c;
                  fnr.put('fnr',String.valueOf(CSOrderScorRep.InwiB2C_FNR__c));
            	  output.put('data1', fnr);
            	//ILA 07/07/2023 End

    
        }else {
          //Amine brm B-14383 
          orderItem.InwiB2C_FMD__c = fmd;
          
        }
      update orderItem;
        //ILA 07/07/2023 maj du fnr sur un attribut via un DR Post 
      //update orderItemTerminal;
      //ILA 07/07/2023 End
    }output.put('show', '1');
    output.put('data', CSOrderScorRep);}

    //Begin ACYL/YOUNES
    else{

      InwiB2C_MONT_CAUT_CRETER__c CSOrderScorRep;

/*if (Isidar5G) {
    // Cas spécial IDAR 5G
    if (typeClient == 'GP') {
        // On prend uniquement GP
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
              AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c = :typeClient
              AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_TYPE_HANDSET__c IN :handSetInClause
            LIMIT 1
        ];
    } else {
        // Si autre type client → prendre uniquement ALL
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
              AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c = 'ALL'
              AND InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_TYPE_HANDSET__c IN :handSetInClause
            LIMIT 1
        ];
    }

} 
        else {
    // Cas standard (non-IDAR5G)
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
         Order by InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c desc
        LIMIT 1
    ];
}*/

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
         Order by InwiB2C_MONT_CAUT_FMSFMD__r.InwiB2C_M_Type_Client__c desc // Meryem Yahya prioriser les autres Type sur ALL
        LIMIT 1
    ];
 //Y_MH idar 5G Lot A end 

system.debug('CSOrderScorRep' + CSOrderScorRep);

Id Id = (Id) CSOrderScor.get('Id');
Id Idterm = (Id) CSOrderScor.get('terminalId');
if (CSOrderScorRep != null){
//CHB 19/02/2024 ano B-14377 begin */
/*  OrderItem orderItem = [Select id, InwiB2C_FMS__c, InwiB2C_FMD__c,InwiB2C_FNR__c
from OrderItem
where Id = :Id
limit 1];*/
OrderItem orderItem = [Select id, InwiB2C_FMS__c, InwiB2C_FMD__c,InwiB2C_FNR__c,InwiB2C_FMS_Catalogue__c,InwiB2C_FMD_Catalogue__c
from OrderItem
where Id = :Id
limit 1];
//CHB 19/02/2024 ano B-14377 End */
//ILA 07/07/2023 maj du fnr sur un attribut via un DR Post Start
/* OrderItem orderItemTerminal = [Select id, InwiB2C_FMS__c, InwiB2C_FMD__c,InwiB2C_FNR__c
from OrderItem666
where Id = :Idterm
limit 1];*/
Map<String,String> fnr=new Map<String,String>();
//ILA 07/07/2023 End
orderItem.InwiB2C_FMS__c = CSOrderScorRep.InwiB2C_Prix_FMS__c; //Y_MH idar 5G Lot A
//CHB 19/02/2024 ano B-14377 begin*/
orderItem.InwiB2C_FMS_Catalogue__c= CSOrderScorRep.InwiB2C_Prix_FMS__c ; //Y_MH idar 5G Lot A
//CHB 19/02/2024 ano B-14377 end*/
//orderItem.InwiB2C_FMD__c = CSOrderScorRep.VALUE_FMD__c;
if (Isterminal == 'TRUE'){
orderItem.InwiB2C_FMD__c = CSOrderScorRep.InwiB2C_Prix_FMD__c;
//CHB 19/02/2024 ano B-14377 begin */
orderItem.InwiB2C_FMD_Catalogue__c= CSOrderScorRep.InwiB2C_Prix_FMD__c;
//CHB 19/02/2024 ano B-14377 end*/
//ILA 07/07/2023 maj du fnr sur un attribut via un DR Post
//orderItemTerminal.InwiB2C_FNR__c = CSOrderScorRep.InwiB2C_FNR__c;
fnr.put('fnr',String.valueOf(CSOrderScorRep.InwiB2C_Prix_FNR__c));
output.put('data1', fnr);
//ILA 07/07/2023 End


}else {
//Amine brm B-14383 
orderItem.InwiB2C_FMD__c = fmd;

}
update orderItem;
//ILA 07/07/2023 maj du fnr sur un attribut via un DR Post 
//update orderItemTerminal;
//ILA 07/07/2023 End


}
output.put('show', '1');
    output.put('data', CSOrderScorRep);

    }    //End  ACYL/YOUNES


  }

}