/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class inwib2c_RecuPaiementPostpaid{
    public Map<String, Object> output{ get; set; }

    public String keys{ get; set; }

    public String code_transaction{ get; set; }

    public String date_facture{ get; set; }

    public String mode_paiement{ get; set; }

    public List<Map<String, Object>> lignes{ get; set; }

    public Decimal total_ttc{ get; set; }
    public List<Map<String, Object>> datafms{ get; set; }

    public inwib2c_RecuPaiementPostpaid(){
        Map<String, Object> input = new Map<String, Object>();
        code_transaction = '';
        // Call vip
        input.put('orderid', Apexpages.currentPage().getParameters().get('orderid'));
        if (!Test.isRunningTest()){
            output = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_recu_paiment_postpaid', input, null));
            System.debug(output);
        } else{
            System.debug(Apexpages.currentPage().getParameters().get('input'));
            Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(Apexpages.currentPage().getParameters().get('input'));
            List<Map<String, Object>> data = new List<Map<String, Object>>();
            for (Object instance : (List<Object>)root.get('datafms')){
                data.add((Map<String, Object>)instance);

            }

            
            root.put('datafms', data);
            output = root;
            System.debug(output);
        }
        // Get response keys
        for (String item : output.keySet()){
            keys = keys + item + '-';
        }
        System.debug(keys);

        Boolean displayFMD = (Boolean) output.get('displayFMD');
           
        System.debug(displayFMD);
        // get lignes & keys
        List<Map<String, Object>> temp = new List<Map<String, Object>>();
        Decimal prix = 0;
        List<Object> entriesArray = (List<Object>)output.get('datafms');
        for (Object inidividualEntries : entriesArray){

            Map<String, Object> ligne_item = (Map<String, Object>)inidividualEntries;


            Map<String, Object> ind_fms = new Map<String, Object>();
            Map<String, Object> ind_fmd = new Map<String, Object>();


            mode_paiement = (String) ligne_item.get('mode_paiement');
            date_facture = (String) ligne_item.get('date');
            prix = prix + (Decimal) ligne_item.get('montant');

            // FMS
            String ligne_key = '';

            String reference = ligne_item.containsKey('reference') ? (String) ligne_item.get('reference') : '';
            if (code_transaction == ''){
                code_transaction = reference;
            }

            if (reference != ''){
                ind_fms.put('ligne_reference', 'FMS' + reference);
            } else{
                ind_fms.put('ligne_reference', '');
            }
            ind_fms.put('ligne_type', 'FMS');
            ind_fms.put('ligne_montant', (Decimal) ligne_item.get('montant'));
            ind_fms.put('timbre', ligne_item.get('timbre'));
            ind_fms.put('montantrestant', ligne_item.get('montantrestant'));

            for (String item : ind_fms.keySet()){
                ligne_key = ligne_key + item;
            }
            ind_fms.put('keys', ligne_key);
            if ((Decimal) ligne_item.get('montant') > 0){
                temp.add(ind_fms);
            }


            // FMD
            if (displayFMD){

                String ligne_key_fmd = '';
                prix = prix + (Decimal) ligne_item.get('montant_fmd');

                String reference_fmd = ligne_item.containsKey('reference_fmd') ? (String) ligne_item.get('reference_fmd') : '';

                if (code_transaction == ''){
                    code_transaction = reference_fmd;

                }
                if (reference_fmd != ''){
                    ind_fmd.put('ligne_reference', 'FMD' + reference_fmd);
                    ind_fmd.put('ligne_montant', (Decimal) ligne_item.get('montant_fmd'));
                    ind_fmd.put('ligne_type', 'FMD');
                    ind_fmd.put('timbre', ligne_item.get('timbre'));
                    ind_fmd.put('montantrestant', ligne_item.get('montantrestant'));
                } else{
                ind_fmd.put('ligne_reference', '');
                ind_fmd.put('ligne_montant','');
                ind_fmd.put('ligne_type', '');
                ind_fmd.put('timbre', '');
                ind_fmd.put('montantrestant', '');
                }

               

                for (String item : ind_fmd.keySet()){
                    ligne_key_fmd = ligne_key_fmd + item;
                }
                ind_fmd.put('keys', ligne_key_fmd);

                temp.add(ind_fmd);
                // System.debug('ind_fmd');
                // for (String item : ind_fmd.keySet()){
                //     System.debug(item + ' : ' + ind_fmd.get(item));
                // }

            }


        }
        lignes = temp;
        total_ttc = prix;

        System.debug(code_transaction);
        System.debug(date_facture);
        System.debug(lignes);
    }

}