import { LightningElement, track } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

export default class InwiB2C_EligibilityFTTHOnlyOrange extends OmniscriptBaseMixin(
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
        if (event.origin !== this.vfRoot) {
          return;
        }
      if (event.data && event.data.name === "VFtoLWC" && event.data.payload) {
        const { latitudeC, longitudeC  } = event.data.payload;
        this.latitudeC = latitudeC;
        this.longitudeC = longitudeC;
      } else if (event.data && event.data.searchCompleted) {
        this.isSearchDone = true;
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

  async executeEligibilityCheck(skipOperator) {
    let params = {
      input: JSON.stringify({
        skipOperator: skipOperator || "INWI",
        coordinates: {
          latitude: this.latitudeC,
          longitude: this.longitudeC
        }
      }),

      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_CheckEligibilityFTTHVula",
      options: {}
    };

    console.log("params to send with skip op INWI :", params);

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        const eligibilityFTTHResp = response.result.IPResult;
        console.log("responseeee vip", eligibilityFTTHResp)
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
}