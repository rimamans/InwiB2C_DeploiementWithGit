public with sharing class inwiB2C_FideliteDocumentController {
    public String nom {get;set;}
    public String prenom {get;set;}
    public String cardid {get;set;}
    public String datenaissance {get;set;}
    public String adresse {get;set;}

    public inwiB2C_FideliteDocumentController() {

        nom= Apexpages.currentPage().getParameters().get('nom');
        prenom= Apexpages.currentPage().getParameters().get('prenom');
        cardid= Apexpages.currentPage().getParameters().get('cardid');
        datenaissance= Apexpages.currentPage().getParameters().get('datenaissance');
        adresse= Apexpages.currentPage().getParameters().get('adresse');

    }
}