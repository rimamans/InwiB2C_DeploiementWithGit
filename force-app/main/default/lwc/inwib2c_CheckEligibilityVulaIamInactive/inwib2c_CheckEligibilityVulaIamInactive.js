import { LightningElement, track } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

export default class Inwib2c_CheckEligibilityVulaIamInactive extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  vfRoot = "https://inwi-b2c--devevol--c.sandbox.vf.force.com";

  @track proVilleOptions = [];
  @track quartierOptions = [];
  @track searchProvince = "";
  @track searchQuartier = "";
  @track showProvinceOptions = false;
  @track showOptions = false;
  @track filteredProvinceVilleOptions = [];
  @track filteredQuartiersOptions = [];
  @track quartierLoading = true;
  @track isSearchDone = false;
  @track latitude = "";
  @track longitude = "";
  @track showEligibilityPopup = false;
  @track showNoEligibilityPopup = false;

  codeProvince;
  valueProvince;
  selectedProVille = "";
  selectedQuartier = "";
  selectedCommuneCode = "";
  selectedQuartierLabel = "";
  selectedVoie = "";
  eligibilityMessage = "";
  address = "";

  serviceAccId;
  isServiceAccIdCreated = false;
  omniScriptUrl;
  inputOs;
  operatorOI;
  _actionUtil;
  _ns = getNamespaceDotNotation();

  connectedCallback() {
    this._actionUtil = new OmniscriptActionCommonUtil();
    this.loadProvinces();
    window.addEventListener("scroll", this.handleScroll, true);

    window.addEventListener("message", (event) => {
      if (
        event.data &&
        event.data.name === "coordinates" &&
        event.data.payload
      ) {
        const { latitudeC, longitudeC } = event.data.payload;
        this.latitudeC = latitudeC;
        this.longitudeC = longitudeC;

        if (this.isSearchDone) {
          this.latitude = this.latitudeC;
          this.longitude = this.longitudeC;
        }
      } else if (event.data && event.data.searchCompleted) {
        this.isSearchDone = true;
        this.latitude = this.latitudeC;
        this.longitude = this.longitudeC;
        console.log("this latitude", this.latitudeC);
      }
    });
  }

  disconnectedCallback() {
    window.removeEventListener("scroll", this.handleScroll, true);
  }

  handleScroll = () => {
    this.showProvinceOptions = false;
    this.showOptions = false;
    this.showVoieOptions = false;
  };

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
        this.proVilleOptions = response.result.IPResult.results.map(
          (proville) => ({
            label: proville.libelle,
            value: String(proville.code)
          })
        );
      });
  }

  showProvinceOptionsHandler() {
    this.showProvinceOptions = true;
    this.filteredProvinceVilleOptions = [...this.proVilleOptions];
  }

  InitSearchProvince(event) {
    this.searchProvince = event.target.value.toLowerCase();
    this.filteredProvinceVilleOptions = this.searchProvince
      ? this.proVilleOptions.filter((option) =>
          option.label.toLowerCase().includes(this.searchProvince)
        )
      : [];
  }

  ProvinceOptionSelect(event) {
    const selectedValue = event.target.dataset.value;
    const selectedOption = this.proVilleOptions.find(
      (option) => option.value === selectedValue
    );

    if (selectedOption) {
      this.selectedProVille = selectedOption.value;
      this.searchProvince = selectedOption.label;
      this.selectedProVille = selectedOption.value;
      this.valueProvince = selectedOption.label;
      this.loadQuartier();
    } else {
      console.warn("Aucune province sélectionnée !");
    }

    this.showProvinceOptions = false;
  }

  loadQuartier() {
    this.quartierLoading = true;
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
        const results = response?.result?.IPResult?.results;

        if (!Array.isArray(results)) {
          console.warn("Données quartiers invalides :", results);
          this.quartierOptions = [];
          this.filteredQuartiersOptions = [];
          return;
        }

        this.quartierOptions = results.map((quartier) => {
          const [codeQuartier, communeCode] = quartier.code.split(":");
          return {
            label: quartier.libelle,
            value: `${codeQuartier}:${communeCode}`,
            communeCode: communeCode
          };
        });
        this.quartierLoading = false;
      })
      .catch((error) => {
        console.error("Erreur lors de la récupération des quartiers:", error);
      });
  }

  showQuartierOptionsHandler() {
    this.showOptions = true;
    this.filteredQuartiersOptions = [...this.quartierOptions];
  }

  InitSearchQuartier(event) {
    this.searchQuartier = event.target.value.toLowerCase();

    if (!Array.isArray(this.quartierOptions)) {
      console.warn("quartierOptions non disponible");
      this.filteredQuartiersOptions = [];
      this.showOptions = false;
      return;
    }

    this.filteredQuartiersOptions = this.searchQuartier
      ? this.quartierOptions.filter((option) =>
          option.label.toLowerCase().includes(this.searchQuartier)
        )
      : [];

    this.showOptions = this.filteredQuartiersOptions.length > 0;
  }

  QuartierOptionSelect(event) {
    const selectedCode = event.target.dataset.value;
    const selectedOption = this.quartierOptions.find(
      (option) => option.value === selectedCode
    );

    if (selectedOption) {
      const [quartierCode, communeCode] = selectedCode.split(":");
      this.selectedQuartier = quartierCode;
      this.selectedCommuneCode = communeCode;

      this.searchQuartier = selectedOption.label;
      this.selectedQuartierLabel = selectedOption.label;

      this.showOptions = false;
    } else {
      console.log(
        "Aucune correspondance trouvée pour le quartier sélectionné."
      );
    }
  }

  async checkEligibilityFTTH() {
    let quartierCode = this.selectedQuartier.split(":")[0];
    if (!this.selectedProVille || !this.selectedQuartier) {
      alert("Veuillez renseigner tous les champs !");
      return;
    }
    let params = {
      input: JSON.stringify({
        skipOperator: "",
        coordinates: {
          latitude: this.latitudeC,
          longitude: this.longitudeC
        },
        address: {
          codeProvince: this.selectedProVille,
          codeCommune: this.selectedCommuneCode,
          codeQuartier: quartierCode,
          codeVoie: "",
          numVoie: ""
        }
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_CheckEligibilityFTTHVula",
      options: {}
    };

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        const eligibilityFTTHIAM = response.result.IPResult;
        console.log("responsssse IAM", eligibilityFTTHIAM);
        console.log("status", eligibilityFTTHIAM.status);

        if (eligibilityFTTHIAM.status === "OK") {
          this.eligibilityMessage =
            "Votre adresse est bien éligible à nos offres FTTH !";
          this.showEligibilityPopup = true;
        } else {
          this.eligibilityDownMessage =
            "Cette adresse n’est pas éligible, vous pouvez faire une nouvelle recherche ou cliquez sur « Passer à l’éligibilité Orange » pour continuer.";
          this.showNoEligibilityPopup = true;
        }

        const { operator } = eligibilityFTTHIAM;
        this.operatorOI = operator;

        const DRProvince =
          this.proVilleOptions.find(
            (option) => option.value === this.selectedProVille
          )?.label || "";

        const provinceCode = this.selectedProVille;
        const provinceValue = DRProvince;
        const quartierCode = this.selectedQuartier;
        const quartierValue = this.selectedQuartierLabel;
        const communeCode = this.selectedCommuneCode;

          const { status, nro} = eligibilityFTTHIAM;
          this.isServiceAccIdCreated = true;
          this.inputOs =
            '{"InOperatorOI":"' +
            operator +
            '","InNro":"' +
            nro +
            '","InStatutPlaque":"' +
            status +
            '","InProvince":"' +
            provinceValue +
            '","InProvinceCode":"' +
            provinceCode +
            '","InQuartier":"' +
            quartierValue +
            '","InQuartierCode":"' +
            quartierCode +
            '","InCommuneCode":"' +
            communeCode +
            '","InTypePartage":"ACTIF"}';
        }
      );
  }

  redirectAcquisition() {
   this.showEligibilityPopup = false;
   this.omniApplyCallResp({
     inputOsacq: JSON.parse(this.inputOs),
    test: "test"
  });
  this.omniNextStep();
  }

  handleNext() {
    this.omniNextStep();
  }

  handleNewSearch() {
    this.showEligibilityPopup = false;
    this.isSearchDone = false;

    this.selectedProVille = "";
    this.selectedQuartier = "";
    this.selectedCommuneCode = "";
    this.selectedQuartierLabel = "";
    this.selectedVoie = "";
    this.valueProvince = "";

    this.latitude = "";
    this.longitude = "";
    this.latitudeC = "";
    this.longitudeC = "";
    this.address = "";

    this.searchProvince = "";
    this.searchQuartier = "";

    this.filteredProvinceVilleOptions = [];
    this.filteredQuartiersOptions = [];
    this.quartierOptions = [];

    this.quartierLoading = true;
    this.eligibilityMessage = "";
    this.inputOs = "";
  }

  get isCommuneDisabled() {
    return !this.selectedQuartier;
  }
}