public with sharing class inwiB2C_DuplicataDealerController {

    public String reengag { get; set; }
    public String portedProfil { get; set; }
    public String portedOfferType { get; set; }
    public String portedMsisdn { get; set; }
    public String portedLineType { get; set; }
    public String portedIccId{ get; set; }
    public String portedEngagement { get; set; }
    public String options { get; set; }
    public String lineType { get; set; }
    public String fi { get; set; }
    public String equipmentType4 { get; set; }
    public String fag { get; set; }
    public String equipmentType3 { get; set; }
    public String equipmentType2 { get; set; }
    public String equipmentType { get; set; }
    public String equipmentSerialNumber4 { get; set; }
    public String equipmentSerialNumber3 { get; set; }
    public String equipmentSerialNumber2 { get; set; }
    public String equipmentSerialNumber { get; set; }
    public String equipmentPrice4 { get; set; }
    public String equipmentPrice3 { get; set; }
    public String equipmentPrice2 { get; set; }
    public String equipmentPrice { get; set; }
    public String equipmentLabel4 { get; set; }
    public String equipmentLabel3 { get; set; }
    public String equipmentLabel2 { get; set; }
    public String equipmentLabel { get; set; }
    public String equipmentEngagement4 { get; set; }
    public String equipmentEngagement3 { get; set; }
    public String equipmentEngagement2 { get; set; }
    public String equipmentEngagement { get; set; }
    public String equipmentDisposition4 { get; set; }
    public String equipmentDisposition3 { get; set; }
    public String equipmentDisposition2 { get; set; }
    public String equipmentDisposition { get; set; }
    public String caution { get; set; }
    public String asf { get; set; }
    public String suscriptionPrice { get; set; }
    public String isSAV { get; set; }
    public String isPre { get; set; }
    public String isPost { get; set; }
    public String isPorta { get; set; }
    public String isMig { get; set; }
    public String globalEquipmentPrice { get; set; }
    public String fms { get; set; }
    public String fmd { get; set; }
    public String contractType { get; set; }
    public String agreementDate { get; set; }
    public String postalCode { get; set; }
    public String adress { get; set; }
    public String simPrice { get; set; }
    public String paymentReference { get; set; }
    public String paymentMode { get; set; }
    public String identificationType { get; set; }
    public String identificationNumber { get; set; }
    public String contractNumber { get; set; }
    public String profil { get; set; }
    public String posName { get; set; }
    public String offerType { get; set; }
    public String msisdn { get; set; }
    public String lastName { get; set; }
    public String iccId { get; set; }
    public String firstName { get; set; }
    public String engagement { get; set; }
    public String email { get; set; }
    public String custumerFullName { get; set; }
    public String contactNumber { get; set; }
    public String city { get; set; }
    public String birthDay { get; set; }
    public String billingAccountNumber { get; set; }

    public String subscriptionId { get; set; }
    public List<Integer> loopList{ get; set; }
    public String keys { get; set; }

    String procedureName = 'Inwi_InwiB2C_GenerateDuplicataDealer';
    Map<String, Object> ipInput = new Map<String, Object>();
    public Map<String, Object> ipOutput { get; set; }
    Map<String, Object> ipOptions = new Map<String, Object>();


    public inwiB2C_DuplicataDealerController() {
        subscriptionId = Apexpages.currentPage().getParameters().get('subscriptionId');
        ipInput.put('subscriptionId', subscriptionId);
        loopList = new List<Integer>{ 0 };
        ipOutput = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions));
        for (String items: ipOutput.keySet()) {
            keys += items + '-';
        }
    }
}