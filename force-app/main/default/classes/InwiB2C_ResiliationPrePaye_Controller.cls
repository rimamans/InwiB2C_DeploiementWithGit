public with sharing class InwiB2C_ResiliationPrePaye_Controller {
    public String lastname {get;set;}
    public String firstname {get;set;}
    public String typeidentite {get;set;}
    public String numPieceIdentite {get;set;}
    public String numligne {get;set;}
    public String offre {get;set;}
    public String email {get;set;}
    public String numcontact {get;set;}
    public String datedesignature{get;set;}

    public InwiB2C_ResiliationPrePaye_Controller() {
        lastname=Apexpages.currentPage().getParameters().get('lastname');
        firstname= Apexpages.currentPage().getParameters().get('firstname');
        numPieceIdentite= Apexpages.currentPage().getParameters().get('numPieceIdentite');
        numligne=Apexpages.currentPage().getParameters().get('numligne');
        typeidentite=Apexpages.currentPage().getParameters().get('typeidentite');
        offre = Apexpages.currentPage().getParameters().get('offre');
        email = Apexpages.currentPage().getParameters().get('email');
        numcontact = Apexpages.currentPage().getParameters().get('numcontact'); 
        datedesignature = Apexpages.currentPage().getParameters().get('datedesignature');

    }
}