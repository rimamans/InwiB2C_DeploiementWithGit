import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import template from "./inwiB2C_DisplayTypeDeLigneForMigration.html";

/*const TL = new Map([
  ["CI", ["CI", "GP"]],
  ["CO", ["CI", "GP"]],
  ["AX", ["AX", "GP"]],
  ["AF", ["AF", "GP"]],
  ["PF", ["PF", "GP"]],
  ["SN", ["SN", "GP"]],
  ["PF", ["PF", "GP"]],
  ["SN", ["SN", "GP"]],
  ["PC", ["PC", "GP"]],
  ["PP", ["PP", "GP"]]
]);*/

export default class InwiB2C_DisplayTypeDeLigneForMigration extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)) {


    
  //
  @track
  __disabled = false;
  nafidaOk = false;
  @track 
  selectedLabel;
  migGratuite = false;
  needApprobation = false;
  needPrice = false;
  isLoading = false;
  ChangeTypeLigne = false;
  __showStatutFar = false;

  __index_type_ligne;
  __index_numero_adherant;
  __typeLigneSource;
  __typeLigneCibleValues = [];
  __typeLigneCible;
  value = "";
  numAd = "";
  valueStatutFar="";

  __showinputs = false;
  __FreeMig = false;
  __userprofil = "";
  __iscameleon ;
  __item = "";
  orderid = "";
  __typepos = "";
  isOs = false;
  __accountid = "";
  __vlccart;
  __message = "";
  isFreeMigChecked = false;
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
  set typeoffer(value) {
      this.__typeoffer = value;
  }
  get typeoffer() {
      return this.__typeoffer;
  }
  @api
  set userprofil(value) {
      this.__userprofil = value;
  }
  get userprofil() {
      return this.__userprofil;
  }
  @api
  set iscameleon(value) {
      this.__iscameleon = value;
  }
  get iscameleon() {
      return this.__iscameleon;
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

/* Puppilles DGPC ILA 22/01/24 Start */
__isppalowed
@api
set isppalowed(value) {
  this.__isppalowed = value;
}
get isppalowed() {
  return this.__isppalowed;
}
/* Puppilles DGPC ILA 22/01/24 End */

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
  //
  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.getOffersAttributes();
    console.log('isFreeMigChecked'+this.isFreeMigChecked);
    console.log('Val Selected ',+this.value );
    
  }
  handleChangeStatFar(event) {
    this.valueStatutFar = event.detail.value;

}
get optionsStatutFar() {
  return [
      { label: 'Actif', value: 'Actif' },
      { label: 'Non actif', value: 'Non actif' },
     
  ];
}
  getOffersAttributes() {
    console.log('__iscameleon: '+this.__iscameleon);
    if(this.__iscameleon == false){
    this.omniUpdateDataJson({ "freeMig": false});
   /* if(this.__userprofil && this.__userprofil != "Inwi POS" && this.__iscameleon == true)
   { this.isFreeMigChecked = true;
    this.omniUpdateDataJson({ "freeMig": true });
   }*/
    if(this.__userprofil && (this.userprofil == "SC Agents BO réclamation N2" || this.userprofil == "System Administrator" || this.userprofil == "SC Superviseur BO CRC Ex" || this.userprofil == "SC Superviseur BO CRC Int" || this.userprofil == "SC Agent VIP Int" ))
    this.__FreeMig = true;
    this.__vlccart && this.__vlccart.records && this.__vlccart.records.map(item => {
      if (item.action == "Add") {
        this.__item = item;
        this.orderid = this.__item.OrderId.value;
        console.log("OrderId=> ",this.orderid);
        //get type de ligne selectionné
        // get les types de ligne de l'offre cible
        item.attributeCategories.records[0].productAttributes.records.map((item2, index) => {
         // console.log("1 => ", item2.code)
          if (item2.code == "INWIB2C_ATT_RT_TYPE_LIGNE") {
            this.__index_type_ligne = index;
            this.value = item2.userValues;
            item2.values.map(item3 => {
              this.__typeLigneCibleValues.push(item3)
            })
            /*if(item2.userValues == "NAFIDA")
              {
               // this.needApprobation = true;
                this.__showinputs = true;
              }
              if(item2.userValues == "NAFIDA" && this.__typeLigneSource != "NAFIDA" && this.nafidaOk == false)
                this.__disabled = true;*/

          }
           if (item2.code == "INWIB2C_ATT_DC_NUMERO_ADHERANT") {
            this.__index_numero_adherant = index;
            console.log("Num adhérant=> ",this.numAd);
            this.numAd = item2.userValues;
          }
        })
      } else {
        // get type ligne de l'offre source
        item.attributeCategories.records[0].productAttributes.records.map(item2 => {
          // console.log("2 => ", item2.code)
          if (item2.code == "INWIB2C_ATT_RT_TYPE_LIGNE") {
            this.__typeLigneSource = item2.userValues;
          }
        })
      }
    })
    if (this.__typeLigneSource != this.value)
    { 
      this.needApprobation = true;
      this.ChangeTypeLigne = true;
    }
    else
      this.needApprobation = false
    if (this.__typeLigneSource =="GP")
    {
      this.needPrice = true;
      this.omniUpdateDataJson({ "needPrice": this.needPrice });
  }
    this.omniUpdateDataJson({ "needApp": this.needApprobation });
    this.selectedLabel = this.__typeLigneCibleValues.find(opt => opt.value === this.value).label;
    
    this.omniUpdateDataJson({ "ChangeTypeLigne": this.ChangeTypeLigne});
  }
}
  changeFreeMig(event){
    this.omniUpdateDataJson({ "freeMig": event.target.checked });
  }
  get eligibility() {
   // console.log("eligibility")
   // console.log(this.__typeLigneSource)
   // console.log(JSON.stringify(this.__typeLigneCibleValues))
    let value = false;
    if (this.__typeLigneSource == "NAFIDA") {
      this.__typeLigneCibleValues.map(item => {
        if (item.value == "NAFIDA") {
          value = true;
          //this.__showinputs = true;
        }
      })
    }
    else if (this.__typeLigneSource == "CI") {
      this.__typeLigneCibleValues.map(item => {
        if (item.value == "CI" || item.value == "GP") {
          value = true;
        }
      })
    }
    else {
      value = true;
    }
    //console.log("value = ", value)
    return value;
  }

  get isNafida() {
    /**Campus connecte postpaye ILA 25/04/2024 Ila Start */
    //if (this.__typeLigneSource == "NAFIDA") {
      if (this.__typeLigneSource == "NAFIDA" ||this.__typeLigneSource =="CP" ) {
      /**Campus connecte postpaye ILA 25/04/2024 Ila End */
      return true;
    } else return false;
  }

  get selection() {
    /* Puppilles DGPC ILA 22/01/24 Start */
    if(this.__typeLigneSource == "GP"){
      for (var i=this.__typeLigneCibleValues.length-1; i>=0; i--) {
        /**B-15042 ILA 03/04/2024 Ila Start */
        //if((this.__typeLigneCibleValues[i].value == "CO") || (this.__typeLigneCibleValues[i].value == "ED") || (this.__typeLigneCibleValues[i].value == "CI" && this.__typepos != "inwib2c_OS") || (this.__typeLigneCibleValues[i].value == "PC" && !this.__isdgallowed) || (this.__typeLigneCibleValues[i].value == "SN" && !this.__isdgallowed) || (this.__typeLigneCibleValues[i].value == "PP" && !this.__isppalowed)){
        /**Campus connecte postpaye ILA 25/04/2024 Ila Start */
        //if((this.__typeLigneCibleValues[i].value == "CO") || (this.__typeLigneCibleValues[i].value == "ED") || (this.__typeLigneCibleValues[i].value == "CI" && this.__typepos != "inwib2c_OS") || (this.__typeLigneCibleValues[i].value == "PC" && (!this.__isdgallowed || this.userprofil != "Inwi POS")) || (this.__typeLigneCibleValues[i].value == "SN" && (!this.__isdgallowed || this.userprofil != "Inwi POS")) || (this.__typeLigneCibleValues[i].value == "PP" && (!this.__isppalowed || this.userprofil != "Inwi POS"))){
          //if((this.__typeLigneCibleValues[i].value == "CP") ||(this.__typeLigneCibleValues[i].value == "CO") || (this.__typeLigneCibleValues[i].value == "ED") || (this.__typeLigneCibleValues[i].value == "CI" && this.__typepos != "inwib2c_OS") || (this.__typeLigneCibleValues[i].value == "PC" && (!this.__isdgallowed || this.userprofil != "Inwi POS")) || (this.__typeLigneCibleValues[i].value == "SN" && (!this.__isdgallowed || this.userprofil != "Inwi POS")) || (this.__typeLigneCibleValues[i].value == "PP" && (!this.__isppalowed || this.userprofil != "Inwi POS"))){
          /**Campus connecte postpaye ILA 25/04/2024 Ila End */
        /**B-15042 ILA 03/04/2024 Ila End */
        /* Collaborateur OCP ILA 08/11/24 Start */
        if((this.__typeLigneCibleValues[i].value == "CP") ||(this.__typeLigneCibleValues[i].value == "CO") || (this.__typeLigneCibleValues[i].value == "ED") || (this.__typeLigneCibleValues[i].value == "CI" && this.__typepos != "inwib2c_OS") || (this.__typeLigneCibleValues[i].value == "PC" && (!this.__isdgallowed || this.userprofil != "Inwi POS")) || (this.__typeLigneCibleValues[i].value == "SN" && (!this.__isdgallowed || this.userprofil != "Inwi POS")) || (this.__typeLigneCibleValues[i].value == "PP" && (!this.__isppalowed || this.userprofil != "Inwi POS")) || (this.__typeLigneCibleValues[i].value == "OCP" && !this.__isocpallowed)){
        /* Collaborateur OCP ILA 08/11/24 End */ 
          this.__typeLigneCibleValues.splice(i, 1);
        }
    }
    return this.__typeLigneCibleValues;
    }
    else{
      return this.__typeLigneCibleValues.filter(item => {
        return item.value == "GP" || item.value == this.__typeLigneSource 
      })
    }
  }
  handleChangeStatFar(event) {
    this.valueStatutFar = event.detail.value;

}

  handleChangeDropDown(event) {
    this.__message = "";
    this.value = event.detail.value;
    this.selectedLabel = this.__typeLigneCibleValues.find(opt => opt.value === this.value).label;
    this.__showinputs = false;
    this.__showStatutFar = false;

    if (this.__typeLigneSource == "GP") {
       if (this.value == "CI" || this.value == "CO") {
        this.checkEligibilityCollaborator();
      } else if (this.value == "NAFIDA") {
        this.__disabled = true;
        this.__showinputs = true;
      }
      /**B-14756 ILA 15/03/24 Start */
      else if(this.value == "PP" ){
        this.__disabled = true;
        /* Collaborateur OCP ILA 08/11/24 Start */
        this.checkEligibilityPP(this.value);
        /* Collaborateur OCP ILA 08/11/24 End */
      }
      else if(this.value == "AF" || this.value == "PF" ){
        this.__showStatutFar = true;
      }
      /* Collaborateur OCP ILA 08/11/24 Start */
      else if(this.value == "OCP"){
        this.__disabled = true;
        this.checkEligibilityPP(this.value);
      }
      /* Collaborateur OCP ILA 08/11/24 END */
      /**B-14756 ILA 15/03/24 end */
      else
      this.__disabled = false;
    }
    if ((this.__typeLigneSource == "GP" && this.value != "GP" )||(this.__typeLigneSource == "AF" && this.value == "PF")||(this.__typeLigneSource == "PF" && this.value == "AF"))
    this.needApprobation = true;
    else
    this.needApprobation = false
    this.omniUpdateDataJson({ "needApp": this.needApprobation });
    if(this.value == "GP" && this.__typeLigneSource != "AF" && this.__typeLigneSource != "PF" && this.__typeLigneSource != "AX" && this.__typeLigneSource != "PC" && this.__typeLigneSource != "SN" && this.__typeLigneSource != "PP" && this.__typeLigneSource != "CI")
      this.needPrice = true;
    /* Collaborateur OCP ILA 08/11/24 Start */
    //if(this.__typeLigneSource == "GP" && (this.value=="AF" || this.value=="PF" ||this.value=="AX" || this.value=="PC" ||this.value=="SN" ||this.value=="PP" ||this.value=="CI" ||this.value=="NAFIDA" ))
    if(this.__typeLigneSource == "GP" && (this.value=="AF" || this.value=="PF" ||this.value=="AX" || this.value=="PC" ||this.value=="SN" ||this.value=="PP" ||this.value=="CI" ||this.value=="NAFIDA" ||this.value=="OCP" ))
      /* Collaborateur OCP ILA 08/11/24 Start */
      this.needPrice = false;
    this.omniUpdateDataJson({ "needPrice": this.needPrice });
    if(this.__typeLigneSource != this.value)
      this.ChangeTypeLigne = true;
    this.omniUpdateDataJson({ "ChangeTypeLigne": this.ChangeTypeLigne});
  }

  checkEligibilityCollaborator() {
    this.__loading = true;
    this.__disabled = true;
    this.__message = "";
    const params = {
      input: '{"accountid": "' + this.__accountid + '" }',
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
        console.log(result);
        console.log(this.value)
        this.__loading = false;
        if (result && result.count < 4) {
          this.value == "CI";
          this.__disabled = false;

        } else {
          //this.__message = "Le client a dépassé la limite autorisée";
          const event1 = new ShowToastEvent({
            message: 'Le client a dépassé la limite autorisée',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(event1);
        }
      })
      .catch(error => {
        console.log("error");
        window.console.log(error);
      });

  }
/* Collaborateur OCP ILA 08/11/24 Start */
  checkEligibilityPP(typeLigne) {
/* Collaborateur OCP ILA 08/11/24 End */
    /* Collaborateur OCP ILA 08/11/24 Start */
    let type= typeLigne=="PP"?"pupilles de la nation DGPC":"Collaborateur OCP";
    /* Collaborateur OCP ILA 08/11/24 End */
    this.__message = "";
    const params = {
      /* Collaborateur OCP ILA 08/11/24 Start */
      //input: '{"cin":"'+this.__cin+'","type":"pupilles de la nation DGPC"'+',"typeoffer": "'+ this.__typeoffer + '"}',
      /* Collaborateur OCP ILA 08/11/24 End */
      input: '{"cin":"'+this.__cin+'","type":"'+type+'","typeoffer": "'+ this.typeoffer + '"}',
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_check_Far",
      options: "{}",
    };

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log("call inwib2c_inwib2c_check_Far");
        console.log('input ', input,' response ',response);
        let result = response.result.IPResult;
        console.log(result);
        if (result && result.count < result.max_far) {
          /* Collaborateur OCP ILA 08/11/24 Start */
          //this.value == "PP";
          this.value == typeLigne;
          /* Collaborateur OCP ILA 08/11/24 End */
          this.__disabled = false;

        } else {
          this.__message = "Le client a dépassé la limite autorisée";
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
            "accountid": "`+ this.__accountid + `",
            "typeoffer": "`+ this.__typeoffer  + `"
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
          console.log(input);
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
              } else if (result.identificationStatus && result.identificationStatus == "1" && result.count.count >= result.count.max_nafida) {
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
                this.__disabled = false;
                this.nafidaOk = true;
              }
            } else if (!result.success) {
              this.__message = result.error;
              const event1 = new ShowToastEvent({
                message: result.error,
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event1);
            }
          }
        })
        .catch(error => {
          console.log("error");
          window.console.log(error);
          
        });
    }
  }

  handleChooseOffer() {

  }

  handleClick(){
    /*let localItem = JSON.parse(JSON.stringify(this.__item));
    //console.log("item====> ",localItem);
     //   console.log(this.value);
     localItem.attributeCategories.records[0].productAttributes.records[this.__index_type_ligne].userValues = this.value;
     if (this.value == "NAFIDA") {
      localItem.attributeCategories.records[0].productAttributes.records[this.__index_numero_adherant].userValues = this.template.querySelector(`[data-theid="numadherant"]`).value;
      
    }*/
    //return type de ligne et num adh choisis
    console.log("this.selectedLabel=>",this.selectedLabel);
    this.omniUpdateDataJson({ "inputLigne": this.selectedLabel});
    if(this.value == "NAFIDA" && this.__typeLigneSource != "NAFIDA")
    this.omniUpdateDataJson({ "inputNumAd": this.template.querySelector(`[data-theid="numadherant"]`).value });
   
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
   
    //Suivant OS
    this.omniNextStep();




  }



  render() {
    return template;
  }
  }