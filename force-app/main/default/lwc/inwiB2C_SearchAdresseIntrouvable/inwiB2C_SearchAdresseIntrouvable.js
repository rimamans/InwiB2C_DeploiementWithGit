import { LightningElement, track } from 'lwc';
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_SearchAdresseIntrouvable extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) 
{
   @track provinceVilleOptions = [];
   @track isButtonsVisible = false;
   @track Adressevalue = '';
   @track filteredProvinceVilleOptions = [];
   @track searchProvince = '';
   @track showOptions = false; // Contrôle la visibilité de la liste
    selectedProvinceVille = "";
    _actionUtil; //pour executer des appels d'API backend
    _ns = getNamespaceDotNotation();
  
    adresse;
    codeProvince;
    valueProvince;
    distributeur='';
    partenaire='';
    response='';
    statut='';
    adresseIAM;
 

    //Recupere les provinces/villes de l'IP
  connectedCallback() {
    this._actionUtil = new OmniscriptActionCommonUtil();
    this.loadProvinceVille();
  }

  //Modified by LH - 21/02/2025
  loadProvinceVille() {
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
      console.log("Provinces:", response);
        this.provinceVilleOptions = response.result.IPResult.results.map(
          (provinceVille) => ({
            label: provinceVille.libelle,
            value: String(provinceVille.code)
          }));
          this.filteredProvinceVilleOptions = [...this.provinceVilleOptions];
    })
    .catch((error) => {
      console.error("Erreur api call:", error);
  });
  }

  handleSearchChange(event) {
    this.searchProvince = event.target.value.toLowerCase(); // Mettre en minuscule
    this.filteredProvinceVilleOptions = this.searchProvince
      ? this.provinceVilleOptions.filter(option =>
          option.label.toLowerCase().includes(this.searchProvince)
        )
      :[];
      this.showOptions = this.filteredProvinceVilleOptions.length > 0; // Afficher si des résultats existent
  }

  handleOptionSelect(event) {
    const selectedValue = event.target.dataset.value;
    const selectedOption = this.provinceVilleOptions.find(option => option.value === selectedValue);

    if (selectedOption) {
        this.selectedProvinceVille = selectedValue;
        this.searchProvince = selectedOption.label;
        this.codeProvince = selectedOption.value;
        this.valueProvince = selectedOption.label;
    }

    this.showOptions = false;
    this.isButtonsVisible = true;
    console.log('Province sélectionnée :', selectedValue);
    console.log('Code Province :', this.codeProvince);
    console.log('Value Province :', this.valueProvince);
}

 
handleAdresseChange(event) {
    this.Adressevalue = event.target.value;
    this.adresseIAM = this.Adressevalue
}

// LH - 21/02/2025

handleEnvoyer() {
  let params = {
    input: JSON.stringify({
      InAdresse: this.adresseIAM,
      InCodeProvince: this.codeProvince,
      InValueProvince: this.valueProvince,
      InDistributeur: this.distributeur,
      InPartenaire: this.partenaire,
      InResponse: this.response,
      InStatut: this.statut
    }),
    sClassName: `${this._ns}IntegrationProcedureService`,
    sMethodName: "inwib2c_CreateDemandeAdresseIAM",
    options: {}
  };

  console.log("params", params);

  this._actionUtil
    .executeAction(params, null, this, null, null)
    .then((response) => {
      console.log("response path", response);
      const traceCreation = response.result.IPResult;
      console.log("Création d'une trace:", traceCreation);
      const traceName = response.result.IPResult.DemandeName;
      console.log("Nom de la trace (orderId):", traceName);

      let params2 = {
        input: JSON.stringify({
          orderId: traceName,
          searchedAddress: this.adresseIAM,
          codeProvince: this.codeProvince,
        }),
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_SendMissingAddressToSupport",
        options: {}
      };

      console.log("params 2", params2);

      return this._actionUtil.executeAction(params2, null, this, null, null);
    })
    .then((response) => {
      console.log("response path params2", response);

      if (response && response.result && response.result.IPResult) {
        this.responseStatus = response.result.IPResult.status === "OK" ? "success" : "error";
      } else {
        this.responseStatus = "error"; 
      }

      this.omniUpdateDataJson({ responseStatus: this.responseStatus });

      console.log("response status", this.responseStatus);

      this.omniNextStep();
    })
    .catch((error) => {
      console.error("Erreur lors de l'envoi de l'adresse :", error);
      this.omniUpdateDataJson({ responseStatus: "error" });
      this.omniNextStep();
    });
}


  handleAnnuler(event){
    window.location.href = '/PortailPDVPhase2/s/';
  }
}