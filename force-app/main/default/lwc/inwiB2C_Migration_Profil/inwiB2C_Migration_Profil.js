import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_Migration_Profil.html';

export default class inwiB2C_Migration_Profil extends OmniscriptBaseMixin(LightningElement) {

    @api records;

    @track columns =[

       
        {fieldName: 'M_DATE', label: 'Date de migration', hideDefaultActions: true, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }, editable: false},
        {fieldName: 'NEWPROFIL', label: 'Nouveau profil', hideDefaultActions: true , editable: false},
        {fieldName: 'OLDPROFIL', label: 'Ancien profil', hideDefaultActions: true , editable: false},
        {fieldName: 'M_CANAL', label: 'Canal', hideDefaultActions: true , editable: false}

         ];

  

get properties () {
console.log('propreties')
       
  return this.records.properties;
  
    }



    render() {

        //console.log(this.omniJsonData);
        return template;
    }


}