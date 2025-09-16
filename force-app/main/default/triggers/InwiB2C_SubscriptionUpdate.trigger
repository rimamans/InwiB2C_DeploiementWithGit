trigger InwiB2C_SubscriptionUpdate on Case (before insert, before update) {

    Map<Id, Case> caseOldMap = Trigger.oldMap;
    List<String> data = new List<String>();
    system.debug('start0');

    for(Case caseNew:Trigger.new){
        
            if (Trigger.isInsert){
                if (caseNew.vlocity_cmt__SubscriptionId__c != null){
                    system.debug('start');
                    vlocity_cmt__Subscription__c SubscriptionRecord= [ select vlocity_cmt__AccountId__r.InwiB2C_HV__c , InwiB2C_MEI__c,Inwib2c_Terminal__c, InwiB2C_Code_Article__c,   Inwib2c_ICC__c, Inwib2c_SegmentLigne__c from vlocity_cmt__Subscription__c where id = :caseNew.vlocity_cmt__SubscriptionId__c];
                    caseNew.Inwib2c_IMEI_terminal__c = SubscriptionRecord.InwiB2C_MEI__c;
                    caseNew.Inwib2c_Model_article__c = SubscriptionRecord.Inwib2c_Terminal__c;
                    caseNew.Inwib2c_Code_article__c = SubscriptionRecord.InwiB2C_Code_Article__c;
                    caseNew.Inwib2c_MEID_Pack_SIM__c = SubscriptionRecord.Inwib2c_ICC__c;
                    caseNew.InwiB2C_SegmentClient__c = SubscriptionRecord.Inwib2c_SegmentLigne__c;
                         if (SubscriptionRecord.vlocity_cmt__AccountId__r.InwiB2C_HV__c) {
            caseNew.HV__c = 'Oui';
            caseNew.Priority = 'High' ;
        } else {
            caseNew.HV__c = 'Non';
        }
                    system.debug('end');     
                }
               
            }
        else{
            Case oldCase = caseOldMap.get(caseNew.Id);
            if((caseNew.Status == 'InwiB2C_Annule' || caseNew.Status == 'InwiB2C_Resolu') && oldCase.Status != 'InwiB2C_Annule' && oldCase.Status != 'InwiB2C_Resolu')
            {

                if(caseNew.Inwib2c_Cat_gorie__c == 'Inwib2c_Assistance/service _HelpDesk' && ((caseNew.InwiB2C_TypeSpecialite__c == 'All' && (caseNew.InwiB2C_Detail__c == 'Coupure de fibre'||caseNew.InwiB2C_Detail__c == 'Pas de synchronisation' || caseNew.InwiB2C_Detail__c == 'Pas d\'authentification Voix /data')) || (caseNew.InwiB2C_TypeSpecialite__c == 'Data _HelpDesk _Assistance/service' && (caseNew.InwiB2C_Detail__c == 'Pas d\'authentification data'||caseNew.InwiB2C_Detail__c == 'pas de navigation internet' ))) && (caseNew.Inwib2c_la_file_d_attente__c == '' || caseNew.Inwib2c_la_file_d_attente__c == 'Support Technique ADSL B2C N1'|| caseNew.Inwib2c_la_file_d_attente__c == 'Support Technique FTTH B2C N1'))
                {
                       data.add((String) caseNew.Id);
                }
                
            }
            system.debug('start2');

            
            system.debug('start21');

        if (caseNew.vlocity_cmt__SubscriptionId__c != oldCase.vlocity_cmt__SubscriptionId__c && caseNew.vlocity_cmt__SubscriptionId__c != null){
                vlocity_cmt__Subscription__c SubscriptionRecord= [ select vlocity_cmt__AccountId__r.InwiB2C_HV__c , InwiB2C_MEI__c,Inwib2c_Terminal__c,    Inwib2c_ICC__c, InwiB2C_Code_Article__c, Inwib2c_SegmentLigne__c from vlocity_cmt__Subscription__c where id = :caseNew.vlocity_cmt__SubscriptionId__c];
                caseNew.Inwib2c_IMEI_terminal__c = SubscriptionRecord.InwiB2C_MEI__c;
                caseNew.Inwib2c_Model_article__c = SubscriptionRecord.Inwib2c_Terminal__c;
                caseNew.Inwib2c_Code_article__c = SubscriptionRecord.InwiB2C_Code_Article__c;
                caseNew.Inwib2c_MEID_Pack_SIM__c = SubscriptionRecord.Inwib2c_ICC__c;
                caseNew.InwiB2C_SegmentClient__c = SubscriptionRecord.Inwib2c_SegmentLigne__c;
                if (SubscriptionRecord.vlocity_cmt__AccountId__r.InwiB2C_HV__c) {
                    caseNew.HV__c = 'Oui';
                } else {
                    caseNew.HV__c = 'Non';
                }
            }
        }
        
    }
    if (!data.isEmpty()){
         InwiB2C_callHandleSaveTickets.CallVIP(data);
    }
}