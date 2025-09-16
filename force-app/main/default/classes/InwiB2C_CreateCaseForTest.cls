global with sharing  class InwiB2C_CreateCaseForTest implements vlocity_cmt.VlocityOpenInterface {


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
            
    
    
    
        String TypeRec =  (String)options.get('TypeRec');
          System.debug(TypeRec);
        String Type = (String)inputMap.get('Type');
        String Categorie =(String)inputMap.get('Categorie');System.debug(Categorie);
        String Qualification = (String)inputMap.get('Qualification');
        System.debug(Qualification);
        String TypeSpecialite = (String)inputMap.get('TypeSpecialite');
        System.debug(TypeSpecialite);
        String Detail = (String)inputMap.get('Detail');
        System.debug(Detail);
        String Descriptif = (String)inputMap.get('Descriptif');
        System.debug(Descriptif);
        String Recapitulatif = (String)inputMap.get('Recapitulatif');
        System.debug(Recapitulatif);
        String Source = (String)inputMap.get('Source');
        System.debug(Source);
        String OffreType = (String)inputMap.get('OffreType');
        System.debug(OffreType);
        Boolean Qauda= (Boolean)inputMap.get('Qauda');
        String PartId = (String)inputMap.get('PartId');System.debug(PartId);
    
        String SubscriptionId = (String)inputMap.get('SubscriptionId');
        String ContId = (String)inputMap.get('ContId');
        String AccId = (String)inputMap.get('AccId');
        String BillingAccId = (String)inputMap.get('BillingAccId');
    
        if(Categorie.equals('')) Categorie = null;
        if(Qualification.equals('')) Qualification = null;
        if(TypeSpecialite.equals('')) TypeSpecialite = null;
    
        if(Detail.equals('')) Detail = null;
        
        if(Descriptif.equals('')) Descriptif = null;
        if(Recapitulatif.equals('')) Recapitulatif = null;
        if(Source.equals('')) Source = null;
         if (OffreType =='FTTH') {
             Qauda = (Boolean)inputMap.get('Qauda');
             System.debug(Qauda);
         }
        
        
    
        Id idSubscriptionId;
        Id idContId;
        Id idAccId;
        Id  idBillingAccId;
    
    
        
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
    
        //try {
    //     System.debug('try');
    // Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
    // String pname = p.Name;
    //        if (Pname!='Inwi POS'){
    //         RecordType rT = [Select Id from RecordType where DeveloperName = :TypeRec];
    
    //     Case theNewCase= new Case(
    //         Type=Type,
    //         RecordTypeId = rT.Id,
    //         Inwib2c_Cat_gorie__c=Categorie,
    //         InwiB2C_Qualification__c = Qualification,
    //         InwiB2C_TypeSpecialite__c=TypeSpecialite,
    //         InwiB2C_Detail__c=Detail,
    //         Description=Descriptif,
    //         Subject=Recapitulatif,
    //         //InwiB2C_Qualification_AUDA__c= QualificationAUDA,
    //         Origin=Source,
    //         Status = 'Ouvert',
    //         vlocity_cmt__SubscriptionId__c=idSubscriptionId,
    //         Inwib2c_Compte_de_facturation__c=idBillingAccId, 
    //         ContactId=idContId,
    //        InwiB2C_CanalUser__c='InwiB2C_CRC',
    //       //  InwiB2C_Partenaire__c=idPartId,
    //         AccountId=idAccId);
    //          if(OffreType == 'FTTH'){
    
    //             theNewCase.InwiB2C_Qualification_AUDA__c = Qauda;
    //          }
    //         insert theNewCase;
    //         System.debug('begin1'+Pname);
    //         Id idCase =  theNewCase.Id;            
    //         outMap.put('idcase',idCase);
    //      } 
           
          
           
           
          //else if (Pname=='Inwi POS'){
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
         //} 
           
    
            System.debug('end try');
        // } catch(DmlException e) {
        //     System.debug('An unexpected error has occurred: ' + e.getMessage());
        // }
           
    }
    }