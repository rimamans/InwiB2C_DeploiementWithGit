import { LightningElement, track } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";


export default class InwiB2C_addressEntryFTTH extends LightningElement {
  @track proVilleOptions = [];
  @track communeOptions = [];
  @track quartierOptions = [];
  @track voieOptions = [];
  @track numeroVoie = [];

  //initialisation, au debut vide
  selectedProVille = "";
  selectedCommune = "";
  selectedQuartier = "";
  selectedVoie = "";
  numeroVoie = "";

  _actionUtil; //pour executer des appels d'API backend
  _ns = getNamespaceDotNotation();

  address = "";
  zoomLevel = 12;
  mapCenter = {};
  mapMarkers = [
    {
      location: { Latitude: "48.8566", Longitude: "2.3522" }
    }
  ];

  //Recupere les proviences de l'IP
  connectedCallback() {
    this._actionUtil = new OmniscriptActionCommonUtil();
    this.loadProvinces();
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
        console.log("thagi", response);
        this.proVilleOptions = response.result.IPResult.response.results.map(
          (proville) => ({
            label: proville.label,
            value: proville.code
          })
        );
        console.log(
          "Response results:",
          response.result.IPResult.response.results
        );
      });
  }

  
  handleMarkerSelect(event) {
    const marker = this.mapMarkers.find((marker) => {
      return marker.value === event.detail.selectedMarkerValue;
    });

    alert(JSON.stringify(marker));
  }

  handleAddressChange(event) {
    this.address = event.target.value;
  }

  async handleSearch() {
    const apiKey = "AIzaSyDifRu8RrYRB7o_4_CqoCZqEx3JWvbccCo";
    const endpoint = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(
      this.address
    )}&key=${apiKey}`;

    const response = await (await fetch(endpoint)).json();

    const latitude = response.results[0].geometry.location.lat;
    const longitude = response.results[0].geometry.location.lng;

    this.mapMarkers = [
      {
        location: { Latitude: latitude + 0.001, Longitude: longitude },
        value: this.address + 1
      },
      {
        location: { Latitude: latitude + 0.002, Longitude: longitude },
        value: this.address + 2
      },
      {
        location: { Latitude: latitude + 0.003, Longitude: longitude },
        value: this.address + 3
      },
      {
        location: { Latitude: latitude, Longitude: longitude + 0.001 },
        value: this.address + 4
      },
      {
        location: { Latitude: latitude, Longitude: longitude + 0.002 },
        value: this.address + 5
      },
      {
        location: { Latitude: latitude, Longitude: longitude + 0.003 },
        value: this.address + 6
      }
    ];

    this.mapCenter = { Latitude: latitude, Longitude: longitude };
  }

  // loadAddress() {
  //   let params = {
  //     input: JSON.stringify({
  //       skipOperator: "IAM",
  //       coordinates: {
  //         latitude: "",
  //         longitude: ""
  //       },
  //       address: {
  //         codeProvince: this.selectedProVille,
  //         codeCommune: this.selectedCommune,
  //         codeQuartier: this.selectedQuartier,
  //         codeVoie: this.selectedVoie,
  //         numVoie: this.numeroVoie
  //       }
  //     }),
  //     cClassName: `${this._ns}IntegrationProcedureService`,
  //     sMethodName: "inwib2c_InwiB2C_CheckEligibilityFTTHVula",
  //     options: {}
  //   };

  //   this._actionUtil
  //     .executeAction(params, null, this, null, null)
  //     .then((response) => {
  //       console.log("Les informations de l'adresse", response);
  //     });
  // }

  //   loadCommunes() {
  //     if (this.selectedQuartier) {
  //       let params = {
  //         input: JSON.stringify({
  //           keyword: this.selectedQuartier,
  //           search: "COMMUNES"
  //         }),
  //         sClassName: `${this._ns}IntegrationProcedureService`,
  //         sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
  //         options: {}
  //       };
  //       this._actionUtil
  //         .executeAction(params, null, this, null, null)
  //         .then((response) => {
  //           console.log("sia", response);
  //           this.communeOptions = response.result.IPResult.response.results.map(
  //             (commune) => ({
  //               label: commune.label,
  //               value: commune.code
  //             })
  //           );
  //         });
  //     }
  //   }

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
        console.log("quartier", response);
        this.quartierOptions = response.result.IPResult.response.results.map(
          (quartier) => ({
            label: quartier.label,
            value: quartier.code
          })
        );
      });
  }

  //   loadVoie() {
  //     let params = {
  //       input: JSON.stringify({ keyword: this.selectedQuartier, search: "VOIE" }),
  //       sClassName: `${this._ns}IntegrationProceduresService`,
  //       sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
  //       options: {}
  //     };
  //     const response = this._actionUtil.executeAction(
  //       params,
  //       null,
  //       this,
  //       null,
  //       null
  //     );
  //     this.voieOptions = response.result.map((voie) => ({
  //       label: voie.label,
  //       value: voie.code
  //     }));
  //   }

  get isCommuneDisabled() {
    return !this.selectedQuartier;
  }

  handleProvinceChange(event) {
    this.selectedProVille = event.detail.value; // Capturer la valeur sélectionnée
    console.log("Province/Ville sélectionnée", this.selectedProVille); // Vérifiez que la valeur est bien assignée
    this.loadQuartier();
  }
  //   handleProvinceChange(event) {
  //     this.selectedProville = event.target.value;
  //     console.log("province/ville selectionner", this.selectedProVille);
  //     console.log("proVille", event.detail.value);
  //     // this.loadQuartier();
  //   }

  handleQuartierChange(event) {
    this.selectedQuartier = event.target.value;
    console.log("quartier", event.target.value);
    // this.loadCommunes();
    // this.loadVoie();
    //   const payload = {
    //     province: this.selectedProVille,
    //     quartier: this.selectedQuartier,
    //   };

    //   publish(this.messageContext, ADDRESS_CHANNEL, payload);
    // }

    // LMS MessageContext
    // @wire(MessageContext) messageContext;


    
  }
}

//   handleCommuneChange(event) {
//     this.selectedCommune = event.target.value;
//     console.log("commune", event.target.value);
//   }

//   handleVoieChange(event) {
//     this.selectedVoie = event.target.value;
//     console.log("voie", event.target.value);
//   }

//   handleInputChange(event) {
//     this.numeroVoie = event.target.value;
//     console.log("numeroVoie", event.target.value);
//   }