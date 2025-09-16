import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

export default class inwiB2C_GetAgence extends OmniscriptBaseMixin(LightningElement) {


  _ns = getNamespaceDotNotation();
  @track value;

  @track idrec;

  @track optionsArray = [];

  show = false;
  @api profil;


  handleChanged(event) {


    this.value = event.target.value;
    if (this.value == '') {
      this.show = false;

    } else {
      this.show = true;

    }

    this._actionUtil = new OmniscriptActionCommonUtil();

    const params = {
      input: '{"search":"' + this.value + '"}',
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_Get_All_Agence2",
      options: '{}'
    };
    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log('response');
        console.log('response' + response.result.IPResult);
        console.log(JSON.stringify(response.result.IPResult));
        JSON.parse(JSON.stringify(response.result.IPResult));
        let res = response.result.IPResult.List;


        console.log('res');
        console.log(res);

        this.optionsArray = res;

        console.log('thisoptions:' + res);

      })
      .catch(error => {
        console.log("error");
        window.console.log(error);
      });

  }

  handleSelect(event) {
    this.show = false;
    this.value = event.target.dataset.codeagence + ', ' + event.target.dataset.name;
    this.idrec = event.target.dataset.idacc;
    console.log('return value');
    console.log(this.idrec);
    console.log(this.value);


    this.template.querySelectorAll('lightning-input').value = this.value;

    let AgenceResult = { "IdAgence": this.idrec, "dataAgence": this.value, "AgenceName": event.target.dataset.name, "CodeAgence": event.target.dataset.codeagence };


    this.omniUpdateDataJson(AgenceResult);
    this.omniSaveState(AgenceResult, true);
    this.optionsArray = [];


  }

}