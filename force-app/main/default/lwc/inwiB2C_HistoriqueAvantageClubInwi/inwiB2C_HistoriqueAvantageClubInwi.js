import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_HistoriqueAvantageClubInwi.html';

export default class inwiB2C_HistoriqueAvantageClubInwi extends OmniscriptBaseMixin(LightningElement) {
  
    @api records;
    __profil;
    @api
   
    get profil(){
        return this.__profil;
    }



    set profil(value){
        this.__profil= value;
    }

    @track columns =[

        {fieldName: 'id', label: 'Id Transaction', hideDefaultActions: true , initialWidth: 200, editable: false},
        {fieldName: 'offerName', label: 'Avantage', hideDefaultActions: true , editable: false},
        {fieldName: 'TypeOffre', label: 'Type', hideDefaultActions: true,initialWidth: 100, editable: false,},
        {fieldName: 'createdDate', label: 'Date souscription', hideDefaultActions: true,initialWidth: 200, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }, editable: false},
       // {fieldName: 'Code', label: 'Code promo', hideDefaultActions: true , editable: false},
         ];
         
         @track columnsfalse =[

            {fieldName: 'id', label: 'Id Transaction', hideDefaultActions: true , initialWidth: 200, editable: false},
            {fieldName: 'offerName', label: 'Avantage', hideDefaultActions: true , editable: false},
            {fieldName: 'type', label: 'Type', hideDefaultActions: true,initialWidth: 100, type :"number" , editable: false, },
            {fieldName: 'createdDate', label: 'Date souscription', hideDefaultActions: true,initialWidth: 200, type: "date", typeAttributes:{
                year: "numeric",
                month: "2-digit",
                day: "2-digit"
            }, editable: false},
             ];

get loyaltyTransaction () {

       
    if (this.omniJsonData && this.omniJsonData.result && this.omniJsonData.result.loyaltyTransaction){
        return this.omniJsonData.result.loyaltyTransaction;
    }
        else return [];
    }



    render() {
        console.log("dd");
        console.log(this.profil);

        return template;
    }


}