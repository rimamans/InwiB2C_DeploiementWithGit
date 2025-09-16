import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import template from "./inwiB2C_ChangeTypeDeLigne.html";

export default class InwiB2C_ChangeTypeDeLigne extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

  //
  @track
  __disabled = false;
  isNafida = false;
  @track
  selectedLabel;
  valeurselectionne;
  valeurcatalogue;
  needApprobation = false;
  isLoading = false;
  __index_type_ligne;
  __index_numero_adherant;
  __typeLigneSource;
  __typeLigneCibleValues = [];
  __typeLigneCible = [];
  __next = false;
  numAd = "";
  valueStatutFar="";
  __showStatutFar = false;

  __showinputs = false;
  __item = "";
  __message = "";
  orderid = "";
  __typepos = "";
  isOs = false;
  __accountid = "";
  __cin = "";
  __vlccart;
  @api typeoffer;
  @api
  set vlccart(value) {
    this.__vlccart = { ...value };
  }
  get vlccart() {
    return this.__vlccart;
  }

  @api
  set typepos(value) {
    this.__typepos = value;
  }
  get typepos() {
    return this.__typepos;
  }
  @api
  set accountid(value) {
    this.__accountid = value;
  }
  get accountid() {
    return this.__accountid;
  }
  @api
  set cin(value) {
    this.__cin = value;
  }
  get cin() {
    return this.__cin;
  }

  __isdgallowed
  @api
  set isdgallowed(value) {
    this.__isdgallowed = value;
  }
  get isdgallowed() {
    return this.__isdgallowed;
  }
  /* Puppilles DGPC ILA 24/01/2024 Start*/
  __isppalowed
  @api
  set isppalowed(value) {
    this.__isppalowed = value;
  }
  get isppalowed() {
    return this.__isppalowed;
  }
   /* Puppilles DGPC ILA 24/01/2024 End */

     /* Campus postpaye ILA 24/04/2024 Start*/
  __iscampusallowed
  @api
  set iscampusallowed(value) {
    this.__iscampusallowed = value;
  }
  get iscampusallowed() {
    return this.__iscampusallowed;
  }
  __universite
  @api
  set universite(value) {
    this.__universite = value;
  }
  get universite() {
    return this.__universite;
  }
  __showUniversite=false;
  universites=[];
  universiteValue;
   /* Campus postpaye ILA 24/04/2024 End */

  //
   /**B-15042 ILA 03/04/2024 Ila Start */
  @api
  set userprofil(value) {
      this.__userprofil = value;
  }
  get userprofil() {
      return this.__userprofil;
  }
   /**B-15042 ILA 03/04/2024 Ila End */
   /* Collaborateur OCP ILA 08/11/24 Start */
__isocpallowed
@api
set isocpallowed(value) {
  this.__isocpallowed = value;
}
get isocpallowed() {
  return this.__isocpallowed;
}
/* Collaborateur OCP ILA 08/11/24  End */
  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.getOffersAttributes();
    console.log(JSON.stringify(this.valeurcatalogue))
    // this.value = this.valeurselectionne;
    this.omniUpdateDataJson({ "valeurancienne": this.valeurcatalogue });
    console.log(JSON.stringify(this.value))
    console.log("this.ancien type"+this.ancientype);
  }
  handleChangeStatFar(event) {
    this.valueStatutFar = event.detail.value;

}

  getOffersAttributes() {
    console.log(JSON.stringify(this.__vlccart))
    //this.omniUpdateDataJson({ "needApp ": this.needApprobation });
    console.log("Type Pos=> ", this.__vlccart);
    this.__vlccart && this.__vlccart.records && this.__vlccart.records.map(item => {
      if (item.action == "Existing"|| item.action == "Change") {
        this.__item = item;
        this.orderid = this.__item.OrderId.value;
        console.log("OrderId=> ", this.orderid);
        //get type de ligne selectionné
        item.attributeCategories.records[0].productAttributes.records.map((item2, index) => {
          //console.log("1 => ", item2.code)
          if (item2.code == "INWIB2C_ATT_RT_TYPE_LIGNE") {
            this.__index_type_ligne = index;
            this.valeurcatalogue = item2.userValues;
            console.log('item2', item2);
            item2.values.map(item3 => {
              console.log('typecible', item3);
              this.__typeLigneCible.push(item3)
            })

          }

        })
      }
    })

    // if (this.value=='NAFIDA') {this.isNafida=true}else{this.isNafida=false};
    // console.log(this.value);
    // if (this.__typeLigneSource != this.value)
    // this.needApprobation = true;
    // else
    // this.needApprobation = false
    // this.omniUpdateDataJson({ "needApp ": this.needApprobation });
    // this.selectedLabel = this.__typeLigneCibleValues.find(opt => opt.value === this.value).label;

  }

  //   get eligibility() {

  //     let value = true;
  //     if (this.value == "NAFIDA") {
  //         value = false;
  //     }
  //     return value;
  //   }

  get selection() {
    
    for (var i=this.__typeLigneCible.length-1; i>=0; i--) {
      /* Collaborateur OCP ILA 08/11/24 Start */
        //if((this.__typeLigneCible[i].value == "CP" && !this.__iscampusallowed) || (this.__typeLigneCible[i].value == "CO") || (this.__typeLigneCible[i].value == "ED") || (this.__typeLigneCible[i].value == "CI" && this.__typepos != "inwib2c_OS") || (this.__typeLigneCible[i].value == "PC" && (!this.__isdgallowed ||this.userprofil != "Inwi POS" )) || (this.__typeLigneCible[i].value == "SN" && (!this.__isdgallowed || this.userprofil != "Inwi POS")) || (this.__typeLigneCible[i].value == "PP" && (!this.__isppalowed || this.userprofil != "Inwi POS"))){  
        if((this.__typeLigneCible[i].value == "CP" && !this.__iscampusallowed) || (this.__typeLigneCible[i].value == "CO") || (this.__typeLigneCible[i].value == "ED") || (this.__typeLigneCible[i].value == "CI" && this.__typepos != "inwib2c_OS") || (this.__typeLigneCible[i].value == "PC" && (!this.__isdgallowed ||this.userprofil != "Inwi POS" )) || (this.__typeLigneCible[i].value == "SN" && (!this.__isdgallowed || this.userprofil != "Inwi POS")) || (this.__typeLigneCible[i].value == "PP" && (!this.__isppalowed || this.userprofil != "Inwi POS")) || (this.__typeLigneCible[i].value == "OCP" && !this.__isocpallowed)){  
        /* Collaborateur OCP ILA 08/11/24 End */
          this.__typeLigneCible.splice(i, 1);
      }
  }
  return this.__typeLigneCible;


  }



  handleChangeDropDown(event) {
  
    this.value = event.detail.value;
    this.valeurselectionne = this.__typeLigneCible.find(opt => opt.value === this.value).label;
    console.log("this.value----->", this.value)
    console.log("this.cin----->", this.__cin)
    this.__message = "";
    this.__showStatutFar = false;
    if (this.value == "AF" || this.value == "PF") {

      this.__showStatutFar = true;
  }
    /* Campus postpaye ILA 24/04/2024 Start*/
    /*if(
    (this.valeurcatalogue=="GP" && (this.value=="CI" || this.value=="NAFIDA" || this.value=="AF" || this.value=="PF"|| this.value=="AX" || this.value=="PC" || this.value=="SN" || this.value=="PP")) ||
    (this.valeurcatalogue!="GP" && this.value=="GP")  
    )*/
    if(
      (this.valeurcatalogue=="GP" && (this.value=="CI" || this.value=="NAFIDA" || this.value=="AF" || this.value=="PF"|| this.value=="AX" || this.value=="PC" || this.value=="SN" || this.value=="PP" || this.value=="CP" || this.value=="OCP")) ||
      (this.valeurcatalogue!="GP" && this.value=="GP")  
      )
    /* Campus postpaye ILA 24/04/2024 Start*/
    {
      console.log("this.invetig----->", this.valeurcatalogue + '==>'+this.value)

            if(this.valeurcatalogue===this.value){
              this.__message = "Vous ne pouvez pas séléctionner le meme type de ligne";
              /* Campus postpaye ILA 24/04/2024 Start*/
              this.__showUniversite=false;
              /* Campus postpaye ILA 24/04/2024 End*/
              this.__showinputs = false;
              this.__next = false;
          }
            else if (this.value == "NAFIDA") {
              /* Campus postpaye ILA 24/04/2024 Start*/
              this.__showUniversite=false;
              this.__showStatutFar = false;

              /* Campus postpaye ILA 24/04/2024 End*/
              this.__showinputs = true;
              this.__next = false;
              
            } else if (this.value == "CI") {
              /* Campus postpaye ILA 24/04/2024 Start*/
              this.__showUniversite=false;
              /* Campus postpaye ILA 24/04/2024 End*/
              this.__showinputs = false;
              this.__next = false;
              this.__showStatutFar = false;

              this.checkEligibilityCollaborator(this.value);

            } else if (this.value == "AF" || this.value == "PF" || this.value=="AX") {
              /* Campus postpaye ILA 24/04/2024 Start*/
              this.__showUniversite=false;
              /* Campus postpaye ILA 24/04/2024 End*/
              this.__showinputs = false;
              this.__next = false;
              this.checkEligibilityFar(this.value);

          }
          else if(this.value == "PC" || this.value == "SN" || this.value == "PP" ){
            /* Campus postpaye ILA 24/04/2024 Start*/
            this.__showUniversite=false;
            /* Campus postpaye ILA 24/04/2024 End*/
            this.__showinputs = false;
            this.__next = false;
            this.checkEligibilityDG(this.value);
          }
          /* Campus postpaye ILA 24/04/2024 Start*/
          else if(this.value == "CP"){
            this.__showinputs = false;
            this.__showUniversite=false;
            this.__next = false;
            this.__showStatutFar = false;

            this.elligibiliteCampus();
          }
          /* Campus postpaye ILA 24/04/2024 END*/

         /* Collaborateur OCP ILA 08/11/24 Start */
          else if(this.value == "OCP"){
            this.__showinputs = false;
            this.__showUniversite=false;
            this.__next = false;
            this.__showStatutFar = false;
            this.checkEligibilityFar(this.value);
          }
          /* Collaborateur OCP ILA 08/11/24 End */

          else { 
              this.__showinputs = false;
              this.__next = false;
              /* Campus postpaye ILA 24/04/2024 Start*/
            this.__showUniversite=false;
            /* Campus postpaye ILA 24/04/2024 End*/
              this.checkEligibilityGP();
          }
    }else{
      this.__next = false;
      /* Campus postpaye ILA 24/04/2024 Start*/
      this.__showUniversite=false;
      /* Campus postpaye ILA 24/04/2024 End*/
      this.__message = "Vous ne pouvez pas séléctionner ce type de ligne";
    }  
    

    if (this.value == "GP" && (this.valeurcatalogue != "AF" && this.valeurcatalogue != "PF" && this.valeurcatalogue!="AX" && this.valeurcatalogue!="SN" && this.valeurcatalogue!="PC")) 
    {
      this.omniUpdateDataJson({ "needApproval": false });

    }
    console.log("this.catalogue", this.valeurcatalogue)
    console.log("this.value", this.value)
   
    this.omniUpdateDataJson({ "valeurselectionne": this.valeurselectionne });


  }
/* Campus postpaye ILA 24/04/2024 Start*/
  elligibiliteCampus(){
    let vipInput='{"cin":"'+this.cin+'","offerType":"MOBILE_POSTPAID","orderType":"M"}';
    console.log('eligibilite Input',vipInput);
    const params = {
      input: vipInput,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_elligibiliteCampusPostpaye',
      options: '{}'
  };
  this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => { 
          this.isLoadinginModal=false; 
            if (response.error == false) {
                console.log(response);
                if (response.result) {
                    console.log('eligibilite Output',JSON.stringify(response));
                    if(response.result.IPResult && response.result.IPResult.isEligible==1){
                      this.universiteValues();
                      this.__showUniversite=true;
                      this.__next = true;
                    } 
                   else{
                    this.__message='Vous n\'êtes pas éligible pour l\'avantage campus';
                   }
                }
            }
        })
        .catch(error => {
            console.log('error');
            window.console.log(error);
        });    

  }
  get optionsStatutFar() {
    return [
        { label: 'Actif', value: 'Actif' },
        { label: 'Non actif', value: 'Non actif' },
       
    ];
}

  universiteValues(){
    let values= [
        { label: 'Université Abdelmalek Essaâdi', value: 'Université Abdelmalek Essaâdi' },
        { label: 'Université Cadi Ayyad', value: 'Université Cadi Ayyad' },
        { label: 'Université Chouaib Doukkali', value: 'Université Chouaib Doukkali' },
        { label: 'Université Hassan 1er', value: 'Université Hassan 1er' },
        { label: 'Université Hassan II', value: 'Université Hassan II' },
        { label: 'Université Ibn Tofaîl', value: 'Université Ibn Tofaîl' },
        { label: 'Université Ibn Zohr', value: 'Université Ibn Zohr' },
        { label: 'Université Mohamed V', value: 'Université Mohamed V' },
        { label: 'Université Mohammed Premier', value: 'Université Mohammed Premier' },
        { label: 'Université Moulay Ismail', value: 'Université Moulay Ismail' },
        { label: 'Université Sidi Mohamed Ben Abdellah', value: 'Université Sidi Mohamed Ben Abdellah' },
        { label: 'Université Sultan Moulay Slimane', value: 'Université Sultan Moulay Slimane' },
    ];
    this.universites = values;
    this.universiteValue=this.__universite;
 }

 handleSelection(event){
  let value= event.detail.value;
  this.omniUpdateDataJson({ "newUniversite": value});

 }
 /* Campus postpaye ILA 24/04/2024 End*/

  checkEligibilityGP() {
    console.log('in checkEligibilityGP');
    const selectedEvent = new CustomEvent("changelignetype", {
        detail: ["Checking Eligibility"],
    });
    this.dispatchEvent(selectedEvent);
    //
    this.__loading = true;
    this.__disabled = true;
    this.__message = "";
    const params = {
        input: '{"cin":"'+this.__cin+'","type":"Grand Public","typeoffer": "'+ this.typeoffer + '"}',
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_inwib2c_check_collaborateur",
        options: "{}",
    };
    this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
            console.log("call inwib2c_inwib2c_check_grand publique"+this.typeoffer );
            console.log(response);
            let result = response.result.IPResult;
            console.log(result);
            console.log(this.value)
            this.__loading = false;
            if (result && result.count < result.max_gp) {
                this.value = "GP";
                this.__next = true;
                console.log('check: this .value'+this.value)
                const selectedEvent = new CustomEvent("changelignetype", {
                    detail: [],
                });
                this.dispatchEvent(selectedEvent);
            } else {
                this.__message = "Le client a dépassé la limite autorisée";
                const selectedEvent = new CustomEvent("changelignetype", {
                    detail: ["Le client a dépassé la limite autorisée"],
                });
                this.dispatchEvent(selectedEvent);
            }
        })
        .catch(error => {
            console.log("error");
            window.console.log(error);
        });
}

  checkEligibilityFar(typeligne) {
    this.__message = "";
    /* Collaborateur OCP ILA 08/11/24 Start */
    //let type= typeligne=="AF"?"Adhérant FAR":typeligne=="PF"?"Pupilles de la nation FAR":"Forces auxiliaires";
    let type= typeligne=="AF"?"Adhérant FAR":typeligne=="PF"?"Pupilles de la nation FAR":typeligne=="OCP"?"Collaborateur OCP":"Forces auxiliaires"
    /* Collaborateur OCP ILA 08/11/24 Start */
    const params = {
        input: '{"cin":"'+this.__cin+'","type":"'+type+'","typeoffer": "'+ this.typeoffer + '"}',
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_inwib2c_check_Far",
        options: "{}",
    };

    this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
            console.log("call inwib2c_inwib2c_check_Far");
            console.log('input ', params,' response ',response);
            let result = response.result.IPResult;
            console.log(result);
            console.log(this.value)
            this.__loading = false;
            if (result && result.count < result.max_far) {
                this.value = typeligne;
                this.__next = true;
                const selectedEvent = new CustomEvent("changelignetype", {
                    detail: [],
                });
                this.dispatchEvent(selectedEvent);
            } else {
                this.__message = "Le client a dépassé la limite autorisée";
                const selectedEvent = new CustomEvent("changelignetype", {
                    detail: ["Le client a dépassé la limite autorisée"],
                });
                this.dispatchEvent(selectedEvent);
            }
        })
        .catch(error => {
            console.log("error");
            window.console.log(error);
        });

}

checkEligibilityDG(typeligne) {



  this.__message = "";
  /* ILA 24/01/2024 PUPPILLES DGPC Start */
  //let type= typeligne=="PC"?"DGPC":"DGSN";
  let type= typeligne=="PP"?"pupilles de la nation DGPC":typeligne=="PC"?"DGPC":"DGSN";
  /* ILA 24/01/2024 PUPPILLES DGPC End */
  const params = {
      input: '{"cin":"'+this.__cin+'","type":"'+type+'","typeoffer": "'+ this.typeoffer + '"}',
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_check_Far",
      options: "{}",
  };

  this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
          console.log("call inwib2c_inwib2c_check_Far");
          console.log(response);
          let result = response.result.IPResult;
          console.log(result);
          console.log(this.value)
          this.__loading = false;
          if (result && result.count < result.max_far) {
              this.value = typeligne;
              this.__next = true;
              const selectedEvent = new CustomEvent("changelignetype", {
                  detail: [],
              });
              this.dispatchEvent(selectedEvent);
          } else {
              this.__message = "Le client a dépassé la limite autorisée";
              const selectedEvent = new CustomEvent("changelignetype", {
                  detail: ["Le client a dépassé la limite autorisée"],
              });
              this.dispatchEvent(selectedEvent);
          }
      })
      .catch(error => {
          console.log("error");
          window.console.log(error);
      });

}

checkEligibilityCollaborator(typeligne) {
  const selectedEvent = new CustomEvent("changelignetype", {
      detail: ["Checking Eligibility"],
  });
  this.dispatchEvent(selectedEvent);
  //
  this.__loading = true;
  this.__disabled = true;
  this.__message = "";
  const params = {
    input: '{"cin":"'+this.__cin+'","type": "Collaborateur inwi" ,"typeoffer": "'+ this.typeoffer + '"}',
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_check_collaborateur",
      options: "{}",
  };

  this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
          console.log("call inwib2c_inwib2c_check_collaborateur");
          console.log(response);
          let result = response.result.IPResult;
          console.log(result.count);
          console.log(this.value)
          this.__loading = false;
          if (result && result.count < result.max_collaborateur) {
              this.value == "CI";
              console.log('heree')
              this.__next = true;
              const selectedEvent = new CustomEvent("changelignetype", {
                  detail: [],
              });
              this.dispatchEvent(selectedEvent);
          } else {
              this.__message = "Le client a dépassé la limite autorisée";
              const selectedEvent = new CustomEvent("changelignetype", {
                  detail: ["Le client a dépassé la limite autorisée"],
              });
              this.dispatchEvent(selectedEvent);
          }
      })
      .catch(error => {
          console.log("error");
          window.console.log(error);
      });

}

  checkEligibilityNafida() {
    this.__disabled = true;
    this.__message = "";
    let value =
      this.template.querySelector(`[data-theid="numadherant"]`).value;
    if (!value || value == "") {
      this.__message = "Veuillez saisir le numéro de l'adhérant";
      const event1 = new ShowToastEvent({
        message: 'Veuillez saisir le numéro de l\'adhérant',
        variant: 'error',
        mode: 'dismissable'
      });
      this.dispatchEvent(event1);
    } else {
      this.__loading = true;
      const input = `{
            "foudationName": "FM6",
            "adherentNationalId": "`+ this.__cin + `",
            "adherentNumber": "`+ value + `",
            "accountid": "`+ this.__accountid + `"
        }`;

      const params = {
        input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_inwib2c_check_nafida_member",
        options: "{}",
      };

      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          console.log("call inwib2c_inwib2c_check_nafida_member");
          let result = response.result.IPResult;
          console.log(result);
          this.__loading = false;
          if (result) {
            if (result.status == "1") {
              if (result.identificationStatus && result.identificationStatus == "0") {
                this.__message = "Le client n'est pas adhérant dans la fondation";
                this.nafidaOk = false;
                const event1 = new ShowToastEvent({
                  message: 'Le client n\'est pas adhérant dans la fondation',
                  variant: 'error',
                  mode: 'dismissable'
                });
                this.dispatchEvent(event1);
              } else if (result.identificationStatus && result.identificationStatus == "1" && result.count.count  >= result.count.max_nafida) {
                this.__message = "Le client a dépassé la limite autorisée";
                this.nafidaOk = false;
                const event2 = new ShowToastEvent({
                  message: 'Le client a dépassé la limite autorisée',
                  variant: 'error',
                  mode: 'dismissable'
                });
                this.dispatchEvent(event2);
              } else {
                this.value == "NAFIDA";
                this.__next = true;
                this.isNafida = true;
                //this.__disabled = false;
                const selectedEvent = new CustomEvent("changelignetype", {
                    detail: [],
                });
                this.dispatchEvent(selectedEvent);
              }
            } else if(result.success==false) {
              this.__message ="une erreur s'est produite, merci de re-essayer";
     
            }
          }
        })
        .catch(error => {
          console.log("error");
          window.console.log(error);

        });
    }
  }

  handleSuivant() {
    if ((this.value == "AF" || this.value == "PF"  ) &&  this.valueStatutFar) {
      const params = {
          input: '{"value": "' + this.valueStatutFar + '", "orderid":"' + this.orderid + '" }',
          sClassName: `${this._ns}IntegrationProcedureService`,
          sMethodName: "inwib2c_updateOrderFar",
          options: '{}',
      };

      this._actionUtilClass
          .executeAction(params, null, this, null, null)
          .then(response => {
              console.log("saveAppliedPromotions");
              this.dispatchEvent(selectedEvent);

          })
          .catch(error => {
              this.saving = false;
              window.console.log(error);
          });

  }
    this.omniNextStep();
  }

  handleClick() {
    if ((this.value == "AF" || this.value == "PF"  ) &&  this.valueStatutFar) {
      const params = {
          input: '{"value": "' + this.valueStatutFar + '", "orderid":"' + this.orderid + '" }',
          sClassName: `${this._ns}IntegrationProcedureService`,
          sMethodName: "inwib2c_updateOrderFar",
          options: '{}',
      };

      this._actionUtilClass
          .executeAction(params, null, this, null, null)
          .then(response => {
              console.log("saveAppliedPromotions");
              this.dispatchEvent(selectedEvent);

          })
          .catch(error => {
              this.saving = false;
              window.console.log(error);
          });

  }
  
    //return type de ligne et num adh choisis
    console.log("this.selectedLabel=>", this.selectedLabel);
    this.omniUpdateDataJson({ "inputLigne": this.selectedLabel });
    if (this.value == "NAFIDA")
      this.omniUpdateDataJson({ "inputNumAd": this.template.querySelector(`[data-theid="numadherant"]`).value });
    //Suivant OS
    this.omniNextStep();




  }



  render() {
    return template;
  }
}