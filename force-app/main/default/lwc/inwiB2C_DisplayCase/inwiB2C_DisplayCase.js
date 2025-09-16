import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from './inwiB2C_DisplayCase.html';


export default class inwiB2C_DisplayCase extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
  ) {
    _ns = getNamespaceDotNotation();
    _actionUtilClass;
    __recordcase;
    __data = [];
    __size = -1;
    __selectedItem;
    @api
    get recordcase() {
        return this.__recordcase;
    }

    set recordcase(value) {
        this.__recordcase = value;
    }

    get isLoading() {
        const list = JSON.parse(JSON.stringify(this.recordcase));
        console.log("list.lenght !== this.__data.length");
        console.log(list.length);
        if (!this.__selectedItem && list.length) {
            console.log("selectedItem INIT start")
            if (list && list.length == 1) {
                var cases = JSON.parse(JSON.stringify(list));
                let selectedCase = {
                    "selectedCaseId": cases[0].Id
                   
                 
                }
                this.omniUpdateDataJson(selectedCase);
                this.omniSaveState(selectedCase, true);
                this.omniApplyCallResp(selectedCase);

            } else if (list && list.length > 1) {
                var cases = JSON.parse(JSON.stringify(list));
                var lenght = list.length - 1;
               
                    let selectedCase = {
                        "selectedCaseId": cases[lenght].Id
                       
                     
                    }
                  
                this.omniApplyCallResp(selectedCase);
                this.omniUpdateDataJson(selectedCase);
                this.omniSaveState(selectedCase, true);
            }
        }
        return this.__size === list.length;
    }

    handleSelectedAccounts(event) {
        console.log('handleSelectedCase' + event.target.dataset.idcase);
     
        var cases = JSON.parse(JSON.stringify(this.recordcase));
        let selectedItem = {};
        cases.map(item => {
            if (item.Id == event.target.dataset.idcase) {
                selectedItem = { ...item }
            }
        })
        this.__selectedItem = selectedItem.Id;
        let selectedCase = {
            "selectedCaseId": event.target.dataset.idcase
           
        }
        console.log("__selectedItem");
        console.log(this.__selectedItem);
        console.log(JSON.stringify(selectedCase));
        this.omniUpdateDataJson(selectedCase);
        this.omniSaveState(selectedCase, true);
        this.omniApplyCallResp(selectedCase);
    }
  

  /*  connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
      
    }*/
    render(event) {
        return template;
    }
}