import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwib2c_RendezVousVulaFTTH.html';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class inwib2c_RendezVousVulaFTTH extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    // Variable pour stocker la date minimum
    __minDate;
    __maxDate ; 
    @track flagValider = false;
    @track disabled = false ;
    

    connectedCallback() {
        const today = new Date();

        // minDate = aujourd'hui + 1 jour
        const tomorrow = new Date(today);
        tomorrow.setDate(today.getDate() + 1);
        this.__minDate = tomorrow.toISOString().split('T')[0]; // Format YYYY-MM-DD

        // maxDate = aujourd'hui + 10 jours
        const tenDaysLater = new Date(today);
        tenDaysLater.setDate(today.getDate() + 10);
        this.__maxDate = tenDaysLater.toISOString().split('T')[0]; // Format YYYY-MM-DD 
    }




    handleRendezVous(event){
        const date = new Date(event.target.value);
        const dayOfWeek = date.getDay();
        let rendezVous=this.template.querySelector('[data-id="rendezVous"]').value;
        const formattedDate = date.toLocaleDateString('GMT', {year: 'numeric', month: 'numeric', day: 'numeric'}).replace(/ /g, '-');
        let holidayTMP = [];
        for (let i = 0; i < this.__holidays.length; i++) {
          const dateTMP=new Date(this.__holidays[i]);
          holidayTMP.push(dateTMP.toLocaleDateString('GMT', {
            year: 'numeric', month: 'numeric', day: 'numeric'
          }).replace(/ /g, '-'));
        }
        if(date <= new Date(this.__minDate) || Date.parse(rendezVous) > new Date(this.__maxDate) || dayOfWeek === 6 || dayOfWeek === 0 || holidayTMP.includes(formattedDate) ){
          this.disabled = false ;
            this.flagValider = true;
            this.showMessage('Erreur', 'Merci de choisir un jour ouvré', 'error');
          }
        else
          this.flagValider = false;
        this.disabled = true ; 
      }
      valider(){

        // this.omniNextStep();
      }

      showMessage(title, message, variant) {
        const evt = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(evt);
      }

      render(){
        return template;
    }

}