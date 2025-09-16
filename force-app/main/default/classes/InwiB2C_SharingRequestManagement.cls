/**
 * @description : cette classe permet de gerer les demandes de partage FTTH: 
 * 					createNewDegroupageOrder => creer une nouvelle demande de partage 
 * 					cloneDemandePrtage: cloner une demande de partage et mise a jour des champs
 * 					searchForScopedRequest => chercher les demandes de partage avec un scope
 *                  searchForUnscopedRequest => chercher les demandes de partage non scopées
 * 					getRequestStatus =>retourner les status de la demande pour les afficher sur le lwc recherche
 * @author            : Imane Lakrari
 * @last modified on  : 06-03-2025
 * @last modified by  : Imane Lakrari
**/
public class InwiB2C_SharingRequestManagement {
/**search for sharing requests not defined by a scope*/  
    public static List<Object> searchForUnscopedRequest(Map<String,object> input){
    // String jsonString='{"InwiB2C_Numero_Partage__c":"","InwiB2C_lineId__c":"","InwiB2C_NumeroDesignation__c":"","InwiB2C_Statut_demande__c":"REJ","InwiB2C_LastName__c":"","InwiB2C_numeroContact__c":"","CreatedDate":"","startDate":"","endDate":""}';
    // Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
    List<Object> requestList = new List<Object>();
    Map<String,Object> inputs=new Map<String,Object>();
        for(String iter1 : input.keySet()){
            if(input.get(iter1)!=''){
                inputs.put(iter1,input.get(iter1));
            }        
        }
    String profile= (String)inputs.get('profile');
    inputs.remove('profile');
    Integer size =inputs.size();
    Integer i=0;
    //K-KA 30-05-2025 B-29274 start
    String req='Select Id,InwiB2C_Compteur_recyclage__c,InwiB2C_Numero_Partage__c,InwiB2C_Sequence__c,InwiB2C_FirstName__c,InwiB2C_LastName__c,InwiB2C_nd_Attribut__c,InwiB2C_NumeroDesignation__c,CreatedDate,InwiB2C_Nationalid__c,InwiB2C_Operateur_Infrastructure__c,tolabel(InwiB2C_Statut_demande__c),InwiB2C_numeroContact__c,InwiB2C_Motif__c,tolabel(InwiB2C_Type_d_operation__c),InwiB2C_Code_Motif__c from inwiB2C_demande_partage__c where ';
    //K-KA 30-05-2025 B-29274 end
    for(String iter2 : inputs.keySet()){
        if(i==0){
            if (iter2 == 'CreatedDate'){
                req = req+'DAY_ONLY(CreatedDate)='+inputs.get(iter2);
                i++;
            }else if(iter2 == 'startDate'){
                req = req+'DAY_ONLY(CreatedDate) >'+inputs.get(iter2);
                i++;
            }else if(iter2 == 'endDate'){
                req = req+'DAY_ONLY(CreatedDate) <'+inputs.get(iter2);
                i++;
            }else if(iter2 =='InwiB2C_NumeroDesignation__c'){
                req = req+'(InwiB2C_NumeroDesignation__c =\''+inputs.get(iter2)+'\' Or InwiB2C_nd_Attribut__c=\''+inputs.get(iter2)+'\')';
                    i++;
            }
            //  K-KA 16-06-2025 - B-29805 START

            else if(iter2 =='InwiB2C_Order__r.inwib2c_Partenaire__c'){
                req = req + 'InwiB2C_Order__r.inwib2c_Partenaire__c = \'' + inputs.get(iter2) + '\'';
                    i++;
            }
            //  K-KA 16-06-2025 - B-29805 END
            else{
                req = req+iter2+'= \''+inputs.get(iter2)+'\'';
                i++;
            }	
        }else{
            if(iter2 == 'CreatedDate')
                req = req+' and DAY_ONLY(CreatedDate)='+inputs.get(iter2);
            else if(iter2 == 'startDate')
                req = req+' and DAY_ONLY(CreatedDate) >'+inputs.get(iter2);
            else if(iter2 == 'endDate')
                req = req+' and DAY_ONLY(CreatedDate) <'+inputs.get(iter2);
			else if(iter2 =='InwiB2C_NumeroDesignation__c')
                req = req+' and (InwiB2C_NumeroDesignation__c =\''+inputs.get(iter2) +'\' Or InwiB2C_nd_Attribut__c=\''+inputs.get(iter2)+'\')';
            //  K-KA 16-06-2025 - B-29805 START

            else if(iter2 =='InwiB2C_Order__r.inwib2c_Partenaire__c')
                req = req+' and (InwiB2C_Order__r.inwib2c_Partenaire__c)=\''+inputs.get(iter2)+'\'';
            //  K-KA 16-06-2025 - B-29805 END
            else
                req = req+' and '+iter2+'= \''+inputs.get(iter2)+'\'';
        }
    }
    // B-29331 ILA 06/06/2025 Start 
    // req = req+' and InwiB2C_Order__r.inwiB2C_Statut__c NOT IN (\'inwiB2C_Activee\',\'inwiB2C_Annulee\') Order by InwiB2C_Numero_Partage__c DESC,InwiB2C_Sequence__c DESC Limit 50';
     req = req+' Order by InwiB2C_Numero_Partage__c DESC,InwiB2C_Sequence__c DESC Limit 50';
    // B-29331 ILA 06/06/2025 End 
    //executer la requete
	List<inwiB2C_demande_partage__c> requests = DataBase.query(req);       
    if(!requests.isEmpty()){
        Map<String, String> maxNumeroPartageMap = new Map<String, String>();
        Map<String, Decimal> maxSequenceMap = new Map<String, Decimal>();
        Map<String, Map<String, Boolean>> buttonMap = new Map<String, Map<String, Boolean>>();
        // inwiB2C_Parametre_Demande_Partage__mdt nbrRecyclageMax=null; B-29237
        //si le profil = inwi pos les boutons recycler et annuler seront grisées(B-26678)
        if(profile != 'Inwi POS'){
            //recuperer le dernier numPartage et sequenece par rapport au nd
            //stocker les nd dans un set 
            Set<String> ndSet=new Set<String>();
            for (inwiB2C_demande_partage__c demande : requests) {
                ndSet.add(demande.InwiB2C_nd_Attribut__c);
            }
            //trouver le numPartage Order par Nd
            for (AggregateResult ar : [
                select InwiB2C_nd_Attribut__c, MAX(InwiB2C_Numero_Partage__c) maxNumero
                from inwiB2C_demande_partage__c
                where InwiB2C_nd_Attribut__c in : ndSet
                and InwiB2C_Order__r.inwiB2C_Statut__c NOT IN ('inwiB2C_Activee','inwiB2C_Annulee')
                group by InwiB2C_nd_Attribut__c
            ]) {
                maxNumeroPartageMap.put(
                (String) ar.get('InwiB2C_nd_Attribut__c'), 
                (String) ar.get('maxNumero')
                );
            }
            //trouver la sequenece max par numPartage
            for (AggregateResult ar:[
                        select InwiB2C_nd_Attribut__c, MAX(InwiB2C_Sequence__c) maxSequence
                        from inwiB2C_demande_partage__c
                        where InwiB2C_nd_Attribut__c IN :maxNumeroPartageMap.keySet()
                        and InwiB2C_Numero_Partage__c IN :maxNumeroPartageMap.values()
                        group by InwiB2C_nd_Attribut__c
                    ]){
                        String ndAttribut = (String) ar.get('InwiB2C_nd_Attribut__c');
                        Decimal maxSequence = (Decimal) ar.get('maxSequence');
                        maxSequenceMap.put(ndAttribut, maxSequence); 
            }
            //recuperer la configuration des statuts dans une map 
            List<InwiB2C_Button_Action_Vula__c> BAV=[Select toLabel(InwiB2C_Statut__c), InwiB2C_Cancel__c,InwiB2C_Recycle__c from InwiB2C_Button_Action_Vula__c];
                for (InwiB2C_Button_Action_Vula__c iter : BAV) {
                    buttonMap.put(iter.InwiB2C_Statut__c, new Map<String, Boolean>{
                        'cancel' => iter.InwiB2C_Cancel__c,
                        'recycle' => iter.InwiB2C_Recycle__c
                    });
                }
            //recuperer le nombre max de recyclage
            // nbrRecyclageMax = [select inwiB2C_value__c from inwiB2C_Parametre_Demande_Partage__mdt where DeveloperName ='NbrMaxRecyclage']; B-29237
        }  
        Map<String, Object> deserializedRequest = new Map<String,Object>();
        //Construire une liste des objets pour l'affichage
        for(inwiB2C_demande_partage__c iter3 : requests){
            //transformer le record en une map String/object
            deserializedRequest=(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(iter3));
            //construire un objet pour chaque record
            Map<String, Object> requestObject = new Map<String,Object>();
            //recuperer le statut des bouttons que pour les demandes avec max numPartage et maxSeq
            String ndAttribut = (String)deserializedRequest.get('InwiB2C_nd_Attribut__c');
            String numeroPartage = (String)deserializedRequest.get('InwiB2C_Numero_Partage__c');
            Integer sequence = (Integer)deserializedRequest.get('InwiB2C_Sequence__c');
            Integer CompteurRecylage = (Integer)deserializedRequest.get('InwiB2C_Compteur_recyclage__c');
            String Statut = (String)deserializedRequest.get('InwiB2C_Statut_demande__c');
            if (profile != 'Inwi POS' && numeroPartage == maxNumeroPartageMap?.get(ndAttribut) && sequence == maxSequenceMap?.get(ndAttribut)) {
                //on stock le ! du boolean pour l'utiliser dans disable lwc
                requestObject.put('CancelDisabled',!buttonMap?.get(Statut)?.get('cancel'));
                //02-06-2025 K-KA 28874 start
                if ( Statut == 'Suspendue' &&((String)deserializedRequest.get('InwiB2C_Code_Motif__c') == '24' ||(String)deserializedRequest.get('InwiB2C_Code_Motif__c') == '25')) {
                    requestObject.put('ReycleDisabled', true);
                }
                //02-06-2025 K-KA 28874 Fin
                
                 //MGEN3741-FTTH_VULA_Recyclage_hors délai-rejet-max suspension Meryem Yahya
                else if (Statut == 'DEF' && ((String)deserializedRequest.get('InwiB2C_Code_Motif__c') == '21' || (String)deserializedRequest.get('InwiB2C_Code_Motif__c') == '22'|| (String)deserializedRequest.get('InwiB2C_Code_Motif__c') == '23')) {
                    requestObject.put('ReycleDisabled', false);
                }
                //MGEN3741-FTTH_VULA_Recyclage_hors délai-rejet-max suspension Meryem Yahya
                
                
               else {
                // B-29237 02/06/25 ILA Start
                requestObject.put('ReycleDisabled',!buttonMap?.get(Statut)?.get('recycle'));
                /*
                //le recyclage se base aussi sur le compteur de recyclage
                if(buttonMap.get(Statut)?.get('recycle')==true && CompteurRecylage <Integer.valueof(nbrRecyclageMax.inwiB2C_value__c))
                        requestObject.put('ReycleDisabled',false);
                    else
                        requestObject.put('ReycleDisabled',true);
                        */
                // B-29237 02/06/25 ILA End
               } 
            }else{
                requestObject.put('CancelDisabled',true);
                requestObject.put('ReycleDisabled',true);   
            }
            for(String iter4 :deserializedRequest.keySet()){
                if(iter4 != 'attributes' && iter4 != 'RecordTypeId' && iter4 != 'CurrencyIsoCode')
                    requestObject.put(iter4,deserializedRequest.get(iter4));
            }
            //Ajouter l'objet a la liste retournée
            requestList.add(requestObject);
        }
    }
    return requestList;           
}

/**search for sharing requests defined by a scope*/
    public static List<Object> searchForScopedRequest(Map<String,object> input){
        //String jsonString = '{"InwiB2C_Numero_Partage__c":"00000010","InwiB2C_lineId__c":"","InwiB2C_NumeroDesignation__c":"","InwiB2C_nd_Attribut__c":""}';
		//Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        //recuperer les criteres not null
        Map<String,Object> inputs=new Map<String,Object>();
        for(String iter1 : input.keySet()){
            if(input.get(iter1)!=''){
                inputs.put(iter1,input.get(iter1));
            }        
        }
        String profile= (String)inputs.get('profile');
        inputs.remove('profile');
        //construire la requête dynamique
        Integer size =inputs.size();
        Integer i=0;
        //K-KA 30-05-2025 B-29274 start
        // B-29331 ILA 06/06/2025 add order to request statut Start
        String req='Select Id,InwiB2C_Compteur_recyclage__c,InwiB2C_Numero_Partage__c,InwiB2C_Sequence__c,InwiB2C_FirstName__c,InwiB2C_LastName__c,InwiB2C_nd_Attribut__c,InwiB2C_NumeroDesignation__c,CreatedDate,InwiB2C_Nationalid__c,InwiB2C_Operateur_Infrastructure__c,tolabel(InwiB2C_Statut_demande__c),InwiB2C_numeroContact__c,InwiB2C_Motif__c,tolabel(InwiB2C_Type_d_operation__c),InwiB2C_Code_Motif__c,InwiB2C_Order__r.inwiB2C_Statut__c from inwiB2C_demande_partage__c where ';
        // B-29331 ILA 06/06/2025 add order to request statut End
        //K-KA 30-05-2025 B-29274 end
        for(String iter2 : inputs.keySet()){
            if(i==0){
                if (iter2 == 'CreatedDate'){
                    req = req+'DAY_ONLY(CreatedDate)='+inputs.get(iter2);
                    i++;
                }
                else if(iter2 == 'startDate'){
                     req = req+'DAY_ONLY(CreatedDate) >'+inputs.get(iter2);
                    i++;
                }
                else if(iter2 == 'endDate'){
                               req = req+'DAY_ONLY(CreatedDate) <'+inputs.get(iter2);
                               i++;
                          }
				else if(iter2 =='InwiB2C_NumeroDesignation__c'){
                    req = req+'(InwiB2C_NumeroDesignation__c =\''+inputs.get(iter2)+'\' Or InwiB2C_nd_Attribut__c=\''+inputs.get(iter2)+'\')';
                    i++;
                }
                //  K-KA 16-06-2025 - B-29805 START
                else if(iter2 =='InwiB2C_Order__r.inwib2c_Partenaire__c'){
                req = req + 'InwiB2C_Order__r.inwib2c_Partenaire__c = \'' + inputs.get(iter2) + '\'';
                    i++;
                 }
                //  K-KA 16-06-2025 - B-29805 END
                else{
                    req = req+iter2+'= \''+inputs.get(iter2)+'\'';
                 	i++;
               }	
            }
            else{
                if(iter2 == 'CreatedDate')
                    req = req+' and DAY_ONLY(CreatedDate)='+inputs.get(iter2);
                else if(iter2 == 'startDate')
                    req = req+' and DAY_ONLY(CreatedDate) >'+inputs.get(iter2);
                else if(iter2 == 'endDate')
                    req = req+' and DAY_ONLY(CreatedDate) <'+inputs.get(iter2);
				else if(iter2 =='InwiB2C_NumeroDesignation__c')
                    req = req+' and (InwiB2C_NumeroDesignation__c =\''+inputs.get(iter2) +'\' Or InwiB2C_nd_Attribut__c=\''+inputs.get(iter2)+'\')';
                //  K-KA 16-06-2025 - B-29805 START
                    else if(iter2 =='InwiB2C_Order__r.inwib2c_Partenaire__c')
                    req = req + 'InwiB2C_Order__r.inwib2c_Partenaire__c = \'' + inputs.get(iter2) + '\'';
                //  K-KA 16-06-2025 - B-29805 END
                else
                	req = req+' and '+iter2+'= \''+inputs.get(iter2)+'\'';
            }
        }
        /************************************** */
    // B-29331 ILA 06/06/2025 Start 
    // req = req+' and InwiB2C_Order__r.inwiB2C_Statut__c NOT IN (\'inwiB2C_Activee\',\'inwiB2C_Annulee\') Order by InwiB2C_Numero_Partage__c DESC,InwiB2C_Sequence__c DESC Limit 50';
     req = req+' Order by InwiB2C_Numero_Partage__c DESC,InwiB2C_Sequence__c DESC Limit 50';
    // B-29331 ILA 06/06/2025 End 
        
        //executer la requete
        List<inwiB2C_demande_partage__c> requests = DataBase.query(req);
        List<Object> requestList = new List<Object>();
        //recupere le nombre max de recyclage
        // inwiB2C_Parametre_Demande_Partage__mdt nbrRecyclageMax = [select inwiB2C_value__c from inwiB2C_Parametre_Demande_Partage__mdt where DeveloperName ='NbrMaxRecyclage']; B-29237
        if(!requests.isEmpty()){
           //Construire une liste des objets pour l'affichage
           Map<String, Object> deserializedRequest = new Map<String,Object>();
           //get button's status for last demande
           inwiB2C_demande_partage__c lastDemande=requests[0];
           InwiB2C_Button_Action_Vula__c BAV=[Select InwiB2C_Cancel__c,InwiB2C_Recycle__c,InwiB2C_Statut__c from InwiB2C_Button_Action_Vula__c where tolabel(InwiB2C_Statut__c) =:lastDemande.InwiB2C_Statut_demande__c];
           for(inwiB2C_demande_partage__c iter3 : requests){
           //transformer le record en une map String/object
           deserializedRequest=(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(iter3));
           //construire un objet pour chaque record
           Map<String, Object> requestObject = new Map<String,Object>();
           //set button status only for the last demande
           // B-29331 ILA 06/06/2025 Start 
            //if (profile != 'Inwi POS' && iter3==requests[0]){
           
            if (profile != 'Inwi POS' && iter3==requests[0] && iter3.InwiB2C_Order__r.inwiB2C_Statut__c !='inwiB2C_Activee' && iter3.InwiB2C_Order__r.inwiB2C_Statut__c !='inwiB2C_Annulee'){
                  system.debug('status '+ BAV.InwiB2C_Statut__c + ' ' + (String)deserializedRequest.get('InwiB2C_Code_Motif__c')) ;
                    // B-29331 ILA 06/06/2025 End 
                requestObject.put('CancelDisabled',!BAV.InwiB2C_Cancel__c);
                //02-06-2025 K-KA 28874 start
                if (BAV.InwiB2C_Statut__c == 'SUS' && ((String)deserializedRequest.get('InwiB2C_Code_Motif__c') == '24' || (String)deserializedRequest.get('InwiB2C_Code_Motif__c') == '25')) {
                    requestObject.put('ReycleDisabled', true);
                }
                //02-06-2025 K-KA 28874 Fin
                
                //MGEN3741-FTTH_VULA_Recyclage_hors délai-rejet-max suspension Meryem Yahya
                else if (BAV.InwiB2C_Statut__c == 'DEF' && ((String)deserializedRequest.get('InwiB2C_Code_Motif__c') == '21' || (String)deserializedRequest.get('InwiB2C_Code_Motif__c') == '22'|| (String)deserializedRequest.get('InwiB2C_Code_Motif__c') == '23')) {
                    requestObject.put('ReycleDisabled', false);
                }
                //MGEN3741-FTTH_VULA_Recyclage_hors délai-rejet-max suspension Meryem Yahya
               else {
                    // B-29237 02/06/25 ILA Start
                    requestObject.put('ReycleDisabled',!BAV.InwiB2C_Recycle__c);
                    //le nombre de recyclage est limité par rapport au numéro de partage
                    /*
                    if(BAV.InwiB2C_Recycle__c==true && requests[0].InwiB2C_Compteur_recyclage__c <Integer.valueof(nbrRecyclageMax.inwiB2C_value__c))
                            requestObject.put('ReycleDisabled',false);
                        else
                            requestObject.put('ReycleDisabled',true);
                    */
                    // B-29237 02/06/25 ILA End
            }
           }
           else{
                requestObject.put('CancelDisabled',true);
                requestObject.put('ReycleDisabled',true);   
           }
           for(String iter4 :deserializedRequest.keySet()){
               if(iter4 != 'attributes' && iter4 != 'RecordTypeId' && iter4 != 'CurrencyIsoCode')
                   requestObject.put(iter4,deserializedRequest.get(iter4));
                }
            //Ajouter l'objet a la liste retournée
            requestList.add(requestObject);
            }
                
        }
        return requestList;
    }

/**create new sharing request*/

    public static void createNewSharingRequest(String orderId,String subId){

        //create commande de partage
        InwiB2C_Commande_de_partage__c commandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c=orderId);
        insert commandePartage;

        //get informations from order and site
        String statutLigne = '';
        Boolean Portability =false;
        String nd='';
        String ndAttribut='';
        String login='';
        String identifligne= 'ND';
        String operatorInfra='';
        String mac='';
        String codeRoutage ='';
        String rio='';
        String building ='';
        String projetid ='';
        String city ='';
        String street ='';
        String latitude ='';
        String longitude ='';
        String district =''; 
        DateTime rendezvous;
        String vitesse ='';
        String typePartage='';
        String cin='';
        String numContact='';

        Order commande = [select id,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_numvoiecode__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_numvoievalue__c,
        vlocity_cmt__DefaultServiceAccountId__r.inwib2c_voievalue__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_voiecode__c,
        vlocity_cmt__DefaultServiceAccountId__r.inwib2c_quartiervalue__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_quartiercode__c,
        vlocity_cmt__DefaultServiceAccountId__r.inwib2c_communevalue__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_communecode__c,
        vlocity_cmt__DefaultServiceAccountId__r.inwib2c_provincevalue__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_provincecode__c,
        AccountId,Account.vlocity_cmt__PersonContactId__r.FirstName,Account.vlocity_cmt__PersonContactId__r.LastName,Account.vlocity_cmt__PersonContactId__r.Phone,Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,
        vlocity_cmt__DefaultServiceAccountId__c,vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_numero_de_designation__c,vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Portabilite__c,vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_LoginIAM__c,
        vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Identifiant_de_la_ligne__c,vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Address__r.InwiB2C_Region__r.InwiB2C_RegionMdn__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_building__c,vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Plaque__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_city__c
        ,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_street__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_latitude__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_longitude__c, vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_district__c from Order where Id =:orderId ];
        
        orderitem parent=[select id,vlocity_cmt__JSONAttribute__c,vlocity_cmt__Product2Id__r.ProductCode  FROM orderitem WHERE OrderId  =: orderId and vlocity_cmt__ParentItemId__c =null and product2.vlocity_cmt__Type__c = 'FTTH' ];
        orderitem numTel=[select id,vlocity_cmt__JSONAttribute__c  FROM orderitem WHERE OrderId  =: orderId and vlocity_cmt__RootItemId__c =: parent.Id and product2.ProductCode = 'INWIB2C_FOB2C_OFFERING_MSISDN_STANDARD' ];
        orderitem terminal=[select id,vlocity_cmt__JSONAttribute__c  FROM orderitem WHERE OrderId  =: orderId and vlocity_cmt__RootItemId__c =: parent.Id and product2.ProductCode = 'INWIB2C_FOB2C_OFFERING_TERMINAL' ];
        
        statutLigne=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(parent.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_STATUTPARTAGE');
        //B-27482
        if (statutLigne=='LA' && commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Portabilite__c=='Oui')
        {
            Portability=true;
        }
        identifligne=commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Identifiant_de_la_ligne__c;
        operatorInfra=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(parent.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_OPERATEUROI');
        mac=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(terminal.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_IMEI');
        rio=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(numTel.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_RIO');
        rendezvous= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSONDateTime(parent.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_INSTALLDATE');
        typePartage=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(parent.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_TYPEPARTAGE');
        //mapping offre speed
       
        InwiB2C_mapping_offres_speed__mdt speed=[ select InwiB2C_speed__c from InwiB2C_mapping_offres_speed__mdt  where InwiB2C_CodeOffre__c =:parent.vlocity_cmt__Product2Id__r.ProductCode ];
        vitesse= speed.InwiB2C_speed__c;
        //set Nd or login
        if(statutLigne=='LA'){
            if(identifligne=='Login')
                login=commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_LoginIAM__c;
            else{
                String ndTMP=commande.vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_numero_de_designation__c;
                nd=ndTMP;
                if(ndTMP.startswith('212'))
                    nd='0'+ndTMP.substring(3);
            }
                
        }
        //set num contact
        String numContactTMP=commande.Account.vlocity_cmt__PersonContactId__r.Phone;
        numContact=numContactTMP;
        if(!numContactTMP.startswith('05'))
                    numContact='0'+numContactTMP.substring(3);
        //set NdAttribute
        // String ndOrderItem = (Portability==true)?'INWIB2C_ATT_RT_MSISDN_PORTED':'INWIB2C_ATT_RT_MSISDN';
        // String ndAttributeTMP=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(numTel.vlocity_cmt__JSONAttribute__c, ndOrderItem);
        //B-27597 08\04\25 ILA Start
        if (!(statutLigne =='LA' && Portability ==true)){
            String ndAttributeTMP=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(numTel.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_MSISDN' );
            ndAttribut=ndAttributeTMP;
            if(!ndAttributeTMP.startswith('05')){
                ndAttribut='0'+ndAttributeTMP.substring(3);
            }
        }
        //B-27597 08\04\25 ILA End
        //set routing code 
        if(Portability==true)
            codeRoutage=(commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Address__r.InwiB2C_Region__r.InwiB2C_RegionMdn__c == 'NORD')?'E2101':'E3101'; 
        //set CIN: ne pas envoyer dans le cas de ligne inactive B-24551/B-24548/B-27338
        if(statutLigne=='LA')
            cin=commande.Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c;
        //set address for Orange OI
        building=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_building__c;
        projetid=commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Plaque__c;
        city=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_city__c;
        street=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_street__c;
        latitude =commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_latitude__c;
        longitude =commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_longitude__c;
        district =commande.vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_district__c;

        //create demande de partage
        inwiB2C_demande_partage__c newRequest = new inwiB2C_demande_partage__c(
            InwiB2C_Commande_de_partage__c=commandePartage.id,
            InwiB2C_Sequence__c=1,
            InwiB2C_Statut_demande__c='NOU',
            InwiB2C_Account__c=commande.AccountId,
            InwiB2C_Site__c=commande.vlocity_cmt__DefaultServiceAccountId__c,
            InwiB2C_Order__c=commande.Id,
            InwiB2C_Statut_ligne__c=statutLigne,
            InwiB2C_Operateur_Infrastructure__c=operatorInfra,
            InwiB2C_Operateur_commercial__c='WANA',
            Type_de_partage__c=typePartage,
            InwiB2C_NumeroDesignation__c=nd,
            InwiB2C_Login__c=login,
            InwiB2C_nd_Attribut__c=ndAttribut,
            InwiB2C_FirstName__c=commande.Account.vlocity_cmt__PersonContactId__r.FirstName,
            InwiB2C_LastName__c=commande.Account.vlocity_cmt__PersonContactId__r.LastName,
            InwiB2C_Nationalid__c=cin,
            InwiB2C_numeroContact__c=numContact,
            InwiB2C_Installation_CPE__c=true,
            InwiB2C_Identifiant_CPE__c=mac,
            //B-26687
            InwiB2C_savPlus__c=false,
            InwiB2C_Province__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_provincevalue__c,
            InwiB2C_Code_Province__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_provincecode__c,
            InwiB2C_Commune__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_communevalue__c,
            InwiB2C_Code_Commune__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_communecode__c,
            inwiB2C_Quartier__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_quartiervalue__c,
            InwiB2C_Code_Quartier__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_quartiercode__c,
            InwiB2C_Voie__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_voievalue__c,
            InwiB2C_Code_Voie__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_voiecode__c,
            InwiB2C_Numero_de_la_voie__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_numvoievalue__c,
            InwiB2C_Code_de_Numero_de_la_voie__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_numvoiecode__c,
            InwiB2C_codeRoutage__c=codeRoutage,
            InwiB2C_Portabilite__c=Portability,
            InwiB2C_Rio__c=rio,
            inwib2c_building__c=building,
            inwib2c_projetid__c=projetid,
            inwib2c_city__c=city,
            inwib2c_street__c=street,
            inwib2c_latitude__c=latitude ,
            inwib2c_longitude__c=longitude ,
            inwiB2C_district__c=district,
            InwiB2C_rendezvous__c=rendezvous,
            InwiB2C_Vitesse__c=vitesse,
            InwiB2C_Type_d_operation__c='NA',
            InwiB2C_Subscription__c=subId
        );
        insert newRequest;

    }
    
/**clone existing sharing request*/
    public static String  cloneSharingRequest(Map<String,object> inputs){
        
        String sharingOrderId=inputs.get('InwiB2C_Commande_de_partage__c').toString();
        String newCommande=inputs.get('newCommande').toString();
        
        //get the last request and clone it
        /* MGEN3729 04/06/25 ILA Start
            add proposed fields to the request
        */
        inwiB2C_demande_partage__c lastrequest=[Select inwiB2C_Subscription__c, InwiB2C_Compteur_recyclage__c,InwiB2C_Type_d_operation__c,inwib2c_city__c, inwib2c_latitude__c, inwib2c_longitude__c, inwiB2C_district__c, inwib2c_street__c,inwib2c_projetid__c, inwib2c_building__c,InwiB2C_UUID__c,InwiB2C_Commande_de_partage__c,InwiB2C_Sequence__c,InwiB2C_Account__c,InwiB2C_Site__c,InwiB2C_Order__c,InwiB2C_Statut_ligne__c,InwiB2C_NumeroDesignation__c,InwiB2C_Operateur_Infrastructure__c,InwiB2C_FirstName__c,InwiB2C_LastName__c,InwiB2C_numeroContact__c,InwiB2C_Nationalid__c,InwiB2C_rendezvous__c,InwiB2C_codeRoutage__c,InwiB2C_Province__c,inwiB2C_Quartier__c,InwiB2C_Commune__c,InwiB2C_Voie__c,InwiB2C_Numero_de_la_voie__c,InwiB2C_Vitesse__c,InwiB2C_nd_Attribut__c,InwiB2C_Operateur_commercial__c,Type_de_partage__c,InwiB2C_Login__c,InwiB2C_Identifiant_CPE__c,InwiB2C_Rio__c,InwiB2C_Installation_CPE__c,InwiB2C_savPlus__c,InwiB2C_Portabilite__c,InwiB2C_Code_Province__c,InwiB2C_Code_Commune__c,InwiB2C_Code_Quartier__c,InwiB2C_Code_Voie__c,InwiB2C_Code_de_Numero_de_la_voie__c,InwiB2C_lineId__c,InwiB2C_Province_proposee__c,InwiB2C_Code_Province_propose__c,InwiB2C_Commune_Proposee__c,InwiB2C_Code_Commune_Propose__c,InwiB2C_Quartier_Propose__c,InwiB2C_Code_Quartier_Propose__c,InwiB2C_Voie_Porposee__c,InwiB2C_Code_Voie_Porposee__c,InwiB2C_Numero_de_voie_propose__c,InwiB2C_Latitude_proposee__c,InwiB2C_Longitude_Proposee__c,InwiB2C_Building_Propose__c,InwiB2C_City_proposee__c,InwiB2C_PlateId_Proposee__c,InwiB2C_Street_Propose__c,InwiB2C_District_Propose__c,InwiB2C_Date_de_mise_en_service__c,InwiB2C_Statut_demande__c from inwiB2C_demande_partage__c where InwiB2C_Commande_de_partage__c=:sharingOrderId order by CreatedDate desc limit 1];

        inwiB2C_demande_partage__c clonedRequest = lastrequest.clone(false,true,false);
        
       //si commande = true => génération d'une nouvelle commande de partage (génération d'un nouvel numéro de partage)
        if(newCommande=='true'){
            InwiB2C_Commande_de_partage__c commandePartage = new InwiB2C_Commande_de_partage__c();
            if(inputs.containsKey('InwiB2C_Order__c')){
                commandePartage.InwiB2C_Order__c=inputs.get('InwiB2C_Order__c').toString();
                clonedRequest.InwiB2C_Order__c=inputs.get('InwiB2C_Order__c').toString();
            }
            else
                commandePartage.InwiB2C_Order__c=lastrequest.InwiB2C_Order__c;
            insert commandePartage;
            clonedRequest.InwiB2C_Sequence__c=1;
            clonedRequest.InwiB2C_Commande_de_partage__c=commandePartage.Id;
            sharingOrderId=commandePartage.Id;   
        }
        else
            clonedRequest.InwiB2C_Sequence__c=lastrequest.InwiB2C_Sequence__c+1;
        //update fields received as inputs
        for(String key : inputs.keySet()){
            if(key=='InwiB2C_Order__c' || key=='newCommande')
                continue;
            else if(key=='InwiB2C_rendezvous__c'){
                if(inputs.get(key).toString()!=''){
                    DateTime rendesVous =(DateTime)JSON.deserialize('"'+String.valueOf(inputs.get(key))+'"', DateTime.class);
                    clonedRequest.put(key,rendesVous);
                }
            }
            else if(key=='InwiB2C_Compteur_recyclage__c'){
                clonedRequest.put(key,Integer.valueOf(inputs.get(key).toString()));
            }
            //R-SL Ticket B-29934 19/06/2025 start
            else if(key==('InwiB2C_Statut_demande__c')){
            clonedRequest.put(key,inputs.get(key).toString());
            if(inputs.get(key)=='MES')
                clonedRequest.InwiB2C_Date_de_mise_en_service__c=Date.today();
        }
        //R-SL Ticket B-29934 19/06/2025 end
            else{
                if(inputs.get(key).toString()!=''){
                    clonedRequest.put(key,inputs.get(key).toString());
                }
            }
        }
        
        // MGEN3729 04/06/25 ILA End
                
        insert clonedRequest;
        return clonedRequest.Id;
        

    }
    
/**Get statut picklits values*/
    public static List <Map <String,String>>  getRequestStatus(Map<String,object> inputs) {
        //recuperer le nom du cjamp depuis l input
        String fieldName=inputs.get('fieldName').toString();
        List<String> statutList = new List<String>();
        // Récupère les données du champ de InwiB2C_Statut__c'
        Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get('inwiB2C_demande_partage__c').getDescribe();
        Schema.DescribeFieldResult StatLabel = objDescribe.fields.getMap().get(fieldName).getDescribe();
        //Schema.DescribeFieldResult StatLabel = inwiB2C_demande_partage__c.InwiB2C_Statut_demande__c.getDescribe();
       List<Schema.PicklistEntry>  Label= StatLabel.getPicklistValues();
        // liste de maps contenant les labels et valeurs
       List <Map <String,String>> statut = new List <Map <String,String>> ();
        for (Schema.PicklistEntry stat : Label ){
           Map <String,String> statutMap  = new Map <String,String> ();
           statutMap.put('label', stat.getLabel());
           statutMap.put('value', stat.getValue());
           statut.add(statutMap);
      }
        return statut;
    }
    

}