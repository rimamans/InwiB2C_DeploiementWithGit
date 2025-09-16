import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_DisplayOffresSell.html';

export default class InwiB2C_DisplayOffresSell extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    constructor() {
        super();
        var offresgeneric = [];
        var offreseligible = [];
        var offresciblee = [];
        
        var themdn;
        var agent;
        var idofthecase;
        var idaccountcase;
        var profilsubscription;
        
        
        var isOffresGeneric=true;
        var isOffresEligible=true;
        var isOffresCiblee=true;
        // Y_MH begin
        var offrecibletodisplay = 0 ;
    }
    renderedCallback() {
    }
    
    disableAlreadyProposed = true;
    disableMotif = false;
    disableRetourClient = false;

    @api offresgeneric; 
    @api offreseligible; 
    @api offresciblee; 
    @api themdn;
    @api agent;
    @api idofthecase;
    @api idaccountcase;
    @api profilsubscription;
    
    get alreadyProposed() {
        return [
            { label: 'Oui', value: 'oui' },
            { label: 'Non', value: 'non' },
        ];
    }

    recordsToAd = {
        "inputCible": [],
        "inputEligible": [],
        "inputGeneric": []
      };
    valueRetourClient = 'inProgress';
    valueMotif = 'inProgress';
/*
    get MotifOptions() {
        return [
            { label: 'Engagé avec un confrère', value: 'Engage avec un confrere' },
            { label: 'Faible couverture réseau Inwi', value: 'Faible couverture reseau Inwi' },
            { label: 'N’achète jamais par téléphone', value: 'N achete jamais par telephone' },
            { label: 'Non intéressé par le produit', value: 'Non interesse par le produit' },
            { label: 'Trop cher', value: 'Trop cher' },
            { label: 'Prise de RDV pour rappel ultérieur', value: 'Prise de RDV pour rappel ulterieur' },
            { label: 'Souhaite réfléchir', value: 'Souhaite reflechir' },
            { label: 'Hors cible', value: 'Hors cible' },
            { label: 'Réclamation en cours', value: 'Reclamation en cours' },

        ];
    }
*/
    get MotifRefusee() {
        return [
            { label: 'Engagé avec un confrère', value: 'Engage avec un confrere' },
            { label: 'Faible couverture réseau Inwi', value: 'Faible couverture reseau Inwi' },
            { label: 'N’achète jamais par téléphone', value: 'N achete jamais par telephone' },
            { label: 'Non intéressé par le produit', value: 'Non interesse par le produit' },
            { label: 'Souhaite réfléchir', value: 'Souhaite reflechir' },
            { label: 'Trop cher', value: 'Trop cher' },
            { label: 'Prise de RDV pour rappel ultérieur', value: 'Prise de RDV pour rappel ulterieur' },
        ];
    }
// (Y-MH begin enlever le motif liéé a retour client autres )
    /*get MotifAutres() {
        return [
         //   { label: 'Souhaite réfléchir', value: 'Souhaite reflechir' },
            { label: 'Hors cible', value: 'Hors cible' },
            { label: 'Réclamation en cours', value: 'Reclamation en cours' },
        ];
    }*/   // (Y-MH enlever le motif liéé a retour client autres )
   
    get RetourClient() {
        return [
            { label: 'Acceptée', value: 'Acceptee' },
            { label: 'Refusée', value: 'Refusee' },
            //{ label: 'Autres', value: 'Autres' },   (Y-MH elever  retour client autres )
        ];
    }

    get offresGenericToShow() {
        var disableAll = false;
       /* for (var offre of this.offresgeneric) {
         if(offre.RetourClient == 'Acceptee' || offre.RetourClient == 'Refusee' ){
             disableAll = true;
             break;
         }
        }*/
        var  offreTemp = [];
         try {
             for (var offre of this.offresgeneric) {
           //     console.log('offresGenericToShow : this.offresGenericToShow: ');
           //     console.dir(this.offresgeneric);

                 let val = {
                    "Id":offre.Id,
                    "idMotifElementGeneric":'genericmotif'+offre.Id,
                    "idRetourElementGeneric":'genericretour'+offre.Id,
                    "offreid":offre.Id,
                    "typeoffre":'generic',
                    "MDN":offre.MDN,
                    "disableRetourClient" : disableAll,
                    "RetourClient":offre.RetourClient,
                    "DateDebut" : offre.DateDebut, 
                    "DateFin" : offre.DateFin, 
                    "Priorite" : offre.Priorite, 
                    "date" : offre.dateModification, 
                    "IdCampagne": offre.IdCampagne,

                    "Argumentaire" : offre.Argumentaire,    
                    "Description" : offre.Description,    
                    "points" : offre.points,    
                    "dateModification":offre.dateModification,
                    "Motif":offre.Motif,
                    "isAlreadyProposed": ((offre.RetourClient != undefined  )  ? 'oui' : 'non'),            
                    "isDisabled": ((offre.Motif == undefined ||disableAll == true|| offre.RetourClient == undefined || offre.RetourClient == 'Acceptee') ? true : false),            
                    "MotifOptionsGeneric": //(offre.RetourClient == 'Autres') ? 
                                          //  this.MotifAutres :  MotifAutre    
                                          // (Y-MH enlever le motif liéé a retour client autres )
                                            ((offre.RetourClient == 'Refusee') ? 
                                                this.MotifRefusee : 
                                                null)       
                   };
             
                 offreTemp.push(val); 
                }
                console.log('offresGenericToShow : offreTemp: ');
                console.dir(offreTemp);
 
         } catch (error) {
             console.error('error isAlreadyProposed', error.message);  
         }
         return offreTemp;
     }


    get offresEligibleToShow() {
    
        var  offreTemp = [];
        var disableAll = false;
      /*  for (var offre of this.offreseligible) {
         if(offre.RetourClient == 'Acceptee' || offre.RetourClient == 'Refusee' ){
             disableAll = true;
             break;
         }
        }*/
         try {


             for (var offre of this.offreseligible) {
            //    console.log('offresEligibleToShow : this.offreseligible: ');
             //   console.dir(this.offreseligible);

                 let val = {
                    "Id":offre.Id,
                    "idMotifElementEligible":'eligiblemotif'+offre.Id,
                    "idRetourElementEligible":'eligibleretour'+offre.Id,
                    "offreid":offre.Id,
                    "typeoffre":'eligible',
                    "MDN":offre.MDN,
                    "disableRetourClient" : disableAll,
                    "DateDebut" : offre.DateDebut, 
                    "DateFin" : offre.DateFin, 
                    "Priorite" : offre.Priorite, 
                    "date" : offre.dateModification, 

                    "IdCampagne": offre.IdCampagne,

                    "Argumentaire" : offre.Argumentaire,    
                    "Description" : offre.Description,   
                    "points" : offre.points,    
                    "dateModification":offre.dateModification,      
                    "RetourClient":offre.RetourClient,
                    "Motif":offre.Motif,
                    "isAlreadyProposed": ((offre.RetourClient != undefined  )  ? 'oui' : 'non'),            
                    "isDisabled": ((offre.Motif == undefined ||disableAll == true|| offre.RetourClient == undefined|| offre.RetourClient == 'Acceptee') ? true : false),            
                    "MotifOptionsEligible": //(offre.RetourClient == 'Autres') ? 
                                            //this.MotifAutres :   (Y-MH enlever le motif liéé a retour client autres )
                                            ((offre.RetourClient == 'Refusee') ? 
                                                this.MotifRefusee : 
                                                null)          
                   };
             
                 offreTemp.push(val); 
                }
             //   console.log('offresEligibleToShow : offreTemp: ');
            //    console.dir(offreTemp);
 
         } catch (error) {
             console.error('error isAlreadyProposed', error.message);  
         }
 
         return offreTemp;
     }


    get offresCibleeToShow() {
    
       var  offreTemp = [];
// Y.Mh begin  Exploitation du TAG éligibilité CRM
       //var disableAll = false;
       /* for (var offre of this.offresciblee) {
       if(offre.RetourClient == 'Acceptee' || offre.RetourClient == 'Refusee' ){
          disableAll = true;
           break;
       }
       }*/
   
      const currentDate = new Date();
      console.log ("currentdate", currentDate) ;
      console.log ("offre", this.offresciblee) ;

       for (var offre of [...this.offresciblee])  {
        console.log ("modificationDate1", offre.dateModification) ;
        var hideoffre = false ; 
        var disableAll = false;
        if (offre.RetourClient === 'Acceptee') {
            disableAll = true;
            console.log ("offreRetourClientAccept", offre.RetourClient) ;
            console.log ("hideoffreaccepté",hideoffre) ;
            
        } else if (offre.RetourClient === 'Refusee') {
            
            let modificationDate =new Date(offre.dateModification.replace(" ", "T"))  ; 
            console.log ("modificationDate22", offre.dateModification) ;
            console.log ("offreRetourClientRefuse", offre.RetourClient) ;
            
            // Calculer la différence en jours
            let diffInDays =Math.floor((currentDate - modificationDate) / (1000 * 60 * 60 * 24)) ;
            console.log ("diffInDays", diffInDays) ;
    
            if (diffInDays <= 90) {
                console.log ("diffInDays90", diffInDays) ;
                // Si la différence est inférieure ou égale à 90 jours, masquer l'offre
                hideoffre = true;
                console.log ("hideoffrerefusé",hideoffre) ;
            }
        }
        let val = {
            "Id":offre.Id,
            "idMotifElementCible":'ciblemotif'+offre.Id,
            "idRetourElementCible":'cibleretour'+offre.Id,
            "typeoffre":'cible',
            "offreid":offre.Id,
            "disableRetourClient" : disableAll,
            "MDN":offre.MDN,
            "Argumentaire" : offre.Argumentaire,    
            "Description" : offre.Description,   
            "DateDebut" : offre.DateDebut, 
            "DateFin" : offre.DateFin, 
            "Priorite" : offre.Priorite, 
            "points" : offre.points, 
            "date" : offre.dateModification, 
            "IdCampagne": offre.IdCampagne,
            "hideoffre":hideoffre ,
            "dateModification":offre.dateModification,           
            "mdn" : offre.MDN,    
            "RetourClient":offre.RetourClient,
            "Motif":offre.Motif,
            "isAlreadyProposed": ((offre.RetourClient != undefined  )  ? 'oui' : 'non'),            
            "isDisabled": ((offre.Motif == undefined ||disableAll == true || offre.RetourClient == undefined || offre.RetourClient == 'Acceptee') ? true : false),            
            "MotifOptionsCiblee": //(offre.RetourClient == 'Autres') ? 
                                   // this.MotifAutres :  (Y-MH enlever le motif liéé a retour client autres )
                                    ((offre.RetourClient == 'Refusee') ? 
                                        this.MotifRefusee : 
                                        null)           
          };

           // offreTemp.push(val); 

            if (val.hideoffre === false) {
            console.log("hideoffre",hideoffre) ;
            offreTemp.push(val);
            //this.offrecibletodisplay ++ ;
        }
        
    }
     /*try {
            for (var offre of this.offresciblee) {
               //console.log('___offre.Motif'+offre.Motif);
                let val = {
                    "Id":offre.Id,
                    "idMotifElementCible":'ciblemotif'+offre.Id,
                    "idRetourElementCible":'cibleretour'+offre.Id,
                    "typeoffre":'cible',
                    "offreid":offre.Id,
                    "disableRetourClient" : disableAll,
                    "MDN":offre.MDN,
                    "Argumentaire" : offre.Argumentaire,    
                    "Description" : offre.Description,   
                    "DateDebut" : offre.DateDebut, 
                    "DateFin" : offre.DateFin, 
                    "Priorite" : offre.Priorite, 
                    "points" : offre.points, 
                    "date" : offre.dateModification, 
                    "IdCampagne": offre.IdCampagne,
                    "hideoffre":hideoffre ,
                    "dateModification":offre.dateModification,           
                    "mdn" : offre.MDN,    
                    "RetourClient":offre.RetourClient,
                    "Motif":offre.Motif,
                    "isAlreadyProposed": ((offre.RetourClient != undefined  )  ? 'oui' : 'non'),            
                    "isDisabled": ((offre.Motif == undefined ||disableAll == true || offre.RetourClient == undefined || offre.RetourClient == 'Acceptee') ? true : false),            
                    "MotifOptionsCiblee": ((offre.RetourClient == 'Autres') ? 
                                            this.MotifAutres : 
                                            ((offre.RetourClient == 'Refusee') ? 
                                                this.MotifRefusee : 
                                                null))            
                  };

                    offreTemp.push(val); 

                    if (val.hideoffre === false) {
                    console.log("hideoffre",hideoffre) ;
                    offrecibletodisplay ++ ;
                }
                
            }
          //  console.log('offreTemp: ');
          //  console.dir(offreTemp);

        } catch (error) {
            console.error('error isAlreadyProposed', error.message);  
        }*/
        console.log("offreTemp",offreTemp) ; 
        return offreTemp;
       
    }
// Y.Mh End  Exploitation du TAG éligibilité CRM
    
    handleRetourClientChange(event) {
//event.target.dataset.test     event.target.id     console.log('start Refusee');
try {

    var description = event.target.dataset.description;
    var argumentaire = event.target.dataset.argumentaire;
    var datedebut = event.target.dataset.datedebut;
    var datefin = event.target.dataset.datefin;
    var idcampagne = event.target.dataset.idcampagne;
    var priorite = event.target.dataset.priorite;
    var points = event.target.dataset.points;
    var date = event.target.dataset.date;

    console.log('idcampagne: '+idcampagne);

    var offreid = event.target.dataset.offreid;
   // console.log('handleRetourClientChange.typeoffre: '+typeoffre);

    var typeoffre = event.target.dataset.typeoffre;
                
    var comboboxRetour = this.template.querySelector(`[data-customidrt="${offreid}"]`);
    var comboboxMotif = this.template.querySelector(`[data-customidmt="${offreid}"]`);
//    var comboboxMotif = this.template.querySelector('#'+typeoffre+'motif'+offreid+'-11');
  //  var comboboxRetour = this.template.querySelector('#'+typeoffre+'retour'+offreid+'-11');

    var comboboxRetourValue = comboboxRetour.value;

    if(comboboxRetourValue  == 'Refusee'){

        comboboxMotif.options = this.MotifRefusee;
        comboboxMotif.disabled = false;

    //}else if(comboboxRetourValue  == 'Autres'){  (Y-MHelever le motif liéé a retour client autres )

       // comboboxMotif.options = this.MotifAutres;
        //comboboxMotif.disabled = false;

    }else if(comboboxRetourValue  == 'Acceptee'){
            comboboxMotif.options = null;
            comboboxMotif.disabled = true;

            this.addToSend(description,argumentaire,date,datedebut,datefin,idcampagne,priorite,points,typeoffre,offreid,
                            comboboxRetourValue,comboboxMotif.value);
    }else{
        console.log('else');  
    }
    } catch (error) {
        console.error('error handleRetourClientChange', error.message);  

    }
        
    }

    handleMotifChange(event) {
        try {
            console.log('start handleMotifChange');

            var description = event.target.dataset.description;
            var argumentaire = event.target.dataset.argumentaire;
            var datedebut = event.target.dataset.datedebut;
            var datefin = event.target.dataset.datefin;
            var idcampagne = event.target.dataset.idcampagne;
            var priorite = event.target.dataset.priorite;
            var points = event.target.dataset.points;
            var date = event.target.dataset.date;
        

            var typeoffre = event.target.dataset.typeoffre;
            console.log('idcampagne: '+idcampagne);

            var offreid = event.target.dataset.offreid;
                    
            var comboboxRetour = this.template.querySelector(`[data-customidrt="${offreid}"]`);
            var comboboxMotif = this.template.querySelector(`[data-customidmt="${offreid}"]`);

    //    var comboboxMotif = this.template.querySelector('#'+typeoffre+'motif'+offreid+'-1205');
    //    var comboboxRetour = this.template.querySelector('#'+typeoffre+'retour'+offreid+'-1205');

      //  console.log('comboboxMotif.value: '+comboboxMotif.value);
      //  console.log('comboboxRetour.value: '+comboboxRetour.value);
      this.addToSend(description,argumentaire,date,datedebut,datefin,idcampagne,priorite,points,typeoffre,offreid,
                            comboboxRetour.value,comboboxMotif.value);

        } catch (error) {
            console.error('message error Refusee', error.message);  
        }
        
    }
    


    addToSend(description,argumentaire,date,datedebut,datefin,idcampagne,
        priorite,points,typeoffre,offreid,comboboxRetourvalue,comboboxMotifvalue){

        let newRec = {
            "agent": this.agent,
            "argumentaire": argumentaire,
            "date": date,
            "dateDebut": datedebut,
            "dateFin": datefin,
            "description": description,
            "idCase": this.idofthecase,
            "idCompagne": idcampagne,
            "points": points,
            "priorite": priorite,
            "typeOffre": typeoffre,
            "account": this.idaccountcase,
            "profil": this.profilsubscription,
            
            "offreid":offreid,
            "mdn" : this.themdn,
            "RetourClient":comboboxRetourvalue,
            "Motif":comboboxRetourvalue=='Acceptee' ? "" : comboboxMotifvalue
        };
        if(typeoffre=='cible'){            
            this.recordsToAd.inputCible.push(newRec); 
            console.log('this.recordsToAd: ');
            console.dir(this.recordsToAd);

        }else if(typeoffre=='eligible'){            

            this.recordsToAd.inputEligible.push(newRec); 
            console.log('this.recordsToAd: ');
            console.dir(this.recordsToAd);

        }  else if(typeoffre=='generic'){            

            this.recordsToAd.inputGeneric.push(newRec); 
            console.log('this.recordsToAd: ');
            console.dir(this.recordsToAd);

        }  
    }

    saveModifs(){
        console.log('start saveModifs');

        this.omniUpdateDataJson(this.recordsToAd);
        this.omniSaveState(this.recordsToAd,true);
        this.omniNextStep();

        console.log('end saveModifs');

    }
    
    render() {

        this.isOffresGeneric  =(this.offresgeneric.length  == 0 ? false:true );
        this.isOffresEligible =(this.offreseligible.length == 0 ? false:true );
       // this.isOffresCiblee = (this.offresciblee.length == 0  ? false:true);
       // (Y-MH begin Exploitation du TAG éligibilité CRM)
       console.log("offresCibleeToShow",this.offresCibleeToShow.length) ;
        this.isOffresCiblee = (this.offresCibleeToShow.length == 0 ? false:true);
        return template;
        
    }
    
}