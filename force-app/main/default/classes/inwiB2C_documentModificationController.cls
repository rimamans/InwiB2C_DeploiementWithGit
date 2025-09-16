/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-11-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class inwiB2C_documentModificationController {
    public String OrderId {get;set;}
    public String oldmac {get;set;}
    public String oldmodel {get;set;}
  
    Map <String, Object> ipInput = new Map <String, Object> ();
    public  Map <String, Object> ipOutput {get;set;}
    Map <String, Object> ipOptions = new Map <String, Object> ();
    public String keys {get; set;}
    public inwiB2C_documentModificationController() {
// Get params
    OrderId= Apexpages.currentPage().getParameters().get('orderId');
    oldmac= Apexpages.currentPage().getParameters().get('oldmac');
    oldmodel= Apexpages.currentPage().getParameters().get('oldmodel');


    System.debug('ID order IS :'+ OrderId);

// Call VPI
    System.debug(' ipOutput ddd :');


    ipInput.put('OrderId', OrderId);
    ipInput.put('oldmac', oldmac);
    ipInput.put('oldmodel', oldmodel);
    ipOutput =  (Map <String, Object>) (vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_inwiB2C_GetInfoDocMod', ipInput, ipOptions));
    System.debug(' ipInput IS :'+ ipInput);
    System.debug(' ipOutput IS :'+ ipOutput);

    for (String item : ipOutput.keySet()) {
        System.debug(' keys IS :'+ keys);
        keys = keys + item;
    }
    }
}