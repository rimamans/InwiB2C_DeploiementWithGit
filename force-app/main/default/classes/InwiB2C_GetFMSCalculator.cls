/**
 * @description       : Calcule le montant FMS selon le type d’offre
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-04-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class InwiB2C_GetFMSCalculator implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap) {
        Boolean result = true; 
        try {
            if (methodName == 'GetFMSByOrderId') {
                GetFMSByOrderId(inputMap, outputMap, optionsMap);
            }
        } catch(Exception e) {
            outputMap.put('error', e.getMessage());
            return false;
        }
        return result;
    }

    private void GetFMSByOrderId(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap) {
        try {
            Map<String, Object> orderDataInput = (Map<String, Object>) inputMap.get('OrderDataInput');

            String productCode       = (String) orderDataInput.get('productCode');
            String offreType         = (String) orderDataInput.get('offreType');
            String typeLigne         = (String) orderDataInput.get('typeLigne');
            String isBlackListed     = (String) orderDataInput.get('isBlackListed');
            Decimal engagementDuration = (Decimal) orderDataInput.get('engagementDuration');

            if (String.isNotBlank(productCode)) {
                Decimal fmsAmount = 0;

                if (offreType == 'Cameleon') {
                    List<vlocity_cmt__PriceListEntry__c> priceListEntry = [ 
                        SELECT Id,
                               vlocity_cmt__PricingElementId__r.vlocity_cmt__Amount__c,
                               vlocity_cmt__PricingElementId__r.vlocity_cmt__PricingVariableId__r.Name 
                        FROM vlocity_cmt__PriceListEntry__c 
                        WHERE vlocity_cmt__ProductId__r.ProductCode = :productCode 
                        AND vlocity_cmt__PricingElementId__r.vlocity_cmt__PricingVariableId__r.Name = 'FMS_Catalogue'
                        LIMIT 1
                    ];
                    
                    if (!priceListEntry.isEmpty()) { 
                        fmsAmount = priceListEntry[0].vlocity_cmt__PricingElementId__r.vlocity_cmt__Amount__c != null 
                            ? priceListEntry[0].vlocity_cmt__PricingElementId__r.vlocity_cmt__Amount__c 
                            : 0;
                    }

                } else if (offreType == 'Postpaye') {

                    List<InwiB2C_MONT_CAUT_FMSFMD__c> montcautFMS = [
                        SELECT Id, VALUE_FMS__c, InwiB2C_Code_Offre__c  
                        FROM InwiB2C_MONT_CAUT_FMSFMD__c 
                        WHERE InwiB2C_Code_Offre__c = :productCode 
                          AND InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration 
                          AND InwiB2C_IS_PORTABILITY__c = 'ALL' 
                          AND InwiB2C_ISBLACKLISTED__c = :isBlackListed 
                          AND InwiB2C_M_Type_Client__c = :typeLigne
                        LIMIT 1
                    ];
                    if (!montcautFMS.isEmpty()) {
                        fmsAmount = montcautFMS[0].VALUE_FMS__c != null 
                            ? montcautFMS[0].VALUE_FMS__c 
                            : 0;
                    }
                }

                outputMap.put('MontantFMS', fmsAmount);
            } else {
                outputMap.put('error', 'ProductCode non fourni ou vide.');
            }

        } catch (Exception e) {
            outputMap.put('error', 'Erreur lors du calcul FMS : ' + e.getMessage());
        }
    }
}