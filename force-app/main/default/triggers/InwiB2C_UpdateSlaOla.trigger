trigger InwiB2C_UpdateSlaOla on Case (before insert) {

    List<Id> subscriptionIdList = new List<Id>();

    for (Case caseNew : Trigger.new) {
        if (caseNew.vlocity_cmt__SubscriptionId__c != null) {
            subscriptionIdList.add(caseNew.vlocity_cmt__SubscriptionId__c);
        }
    }

    List<vlocity_cmt__Subscription__c> subscriptionList = [
        SELECT Id, Inwib2c_SegmentLigne__c, vlocity_cmt__AccountId__r.InwiB2C_HV__c 
        FROM vlocity_cmt__Subscription__c 
        WHERE Id IN :subscriptionIdList
    ];

    Map<Id, vlocity_cmt__Subscription__c> subscriptionMap = new Map<Id, vlocity_cmt__Subscription__c>();

    for (vlocity_cmt__Subscription__c subscription : subscriptionList) {
        subscriptionMap.put(subscription.Id, subscription);
    }

    Id profileId = UserInfo.getProfileId();
    String profileName = [SELECT Name FROM Profile WHERE Id = :profileId].Name;

    for (Case caseNew : Trigger.new) {
        /*B-0584 ZME 29.01.2021 BEGIN*/
        if (profileName == 'SC Agent VIP Int') {
            caseNew.inwib2c_Visibility__c = 'VIP';
        }
        if (profileName == 'Fraude Int') {
            caseNew.inwib2c_Visibility__c = 'FRAUDE';
        }
        /*B-0584 ZME 29.01.2021 END*/

        if (caseNew.vlocity_cmt__SubscriptionId__c != null) {
            vlocity_cmt__Subscription__c subscription = subscriptionMap.get(caseNew.vlocity_cmt__SubscriptionId__c);
            if (subscription != null) {
                Boolean isHv = subscription.vlocity_cmt__AccountId__r.InwiB2C_HV__c;

                if (caseNew.type == 'Inwib2c_Reclamation') {
                    if (caseNew.Inwib2c_Cat_gorie__c == 'Inwib2c_Reseau_Reclamation' && isHv) {
                        caseNew.SLA__c = '6H';
                        caseNew.OLA__c = '8H';    
                    } else if (caseNew.Inwib2c_Cat_gorie__c == 'Inwib2c_Couverture' && isHv) {
                        caseNew.SLA__c = 'NA';
                        caseNew.OLA__c = '16J';
                    } else if (caseNew.Inwib2c_Cat_gorie__c == 'Inwib2c_Recharge_Reclamation' && isHv) {
                        caseNew.SLA__c = '6H';
                        caseNew.OLA__c = 'NA';
                    } else if (caseNew.Inwib2c_Cat_gorie__c == 'Inwib2c_Facturation_Reclamation' && isHv) {
                        caseNew.SLA__c = '28H';
                        caseNew.OLA__c = 'NA';
                    } else if (caseNew.Inwib2c_Cat_gorie__c == 'Inwib2c_Gestion_Compte_Client_Reclamation' && isHv) {
                        caseNew.SLA__c = '6H';
                        caseNew.OLA__c = 'NA';
                    } else if (caseNew.Inwib2c_Cat_gorie__c == 'Inwib2c_Assistance_service _Reclamation' && isHv) {
                        caseNew.SLA__c = '6H';
                        caseNew.OLA__c = 'NA';
                    } else {
                        caseNew.SLA__c = '72H';
                        caseNew.OLA__c = '24H';
                    }
                } else if (caseNew.type != 'Inwib2c_Requete_interne') {
                    caseNew.SLA__c = '72H';
                    caseNew.OLA__c = '24H';
                }
            } else if (caseNew.type != 'Inwib2c_Requete_interne') {
                caseNew.SLA__c = '72H';
                caseNew.OLA__c = '24H';
            }
        } else if (caseNew.type != 'Inwib2c_Requete_interne') {
            caseNew.SLA__c = '72H';
            caseNew.OLA__c = '24H';
        }
    }
}