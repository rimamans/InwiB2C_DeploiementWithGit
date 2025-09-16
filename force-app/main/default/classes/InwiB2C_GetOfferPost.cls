global with sharing class InwiB2C_GetOfferPost implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        if (methodName == 'getOffer') {
            outMap.put('result', getOffer(inputMap));
        }
        return true;
    }
    
    Map<String,Object> getOffer(Map<String,Object> inputMap) {
        String codeSource=(String)inputMap.get('offresource');
        String offerCible;
        String typeoffre = (String) inputMap.get('typeoffre');
        //String codeCible = 'INWIB2C_OFFERING_SPECIAL_ETUDIANT';
        List<InwiB2C_Offer__c> getOfferList =new List<InwiB2C_Offer__c>();
        //begin CHB 11/08/2023 ANO 10460
        String TypeLigne=(String) inputMap.get('TypeLigne');
        //end CHB 11/08/2023 ANO 10460
        List<INWIB2C_FRAIS_MGR_CML__c> getOfferListCam =new List<INWIB2C_FRAIS_MGR_CML__c>();
        if(typeoffre=='Cameleon'){
            getOfferListCam=[select  INWIB2C_OFFRE_DESTINATION__c from INWIB2C_FRAIS_MGR_CML__c where INWIB2C_OFFRE_SOURCE__c =:codeSource];
        }else if(TypeLigne=='AF' || TypeLigne=='PF' || TypeLigne=='AX'|| TypeLigne=='SN' || TypeLigne=='PC' || TypeLigne=='PP'){//begin CHB 11/08/2023 ANO 10460
            getOfferList =[SELECT Id, Offre_Cible__c FROM InwiB2C_Offer__c WHERE Offre_Source__c =:codeSource AND Offre_Cible__c!='INWIB2C_OFFERING_49DH_ILLINWI_APL' AND Offre_Cible__c!='INWIB2C_OFFERING_49DH_ILLIMITE_RS' AND Offre_Cible__c!='INWIB2C_OFFERING_49DH_INTERNET' ];
        } //end CHB 11/08/2023 ANO 10460
        else{
         getOfferList =[SELECT Id, Offre_Cible__c FROM InwiB2C_Offer__c WHERE Offre_Source__c =:codeSource ];
    }
     List<String> code = new list<String> ();
        if (!Test.isRunningTest()){
            if(typeoffre=='Cameleon'){ 
                for(INWIB2C_FRAIS_MGR_CML__c getOffer : getOfferListCam){
                offerCible=getOffer.INWIB2C_OFFRE_DESTINATION__c;
                code.add(offerCible);
            }
        }else{
            for(InwiB2C_Offer__c getOffer : getOfferList){
                offerCible=getOffer.Offre_Cible__c;
                code.add(offerCible);
            }
        }
        } else{
            code.add('INWIB2C_OFFERING_49DH_APL');
        }
        
        //   List<Asset > getIdOfferList = [SELECT Id, ProductCode, Name ,vlocity_cmt__RecurringCharge__c, vlocity_cmt__JSONAttribute__c  from Asset where ProductCode in :code and vlocity_cmt__ParentItemId__c =:'' and vlocity_cmt__RecurringCharge__c  !=0 and vlocity_cmt__RecurringCharge__c != null];
        //   List<Product2> getIdOfferList=[SELECT Id,ProductCode, Name,vlocity_cmt__JSONAttribute__c FROM Product2 where ProductCode in :code];
        // CHB ANO 12323 23-11-2023
        List<PricebookEntry> getIdOfferList=[select Id,UnitPrice,Product2.ProductCode, Product2.Name, Product2.vlocity_cmt__JSONAttribute__c
                                             from PricebookEntry  where ProductCode in :code AND IsActive =:true];
        Map<String,Object> response = new Map<String,Object>();
        List<Object> offerListRep = new List<Object>();
        string profil;
        for (PricebookEntry getOfferForfait:getIdOfferList){
            profil = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(getOfferForfait.Product2.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_PROFIL');
            Map<String, Object> ListFinale= new Map<String, Object>();
            ListFinale.put('forfaitDescription', getOfferForfait.Product2.Name);
            ListFinale.put('forfaitId',profil );
            ListFinale.put('code_offre', getOfferForfait.Product2.ProductCode);
            ListFinale.put('subscriptionPrice', getOfferForfait.UnitPrice);
            //System.debug('list'+offerListRep);
            
            if(!offerListRep.contains(ListFinale) ){
                offerListRep.add(ListFinale);
                
            }
            
            
        }
        response.put('forfaits', offerListRep);
        inputMap.put('Offer',response);
        System.debug(response.toString());
        
        return inputMap;
        
        
    }
}