/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-28-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class InwiB2C_SearchOrderD2D implements vlocity_cmt.VlocityOpenInterface {
   
      global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options) {
         if (methodName == 'SearchOrderD2D')
        {
            searchOrderD2D(inputs, output, options);
        }

        return true;
    }
    private void searchOrderD2D(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
            String orderid = (String) input.get('orderid');
            String statut = (String) input.get('statut');
            String PosId = (String) input.get('PosId');
            String typeoffre = (String) input.get('typeoffre');
           // String usercreateur = (String) input.get('usercreateur');
            String userlivreur = (String) input.get('userlivreur');
            //String clientid = (String) input.get('clientid');
            String startdate = (String) input.get('startdate');
            String enddate = (String) input.get('enddate');
            String numcontact = (String) input.get('numcontact');
            String statuslivraison = (String) input.get('statuslivraison');
            String useranimateur = (String) input.get('useranimateur');
             
            System.debug('startdate ' + startdate);
            System.debug('enddate ' + enddate);
        
       /* if (String.isBlank(orderid)  && String.isBlank(statut)  && String.isBlank(PosId)  && String.isBlank(usercreateur)  && String.isBlank(userlivreur)  && String.isBlank(typeoffre)&& String.isBlank(typeoffre) && String.isBlank(clientid) ) {
            return;
        }*/
      
             // Construct the WHERE clause 
            String whereClause = ' WHERE (Product2.ProductCode like \'%TERMINAL%\' ) and Order.inwiB2C_Canal__c = \'inwiB2C_D2D\' ';
            if (String.isNotBlank(orderid)) {
                whereClause += ' AND orderid = \'' + orderid + '\'';
            }
            if (String.isNotBlank(statut)) {
                whereClause += ' AND Order.inwiB2C_Statut__c = \'' + statut + '\'';
            }
            if (String.isNotBlank(PosId)) {
                whereClause += ' AND Order.inwib2c_Partenaire__c = \'' + PosId + '\'';
            }
            if (String.isNotBlank(numcontact)) {
                whereClause += ' AND Order.Account.InwiB2C_Num_ro_de_contact__c = \'' + numcontact + '\'';
            }
            if (String.isNotBlank(userlivreur)) {
                whereClause += ' AND Order.OwnerId = \'' + userlivreur + '\'';
            }
            if(String.isNotBlank(typeoffre)){
                whereClause += ' AND Order.InwiB2C_Offre__c like \'%' + typeoffre + '%\'';
            }
            if(String.isNotBlank(statuslivraison)){
                whereClause += ' AND Order.InwB2C_Statut_livraison_D2D__c = \'' + statuslivraison + '\'';
            }
          if(String.isNotBlank(startdate) && String.isBlank(enddate)){
                whereClause += ' AND Order.CreatedDate = ' + startdate  ;
            }
           if(String.isNotBlank(startdate) && String.isNotBlank(enddate)){
                whereClause += ' AND Order.CreatedDate <= ' + enddate + ' AND Order.CreatedDate >= ' + startdate ;
           }
        if(String.isNotBlank(useranimateur)){
                whereClause += ' AND Order.inwiB2C_Animateur_D2D__c = \'' +  useranimateur + '\'' ;
        }

            
           String query = 'SELECT Id, OrderId, Order.OrderNumber,Order.Account.vlocity_cmt__PrimaryContactId__r.LastName, Order.Account.vlocity_cmt__PrimaryContactId__r.FirstName,' +
               'Order.Account.vlocity_cmt__PersonContactId__r.FirstName,  Order.Account.vlocity_cmt__PersonContactId__r.LastName,'+
                'Order.Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,Order.Account.vlocity_cmt__PrimaryContactId__r.InwiB2C_CIN__c,'+
               'vlocity_cmt__ParentItemId__c,Order.InwiB2C_Offre__c, Order.Account.InwiB2C_Address__r.InwiB2C_Adresse__c, ' +
                        'Order.InwB2C_Statut_livraison_D2D__c,Order.InwiB2C_Statut__c,Order.inwib2c_MotifAnnulation__c,Order.inwib2c_Motif_de_recyclage__c,Product2.ProductCode,Product2.Name, Order.CreatedById , '+
                'Order.InwiB2C_FMS_Total__c,Order.InwiB2C_FMD_Total__c , Order.Account.InwiB2C_Num_ro_de_contact__c , vlocity_cmt__JSONAttribute__c '+
                          'FROM OrderItem ' + whereClause + ' LIMIT 200 ' ;

            System.debug(query);
             List<OrderItem> orderItems = Database.query(query); 
            List<Map<String, Object>> transformedResults = new List<Map<String, Object>>();
            System.debug(' orderItems ' + orderItems);
        
            for(OrderItem item : orderItems) {
                Map<String, Object> resultInfo = new Map<String, Object>();
                System.debug(' json ' + item.vlocity_cmt__JSONAttribute__c);
                 if (item.vlocity_cmt__JSONAttribute__c != null) {
                Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__JSONAttribute__c);
                if (jsonMap.containsKey('INWIB2C_ACAT_MOBILE')) {
                    List<Object> INWIB2C_ACAT_MOBILE_Attributes = (List<Object>) jsonMap.get('INWIB2C_ACAT_MOBILE');
                    for (Object INWIB2C_ACAT_MOBILE_Attribute : INWIB2C_ACAT_MOBILE_Attributes) {
                        Map<String, Object> attributeMap = (Map<String, Object>) INWIB2C_ACAT_MOBILE_Attribute;
                        String attributeUniqueCode = (String) attributeMap.get('attributeuniquecode__c');
                        /*if ('INWIB2C_ATT_RT_CODE_ARTICLE'.equals(attributeUniqueCode)) {
                            Map<String, Object> attributeRunTimeInfo = (Map<String, Object>) attributeMap.get('attributeRunTimeInfo');
                            if (attributeRunTimeInfo != null && attributeRunTimeInfo.containsKey('value')) {
                                resultInfo.put('codearticle', attributeRunTimeInfo.get('value'));
                                break; 
                            }
                        }*/
                        System.debug('attributeUniqueCode '+attributeUniqueCode);
                         if ('INWIB2C_ATT_RT_MODELE'.equals(attributeUniqueCode)) {
                            Map<String, Object> attributeRunTimeInfo = (Map<String, Object>) attributeMap.get('attributeRunTimeInfo');
                             System.debug('codearticle'+attributeRunTimeInfo);
                            if (attributeRunTimeInfo != null && attributeRunTimeInfo.containsKey('value')) {
                                resultInfo.put('codearticle', attributeRunTimeInfo.get('value'));
                            }
                        }
                        if ('INWIB2C_ATT_DC_MODELELABEL'.equals(attributeUniqueCode)) {
                            Map<String, Object> attributeRunTimeInfo = (Map<String, Object>) attributeMap.get('attributeRunTimeInfo');
                            if (attributeRunTimeInfo != null && attributeRunTimeInfo.containsKey('value')) {
                                resultInfo.put('libelle', attributeRunTimeInfo.get('value'));
                            }
                        }
                       
                    }
                }
            }
         
            // H-M MC_MGEN3670SF_Phase 2 BO CRC D2D Begin
            Map<String, InwiB2C_AnnulationRejetConfig__mdt> motifMetadataMap = new Map<String, InwiB2C_AnnulationRejetConfig__mdt>();

            // Charger toutes les métadonnées dans la map
            for (InwiB2C_AnnulationRejetConfig__mdt motif : [
                SELECT Inwib2c_Libelle_MotifAnnulation__c, InwiB2C_Motif_Annulation__c, 
                       InwiB2C_Code_Motif_Annulation__c, Libelle_MotifRejet__c, 
                       InwiB2C_Motif_Rejet__c, InwiB2C_Code_Rejet__c  
                FROM InwiB2C_AnnulationRejetConfig__mdt WHERE Inwib2c_ActiveMotif__c = true 
            ]) {
                motifMetadataMap.put(motif.InwiB2C_Motif_Annulation__c, motif);
                motifMetadataMap.put(motif.InwiB2C_Motif_Rejet__c, motif); 
            }
            
            // Récupération des valeurs de l'Order
            String motifAnnulation = item.Order.inwib2c_MotifAnnulation__c;
            String motifRejet = item.Order.inwib2c_Motif_de_recyclage__c;
            
            
            System.debug('Motif Annulation: ' + motifAnnulation);
            System.debug('Motif Rejet: ' + motifRejet);
            
            String codemotifAnnulation, libelleMotifAnnulation, codeRejet, libelleMotifRejet;
            
            // Vérification et récupération des valeurs pour motif d'annulation
            if (String.isNotBlank(motifAnnulation) && motifMetadataMap.containsKey(motifAnnulation)) {
                InwiB2C_AnnulationRejetConfig__mdt motifData = motifMetadataMap.get(motifAnnulation);
                codemotifAnnulation = motifData.InwiB2C_Code_Motif_Annulation__c;
                libelleMotifAnnulation = motifData.Inwib2c_Libelle_MotifAnnulation__c;
            } else {
                System.debug('Motif Annulation non trouvé dans les metadata: ' + motifAnnulation);
            }
            
            // Vérification et récupération des valeurs pour motif de rejet
            if (String.isNotBlank(motifRejet) && motifMetadataMap.containsKey(motifRejet)) {
                InwiB2C_AnnulationRejetConfig__mdt motifData = motifMetadataMap.get(motifRejet);
                codeRejet = motifData.InwiB2C_Code_Rejet__c;
                libelleMotifRejet = motifData.Libelle_MotifRejet__c;
            } else {
                System.debug('Motif Rejet non trouvé dans les metadata: ' + motifRejet);
            }
            

                resultInfo.put('FMS', item.Order.InwiB2C_FMS_Total__c);
                resultInfo.put('FMD', item.Order.InwiB2C_FMD_Total__c);
                resultInfo.put('contactnumber', item.Order.Account.InwiB2C_Num_ro_de_contact__c);
                resultInfo.put('statut', item.Order.InwB2C_Statut_livraison_D2D__c);
                resultInfo.put('adresse', item.Order.Account.InwiB2C_Address__r.InwiB2C_Adresse__c);
                resultInfo.put('usercreateur', item.Order.CreatedById);
                resultInfo.put('offre', item.Order.InwiB2C_Offre__c);
                resultInfo.put('orderid', item.OrderId);
                resultInfo.put('ordernumber', item.Order.OrderNumber);
                resultInfo.put('motifAnnulation',libelleMotifAnnulation);
                resultInfo.put('statutOrder', item.Order.inwiB2C_Statut__c );
                resultInfo.put('codemotifAnnulation', codemotifAnnulation);
                resultInfo.put('codeRejet', codeRejet);
                resultInfo.put('motifRejet', libelleMotifRejet);
                resultInfo.put('siteid',item.Order.Account.InwiB2C_Address__r.Id);
                resultInfo.put('clientid', item.Order.AccountId);
                
             // H-M MC_MGEN3670SF_Phase 2 BO CRC D2D Begin

                
                String nom =  String.isNotBlank(item.Order.Account.vlocity_cmt__PrimaryContactId__r.LastName) ?  (String) item.Order.Account.vlocity_cmt__PrimaryContactId__r.LastName :  (String) item.Order.Account.vlocity_cmt__PersonContactId__r.LastName ;
                String prenom = String.isNotBlank(item.Order.Account.vlocity_cmt__PrimaryContactId__r.FirstName) ? (String) item.Order.Account.vlocity_cmt__PrimaryContactId__r.FirstName  :(String) item.Order.Account.vlocity_cmt__PersonContactId__r.FirstName;
         		String cin = String.isNotBlank(item.Order.Account.vlocity_cmt__PrimaryContactId__r.InwiB2C_CIN__c) ? (String) item.Order.Account.vlocity_cmt__PrimaryContactId__r.InwiB2C_CIN__c  :(String) item.Order.Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c;
                 
                resultInfo.put('nom', nom);
                resultInfo.put('prenom', prenom);
               resultInfo.put('cin', cin);
                
                
            transformedResults.add(resultInfo);
            }

            output.put('result', transformedResults);
      
   }
}