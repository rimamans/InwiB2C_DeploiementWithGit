import { LightningElement, track } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";

export default class inwiB2C_EligibilityHome5G extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  vfRoot = "https://inwi-b2c--devevol--c.sandbox.vf.force.com";

//   @track proVilleOptions = [];
//   @track quartierOptions = [];
//   @track searchProvince = "";
//   @track searchQuartier = "";
//   @track showProvinceOptions = false;
//   @track showOptions = false;
//   @track filteredProvinceVilleOptions = [];
//   @track filteredQuartiersOptions = [];
//   @track quartierLoading = true;
  @track isSearchDone = false;
  @track latitude = "";
  @track longitude = "";
  @track showEligibilityPopup = false;
  @track showNoEligibilityPopup = false;$
  showButtonSuivant = false ; 

//   codeProvince;
//   valueProvince;
//   selectedProVille = "";
//   selectedQuartier = "";
//   selectedCommuneCode = "";
//   selectedQuartierLabel = "";
//   selectedVoie = "";
  eligibilityMessage = "";
  address = "";


//   serviceAccId;
  isServiceAccIdCreated = false;
  omniScriptUrl;
  inputOs;
//   operatorOI;
  _actionUtil;
  _ns = getNamespaceDotNotation();

  connectedCallback() {
    this._actionUtil = new OmniscriptActionCommonUtil();
    // this.loadProvinces();
    window.addEventListener("scroll", this.handleScroll, true);
    // window.addEventListener("message", this.handleMessage.bind(this));

    window.addEventListener("message", (event) => {
      if (
        event.data &&
        event.data.name === "GPS" &&
        event.data.payload
      ) {
        const { latitudeC, longitudeC } = event.data.payload;
        this.latitudeC = latitudeC;
        this.longitudeC = longitudeC;

        if (this.isSearchDone) {
          this.isServiceAccIdCreated = false ;
          this.latitude = this.latitudeC;
          this.longitude = this.longitudeC;
        }
      } else if (event.data && event.data.searchCompleted) {
        this.isSearchDone = true;
        this.isServiceAccIdCreated = false ;
        this.latitude = this.latitudeC;
        this.longitude = this.longitudeC;
        console.log("this latitude 11", this.latitudeC);
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

  // handleMessage(event) {
  //   const data = event.data;

  //   if (data && data.name === "GPS" && data.payload) {
  //     const { latitudeC, longitudeC } = data.payload;
  //     this.latitudeC = latitudeC;
  //     this.longitudeC = longitudeC;

  //     if (this.isSearchDone) {
  //       this.latitudeGPS = this.latitudeC;
  //       this.longitudeGPS = this.longitudeC;
  //     }
  //   } else if (data && data.searchCompleted) {
  //     this.isSearchDone = true;
  //     this.latitudeGPS = this.latitudeC;
  //     this.longitudeGPS = this.longitudeC;
  //   }
  // }

  showMessage(t, m, type) {
    const toastEvt = new ShowToastEvent({
      title: t,
      message: m,
      variant: type
    });
    this.dispatchEvent(toastEvt);
  }

  async checkEligibility5G() {

    // this.showButtonSuivant = true ; 
    let params = {
    input: JSON.stringify({
      latitude: this.latitudeC,
      longitude: this.longitudeC
    }),
    sClassName: `${this._ns}IntegrationProcedureService`,
    sMethodName: "inwib2c_CheckEligibilityHome5G",
    options: {}
  };

  const response = await this._actionUtil.executeAction(params, null, this, null, null);
  const eligibility5GResp = response.result.IPResult;

  this.isServiceAccIdCreated = (eligibility5GResp.isEligible === true); 
  console.log('resp api 5G gps' , eligibility5GResp.isEligible) ;

  if (this.isServiceAccIdCreated) {
    this.showMessage('Succès', "Le logement est éligible à la 5G.", 'success');
   
  } else {
    this.showMessage('Erreur', "Le logement est non éligible à la 5G.", 'error');
    
  }
  }

  generateInputOS() {
  this.inputOs = JSON.stringify({
   
    InLatitudeGps: this.latitude,
    InLongitudeGps: this.longitude
 

  });
}
  redirectAcquisition() {
   this.showEligibilityPopup = false;
   console.log('next step 11') ;
//    this. generateInputOS() ; 
    console.log('next step 2') ;
//    this.omniApplyCallResp({
//       inputOsacq: JSON.parse(this.inputOs),
//       test: "test"
//     });
    
  this.omniNextStep();
  }

  handleNext() {
    this.omniNextStep();
  }

}