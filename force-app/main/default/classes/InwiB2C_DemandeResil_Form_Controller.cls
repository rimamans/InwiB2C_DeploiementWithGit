public with sharing class InwiB2C_DemandeResil_Form_Controller {
    public String lastname {get;set;}
    public String firstname {get;set;}
    public String raisonsociale {get;set;}
    public String numligne {get;set;}
    public String typeidentite {get;set;}
    public String offre {get;set;}
    public String numcontact {get;set;}
    public String datedesignature{get;set;}




public InwiB2C_DemandeResil_Form_Controller() {

    lastname=Apexpages.currentPage().getParameters().get('lastname');
    firstname= Apexpages.currentPage().getParameters().get('firstname');
    raisonsociale= Apexpages.currentPage().getParameters().get('raisonsociale');
    numligne=Apexpages.currentPage().getParameters().get('numligne');
    typeidentite=Apexpages.currentPage().getParameters().get('typeidentite');
    offre = Apexpages.currentPage().getParameters().get('offre');
    numcontact = Apexpages.currentPage().getParameters().get('numcontact'); 
    datedesignature = Apexpages.currentPage().getParameters().get('datedesignature');
  
  }

}