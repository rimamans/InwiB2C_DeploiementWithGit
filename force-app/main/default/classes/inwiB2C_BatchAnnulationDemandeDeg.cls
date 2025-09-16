public class inwiB2C_BatchAnnulationDemandeDeg implements Database.Batchable<SObject>, Database.Stateful{
    
    //private Integer totalProcessed = 0;
    private Integer maxPerNight;
    private Integer expirationTimeSubmission;
    private Integer expirationTimeSuspension;   
    private Integer batchSize;
    private Integer totalProcessedRecords;
    
    public inwiB2C_BatchAnnulationDemandeDeg(Integer batchSize) {
        this.batchSize = batchSize;
        inwiB2C_Limit_Annulation_demande_deg__mdt limitMetadata = [
            Select inwiB2C_Value__c 
            From inwiB2C_Limit_Annulation_demande_deg__mdt 
            Where DeveloperName = 'Limite' 
            Limit 1
        ];
        inwiB2C_Limit_Annulation_demande_deg__mdt expirationTimeSuspensionMetadata = [
            Select inwiB2C_Value__c 
            From inwiB2C_Limit_Annulation_demande_deg__mdt 
            Where DeveloperName = 'Expiration_time_Sus'
            Limit 1
        ];
        inwiB2C_Limit_Annulation_demande_deg__mdt expirationTimeSubmissionMetadata = [
            Select inwiB2C_Value__c 
            From inwiB2C_Limit_Annulation_demande_deg__mdt 
            Where DeveloperName = 'Expiration_time_Sub'
            Limit 1
        ];
        
        inwiB2C_BatchAnnulationDemDegCounter__c totalProcessedRecordsCounter = [
            SELECT inwiB2C_Total_Processed_Records__c, SetupOwner.Name 
            FROM inwiB2C_BatchAnnulationDemDegCounter__c 
            where SetupOwner.Name = 'Wana corporate/inwi B2C'
            Limit 1
        ];
        
        this.maxPerNight = Integer.ValueOf(limitMetadata.inwiB2C_Value__c);
        this.expirationTimeSuspension = Integer.ValueOf(expirationTimeSuspensionMetadata.inwiB2C_Value__c);
        this.expirationTimeSubmission = Integer.ValueOf(expirationTimeSubmissionMetadata.inwiB2C_Value__c);
        this.totalProcessedRecords = Integer.ValueOf(totalProcessedRecordsCounter.inwiB2C_Total_Processed_Records__c);
    }
    
   public Database.QueryLocator start(Database.BatchableContext bc) {
         String query = 'SELECT Id, InwiB2C_Commande_de_degroupage__c, InwiB2C_Statutdegroupage__c, InwiB2C_CodeMotifRejet__c, ' +
                'InwiB2C_Order__c, InwiB2C_StatutLigneIam__c, InwiB2C_Technologie__c, InwiB2C_rendezvous__c, ' +
                'InwiB2C_Compteur_relance__c, InwiB2C_LastName__c, InwiB2C_FirstName__c, InwiB2C_Nationalid__c, ' +
                'InwiB2C_Commentaire__c, InwiB2C_numeroContact__c, InwiB2C_codeRoutage__c, InwiB2C_ADRESSE__c, ' +
                'InwiB2C_AdresseIAMProposee__c, InwiB2C_BAT__c, InwiB2C_CCOM__c, InwiB2C_CQUARTIER__c, InwiB2C_CVOIE__c, ' +
                'InwiB2C_ESC__c, InwiB2C_ETAGE__c, InwiB2C_NVOIE__c, InwiB2C_PORTE__c, InwiB2C_Technologie__c, ' +
                'InwiB2C_typePrestation__c ' +
                   'FROM INWIB2C_DEMANDE_DEGROUPAGE__c ' +
                   //'WHERE InwiB2C_Statutdegroupage__c NOT IN (\'REU\', \'ACT\', \'InwiB2C_EnErreur\', \'TCA\', \'ANN\', \'DAN\') ' +
                   //'WHERE InwiB2C_Statutdegroupage__c IN (\'SOU\', \'SUS\') ' +
                   'ORDER BY InwiB2C_DEGROUPAGE_NUM__c DESC, InwiB2C_SEQ_NUM__c DESC';

     Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>> groupedRecords = new Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>>();
       List<INWIB2C_DEMANDE_DEGROUPAGE__c> allRecords = Database.query(query);
        
        for (INWIB2C_DEMANDE_DEGROUPAGE__c record : allRecords) {
            String groupKey = String.ValueOf(record.InwiB2C_DEGROUPAGE_NUM__c);
            if (!groupedRecords.containsKey(groupKey)) {
                groupedRecords.put(groupKey, new List<INWIB2C_DEMANDE_DEGROUPAGE__c>());
            }
            groupedRecords.get(groupKey).add(record);
        }
        
      return Database.getQueryLocator(query);
    }


    public void execute(Database.BatchableContext bc, List<INWIB2C_DEMANDE_DEGROUPAGE__c> scope) {
        
         Set<String> demandeStatus = new Set<String>{'REU', 'ACT', 'InwiB2C_EnErreur', 'TCA', 'ANN', 'DAN'};
         Set<String> suspendedStatusCodes = new Set<String>{'63', '24', '56', '70', '71', '73', '48', '66'};
        
         Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>> groupedRecords = new Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>>();
      //  Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>> processedGroupe = new Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>>();
        List<INWIB2C_DEMANDE_DEGROUPAGE__c> demandetoCancel = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
        
        for (INWIB2C_DEMANDE_DEGROUPAGE__c record : scope) {
            if (!groupedRecords.containsKey(record.InwiB2C_Commande_de_degroupage__c)) {
                groupedRecords.put(record.InwiB2C_Commande_de_degroupage__c, new List<INWIB2C_DEMANDE_DEGROUPAGE__c>());
            }
            groupedRecords.get(record.InwiB2C_Commande_de_degroupage__c).add(record);
        }
        
        Date todayDate = Date.today();
        
        for (String key : groupedRecords.keySet()) {
            
            if (totalProcessedRecords == maxPerNight) {
                   break; // Stop processing if the total records processed reaches maxPerNight
             }
            
            List<INWIB2C_DEMANDE_DEGROUPAGE__c> records = groupedRecords.get(key);
            
            INWIB2C_DEMANDE_DEGROUPAGE__c lastSuspended = null;
            INWIB2C_DEMANDE_DEGROUPAGE__c lastDemande = records[0];
            List<INWIB2C_DEMANDE_DEGROUPAGE__c> suspensions = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
            INWIB2C_DEMANDE_DEGROUPAGE__c firstSubmitted = null;

            for (INWIB2C_DEMANDE_DEGROUPAGE__c record : records) {
                if (record.InwiB2C_Statutdegroupage__c == 'SUS') {
                    suspensions.add(record);
                    if (lastSuspended == null) {
                        lastSuspended = record; // First suspended record found
                    }
                } else if (record.InwiB2C_Statutdegroupage__c == 'SOU') {
                    firstSubmitted = record; 
                }
            }

            // Process Case 1: Suspension with Expired Deadline
            if (lastDemande != null) {
                DateTime deadlineSuspension = getWorkingDateAterXDays(lastDemande.CreatedDate, expirationTimeSuspension);
                if (todayDate > deadlineSuspension && lastDemande.InwiB2C_Statutdegroupage__c == 'SUS' && suspendedStatusCodes.contains(lastDemande.InwiB2C_CodeMotifRejet__c)) {
                    demandetoCancel.add(lastDemande);
                    totalProcessedRecords++;
                    continue; // Move to the next group
                }
            }

            // Process Case 2: Submission to IAM with Expired Deadline
            if (firstSubmitted != null) {
                DateTime deadlineSubmission = getWorkingDateAterXDays(firstSubmitted.CreatedDate, expirationTimeSubmission);
                if (todayDate > deadlineSubmission && !demandeStatus.contains(lastDemande.InwiB2C_Statutdegroupage__c)) {
                   demandetoCancel.add(lastDemande);
                    totalProcessedRecords++;
                    continue; 
                }
            }

            // Process Case 3: Suspended Status with Recycling and Deadline Not Passed
            if (suspensions.size() == 3) {
                INWIB2C_DEMANDE_DEGROUPAGE__c thirdSuspension = suspensions[0]; // Third suspension
                DateTime deadlineThirdSuspension = getWorkingDateAterXDays(thirdSuspension.CreatedDate, expirationTimeSuspension);
                if (todayDate <= deadlineThirdSuspension && lastDemande.InwiB2C_Compteur_recyclage__c >= 2 && lastDemande.InwiB2C_Statutdegroupage__c == 'SUS'&& suspendedStatusCodes.contains(lastDemande.InwiB2C_CodeMotifRejet__c)) {
                   demandetoCancel.add(lastDemande);
                    totalProcessedRecords++;
                    continue; 
                }
            }
        }

        if (!demandetoCancel.isEmpty()) {
        System.enqueueJob(new inwiB2C_AnnulationDemandeDegApiCall(demandetoCancel));
   		
        
        inwiB2C_BatchAnnulationDemDegCounter__c ProcessedRecordsCounter = [
            SELECT inwiB2C_Total_Processed_Records__c, SetupOwner.Name 
            FROM inwiB2C_BatchAnnulationDemDegCounter__c 
            where SetupOwner.Name = 'Wana corporate/inwi B2C'
            Limit 1
        ];
		
            if(ProcessedRecordsCounter != null) {
            ProcessedRecordsCounter.inwiB2C_Total_Processed_Records__c += totalProcessedRecords;
            update ProcessedRecordsCounter;
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch finished processing ' + totalProcessedRecords + ' records.');
    }
    
    
    public static DateTime getWorkingDateAterXDays(DateTime inputDate, Integer numberOfDays) {

    Set<Date> holidays = new Set<Date>();
    
    for (InwiB2C_Holidays__c holiday : [
        SELECT inwib2c_date__c 
        FROM InwiB2C_Holidays__c 
        WHERE inwib2c_date__c >= :inputDate.date()
    ]) {
        holidays.add(holiday.inwib2c_date__c);
    }

    Integer workingDaysAdded = 0;
    DateTime currentDate = inputDate;

    // Loop until the required number of working days is added
    while (workingDaysAdded < numberOfDays) {
 
        currentDate = currentDate.addDays(1);

        // Check if it's a weekend
        DateTime dateTimeE = DateTime.newInstance(currentDate.year(), currentDate.month(), currentDate.day());
        Integer dayOfWeek = Integer.valueOf(dateTimeE.format('u'));
        Boolean isWeekend = (dayOfWeek == 6 || dayOfWeek == 7); // 6 = Saturday, 7 = Sunday
        
        // Check if it's a holiday
        Boolean isHoliday = holidays.contains(currentDate.date());

        // If it's not a weekend and not a holiday, count it as a working day
        if (!isWeekend && !isHoliday) {
            workingDaysAdded++;
        }
    }

    return currentDate;
	}



    public void cancelDmande(List<INWIB2C_DEMANDE_DEGROUPAGE__c> demandesToCancel) {
        
        
    List<InwiB2C_Commande_de_degroupage__c> newCommandes = new List<InwiB2C_Commande_de_degroupage__c>();
    List<INWIB2C_DEMANDE_DEGROUPAGE__c> lastDemandes = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
    List<INWIB2C_DEMANDE_DEGROUPAGE__c> lastDemandesToCancel = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
    List<INWIB2C_DEMANDE_DEGROUPAGE__c> clonedDemandes = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
    Set<String> mdnSet = new Set<String>();
    Set<String> commandeDegroupageSet = new Set<String>();
    
    // Step 1: Create new InwiB2C_Commande_de_degroupage__c records 
    for (INWIB2C_DEMANDE_DEGROUPAGE__c demande : demandesToCancel) {
		commandeDegroupageSet.add(demande.InwiB2C_Commande_de_degroupage__c);
        InwiB2C_Commande_de_degroupage__c newCommande = new InwiB2C_Commande_de_degroupage__c();
        newCommande.InwiB2C_Order__c = demande.InwiB2C_Order__c;
        newCommandes.add(newCommande);
    }
    
    // Bulk insert new commandes
    insert newCommandes;
        
     //Query latest demande
     lastDemandes = [select InwiB2C_UUID__c,InwiB2C_Compteur_relance__c,InwiB2C_Commande_de_degroupage__c,InwiB2C_ACTION__c,InwiB2C_ADRESSE__c,InwiB2C_Account__c,InwiB2C_AdresseIAMProposee__c,InwiB2C_Agence__c,InwiB2C_BAT__c,InwiB2C_CCOM__c,InwiB2C_CLIENT_TYPE__c,InwiB2C_CQUARTIER__c,InwiB2C_CVOIE__c,InwiB2C_CodeMotifRejet__c,InwiB2C_Commentaire__c,InwiB2C_DEGROUPAGE_NUM__c,InwiB2C_Debit__c,InwiB2C_DetailErreur__c,InwiB2C_Dslamport__c,InwiB2C_ESC__c,InwiB2C_ETAGE__c,InwiB2C_FirstName__c,InwiB2C_LastName__c,InwiB2C_MotifAnnulation__c,InwiB2C_Motif__c,InwiB2C_NVOIE__c,InwiB2C_Nationalid__c,InwiB2C_NouvelleTechnologie__c,InwiB2C_NumeroDesignation__c,InwiB2C_Order__c,InwiB2C_PORTE__c,InwiB2C_PartenaireCode__c,InwiB2C_SEQ_NUM__c,InwiB2C_Site__c,InwiB2C_StatutDegroupageIAM__c,InwiB2C_StatutLigneIam__c,InwiB2C_Statutdegroupage__c,InwiB2C_Technologie__c,InwiB2C_categorieClient__c,InwiB2C_codeOpDemandeur__c,InwiB2C_codeRoutage__c,InwiB2C_dateOrdre__c,InwiB2C_ndOperateur__c,InwiB2C_ndPrecedent__c,InwiB2C_numeroContact__c,InwiB2C_portabilite__c,InwiB2C_positionReglette__c,InwiB2C_qualiteService__c,InwiB2C_rendezvous__c,InwiB2C_typeCommande__c,InwiB2C_typePrestation__c,InwiB2C_AvecInstallationDomicile__c,InwiB2C_OrigineDemande__c,InwiB2C_Date_de_mise_en_service__c 
                                                  FROM INWIB2C_DEMANDE_DEGROUPAGE__c  
                                                  where InwiB2C_Commande_de_degroupage__c IN :commandeDegroupageSet
                                                  order by CreatedDate desc, InwiB2C_SEQ_NUM__c DESC  ]; 
        
        for (INWIB2C_DEMANDE_DEGROUPAGE__c demande : lastDemandes) {
            
            if(!lastDemandesToCancel.contains(demande)){
                lastDemandesToCancel.add(demande);
            } 
        }

    // Step 2: Clone demande degroupage
    for (Integer i = 0; i < lastDemandesToCancel.size(); i++) {
        INWIB2C_DEMANDE_DEGROUPAGE__c clonedRecord = demandesToCancel[i].clone(false, true);
        clonedRecord.InwiB2C_Commande_de_degroupage__c = newCommandes[i].Id;
        clonedRecord.InwiB2C_SEQ_NUM__c=1;
        clonedDemandes.add(clonedRecord);

        // Step 3: Extract MDN 
        String mdn = (String.isNotBlank(clonedRecord.InwiB2C_ndOperateur__c)) 
                     ? clonedRecord.InwiB2C_ndOperateur__c 
                     : clonedRecord.InwiB2C_NumeroDesignation__c;
        if (String.isNotBlank(mdn)) {
            mdn = '212' + mdn.removeStart('0');
            mdnSet.add(mdn);
        }
    }
    
    // Bulk insert cloned 'INWIB2C_DEMANDE_DEGROUPAGE__c' records
    insert clonedDemandes;

    // Step 4: Query 'vlocity_cmt__Subscription__c' using MDNs
    List<vlocity_cmt__Subscription__c> subscriptions = [
        SELECT Id, Inwib2c_Num_ro_de_la_ligne__c
        FROM vlocity_cmt__Subscription__c
        WHERE Inwib2c_Num_ro_de_la_ligne__c IN :mdnSet
        AND (Inwib2c_Profil__c = 'ADSL XTRA by inwi Jusqu\'à 20 Mega' 
             OR Inwib2c_Profil__c = 'ADSL')
        ORDER BY CreatedDate DESC
    ];

    // Step 5: Insert 'InwiB2C_TraitementResiliationDegroupage__e' events in bulk
    List<InwiB2C_TraitementResiliationDegroupage__e> eventsToInsert = new List<InwiB2C_TraitementResiliationDegroupage__e>();
    Map<String, vlocity_cmt__Subscription__c> subscriptionMap = new Map<String, vlocity_cmt__Subscription__c>();
    for (vlocity_cmt__Subscription__c subscription : subscriptions) {
        if(!subscriptionMap.containsKey(subscription.Inwib2c_Num_ro_de_la_ligne__c)){
            subscriptionMap.put(subscription.Inwib2c_Num_ro_de_la_ligne__c, subscription);
            InwiB2C_TraitementResiliationDegroupage__e event = new InwiB2C_TraitementResiliationDegroupage__e(
                    InwiB2C_subscriptionId__c = subscription.Id
                );
                eventsToInsert.add(event);
        }
        
    }
    
    
    if (!eventsToInsert.isEmpty()) {
        insert eventsToInsert;
    }
  }
}