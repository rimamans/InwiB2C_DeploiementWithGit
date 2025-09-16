import { LightningElement, track } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

export default class Inwib2c_CheckEligibilityVulaOrangeInActive extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  vfRoot = "https://inwi-b2c--devevol--c.sandbox.vf.force.com";
  @track isSearchDone = false;
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

    window.addEventListener("message", (event) => {
      if (event.data && event.data.name === "VFtoLWC" && event.data.payload) {
        const { latitudeC, longitudeC, triggerCheckEligibility  } = event.data.payload;
        this.latitudeC = latitudeC;
        this.longitudeC = longitudeC;
        if (triggerCheckEligibility) {
          this.checkEligibilityFTTH();
        }
      } else if (event.data && event.data.action === "redirect") {
        this.redirectAcquisition();
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
        this.collectPointId = collectPointId;

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
    });
  }

  async checkEligibilityFTTH() {
    let params = {
      input: JSON.stringify({
        skipOperator: "INWI",
        coordinates: {
          latitude: this.latitudeC,
          longitude: this.longitudeC
        }
      }),

      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_CheckEligibilityFTTHVula",
      options: {}
    };

    console.log("params to send with skip INW IN ORANGE:", params);

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        const eligibilityFTTHResp = response.result.IPResult;
        console.log("response vip", eligibilityFTTHResp)
        const { operator } = eligibilityFTTHResp;
        this.operatorOI = operator;
        this.skipOperator = operator;

         if (eligibilityFTTHResp && Array.isArray(eligibilityFTTHResp.address)) {
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

          const iframeEligibleOrange = this.template.querySelector("iframe");
          if (iframeEligibleOrange) {
            iframeEligibleOrange.contentWindow.postMessage(
              { name: "OrangeData", orangeData },
              this.vfRoot
            );
          }
        } 
  });
  }

  redirectAcquisition() {
    this.omniApplyCallResp({
      inputOsacq: JSON.parse(this.inputOs),
      test: "test"
    });
    this.omniNextStep();
  }

    handleQuit(event){
    window.location.href = '/lightning/page/home';
  }

}