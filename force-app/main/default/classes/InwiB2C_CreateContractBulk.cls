@RestResource(urlMapping='/CreateContractBulk')
global with sharing class InwiB2C_CreateContractBulk {
    @HttpPost
    global static void createContractBulk() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        InwiB2C_CreateContractBulkParams params;
        if(!Test.isRunningTest()) {
       		 params = InwiB2C_CreateContractBulkParams.parse(req.requestBody.tostring());
          	 res.addHeader('charset', 'UTF-8 Server');
        	 res.addHeader('Content-Type', 'application/json');
        }
        else
        {
             //R-SL 12/06/2025 start
             params = InwiB2C_CreateContractBulkParams.parse('{"infosContracts":[{"customers":{"canal":"AM","user":"212648069965","businessUnit":"CPD01","pos":"POSIDENT","firstName":"ACTIVATIONP","lastName":"TESTPSF","birthDate":"01/01/1900","typePi":"NID","pi":"FQ0097856","Ocerised":false,"segmentLevel1":"C","address":"CASABLANCA"},"ressources":{"mdn":"212000035026","businessreference":"123","mdnDealer":"212648069965","icc":"123000000000035026","profileId":"618","imsi":"123000000035026","ki":"F97769DD8309EA44AD0EE2BBB7AB45CC","puk":"26364298","codeArticle":"000012345","ocsId":"IN1", "correlationId":"123456789AA"}}],"operation":{"uuid":"34b9548a-62d1-4a41-b5e4-0ffd520b44e8"}}');
             //R-SL 12/06/2025 end
        }
        Map<String, Object> responseMap = new Map<String, Object>();

        try {
            List<inwiB2C_CreateContractBulk__c> createContractBulkRecords = new List<inwiB2C_CreateContractBulk__c>();
            //R-SL 12/06/2025 start
            List<User> users = new List<User>();
            if(params.infosContracts[0].customers.animateur !=''){
            users = [SELECT Id FROM User WHERE Id = :params.infosContracts[0].customers.animateur];
            }
            //R-SL 12/06/2025 end
            for (Integer i = 0; i < params.infosContracts.size(); i++) {
                inwiB2C_CreateContractBulk__c createContractBulkRecord = new inwiB2C_CreateContractBulk__c();
                //createContractBulkRecord.inwiB2C_Request__c;
                if(!Test.isRunningTest()) {
       		 		createContractBulkRecord.inwiB2C_Request__c = req.requestBody.tostring();
                }
                else
                {
                    //R-SL 12/06/2025 start
                    createContractBulkRecord.inwiB2C_Request__c = '{"infosContracts":[{"customers":{"canal":"AM","user":"212648069965","businessUnit":"CPD01","pos":"POSIDENT","firstName":"ACTIVATIONP","lastName":"TESTPSF","birthDate":"01/01/1900","typePi":"NID","pi":"FQ0097856","Ocerised":false,"segmentLevel1":"C","address":"CASABLANCA"},"ressources":{"mdn":"212000035026","mdnDealer":"212648069965","icc":"123000000000035026","profileId":"618","imsi":"123000000035026","ki":"F97769DD8309EA44AD0EE2BBB7AB45CC","puk":"26364298","codeArticle":"000012345","ocsId":"IN1", "correlationId":"123456789AA","businessreference":"123"}}],"operation":{"uuid":"34b9548a-62d1-4a41-b5e4-0ffd520b44e8"}}';
                     //R-SL 12/06/2025 end
                }
              /*chb 28/05/2024 SF24-047-complement D2D MRE begin*/
                /* sbo 13/06/2025 B-29640 START ajout de l'attribut accountid!='' sur la condition*/
                if(params.infosContracts[i].customers.canal == 'inwiB2C_FDV' || params.infosContracts[i].customers.canal == 'AM' && params.infosContracts[i].customers.accountid!='' && params.infosContracts[i].customers.accountid!=null){
                    /* sbo 13/06/2025 B-29640 END*/
                    if(params.infosContracts[i].ressources.businessreference!=null && params.infosContracts[i].ressources.businessreference!=''){
                        createContractBulkRecord.inwiB2C_businessreference__c=params.infosContracts[i].ressources.businessreference;
                    }else{
                          //chb 23/06/2025 B-29640 begin*/
                     throw new StringException('businessreference obligatoire pour canal ' + 
                     (params.infosContracts[i].customers.canal == 'inwiB2C_FDV' ? 'Force de vente' : 'AM'));
                        // throw new StringException('businessreference obligatoire pour canal '+ params.infosContracts[i].customers.canal=='inwiB2C_FDV'?'Force de vente': params.infosContracts[i].customers.canal);
                    //chb 23/06/2025 B-29640 END*/
                          }/*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
                    if((params.infosContracts[i].customers.accountid!=null ||  params.infosContracts[i].customers.canal == 'AM' ) && params.infosContracts[i].customers.accountid!='' ){
                        createContractBulkRecord.inwiB2C_IdAccount__c =params.infosContracts[i].customers.accountid;
                    }
                    else{
                        throw new StringException('accountid obligatoire pour canal '+params.infosContracts[i].customers.canal=='inwiB2C_FDV'?'Force de vente':params.infosContracts[i].customers.canal);
                    }/*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final end*/
                   
            }else if(params.infosContracts[i].customers.canal != 'inwiB2C_FDV' && params.infosContracts[i].customers.canal != 'AM'){
                if(params.infosContracts[i].ressources.businessreference!=null && params.infosContracts[i].ressources.businessreference!=''){
                    createContractBulkRecord.inwiB2C_businessreference__c=params.infosContracts[i].ressources.businessreference;
                } /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
                //if(params.infosContracts[i].customers.accountid!=null && params.infosContracts[i].customers.accountid!=''){
                //    createContractBulkRecord.inwiB2C_IdAccount__c =params.infosContracts[i].customers.accountid;
              //  }    /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final end*/
            }   
                 
                 /*chb 28/05/2024 SF24-047-complement D2D MRE end*/
                //Operation
                createContractBulkRecord.inwiB2C_uuid__c = params.operation.uuid;
                //Customer
                createContractBulkRecord.inwiB2C_Canal__c = params.infosContracts[i].customers.canal;
                createContractBulkRecord.inwiB2C_User__c = params.infosContracts[i].customers.user;
                createContractBulkRecord.inwiB2C_CodeDistributeur__c = params.infosContracts[i].customers.businessUnit;
                createContractBulkRecord.InwiB2C_CodeAgence__c = params.infosContracts[i].customers.pos;
                createContractBulkRecord.inwiB2C_FirstName__c = params.infosContracts[i].customers.firstName;
                createContractBulkRecord.inwiB2C_LastName__c = params.infosContracts[i].customers.lastName;
                createContractBulkRecord.inwiB2C_Gender__c = params.infosContracts[i].customers.gender;
                if (params.infosContracts[i].customers.birthDate != '') {
                    createContractBulkRecord.inwiB2C_BirthDate__c = Date.parse(params.infosContracts[i].customers.birthDate);
                }
                createContractBulkRecord.inwiB2C_TypePieceIdentite__c = params.infosContracts[i].customers.typePi;
                createContractBulkRecord.inwiB2C_PieceIdentite__c = params.infosContracts[i].customers.pi;
                createContractBulkRecord.inwiB2C_Ocerised__c = params.infosContracts[i].customers.ocerised;
                createContractBulkRecord.inwiB2C_SegmentLevel1__c = params.infosContracts[i].customers.segmentLevel1;
                createContractBulkRecord.inwiB2C_SegmentLevel2__c = params.infosContracts[i].customers.segmentLevel2;
                createContractBulkRecord.inwiB2C_CountryCode__c = params.infosContracts[i].customers.countryCode;
                createContractBulkRecord.inwiB2C_City__c = params.infosContracts[i].customers.city;
                createContractBulkRecord.inwiB2C_State__c = params.infosContracts[i].customers.state;
                createContractBulkRecord.inwiB2C_Street__c = params.infosContracts[i].customers.street;
                createContractBulkRecord.inwiB2C_Address__c = params.infosContracts[i].customers.address;
                createContractBulkRecord.inwiB2C_ComplementAddress__c = params.infosContracts[i].customers.complementAddress;
                createContractBulkRecord.inwiB2C_PostCode__c = params.infosContracts[i].customers.postcode;
                createContractBulkRecord.inwiB2C_BusinessSegment__c = params.infosContracts[i].customers.businessSegment;
                
                
                //R-SL 12/06/2025 MGEN3727 Besoin Identification MDM_TRE_V1.1 (l'ajout de champ inwib2c_animateur) start
               
                if(!String.isBlank(params.infosContracts[i].customers.animateur)){
                    
                if (!users.isEmpty() ) {
                  createContractBulkRecord.InwiB2C_Animateur__c = params.infosContracts[i].customers.animateur;
                   } else {
                      throw new StringException('L\'animateur saisi n\'existe pas');
                   }
                }
                                   
                //R-SL 12/06/2025 end
                
                //Ressource
                createContractBulkRecord.inwiB2C_Mdn__c = params.infosContracts[i].ressources.mdn;
                createContractBulkRecord.inwiB2C_MdnDealer__c = params.infosContracts[i].ressources.mdnDealer;
                createContractBulkRecord.inwiB2C_Icc__c = params.infosContracts[i].ressources.icc;
                createContractBulkRecord.inwiB2C_ProfileId__c = params.infosContracts[i].ressources.profileId;
                createContractBulkRecord.inwiB2C_Imsi__c = params.infosContracts[i].ressources.imsi;
                createContractBulkRecord.inwiB2C_Ki__c = params.infosContracts[i].ressources.ki;
                createContractBulkRecord.inwiB2C_Puk__c = params.infosContracts[i].ressources.puk;
                createContractBulkRecord.inwiB2C_CodeArticle__c = params.infosContracts[i].ressources.codeArticle;
                createContractBulkRecord.inwiB2C_OcsId__c = params.infosContracts[i].ressources.ocsId;
                //chb 04/07/2024 ttm AM begin */
                //createContractBulkRecord.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Nouveau';
                 //CHB 19/06/2025 DS4752  Rollback SOA begin */
                //createContractBulkRecord.inwiB2C_StatutDeTraitement__c = params.infosContracts[i].ressources.profileId =='2539'?'inwiB2C_Erreur':'inwiB2C_Nouveau';
                //createContractBulkRecord.inwiB2C_Erreur__c =params.infosContracts[i].ressources.profileId =='2539'?'Les lignes Dealer ne sont pas pris en charge.':'';
                createContractBulkRecord.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Nouveau'; 
                //CHB 19/06/2025 DS4752  Rollback SOA end */
                //chb 04/07/2024 ttm AM end */
                //JBEN - 17122021 - ADD CORRELATIONID
                createContractBulkRecord.inwiB2C_CorrelationId__c = params.infosContracts[i].ressources.correlationId;
                //CHB - 14-06-2023 - ADD LigneActive & DateReelDemande
                //createContractBulkRecord.InwiB2C_LigneActive__c = params.infosContracts[i].ressources.LigneActive;
                createContractBulkRecord.InwiB2C_DateReelDemande__c = params.infosContracts[i].ressources.DateReelDemande;
                //Amine brm 21/03/2024 TTM ESIM
                createContractBulkRecord.inwib2c_TypeCarteSIM__c = params.infosContracts[i].ressources.typesim;

               
                createContractBulkRecords.add(createContractBulkRecord);
            }
            insert createContractBulkRecords;
            if(!Test.isRunningTest()) {
            	res.responseBody = blob.valueOf('{"status": "OK", "uuid": ' + params.Operation.uuid +'}');
            }
        }
        catch (Exception e) {
            res.responseBody = blob.valueOf('{"status": "KO", "errorCode":' + String.valueOf(e) + ', "errorMessage": ' + String.valueOf(e) + ': ' + String.valueOf(e.getStackTraceString()) +', "uuid": ' +  params.Operation.uuid +'}');
            res.statusCode = 400;
        }
    }
}