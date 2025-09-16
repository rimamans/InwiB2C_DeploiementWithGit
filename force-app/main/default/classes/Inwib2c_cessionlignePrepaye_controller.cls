public with sharing class Inwib2c_cessionlignePrepaye_controller {
    public String cessionDate  { get; set; }
    public String clientAccountNumber { get; set; }
    public String lineNumber { get; set; }
    public String subscribedOffer { get; set; }
    public String serviceContractNumber { get; set; }
    public String cedantFullName { get; set; }
    public String cedantIdType { get; set; }
    public String cedantIdNumber { get; set; }
    public String cedantAddress { get; set; }
    public String cedantPhoneNumber { get; set; }
    public String cessionnaireFullName { get; set; }
    public String cessionnaireIdType { get; set; }
    public String cessionnaireIdNumber { get; set; }
    public String cessionnaireAddress { get; set; }

    public Inwib2c_cessionlignePrepaye_controller() {
        cessionDate  = ApexPages.currentPage().getParameters().get('cessionDate');
        clientAccountNumber = ApexPages.currentPage().getParameters().get('clientAccountNumber');
        lineNumber = ApexPages.currentPage().getParameters().get('lineNumber');
        subscribedOffer = ApexPages.currentPage().getParameters().get('subscribedOffer');
        serviceContractNumber = ApexPages.currentPage().getParameters().get('serviceContractNumber');
        cedantFullName = ApexPages.currentPage().getParameters().get('cedantFullName');
        cedantIdType = ApexPages.currentPage().getParameters().get('cedantIdType');
        cedantIdNumber = ApexPages.currentPage().getParameters().get('cedantIdNumber');
        cedantAddress = ApexPages.currentPage().getParameters().get('cedantAddress');
        cedantPhoneNumber = ApexPages.currentPage().getParameters().get('cedantPhoneNumber');
        cessionnaireFullName = ApexPages.currentPage().getParameters().get('cessionnaireFullName');
        cessionnaireIdType = ApexPages.currentPage().getParameters().get('cessionnaireIdType');
        cessionnaireIdNumber = ApexPages.currentPage().getParameters().get('cessionnaireIdNumber');
        cessionnaireAddress = ApexPages.currentPage().getParameters().get('cessionnaireAddress');
    }
}