import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwib2c_RendezVousVula.html';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Inwib2c_RendezVousVula extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {




    // Variable pour stocker la date minimum
    __minDate;
    __maxDate ; 
    @track flagValider = false;
    @track disabled = false ;
    __holidays = [] ; 
    _actionUtilClass ; 
    _ns = getNamespaceDotNotation();
    
    @api
  get holidays(){
    return this.__holidays 
  }
  set holidays(value){
    this.__holidays=value;
  }

  @api
  get rootitemid() {
    return this.__rootitemid;
  }
  set rootitemid(value) {
    this.__rootitemid = value;
  }
//Y_MH Begin Ajout 20 min pour minDate
  connectedCallback() {
    const now = new Date(); // Date actuelle
    now.setMinutes(now.getMinutes() + 20); // Ajoute 20 minutes
    now.setSeconds(0, 0);
    now.setDate(now.getDate() + 2); // J+1

    // Vérifier si l'heure dépasse 16:30
    if (now.getHours() > 16 || (now.getHours() === 16 && now.getMinutes() > 30)) {
        now.setDate(now.getDate() + 1); // Passer au jour suivant (J+2)
        now.setHours(8, 0, 0); // Fixer à 08:00
    }

    // Définition de maxDate = J+10 à 16:30
    const maxDate = new Date(now);
    maxDate.setDate(now.getDate() + 9); // J+10 par rapport à minDate
    maxDate.setHours(16, 30, 0); // Fixer à 16:30
    maxDate.setSeconds(0, 0);

    console.log("Holidays ConnectedCallBack :", JSON.stringify(this.__holidays));


    let holidayTMP = [];
        for (let i = 0; i < this.__holidays.length; i++) {
          const dateTMP=new Date(this.__holidays[i]);
          holidayTMP.push(dateTMP.toLocaleDateString('GMT', {
            year: 'numeric', month: 'numeric', day: 'numeric'
          }).replace(/ /g, '-'));
        }

    // Récupérer la date minimale actuelle au format "YYYY-MM-DD" pour la comparaison
    const nowFormatted = now.toLocaleDateString('GMT', {year: 'numeric', month: 'numeric', day: 'numeric'}).replace(/ /g, '-');
  
    console.log('nowFormatted',nowFormatted) ;
    console.log('holidayTMP',holidayTMP) ; 
    console.log("ISholidaystempCallBack :",holidayTMP.includes(nowFormatted)); 


    // Si mindate correspond à un jour férié, l'ajuster en incrémentant d'un jour
    if (holidayTMP.includes(nowFormatted)) {
      now.setDate(now.getDate() + 1); 
      now.setHours(8, 0, 0);
      console.log("ISholidaystempCallBackiff :",holidayTMP.includes(nowFormatted)); 
    }

  //YMH  Vérification si samedi aprés 13 B-28460
  if (now.getDay() === 6 && now.getHours() >= 13) {
  now.setDate(now.getDate() + 1);
  now.setHours(8, 0, 0); // Remise à 8h du matin pour le jour suivant
  console.log("Samedi après 13h : ajout d'un jour");
}
//YMH 0 = Dimanche  B-28460
if (now.getDay() === 0) { 
  now.setDate(now.getDate() + 1);
  now.setHours(8, 0, 0); // Repositionne à 08:00
  console.log("Dimanche : ajout d'un jour");
}

    // Conversion en format ISO
    //Y_MH 24_04_2025 fuso maroc begin
    this.__minDate = now.toLocaleString('sv-SE', {
      timeZone: 'Africa/Casablanca', 
      hour12: false
  }).replace(' ', 'T');

      this.__maxDate = maxDate.toLocaleString('sv-SE', {
        timeZone: 'Africa/Casablanca', 
        hour12: false
    }).replace(' ', 'T');
 //Y_MH 24_04_2025 fuso maroc  end


    this._actionUtilClass = new OmniscriptActionCommonUtil();
}
//Y_MH End Ajout 20 min pour minDate



    handleRendezVous(event){
        console.log ('flagvalider' , this.flagValider) ;
        console.log ('disabled' , this.disabled)
        console.log ('mindate' , this.__minDate) ;
        console.log ('macdate' , this.__maxDate) ;


       const date = new Date(event.target.value);

        
        const dayOfWeek = date.getDay();
       
        let rendezVous=this.template.querySelector('[data-id="rendezVous"]').value;
       
        const formattedDate = date.toLocaleDateString('GMT', {year: 'numeric', month: 'numeric', day: 'numeric'}).replace(/ /g, '-');

        const hour = date.getHours(); // Récupère l'heure

        let holidayTMP = [];
        for (let i = 0; i < this.__holidays.length; i++) {
          const dateTMP=new Date(this.__holidays[i]);
          holidayTMP.push(dateTMP.toLocaleDateString('GMT', {
            year: 'numeric', month: 'numeric', day: 'numeric'
          }).replace(/ /g, '-'));
        }
        // Y_MH Begin Ajout controle par rapport a l'heure
        console.log("holidaystemp :",holidayTMP);
        console.log("formattedDate :", formattedDate);
        console.log("ISholidaystemp :",holidayTMP.includes(formattedDate));

        console.log('date apres le for', date) ;
        if (
          date < new Date(this.__minDate) || 
          Date.parse(rendezVous) > new Date(this.__maxDate) || 
          dayOfWeek === 0 || // Dimanche
          holidayTMP.includes(formattedDate) || // Jour férié
          hour < 8 || 
          (hour === 16 && date.getMinutes() > 30) || // heure entre 8H et 16H30
          hour > 16 || 
          (dayOfWeek === 6 && (hour > 13 || (hour === 13 && date.getMinutes() > 0))) // Samedi après 13h
      ) {
          this.flagValider = true;
          let errorMessage = '';
      
          if (date < new Date(this.__minDate) || Date.parse(rendezVous) > new Date(this.__maxDate)) {
            const formattedMinDate = new Date(this.__minDate).toLocaleString('fr-FR', {
                day: '2-digit',
                month: 'long',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        
            const formattedMaxDate = new Date(this.__maxDate).toLocaleString('fr-FR', {
                day: '2-digit',
                month: 'long',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        
            errorMessage = `Merci de choisir une date entre le ${formattedMinDate} et le ${formattedMaxDate}.`;
        } else if (dayOfWeek === 0 || holidayTMP.includes(formattedDate)) {
            errorMessage = "Merci de choisir un jour ouvré.";
        } else if (dayOfWeek === 6 && (hour > 13 || (hour === 13 && date.getMinutes() > 0))) {
            errorMessage = "Le samedi, veuillez choisir une heure avant 13:00.";
        } else {
            errorMessage = "Merci de choisir une heure entre 08:00 et 16:30.";
        }
        console.log('message erreur', errorMessage) ;
          this.showMessage('Erreur', errorMessage, 'error');
      } else
        this.flagValider = false;
       
        console.log ('flagvaliderelse' , this.flagValider) ;
        console.log ('disabledelse' , this.disabled)
      }
// Y_MH End Ajout controle par rapport a l'heure
      

      updateSF() {
        let input;
        console.log('UpdateOrderItem called');
    
            //input = '{"OrderItemPar":"' + this.rootitemid + '","DateInstallation": "' + this.template.querySelector('[data-id="rendezVous"]').value +'"}';



//Y_MH 24_04_2025 fuso maroc begin
    const rendezVousDate = new Date(this.template.querySelector('[data-id="rendezVous"]').value);
    
    // Convertir la date sélectionnée en GMT+1 (Africa/Casablanca)
    const rendezVousDateInGMTPlus1 = new Date(rendezVousDate.toLocaleString('en-US', {
        timeZone: 'Africa/Casablanca'
    }));
    
    // Convertir la date en ISO, sans le "Z" pour éviter l'UTC
    const rendezVousISO = rendezVousDateInGMTPlus1.toISOString().replace('Z', '');  // Retirer le "Z" pour garder GMT+1

    // Préparer les données d'entrée
    input = '{"OrderItemPar":"' + this.rootitemid + '","DateInstallation": "' + rendezVousISO + '"}';

    //Y_MH 24_04_2025 fuso maroc end
  
            const params = {
                input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'inwib2c_Inwib2c_UpdateRdvFTTHVula',
                options: '{}',
            };
            console.log('before call Updatesf', JSON.stringify(params));

            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    if (!response.error) {

                        console.log('Rdv mis a jour avec succees');
                        this.omniNextStep() ; 
           
                    }else {  // Y_MH 14_05_2025 B-28477 begin
                      this.showMessage('Erreur', 'La mise à jour a échoué. Veuillez réessayer.', 'error');
                    }// Y_MH 14_05_2025 B-28477 begin
                })
                .catch(error => {
                    console.log('Erreur critique :', error);
                    this.showMessage('Erreur', 'Erreur critique lors de la mise à jour', 'error');
                });
        
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