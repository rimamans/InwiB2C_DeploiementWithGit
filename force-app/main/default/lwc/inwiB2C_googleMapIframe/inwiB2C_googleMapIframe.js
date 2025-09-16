import { LightningElement, track, api } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from "lightning/navigation";


export default class InwiB2C_googleMapIframe extends OmniscriptBaseMixin(NavigationMixin(LightningElement)){

vfRoot = "https://inwi-b2c--devevol--c.sandbox.vf.force.com";

@track proVilleOptions = [];
@track quartierOptions = [];
@track voieOptions = [];
@track numeroVoieOptions = [];

selectedProVille = "";
selectedQuartier = "";
selectedVoie = "";
selectedNumeroVoie = "";
selectedCommuneLibelle = "";
serviceAccId;

_actionUtil; //pour executer des appels d'API backend
_ns = getNamespaceDotNotation();

address = "";

 //Recupere les provinces, quartiers de la VIP
  connectedCallback() {
    this._actionUtil = new OmniscriptActionCommonUtil();
    this.loadProvinces();

     window.addEventListener("message", (event) => {
        if (event.origin !== this.vfRoot) {
            console.log("origin", event.origin);
            return;
        }

        if (event.data && event.data.name === 'VFtoLWC' && event.data.payload) {
            const { latitudeC, longitudeC } = event.data.payload;
            this.latitudeC = latitudeC;
            this.longitudeC = longitudeC;
            console.log("Central Coordonnées GPS from VF:", latitudeC, longitudeC);

        } else if(event.data && event.data.name === 'CreateServiceAccountInwi' && event.data.payload){
          const {building, city, latitude, longitude, operatorOI, plateId, street} = event.data.payload;
                    this.building = building;
                    this.city = city;
                    this.operatorOI = operatorOI;
                    this.plateId = plateId;
                    this.street = street;
                    this.latitude = latitude;
                    this.longitude= longitude;
                    console.log("Details of INWI Marker Selected from VF:", building, city, operatorOI, plateId, street, latitude, longitude);

                    let params = {
                      input: JSON.stringify({
                        InOperatorOI: operatorOI,
                        InPlaque: plateId,
                        InStreet: street,
                        InCity: city,
                        InBuilding: building,
                        InLatitude: latitude,
                        InLongitude: longitude,
                        }),

                      sClassName: `${this._ns}IntegrationProcedureService`,
                      sMethodName: "Inwi_InwiB2C_CreateSiteVulaByEligibility",
                      options: {}
                    };

                    this._actionUtil
                      .executeAction(params, null, this, null, null)
                      .then((response) => {
                        const orangeEligibilityFTTHResp = response.result.IPResult;
                        console.log("INWI - Creation Site:", orangeEligibilityFTTHResp);
                        this.serviceAccId = orangeEligibilityFTTHResp.Accountservice;
                        console.log("ServiceAccID - INWI:", this.serviceAccId);
                        });

        }else if(event.data && event.data.name === 'CreateServiceAccountOrange' && event.data.payload){
          const {building, city, latitude, longitude, operatorOI, plateId, street, district} = event.data.payload;
                    this.building = building;
                    this.city = city;
                    this.district = district;
                    this.operatorOI = operatorOI;
                    this.plateId = plateId;
                    this.street = street;
                    this.latitude = latitude;
                    this.longitude= longitude;
                    console.log("Details of ORANGE Marker Selected from VF:", building, city, operatorOI, plateId, street, latitude, longitude, district);

                    let params = {
                      input: JSON.stringify({
                        InOperatorOI: operatorOI,
                        InPlaque: plateId,
                        InStreet: street,
                        InCity: city,
                        InBuilding: building,
                        InLatitude: latitude,
                        InLongitude: longitude,
                        InDistrict: district
                        }),

                      sClassName: `${this._ns}IntegrationProcedureService`,
                      sMethodName: "Inwi_InwiB2C_CreateSiteVulaByEligibility",
                      options: {}
                    };

                    this._actionUtil
                      .executeAction(params, null, this, null, null)
                      .then((response) => {
                        const orangeEligibilityFTTHResp = response.result.IPResult;
                        console.log("Orange - Creation Site:", orangeEligibilityFTTHResp);
                        this.serviceAccId = orangeEligibilityFTTHResp.Accountservice;
                        console.log("ServiceAccID - Orange:", this.serviceAccId);
                        })}
                    });
                  }

  loadProvinces() {
    let params = {
      input: JSON.stringify({ keyword: "", search: "PROVINCES" }),
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
            label: proville.label,
            value: proville.code
          })
        );
        console.log(
          "Response results:",
          response.result.IPResult.results
        );
      });
  }

  loadQuartier() {
    let params = {
      input: JSON.stringify({
        keyword: this.selectedProVille,
        search: "QUARTIERS"
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
            label: quartier.label,
            value: quartier.code,
            commune: quartier.commune
          })
        );
      });
      console.log("quartier.commune", commune)
  }

    loadVoies() {
    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "VOIES"
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: {}
    };
    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("Voies", response);
        this.voieOptions = response.result.IPResult.results.map(
          (voie) => ({
            label: voie.libelle,
            value: voie.code
          })
        );
      });
  }

    loadNumVoies() {
    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "NUM_VOIES"
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

handleAddressChange(event) {
this.address = event.target.value;
}

async checkEligibilityFTTH() {
    // if (!this.selectedProVille || !this.selectedQuartier || !this.selectedNumeroVoie || !this.selectedVoie) {
    //     alert("Veuillez renseigner tous les champs !");
    //     return;
    // }

    const apiKey = "AIzaSyDLSu8_FsTJGBxMqleP7gqKCNcPYed1V20";
    const endpoint = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(
        this.address
    )}&key=${apiKey}`;

    try {
        const response = await (await fetch(endpoint)).json();

            const latitude = response.results[0].geometry.location.lat;
            const longitude = response.results[0].geometry.location.lng;
            const titre = this.address
            console.log(`Coordonnées GPS pour l'adresse : ${this.address}`);
            console.log("Latitudeee :", latitude);
            console.log("Longitudeee :", longitude);
             console.log("Titre :", titre);


            const iframe = this.template.querySelector("iframe");
            if (iframe) {
                iframe.contentWindow.postMessage({ name: "Geocodage", latitude, longitude, titre }, this.vfRoot);
                console.log("titree envoyer", titre,latitude, longitude )
        }
    } catch (error) {
        console.error("Error:", error);
    }

     let params = {
      input: JSON.stringify({
        skipOperator: "IAM",
        coordinates: {
          latitude: this.latitudeC,
          longitude: this.longitudeC
        },
        address: {
          codeProvince: this.selectedProVille,
          codeCommune: this.selectedCommune,
          codeQuartier: this.selectedQuartier,
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
        console.log("Les coordonnées GPS des adresses eligibles:", eligibilityFTTHResp);
        const {operator} = eligibilityFTTHResp;
        const operatorOI = operator;
        console.log("OperatorOI EST:", operatorOI);

     const DRProvince = this.proVilleOptions.find(option => option.value === this.selectedProVille)?.label || '';
     const DRQuartier = this.quartierOptions.find(option => option.value === this.selectedQuartier)?.label || '';
     const DRVoie = this.voieOptions.find(option => option.value === this.selectedVoie)?.label || '';
     const DRNumVoie = this.numeroVoieOptions.find(option => option.value === this.selectedNumeroVoie )?.label || '';


        if (operatorOI === "IAM") {
          const {nro} = eligibilityFTTHResp;
          const noeud = nro;
          console.log(`Le noeud de l'operateur ${operatorOI} est `, noeud);


          const provinceCode = this.selectedProVille;
          const provinceValue = DRProvince;
          const quartierCode = this.selectedQuartier;
          const quartierValue = DRQuartier;
          const voieCode = this.selectedVoie;
          const voieValue = DRVoie;
          const numVoieCode = this.selectedNumeroVoie;
          const numVoieValue = DRNumVoie;
          const communeValue = this.selectedCommuneLibelle;
          const communeCode = this.selectedCommuneCode;

    let params = {
      input: JSON.stringify({
        InOperatorOI: operatorOI,
        InNro: noeud,
        InProvince: provinceValue,
        InNumeroVoie: numVoieValue,
        InProvinceCode: provinceCode,
        InQuartier: quartierValue,
        InQuartierCode: quartierCode,
        InNumVoieCode: numVoieCode,
        InVoie: voieValue,
        InVoieCode: voieCode,
        InCommune: communeValue,
        InCommuneCode: communeCode,
        
        }),

      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "Inwi_InwiB2C_CreateSiteVulaByEligibility",
      options: {}
    };

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        const IAMeligibilityFTTHResp = response.result.IPResult;
        console.log("Les IAM Details:", IAMeligibilityFTTHResp);
        this.serviceAccId = IAMeligibilityFTTHResp.Accountservice;
      // this.omniApplyCallResp({ 'serviceAccId': serviceAccId });
      // this.omniNextStep();

        // console.log("ServiceAccID:", serviceAccId);
        // if (serviceAccId) {

        // this.acquisitionUrl = `/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c%3Ainwib2cInwiB2C_AcquisitionFTTHVulaFrench&c__serviceAccId=${serviceAccId}`;
      // } else {
      //   console.error("pas de service account id", error);
      // }
        }
      )

    } else if(operator === "ORANGE"){
      const orangeData = eligibilityFTTHResp.address.map((address)=>({
            latitude: address.coordinate.latitude,
            longitude: address.coordinate.longitude,
            building: address.building,
            district: address.district,
            street: address.street,
            city: address.city,
            title:  `${address.street}`,
            operator: eligibilityFTTHResp.operator,
            plateId: address.plateId
        }))
        console.log("OrangeData", orangeData)
            const iframeEligibleOrange = this.template.querySelector("iframe");
            if (iframeEligibleOrange) {
                iframeEligibleOrange.contentWindow.postMessage ({ name: "OrangeData", orangeData }, this.vfRoot);
                console.log("orange data sent to VF")
        }

    }else {
      //Dans le cas de l'operateur INWI
       const mapData = eligibilityFTTHResp.address.map((address)=>({
            latitude: address.coordinate.latitude,
            longitude: address.coordinate.longitude,
            building: address.building,
            street: address.street,
            city: address.city,
            title:  `${address.street}`,
            operator: eligibilityFTTHResp.operator,
            plateId: address.plateId
        }))
        console.log("INWI: mapData ", mapData)

        const iframeEligible = this.template.querySelector("iframe");
            if (iframeEligible) {
                iframeEligible.contentWindow.postMessage ({ name: "MapData", mapData }, this.vfRoot);
        }

    }
})}
    redirectAcquisition() {
      console.log("retrieve service acc", this.serviceAccId)
      this.omniApplyCallResp({ 'serviceAccId': this.serviceAccId, 'test': 'test' });
      this.omniNextStep();
}

  get isCommuneDisabled() {
    return !this.selectedQuartier;
  }

  handleProvinceChange(event) {
    this.selectedProVille = event.detail.value;
    console.log("Province/Ville sélectionnée", this.selectedProVille);

  setTimeout(() => {
    this.loadQuartier();
  }, 500);
  }


  handleQuartierChange(event) {

  const selectedCode = event.target.value;
  this.selectedQuartier = selectedCode;
  const selectedQuartierObj = this.quartierOptions.find(
    (quartier) => quartier.value === selectedCode
  );
  if (selectedQuartierObj && selectedQuartierObj.commune) {
    const { libelle, code } = selectedQuartierObj.commune;
    this.selectedCommuneLibelle = libelle;
    this.selectedCommuneCode = code;

    console.log("Commune libelle:", libelle);
    console.log("Commune code:", code);


  } else {
    console.log("pas de commune qui correspond au quartier");
  }
  this.loadVoies();

  }

  handleVoieChange(event){
    this.selectedVoie = event.target.value;
    console.log("Num sélectionnée", this.selectedVoie);
    this.loadNumVoies();
  }

  handleNumVoieChange(event){
  this.selectedNumeroVoie = event.target.value;
  console.log("Num Voie sélectionnée", this.selectedNumeroVoie);
  }

}