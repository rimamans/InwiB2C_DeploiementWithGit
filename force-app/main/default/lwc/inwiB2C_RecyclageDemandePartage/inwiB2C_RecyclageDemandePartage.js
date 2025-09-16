import { LightningElement, api, track, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_RecyclageDemandePartage.html";
import { NavigationMixin } from "lightning/navigation";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecord } from "lightning/uiRecordApi";

const fieldsToRetrieve = [
  "inwiB2C_demande_partage__c.InwiB2C_Statut_demande__c",
  "inwiB2C_demande_partage__c.InwiB2C_FirstName__c",
  "inwiB2C_demande_partage__c.InwiB2C_LastName__c",
  "inwiB2C_demande_partage__c.InwiB2C_Nationalid__c",
  "inwiB2C_demande_partage__c.InwiB2C_Operateur_Infrastructure__c",
  "inwiB2C_demande_partage__c.InwiB2C_Identifiant_CPE__c",
  "inwiB2C_demande_partage__c.InwiB2C_Commentaire__c",
  "inwiB2C_demande_partage__c.InwiB2C_numeroContact__c",
  //'inwiB2C_demande_partage__c.InwiB2C_rendezvous__c',
  "inwiB2C_demande_partage__c.InwiB2C_codeRoutage__c",
  "inwiB2C_demande_partage__c.InwiB2C_Code_Statut__c",
  "inwiB2C_demande_partage__c.InwiB2C_Commande_de_partage__c",
  "inwiB2C_demande_partage__c.InwiB2C_Province__c",
  "inwiB2C_demande_partage__c.InwiB2C_Commune__c",
  "inwiB2C_demande_partage__c.inwiB2C_Quartier__c",
  "inwiB2C_demande_partage__c.InwiB2C_Voie__c",
  "inwiB2C_demande_partage__c.InwiB2C_Numero_de_la_voie__c",
  "inwiB2C_demande_partage__c.InwiB2C_Numero_Partage__c",
  "inwiB2C_demande_partage__c.InwiB2C_nd_Attribut__c",
  "inwiB2C_demande_partage__c.InwiB2C_NumeroDesignation__c",
  "inwiB2C_demande_partage__c.CreatedDate",
  "inwiB2C_demande_partage__c.inwib2c_city__c",
  "inwiB2C_demande_partage__c.inwiB2C_district__c",
  "inwiB2C_demande_partage__c.inwib2c_street__c",
  "inwiB2C_demande_partage__c.inwib2c_projetid__c",
  "inwiB2C_demande_partage__c.inwib2c_building__c",
  "inwiB2C_demande_partage__c.inwib2c_longitude__c",
  "inwiB2C_demande_partage__c.inwib2c_latitude__c",
  "inwiB2C_demande_partage__c.InwiB2C_Compteur_recyclage__c",
  "inwiB2C_demande_partage__c.InwiB2C_Code_Province__c",
  "inwiB2C_demande_partage__c.InwiB2C_Code_Quartier__c",
  "inwiB2C_demande_partage__c.InwiB2C_Code_Voie__c",
  "inwiB2C_demande_partage__c.InwiB2C_Code_de_Numero_de_la_voie__c",
  "inwiB2C_demande_partage__c.InwiB2C_lineId__c",
  "inwiB2C_demande_partage__c.InwiB2C_Code_Commune__c",
  "inwiB2C_demande_partage__c.InwiB2C_Order__c",
  "inwiB2C_demande_partage__c.InwiB2C_Code_Motif__c"
];

export default class InwiB2C_RecyclageDemandePartage extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  @api recordid;
  @track vfRoot;

  record;
  error;

  address = "";
  //vfRoot = "https://inwi-b2c--uatevol.sandbox.my.site.com";
  //vfRoot = "https://inwi-b2c--uatevol--c.sandbox.vf.force.com";
  //LH MAJ B-14518 15/02/2025
  @track isSearchDone = false;



  @wire(getRecord, { recordId: "$recordid", fields: fieldsToRetrieve })
  wiredRecord({ error, data }) {
    if (data) {
      //console.log('data ', JSON.stringify(data))
      this.record = data;
      this.error = undefined;
      this._demande = this.initializeDemande();
    } else if (error) {
      console.log("error ", JSON.stringify(error));
      this.error = error;
      this.record = undefined;

      let message = "Unknown error";
      if (Array.isArray(error.body)) {
        message = error.body.map((e) => e.message).join(", ");
      } else if (typeof error.body.message === "string") {
        message = error.body.message;
      }
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error loading contact",
          message,
          variant: "error"
        })
      );
    }
  }

  getFieldValue(fieldApiName) {
    console.log(this.record?.fields?.[fieldApiName]?.value, fieldApiName);
    return this.record?.fields?.[fieldApiName]?.value //|| "";
  }

  _demande = {};

  get demande() {
    return this._demande;
  }

  // Method to initialize the demande object
  initializeDemande() {
    const fields = [
      "InwiB2C_Statut_demande__c",
      "InwiB2C_FirstName__c",
      "InwiB2C_LastName__c",
      "InwiB2C_Nationalid__c",
      "InwiB2C_Operateur_Infrastructure__c",
      "InwiB2C_Identifiant_CPE__c",
      "InwiB2C_Commentaire__c",
      "InwiB2C_numeroContact__c",
      //'InwiB2C_rendezvous__c',
      "InwiB2C_codeRoutage__c",
      "InwiB2C_Code_Statut__c",
      "InwiB2C_Commande_de_partage__c",
      "InwiB2C_Province__c",
      "InwiB2C_Commune__c",
      "inwiB2C_Quartier__c",
      "InwiB2C_Voie__c",
      "InwiB2C_Numero_de_la_voie__c",
      "InwiB2C_Numero_Partage__c",
      "InwiB2C_nd_Attribut__c",
      "InwiB2C_NumeroDesignation__c",
      "CreatedDate",
      "inwib2c_city__c",
      "inwiB2C_district__c",
      "inwib2c_street__c",
      "inwib2c_projetid__c",
      "inwib2c_building__c",
      "inwib2c_longitude__c",
      "inwib2c_latitude__c",
      "InwiB2C_Compteur_recyclage__c",
      "InwiB2C_Code_Province__c",
      "InwiB2C_Code_Quartier__c",
      "InwiB2C_Code_Voie__c",
      "InwiB2C_Code_de_Numero_de_la_voie__c",
      "InwiB2C_lineId__c",
      "InwiB2C_Code_Commune__c",
      "InwiB2C_Order__c",
      "InwiB2C_Code_Motif__c"
    ];

    this.getFieldValue("InwiB2C_Operateur_Infrastructure__c") == "IAM" &&  this.showaddsite();

    let demandeData = {
      id: this.recordid,
      address: `${this.getFieldValue("inwiB2C_Quartier__c")} ${this.getFieldValue("InwiB2C_Commune__c")} ${this.getFieldValue("InwiB2C_Province__c")}`,
      InwiB2C_rendezvous__c: this._demande["InwiB2C_rendezvous__c"] || null
    };

    // Dynamically add fields and their values to the object
    fields.forEach((field) => {
      demandeData[field] = this.getFieldValue(field);
    });
    demandeData.InwiB2C_Numero_de_la_voie__c = this.getFieldValue("InwiB2C_Numero_de_la_voie__c") || this.getFieldValue("InwiB2C_Code_de_Numero_de_la_voie__c")
    this._labelProvince = this.getFieldValue("InwiB2C_Province__c")
    this._labelCommune = this.getFieldValue("InwiB2C_Commune__c")
    this._labelQuartier = this.getFieldValue("inwiB2C_Quartier__c")
    this._labelVoie = this.getFieldValue("InwiB2C_Voie__c")
    this._labelNumVoie = this.getFieldValue("InwiB2C_Numero_de_la_voie__c") || this.getFieldValue("InwiB2C_Code_de_Numero_de_la_voie__c")

    this.isLoading = false;
    console.log(demandeData);
    return demandeData;
  }

  /* set demande(value){
    this.demande = value
  } */

  get isIamAdress() {
    return this.getFieldValue("InwiB2C_Operateur_Infrastructure__c") == "IAM";
  }
  get isOrangeAddress() {
    return (
      this.getFieldValue("InwiB2C_Operateur_Infrastructure__c") == "ORANGE"
    );
  }

  @track codeRoutageList;
  adresseSplitee = {};
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  @track proVilleOptions = [];
  @track quartierOptions = [];
  @track voieOptions = [];
  @track numeroVoieOptions = [];
  @track communesOptions = [];

  selectedProVille = "";
  selectedQuartier = "";
  selectedCommuneCode = "";
  selectedVoie = "";
  selectedNumeroVoie = "";
  selectedCommuneLibelle = "";
  address = "";

  //!!!!!!!!!!!!!!!!!!!!

  flagValider = true;
  flagSynchro = true;
  flagSearch = false;
  isLoading = true;
  showAddPropose = false;
  showAddIAM = false;
  showButtons = false;
  addIAMEmpty = false;

  provinceValues = [];
  ProvinceVille;
  operationName;
  communeValues = [];
  CommuneV;
  QuartierIAM;
  QuartierValuesIAM;
  VoieValues;
  Voie;
  Numerovoie;
  NumerovoieValues;
  batiment;
  porte;
  etage;
  escalier;
  //label
  //labelProvince;
 // labelCommune;
 // labelQuartier;
  //labelVoie;
  //labelNumVoie;


  _labelProvince

  get labelProvince() {
    return this._labelProvince;
  }
  set labelProvince(value){
    this._labelProvince = value;

  } 
  
  _labelCommune;
  get labelCommune() {
    return this._labelCommune;
  }
  set labelCommune(value) {
    this._labelCommune = value;

  }

  _labelQuartier;
  get labelQuartier() {
    return this._labelQuartier;
  }
  set labelQuartier(value) {
    this._labelQuartier = value;

  }

  _labelVoie;
  get labelVoie() {
    return this._labelVoie;
  }
  set labelVoie(value) {
    this._labelVoie = value;

  }

  _labelNumVoie;
  get labelNumVoie() {
    return this._labelNumVoie;
  }
  set labelNumVoie(value) {
    this._labelNumVoie = value;

  }

  //final values
  provinceCodeFinal;
  provinceLabelFinal;
  communeCodeFinal;
  communeLabelFinal;
  quartierCodeFinal;
  quartierLabelFinal;
  voieCodeFinal;
  voieLabelFinal;
  nvoieCodeFinal;
  nvoieLabelFinal;
  adresseSiteFinal;
  batimentFinal;
  etageFinal;
  escalierFinal;

  searchResultsProvince;
  searchResultsCommune;
  searchResultsQuartierIAM;
  searchResultsVoie;
  searchResultsNumVoies;
  @track selectedSearchResultProvince;
  @track selectedSearchResultCommune;
  @track selectedSearchResultQuartierIAM;
  @track selectedSearchResultVoie;
  @track selectedSearchResultNumVoies;
  disableCommune = true;
  disableQuartierIAM = true;
  disableVoie = true;
  disableNumVoie = true;

  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  @track mindate;
  @track maxdate;
  @track selector;
  @track disabled;
  dispSelectedDate;
  __showrendezvous;
  __minDateRecyclage;
  __maxDateRecyclage;
  __holidays = [];

  connectedCallback() {
    const currentOrigin = window.location.origin;
    console.log("current origin of the lwc is now", currentOrigin)

    /* if (currentOrigin.includes("site")) {
      this.vfRoot = "https://inwi-b2c--uatevol.sandbox.my.site.com";
    } else {
      this.vfRoot = "https://inwi-b2c--uatevol--c.sandbox.vf.force.com";
    } */


    const isProduction = !window.location.hostname.includes('sandbox');
    const isSite = window.location.hostname.includes('site');

    const baseUrl = isProduction 
      ? `https://inwi-b2c${isSite ? '.my.site.com' : '--c.vf.force.com' }`
      : (() => {
          const env = window.location.hostname.split('--')[1]?.split('.')[0] || 'uatevol';
          return `https://inwi-b2c--${env}${isSite ? '.sandbox.my.site.com' : '--c.sandbox.vf.force.com'}`;
        })();
    console.log('baseUrl: ' , baseUrl)
    this.vfRoot = baseUrl

    console.log("recordid ", this.recordid);
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this._actionUtil = new OmniscriptActionCommonUtil();
    //this.loadProvinces();
    //this.fetchPicklistIAM("province");
    this.operationName = "getProvinces";
    this.setcodeRoutage();
    this.getMinMaxRecyclageDateHolidays();
    window.addEventListener("message", (event) => {
      //LH MAJ B-14518 15/02/2025
      // if (event.origin !== this.vfRoot) {
      //   console.log("origin de l'event", event.origin);
      //   return;
      // }
      if (event.data && event.data.name === "VFtoLWC" && event.data.payload) {
        const { latitudeC, longitudeC } = event.data.payload;
        this.latitudeC = latitudeC;
        this.longitudeC = longitudeC;
        console.log("Central Coordonnées GPS from VF:", latitudeC, longitudeC);
      }else if (event.data && event.data.searchCompleted) {
        this.isSearchDone = true;
        console.log("Recherche terminée, isSearchDone mis à true.");
    }else if (
        event.data &&
        event.data.name === "CreateSharingRequest" &&
        event.data.payload
      ) {
        const {
          building,
          city,
          latitude,
          longitude,
          plateId,
          street,
          district
        } = event.data.payload;
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        this.demande["inwib2c_city__c"] = city
        this.demande["inwiB2C_district__c"] = district
        this.demande["inwib2c_street__c"] = street
        this.demande["inwib2c_projetid__c"] = plateId
        this.demande["inwib2c_building__c"] = building
        this.demande["inwib2c_longitude__c"] = longitude
        this.demande["inwib2c_latitude__c"] = latitude

        this.building = building;
        this.city = city;
        this.district = district;
        this.plateId = plateId;
        this.street = street;
        this.latitude = latitude;
        this.longitude = longitude;
        console.log(
          "Details of ORANGE Marker Selected from VF:",
          building,
          city,
          plateId,
          street,
          latitude,
          longitude,
          district
        );
      }
    });
  }

  setcodeRoutage() {
    let codes = [
      { label: "E2101", value: "E2101" },
      { label: "E3101", value: "E3101" }
    ];
    this.codeRoutageList = codes;
  }

  getMinMaxRecyclageDateHolidays() {
    const params = {
      input: "{}",
      sClassName: "inwiB2C_DemandePartageDateHandler",
      sMethodName: "calculateRecyclageDates",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("reponse", response);

        if (response?.result?.result) {
    
          this.__holidays = response.result?.holidays;

          const minDateRecyclage = new Date(response.result.result.minDateRecyclage);
          const maxDateRecyclage = new Date(response.result.result.maxDateRecyclage);

          console.log("Min Date (Raw):", minDateRecyclage);

          // Convert to local YYYY-MM-DDTHH:MM format
          const formatToLocalDateTime = (date) => {
            let year = date.getFullYear();
            let month = String(date.getMonth() + 1).padStart(2, '0');
            let day = String(date.getDate()).padStart(2, '0');
            let hours = String(date.getHours()).padStart(2, '0');
            let minutes = String(date.getMinutes()).padStart(2, '0');
            return `${year}-${month}-${day}T${hours}:${minutes}`;
          };

          this.__minDateRecyclage = formatToLocalDateTime(minDateRecyclage);
          this.__maxDateRecyclage = formatToLocalDateTime(maxDateRecyclage);

          console.log("Formatted Min Date:", this.__minDateRecyclage);
        }
      })
      .catch((error) => {
        window.console.log(error);
      });
  }

  showMessage(t, m, type) {
    const toastEvt = new ShowToastEvent({
      title: t,
      message: m,
      variant: type
    });
    this.dispatchEvent(toastEvt);
  }
  handleinputIAM(event) {
    this[event.target.name] = event.target.value;
  }

  handleSelection(event) {
    this.demande[event.target.name] = event.target.value;
    if(event.target.name === 'InwiB2C_Numero_de_la_voie__c'){
      if(event.target.value?.length <= 10){
        this.labelNumVoie = event.target.value;
        this.demande["InwiB2C_Code_de_Numero_de_la_voie__c"]  = event.target.value;
        this.demande["InwiB2C_Numero_de_la_voie__c"] = event.target.value;
      }
      else{
         this.flagValider = true
         event.target.value = ''
          this.labelNumVoie = ''
          this.demande["InwiB2C_Code_de_Numero_de_la_voie__c"] = ''
          this.demande["InwiB2C_Numero_de_la_voie__c"] = ''
         this.showMessage(
        "Erreur",
        `Le champ numéro de la voie ne peut contenir plus de 10 caractères.`,
        "error"
      );
      }
    } 
    if (
      this.isOrangeAddress &&
      this.demande["inwib2c_city__c"] &&
      this.demande["inwib2c_latitude__c"] &&
      this.demande["inwib2c_longitude__c"] && this.demande["InwiB2C_rendezvous__c"]
    )
      this.flagValider = false;

      if(this.isIamAdress && this.demande["InwiB2C_Numero_de_la_voie__c"] && this.demande["InwiB2C_rendezvous__c"]) this.flagValider = false;
  }

  handleRendezVous(event) {
    const dateTimeString = event.target.value; 
    const selectedDate = new Date(dateTimeString);
    const dayOfWeek = selectedDate.getDay(); 
    const formattedDate = selectedDate.toISOString().slice(0, 16)


    const date = new Date(event.target.value);

    console.log("rdv", date);
    console.log("formattedDate", formattedDate);

    let holidayTMP = [];
    for (let i = 0; i < this.__holidays?.length; i++) {
      const dateTMP = new Date(this.__holidays[i]);
      holidayTMP.push(
        dateTMP
          .toLocaleDateString("GMT", {
            year: "numeric",
            month: "numeric",
            day: "numeric"
          })
          ?.replace(/ /g, "-")
      );
    }
    console.log("holiday ", holidayTMP);
    console.log(
      date <= new Date(this.__minDateRecyclage),
      dayOfWeek === 6,
      dayOfWeek === 0,
      holidayTMP?.includes(formattedDate)
    );
    if (
      selectedDate < new Date(this.__minDateRecyclage) || // Before min date
      selectedDate > new Date(this.__maxDateRecyclage) || // After max date
      dayOfWeek === 6 || // Saturday
      dayOfWeek === 0 || // Sunday
      holidayTMP.includes(formattedDate.split("T")[0]) // Date is a holiday
    ) {
      this.flagValider = true;
      let minDate = new Date(this.__minDateRecyclage)
      let maxDate = new Date(this.__maxDateRecyclage)
      const minDateStr = minDate.toLocaleDateString("fr-FR"); // Format min date
      const maxDateStr = maxDate.toLocaleDateString("fr-FR"); // Format max date
      this.showMessage(
        "Erreur",
        `Merci de choisir un jour ouvré compris entre le ${minDateStr} et le ${maxDateStr}`,
        "error"
      );
    } else {
      if(this.isIamAdress ){ 
        if(this.demande["InwiB2C_Numero_de_la_voie__c"] && this.labelNumVoie) this.flagValider = false
      }
      else {this.flagValider = false; }
      this.demande["InwiB2C_rendezvous__c"] = formattedDate;
    }
  }

  showaddsite() {
    this.showAddIAM = true;
    this.fetchPicklistIAM("province");
    this.showButtons = true;
    this.flagValider = true;
  }

  fetchPicklistIAM(picklist) {
    let input;

    if (picklist == "province") {
      //input = '{"operation_name":"' + this.operationName + '"}';
      input = '{ "keyword": "", "search": "PROVINCES" }';
    } else if (picklist == "commune") {
      //input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '"}';
      input =
        '{"search":"COMMUNES","keyword":"", "codeProvince":"' +
        this.ProvinceVille +
        '"}';
      //   console.log('input',input);
    } else if (picklist == "getQuartiers") {
      //input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '"}';
      input =
        '{"search":"QUARTIERS","keyword":"","codeProvince":"' +
        this.ProvinceVille +
        '","codeCommune":"' +
        
        this.CommuneV +
        '"}';
      //  console.log('input',input);
    } else if (picklist == "getVoies") {
      //input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '"}';
      input =
        '{ "keyword": "", "search": "VOIES" ,"codeProvince":"' +
        this.ProvinceVille +
        '","codeCommune":"' +
        this.CommuneV +
        '","codeQuartier":"' +
        this.QuartierIAM +
        '"}';
      // console.log('input',input);
    } else if (picklist == "getNumVoies") {
      //input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '","way_code":"' + this.Voie + '"}';
      input =
        '{ "keyword": "", "search": "NUM_VOIES" ,"codeProvince":"' +
        this.ProvinceVille +
        '","codeCommune":"' +
        this.CommuneV +
        '","codeQuartier":"' +
        this.QuartierIAM +
        '","codeVoie":"' +
        this.Voie +
        '"}';
      // console.log('input',input);
    }
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("adddres response ", response);
        let rs = [];
        if (Object.keys(response.result.IPResult).length == 0) {
          let v = {
            label: "Aucun élément",
            value: "null"
          };
          rs.push(v);
        } else {
          rs = response.result.IPResult.results.map((element) => {
            let temp = {};
            //   if (element.value == 'Maroc')
            temp["label"] = element?.label || element?.libelle;
            temp["value"] = element.code   // element.code.split(":")[0] || element.code;
            if(picklist == "getQuartiers"){
              temp["commune"] = element?.commune?.code
            }
            return temp;
          });
        }

        if (picklist == "province") {
          // console.log('start picklist === province  :')

          this.provinceValues = rs;
          let t = rs.sort(function (a, b) {
            var nameA = a.label.toUpperCase(); // ignore upper and lowercase
            var nameB = b.label.toUpperCase(); // ignore upper and lowercase
            if (nameA < nameB) {
              return -1;
            }
            if (nameA > nameB) {
              return 1;
            }

            // names must be equal
            return 0;
          });

          //   console.log('t :')
          //  console.log(t)
        } else if (picklist == "commune") {
          //console.log('start picklist === commune  :')

          this.communeValues = rs;
          if (this.communeValues.length >= 1) {
            this.disableCommune = false;
          }
          let t = rs.sort(function (a, b) {
            var nameA = a.label.toUpperCase(); // ignore upper and lowercase
            var nameB = b.label.toUpperCase(); // ignore upper and lowercase
            if (nameA < nameB) {
              return -1;
            }
            if (nameA > nameB) {
              return 1;
            }

            // names must be equal
            return 0;
          });

          //  console.log('t :')
          //  console.log(t)
        } else if (picklist == "getQuartiers") {
          // console.log('start picklist === getQuartiers  :')

          this.QuartierValuesIAM = rs;
          if (this.QuartierValuesIAM.length >= 1) {
            this.disableQuartierIAM = false;
          }
          let t = rs.sort(function (a, b) {
            var nameA = a.label.toUpperCase(); // ignore upper and lowercase
            var nameB = b.label.toUpperCase(); // ignore upper and lowercase
            if (nameA < nameB) {
              return -1;
            }
            if (nameA > nameB) {
              return 1;
            }

            // names must be equal
            return 0;
          });

          //  console.log('t :')
          //  console.log(t)
        } else if (picklist == "getVoies") {
          // console.log('start picklist === getVoies  :')

          this.VoieValues = rs;

          if (this.VoieValues.length >= 1) {
            this.disableVoie = false;
          }
          let t = rs.sort(function (a, b) {
            var nameA = a.label.toUpperCase(); // ignore upper and lowercase
            var nameB = b.label.toUpperCase(); // ignore upper and lowercase
            if (nameA < nameB) {
              return -1;
            }
            if (nameA > nameB) {
              return 1;
            }

            // names must be equal
            return 0;
          });

          //  console.log('t :')
          //   console.log(t)
        } else if (picklist == "getNumVoies") {
          //console.log('start picklist === Numerovoie  :')

          this.NumerovoieValues = rs;
          if (this.NumerovoieValues.length >= 1) {
            this.disableNumVoie = false;
          }
          let t = rs.sort(function (a, b) {
            var nameA = a.label.toUpperCase(); // ignore upper and lowercase
            var nameB = b.label.toUpperCase(); // ignore upper and lowercase
            if (nameA < nameB) {
              return -1;
            }
            if (nameA > nameB) {
              return 1;
            }

            // names must be equal
            return 0;
          });

          //  console.log('t :')
          //  console.log(t)
        }
      })
      .catch((error) => {
        console.log("error : " + error);
      });
  }

  showPicklistOptionsProvince() {
    //this.positionClick = 'ProvinceInput';
    if (!this.searchResultsProvince) {
      this.searchResultsProvince = this.provinceValues;
    }
    this.searchResultsCommune = null;
    this.searchResultsQuartierIAM = null;
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
    //chb ano B-14518 27/02/2024
    this.ProvinceVille = null;
    this.labelProvince = null;
    this.flagValider = true
  }
  showPicklistOptionsCommune() {
    if (!this.searchResultsCommune) {
      this.searchResultsCommune = this.communeValues;
    }
    this.searchResultsQuartierIAM = null;
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
    //chb ano B-14518 27/02/2024
    this.CommuneV = null;
    this.labelCommune = null;
  }
  showPicklistOptionsQuartierIAM() {
    if (!this.searchResultsQuartierIAM) {
      this.searchResultsQuartierIAM = this.QuartierValuesIAM;
    }
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
    //chb ano B-14518 27/02/2024
    this.QuartierIAM = null;
    this.labelQuartier = null;
  }
  showPicklistOptionsVoie() {
    if (!this.searchResultsVoie) {
      this.searchResultsVoie = this.VoieValues;
    }
    this.searchResultsNumVoies = null;
    //chb ano B-14518 27/02/2024
    this.Voie = null;
    this.labelVoie = null;
  }
  showPicklistOptionsNumVoies() {
    if (!this.searchResultsNumVoies && this.NumerovoieValues.length > 1) {
      this.searchResultsNumVoies = this.NumerovoieValues;
    }
    //chb ano B-14518 27/02/2024
    this.Numerovoie = null;
    this.labelNumVoie = null;
  }
  handleKeyPress(event) {
    if (event.key === "Enter" || event.key === "Return") {
      // Clear your list here
      this.searchResultsNumVoies = null;
    }
  }

  GetProvince(event) {
    /* this.ProvinceVille= event.detail.value;
     this.labelProvince=this.provinceValues.find(opt => opt.value === event.detail.value).label;
     this.operationName='getCommunes';
     this.fetchPicklistIAM('commune');*/
    const input = event.detail.value.toLowerCase();
    const result = this.provinceValues.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsProvince = result;
    this.searchResultsQuartierIAM = null;
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
    this.fetchPicklistIAM("commune");
  }

  selectSearchResultProv(event) {
    this.ProvinceVille = null;
    this.labelProvince = null;
    const selectedValueProv = event.currentTarget.dataset.value;
    this.selectedSearchResultProvince = this.provinceValues.find(
      (picklistOption) => picklistOption.value === selectedValueProv
    );
    this.ProvinceVille = selectedValueProv;
    this.demande["InwiB2C_Code_Province__c"] = selectedValueProv;
    this.demande["InwiB2C_Province__c"] = this.provinceValues.find(
      (opt) => opt.value === selectedValueProv
    ).label;
    this.labelProvince = this.provinceValues.find(
      (opt) => opt.value === selectedValueProv
    ).label;
    console.log("this.ProvinceVilleLabel:", this.labelProvince);

    ///quartier
    this.labelQuartier = "";
    this.QuartierIAM = "";
    this.Voie = "";
    this.labelVoie = "";
    this.Numerovoie = "";
    this.labelNumVoie = "";
    this.disableQuartierIAM = true;
    this.disableVoie = true;
    this.disableNumVoie = true;

    ///
    this.CommuneV = "";
    this.labelCommune = "";
    this.disableCommune = true;
  
    this.communeValues = [];
    this.QuartierValuesIAM = [];

    this.flagSearch = true;


    this.operationName = "getQuartiers";
    this.fetchPicklistIAM("getQuartiers");
    this.clearSearchResultsCommune();

    /// commune

    this.operationName = "getCommunes";
    this.fetchPicklistIAM("commune");
    this.clearSearchResultsProvince();
  }
  GetCommune(event) {
    /*this.CommuneV= event.detail.value;
    this.labelCommune=this.communeValues.find(opt => opt.value === event.detail.value).label;
    this.operationName='getQuartiers';
    this.fetchPicklistIAM('getQuartiers');*/
    const input = event.detail.value.toLowerCase();
    const result = this.communeValues.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsCommune = result;

    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
    this.handleDocumentClick;
  }
  selectSearchResultCommune(event) {
    this.CommuneV = null;
    this.labelCommune = null;
    const selectedValueComm = event.currentTarget.dataset.value;
    this.demande["InwiB2C_Code_Commune__c"] = selectedValueComm;
    this.selectedSearchResultCommune = this.communeValues.find(
      (picklistOption) => picklistOption.value === selectedValueComm
    );
    this.demande["InwiB2C_Commune__c"] = this.communeValues.find(
      (opt) => opt.value === selectedValueComm
    ).label;
    this.CommuneV = selectedValueComm;
    this.labelCommune = this.communeValues.find(
      (opt) => opt.value === selectedValueComm
    ).label;
    this.labelQuartier = "";
    this.QuartierIAM = "";
    this.Voie = "";
    this.labelVoie = "";
    this.Numerovoie = "";
    this.labelNumVoie = "";
    this.disableQuartierIAM = true;
    this.disableVoie = true;
    this.disableNumVoie = true;
    this.flagSearch = true;
    this.operationName = "getQuartiers";
    this.fetchPicklistIAM("getQuartiers");
    this.clearSearchResultsCommune();
  }

  GetQuartier(event) {
    /*this.QuartierIAM= event.detail.value;
    this.labelQuartier=this.QuartierValuesIAM.find(opt => opt.value === event.detail.value).label;
    this.operationName='getVoies';
    this.fetchPicklistIAM('getVoies'); */
    const input = event.detail.value.toLowerCase();
    const result = this.QuartierValuesIAM.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsQuartierIAM = result;
  }
  selectSearchResultQuartierIAM(event) {
    this.QuartierIAM = null;
    this.labelQuartier = null;
    this.CommuneV = null;
    this.labelCommune = null;
    const selectedValueQuartierIAM = event.currentTarget.dataset.value;
    this.demande["InwiB2C_Code_Quartier__c"] = selectedValueQuartierIAM.split(":")[0] || selectedValueQuartierIAM;
    this.demande["inwiB2C_Quartier__c"] = this.QuartierValuesIAM.find(
      (opt) => opt.value === selectedValueQuartierIAM
    ).label;
    this.selectedSearchResultQuartierIAM = this.QuartierValuesIAM.find(
      (picklistOption) => picklistOption.value === selectedValueQuartierIAM
    );
    this.QuartierIAM = selectedValueQuartierIAM.split(":")[0] || selectedValueQuartierIAM;;
    this.labelQuartier = this.QuartierValuesIAM.find(
      (opt) => opt.value === selectedValueQuartierIAM
    ).label;
    /// set commune

  console.log(this.QuartierValuesIAM.find(
      (opt) => opt.value === selectedValueQuartierIAM
    ))
    
   let selectedValueComm =  this.selectedSearchResultQuartierIAM?.commune; 

    console.log(selectedValueComm)

   this.CommuneV = selectedValueComm
    this.demande["InwiB2C_Code_Commune__c"] = selectedValueComm;
    
     this.selectedSearchResultCommune = this.communeValues?.find(
      (picklistOption) => picklistOption.value === selectedValueComm
    );

    this.demande["InwiB2C_Commune__c"] = this.communeValues?.find(
      (opt) => opt.value === selectedValueComm
    )?.label;

    this.labelCommune = this.communeValues?.find(
      (opt) => opt.value === selectedValueComm
    )?.label; 

    console.log( this.communeValues?.find(
      (opt) => opt.value === selectedValueComm
    )?.label)

    ///
    this.Voie = "";
    this.labelVoie = "";
    this.Numerovoie = "";
    this.labelNumVoie = "";
    this.disableVoie = true;
    this.disableNumVoie = true;
    this.flagSearch = true;
    this.operationName = "getVoies";
    this.fetchPicklistIAM("getVoies");
    this.clearSearchResultsQuartierIAM();
  }
  getVoies(event) {
    /*this.Voie= event.detail.value;
    this.labelVoie=this.VoieValues.find(opt => opt.value === event.detail.value).label;
    this.operationName='getNumVoies';
    this.fetchPicklistIAM('getNumVoies'); */
    const input = event.detail.value.toLowerCase();
    const result = this.VoieValues.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsVoie = result;
  }
  selectSearchResultVoie(event) {
    this.Voie = null;
    this.labelVoie = null;
    const selectedValueVoie = event.currentTarget.dataset.value;
    this.demande["InwiB2C_Code_Voie__c"] = selectedValueVoie;
    this.demande["InwiB2C_Voie__c"] = this.VoieValues.find(
      (opt) => opt.value === selectedValueVoie
    ).label;
    this.selectedSearchResultVoie = this.VoieValues.find(
      (picklistOption) => picklistOption.value === selectedValueVoie
    );
    this.Voie = selectedValueVoie;
    this.labelVoie = this.VoieValues.find(
      (opt) => opt.value === selectedValueVoie
    ).label;
    this.disableNumVoie = false;
    //this.operationName = "getNumVoies";
    //this.fetchPicklistIAM("getNumVoies");
    this.flagSearch = false;
    this.Numerovoie = "";
    this.labelNumVoie = "";
    this.clearSearchResultsVoie();
  }
  getNumVoies(event) {
    /*this.Numerovoie= event.detail.value;
    this.labelNumVoie=this.NumerovoieValues.find(opt => opt.value === event.detail.value).label;*/
    const input = event.detail.value.toLowerCase();
    const result = this.NumerovoieValues.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsNumVoies = result;
    this.flagSearch = false;
  }
  selectSearchResultNumVoies(event) {
    this.Numerovoie = null;
    this.labelNumVoie = null;
    const selectedValueNumVoies = event.currentTarget.dataset.value;
    this.selectedSearchResultNumVoies = this.NumerovoieValues.find(
      (picklistOption) => picklistOption.value === selectedValueNumVoies
    );

    this.Numerovoie = selectedValueNumVoies;
    this.demande["InwiB2C_Code_de_Numero_de_la_voie__c"] =
      selectedValueNumVoies;
    this.labelNumVoie = this.NumerovoieValues.find(
      (opt) => opt.value === selectedValueNumVoies
    ).label;
    this.demande["InwiB2C_Numero_de_la_voie__c"] = this.NumerovoieValues.find(
      (opt) => opt.value === selectedValueNumVoies
    ).label;
    this.flagSearch = false;
    console.log("labelNumVoie", this.labelNumVoie);

    this.clearSearchResultsNumVoies();
  }

  clearSearchResultsProvince() {
    this.searchResultsProvince = null;
  }
  clearSearchResultsCommune() {
    this.searchResultsCommune = null;
  }
  clearSearchResultsQuartierIAM() {
    this.searchResultsQuartierIAM = null;
  }
  clearSearchResultsVoie() {
    this.searchResultsVoie = null;
  }
  clearSearchResultsNumVoies() {
    this.searchResultsNumVoies = null;
  }
  /*chb 25/09/2024 B-20681 begin */
  handleKeyDown(event) {
    // Récupérer le code de la touche pressée
    const key = event.key;

    // Bloquer tout caractère non numérique
    if (
      !/^[0-9]$/.test(key) &&
      key !== "Backspace" &&
      key !== "ArrowLeft" &&
      key !== "ArrowRight"
    ) {
      event.preventDefault(); // Bloque la saisie de caractères non numériques
    }
  }

  valider() {
    this.isLoading = true
    let formatdate = new Date(this.demande['InwiB2C_rendezvous__c'])
    this.demande['InwiB2C_rendezvous__c'] = formatdate?.toISOString()?.replace(/\.\d{3}Z$/, '.000Z');
    console.log("validate(this.demande) ", this.demande);
    let newCommandePartage;
    let methodeName;
    let procedureName;

    const params = {
      input: `{"lwcDemande": ${JSON.stringify(this.demande)} }`,
      sClassName: "inwiB2C_RecyclageDemandePartage",
      sMethodName: "RecycleDemandePartage",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("reponse", response);

        if (response?.result?.result) {
          methodeName = response?.result?.result?.methodeName
          newCommandePartage = response?.result?.result?.newCommandePartage
          procedureName = response?.result?.result?.procedureName
          //this.omniUpdateDataJson({ ...response?.result?.result });
          //this.omniNextStep();
          const params1 = {
            input: `${JSON.stringify(response?.result?.result?.apiIpInput)}`,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: procedureName,
            options: "{}"
          };
          this._actionUtilClass
            .executeAction(params1, null, this, null, null)
            .then((response) => {
              console.log("reponse", response);

              if (response?.result.IPResult) {
                //this.omniUpdateDataJson({ ...response?.result?.result });
                //this.omniNextStep();
                const params2 = {
                  input: `{"lwcData": ${JSON.stringify(this.demande)} , "methodeName": "${methodeName}" , "newCommandePartage": "${newCommandePartage}" , "apiResult":${JSON.stringify(response?.result.IPResult)}}`,
                  sClassName: "inwiB2C_RecyclageDemandePartage",
                  sMethodName: "continueAfterAPICall",
                  options: "{}"
                };
                this._actionUtilClass
                  .executeAction(params2, null, this, null, null)
                  .then((response) => {
                    console.log("reponse", response);

                    if (response?.result?.result) {
                      this.isLoading = false
                      this.omniUpdateDataJson({ ...response?.result?.result });
                      this.omniNextStep();


                    }
                    else {
                      this.isLoading = false
                      this.dispatchEvent(
                        new ShowToastEvent({
                          title: 'Erreur',
                          message: 'Error',
                          variant: 'error'
                        }),
                      );
                    }
                  })
                  .catch((error) => {
                    this.isLoading = false
                    this.dispatchEvent(
                      new ShowToastEvent({
                        title: 'Erreur',
                        message: error,
                        variant: 'error'
                      }),
                    );
                    window.console.log(error);
                  });

              }
              else {
                this.isLoading = false
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Error',
                    variant: 'error'
                  }),
                );
              }
            })
            .catch((error) => {
              this.isLoading = false
              this.dispatchEvent(
                new ShowToastEvent({
                  title: 'Erreur',
                  message: error,
                  variant: 'error'
                }),
              );
              window.console.log(error);
            });

        }
        else{
          this.isLoading = false
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Erreur',
              message: 'Error',
              variant: 'error'
            }),
          );
        }
      })
      .catch((error) => {
        this.isLoading = false
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Erreur',
            message: error,
            variant: 'error'
          }),
        );
        window.console.log(error);
      });
  }
  annuler() {
    this.omniUpdateDataJson({ exit: true });
    this.omniNextStep();
  }

  //HL - 16/01/2025

  async checkEligibilityFTTH() {
    let params = {
      input: JSON.stringify({
        coordinates: {
          latitude: this.latitudeC,
          longitude: this.longitudeC
        }
      }),

      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_CheckEligibilityOrangeVula",
      options: {}
    };

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("response from orange", response);
        const eligibilityFTTHResp = response.result.IPResult;
        console.log(
          "Les coordonnées GPS des adresses eligibles:",
          eligibilityFTTHResp
        );
        const orangeData = eligibilityFTTHResp.address.map((address) => ({
          latitude: address.coordinate.latitude,
          longitude: address.coordinate.longitude,
          building: address.building,
          district: address.district,
          street: address.street,
          city: address.city,
          title: `${address.street}`,
          plateId: address.plateId
        }));

        console.log("OrangeData", orangeData);

        const iframeEligibleOrange = this.template.querySelector("iframe");
        if (iframeEligibleOrange) {
          iframeEligibleOrange.contentWindow.postMessage(
            { name: "OrangeData", orangeData },
            this.vfRoot
          );
          console.log("orange data sent to VF");
        }
      });
  }

  /*
  loadProvinces() {
    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "PROVINCES"
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: {}
    };

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("Provinces", response);
        this.proVilleOptions = response.result.IPResult.results.map(
          (proville) => ({
            label: proville.libelle,
            value: String(proville.code)
          })
        );
        console.log("Response results:", response.result.IPResult.results);
      });
  }

  loadCommune() {
    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "COMMUNES",
        codeProvince: this.selectedProVille,
        codeCommune: "",
        codeQuartier: "",
        codeVoie: ""
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: {}
    };
    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("Communes", response);
        this.communesOptions = response.result.IPResult.results.map(
          (commune) => ({
            label: commune.libelle,
            value: commune.code,
            commune: commune.commune
          })
        );
      });
    console.log("quartier.commune", commune);
  }

  loadQuartier() {
    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "QUARTIERS",
        codeProvince: this.selectedProVille,
        codeCommune: "",
        codeQuartier: "",
        codeVoie: ""
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: {}
    };
    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("Quartiers", response);
        this.quartierOptions = response.result.IPResult.results.map(
          (quartier) => ({
            label: quartier.libelle,
            value: quartier.code,
            commune: quartier.commune
          })
        );
      });
    console.log("quartier.commune", commune);
  }

  loadVoies() {
    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "VOIES",
        codeProvince: this.selectedProVille,
        codeCommune: this.selectedCommuneCode,
        codeQuartier: this.selectedQuartier,
        codeVoie: ""
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: {}
    };
    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("Voies", response);
        this.voieOptions = response.result.IPResult.results.map((voie) => ({
          label: voie.libelle,
          value: voie.code
        }));
      });
  }

  loadNumVoies() {
    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "NUM_VOIES",
        codeProvince: this.selectedProVille,
        codeCommune: this.selectedCommuneCode,
        codeQuartier: this.selectedQuartier,
        codeVoie: this.selectedVoie
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: {}
    };
    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("Numeros dans la voie", response);
        this.numeroVoieOptions = response.result.IPResult.results.map(
          (numvoie) => ({
            label: numvoie.libelle,
            value: numvoie.code
          })
        );
      });
  }


  handleProvinceChange(event) {
    this.selectedProVille = event.target.value;
    console.log("Province/Ville sélectionnée now", this.selectedProVille);
    this.demande["InwiB2C_Code_Province__c"] = event.target.value
    this.demande["InwiB2C_Province__c"] = this.proVilleOptions.find(
      (opt) => opt.value === event.target.value
    ).label;

    setTimeout(() => {
      this.loadCommune();
    }, 500);
  }

  handleCommuneChange(event) {
    this.selectedVoie = event.target.value;
    console.log("Num sélectionnée", this.selectedCommuneLibelle);
    this.demande["InwiB2C_Code_Commune__c"] = event.target.value;
    this.demande["InwiB2C_Commune__c"] = this.communesOptions.find(
      (opt) => opt.value === event.target.value
    ).label;
    this.loadQuartier();
  }

  handleQuartierChange(event) {
    const selectedCode = event.target.value;
    this.selectedQuartier = selectedCode;
    const selectedQuartierObj = this.quartierOptions.find(
      (quartier) => quartier.value === selectedCode
    );
    if (selectedQuartierObj && selectedQuartierObj.commune) {
      const { code } = selectedQuartierObj.commune;
      // this.selectedCommuneLibelle = libelle;
      this.selectedCommuneCode = code;
      this.demande["InwiB2C_Code_Quartier__c"] = selectedCode;
      this.demande["inwiB2C_Quartier__c"] = selectedQuartierObj.label
      //this.demande["InwiB2C_Code_Commune__c"] = code
      console.log("Commune code est now:", code);
    } else {
      console.log("pas de commune qui correspond au quartier");
    }
    this.loadVoies();
    this.loadNumVoies();
  }

  handleVoieChange(event) {
    this.selectedVoie = event.target.value;
    console.log("Num sélectionnée", this.selectedVoie);
    this.demande["InwiB2C_Code_Voie__c"] = event.target.value;
    this.demande["InwiB2C_Voie__c"] = this.voieOptions.find(
      (opt) => opt.value === event.target.value
    ).label;
    this.loadNumVoies();
  }

  handleNumVoieChange(event) {
    this.selectedNumeroVoie = event.target.value;
    this.demande["InwiB2C_Code_de_Numero_de_la_voie__c"] = event.target.value;
    this.demande["InwiB2C_Numero_de_la_voie__c"] = this.numeroVoieOptions.find(
      (opt) => opt.value === event.target.value
    ).label;
    console.log("Num Voie sélectionnée", this.selectedNumeroVoie);
  }

  */
}