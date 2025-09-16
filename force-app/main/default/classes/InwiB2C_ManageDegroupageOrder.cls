public class InwiB2C_ManageDegroupageOrder  {
    public static void createNewDegroupageOrder(String orderId,String type){
        
        //create commande degroupage
        InwiB2C_Commande_de_degroupage__c commandeDeg = new InwiB2C_Commande_de_degroupage__c (InwiB2C_Order__c=orderId);
        insert commandeDeg;
        
        //get degroupage information
        String dslamPort = '';
        String statutLigneIam = '';
        String technoDegroupage = '';
        String positionReglette = '';
        Date rendezvous ;
        
        Order commande = [select id,inwib2c_Partenaire__c,inwib2c_Partenaire__r.inwib2c_CodePartenaire__c,AccountId,Account.vlocity_cmt__PersonContactId__r.FirstName,Account.vlocity_cmt__PersonContactId__r.LastName,Account.vlocity_cmt__PersonContactId__r.Phone,Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,vlocity_cmt__DefaultServiceAccountId__c,vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_numero_de_designation__c, vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_NomIAM__c,vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_PrenomIAM__c,vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_Adresse_Facture_IAM__c,vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Address__r.InwiB2C_Region__r.InwiB2C_RegionMdn__c from Order where Id =:orderId ];
        orderitem parent=[select id,vlocity_cmt__JSONAttribute__c  FROM orderitem WHERE OrderId  =: orderId and vlocity_cmt__ParentItemId__c =null and product2.vlocity_cmt__Type__c = 'ADSL' ];
        
        dslamPort= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(parent.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_IDPORTDSLAM');
        statutLigneIam = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(parent.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_DSLSRCSTAT');
        technoDegroupage = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(parent.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_ODSLB2CTA');
        positionReglette = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(parent.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_POSITMDF');
        rendezvous = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSONDate(parent.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_CRINSTAL');
        
        InwiB2C_Sequence_Order_Number__c parametresDeg = [select id,InwiB2C_typePrestation__c,InwiB2C_Debit__c,InwiB2C_qualiteService__c from InwiB2C_Sequence_Order_Number__c where InwiB2C_statut_ligne__c=: statutLigneIam and InwiB2C_Technologie__c=: technoDegroupage];
        
        Date dateOrder;
        DateTime dtOrder = System.now();
        dateOrder = date.newinstance(dtOrder.year(), dtOrder.month(), dtOrder.day());
        String nd ='';
        String ndOp = '';
        String nomIam =commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_NomIAM__c;
        String prenomIam = commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_PrenomIAM__c;
        Integer portabilite = 0;
        String codeRoutage ='';
        String numContact = '';
        Map<String, String> insertAdresse = new Map<String, String>();
        List<String> addSplitee = commande.vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_Adresse_Facture_IAM__c.split('\\|',-1);
        if(statutLigneIam =='LA' )
        {
            nd = commande.vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_numero_de_designation__c;
            portabilite = 1;
            if(commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Address__r.InwiB2C_Region__r.InwiB2C_RegionMdn__c == 'NORD')
                codeRoutage = 'E2101';
            else   
                codeRoutage = 'E3101';
        }
        if(statutLigneIam =='LI')
        {
            Map<Integer,String> formatAddresse = new Map<Integer,String>{0 =>'PORTE',1=>'ETAGE', 2=>'ESC', 3=>'BAT', 4=>'NVOIE', 5=>'CVOIE', 6=>'CQUARTIER',7 =>'CCOM'};
            ndOp=commande.vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_numero_de_designation__c;
            if(commande.Account.vlocity_cmt__PersonContactId__r.Phone != '')
                numContact=commande.Account.vlocity_cmt__PersonContactId__r.Phone;
            else
                numContact = '0600002028';
            for (Integer key : formatAddresse.keySet()){
                if(addSplitee[key].indexOf(';')== -1)
                    insertAdresse.put(formatAddresse.get(key),addSplitee[key]);
                else
                   insertAdresse.put(formatAddresse.get(key),addSplitee[key].substring(0,addSplitee[key].indexOf(';')));
                        }
        }
        if(String.isBlank(commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_NomIAM__c) || commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_NomIAM__c=='undefined' )
            nomIam = commande.Account.vlocity_cmt__PersonContactId__r.LastName;
        if(String.isBlank(commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_PrenomIAM__c) || commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_PrenomIAM__c=='undefined')
            prenomIam = commande.Account.vlocity_cmt__PersonContactId__r.FirstName;
        
        //create demande degroupage
        INWIB2C_DEMANDE_DEGROUPAGE__c degroupage = new INWIB2C_DEMANDE_DEGROUPAGE__c(
                        InwiB2C_Commande_de_degroupage__c=commandeDeg.Id,
                        InwiB2C_SEQ_NUM__c = 1,
                        InwiB2C_Order__c = commande.Id,
                        InwiB2C_NumeroDesignation__c = nd,
                        InwiB2C_CLIENT_TYPE__c ='B2C',
                        InwiB2C_Account__c = commande.AccountId,
                        InwiB2C_Site__c = commande.vlocity_cmt__DefaultServiceAccountId__c,
                        InwiB2C_LastName__c = nomIam,
                        InwiB2C_FirstName__c = prenomIam ,
                        InwiB2C_Nationalid__c = commande.Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,
                        InwiB2C_ADRESSE__c = commande.vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_Adresse_Facture_IAM__c,
                        InwiB2C_Statutdegroupage__c = 'NOU',
                        InwiB2C_Dslamport__c = dslamPort,
                        InwiB2C_StatutLigneIam__c = statutLigneIam,
                        InwiB2C_Technologie__c= technoDegroupage,
                        InwiB2C_PartenaireCode__c = commande.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c,
                        InwiB2C_ACTION__c = 'ADD',
                        InwiB2C_codeOpDemandeur__c = 'WNA',
                        InwiB2C_typeCommande__c = 'NA',
                        InwiB2C_ndOperateur__c = ndOp,
                        InwiB2C_dateOrdre__c = dateOrder,
                        InwiB2C_portabilite__c = portabilite,
                        InwiB2C_codeRoutage__c = codeRoutage,
                        InwiB2C_positionReglette__c = positionReglette,
                        InwiB2C_typePrestation__c = parametresDeg.InwiB2C_typePrestation__c,
                        InwiB2C_Debit__c = parametresDeg.InwiB2C_Debit__c,
                        InwiB2C_qualiteService__c = parametresDeg.InwiB2C_qualiteService__c,
                        InwiB2C_categorieClient__c = 'R',
                        InwiB2C_numeroContact__c = numContact,
                        InwiB2C_rendezvous__c = rendezvous,
                        InwiB2C_PORTE__c =insertAdresse.get('PORTE'),
                        InwiB2C_ETAGE__c = insertAdresse.get('ETAGE'),
                        InwiB2C_ESC__c = insertAdresse.get('ESC'),
                        InwiB2C_BAT__c = insertAdresse.get('BAT'),
                        InwiB2C_NVOIE__c = insertAdresse.get('NVOIE'), 
                        InwiB2C_CVOIE__c = insertAdresse.get('CVOIE'), 
                        InwiB2C_CQUARTIER__c = insertAdresse.get('CQUARTIER'), 
                        InwiB2C_CCOM__c = insertAdresse.get('CCOM'),
                       	InwiB2C_Agence__c = commande.inwib2c_Partenaire__c
                    );
                    insert degroupage;
    }
    
    public static String  cloneDemandeDeg(Map<String,object> inputs){
        String type='';
        String commDegId=inputs.get('InwiB2C_Commande_de_degroupage__c').toString();
        String newCommande=inputs.get('newCommande').toString();
        if(inputs.containsKey('type'))
        	type=inputs.get('type').toString();
        
        INWIB2C_DEMANDE_DEGROUPAGE__c  lastdemande = [select InwiB2C_Compteur_recyclage__c,InwiB2C_Compteur_relance__c,InwiB2C_Commande_de_degroupage__c,InwiB2C_ACTION__c,InwiB2C_ADRESSE__c,InwiB2C_Account__c,InwiB2C_AdresseIAMProposee__c,InwiB2C_Agence__c,InwiB2C_BAT__c,InwiB2C_CCOM__c,InwiB2C_CLIENT_TYPE__c,InwiB2C_CQUARTIER__c,InwiB2C_CVOIE__c,InwiB2C_CodeMotifRejet__c,InwiB2C_Commentaire__c,InwiB2C_DEGROUPAGE_NUM__c,InwiB2C_Debit__c,InwiB2C_DetailErreur__c,InwiB2C_Dslamport__c,InwiB2C_ESC__c,InwiB2C_ETAGE__c,InwiB2C_FirstName__c,InwiB2C_LastName__c,InwiB2C_MotifAnnulation__c,InwiB2C_Motif__c,InwiB2C_NVOIE__c,InwiB2C_Nationalid__c,InwiB2C_NouvelleTechnologie__c,InwiB2C_NumeroDesignation__c,InwiB2C_Order__c,InwiB2C_PORTE__c,InwiB2C_PartenaireCode__c,InwiB2C_SEQ_NUM__c,InwiB2C_Site__c,InwiB2C_StatutDegroupageIAM__c,InwiB2C_StatutLigneIam__c,InwiB2C_Statutdegroupage__c,InwiB2C_Technologie__c,InwiB2C_categorieClient__c,InwiB2C_codeOpDemandeur__c,InwiB2C_codeRoutage__c,InwiB2C_dateOrdre__c,InwiB2C_ndOperateur__c,InwiB2C_ndPrecedent__c,InwiB2C_numeroContact__c,InwiB2C_portabilite__c,InwiB2C_positionReglette__c,InwiB2C_qualiteService__c,InwiB2C_rendezvous__c,InwiB2C_typeCommande__c,InwiB2C_typePrestation__c,InwiB2C_AvecInstallationDomicile__c,InwiB2C_OrigineDemande__c,InwiB2C_Date_de_mise_en_service__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c  where InwiB2C_Commande_de_degroupage__c=: commDegId order by CreatedDate desc limit 1]; 	
        INWIB2C_DEMANDE_DEGROUPAGE__c cloneddemande=lastdemande.clone(false,true,false);
        if(newCommande=='true'){
            InwiB2C_Commande_de_degroupage__c commandeDeg = new InwiB2C_Commande_de_degroupage__c ();
            if(inputs.containsKey('InwiB2C_Order__c'))
            	commandeDeg.InwiB2C_Order__c=inputs.get('InwiB2C_Order__c').toString();
        	insert commandeDeg;
            cloneddemande.InwiB2C_SEQ_NUM__c=1;
            if(inputs.containsKey('InwiB2C_Order__c'))
            	cloneddemande.InwiB2C_Order__c = inputs.get('InwiB2C_Order__c').toString();
            cloneddemande.InwiB2C_Commande_de_degroupage__c=commandeDeg.Id;
            commDegId=commandeDeg.Id;
            /**B-27594 ILA 04/04/25 Start */
            cloneddemande.InwiB2C_Compteur_recyclage__c=0;
            /**B-27594 ILA 04/04/25 End */
                
        }
        else{
            cloneddemande.InwiB2C_SEQ_NUM__c =lastdemande.InwiB2C_SEQ_NUM__c + 1;
        }
        
        if(inputs.containsKey('InwiB2C_Statutdegroupage__c')){
            cloneddemande.InwiB2C_Statutdegroupage__c = inputs.get('InwiB2C_Statutdegroupage__c').toString();
            if(inputs.get('InwiB2C_Statutdegroupage__c')=='REU')
                cloneddemande.InwiB2C_Date_de_mise_en_service__c=Date.today();
        }
        if(inputs.containsKey('InwiB2C_CodeMotifRejet__c'))
            cloneddemande.InwiB2C_CodeMotifRejet__c=inputs.get('InwiB2C_CodeMotifRejet__c').toString();
        else
            cloneddemande.InwiB2C_CodeMotifRejet__c='';
        if(inputs.containsKey('InwiB2C_NouvelleTechnologie__c'))
            cloneddemande.InwiB2C_NouvelleTechnologie__c=inputs.get('InwiB2C_NouvelleTechnologie__c').toString();
        if(inputs.containsKey('InwiB2C_Motif__c'))
            cloneddemande.InwiB2C_Motif__c=inputs.get('InwiB2C_Motif__c').toString();
        else
            cloneddemande.InwiB2C_Motif__c='';
        if(inputs.containsKey('InwiB2C_typeCommande__c'))
            cloneddemande.InwiB2C_typeCommande__c=inputs.get('InwiB2C_typeCommande__c').toString();
        if(inputs.containsKey('InwiB2C_MotifAnnulation__c'))
            cloneddemande.InwiB2C_MotifAnnulation__c=inputs.get('InwiB2C_MotifAnnulation__c').toString();
        else
            cloneddemande.InwiB2C_MotifAnnulation__c='';
        if(inputs.containsKey('InwiB2C_LastName__c'))
            cloneddemande.InwiB2C_LastName__c=inputs.get('InwiB2C_LastName__c').toString();
        if(inputs.containsKey('InwiB2C_FirstName__c'))
            cloneddemande.InwiB2C_FirstName__c=inputs.get('InwiB2C_FirstName__c').toString();
        if(inputs.containsKey('InwiB2C_Nationalid__c'))
            cloneddemande.InwiB2C_Nationalid__c=inputs.get('InwiB2C_Nationalid__c').toString();
        if(inputs.containsKey('InwiB2C_Commentaire__c'))
            cloneddemande.InwiB2C_Commentaire__c=inputs.get('InwiB2C_Commentaire__c').toString();
        else 
            cloneddemande.InwiB2C_Commentaire__c='';
        if(inputs.containsKey('InwiB2C_numeroContact__c'))
            cloneddemande.InwiB2C_numeroContact__c=inputs.get('InwiB2C_numeroContact__c').toString();
        if(inputs.containsKey('InwiB2C_codeRoutage__c'))
            cloneddemande.InwiB2C_codeRoutage__c=inputs.get('InwiB2C_codeRoutage__c').toString();
        if(inputs.containsKey('InwiB2C_ADRESSE__c'))
            cloneddemande.InwiB2C_ADRESSE__c=inputs.get('InwiB2C_ADRESSE__c').toString();
        if(inputs.containsKey('InwiB2C_AdresseIAMProposee__c') && inputs.get('InwiB2C_AdresseIAMProposee__c').toString() != ''){
            cloneddemande.InwiB2C_AdresseIAMProposee__c=inputs.get('InwiB2C_AdresseIAMProposee__c').toString();
            if(inputs.containsKey('site')){
                String idSite=inputs.get('site').toString();
                Account site = [Select id,InwiB2C_Adresse_Modifi_par_IAM__c,InwiB2C_Adresse_proposee_IAM__c from Account where Id=:idSite ];
                site.InwiB2C_Adresse_Modifi_par_IAM__c = true;
                site.InwiB2C_Adresse_proposee_IAM__c=inputs.get('InwiB2C_AdresseIAMProposee__c').toString();
                update site;
            }
        }
        if(inputs.containsKey('InwiB2C_BAT__c'))
            cloneddemande.InwiB2C_BAT__c=inputs.get('InwiB2C_BAT__c').toString();
        if(inputs.containsKey('InwiB2C_CCOM__c'))
            cloneddemande.InwiB2C_CCOM__c=inputs.get('InwiB2C_CCOM__c').toString();
        if(inputs.containsKey('InwiB2C_CQUARTIER__c'))
            cloneddemande.InwiB2C_CQUARTIER__c=inputs.get('InwiB2C_CQUARTIER__c').toString();
        if(inputs.containsKey('InwiB2C_CVOIE__c'))
            cloneddemande.InwiB2C_CVOIE__c=inputs.get('InwiB2C_CVOIE__c').toString();
        if(inputs.containsKey('InwiB2C_ESC__c'))
            cloneddemande.InwiB2C_ESC__c=inputs.get('InwiB2C_ESC__c').toString();
        if(inputs.containsKey('InwiB2C_ETAGE__c'))
            cloneddemande.InwiB2C_ETAGE__c=inputs.get('InwiB2C_ETAGE__c').toString();
        if(inputs.containsKey('InwiB2C_NVOIE__c'))
            cloneddemande.InwiB2C_NVOIE__c=inputs.get('InwiB2C_NVOIE__c').toString();
        if(inputs.containsKey('InwiB2C_PORTE__c'))
            cloneddemande.InwiB2C_PORTE__c=inputs.get('InwiB2C_PORTE__c').toString();
        if(inputs.containsKey('InwiB2C_Technologie__c'))
            cloneddemande.InwiB2C_Technologie__c=inputs.get('InwiB2C_Technologie__c').toString();
        if(inputs.containsKey('InwiB2C_typePrestation__c'))
            cloneddemande.InwiB2C_typePrestation__c=inputs.get('InwiB2C_typePrestation__c').toString();
        if(type=='CHT')
        {
            String techno = inputs.get('InwiB2C_Technologie__c').toString();
            cloneddemande.InwiB2C_Order__c=null;
            InwiB2C_Sequence_Order_Number__c parametresDeg = [select id,InwiB2C_typePrestation__c,InwiB2C_Debit__c,InwiB2C_qualiteService__c from InwiB2C_Sequence_Order_Number__c where InwiB2C_statut_ligne__c=: lastdemande.InwiB2C_StatutLigneIam__c and InwiB2C_Technologie__c=: techno];
			cloneddemande.InwiB2C_typePrestation__c=parametresDeg.InwiB2C_typePrestation__c;
            cloneddemande.InwiB2C_qualiteService__c=parametresDeg.InwiB2C_qualiteService__c;
        }
        /**MGEN3568 07/08/24 ILA Start*/
        if(inputs.containsKey('InwiB2C_rendezvous__c') && inputs.get('InwiB2C_rendezvous__c').toString()!=''){
            DateTime rendesVous =(DateTime)JSON.deserialize('"'+String.valueOf(inputs.get('InwiB2C_rendezvous__c'))+'"', DateTime.class);
            //Date rendesVous = Date.valueOf(inputs.get('InwiB2C_rendezvous__c').toString());
            cloneddemande.InwiB2C_rendezvous__c=rendesVous;
        }
        if(inputs.containsKey('InwiB2C_UUID__c')){
            cloneddemande.InwiB2C_UUID__c = inputs.get('InwiB2C_UUID__c').toString();
        }
        if(inputs.containsKey('InwiB2C_Compteur_recyclage__c')){
            Integer compteur = Integer.valueOf(inputs.get('InwiB2C_Compteur_recyclage__c').toString());
            cloneddemande.InwiB2C_Compteur_recyclage__c = compteur;
            if(compteur == 2)
                cloneddemande.InwiB2C_Compteur_relance__c=0;
        }
        /**MGEN3568 07/08/24 ILA End*/
        
		
 
		insert cloneddemande;
        return commDegId;
    }

}