import { LightningElement, api, wire } from "lwc";

import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwiB2C_DisplayContract.html";

export default class InwiB2C_DisplayContract extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  _ns = getNamespaceDotNotation();
  picklistvalues = [];
  Point_de_vente_Options = [];

  // address code vars

  @api p;
  @api r;

  @api v;
  @api q;

  isLoading = true;
  loadingMsg = "picklists are loading...";

  PaysValues = [];
  RegionValues = [];
  VilleValues = [];
  QuartierValues = [];
  IdMaroc;

  isToSpecify = false;

  //fin address code vars

  // start optimisation de perfs suite case SF 466875293 by Badr aissouni le 03/04/2024
  // renderedCallback() {
  //   this.addressDisplayCheck();
  //   }
  // end optimisation de perfs suite case SF 466875293 by Badr aissouni le 03/04/2024

  addressDisplayCheck(){
      
    console.log("addressDisplayCheck")
     try {
         
        let indexMaroc = this.PaysValues.findIndex(x => x.label === "Maroc");

    let PaysFieldValue = this.template.querySelector(`[data-theid="Pays"]`).value;

    


    let labelSelected = this.PaysValues.find(
        opt => opt.value === PaysFieldValue
      ).label
   // if (!this.p) this.valuePays = this.PaysValues[indexMaroc].value;
   console.log("addressDisplayCheck_PaysFieldValue"+PaysFieldValue)
   console.log("addressDisplayCheck_labelSelected: "+labelSelected)
   
   this.omniUpdateDataJson({PaysName: labelSelected});


    if (labelSelected == 'Maroc') {

        if(this.template.querySelector(`[data-theid="Region"]`))
            this.template.querySelector(`[data-theid="Region"]`).style.display = "block";

        if(this.template.querySelector(`[data-theid="Ville"]`)){
            this.template.querySelector(`[data-theid="Ville"]`).style.display = "block";

        }

        console.log("addressDisplayCheck_isMaroc_this.isToSpecify "+this.isToSpecify)

        if(this.isToSpecify){
            if(this.template.querySelector(`[data-theid="PrecisionQuartier"]`))
                this.template.querySelector(`[data-theid="PrecisionQuartier"]`).style.display = "block";
        }
        else{
            if(this.template.querySelector(`[data-theid="Quartier"]`))
                this.template.querySelector(`[data-theid="Quartier"]`).style.display = "block";
        }
            
      } else {

    if(this.template.querySelector(`[data-theid="Region"]`))
        this.template.querySelector(`[data-theid="Region"]`).style.display = "none";

    if(this.template.querySelector(`[data-theid="Ville"]`)){
        this.template.querySelector(`[data-theid="Ville"]`).style.display = "none";
        this.template.querySelector(`[data-theid="Ville"]`).value = "null";
        this.omniUpdateDataJson({CityName: ' '});

    }
        this.template.querySelector(`[data-theid="Ville"]`).style.display = "none";

    if(this.template.querySelector(`[data-theid="Quartier"]`))
        this.template.querySelector(`[data-theid="Quartier"]`).style.display = "none";

    if(this.template.querySelector(`[data-theid="PrecisionQuartier"]`))
        this.template.querySelector(`[data-theid="PrecisionQuartier"]`).style.display = "none";


    
/*
        this.omniUpdateDataJson({ Region: "null" });
        this.omniUpdateDataJson({ Ville: "null" });
        this.omniUpdateDataJson({ Quartier: "null" });
        this.omniUpdateDataJson({ PrecisionQuartier: "" });
        this.omniUpdateDataJson({ RegionName: "null" });
        this.omniUpdateDataJson({ CityName: "null" });
  
        // this.RegionValues = [];
        //  this.VilleValues = [];
        this.QuartierValues = [];
  
        this.template.querySelector(`[data-theid="Region"]`).value =
          "sélectionnez une ville";
        this.template.querySelector(`[data-theid="Ville"]`).value = "";
        this.template.querySelector(`[data-theid="Quartier"]`).value = null;
  
        //   this.template.querySelector(`[data-theid="Region"]`).placeholder = 'sélectionnez un pays';
        this.template.querySelector(`[data-theid="Ville"]`).placeholder =
          "sélectionnez une ville";
        this.template.querySelector(`[data-theid="Quartier"]`).placeholder =
          "sélectionnez une ville";
  
        this.template.querySelector(`[data-theid="Region"]`).style.display =
          "none";
        this.template.querySelector(`[data-theid="Ville"]`).style.display =
          "none";
        this.template.querySelector(`[data-theid="Quartier"]`).style.display =
          "none";


     */
      }  
   } catch (error) {
    console.error("addressDisplayCheck_error: "+error)
   }

  }
  
  columnsNotesDisplay = [
    { label: "Titre", fieldName: "Title", hideDefaultActions: true },
    {
      label: "Description",
      fieldName: "TextPreview",
      hideDefaultActions: true,
    },
    {
      label: "Date de Creation",
      fieldName: "CreatedDate",
      hideDefaultActions: true,
    },
    { label: "Created by", fieldName: "CreatedBy", hideDefaultActions: true },
  ];

  columnsSubscriprtion = [
    { label: "MDN", fieldName: "mdn_subscription", hideDefaultActions: true },
    {
      label: "ESN/ICC",
      fieldName: "ESN_ICC_subscription",
      hideDefaultActions: true,
    },
    {
      label: "Article",
      fieldName: "ARTICLE_subscription",
      hideDefaultActions: true,
    },
    { label: "AKEY", fieldName: "akey_subscription", hideDefaultActions: true },
    { label: "IMSI", fieldName: "IMSI_subscription", hideDefaultActions: true },
    {
      label: "Solde Initial",
      fieldName: "SoldeInitial_subscription",
      hideDefaultActions: true,
    },
    {
      label: "Profil",
      fieldName: "profil_subscription",
      hideDefaultActions: true,
    },
    {
      label: "Numero Terminal",
      fieldName: "NumTerminal_subscription",
      hideDefaultActions: true,
    },
    {
      label: "date CRM",
      fieldName: "dateCRM_subscription",
      hideDefaultActions: true,
    },
  ];

  _Testing_changePro() {
    if (this.usedprofile === "procheck") this.usedprofile = "distributeur";
    else this.usedprofile = "procheck";
  }

  // field enabled in the procheck case
  get type0field() {
    if (this.usedprofile === "readOnly") return true;

    return this.usedprofile === "procheck" &&
    this.thecontract.statusContract != "Dossier conforme"
      ? false
      : true;
  }

  // field enabled in the distributeur case
  get type1field() {
    if (this.usedprofile === "readOnly") return true;

    return this.usedprofile === "distributeur" &&
    this.thecontract.statusContract != "Dossier conforme"
      ? false
      : true;
  }

  get alwaysEditable() {
    if (this.usedprofile === "readOnly") return true;
    return this.thecontract.statusContract === "Dossier conforme"
      ? true
      : false;
  }

  get isProcheck() {
    if (this.usedprofile === "readOnly") return true;

    return this.usedprofile === "procheck" ? true : false;
  }

  get isReadOnly() {
    return this.usedprofile === "readOnly" ? true : false;
  }
  hasAddress;
  __thecontract;
  @api
  get thecontract() {
    this.hasAddress =
      typeof this.__thecontract.address == "undefined" ? false : true;

    return this.__thecontract;
  }
  set thecontract(value) {
    this.__thecontract = { ...value };
  }

  @api sumofcontracts;
  @api usedprofile;

  connectedCallback() {
    //start déplacement de code  by Badr aissouni le 03/04/2024
    
    this.addressDisplayCheck();
    //end déplacement de code  by Badr aissouni le 03/04/2024

    
    // PDV picklist code

    try {
      let inputPDV =
        '{"MapItems": [{"FilterOperator__c": "=","InterfaceFieldAPIName__c": "ParentId","FilterValue__c": "distribId","DomainObjectFieldAPIName__c": "pointdv","InterfaceObjectName__c": "Account","InterfaceObjectLookupOrder__c": 1},{"DomainObjectCreationOrder__c": 1,"DomainObjectAPIName__c": "JSON","InterfaceFieldAPIName__c": "pointdv:Id","DomainObjectFieldAPIName__c": "name"},{"DomainObjectCreationOrder__c": 1,"DomainObjectAPIName__c": "JSON","InterfaceFieldAPIName__c": "pointdv:Name","DomainObjectFieldAPIName__c": "value"}],"DRParams": {"distribId": "' +
        this.thecontract.Distributeur_CMD +
        '"}}';

      this.fetchPicklistValues("pdv", inputPDV);
    } catch (error) {
      console.log("error pdv : " + error);
    }

    // address code
    // Déplaçement vers le Contsucteur
    // if (this.PaysValues.length == 0) {
    //   let inp =
    //     '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Pays__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}';

    //   this.fetchPicklistValues("pays", inp);
    // }
    // if (this.VilleValues.length == 0) {
    //   let inpputVille =
    //     '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}';
    //   this.fetchPicklistValues("ville", inpputVille);
    // }

    // if (this.v != null) {
    //   let inp =
    //     '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' +
    //     this.v +
    //     '"}}';
    //   this.omniUpdateDataJson({ Quartier: this.q });

    //   this.fetchPicklistValues("quartier", inp);
    // }

    // if (this.p != null) this.omniUpdateDataJson({ Pays: this.valuePays });
    // if (this.v != null) {
    //   this.setRegionInfo(this.v);
    //   this.omniUpdateDataJson({ Ville: this.v });
    // }

    // fin address code

    //////console.log('connectedCallback')
    // this._actionUtilClass = new OmniscriptActionCommonUtil();

    // const params = {
    //   input: "{}",
    //   sClassName: "inwiB2C_ContractPickListManagement",
    //   sMethodName: "gePicklistValues",
    //   options: "{}",
    // };

    // this._actionUtilClass
    //   .executeAction(params, null, this, null, null)
    //   .then(response => {
    //     ////////console.log('response.result')
    //     ////////console.log(response.result)
    //     this.picklistvalues = response.result.picklistValues;
    //   })
    //   .catch(error => {
    //     window.console.log(error);
    //     //

    //     console.log(error);
    //   });
      // End Déplacement vers le ctor


    this.retrieveNotes();
  }

  NotesToDisplay = [];
  retrieveNotes() {
    //////console.log('start retrieveNotes')
    const paramsNotesCall = {
      input: '{"recordId":"' + this.thecontract.idRecord + '"}',
      sClassName: "inwiB2C_NotesManagement",
      sMethodName: "getNotes",
      options: "{}",
    };

    this._actionUtilClass
      .executeAction(paramsNotesCall, null, this, null, null)
      .then(response => {
        this.NotesToDisplay = JSON.parse(
          JSON.stringify(response.result.AllNotes)
        );
      })
      .catch(error => {
        console.log("error2 : " + error);
      });
  }

  renderedCallback() {
    if (this._toSave == null && this.hasAddress)
      this._toSave = {
        IdAddress: this.thecontract.address.addressId,
        //  "Region": this.thecontract.address.Region,
        //  "Pays": this.thecontract.address.Pays,
        //  "Ville": this.thecontract.address.Ville
      };

    if (this._CityInfo == null && this.hasAddress)
      this._CityInfo = {
        RegionName: this.thecontract.address.RegionName,
        RegionId: this.thecontract.address.Region,
      };
  }

  addNote(event) {
    let titreNote = this.template.querySelector(`[data-theid="titreNote"]`);
    let bodyNote = this.template.querySelector(`[data-theid="bodyNote"]`);

    let theinput = {
      recordId: this.thecontract.idRecord,
      title: titreNote.value,
      body: bodyNote.value,
    };

    const paramsNotesCall = {
      input: JSON.stringify(theinput),
      sClassName: "inwiB2C_NotesManagement",
      sMethodName: "createNote",
      options: "{}",
    };

    this._actionUtilClass
      .executeAction(paramsNotesCall, null, this, null, null)
      .then(response => {
        //////console.log('response : ');
        //////console.log(response);
        this.retrieveNotes();
      })
      .catch(error => {
        console.log("error2 : " + error);
      });
  }

  saveandgenerate() {
    this.savecontract();
  }

  _CityInfo;
  get CityInfo() {
    return this.__CityInfo;
  }
  set CityInfo(value) {
    this.__CityInfo = { ...value };
  }

  VilleChanged(event) {
    // //////console.log('start VilleChanged');

    try {
      this.villeId = event.detail.value[0];

      ////console.log('this.villeId: ' + this.villeId)
      //////console.log(this.villeId)

      //////console.log('typeof this.villeId: ')
      //////console.log(typeof this.villeId)

      if (typeof this.villeId != "undefined") {
        let input = '{"theId": "' + this.villeId + '"}';
        const params = {
          input: input,
          sClassName: `${this._ns}IntegrationProcedureService`,
          sMethodName: "inwib2c_InwiB2C_getInfoCity",
          options: input,
        };
        this._actionUtilClass
          .executeAction(params, null, this, null, null)
          .then(response => {
            ////console.log('in response ')
            ////console.log(response)

            //  //////console.log(response.result.IPResult)
            if (response.error == false) {
              this.CityInfo = response.result.IPResult.theCity;
              this.toSave["Region"] = response.result.IPResult.theCity.RegionId;
              this.toSave["Ville"] = this.villeId;
              let tempContract = JSON.parse(JSON.stringify(this.thecontract));
              tempContract.address.RegionName = this.CityInfo.RegionName;
              this.thecontract = JSON.parse(JSON.stringify(tempContract));

              //////console.log('in if call this.toSave: ')
              //////console.log(this.toSave)
            }
          })
          .catch(error => {
            console.log("error: " + error);
          });
      } else {
        this.toSave["Region"] = "null";
        this.toSave["Ville"] = "null";
        let tempContract = JSON.parse(JSON.stringify(this.thecontract));
        tempContract.address.RegionName = "sélectionnez une ville";
        this.thecontract = JSON.parse(JSON.stringify(tempContract));
        //////console.log('In else call this.toSave: ')
        //////console.log(this.toSave)
      }
    } catch (error) {
      console.log("error: " + error);
    }
  }

  _toSave;
  set toSave(value) {
    this._toSave = { ...value };
  }
  get toSave() {
    return this._toSave;
  }

  changeStatutContrat(event) {
    let StatutContrat = this.template.querySelector(
      `[data-theid="StatusContract"]`
    );
    let Motif_de_non_conformit = this.template.querySelector(
      `[data-theid="Motifnonconformite"]`
    );

    let temp = { confirmiteValue: StatutContrat.value };
    this.omniUpdateDataJson(temp);
    this.omniSaveState(temp, true);

    ////////console.log('StatutContrat.value: ' + StatutContrat.value)
    if (StatutContrat.value == "Dossier non-conforme")
      Motif_de_non_conformit.style.display = "block";
    else Motif_de_non_conformit.style.display = "none";

    this.addToSave(event);
  }
  addToSave(event) {
    let theid = event.target.dataset.theid;
    let value =
      event.target.dataset.theid == "Pays" ||
      event.target.dataset.theid == "Quartier"
        ? event.detail.value[0]
        : event.detail.value;

    if (theid == "StatusContract")
      this.toSave["DateChangementStatutPhysique"] =
        new Date().getFullYear() +
        "-" +
        String(new Date().getMonth() + 1).padStart(2, "0") +
        "-" +
        String(new Date().getDate()).padStart(2, "0");

    if (value == "undefined" || value == null || value == "") value = "";

    if (theid == "PointVente")
      try {
        this.toSave["PointVenteLabel"] = this.Point_de_vente_Options.find(
          opt => opt.value === event.detail.value
        ).label;
      } catch (error) {
        console.error("PointVente_error" + error);
      }



      if (theid == "DateDeNaissance")
        try {
          
          this.toSave[theid] = value.substring(8) + "/" + value.substring(5,7) +"/" +value.substring(0,4);
          return;

        } catch (error) {
          console.error("DateDeNaissance_error" + error);
        }


    ////console.log('after theid: ' + theid)
    //console.log('after value: ' + value)

    this.toSave[theid] = value;
  }

  savecontract(event) {
      console.log("savecontract s")
    const isInputsCorrect = [
      ...this.template.querySelectorAll("lightning-combobox"),
      ...this.template.querySelectorAll("lightning-input"),
    ].reduce((validSoFar, inputField) => {
      inputField.reportValidity();
      return validSoFar && inputField.checkValidity();
    }, true);

    // let isAddressValid = (this.template.querySelector(`[data-theid="Pays"]`).value == '' || this.template.querySelector(`[data-theid="Ville"]`).value == '') ? false : true;

    //  ////console.log('isAddressValid: ' + isAddressValid) && isAddressValid

    

    console.log("savecontract_data-theid=Ville.val "+this.template.querySelector(`[data-theid="Ville"]`).value)
    console.log("savecontract_isInputsCorrect "+isInputsCorrect)

    if (isInputsCorrect) {
      try {
        let fieldToClear = [];
        for (const item in this.toSave) {
          if (this.toSave[item] == "") {
            let temp = "";
            switch (item) {
              case "Commentaire":
                temp = "InwiB2C_Commentaires__c";
                break;
              case "RegistreCommerce":
                temp = "InwiB2C_Registre_de_commerce__c";
                break;

              case "Patente":
                temp = "InwiB2C_Patente__c";
                break;

              case "Entreprise":
                temp = "InwiB2C_Entreprise__c";
                break;

              case "Profession":
                temp = "inwiB2C_Profession__c";
                break;

              case "TelephoneContact":
                temp = "InwiB2C_Telephone_contact__c";
                break;

              case "Email":
                temp = "InwiB2C_Email__c";
                break;

              case "NLigne":
                temp = "InwiB2C_Telephone_contact__c";
                break;

              case "AncienNligne":
                temp = "InwiB2C_Ancien_n_de_ligne__c";
                break;

              case "CodeBaynShop":
                temp = "InwiB2C_Code_bayn_shop__c";
                break;

              default:
                temp = false;

                break;
            }
            if (temp) fieldToClear.push(temp);
          }
        }

        if (fieldToClear.length) {
          let input =
            '{"theid":"' +
            this.thecontract.idRecord +
            '","fieldsList":' +
            JSON.stringify(fieldToClear) +
            "}";
          let params = {
            input: JSON.parse(input),
            sClassName: "InwiB2C_ClearFieldValue",
            sMethodName: "resetValue",
            options: "{}",
          };
          this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
              //let respoStringified = JSON.parse(JSON.stringify(response));
            })
            .catch(error => {
              console.log(error);
              return null;
            });
        }
      } catch (error) {
        console.log("error::" + error);
      }

      if (event.target.dataset.theid == "saveandgenerate")
        this.toSave["generatePdf"] = true;
      else this.toSave["generatePdf"] = false;

      /*
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__webPage',
                    attributes: {
                        url:  '../apex/inwiB2C_ContractGeneration?contractid=' + this.thecontract.idRecord + '&isvivs=true'
                    }
                }).then(generatedUrl => { 
                    window.open(generatedUrl);
                });
        */

      this.omniUpdateDataJson(this.toSave);
      this.omniSaveState(this.toSave, true);

      this.omniNextStep();
    }
  }

  get acceptedFormats() {
    return [".pdf", ".png"];
  }

  gotopreviewsStep() {
    this.omniPrevStep();
  }

  // address code

  fetchPicklistValues(picklist, input) {
    //////console.log('start fetchPicklistValues')
    this._actionUtilClass = new OmniscriptActionCommonUtil();

    const params = {
      input: input,
      sClassName: "vlocity_cmt.DefaultFetchPicklistOptionsImpl",
      sMethodName: "fetchLookupOptions",
      options: "{}",
    };

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        //console.log('response')
        //console.log(response)

        //console.log('response.result.options')
        //console.log(response.result.options)
        let rs = [];
        //  //////console.log('Object.keys(empty).length : '+Object.keys(response.result.options).length )

        //  //////console.log('response.result.options')
        // //////console.log(response.result.options)

        //console.log('isArray')
        //console.log(Array.isArray(response.result.options))

        //console.log('ressss::')
        //console.log(response.result.options instanceof Object && response.result.options instanceof Array)

        //console.log('response.result.options).length::')
        //console.log(Object.keys(response.result.options).length)

        if (
          Object.keys(response.result.options).length == 0 &&
          picklist != "pdv"
        ) {
          //console.log('in case 0')

          //////console.log('start the empty case')
          let v = {
            label: "Aucun élément",
            value: "null",
          };
          rs.push(v);
        } else if (
          !Array.isArray(response.result.options) &&
          Object.keys(response.result.options).length != 0
        ) {
          //console.log('in case 1')
          let v = {
            label: response.result.options.value,
            value: response.result.options.name,
          };
          rs.push(v);
        } else if (
          Array.isArray(response.result.options) &&
          Object.keys(response.result.options).length > 1
        ) {
          //console.log('in case > 1')

          rs = response.result.options.map(element => {
            let temp = {};
            //   if (element.value == 'Maroc')
            temp["label"] = element.value;
            temp["value"] = element.name;
            return temp;
          });
        }

        if (picklist === "pays") {
          this.PaysValues = rs;
          let indexMaroc = this.PaysValues.findIndex(x => x.label === "Maroc");

          //////console.log('indexMaroc: ' + indexMaroc)
          //////console.log('this.PaysValues[indexMaroc]: ' + this.PaysValues[indexMaroc].value)
          this.omniUpdateDataJson({
            IdMaroc: this.PaysValues[indexMaroc].value,
          });
          if (!this.p)
            this.omniUpdateDataJson({
              Pays: this.PaysValues[indexMaroc].value,
            });
          if (this.valuePays == null) {
            if (!this.p) this.valuePays = this.PaysValues[indexMaroc].value;
            else {
              this.valuePays = this.p;
            }
          }
          this.IdMaroc = this.PaysValues[indexMaroc].value;

          this.PaysValues.splice(
            0,
            0,
            this.PaysValues.splice(indexMaroc, 1)[0]
          );
        } else if (picklist === "region") this.RegionValues = rs;
        else if (picklist === "ville") {
          this.VilleValues = rs;

          rs.sort((a, b) => {
            let nameA = a.label.toUpperCase(); // ignore upper and lowercase
            let nameB = b.label.toUpperCase(); // ignore upper and lowercase
            if (nameA < nameB) return -1;
            if (nameA > nameB) return 1;
            return 0;
          });

          //  ////console.log('t :')
          //  ////console.log(t)
        } else if (picklist === "quartier") {
          this.QuartierValues = rs;
          ////console.log('this.QuartierValues[0].value : '+ this.QuartierValues[0].value)
          if (this.QuartierValues[0].value == "null") {
            this.isToSpecify = true;
            this.template.querySelector(`[data-theid="Quartier"]`).placeholder =
              "Aucun élément à selectionner ";
          }
          if (this.QuartierValues.length != 1) {
            this.isToSpecify = false;
            this.template.querySelector(`[data-theid="Quartier"]`).placeholder =
              "sélectionnez un quartier ";
          }
        } else if (picklist === "pdv") {
          //console.log('in pdv')

          ////console.log('rs:')
          ////console.log(rs)
          /*
                                    let disVal = {
                                        "label": this.thecontract.Distributeur_CMD_Name,
                                        "value": this.thecontract.Distributeur_CMD
                                    }
                    */
          this.Point_de_vente_Options = [...rs];

          //console.log('this.Point_de_vente_Options:')
          //console.log(this.Point_de_vente_Options)

          ////console.log('end pdv')
        }
      })
      .catch(error => {
        console.log("error::: " + error);
      });

    //////console.log('end fetchPicklistValues')
  }

  ChangePrecisionQuartier(event) {
    this.omniUpdateDataJson({ PrecisionQuartier: event.detail.value });
  }

  ChangePays(event) {
    console.log('ChangePays')


    
    let labelSelected = this.PaysValues.find(
      opt => opt.value === event.detail.value
    ).label;

    this.omniUpdateDataJson({ Pays: event.detail.value });
    this.omniUpdateDataJson({
        PaysName: labelSelected,
      });

    ////console.log('labelSelected: ' + labelSelected)

    if (labelSelected == "Maroc") {

        if(this.template.querySelector(`[data-theid="Region"]`))
        this.template.querySelector(`[data-theid="Region"]`).style.display = "block";

    if(this.template.querySelector(`[data-theid="Ville"]`)){
        this.template.querySelector(`[data-theid="Ville"]`).style.display = "block";
        this.template.querySelector(`[data-theid="Ville"]`).value = null;

    }

    console.log("addressDisplayCheck_isMaroc_this.isToSpecify "+this.isToSpecify)

    if(this.isToSpecify){
        if(this.template.querySelector(`[data-theid="PrecisionQuartier"]`))
            this.template.querySelector(`[data-theid="PrecisionQuartier"]`).style.display = "block";
    }
    else{
        if(this.template.querySelector(`[data-theid="Quartier"]`))
            this.template.querySelector(`[data-theid="Quartier"]`).style.display = "block";
    }

/*
      this.template.querySelector(`[data-theid="Region"]`).style.display =
        "block";
      this.template.querySelector(`[data-theid="Ville"]`).style.display =
        "block";
      this.template.querySelector(`[data-theid="Quartier"]`).style.display =
        "block";*/
    } else {
      this.omniUpdateDataJson({ Region: "null" });
      this.omniUpdateDataJson({ Ville: "null" });
      this.omniUpdateDataJson({ Quartier: "null" });
      this.omniUpdateDataJson({ PrecisionQuartier: "" });
      this.omniUpdateDataJson({ RegionName: "null" });
      this.omniUpdateDataJson({ CityName: "null" });

      // this.RegionValues = [];
      //  this.VilleValues = [];
      this.QuartierValues = [];

      let Region= this.template.querySelector(`[data-theid="Region"]`);
      let Ville= this.template.querySelector(`[data-theid="Ville"]`);
      let Quartier= this.template.querySelector(`[data-theid="Quartier"]`);
      let PrecisionQuartier= this.template.querySelector(`[data-theid="PrecisionQuartier"]`);

          if(Region){
              console.log('isPaysMaroc_in Region')
              Region.value = "sélectionnez une ville";
              Region.style.display = "none";
          }

          if(Ville){
              console.log('isPaysMaroc_in Ville')
              this.omniUpdateDataJson({CityName: ' '});
        
              
              Ville.value = "null";
              Ville.style.display = "none";
              Ville.placeholder = "sélectionnez une ville"
          }
          
          if(Quartier){
              console.log('isPaysMaroc_in Quartier')
              Quartier.value = "";
              Quartier.style.display = "none";
              Quartier.placeholder = "sélectionnez une ville"
          }

          if(PrecisionQuartier){
              console.log('isPaysMaroc_in PrecisionQuartier')
              PrecisionQuartier.style.display = "none";
          }

          /*

      this.template.querySelector(`[data-theid="Region"]`).value =
        "sélectionnez une ville";
      this.template.querySelector(`[data-theid="Ville"]`).value = "";
      this.template.querySelector(`[data-theid="Quartier"]`).value = null;

      //   this.template.querySelector(`[data-theid="Region"]`).placeholder = 'sélectionnez un pays';
      this.template.querySelector(`[data-theid="Ville"]`).placeholder =
        "sélectionnez une ville";
      this.template.querySelector(`[data-theid="Quartier"]`).placeholder =
        "sélectionnez une ville";

      this.template.querySelector(`[data-theid="Region"]`).style.display =
        "none";
      this.template.querySelector(`[data-theid="Ville"]`).style.display =
        "none";
      this.template.querySelector(`[data-theid="Quartier"]`).style.display =
        "none";*/
    }

    //////console.log('start changing region values')
    /*
                let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Regions","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Country Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"Pays__c","InterfaceObjectName__c":"InwiB2C_Region__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Regions:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Regions:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Country Name":"' + event.detail.value + '"}}';
        
                this.fetchPicklistValues('region', inp)
        */
    //////console.log('end changing region values')
  }

  setRegionInfo(idVille) {
    let input = '{"theId": "' + idVille + '"}';
    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_getInfoCity",
      options: input,
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        // ////console.log('in response :')
        //   ////console.log(response)

        //  //////console.log(response.result.IPResult)
        if (response.error == false) {
          //   let CityInfo = response.result.IPResult.theCity;
          // let regionId = response.result.IPResult.theCity.RegionName;
          //////console.log('regionId: ' + regionId)
          //  ////console.log('response.result.IPResult.theCity: ')
          //  ////console.log(response.result.IPResult.theCity)

          this.template.querySelector(`[data-theid="Region"]`).value =
            response.result.IPResult.theCity.RegionName;
          this.omniUpdateDataJson({
            Region: response.result.IPResult.theCity.RegionId,
          });

          this.omniUpdateDataJson({
            PaysName: response.result.IPResult.theCity.PaysName,
          });
          this.omniUpdateDataJson({
            RegionName: response.result.IPResult.theCity.RegionName,
          });
          this.omniUpdateDataJson({
            CityName: response.result.IPResult.theCity.CityName,
          });
        }
      })
      .catch(error => {
        console.log("error: " + error);
      });
  }

  ChangeVille(event) {
    //////console.log('ChangeVille')
    //////console.log('start changing Quartier values')

    let selectedvilleId = event.detail.value;
    ////console.log('selectedvilleId: ' + selectedvilleId)

    this.omniUpdateDataJson({ Ville: selectedvilleId });
    this.omniUpdateDataJson({ Quartier: "null" });
    this.omniUpdateDataJson({ PrecisionQuartier: "" });

    this.QuartierValues = [];
    //this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';

    this.setRegionInfo(selectedvilleId);

    ////console.log('selectedvilleId: ' + selectedvilleId)
    let inp =
      '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' +
      selectedvilleId +
      '"}}';

    this.fetchPicklistValues("quartier", inp);

    //////console.log('end changing Quartier values')
  }

  ChangeQuartier(event) {
    //////console.log('ChangeQuartier')
    this.omniUpdateDataJson({ Quartier: event.detail.value });

    //  //////console.log('changing region values')
  }

  // fin address code


  constructor(){
    super();
    
    // Fetch the needed picklist values
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    
    const params = {
      input: "{}",
      sClassName: "inwiB2C_ContractPickListManagement",
      sMethodName: "gePicklistValues",
      options: "{}",
    };
    
    this._actionUtilClass
    .executeAction(params, null, this, null, null)
    .then(response => {
      ////////console.log('response.result')
      ////////console.log(response.result)
      this.picklistvalues = response.result.picklistValues;
    })
    .catch(error => {
      window.console.log(error);
      //
      
      console.log(error);
    });

    if (this.PaysValues.length == 0) {
      let inp =
      '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Pays__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}';
      
      this.fetchPicklistValues("pays", inp);
    }
    if (this.VilleValues.length == 0) {
      let inpputVille =
      '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}';
      this.fetchPicklistValues("ville", inpputVille);
    }
    
    if (this.v != null) {
      let inp =
      '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' +
      this.v +
      '"}}';
      this.omniUpdateDataJson({ Quartier: this.q });
      
      this.fetchPicklistValues("quartier", inp);
    }
    
    if (this.p != null) this.omniUpdateDataJson({ Pays: this.valuePays });
    if (this.v != null) {
      this.setRegionInfo(this.v);
      this.omniUpdateDataJson({ Ville: this.v });
    }
    
  }

  render() {
    this.addressDisplayCheck();

    return template;
  }
}