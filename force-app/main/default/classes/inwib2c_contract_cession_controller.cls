public with sharing class inwib2c_contract_cession_controller{
    public List<Integer> loopList{ get; set; }

    public String keys{ get; set; }

    public Map<String, Object> ipOutput{ get; set; }

    public String keysOffers{ get; set; }

    public inwib2c_contract_cession_controller(){
        loopList = new List<Integer>{ 0, 1, 2 };
        Map<String, Object> ipInput = new Map<String, Object>();
        ipInput.put('OrderId', Apexpages.currentPage().getParameters().get('orderid'));
        ipInput.put('SubId', Apexpages.currentPage().getParameters().get('subid'));

        if (!Test.isRunningTest()){
            ipOutput = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_contract_changement_titulaire', ipInput, null));
        } else{
            System.debug('Is test cession contract');
            System.debug(Apexpages.currentPage().getParameters().get('input'));
            Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(Apexpages.currentPage().getParameters().get('input'));
            List<Map<String, Object>> data = new List<Map<String, Object>>();
            for (Object instance : (List<Object>)root.get('data')){
                data.add((Map<String, Object>)instance);

            }
            root.put('data', data);
            ipOutput = root;
            System.debug(ipOutput);
        }

        for (String item : ipOutput.keySet()){
            keys = keys + item;
        }

        // Put Offer keys in string
        try{
            List<Map<String, Object>> offers = (List<Map<String, Object>>)ipOutput.get('data');
            for (String item_offer : offers[0].keySet()){
                System.debug('OFFRE EST : ' + item_offer);
                keysOffers = keysOffers + item_offer;
            }
        } catch (Exception e){


        }
    }

}