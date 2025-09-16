/** 
 * description: Cette classe permet de récupérer les enregistrements de la table InwiB2C_MDN_KOHandler__c et vérifie l'existance de mdn sur la souscription et contract bulk
 * Sujet: MGEN3727B Besoin Identification MDM_TRE_Data_Reporting_V1.0
 * author : khaoula kanboua
 * last modify by : Khaoula kanboua  19/06/2025
 
*/
global with sharing class InwiB2C_TraitementRejetIdentificationMRE implements vlocity_cmt.VlocityOpenInterface {

    public Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap) {
        Boolean result = true;

        try {
            if (methodName == 'getMdnKoHandler') {
                this.getMdnKoHandler(inputMap, outputMap, optionsMap);
                System.debug('Résultat retourné : ' + outputMap);
            } else if (methodName == 'verifyResiliatedSubscription') {
                this.verifyResiliatedSubscription(inputMap, outputMap, optionsMap);
            }
             else {
                result = false; 
            }
        } catch (Exception e) {
            System.debug('Erreur dans invokeMethod: ' + e.getMessage());
            result = false;
        }

        return result;
    }
    // Récupère les enregistrements de l'objet InwiB2C_MDN_KOHandler__c qu'on un statut "Nouvelle"
    public void getMdnKoHandler(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap) {
        List<InwiB2C_MDN_KOHandler__c> koHandlers = [
            SELECT Id, InwiB2C_BusinessReference__c, CreatedDate, InwiB2C_Mdn__c, InwiB2C_Statut__c 
            FROM InwiB2C_MDN_KOHandler__c where InwiB2C_Statut__c = 'Nouvelle' order by CreatedDate desc
            LIMIT 200
        ];

        outputMap.put('result', koHandlers);
    }
    // Vérifie l’existence d’une souscription résiliée et d’un contrat associé à mdn donnée
   public void verifyResiliatedSubscription(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap) {
    String mdn = (String)inputMap.get('mdn');
    String reference = (String)inputMap.get('reference');

    if (String.isBlank(mdn)) {
        outputMap.put('result', new Map<String, Object>{
            'status' => 'ERROR',
            'message' => 'Le numéro de téléphone est vide.'
        });
        return;
    }

    // Vérification de la souscription
    List<vlocity_cmt__Subscription__c> subscriptions = [SELECT Id, inwiB2C_Statut__c , vlocity_cmt__AccountId__c FROM vlocity_cmt__Subscription__c WHERE Inwib2c_Num_ro_de_la_ligne__c = :mdn AND (inwiB2C_Statut__c ='InwiB2C_Active' OR  inwiB2C_Statut__c = 'InwiB2C_ResylCycleVie')   LIMIT 1];

    if (subscriptions.isEmpty()) {
        outputMap.put('result', new Map<String, Object>{
            'status' => 'ERROR',
            'message' => 'Aucune souscription ni contrat trouvés avec ce numéro.'
        });
        return;
    }

    //Vérification du contrat uniquement si la souscription existe
    vlocity_cmt__Subscription__c sub = subscriptions[0];
       String statut = sub.inwiB2C_Statut__c;
       System.debug('statut' + statut);

    // Dispatch par statut
   
 if (statut == 'InwiB2C_ResylCycleVie') {
    List<inwiB2C_CreateContractBulk__c> contracts = [SELECT Id, inwiB2C_Mdn__c, inwiB2C_StatutDeTraitement__c FROM inwiB2C_CreateContractBulk__c WHERE inwiB2C_Mdn__c = :mdn AND inwiB2C_businessreference__c = :reference LIMIT 1];
    if (!contracts.isEmpty()) {
        inwiB2C_CreateContractBulk__c contract = contracts[0];
        System.debug('Contrat trouvé: ID = ' + contract.Id + ', Statut = ' + contract.inwiB2C_StatutDeTraitement__c);

        outputMap.put('result', new Map<String, Object>{
            'status' => 'OK',
            'contractId' => contract.Id,
            'contractStatut' => contract.inwiB2C_StatutDeTraitement__c,
            'subId' => sub.Id
        });
    } else {
        outputMap.put('result', new Map<String, Object>{
            'status' => 'OK',
            'message' => 'Aucun contrat associé à la souscription.',
            'subId' => sub.Id
        });
    }}
    else if (statut == 'InwiB2C_Active') {
        if (sub.vlocity_cmt__AccountId__c == null) {
            outputMap.put('result', new Map<String, Object>{
                'status' => 'ERROR',
                'message' => 'Aucun Account associé à la souscription active.'
            });
            return;
        }

        Account acc = [
            SELECT id, inwib2c_geolocalisation__latitude__s, inwib2c_geolocalisation__longitude__s,
               vlocity_cmt__personcontactid__r.firstname,
               vlocity_cmt__personcontactid__r.inwib2c_secteur_d_activit__c,
               inwib2c_address__r.inwib2c_code_postale__c,
               inwib2c_address__r.inwib2c_adresse__c,
               inwib2c_address__r.inwib2c_pays__c,
               inwib2c_address__r.inwib2c_precision_quartier__c,
               inwib2c_address__r.inwib2c_quartier__r.name,
               inwib2c_address__r.inwib2c_region__r.name,
               inwib2c_address__r.inwib2c_type_d_adresse__c,
               inwib2c_address__r.inwib2c_ville__r.name,
               vlocity_cmt__personcontactid__r.birthdate,
               vlocity_cmt__personcontactid__r.inwib2c_cin__c,
               vlocity_cmt__personcontactid__r.salutation,
               vlocity_cmt__personcontactid__c,
               vlocity_cmt__personcontactid__r.inwib2c_situation_familiale__c,
               vlocity_cmt__personcontactid__r.inwib2c_langue_pr_f_r_e__c,
               vlocity_cmt__primarycontactid__r.inwib2c_fax__c,
               inwib2c_abonnement_fixe__c,
               inwib2c_abonnement_internet__c,
               vlocity_cmt__personcontactid__r.inwib2c_niveau_d_tudes__c,
               vlocity_cmt__personcontactid__r.email,
               vlocity_cmt__personcontactid__r.inwib2c_nationnalit__c,
               vlocity_cmt__personcontactid__r.lastname,
               inwib2c_vip_choix_principal_op_rateur__c,
               vlocity_cmt__personcontactid__r.inwib2c_moyen_de_contact_principal__c,
               vlocity_cmt__personcontactid__r.inwib2c_profession__c,
               vlocity_cmt__personcontactid__r.inwib2c_revenus__c,
               inwib2c_segment_dealer__c,
               inwib2c_segment_valeur__c,
               vlocity_cmt__personcontactid__r.inwib2c_anciennet__c,
               inwib2c_segment_march__c,
               vlocity_cmt__personcontactid__r.inwib2c_num_ro_de_contact__c,
               vlocity_cmt__personcontactid__r.inwib2c_type_cin__c,
               inwib2c_type_dealer__c
            FROM Account
            WHERE Id = :sub.vlocity_cmt__AccountId__c
            LIMIT 1
        ];
        System.debug('accountInfos' + acc);
        outputMap.put('result', new Map<String, Object>{
            'status' => 'OK',
            'acc' => acc        });
    } else {
        outputMap.put('result', new Map<String, Object>{
            'status' => 'ERROR',
            'message' => 'Statut non géré : ' + statut
        });}
}

}