import { LightningElement, track } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

export default class inwiB2C_EligibiliteFTTHForTelevente extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  

  
  vfRoot = "https://inwi-b2c--devevol--c.sandbox.vf.force.com"



  //siteURL = "https://inwi-b2c--uatevol.sandbox.my.site.com";
  // preprodURL = "https://inwi-b2c--preprod.sandbox.my.site.com";


  @track proVilleOptions = [];
  @track quartierOptions = [];
  @track voieOptions = [];
  @track numeroVoieOptions = [];
  @track isSearchDone = false;

  selectedProVille = "";
  selectedQuartier = "";
  selectedCommuneCode = "";

  selectedVoie = "";
  selectedNumeroVoie = "";
  // selectedCommuneLibelle = "";
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

    window.addEventListener("message", (event) => {
      console.log("origin de l'event", event.origin);
      if (event.origin !== this.vfRoot) {
        ////this.siteURL
        console.log("origin de l'event", event.origin);
        console.log(`origin: ${event.origin} et le lwc: ${this.vfRoot}`); //this.siteURL
        return;
      }
      console.log("Message ok recu par l'iframe");
      if (event.data && event.data.name === "VFtoLWC" && event.data.payload) {
        const { latitudeC, longitudeC } = event.data.payload;
        this.latitudeC = latitudeC;
        this.longitudeC = longitudeC;
        console.log("Central Coordonnées GPS from VF:", latitudeC, longitudeC);
      }else if (event.data && event.data.searchCompleted) {
        this.isSearchDone = true;
        console.log("Recherche terminée, isSearchDone mis à true.");
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
        console.log(
          "Details of INWI Marker Selected from VF:",
          building,
          city,
          operatorOI,
          plateId,
          street,
          latitude,
          longitude,
          status,
          provider
        );

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
          district
        } = event.data.payload;

        this.building = building;
        this.city = city;
        this.district = district;
        this.operatorOI = operatorOI;
        this.plateId = plateId;
        this.street = street;
        this.latitude = latitude;
        this.longitude = longitude;
        console.log(
          "Details of ORANGE Marker Selected from VF:",
          building,
          city,
          operatorOI,
          plateId,
          street,
          latitude,
          longitude,
          district
        );
        this.isServiceAccIdCreated = true;
        this.inputOs =
          '{"InOperatorOI":"' +
          operatorOI +
          '","InPlaque":"' +
          plateId +
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
    });
  }

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
        console.log("Provinces:", response);
        this.proVilleOptions = response.result.IPResult.results.map(
          (proville) => ({
            label: proville.libelle,
            value: String(proville.code)
          })
        );
        console.log("Response results:", response.result.IPResult.results);
      });
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
        this.quartierOptions = response.result.IPResult.results.map((quartier) => {
          const [codeQuartier, communeCode] = quartier.code.split(":");
          return {
            label: quartier.libelle,
            value: `${codeQuartier}:${communeCode}`,
            communeCode: communeCode,
            //commune: quartier.commune.code
          };
        });
      })
      .catch((error) => {
        console.error("Erreur lors de la récupération des quartiers:", error);
      });
  }

  loadVoies() {
    //comme quartier maintenant est au format codeQuartier:codeCommune, on doit extraire uniquement the first part
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
        console.log("Voies", response);
        this.voieOptions = response.result.IPResult.results.map((voie) => ({
          label: voie.libelle,
          value: voie.code
        }));
      });
  }

  loadNumVoies() {
    let quartierCode = this.selectedQuartier.split(":")[0];
    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "NUM_VOIES",
        codeProvince: this.selectedProVille,
        codeCommune: this.selectedCommuneCode,
        codeQuartier: quartierCode,
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
          codeVoie: this.selectedVoie,
          numVoie: this.selectedNumeroVoie
        }
      }),

      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_CheckEligibilityFTTHVula",
      options: {}
    };

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        const eligibilityFTTHResp = response.result.IPResult;
        console.log(
          "Les coordonnées GPS des adresses eligibles:",
          eligibilityFTTHResp
        );
        console.log("params ", params);
        console.log(eligibilityFTTHResp.operator);
        const { operator } = eligibilityFTTHResp;
        this.operatorOI = operator;
        this.skipOperator = operator;
        console.log("OperatorOI EST:", this.operatorOI);
        console.log("SkipOperator est :", this.skipOperator);

        const DRProvince =
          this.proVilleOptions.find(
            (option) => option.value === this.selectedProVille
          )?.label || "";
        const DRQuartier =
          this.quartierOptions.find(
            (option) => option.value === this.selectedQuartier
          )?.label || "";
        const DRVoie =
          this.voieOptions.find((option) => option.value === this.selectedVoie)
            ?.label || "";
        const DRNumVoie =
          this.numeroVoieOptions.find(
            (option) => option.value === this.selectedNumeroVoie
          )?.label || "";

        const provinceCode = this.selectedProVille;
        const provinceValue = DRProvince;
        const quartierCode = this.selectedQuartier.split(":")[0]; //here ?? 
        const quartierValue = DRQuartier;
        const voieCode = this.selectedVoie;
        const voieValue = DRVoie;
        const numVoieCode = this.selectedNumeroVoie;
        const numVoieValue = DRNumVoie;
        // const communeValue = this.selectedCommuneLibelle;
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

          console.log("OrangeData", orangeData);

          const iframeEligibleOrange = this.template.querySelector("iframe");
          if (iframeEligibleOrange) {
            iframeEligibleOrange.contentWindow.postMessage(
              { name: "OrangeData", orangeData },
              this.vfRoot
            ); //this.siteURL
            console.log("orange data sent to VF");
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

  handleProvinceChange(event) {
    this.selectedProVille = event.target.value;
    console.log("Province/Ville sélectionnée now", this.selectedProVille);

    setTimeout(() => {
      this.loadQuartier();
    }, 500);
  }

  // handleQuartierChange(event) {

  //   const selectedCode = event.target.value;
  //   this.selectedQuartier = selectedCode;
  //   console.log('code quartier sélectionnéee', selectedCode);
    
  //   const [quartierCode, communeCode] = selectedCode.split(":"); 
  //   this.selectedQuartier = quartierCode;
  //   this.selectedCommuneCode = communeCode;

  //   console.log("Quartier sélectionné:", this.selectedQuartier);
  //   console.log("Commune code est now:", this.selectedCommuneCode);

    
  //   const selectedQuartierObj = this.quartierOptions.find(
  //     (quartier) => quartier.value === selectedCode
  //   );
    
  //   if (selectedQuartierObj) {
  //     this.selectedCommuneCode = selectedQuartierObj.communeCode;
  //     console.log("Commune code est now:", this.selectedCommuneCode);
  //   } else {
  //     console.log("Pas de commune qui correspond au quartier");
  //   }
    
  //   this.loadVoies();
  // }
  handleQuartierChange(event) {
    const selectedCode = event.target.value;
    console.log('Code quartier selectionnee:', selectedCode);

    const [quartierCode, communeCode] = selectedCode.split(":"); 
    this.selectedQuartier = quartierCode;
    this.selectedCommuneCode = communeCode;


    const selectedQuartierObj = this.quartierOptions.find(
      (quartier) => quartier.value === selectedCode 
    );

    if (selectedQuartierObj) {
        this.selectedQuartier = selectedQuartierObj.value;
        this.selectedCommuneCode = selectedQuartierObj.communeCode;
    } else {
        console.log("Pas de correspondance entre les deux");
    }

    this.loadVoies();
}



  handleVoieChange(event) {
    this.selectedVoie = event.target.value;
    console.log("Num sélectionnée", this.selectedVoie);
    this.loadNumVoies();
  }

  handleNumVoieChange(event) {
    this.selectedNumeroVoie = event.target.value;
    console.log("Num Voie sélectionnée", this.selectedNumeroVoie);
  }
}