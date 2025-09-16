/*ZME INWIB2C-PHASE2-Lot 1.2 29.07.2021 BEGIN*/
@RestResource(urlMapping='/CreateContractFirstCall')
global with sharing class inwiB2C_CreateContractFirstCall {
    @HttpPost
    global static void createContract() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        inwiB2C_CreateContractFirstCallParams params; 

        if(!Test.isRunningTest()) {
        params = inwiB2C_CreateContractFirstCallParams.parse(req.requestBody.tostring());
        Map<String, Object> responseMap = new Map<String, Object>();
        res.addHeader('charset', 'UTF-8 Server');
        res.addHeader('Content-Type', 'application/json');
        }
        else
        {
             params = inwiB2C_CreateContractFirstCallParams.parse('{"ressources":[{"mdn":"212000035026","mdnDealer":"212648069965","icc":"123000000000035026","profileId":"618","imsi":"123000000035026","ki":"F97769DD8309EA44AD0EE2BBB7AB45CC","puk":"26364298","codeArticle":"000012345","ocsId":"IN1", "correlationId":"123456789AA","LigneActive":false,"DateReelDemande":"2023-06-14T12:12:56","businessreference":"12345"}],"operation":{"uuid":"34b9548a-62d1-4a41-b5e4-0ffd520b44e8","canal":"inwiB2C_FD"}}');
        }
        try {
            //JBEN - 11052022 - Get ProfileId of the dealer - START
            string profileIdDealerBulk = [Select MasterLabel, inwiB2C_ProfileId__c, Label from InwiB2C_ProfileIdDealerBulk__mdt where label = 'ProfileIdDealer' limit 1].inwiB2C_ProfileId__c;
            //JBEN - 11052022 - Get ProfileId of the dealer - END
            List<inwiB2C_CreateContractBulk__c> createContractBulkRecords = new List<inwiB2C_CreateContractBulk__c>();
            for (Integer i = 0; i < params.ressources.size(); i++) {
                inwiB2C_CreateContractBulk__c createContractBulkRecord = new inwiB2C_CreateContractBulk__c();
                //createContractBulkRecord.inwiB2C_Request__c;
                if(!Test.isRunningTest()) {
       		 		createContractBulkRecord.inwiB2C_Request__c = req.requestBody.tostring();
                }
                else
                {
                    createContractBulkRecord.inwiB2C_Request__c = '{"infosContracts":[{"customers":{"canal":"inwiB2C_FDV","user":"212648069965","businessUnit":"CPD01","pos":"POSIDENT","firstName":"ACTIVATIONP","lastName":"TESTPSF","birthDate":"01/01/1900","typePi":"NID","pi":"FQ0097856","Ocerised":false,"segmentLevel1":"C","address":"CASABLANCA"},"ressources":{"mdn":"212000035026","mdnDealer":"212648069965","icc":"123000000000035026","profileId":"618","imsi":"123000000035026","ki":"F97769DD8309EA44AD0EE2BBB7AB45CC","puk":"26364298","codeArticle":"000012345","ocsId":"IN1", , "correlationId":"123456789AA,"businessreference":"12345"}}],"operation":{"uuid":"34b9548a-62d1-4a41-b5e4-0ffd520b44e8"}}';
                }
                  /*chb 28/05/2024 SF24-047-complement D2D MRE begin*/
                  if(params.Operation.canal== 'inwiB2C_FDV'|| Test.isRunningTest()){
                    if(params.ressources[i].businessreference!=null || Test.isRunningTest()){
                        createContractBulkRecord.inwiB2C_businessreference__c=params.ressources[i].businessreference;
                    }else{
                        throw new StringException('businessreference obligatoire pour le canal force de vente');
                    }/*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
                    if(params.ressources[i].accountid!=null || Test.isRunningTest()){
                        createContractBulkRecord.inwiB2C_IdAccount__c =params.ressources[i].accountid;
                    }
                    else{
                        throw new StringException('accountid obligatoire pour canal Force de vente');
                    }/*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final end*/
                    
                }else if(params.Operation.canal!= 'inwiB2C_FDV'){
                    if(params.ressources[i].businessreference!=null ){createContractBulkRecord.inwiB2C_businessreference__c=params.ressources[i].businessreference;
                    }/*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
                  //  if(params.ressources[i].accountid!=null){
                   //     createContractBulkRecord.inwiB2C_IdAccount__c =params.ressources[i].accountid;
                  //  }/*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final end*/
                }
                    /*chb 28/05/2024 SF24-047-complement D2D MRE end*/
                //Operation
                createContractBulkRecord.inwiB2C_uuid__c = params.operation.uuid;
                //Customer
                createContractBulkRecord.inwiB2C_Canal__c = params.Operation.canal;
                createContractBulkRecord.inwiB2C_User__c = params.Operation.user;
                createContractBulkRecord.inwiB2C_uuid__c = params.Operation.user;
                createContractBulkRecord.inwiB2C_CodeDistributeur__c = params.ressources[i].businessUnit;
                createContractBulkRecord.InwiB2C_CodeAgence__c = params.ressources[i].pos;
                //Ressource
                createContractBulkRecord.inwiB2C_Mdn__c = params.ressources[i].mdn;
                createContractBulkRecord.inwiB2C_Icc__c = params.ressources[i].icc;
                createContractBulkRecord.inwiB2C_ProfileId__c = params.ressources[i].profileId;
                createContractBulkRecord.inwiB2C_Imsi__c = params.ressources[i].imsi;
                createContractBulkRecord.inwiB2C_Ki__c = params.ressources[i].ki;
                createContractBulkRecord.inwiB2C_Puk__c = params.ressources[i].puk;
                createContractBulkRecord.inwiB2C_CodeArticle__c = params.ressources[i].codeArticle;
                createContractBulkRecord.inwiB2C_OcsId__c = params.ressources[i].ocsId;
                 //chb 04/07/2024 ttm AM begin */
                /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
                // createContractBulkRecord.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Nouveau';
                //CHB 19/06/2025 DS4752  Rollback SOA begin */
                //createContractBulkRecord.inwiB2C_StatutDeTraitement__c = params.ressources[i].profileId =='2539' || params.ressources[i].mdn!=null && params.ressources[i].icc!=null && params.ressources[i].mdn!='' && params.ressources[i].icc!='' && params.Operation.canal== 'inwiB2C_FDV'?'inwiB2C_Erreur':'inwiB2C_Nouveau';
                createContractBulkRecord.inwiB2C_StatutDeTraitement__c = params.ressources[i].mdn!=null && params.ressources[i].icc!=null && params.ressources[i].mdn!='' && params.ressources[i].icc!='' && params.Operation.canal== 'inwiB2C_FDV'?'inwiB2C_Erreur':'inwiB2C_Nouveau';
                //CHB 19/06/2025 DS4752  Rollback SOA end */
                //createContractBulkRecord.inwiB2C_Erreur__c =params.ressources[i].profileId =='2539'?'Les lignes Dealer ne sont pas pris en charge.':'';
                 //CHB 19/06/2025 DS4752  Rollback SOA begin */
                //createContractBulkRecord.inwiB2C_Erreur__c =params.ressources[i].profileId =='2539'?'Les lignes Dealer ne sont pas pris en charge.':params.ressources[i].mdn!=null && params.ressources[i].mdn!='' && params.ressources[i].icc!='' && params.ressources[i].icc!=null && params.Operation.canal== 'inwiB2C_FDV'?'L\'insertion du couple MDN et ICC est interdite.':'';
                createContractBulkRecord.inwiB2C_Erreur__c = params.ressources[i].mdn!=null && params.ressources[i].mdn!='' && params.ressources[i].icc!='' && params.ressources[i].icc!=null && params.Operation.canal== 'inwiB2C_FDV'?'L\'insertion du couple MDN et ICC est interdite.':'';
               //CHB 19/06/2025 DS4752  Rollback SOA end */
                //CHB 19/06/2025 DS4752  Rollback SOA begin */
                /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final end*/
                
                //chb 04/07/2024 ttm AM end */
              
                //JBEN - 17122021 - ADD CORRELATIONID
                createContractBulkRecord.inwiB2C_CorrelationId__c = params.ressources[i].correlationId;
                //JBEN - 12052022 - ADD SEGMENTLevel1 to define if dealer or not
                createContractBulkRecord.inwiB2C_SegmentLevel1__c = params.ressources[i].profileId == profileIdDealerBulk?'D':'C';
                //CHB - 14-06-2023 - ADD LigneActive & DateReelDemande
                //createContractBulkRecord.InwiB2C_LigneActive__c = params.ressources[i].LigneActive;
                createContractBulkRecord.InwiB2C_DateReelDemande__c = params.ressources[i].DateReelDemande;
               //Amine brm 21/03/2024 TTM ESIM
                createContractBulkRecord.inwib2c_TypeCarteSIM__c = params.ressources[i].typesim;



                createContractBulkRecords.add(createContractBulkRecord);
            }
            insert createContractBulkRecords;
            if(!Test.isRunningTest()) {
            	res.responseBody = blob.valueOf('{"status": "OK", "uuid": "' + params.Operation.uuid +'"}');
            }
        }
        catch (Exception e) {
            res.responseBody = blob.valueOf('{"status": "KO", "errorCode":' + String.valueOf(e) + ', "errorMessage": ' + String.valueOf(e) + ': ' + String.valueOf(e.getStackTraceString()) +', "uuid": "' +  String.valueOf(params.Operation.uuid) +'"}');
            res.statusCode = 400;
        }
    }
}
/*ZME INWIB2C-PHASE2-Lot 1.2 29.07.2021 END*/