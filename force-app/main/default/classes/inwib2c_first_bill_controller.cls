/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-07-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class inwib2c_first_bill_controller{
    public List<Map<String, Object>> data{ get; set; }

    public Integer dataSize { get; set; }

    public String keys{ get; set; }
    public inwib2c_first_bill_controller(){

        Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(Apexpages.currentPage().getParameters().get('input'));
        System.debug('deserialized');
        System.debug(deserialized);
        List<Map<String, Object>> dataOffer = new List<Map<String, Object>>();
        for (Object instance : (List<Object>)deserialized.get('data'))
            dataOffer.add((Map<String, Object>)instance);
        ///
        System.debug('dataOffer');
        System.debug(dataOffer);
        System.debug('dataOffer[0]');
        System.debug(dataOffer[0]);
        data = dataOffer;
        dataSize = data.size();
        for (String item : dataOffer[0].keySet()){
            keys = keys + item;
        }
        System.debug('keys');
        System.debug(keys);
        
    }

}