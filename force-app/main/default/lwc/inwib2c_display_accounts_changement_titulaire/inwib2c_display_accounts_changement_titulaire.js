import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwib2c_display_accounts_changement_titulaire.html";

export default class Inwib2c_display_accounts_changement_titulaire extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {
    @api profile;
    @api comefrom;
    loadindData = true;
    __hasError = false;
    __showAddAccount = false;
    search = "";
    __data = [];
    // Variables
    __accountid;
    __currentbillingaccount;
    __orderid;
   
    @api
    get accountid() {
        return this.__accountid;
    }
    set accountid(value) {
        this.__accountid = value;
    }

    @api
    get orderid() {
        return this.__orderid;
    }
    set orderid(value) {
        this.__orderid = value;
    }

    @api
    get currentbillingaccount() {
        return this.__currentbillingaccount;
    }
    set currentbillingaccount(value) {
        this.__currentbillingaccount = value;
    }

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }

    //
    handleSearch() {
        console.log(this.search);
        if (this.search !== "") {
            let input =
                `{
            "AccountId": "` + this.__accountid + `",
            "CIN": "` + this.search + `"
              }`;

              // acyl hassani 04/09/2024 cession ligne AM 

              const methodName = 
    this.comefrom === 'cessionAM' 
            ? "inwib2c_get_account_by_cinAM" // Méthode pour cessionAM
            : "inwib2c_get_account_by_cin"; // Méthode par défaut

          const params = {
              input,
              sClassName: `${this._ns}IntegrationProcedureService`,
              sMethodName: methodName,
              options: "{}",
          };
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log(response);
                    if (!response.error) {
                        if (response.result.IPResult && response.result.IPResult.AccountList) {
                            this.__showAddAccount = false;
                            let dataResult = response.result.IPResult.AccountList;
                            let data = [];
                            dataResult.map((item, index) => {
                                console.log(dataResult.length == 1);
                                item.index = index;
                                item.checked = index === 0; 
                                data.push(item);
                            })
                            this.__data = data;
                        } else {
                            this.__data = [];
                            this.__showAddAccount = true;
                        }
                    }
                })
                .catch(error => {
                    window.console.log(error);
                });
        }
    }

    handleChange(event) {
        this.search = event.target.value;
    }
    get isCessionPREPAYE() {
        return this.comefrom === 'cessionPREPAYE';
    }
    //
    handleAddAccount() {
        this.omniApplyCallResp({ newAccount: true });
        this.omniNextStep();
    }

    //
    selectItem(event) {
        let Id = event.target.name;
        let status = event.target.status;
        if (status) {
            let data = [...this.__data];
            data.map(item => {
                item.checked = false;
                return item
            });
            this.__data = data;
        } else {
            let data = [...this.__data];
            data.map(item => {
                if (Id == item.index) {
                    item.checked = true;
                } else {
                    item.checked = false;
                }
                return item
            });
            this.__data = data;
            console.log(data)
        }

    }
     

    

    SaveAndNext(evt) {
        console.log("save")
        let selected = this.__data.filter(item => {
            return item.checked;
        });

        if (selected.length > 0) {
            this.__hasError = false;
            this.saving = true;
            const selectedAccount = selected[0];
          
            this.omniApplyCallResp({ justificatiffff:true , selectedConsumerAccount: selectedAccount, newAccount: false });
            this.omniNextStep();
           
           
            // let input =
            //     `{
            // "OrderId": "` + this.__orderid + `",
            // "BillingAccountId": "` + selectedAccount.Id + `"
            //   }`;

            // const params = {
            //     input,
            //     sClassName: `${this._ns}IntegrationProcedureService`,
            //     sMethodName: "inwib2c_update_order_billing_account",
            //     options: "{}",
            // };

            // this._actionUtilClass
            //     .executeAction(params, null, this, null, null)
            //     .then(response => {
            //         let data = { selectedAccount };
            //         console.log(data);

            //     })
            //     .catch(error => {
            //         window.console.log(error);
            //     });

        } else {
            this.__hasError = true;
        }
    }
    handleSubSelection(event) {
        console.log('start handleSubSelection');
        var selectedsubscriptionId = event.target.name; 
        console.log('selectedsubscriptionId: ' + selectedsubscriptionId);
    
        let selectedSubscription = {
            "selectedSubscription": {
                "theId": selectedsubscriptionId.idclient,
                "redirectToSubscriptionDispaly": true
            }
        };
    
        this.omniUpdateDataJson(selectedSubscription);
        this.omniSaveState(selectedSubscription, true);
        this.omniNextStep();
    }
    
    handleBack() {
        let navi={
            justificatif:true,
    
    
          }
          
          this.omniApplyCallResp(navi);
       // this.omniNavigateTo("TypeChangements");
       this.omniNextStep();

    }

    render() {
        return template;
    }
   
    
    handleclick(event){
      
       //generate Link SF
     if(this.profile!="Inwi POS"){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                "recordId": event.target.dataset.codeclient,
                "objectApiName": "Account",
                "actionName": "view"
            },
        });
       
    } //generate Link Community
      else{
       
        let url ="/PortailPDVPhase2/s/account/"+ event.target.dataset.codeclient;
         this[NavigationMixin.GenerateUrl]({
            type: "standard__webPage",
            attributes: {
                url: url,
            },
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
    }
      
    }
}