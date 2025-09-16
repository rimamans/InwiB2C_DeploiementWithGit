/*ZME INWIB2C-PHASE2-Lot 1.2 12.04.2021 BEGIN*/
@RestResource(urlMapping='/CreateContract')
global with sharing class InwiB2C_CreateContract {
    @HttpPost
    global static void createContract() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        InwiB2C_CreateContractParams params = InwiB2C_CreateContractParams.parse(req.requestBody.tostring());
        Map<String, Object> responseMap = new Map<String, Object>();
        responseMap.put('uuid', params.Operation[0].uuid);
        res.addHeader('charset', 'UTF-8 Server');
        res.addHeader('Content-Type', 'application/json');
        Id clientId, contractId, addressId, dealerId;
        string partenaireId, distributeurId;
        Contract contractClient = new Contract();
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        try {
            //Populate inwiB2C_CreateContractLogs__c
            logCreateContract.inwiB2C_Request__c = req.requestBody.toString();
            //Operation
            logCreateContract.inwib2c_Canal__c = params.Operation[0].canal;
            logCreateContract.inwiB2C_CodeDistributeur__c = params.Operation[0].businessUnit;
            logCreateContract.InwiB2C_CodeAgence__c = params.Operation[0].pos;
            logCreateContract.inwiB2C_User__c = params.Operation[0].user;
            logCreateContract.inwiB2C_uuid__c = params.Operation[0].uuid;
            //Customers
            logCreateContract.inwiB2C_IdClientPS__c = params.InfosContracts[0].customers[0].idClient;
            logCreateContract.inwiB2C_FirstName__c = params.InfosContracts[0].customers[0].firstName;
            logCreateContract.inwiB2C_LastName__c = params.InfosContracts[0].customers[0].lastName;
            logCreateContract.inwiB2C_Gender__c = params.InfosContracts[0].customers[0].gender;
            if (params.InfosContracts[0].customers[0].birthdate != '') {
                logCreateContract.inwiB2C_BirthDate__c = Date.parse(params.InfosContracts[0].customers[0].birthdate);
            }
            logCreateContract.inwiB2C_TypePieceIdentite__c = params.InfosContracts[0].customers[0].typePi;
            logCreateContract.inwiB2C_PieceIdentite__c = params.InfosContracts[0].customers[0].pi;
            logCreateContract.inwiB2C_Ocerised__c = params.InfosContracts[0].customers[0].Ocerised;
            logCreateContract.inwiB2C_SegmentLevel1__c = params.InfosContracts[0].customers[0].segmentLevel1;
            logCreateContract.inwiB2C_SegmentLevel2__c = params.InfosContracts[0].customers[0].segmentLevel2;
            logCreateContract.inwiB2C_CountryCode__c = params.InfosContracts[0].customers[0].countryCode;
            logCreateContract.inwiB2C_Region__c = params.InfosContracts[0].customers[0].region;
            logCreateContract.inwiB2C_City__c = params.InfosContracts[0].customers[0].city;
            logCreateContract.inwiB2C_State__c = params.InfosContracts[0].customers[0].state;
            logCreateContract.inwiB2C_Street__c = params.InfosContracts[0].customers[0].street;
            logCreateContract.inwiB2C_Address__c = params.InfosContracts[0].customers[0].address;
            logCreateContract.inwiB2C_ComplementAddress__c = params.InfosContracts[0].customers[0].complementAddress;
            logCreateContract.inwiB2C_PostCode__c = params.InfosContracts[0].customers[0].postcode;
            logCreateContract.inwiB2C_BusinessSegment__c = params.InfosContracts[0].customers[0].businessSegment;
            //Ressources
            logCreateContract.inwiB2C_Mdn__c = params.InfosContracts[0].ressources[0].mdn;
            logCreateContract.inwiB2C_MdnDealer__c = params.InfosContracts[0].ressources[0].mdnDealer;
            logCreateContract.inwiB2C_Icc__c = params.InfosContracts[0].ressources[0].icc;
            logCreateContract.inwiB2C_ProfileId__c = params.InfosContracts[0].ressources[0].profileId;
            logCreateContract.inwiB2C_imsi__c = params.InfosContracts[0].ressources[0].imsi;
            logCreateContract.inwiB2C_ki__c = params.InfosContracts[0].ressources[0].ki;
            logCreateContract.inwiB2C_puk__c = params.InfosContracts[0].ressources[0].puk;
            logCreateContract.inwiB2C_CodeArticle__c = params.InfosContracts[0].ressources[0].codeArticle;
            logCreateContract.inwiB2C_OcsId__c = params.InfosContracts[0].ressources[0].ocsId;
            //Statut
            logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Nouveau';
            insert logCreateContract;
            id logCreateContractId = logCreateContract.id;
            
            /*IF params.InfosContracts[0].customers[0].segmentLevel1 = 'Dealer' || params.InfosContracts[0].customers[0].segmentLevel1 = 'SD' Then*/
            //Check if mdn exists in orders
            List<orderitem> orderitem = [
                SELECT Order.id, Order.OrderNumber
                FROM OrderItem
                WHERE inwiB2C_Mdn__c =: params.InfosContracts[0].ressources[0].mdn and order.inwiB2C_Statut__c not in ('inwiB2C_Annulee', 'inwiB2C_Activee')
                AND order.inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition' LIMIT 1
            ]; 
            if (!orderitem.isEmpty()) {
                res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "ERR004", "errorMessage": "Le numéro '+params.InfosContracts[0].ressources[0].mdn+' est déjà activée", "uuid": "' +params.Operation[0].uuid+ '"}');
                res.statusCode = 200;
                logCreateContract.inwiB2C_Erreur__c = 'ERR004:Le numéro '+params.InfosContracts[0].ressources[0].mdn+' est déjà activée '+ orderitem[0].Order.OrderNumber;
                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                Update logCreateContract;
            }
            //Check activation count for dealer
            if (logCreateContract.inwiB2C_StatutDeTraitement__c == 'inwiB2C_Nouveau') {
                if (params.InfosContracts[0].ressources[0].mdnDealer != '') {
                    List<vlocity_cmt__Subscription__c> subscriptionDealer = [
                        SELECT id, vlocity_cmt__AccountId__c, inwiB2C_NombreActivationClientParJour__c
                        FROM vlocity_cmt__Subscription__c
                        WHERE Inwib2c_Num_ro_de_la_ligne__c =:params.InfosContracts[0].ressources[0].mdnDealer AND inwiB2C_LegacyStatus__c != 'EXPIRED' AND inwiB2C_Statut__c !='InwiB2C_Expired' LIMIT 1
                    ]; 
                    if (!subscriptionDealer.isEmpty()) {
                        dealerId = subscriptionDealer[0].vlocity_cmt__AccountId__c;
                        Integer orderCount =  [SELECT count()  
                                               FROM Order
                                               WHERE inwiB2C_Statut__c != 'inwiB2C_Annulee' AND inwiB2C_Dealer__c=:dealerId AND CreatedDate = TODAY];
                        if (subscriptionDealer[0].inwiB2C_NombreActivationClientParJour__c == 0) {
                            res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "ERR001", "errorMessage": "Merci d\'appeler le numéro 0529000999 pour activer l\'option identification", "uuid": "' +params.Operation[0].uuid+ '"}');
                            res.statusCode = 200;
                            logCreateContract.inwiB2C_Erreur__c = 'ERR001:Merci d\'appeler le numéro 0529000999 pour activer l\'option identification';
                            logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                            Update logCreateContract;    
                        }
                        else {
                            IF (orderCount >= subscriptionDealer[0].inwiB2C_NombreActivationClientParJour__c) {
                                res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "ERR002", "errorMessage": "Vous avez atteint votre plafond quotidien", "uuid": "' +params.Operation[0].uuid+ '"}');
                                res.statusCode = 200;
                                logCreateContract.inwiB2C_Erreur__c = 'ERR002:Vous avez atteint votre plafond quotidien';
                                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                                Update logCreateContract;
                            }
                        }
                    }
                    else {
                        res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "ERR999", "errorMessage": "DEALER not in SF", "uuid": "' +params.Operation[0].uuid+ '"}');
                        res.statusCode = 200;
                        logCreateContract.inwiB2C_Erreur__c = 'ERR999:DEALER not in SF';
                        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                        Update logCreateContract; 
                    }
                }
            }
            //check on subscription By ICC
            if (logCreateContract.inwiB2C_StatutDeTraitement__c == 'inwiB2C_Nouveau') {
                List<vlocity_cmt__Subscription__c> subscriptionsIcc = [
                    SELECT id, Inwib2c_ICC__c
                    FROM vlocity_cmt__Subscription__c
                    WHERE Inwib2c_Num_ro_de_la_ligne__c =: params.InfosContracts[0].ressources[0].mdn AND (inwiB2C_LegacyStatus__c IN ('EXPIRED', 'Résilié cycle de vie', 'Résiliée cycle de vie') OR inwiB2C_Statut__c = 'InwiB2C_Expired') LIMIT 1
                ];
                if (!subscriptionsIcc.isEmpty() && (subscriptionsIcc[0].Inwib2c_ICC__c == params.InfosContracts[0].ressources[0].icc)) {                    
                    res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "ERR003", "errorMessage": "Le numéro '+ params.InfosContracts[0].ressources[0].mdn +' est suspendu, merci de contacter le 05 29 00 09 99", "uuid": "' +params.Operation[0].uuid+ '"}');
                    res.statusCode = 200;
                    logCreateContract.inwiB2C_Erreur__c = 'ERR003:Le numéro '+ params.InfosContracts[0].ressources[0].mdn +' est suspendu, merci de contacter le 05 29 00 09 99';
                    logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                    Update logCreateContract;         
                }
            }
            //check on subscription
            if (logCreateContract.inwiB2C_StatutDeTraitement__c == 'inwiB2C_Nouveau') {
                List<vlocity_cmt__Subscription__c> subscriptions = [
                    SELECT id, InwiB2C_Canal__c, Inwib2C_Type_Offre__c, Inwib2c_Offre__c, inwiB2C_Statut__c, inwiB2C_LegacyStatus__c
                    FROM vlocity_cmt__Subscription__c
                    WHERE Inwib2c_Num_ro_de_la_ligne__c =: params.InfosContracts[0].ressources[0].mdn AND inwiB2C_LegacyStatus__c NOT IN ('EXPIRED', 'Résilié cycle de vie', 'Résiliée cycle de vie') AND inwiB2C_Statut__c !='InwiB2C_Expired' LIMIT 1
                ];
                if ((params.Operation[0].canal == 'Peoplesoft') && (!subscriptions.isEmpty()) && (subscriptions[0].Inwib2c_Offre__c == 'le mobile à la carte' || subscriptions[0].Inwib2C_Type_Offre__c == 'InwiB2C_Prepaye')) {
                    res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "SUB001", "errorMessage": "Une souscription prépayée existe avec le même MDN", "uuid": "' +params.Operation[0].uuid+ '"}');
                    res.statusCode = 200;
                    logCreateContract.inwiB2C_Erreur__c = 'SUB001:Une souscription existe avec le même MDN '+subscriptions[0].id;
                    logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                    Update logCreateContract;
                }
                else {
                    if (params.Operation[0].canal == 'Peoplesoft') {
                        List<Account> accts = [
                            SELECT id, AccountNumber, InwiB2C_Address__c
                            FROM Account
                            WHERE AccountNumber =: params.InfosContracts[0].customers[0].idClient LIMIT 1
                        ];
                        
                        if (!accts.isEmpty()) {
                            clientId = accts[0].id; 
                            addressId = accts[0].InwiB2C_Address__c;
                        }
                        else {
                            res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "CUST001", "errorMessage": "Client inexistant sur Salesforce", "uuid": "' +params.Operation[0].uuid+ '"}');
                            res.statusCode = 200;
                            logCreateContract.inwiB2C_Erreur__c = 'CUST001:Le client n\'existe pas sur Salesforce';
                            logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                            Update logCreateContract;
                        }
                    }
                    else {
                        if (!subscriptions.isEmpty()) {
                            if ((subscriptions[0].inwiB2C_Statut__c == 'InwiB2C_SuspendueFraude') || (subscriptions[0].inwiB2C_LegacyStatus__c == 'FRAUDE')) {
                                res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "ERR005", "errorMessage": "Le numéro '+ params.InfosContracts[0].ressources[0].mdn +' est suspendu, merci de contacter le 05 29 00 09 99", "uuid": "' +params.Operation[0].uuid+ '"}');
                                res.statusCode = 200;
                                logCreateContract.inwiB2C_Erreur__c = 'ERR005:Le numéro '+ params.InfosContracts[0].ressources[0].mdn +' est suspendu, merci de contacter le 05 29 00 09 99';
                                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                                Update logCreateContract;
                            }
                            else {
                                if (subscriptions[0].inwiB2C_Statut__c == 'InwiB2C_Suspended') {
                                    res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "ERR006", "errorMessage": "Le numéro '+ params.InfosContracts[0].ressources[0].mdn +' est suspendu, merci de contacter le 05 29 00 09 99", "uuid": "' +params.Operation[0].uuid+ '"}');
                                    res.statusCode = 200;
                                    logCreateContract.inwiB2C_Erreur__c = 'ERR006:Le numéro '+ params.InfosContracts[0].ressources[0].mdn +' est suspendu, merci de contacter le 05 29 00 09 99';
                                    logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                                    Update logCreateContract;
                                }
                                else {
                                    if (subscriptions[0].inwiB2C_LegacyStatus__c == 'Suspension cycle de vie') {
                                        res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "ERR007", "errorMessage": "Le numéro '+ params.InfosContracts[0].ressources[0].mdn +' est suspendu, merci de contacter le 05 29 00 09 99", "uuid": "' +params.Operation[0].uuid+ '"}');
                                        res.statusCode = 200;
                                        logCreateContract.inwiB2C_Erreur__c = 'ERR007:Le numéro '+ params.InfosContracts[0].ressources[0].mdn +' est suspendu, merci de contacter le 05 29 00 09 99';
                                        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                                        Update logCreateContract;
                                    }
                                    else {
                                        if (subscriptions[0].InwiB2C_Canal__c == 'inwiB2C_FirstCall' && params.Operation[0].canal == 'DIGITAL') {
                                            /*Update Contract*/
                                            List<Contract> contractIdExist = [
                                                SELECT id
                                                FROM Contract
                                                WHERE Subscription__c = :subscriptions[0].id
                                                LIMIT 1
                                            ];
                                            Contract contractClientUpdate = new Contract();
                                            contractClientUpdate.id = contractIdExist[0].id;
                                            contractClientUpdate.InwiB2c_Nom__c = params.InfosContracts[0].customers[0].firstName;
                                            contractClientUpdate.InwiB2c_Prenom__c = params.InfosContracts[0].customers[0].lastname;
                                            //contractClientUpdate.InwiB2C_Address__c = addressId;
                                            contractClientUpdate.InwiB2C_MDN_Dealer__c = params.InfosContracts[0].ressources[0].mdnDealer;
                                            string sexe;
                                            if (params.InfosContracts[0].customers[0].gender == 'M') {
                                                sexe = 'Homme';
                                            } else if (params.InfosContracts[0].customers[0].gender == 'F') {
                                                sexe = 'Femme';
                                            } else {
                                                sexe = 'Inconnu';
                                            }
                                            contractClientUpdate.InwiB2C_Sexe__c = sexe;
                                            if (params.InfosContracts[0].customers[0].birthdate != '') {
                                                contractClientUpdate.InwiB2C_Date_de_naissance__c = Date.parse(params.InfosContracts[0].customers[0].birthdate
                                                                                                              );
                                            }
                                            contractClientUpdate.InwiB2C_statut_contrat__c = 'Initialise';
                                            contractClientUpdate.inwiB2C_Profession__c = 'Dummy';
                                            contractClientUpdate.InwiB2C_Type_CIN__c = params.InfosContracts[0].customers[0].typePi;
                                            contractClientUpdate.InwiB2C_Num_CIN__c = params.InfosContracts[0].customers[0].pi;
                                            update contractClientUpdate;
                                        }
                                        else {
                                            res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "ERR004", "errorMessage": "Le numéro '+params.InfosContracts[0].ressources[0].mdn+' est déjà activée", "uuid": "' +params.Operation[0].uuid+'"}');
                                            res.statusCode = 200;
                                            logCreateContract.inwiB2C_Erreur__c = 'ERR004:Le numéro '+params.InfosContracts[0].ressources[0].mdn+' est déjà activée';
                                            logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                                            Update logCreateContract;
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            String procedureName = 'inwib2c_InwiB2C_CreateClient';
                            Map<String, Object> ipInput = new Map<String, Object> ();
                            Map<String, Object> mapItem = new Map<String, Object> ();
                            Map<String, Object> ipOutput = new Map<String, Object> ();
                            Map<String, Object> ipOptions = new Map<String, Object> ();
                            
                            mapItem.put('IS_ADSL_INTERESTED', 'false');
                            mapItem.put('PREFERRED_CONTACT_CHANNEL', 'SMS');
                            ipInput.put('individualPost', mapItem);

                            mapItem = new Map<String, Object> ();
                            if (params.InfosContracts[0].customers[0].typePi == 'NID')
                            {
                                mapItem.put('typeIdentity', 'CIN');
                            }
                            else {
                                mapItem.put('typeIdentity', params.InfosContracts[0].customers[0].typePi);   
                            }
                            mapItem.put('identityNumber', params.InfosContracts[0].customers[0].pi);
                            ipInput.put('identificationClient', mapItem);

                            mapItem = new Map<String, Object> ();
                            System.debug('gender: ' + params.InfosContracts[0].customers[0].gender);
                            if (params.InfosContracts[0].customers[0].gender == null || params.InfosContracts[0].customers[0].gender == '')
                            {
                                mapItem.put('gender', 'MR');
                            }
                            else {
                                mapItem.put('gender', params.InfosContracts[0].customers[0].gender);
                            }
                            mapItem.put('familyName', params.InfosContracts[0].ressources[0].mdn);
                            mapItem.put('legalName', 'Dummy');
                            if (params.InfosContracts[0].customers[0].birthdate == null || params.InfosContracts[0].customers[0].birthdate == '') {
                                mapItem.put('birthDate', '01-01-1900');
                            }
                            else {
                                string birthdate = params.InfosContracts[0].customers[0].birthdate;
                                birthdate = birthdate.replace('/', '-');
                                mapItem.put('birthDate', birthdate);
                            }
                            mapItem.put('language', 'ARA');
                            mapItem.put('nationality', 'MAR');
                            mapItem.put('activity_area', 'Dummy');
                            mapItem.put('profession', 'Dummy');
                            mapItem.put('segment1', params.InfosContracts[0].customers[0].segmentLevel1);
                            mapItem.put('segment2', params.InfosContracts[0].customers[0].segmentLevel2);
                            ipInput.put('customerInfos', mapItem); 

                            mapItem = new Map<String, Object> ();
                            mapItem.put('email', params.InfosContracts[0].ressources[0].mdn+'@dummy.xx');
                            mapItem.put('phoneNumber', params.InfosContracts[0].ressources[0].mdn);
                            mapItem.put('phone', '');
                            ipInput.put('contactInfos', mapItem);

                            mapItem = new Map<String, Object> ();
                            mapItem.put('principal', true);
                            mapItem.put('billingAdress', false);
                            if (params.InfosContracts[0].customers[0].address == null || params.InfosContracts[0].customers[0].address == '')
                            {
                                mapItem.put('address', 'DUMMY');
                            }
                            else {
                                mapItem.put('address', params.InfosContracts[0].customers[0].address);
                            }
                            if (params.InfosContracts[0].customers[0].countryCode == null || params.InfosContracts[0].customers[0].countryCode == '')
                            {
                                mapItem.put('countryCode', 'MAR');
                            }
                            else {
                                mapItem.put('countryCode', params.InfosContracts[0].customers[0].countryCode);
                            }
                            if (params.InfosContracts[0].customers[0].city == null || params.InfosContracts[0].customers[0].city == '')
                            {
                                mapItem.put('city', 'DUMMY');
                            }
                            else {
                                mapItem.put('city', params.InfosContracts[0].customers[0].city);
                            }
                            mapItem.put('state', params.InfosContracts[0].customers[0].state); 
                            if (params.InfosContracts[0].customers[0].region == null || params.InfosContracts[0].customers[0].region == '')
                            {
                                mapItem.put('region', 'DUMMY');
                            }
                            else {
                                mapItem.put('region', params.InfosContracts[0].customers[0].region);
                            }
                            if (params.InfosContracts[0].customers[0].postcode == null || params.InfosContracts[0].customers[0].postcode == '')
                            {
                                mapItem.put('zipCode', '00000');
                            }
                            else {
                                mapItem.put('zipCode', params.InfosContracts[0].customers[0].postcode);
                            }
                            mapItem.put('addr_filed2', params.InfosContracts[0].customers[0].complementAddress);
                            ipInput.put('addresse', mapItem);
                            
                            /* Call the IP via runIntegrationService, and save the output to ipOutput */
                            ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
                            
                            System.debug('IP Output inwib2c_InwiB2C_CreateClient: ' + ipOutput);
                            
                            Map<String, Object> mapCSOperationResultInfo = (Map<String, Object>)ipOutput.get('CSOperationResultInfo');
                            String error = (String) mapCSOperationResultInfo.get('errorCode');
                            clientId = (String) mapCSOperationResultInfo.get('clientId');
                            System.debug('error: ' + error);
                            System.debug('clientId: ' + clientId);
                            If ((error != 'OK') && (error != '') && (error != null)) {
                                logCreateContract.inwiB2C_Erreur__c = error;
                                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                                Update logCreateContract;            
                            }
                            
                            /*       Account client = new Account();
client.Name = 'Dummy ' + params.InfosContracts[0].ressources[0].mdn;
client.Inwib2c_Segment_march__c = params.InfosContracts[0].customers[0].segmentLevel1;
client.Inwib2c_Segment_valeur__c = params.InfosContracts[0].customers[0].segmentLevel2;
client.inwiB2C_managedInSF__c = true;
client.vlocity_cmt__Status__c = 'Nouveau';
client.Inwib2c_Client_Depuis__c = date.today();
client.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();

InwiB2C_Address__c address = new InwiB2C_Address__c();

List<InwiB2C_Pays__c> pays = [
SELECT id
FROM InwiB2C_Pays__c
WHERE InwiB2C_code_pays__c = :params.InfosContracts[0].customers[0].countryCode LIMIT 1
];

if (!pays.isEmpty()) {
address.InwiB2C_Pays__c = pays[0].id;
}

List<InwiB2C_Region__c> region = [
SELECT id
FROM InwiB2C_Region__c
WHERE Pays__c = :address.InwiB2C_Pays__c AND Name = :params.InfosContracts[0].customers[0].region LIMIT 1
];

if (!region.isEmpty()) {
address.InwiB2C_Region__c = region[0].id;
}

List<inwiB2C_Ville__c> ville = [
SELECT id
FROM inwiB2C_Ville__c
WHERE InwiB2C_Region__c = :address.InwiB2C_Region__c AND Name = :params.InfosContracts[0].customers[0].city LIMIT 1
];

if (!ville.isEmpty()) {
address.inwiB2C_Ville__c = ville[0].id;
}

List<InwiB2C_Quartier__c> quartier = [
SELECT id
FROM inwiB2C_Quartier__c
WHERE inwiB2C_Ville__c = :address.inwiB2C_Ville__c AND Name = :params.InfosContracts[0].customers[0].state LIMIT 1
];

if (!quartier.isEmpty()) {
address.InwiB2C_Quartier__c = quartier[0].id;
}
else {
address.InwiB2C_Precision_Quartier__c = params.InfosContracts[0].customers[0].state;
}

address.Name = address.InwiB2C_Pays__c + ' ' + address.InwiB2C_Region__c + ' ' + address.inwiB2C_Ville__c + ' ' + address.InwiB2C_Quartier__c + address.InwiB2C_Precision_Quartier__c;
address.InwiB2C_Rue__c = params.InfosContracts[0].customers[0].street;
address.InwiB2C_Adresse__c = params.InfosContracts[0].customers[0].address;
address.InwiB2C_Rue_Complement_d_adresse__c = params.InfosContracts[0].customers[0].complementAddress;
address.InwiB2C_Code_Postale__c = params.InfosContracts[0].customers[0].postcode;
insert address;
addressId = address.Id;
client.InwiB2C_Address__c = addressId;

insert client;
clientId = client.Id;

Contact contactClient = new Contact();
contactClient.AccountId = clientId;
contactClient.firstName = 'Dummy';
contactClient.lastname = params.InfosContracts[0].ressources[0].mdn;
contactClient.InwiB2C_Anciennet__c = 'Dummy';
contactClient.InwiB2C_Profession__c = 'Dummy';
contactClient.InwiB2C_Secteur_d_activit__c = 'Dummy';

String salutation;
if (params.InfosContracts[0].customers[0].gender == 'M') {
salutation = 'Monsieur';
} 
else if (params.InfosContracts[0].customers[0].gender == 'F') {
salutation = 'Madame';
}
contactClient.Salutation = salutation;
if (params.InfosContracts[0].customers[0].birthdate != '') {
contactClient.Birthdate = Date.parse(params.InfosContracts[0].customers[0].birthdate);
}
if (params.Operation[0].canal != 'Dealer') {
contactClient.InwiB2C_Type_CIN__c = params.InfosContracts[0].customers[0].typePi;
contactClient.InwiB2C_CIN__c = params.InfosContracts[0].customers[0].pi;
}
insert contactClient;
Id contactId = contactClient.Id;

client.vlocity_cmt__PersonContactId__c = contactId;
update client;*/
                        }
                    }
                }   
            }
            if (logCreateContract.inwiB2C_StatutDeTraitement__c == 'inwiB2C_Nouveau') {
                if (contractId==null) {
                    System.debug('ContractId='+contractId);
                    contractClient.AccountId = clientId;
                    contractClient.InwiB2c_Nom__c = params.InfosContracts[0].customers[0].firstName;
                    contractClient.InwiB2c_Prenom__c = params.InfosContracts[0].customers[0].lastname;
                    contractClient.InwiB2C_Address__c = addressId;
                    contractClient.InwiB2C_MDN_Dealer__c = params.InfosContracts[0].ressources[0].mdnDealer;
                    string sexe;
                    if (params.InfosContracts[0].customers[0].gender == 'M') {
                        sexe = 'Homme';
                    }
                    else if (params.InfosContracts[0].customers[0].gender == 'F') {
                        sexe = 'Femme';
                    }
                    else {
                        sexe = 'Inconnu';
                    }
                    contractClient.InwiB2C_Sexe__c = sexe;
                    if (params.InfosContracts[0].customers[0].birthdate != '') {
                        contractClient.InwiB2C_Date_de_naissance__c = Date.parse(params.InfosContracts[0].customers[0].birthdate);
                    }
                    contractClient.InwiB2C_statut_contrat__c = 'Initialise';
                    contractClient.inwiB2C_Profession__c = 'Dummy';
                    contractClient.InwiB2C_Date_CRM__c = datetime.now();
                    contractClient.InwiB2C_Date_de_souscription__c = date.today();
                    contractClient.InwiB2C_Type_CIN__c = params.InfosContracts[0].customers[0].typePi;
                    contractClient.InwiB2C_Num_CIN__c = params.InfosContracts[0].customers[0].pi;
                    insert contractClient;
                    
                    contractId = contractClient.Id;
                    String contratNumber = contractClient.ContractNumber;
                    List<Account> partenaires = [
                        SELECT id, inwib2c_CodePartenaire__c, inwiB2C_TypePartenaire__c
                        FROM Account
                        WHERE inwib2c_CodePartenaire__c =: params.Operation[0].businessUnit LIMIT 2
                    ];
                    if (!partenaires.isEmpty()) {
                        for (Integer i = 0; i < partenaires.size(); i++) {
                            if (partenaires[i].inwiB2C_TypePartenaire__c == 'inwiB2C_Distributeur') {
                                distributeurId = partenaires[i].id;
                            }
                            if (partenaires[i].inwiB2C_TypePartenaire__c == 'inwiB2C_Agence') {
                                partenaireId = partenaires[i].id;
                            }
                        }
                    }
                }
                
                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_EnCours';
                Update logCreateContract; 
                contractClient.InwiB2C_Distributeur__c = distributeurId;
                contractClient.InwiB2C_Point_de_vente_CMD__c = partenaireId;
                contractClient.Status = 'Activated';
                update contractClient;
                //Create Event
                String canal;
                IF (params.Operation[0].canal == 'USSD-D') {
                    canal = 'inwiB2C_USSD';
                }
                else {
                    canal = 'inwiB2C_' + params.Operation[0].canal;
                }
                
                inwiB2C_APICreateOrder__e eventCreateOrder = new inwiB2C_APICreateOrder__e();
                eventCreateOrder.inwiB2C_Canal__c = canal;
                eventCreateOrder.inwiB2C_BusinessUnit__c = distributeurId;
                eventCreateOrder.inwiB2C_POS__c = partenaireId;
                eventCreateOrder.inwiB2C_Ocerised__c = params.InfosContracts[0].customers[0].Ocerised;
                
                //Ressources
                eventCreateOrder.inwiB2C_DealerId__c = dealerId;
                eventCreateOrder.inwiB2C_Mdn__c = params.InfosContracts[0].ressources[0].mdn;
                eventCreateOrder.inwiB2C_Icc__c = params.InfosContracts[0].ressources[0].icc;
                eventCreateOrder.inwiB2C_ProfileId__c = params.InfosContracts[0].ressources[0].profileId;
                eventCreateOrder.inwiB2C_imsi__c = params.InfosContracts[0].ressources[0].imsi;
                eventCreateOrder.inwiB2C_ki__c = params.InfosContracts[0].ressources[0].ki;
                eventCreateOrder.inwiB2C_puk__c = params.InfosContracts[0].ressources[0].puk;
                eventCreateOrder.inwiB2C_MdnOCSID__c = params.InfosContracts[0].ressources[0].ocsId;
                system.debug('Code Article : '+params.InfosContracts[0].ressources[0].codeArticle);
                eventCreateOrder.inwiB2C_CodeArticle__c = params.InfosContracts[0].ressources[0].codeArticle;
                
                //Ids
                eventCreateOrder.inwiB2C_IdLog__c = logCreateContractId;
                eventCreateOrder.inwiB2C_ContratId__c = contractId;
                eventCreateOrder.inwiB2C_CustomerId__c = clientId;
                System.debug('Before publishing the event inwiB2C_APICreateOrder__e.');
                
                logCreateContract.inwiB2C_IdAccount__c = clientId;
                logCreateContract.inwiB2C_IdContract__c = contractId;
                Update logCreateContract;
                
                // Call method to publish events
                Database.SaveResult sresult = EventBus.publish(eventCreateOrder);
                
                if (sresult.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    for (Database.Error err : sresult.getErrors()) {
                        System.debug('Error returned: ' +err.getStatusCode()+ ' - ' +err.getMessage());
                        string errormsg = 'Publish event error: ' +err.getStatusCode()+ ' - ' +err.getMessage();
                        logCreateContract.inwiB2C_Erreur__c = errormsg.substring(0, 254);
                        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                        Update logCreateContract;
                    }
                }
                res.responseBody = blob.valueOf('{"status": "OK", "idContractSf": "' +contractId+ '", "uuid": "' +params.Operation[0].uuid+ '"}');
                res.statusCode = 200;
            }
        } catch (Exception e) {
            res.responseBody = blob.valueOf('{"status": "KO", "errorCode": "' +String.valueOf(e)+ '", "errorMessage": "' +String.valueOf(e)+ ': ' +String.valueOf(e.getStackTraceString())+ '", "uuid": "' +params.Operation[0].uuid+ '"}');
            res.statusCode = 400;
            string errorMessage = 'errorMessage": "' +String.valueOf(e)+ ': ' +String.valueOf(e.getStackTraceString());
            if(errorMessage.Length()>254){
            logCreateContract.inwiB2C_Erreur__c = errorMessage.substring(0, 254);
            }
            else {
                logCreateContract.inwiB2C_Erreur__c = errorMessage;
            }

            logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
            Update logCreateContract;
        }
    }
}
/*ZME INWIB2C-PHASE2-Lot 1.2 12.04.2021 END*/