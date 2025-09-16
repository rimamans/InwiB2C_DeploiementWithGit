/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class inwiB2C_Controller_ModificationMdn {
/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/


    public List<Map<String, Object>> data{ get; set; }
    public String keys{ get; set; }

public inwiB2C_Controller_ModificationMdn() {
        // date dayString = date.today();

Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(Apexpages.currentPage().getParameters().get('input'));
system.debug('root'+root);

 List<Map<String, Object>> dataOffer = new List<Map<String, Object>>();
 for (Object instance : (List<Object>)root.get('data'))
     dataOffer.add((Map<String, Object>)instance);
 
 System.debug('dataOffer');
 System.debug(dataOffer);
 System.debug('dataOffer[0]');  
 System.debug(dataOffer[0]);
 data = dataOffer;

 for (String item : dataOffer[0].keySet()){
    keys = keys + item;
}
System.debug('keys');
System.debug(keys);

             
  }

}