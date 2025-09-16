import { LightningElement, track } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

export default class InwiB2C_EligibilityFTTHOnlyInwi extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  vfRoot = "https://inwi-b2c--devevol--c.sandbox.vf.force.com";

  @track isSearchDone = false;
  isServiceAccIdCreated = false;
  address = "";
  serviceAccId;
  mapData;
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
        const { latitudeC, longitudeC, triggerCheckEligibility } =
          event.data.payload;
        this.latitudeC = latitudeC;
        this.longitudeC = longitudeC;
        if (triggerCheckEligibility) {
          this.checkEligibilityFTTH();
        }
      } else if (event.data && event.data.action === "redirect") {
        this.redirectAcquisition();
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
          plateId,
          street,
          status,
          provider
        } = event.data.payload;
        this.building = building;
        this.city = city;
        this.plateId = plateId;
        this.street = street;
        this.latitude = latitude;
        this.longitude = longitude;
        (this.status = status), (this.provider = provider);

        this.isServiceAccIdCreated = true;
        this.inputOs =
          '{"InPlaque":"' +
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
      }
      console.log("gatherrrr data to init the creation of the site", this.inputOs);
    });
  }

  async checkEligibilityFTTH() {
    let params = {
      input: JSON.stringify({
        skipOperator: "",
        coordinates: {
          latitude: this.latitudeC,
          longitude: this.longitudeC
        }
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwiB2C_CheckEligibilityVulaInwi",
      options: {}
    };
    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        const eligibilityFTTHResp = response.result.IPResult;
        console.log("2222222222 vip test", eligibilityFTTHResp);

        if (eligibilityFTTHResp && Array.isArray(eligibilityFTTHResp.address)) {
          const mapData = eligibilityFTTHResp.address.map((address) => ({
            latitude: address.coordinate.latitude,
            longitude: address.coordinate.longitude,
            building: address.building,
            street: address.street,
            city: address.city,
            title: `${address.street} ${address.city} ${address.building}`,
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
      });
  }

  nextStep() {
    this.omniNextStep();
  }

  redirectAcquisition() {
    this.omniApplyCallResp({
      inputOsacq: JSON.parse(this.inputOs),
      test: "test"
    });
    this.omniNavigateTo("AcquisitionFTTHVula");
  }
}