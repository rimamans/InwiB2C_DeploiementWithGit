public with sharing class inwiB2C_AnnulDemDegSusp5joursBatch implements Database.Batchable<SObject>, Database.Stateful{
    @TestVisible private Integer totalProcessed = 0;
    @TestVisible private Integer maxPerNight;
    @TestVisible private Integer expirationTimeSubmission;
    @TestVisible private Integer expirationTimeSuspension;   
    @TestVisible private Integer batchSize;
    @TestVisible private Integer totalProcessedRecords;
    @TestVisible private Integer calloutLimit = 99;
    @TestVisible private List<String> suspendCodes = new List<String> ();

    
    public inwiB2C_AnnulDemDegSusp5joursBatch(Integer batchSize) {
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
       
        inwiB2C_BatchAnnulationDemDegCounter__c totalProcessedRecordsCounter;
        if(!Test.isRunningTest()){
            totalProcessedRecordsCounter = [
                SELECT inwiB2C_Total_Processed_Records__c, SetupOwner.Name 
                FROM inwiB2C_BatchAnnulationDemDegCounter__c 
                where SetupOwner.Name = 'Wana corporate/inwi B2C'
                Limit 1
         	]; 
        }
        
        this.maxPerNight = Integer.ValueOf(limitMetadata.inwiB2C_Value__c);
        this.expirationTimeSuspension = Integer.ValueOf(expirationTimeSuspensionMetadata.inwiB2C_Value__c);
        this.expirationTimeSubmission = Integer.ValueOf(expirationTimeSubmissionMetadata.inwiB2C_Value__c);
        this.totalProcessedRecords = Test.isRunningTest() ? 600 : Integer.ValueOf(totalProcessedRecordsCounter.inwiB2C_Total_Processed_Records__c);


        suspendCodes.add('63');
        suspendCodes.add('24');
        suspendCodes.add('56');
        suspendCodes.add('70');
        suspendCodes.add('71');
        suspendCodes.add('73');
        suspendCodes.add('48');
        suspendCodes.add('66');
        //added for test purpose to be removed for Prod
        //suspendCodes.add('49');


    }

    public System.Iterable<INWIB2C_DEMANDE_DEGROUPAGE__c> start(Database.BatchableContext bc) {


        List<Id> idList = new List<Id> ();
        List<Id> commandeDegIdList = new List<Id> ();


        List<Order> inProgressOrdersLis = [select id, Name, inwib2c_TypeDeLaCommande__c, (select id, Name from Commandes_de_d_groupage__r order by Name desc limit 1 ) from Order where vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__State__c ='In Progress' and InwiB2C_Type_Offer__c ='ADSL' and vlocity_cmt__OrchestrationPlanId__c  in (select vlocity_cmt__OrchestrationPlanId__c from vlocity_cmt__OrchestrationItem__c where Name = 'IAM purchase order' and vlocity_cmt__State__c ='Failed' ) order by CreatedDate];

        for(Order inProgressOrder: inProgressOrdersLis ){
            if (inProgressOrder.Commandes_de_d_groupage__r != null && inProgressOrder.Commandes_de_d_groupage__r.size() > 0 && inProgressOrder.Commandes_de_d_groupage__r[0].id != null){
                commandeDegIdList.add(inProgressOrder.Commandes_de_d_groupage__r[0].id);
            }
        }

        List<InwiB2C_Commande_de_degroupage__c> commandesDegInitialesList = [select id, Name, (select id, name, InwiB2C_Statutdegroupage__c, InwiB2C_StatutDegroupageIAM__c, InwiB2C_CodeMotifRejet__c, inwiB2C_retour_annulation_IAM__c from Demandes_degroupage__r order by InwiB2C_SEQ_NUM__c desc limit 1) A from InwiB2C_Commande_de_degroupage__c where id in :commandeDegIdList];
        //List<InwiB2C_Commande_de_degroupage__c> commandesDegInitialesList = [select id, Name, (select id, name, InwiB2C_Statutdegroupage__c, InwiB2C_StatutDegroupageIAM__c, InwiB2C_CodeMotifRejet__c, inwiB2C_retour_annulation_IAM__c from Demandes_degroupage__r order by InwiB2C_SEQ_NUM__c desc limit 1) A from InwiB2C_Commande_de_degroupage__c where InwiB2C_Order__r.vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__State__c ='In Progress'];

        for (InwiB2C_Commande_de_degroupage__c commandesDegInitiale: commandesDegInitialesList ){



            if (commandesDegInitiale.Demandes_degroupage__r != null && commandesDegInitiale.Demandes_degroupage__r.size() > 0 && commandesDegInitiale.Demandes_degroupage__r[0].InwiB2C_Statutdegroupage__c == 'SUS' &&  commandesDegInitiale.Demandes_degroupage__r[0].inwiB2C_retour_annulation_IAM__c == false && suspendCodes.contains(commandesDegInitiale.Demandes_degroupage__r[0].InwiB2C_CodeMotifRejet__c)  ){
                system.debug('Demandes : ' +JSON.serialize(commandesDegInitiale.Demandes_degroupage__r));
                system.debug('Demande : ' +JSON.serialize(commandesDegInitiale.Demandes_degroupage__r[0]));
                system.debug('Demande Id : ' +JSON.serialize(commandesDegInitiale.Demandes_degroupage__r[0].id));
                
                idList.add(commandesDegInitiale.Demandes_degroupage__r[0].Id);

            }
            
        }

        System.Iterable<INWIB2C_DEMANDE_DEGROUPAGE__c> scopeList= [select id , CreatedDate, InwiB2C_Statutdegroupage__c, InwiB2C_CodeMotifRejet__c, inwiB2C_retour_annulation_IAM__c, InwiB2C_Commande_de_degroupage__c, InwiB2C_Commande_de_degroupage__r.InwiB2C_Order__c from INWIB2C_DEMANDE_DEGROUPAGE__c where Id in :idList];



        // Logic that creates and adds to the list
        // Subject to normal governor limits
        return scopeList;
    }

    public void execute(Database.BatchableContext bc, List<INWIB2C_DEMANDE_DEGROUPAGE__c> scopes) {

        system.debug('In Execute');
      
        //Check Total Number procesed
        if (totalProcessedRecords >= maxPerNight) {    
              System.debug('limit reached');
            return; // Stop processing if the total records processed reaches maxPerNight
         }

        
        Date todayDate = Date.today();
        List<INWIB2C_DEMANDE_DEGROUPAGE__c> demandetoCancel = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
        List<INWIB2C_DEMANDE_DEGROUPAGE__c> demandetoCheck = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
        List<Id> orderIdtoCheck = new List<Id>();

        // Check for suspended demandes that are suspended for mere that 5 days (delay parametered)
        for (INWIB2C_DEMANDE_DEGROUPAGE__c demande : scopes) {
            system.debug(demande);

            DateTime deadlineSuspension = getWorkingDateAterXDays(demande.CreatedDate, expirationTimeSuspension);
                if (todayDate > deadlineSuspension ) {
                    demandetoCancel.add(demande);
                    totalProcessed++;
                }else {
                    demandetoCheck.add(demande);
                    orderIdtoCheck.add(demande.InwiB2C_Commande_de_degroupage__r.InwiB2C_Order__c);
                }
        }

        List<INWIB2C_DEMANDE_DEGROUPAGE__c> allDemandesForOrderList = [SELECT id , CreatedDate, InwiB2C_Statutdegroupage__c, InwiB2C_CodeMotifRejet__c, inwiB2C_retour_annulation_IAM__c, InwiB2C_Commande_de_degroupage__c, InwiB2C_Commande_de_degroupage__r.InwiB2C_Order__c FROM INWIB2C_DEMANDE_DEGROUPAGE__c WHERE InwiB2C_Commande_de_degroupage__r.InwiB2C_Order__c IN :orderIdtoCheck ORDER BY InwiB2C_ORDER_DEGROUPAGE_NUM__c , InwiB2C_SEQ_NUM__c desc];

        Map<id, List<INWIB2C_DEMANDE_DEGROUPAGE__c>> groupedDemandeByOrderMap = new Map<Id, List<INWIB2C_DEMANDE_DEGROUPAGE__c>>();

        for(INWIB2C_DEMANDE_DEGROUPAGE__c demandesForOrder: allDemandesForOrderList ){

            if (!groupedDemandeByOrderMap.containsKey(demandesForOrder.InwiB2C_Commande_de_degroupage__r.InwiB2C_Order__c)) {
                groupedDemandeByOrderMap.put(demandesForOrder.InwiB2C_Commande_de_degroupage__r.InwiB2C_Order__c, new List<INWIB2C_DEMANDE_DEGROUPAGE__c>());
            }
            groupedDemandeByOrderMap.get(demandesForOrder.InwiB2C_Commande_de_degroupage__r.InwiB2C_Order__c).add(demandesForOrder);

        }

        for (Id orderId : groupedDemandeByOrderMap.keySet()){

            List<INWIB2C_DEMANDE_DEGROUPAGE__c> demandeList = groupedDemandeByOrderMap.get(orderId);
            INWIB2C_DEMANDE_DEGROUPAGE__c lastSuspendDemande;
            

            Integer suspendedNumber = 0;

            if (demandeList != null && demandeList.size() >0){

                //Check if there have been more than 2 suspends

                for (INWIB2C_DEMANDE_DEGROUPAGE__c demande: demandeList){

                    if (demande.InwiB2C_Statutdegroupage__c == 'SUS'){
                        ++suspendedNumber;
                        if (suspendedNumber == 1){
                            lastSuspendDemande = demande;
                            
                        }
                        if (suspendedNumber >= 3){
                            demandetoCancel.add(lastSuspendDemande);
                            totalProcessed++;

                        }
                    }
                }

                //Check if First demande creation date has been more than the allawed period
                INWIB2C_DEMANDE_DEGROUPAGE__c firstDemande= demandeList.get(demandeList.size() - 1);
                DateTime deadlineSubmission = getWorkingDateAterXDays(firstDemande.CreatedDate, expirationTimeSubmission);
                if (todayDate > deadlineSubmission ) {
                    demandetoCancel.add(lastSuspendDemande);
                    totalProcessed++;
                     
                }

            }

            

        }








        Integer subListSize = 0;
        Integer demandetoQueueSize = demandetoCancel.size();

        List<INWIB2C_DEMANDE_DEGROUPAGE__c> recordsToQueue = new List<INWIB2C_DEMANDE_DEGROUPAGE__c>();
        /*DLE Change Solution begin */
        List<inwiB2C_CallAnnulDmdDegroupage__e> CancelRequest_event = new List<inwiB2C_CallAnnulDmdDegroupage__e>();
        /*DLE Change Solution end */
        for(INWIB2C_DEMANDE_DEGROUPAGE__c demande : demandetoCancel){
            recordsToQueue.add(demande);
                ++subListSize;
                --demandetoQueueSize;
            System.debug('demandetoQueueSize '+ demandetoQueueSize+ '  subListSize '+subListSize);
            
            System.debug('subListSize == this.calloutLimit '+ (subListSize == this.calloutLimit) + '  demandetoQueueSize == 0 '+ (demandetoQueueSize == 0));
            if(subListSize == this.calloutLimit || (demandetoQueueSize == 0 ) ){
                /*DLE Change Solution begin */
                //System.debug('Queue '+ recordsToQueue);
                //System.enqueueJob(new inwiB2C_AnnulationDemandeDegApiCall(recordsToQueue));
                //recordsToQueue.clear();
                //subListSize=0;
                //System.debug('subListSize '+ subListSize + '  after queue '+ recordsToQueue);
                inwiB2C_CallAnnulDmdDegroupage__e eventToCancel = new inwiB2C_CallAnnulDmdDegroupage__e();
                eventToCancel.inwiB2C_DemandeDeg__c = demande.Id;
                eventToCancel.InwiB2C_Action__c = 'ANN';
                eventToCancel.inwiB2C_Type__c = 'ANN';
                CancelRequest_event.add(eventToCancel);	
                 /*DLE Change Solution end */
                }
        }
        /*DLE Change Solution begin */
        List <Database.SaveResult> sresultSusp = EventBus.publish(CancelRequest_event);
        /*DLE Change Solution end */

    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch finished processing ' + totalProcessed + ' records.');
        
        
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
}