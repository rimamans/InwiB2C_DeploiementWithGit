public class InwiB2C_Desidentification{  
    @InvocableMethod
    public static void Traitement(List<Id> DemandeId){
       
        List<InwiB2C_SubscriptionDesidentification__c> subscriptions1 = [
        Select id,InwiB2C_SouscriptionId__c,InwiB2C_ContractId__c,InwiB2C_MDN__c,InwiB2C_isSelected__c,InwiB2C_date_de_creation__c,
        InwiB2C_Demande_Desidentification_Id__c
        From InwiB2C_SubscriptionDesidentification__c
        where InwiB2C_Demande_Desidentification_Id__c in :DemandeId and InwiB2C_isSelected__c=false];
  
   
        List<Id> contractMultiLigne = new List<Id>();
        List<Id> Contractsidentif = new List<Id>();
        List<Id> idContractList1 = new List<Id>();
    //reccuperer les  Id des contrats des souscription a desidentifier 
        for (InwiB2C_SubscriptionDesidentification__c  sub : subscriptions1) {
            idContractList1.add(sub.InwiB2C_ContractId__c);
        }
    //reccuperer les ID des contrats multiligne a élminier
    //BEGIN CHB 27/07/2023 Ano B-9661 
   /* AggregateResult[] groupedResults= [select InwiB2C_Contract__r.Id
            from vlocity_cmt__Subscription__c 
            WHERE InwiB2C_Contract__c in :idContractList1 
            group by InwiB2C_Contract__r.Id having Count(InwiB2C_Contract__r.Id) > 1 ];
            for (AggregateResult ar : groupedResults)  {
                contractMultiLigne.add((Id)ar.get('Id'));
            }
    // reccuperer les ID des contrats multiligne a élminier
        List<InwiB2C_SubscriptionDesidentification__c> ContractsToModify=[Select Id,InwiB2C_Motif_de_refus__c 
        from InwiB2C_SubscriptionDesidentification__c where InwiB2C_isSelected__c=false and InwiB2C_ContractId__c In :contractMultiLigne ];
    // updater le motif de refus des ligne non eligible 
        for (InwiB2C_SubscriptionDesidentification__c  contrat : ContractsToModify) {
            contrat.InwiB2C_Motif_de_refus__c='Cette ligne est rattaché à un contrat multi-ligne';
        }
        update ContractsToModify;*/
    //END CHB 27/07/2023 Ano B-9661 
    // reccuperer les contrats avec canal identification 
        List<Contract> ContractList1=[Select Id 
        from Contract where Id In :idContractList1 and Canal_d_identification__c In ('Point de vente','inwiB2C_Eshop') ];
        for (Contract  sub : ContractList1) {
            Contractsidentif.add(sub.Id);
        }
        // reccuperer les ID des contrats multiligne a élminier
        List<InwiB2C_SubscriptionDesidentification__c> ContractsToModify2=[Select Id,InwiB2C_Motif_de_refus__c   
        from InwiB2C_SubscriptionDesidentification__c where InwiB2C_isSelected__c=false and InwiB2C_ContractId__c In :Contractsidentif ];
    // updater le motif de refus des ligne non eligible 
        for (InwiB2C_SubscriptionDesidentification__c  demsub : ContractsToModify2) {
            demsub.InwiB2C_Motif_de_refus__c='le canal d\'identification n\'est pas éligible :PDV/Boutique';
        }
        update ContractsToModify2;

    // reccuperer les ID des contrats multiligne a élminier
        List<InwiB2C_SubscriptionDesidentification__c> ContractsToModify3=[Select Id,InwiB2C_Motif_de_refus__c   
        from InwiB2C_SubscriptionDesidentification__c 
        where InwiB2C_isSelected__c = false and InwiB2C_ContractId__c = null and InwiB2C_Motif_de_refus__c=null and InwiB2C_Demande_Desidentification_Id__c in :DemandeId ];
    // updater le motif de refus des ligne non eligible 
        for (InwiB2C_SubscriptionDesidentification__c  demsub : ContractsToModify3) {
            demsub.InwiB2C_Motif_de_refus__c='Ligne sans contrat';
        }
        update ContractsToModify3;
        // chb ticket B-27514 25/03/2025 interdit les lignes suspendu fraude begin */
        List<InwiB2C_SubscriptionDesidentification__c> ContractsToModify4=[SELECT Id,InwiB2C_Motif_de_refus__c   
                                                                            FROM InwiB2C_SubscriptionDesidentification__c 
                                                                            WHERE InwiB2C_isSelected__c = false 
                                                                            AND InwiB2C_SouscriptionId__r.inwiB2C_Statut__c =: 'InwiB2C_SuspendueFraude' 
                                                                            AND InwiB2C_Motif_de_refus__c=null 
                                                                            AND InwiB2C_SouscriptionId__r.Inwib2c_Offre__c in ('Offre Dealer Sim Seule','Offre Dealer Sim+Terminal')
                                                                            AND InwiB2C_Demande_Desidentification_Id__c in :DemandeId ];
    // updater le motif de refus des ligne non eligible 
        for (InwiB2C_SubscriptionDesidentification__c  demsub : ContractsToModify4) {
            demsub.InwiB2C_Motif_de_refus__c='Ligne suspendu Fraude';
        }
        update ContractsToModify4;

        // chb ticket B-27514 25/03/2025 interdit les lignes suspendu fraude end */
               //BEGIN CHB ANO 9661 27/07/2023 
        List<InwiB2C_SubscriptionDesidentification__c> subscriptions = [
        Select id,InwiB2C_SouscriptionId__c,InwiB2C_SouscriptionId__r.vlocity_cmt__AccountId__r.Inwib2c_Segment_march__c,
        InwiB2C_SouscriptionId__r.InwiB2C_Id_profil__c ,InwiB2C_ContractId__c,InwiB2C_MDN__c,
        InwiB2C_isSelected__c,InwiB2C_date_de_creation__c,InwiB2C_Demande_Desidentification_Id__c,
        InwiB2C_SouscriptionId__r.Inwib2c_ICC__c,
        InwiB2C_SouscriptionId__r.InwiB2C_Date_d_activation__c,InwiB2C_SouscriptionId__r.InwiB2C_IMSI__c,
        InwiB2C_SouscriptionId__r.Inwib2c_Offre__c,InwiB2C_SouscriptionId__r.Inwib2c_Terminal__c,
        InwiB2C_SouscriptionId__r.InwiB2C_MEI__c
        From InwiB2C_SubscriptionDesidentification__c
        where InwiB2C_Motif_de_refus__c=null and InwiB2C_Demande_Desidentification_Id__c in :DemandeId and InwiB2C_isSelected__c=false];
       //END  CHB ANO 9661 27/07/2023 
        // recuperer les id contrat a desidentifier pr mettre a jour subscription contract
        List<Id> idContractListadesidentifier = new List<Id>();
        for (InwiB2C_SubscriptionDesidentification__c  sub : subscriptions) {
            idContractListadesidentifier.add(sub.InwiB2C_ContractId__c);
        }

        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        Map<Id,Account> accountMap = new Map<Id,Account>();
        Map<Id,Contract> contractMap = new Map<Id,Contract>();
        //CHB Ano B-17096 26/06/2024 begin */
        Map<Id,InwiB2C_Address__c> addressMapAccount = new Map<Id,InwiB2C_Address__c>();
        Map<Id,InwiB2C_Address__c> addressMapContract = new Map<Id,InwiB2C_Address__c>();
        List<InwiB2C_Pays__c> pays = [SELECT id, Name from InwiB2C_Pays__c WHERE Name='Maroc' limit 1];
        List<InwiB2C_Region__c> region = [SELECT id, Name from InwiB2C_Region__c WHERE Name='DUMMY' limit 1];
        List<inwiB2C_Ville__c> ville = [SELECT id, Name from inwiB2C_Ville__c WHERE Name='DUMMY' limit 1];
        List<inwiB2C_Quartier__c > quartier = [SELECT id, Name from inwiB2C_Quartier__c  WHERE Name='DUMMY' limit 1];
        //CHB Ano B-17096 26/06/2024 end */
        Map<Id,vlocity_cmt__Subscription__c> subscriptionMap = new Map<Id,vlocity_cmt__Subscription__c>();

        List<Id> idSubscriptionList = new List<Id>();
        
        List<Id> idContractList = new List<Id>();

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();


        for (InwiB2C_SubscriptionDesidentification__c  sub : subscriptions) {

            idSubscriptionList.add(sub.InwiB2C_SouscriptionId__c);
            idContractList.add(sub.InwiB2C_ContractId__c);
            system.debug(sub);
            Contact  c = new Contact();
            c.firstName='DUMMY ';
            c.lastName=sub.InwiB2C_MDN__c;
            
            //insert c;
            contactMap.put(sub.id, c);
            system.debug(c);
            //CHB Ano B-17096 26/06/2024 begin */
            if(!Test.isRunningTest()) {
            InwiB2C_Address__c newAddressAccountObj = new InwiB2C_Address__c(
                            InwiB2C_Pays__c = pays[0].id,
                            InwiB2C_Region__c = region[0].id,
                            Name = 'DUMMY', 
                            inwiB2C_Ville__c = ville[0].id,
                            InwiB2C_Quartier__c = quartier[0].id
                        );
            addressMapAccount.put(sub.id, newAddressAccountObj);
            InwiB2C_Address__c newAddressContractObj = new InwiB2C_Address__c(
                InwiB2C_Pays__c = pays[0].id,
                InwiB2C_Region__c = region[0].id,
                Name = 'DUMMY', 
                inwiB2C_Ville__c = ville[0].id,
                InwiB2C_Quartier__c = quartier[0].id
            );
            addressMapContract.put(sub.id, newAddressContractObj);
            }
            //CHB Ano B-17096 26/06/2024 end */
            Account a=new Account();
            //a.vlocity_cmt__PersonContactId__c=c.Id;
            A.Name='DUMMY '+sub.InwiB2C_MDN__c;
            A.RecordTypeId = devRecordTypeId;
            if(sub.InwiB2C_SouscriptionId__r.InwiB2C_Id_profil__c=='2539'){
                A.Inwib2c_Segment_march__c=sub.InwiB2C_SouscriptionId__r.vlocity_cmt__AccountId__r.Inwib2c_Segment_march__c;
            }
       

            accountMap.put(sub.id, a);
            //insert a;
            system.debug(a);

            Contract newcontract = new Contract();
            if(sub.InwiB2C_SouscriptionId__r.InwiB2C_Id_profil__c=='2539'){
                newcontract.InwiB2C_Segmentation__c='Dealer';
            }
            newcontract.Name='DUMMY '+sub.InwiB2C_MDN__c;
            newcontract.Status='Draft';
            newcontract.InwiB2C_statut_contrat__c ='Initialise';
            newcontract.InwiB2c_Nom__c = 'DUMMY ';
            newcontract.InwiB2c_Prenom__c =sub.InwiB2C_MDN__c;
            newcontract.InwiB2C_Date_de_desidentification__c=Datetime.now();
            contractMap.put(sub.id, newcontract);
        }   
    //CHB Ano B-17096 26/06/2024 begin */
        List <InwiB2C_Address__c> adressListAccount = addressMapAccount.values();
        List <InwiB2C_Address__c> adressListContract = addressMapContract.values();
        if(!Test.isRunningTest()) {
            insert adressListAccount;
            insert adressListContract;
    }
    //CHB Ano B-17096 26/06/2024 end */
        List <Contact> contactList = contactMap.values();

        insert contactList;

        //relating the contact to account on salesforce side
        for (Id key:contactMap.keySet()) { 

            Contact tempContact = contactMap.get(key);

            Account tempAccount = accountMap.get(key);
            if(!Test.isRunningTest()) {
            //CHB Ano B-17096 26/06/2024 begin */
            InwiB2C_Address__c tempAdress=addressMapAccount.get(key);
            tempAccount.InwiB2C_Address__c=tempAdress.Id;
            //CHB Ano B-17096 26/06/2024 end */
            }
            tempAccount.vlocity_cmt__PersonContactId__c = tempContact.Id;
           
        }

        List <Account> accountList = accountMap.values();

        insert as system accountList;



        //relating the contact to account on community side  and the account to contrract
        for (Id key:contactMap.keySet()) {

            Contact tempContact = contactMap.get(key);

            Account tempAccount = accountMap.get(key);

            Contract tempContract = contractMap.get(key);

            tempContract.AccountId = tempAccount.Id;

            tempContact.AccountId = tempAccount.Id;
            if(!Test.isRunningTest()) {
            //CHB Ano B-17096 26/06/2024 begin */
            InwiB2C_Address__c tempAdress=addressMapContract.get(key);
            tempContract.InwiB2C_Address__c=tempAdress.Id;
            //CHB Ano B-17096 26/06/2024 end */
            }
        }

        List <Contact> contactList2 = contactMap.values();

        update as system contactList2;

        List <Contract> contractList = contractMap.values();

        insert as system contractList;
        
      
        List<vlocity_cmt__Subscription__c> souscriptionsSelect = [SELECT ID, Name,vlocity_cmt__AccountId__c 
            FROM vlocity_cmt__Subscription__c 
            WHERE Id in :idSubscriptionList];

        Map<Id,vlocity_cmt__Subscription__c> souscriptionsMap = new Map<Id,vlocity_cmt__Subscription__c>();

        for (vlocity_cmt__Subscription__c subscription: souscriptionsSelect){
            souscriptionsMap.put(subscription.Id, subscription);

        }

    //préparation pr mettre a jr les subscriptions contract par le nouveau contrat
        //List<InwiB2C_Subscription_contract__c> subscriptioncontracts = [select Id,InwiB2C_Contract__c from InwiB2C_Subscription_contract__c where InwiB2C_Contract__c in :idContractListadesidentifier];
        //Map<Id,InwiB2C_Subscription_contract__c> subscriptioncontractMap = new Map<Id,InwiB2C_Subscription_contract__c>();
    // Begin CHB 9661 27/07/2023
        
        Set<String> mdnSet = new Set<String>();
        Map<String, String> mdnToIccMap = new Map<String, String>();

        // Collect unique MDNs and build a map of MDN to ICC
        for (InwiB2C_SubscriptionDesidentification__c subscription : subscriptions) {
            String mdn = subscription.InwiB2C_MDN__c;
            String icc = subscription.InwiB2C_SouscriptionId__r.Inwib2c_ICC__c;
            
            if (!mdnSet.contains(mdn)) {
                mdnSet.add(mdn);
                mdnToIccMap.put(mdn, icc);
            }
        }

        List<InwiB2C_Subscription_contract__c> subscriptioncontracts = [
            SELECT Id
            FROM InwiB2C_Subscription_contract__c
            WHERE InwiB2C_MDN__c IN :mdnSet AND InwiB2C_ESN_ICC__c IN :mdnToIccMap.values() 
        ];
        delete subscriptioncontracts;
       
        List<InwiB2C_Subscription_contract__c> subscriptionContractList = new List<InwiB2C_Subscription_contract__c>();
        for (InwiB2C_SubscriptionDesidentification__c  sub : subscriptions) {
            Account tempAccount = accountMap.get(sub.Id);
            Contract tempContract = contractMap.get(sub.Id);
            
            vlocity_cmt__Subscription__c tempSubscription = souscriptionsMap.get(sub.InwiB2C_SouscriptionId__c);
            
            tempSubscription.vlocity_cmt__AccountId__c = tempAccount.Id;
            tempSubscription.InwiB2C_Contract__c = tempContract.Id;
            
            
            InwiB2C_Subscription_contract__c SubscriptionContract= new InwiB2C_Subscription_contract__c();
            SubscriptionContract.InwiB2C_Contract__c=tempContract.Id;
            SubscriptionContract.InwiB2C_Date_CRM__c=sub.InwiB2C_SouscriptionId__r.InwiB2C_Date_d_activation__c.date();
            SubscriptionContract.InwiB2C_ESN_ICC__c=sub.InwiB2C_SouscriptionId__r.Inwib2c_ICC__c;
            SubscriptionContract.InwiB2C_IMSI__c=sub.InwiB2C_SouscriptionId__r.InwiB2C_IMSI__c;
            SubscriptionContract.InwiB2C_MDN__c	=sub.InwiB2C_MDN__c;
            SubscriptionContract.InwiB2C_N_Ligne__c=sub.InwiB2C_MDN__c;
            SubscriptionContract.InwiB2C_Profil__c=sub.InwiB2C_SouscriptionId__r.InwiB2C_Id_profil__c;
            SubscriptionContract.InwiB2C_Type_Offre__c=sub.InwiB2C_SouscriptionId__r.Inwib2c_Offre__c;
            SubscriptionContract.InwiB2C_Modele_terminal__c=sub.InwiB2C_SouscriptionId__r.Inwib2c_Terminal__c;
            SubscriptionContract.InwiB2C_Numero_de_serie_terminal__c=sub.InwiB2C_SouscriptionId__r.InwiB2C_MEI__c;
            
            subscriptionContractList.add(subscriptionContract);

        }
        if (!subscriptionContractList.isEmpty()) {
            insert subscriptionContractList;
        }
        List <vlocity_cmt__Subscription__c> subscriptionList = souscriptionsMap.values();

        update as system subscriptionList;
 
/*
        for (InwiB2C_Subscription_contract__c subscriptioncontract: subscriptioncontracts){

            subscriptioncontractMap.put(subscriptioncontract.InwiB2C_Contract__c, subscriptioncontract);

        }
        
        for (InwiB2C_SubscriptionDesidentification__c  sub : subscriptions) {

            Account tempAccount = accountMap.get(sub.Id);
            
            Contract tempContract = contractMap.get(sub.Id);

            vlocity_cmt__Subscription__c tempSubscription = souscriptionsMap.get(sub.InwiB2C_SouscriptionId__c);

            InwiB2C_Subscription_contract__c tempSubscriptionContract = subscriptioncontractMap.get(sub.InwiB2C_ContractId__c);

            tempSubscription.vlocity_cmt__AccountId__c = tempAccount.Id;
            tempSubscription.InwiB2C_Contract__c = tempContract.Id;
            tempSubscriptionContract.InwiB2C_Contract__c = tempContract.Id;


        }

        List <vlocity_cmt__Subscription__c> subscriptionList = souscriptionsMap.values();

        update as system subscriptionList;


        List <InwiB2C_Subscription_contract__c> tempSubscriptionContract = subscriptioncontractMap.values();
        update as system tempSubscriptionContract;
*/
    //END CHB B-9661 27/07/2023

      
    }

}