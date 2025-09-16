import { LightningElement, track } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

export default class InwiB2C_EligibilityFTTH extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  vfRoot = "https://inwi-b2c--devevol--c.sandbox.vf.force.com";

  @track proVilleOptions = [];
  @track quartierOptions = [];
  @track voieOptions = [];
  @track searchProvince = "";
  @track searchQuartier = "";
  @track searchVoie = "";
  @track showProvinceOptions = false;
  @track showVoieOptions = false;
  @track showOptions = false;
  @track filteredProvinceVilleOptions = [];
  @track filteredQuartiersOptions = []
  @track filteredVoieOptions = [];
  @track isSearchDone = false;
  @track quartierLoading = true;
  @track voieLoading = true;
  @track NumVoieLoading = true;


  codeProvince;
  valueProvince;
  numeroVoieValue = "";

  selectedProVille = "";
  selectedQuartier = "";
  selectedCommuneCode = "";
  selectedQuartierLabel = "";
  selectedVoie = "";
  selectedNumeroVoie = "";

  address = "";
  serviceAccId;
  isServiceAccIdCreated = false;
  orangeData;
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
      if (event.origin !== this.vfRoot) {
        return;
      }
      if (event.data && event.data.name === "VFtoLWC" && event.data.payload) {
        const { latitudeC, longitudeC } = event.data.payload;
        this.latitudeC = latitudeC;
        this.longitudeC = longitudeC;
      } else if (event.data && event.data.searchCompleted) {
        this.isSearchDone = true;
      } else if (
        event.data &&
        event.data.name === "CreateServiceAccountInwi" &&
        event.data.payload
      ) {
        const {
          building,
          city,
          latitude,
          longitude,
          operatorOI,
          plateId,
          street,
          status,
          provider
        } = event.data.payload;
        this.building = building;
        this.city = city;
        this.operatorOI = operatorOI;
        this.plateId = plateId;
        this.street = street;
        this.latitude = latitude;
        this.longitude = longitude;
        (this.status = status), (this.provider = provider);

        this.isServiceAccIdCreated = true;
        this.inputOs =
          '{"InOperatorOI":"' +
          operatorOI +
          '","InPlaque":"' +
          plateId +
          '","InStreet":"' +
          street +
          '","InStatutPlaque":"' +
          status +
          '","InFournisseur":"' +
          provider +
          '","InCity":"' +
          city +
          '","InBuilding":"' +
          building +
          '","InLatitude":"' +
          latitude +
          '","InLongitude":"' +
          longitude +
          '","InTypePartage":"NA"}';
      } else if (
        event.data &&
        event.data.name === "CreateServiceAccountOrange" &&
        event.data.payload
      ) {
        const {
          building,
          city,
          latitude,
          longitude,
          operatorOI,
          plateId,
          street,
          district,
          collectPointId
        } = event.data.payload;

        this.building = building;
        this.city = city;
        this.district = district;
        this.operatorOI = operatorOI;
        this.plateId = plateId;
        this.street = street;
        this.latitude = latitude;
        this.longitude = longitude;
        this.collectPointId = collectPointId
      
        this.isServiceAccIdCreated = true;
        this.inputOs =
          '{"InOperatorOI":"' +
          operatorOI +
          '","InPlaque":"' +
          plateId +
          '","InNro":"' +
          collectPointId +
          '","InStreet":"' +
          street +
          '","InCity":"' +
          city +
          '","InDistrict":"' +
          district +
          '","InBuilding":"' +
          building +
          '","InLatitude":"' +
          latitude +
          '","InLongitude":"' +
          longitude +
          '","InTypePartage":"ACTIF"}';
      }
      console.log("inputtttt", this.inputOs);
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
        console.log("Provincesss:", response);
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
  
    console.log("Options filtrées  yes :", this.filteredQuartiersOptions.map(o => o.label));
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


      this.loadVoies();
      this.showOptions = false;
    } else {
      console.log(
        "Aucune correspondance trouvée pour le quartier sélectionné."
      );
    }
  }
  

  loadVoies() {
    this.voieLoading = true;
    let quartierCode = this.selectedQuartier.split(":")[0];

    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "VOIES",
        codeProvince: this.selectedProVille,
        codeCommune: this.selectedCommuneCode,
        codeQuartier: quartierCode,
        codeVoie: ""
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: {}
    };
    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        this.voieOptions = response.result.IPResult.results.map((voie) => ({
          label: voie.libelle,
          value: voie.code
        }));
        this.voieLoading = false;
      });
  }


  showVoieOptionsHandler() {
    this.showVoieOptions = true;
    this.filteredVoieOptions = [...this.voieOptions];
  }

  InitSearchVoie(event) {
    this.searchVoie = event.target.value.toLowerCase();
    this.filteredVoieOptions = this.searchVoie
      ? this.voieOptions.filter((option) =>
          option.label.toLowerCase().includes(this.searchVoie)
        )
      : [];
    this.showVoieOptions = this.filteredVoieOptions.length > 0;
  }

  VoieOptionSelect(event) {
    const selectedValue = event.target.dataset.value;
    const selectedOption = this.voieOptions.find(
      (option) => option.value === selectedValue
    );

    if (selectedOption) {
      this.selectedVoie = selectedOption.value;
      this.searchVoie = selectedOption.label;
    }

    this.showVoieOptions = false;
    this.NumVoieLoading = false;
  }


  async executeEligibilityCheck(skipOperator) {
    let quartierCode = this.selectedQuartier.split(":")[0];
    if (
      !this.selectedProVille ||
      !this.selectedQuartier ||
      !this.selectedNumeroVoie ||
      !this.selectedVoie 
    ) {
      alert("Veuillez renseigner tous les champs !");
      return;
    }
    let params = {
      input: JSON.stringify({
        skipOperator: skipOperator || "",
        coordinates: {
          latitude: this.latitudeC,
          longitude: this.longitudeC
        },
        address: {
          codeProvince: this.selectedProVille,
          codeCommune: this.selectedCommuneCode,
          codeQuartier: quartierCode,
          codeVoie: this.selectedVoie
        }
      }),

      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_CheckEligibilityFTTHVula",
      options: {}
    };

    console.log("Params to send :", params); 

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        const eligibilityFTTHResp = response.result.IPResult;
        const { operator} = eligibilityFTTHResp;
        this.operatorOI = operator;
        this.skipOperator = operator;


        const DRProvince =
          this.proVilleOptions.find(
            (option) => option.value === this.selectedProVille 
          )?.label || "";
        const DRVoie =
          this.voieOptions.find((option) => option.value === this.selectedVoie)
            ?.label || "";
        const DRNumVoie = this.selectedNumeroVoie;

        const provinceCode = this.selectedProVille;
        const provinceValue = DRProvince;
        const quartierCode = this.selectedQuartier;
        const quartierValue = this.selectedQuartierLabel;
        const voieCode = this.selectedVoie;
        const voieValue = DRVoie;
        const numVoieValue = DRNumVoie;
        const numVoieCode = numVoieValue;
        const communeCode = this.selectedCommuneCode;



        if (operator === "IAM") {
          const { nro } = eligibilityFTTHResp;
          const noeud = nro;

          this.isServiceAccIdCreated = true;
          this.inputOs =
            '{"InOperatorOI":"' +
            operator +
            '","InNro":"' +
            noeud +
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
            '","InVoie":"' +
            voieValue +
            '","InVoieCode":"' +
            voieCode +
            '","InNumeroVoie":"' +
            numVoieValue +
            '","InNumVoieCode":"' +
            numVoieCode +
            '","InTypePartage":"ACTIF"}';
        } else if (operator === "ORANGE") {
          const orangeData = eligibilityFTTHResp.address.map((address) => ({
            collectPointId: address.collectPointId,
            latitude: address.coordinate.latitude,
            longitude: address.coordinate.longitude,
            building: address.building,
            district: address.district,
            street: address.street,
            city: address.city,
            title: `${address.street}`,
            operator: eligibilityFTTHResp.operator,
            plateId: address.plateId
          }));
          console.log("orange data retreived from vip to send to vf")


          const iframeEligibleOrange = this.template.querySelector("iframe");
          if (iframeEligibleOrange) {
            iframeEligibleOrange.contentWindow.postMessage(
              { name: "OrangeData", orangeData },
              this.vfRoot
            );
          }
        } else {
          //Dans le cas de l'operateur INWI
          if (
            eligibilityFTTHResp &&
            Array.isArray(eligibilityFTTHResp.address)
          ) {
            const mapData = eligibilityFTTHResp.address.map((address) => ({
              latitude: address.coordinate.latitude,
              longitude: address.coordinate.longitude,
              building: address.building,
              street: address.street,
              city: address.city,
              title: `${address.street}`,
              operator: eligibilityFTTHResp.operator,
              plateId: address.plateId,
              provider: address.provider,
              status: address.status
            }));
            console.log("INWI: mapData ", mapData);
            const iframeEligible = this.template.querySelector("iframe");
            if (iframeEligible) {
              iframeEligible.contentWindow.postMessage(
                { name: "MapData", mapData },
                this.vfRoot
              );
            }
          }
        }
      });
  }

  async checkEligibilityFTTH() {
    await this.executeEligibilityCheck("");
  }

  async restartEligibilityWithNewCentralGPS() {
    await this.executeEligibilityCheck(this.skipOperator);
    console.log("Nouvelle adresse - operateur inclu:", this.skipOperator);
  }

  redirectAcquisition() {
    this.omniApplyCallResp({
      inputOsacq: JSON.parse(this.inputOs),
      test: "test"
    });
    this.omniNextStep();
  }

  get isCommuneDisabled() {
    return !this.selectedQuartier;
  }

  handleNumVoieChange(event) {
    this.numeroVoieValue = event.target.value;
    this.selectedNumeroVoie = this.numeroVoieValue;
  }
}