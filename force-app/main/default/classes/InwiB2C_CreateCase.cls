global with sharing  class InwiB2C_CreateCase implements vlocity_cmt.VlocityOpenInterface {


global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
    Boolean result = true;
    try{
        if(methodName.equals('creationCase')){
            creationCase(inputMap, outMap, options);
        }else {

        }                              
    } catch(Exception e){
                   
        result = false;     
    }

    return result;

}


public static void creationCase(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
  //    Map<String,Object> CreactionCase = (Map<String,Object>) inputMap.get('CreactionCase');

   //   Map<String,Object> CreactionCase = (Map<String,Object>) inputMap.get('CreactionCase');

//      String Recapitulatif = (String)  Descriptif.get('Recapitulatif');
//  String TypeRec =        (String)options.get('Source');
//       System.debug(TypeRec);


    String TypeRec =  (String)options.get('TypeRec');
      System.debug(TypeRec);
    String Type =  (String)options.get('Type');
    String Categorie =      (String)options.get('Categorie');System.debug(Categorie);
    String Qualification =      (String)options.get('Qualification');System.debug(Qualification);
    String TypeSpecialite = (String)options.get('TypeSpecialite');System.debug(TypeSpecialite);
    String Detail =         (String)options.get('Detail');System.debug(Detail);
    String Descriptif =     (String)options.get('Descriptif');System.debug(Descriptif);
    String Recapitulatif =  (String)options.get('Recapitulatif');System.debug(Recapitulatif);
    String Source =         (String)options.get('Source');System.debug(Source);
    String OffreType =         (String)options.get('OffreType');System.debug(OffreType);
    Boolean Qauda;
    //String Qauda1 =           (String)options.get('Qauda');System.debug(Qauda1);
    String PartId =         (String)options.get('PartId');System.debug(PartId);

    String SubscriptionId = (String)options.get('SubscriptionId');
    String ContId = (String)options.get('ContId');
    String AccId = (String)options.get('AccId');
    String BillingAccId = (String)options.get('BillingAccId');

    if(Categorie.equals('')) Categorie = null;
    if(Qualification.equals('')) Qualification = null;
    if(TypeSpecialite.equals('')) TypeSpecialite = null;

    if(Detail.equals('')) Detail = null;
    
    if(Descriptif.equals('')) Descriptif = null;
    if(Recapitulatif.equals('')) Recapitulatif = null;
    if(Source.equals('')) Source = null;
     if (OffreType =='FTTH') {
         Qauda = (Boolean)options.get('Qauda');System.debug(Qauda);
     }
    //     if (String.valueOf(Qauda).equals('')) {
    //         Qauda = null;
    //     }
    // }
        
    //if(Qauda.equals('')) Qauda = null;
    
    

    Id idSubscriptionId;
    Id idContId;
    Id idAccId;
    Id idBillingAccId;
//    Id idPartId;


  //  if(PartId.equals('')) idPartId = null;
 //   else idPartId = Id.valueOf(PartId);

    
    if(SubscriptionId.equals('')) idSubscriptionId = null;
    else idSubscriptionId = Id.valueOf(SubscriptionId);
    
    if(ContId.equals('')) idContId = null;
    else idContId = Id.valueOf(ContId);

    if(AccId.equals('')) idAccId = null;
    else idAccId = Id.valueOf(AccId);


    if(BillingAccId.equals('')) idBillingAccId = null;
    else idBillingAccId = Id.valueOf(BillingAccId);


    System.debug('idSubscriptionId');
    System.debug(idSubscriptionId);

    System.debug('idContId');
    System.debug(idContId);

    System.debug('idAccId');
    System.debug(idAccId);

    System.debug('idBillingAccId');
    System.debug(idBillingAccId);

   try {
    System.debug('try');
Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
String pname = p.name;
       if (Pname!='Inwi POS'){
        RecordType rT = [Select Id from RecordType where DeveloperName = :TypeRec];

    Case theNewCase= new Case(
        Type=Type,
        RecordTypeId = rT.Id,
        Inwib2c_Cat_gorie__c=Categorie,
        InwiB2C_Qualification__c = Qualification,
        InwiB2C_TypeSpecialite__c=TypeSpecialite,
        InwiB2C_Detail__c=Detail,
        Description=Descriptif,
        Subject=Recapitulatif,
        //InwiB2C_Qualification_AUDA__c= QualificationAUDA,
        Origin=Source,
        Status = 'Ouvert',
        vlocity_cmt__SubscriptionId__c=idSubscriptionId,
        Inwib2c_Compte_de_facturation__c=idBillingAccId, 
        ContactId=idContId,
       InwiB2C_CanalUser__c='InwiB2C_CRC',
      //  InwiB2C_Partenaire__c=idPartId,
        AccountId=idAccId);
         if(OffreType == 'FTTH'){

            theNewCase.InwiB2C_Qualification_AUDA__c = Qauda;
         }
        insert theNewCase;
System.debug('begin1'+Pname);
        Id idCase =  theNewCase.Id;            
        outMap.put('idcase',idCase);
     } 
       
      
       
       
      else if (Pname=='Inwi POS'){
         // System.debug('begin3');
        RecordType rTe = [Select Id from RecordType where DeveloperName = :TypeRec];

    Case theNewCasecommunity= new Case(
        Type=Type,
        RecordTypeId = rTe.Id,
        Inwib2c_Cat_gorie__c=Categorie,
        InwiB2C_Qualification__c = Qualification,
        InwiB2C_TypeSpecialite__c=TypeSpecialite,
        InwiB2C_Detail__c=Detail,
        Description=Descriptif,
        Subject=Recapitulatif,
        //InwiB2C_Qualification_AUDA__c= QualificationAUDA,
        Origin='Visite client au PDV',
        // InwiB2C_Qualification_AUDA__c = Qauda,
        Status = 'Ouvert',
        vlocity_cmt__SubscriptionId__c=idSubscriptionId,
        Inwib2c_Compte_de_facturation__c=idBillingAccId, 
       InwiB2C_CanalUser__c='InwiB2C_PointdeVente',
      // InwiB2C_Partenaire__c=idPartId,
        ContactId=idContId,
        
        AccountId=idAccId);
        if(OffreType == 'FTTH'){

            theNewCasecommunity.InwiB2C_Qualification_AUDA__c = Qauda;
         }
        // if(Qauda == true || Qauda == false){
        //     theNewCasecommunity.InwiB2C_Qualification_AUDA__c = Qauda;
        // }

        insert theNewCasecommunity;

        Id idCasecommunity =  theNewCasecommunity.Id;
        
        outMap.put('idcase',idCasecommunity);
     } 
       
     /*       
        System.debug(idCase);
        Id tempid =  (Id)outMap.get('idcase');
        System.debug('tempid : ');
        System.debug(tempid);
    */
        System.debug('end try');
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
          /*  

       if((SubscriptionId==null) || (ContId==null)){
        System.debug('if(idSubscriptionId || idContId');
        Id idAccId = Id.valueOf(AccId);

        Case theNewCase= new Case(
            Type=TypeRec,
            Inwib2c_Cat_gorie__c=Categorie,
            InwiB2C_TypeSpecialite__c=TypeSpecialite,
            InwiB2C_Detail__c=Detail,
            Description=Descriptif,
            Subject=Recapitulatif,
            Origin=Source,
            AccountId=idAccId
            );
        insert theNewCase;

       }  else{
        System.debug('else');



       }
        */
}
}