public with sharing class InwiB2C_ModificationMdn_Controller {
        public String name {get;set;}
    	public String cin {get;set;}
        public String mdn {get; set;}
        public String offre {get;set;}
        public String poscode {get;set;}
        public String numcomm {get;set;}
        public String oldoffer {get;set;}
        public String oldmdn {get;set;}
        public String newmdn {get;set;}
    	public String datedefacturation{get;set;}
        public String typeModification{get;set;}
        public String detailModification{get;set;}
        public String fraischgtmdn{get;set;}
        public String categoriemdn{get;set;}
    

    
    public InwiB2C_ModificationMdn_Controller() {
            date dayString = date.today();
            datedefacturation = dayString.format();
        	name=Apexpages.currentPage().getParameters().get('name');
            cin= Apexpages.currentPage().getParameters().get('cin');
            mdn= Apexpages.currentPage().getParameters().get('mdn');
            offre=Apexpages.currentPage().getParameters().get('offre');
            poscode=Apexpages.currentPage().getParameters().get('poscode');
            numcomm = Apexpages.currentPage().getParameters().get('numcomm');
            oldoffer = Apexpages.currentPage().getParameters().get('oldoffer'); 
            oldmdn = Apexpages.currentPage().getParameters().get('oldmdn'); 
            newmdn = Apexpages.currentPage().getParameters().get('newmdn'); 
            typeModification = Apexpages.currentPage().getParameters().get('typeModification');
            detailModification = Apexpages.currentPage().getParameters().get('detailModification');
            fraischgtmdn = Apexpages.currentPage().getParameters().get('fraischgtmdn');
            categoriemdn = Apexpages.currentPage().getParameters().get('categoriemdn');



       
      }

    }