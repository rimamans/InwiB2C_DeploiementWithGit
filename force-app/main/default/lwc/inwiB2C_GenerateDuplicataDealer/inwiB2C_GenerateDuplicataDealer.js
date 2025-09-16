import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import template from "./inwiB2C_GenerateDuplicataDealer.html"

export default class InwiB2C_GenerateDuplicataDealer extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    //crm
    @api recordId;

    //pdv
    // @api Recordid;
    Recordid;

    @wire(CurrentPageReference) 
    getPageReference(currentPageReference) { 
        if (currentPageReference && currentPageReference.state) { 
            this.Recordid = currentPageReference.state.Recordid; 
            console.log('Record ID récupéré :', this.Recordid); 
        } 
    }


    @api subid;

    __showButton = false;
    @api 
    get showButton() {
        return this.__showButton;
    }
    set showButton(value) {
        this.__showButton = value;
    }
    isLoading = true

    _actionUtil;
    _ns = getNamespaceDotNotation();


    render() {
        return template;
    }

    renderedCallback() {

    }

    connectedCallback() {
        this._actionUtil = new OmniscriptActionCommonUtil();
        console.log('recordId',this.recordId);
        console.log('Recordid',this.Recordid);
        this.subid= (this.Recordid==undefined || this.Recordid=='') ? this.recordId : this.Recordid;
        console.log('this.subid',this.subid);
        console.log("showButton before call check",this.__showButton);
        this.checkSubscription();
        console.log("showButton after call check",this.__showButton);
        this.isLoading = false;
    }

    GenerateContract() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('recordId',this.recordId);
        let input = '{"subscriptionId":"' + this.subid + '"}';
        console.log('testgenerateContract');
        console.log("inputVIP", input);

        let params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "Inwi_InwiB2C_GenerateDuplicataDealer",
            options: {}
        };
        
        this._actionUtilClass.executeAction(params, null, this, null, null).then((response) => {
            console.log("responseVIP", response.result.IPResult);
            if (response.result.IPResult.error === "Vous n'etes pas eligible a regenererle contract") {
                console.log('error de generation');
                this.showErrorToast("Vous n'etes pas eligible a regenerer le contract");
            } else {
                this.callclass(response.result.IPResult);
            }
        });
    }
    callclass(event){
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        // event.souscriptionID = this.subid;
        let inputClass = JSON.stringify(event);
        console.log("inputClass", inputClass);
            let params = {
                input: inputClass,
                sClassName: 'inwiB2C_CallGenerateContractDealer',
                sMethodName: 'generateContractDealer',
                options: {}
            };
            this._actionUtilClass.executeAction(params, null, this, null, null).then((responseClass) => {
                console.log("responseClass",responseClass);
                // console.log('blob',responseClass.result.result.result.content);
                // console.log('documentName',responseClass.result.result.result.name);
                if(responseClass.result.result.errorName=="Bad Request"){
                    console.log('bad request');
                    this.showErrorToast(responseClass.result.result.error);
                }else{
                    this.updateTrace();
                    this.downloadPDF(responseClass.result.result.result.content,responseClass.result.result.result.name);
                }
            })
    }

    downloadPDF(blob,documentName){
        console.log('blob',blob);
        console.log('documentName',documentName);
            var link = document.createElement('a');

            link.href = 'data:application/octet-stream;base64,' + blob;
            link.download = documentName;
            link.click();

        
    }

    checkSubscription() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        let inputCheck = '{"subscriptionId":"' + this.subid + '"}';
        let params = {
            input: inputCheck,
            sClassName: 'inwiB2C_CallGenerateContractDealer',
            sMethodName: 'checkSubscription',
            options: {}
        };
        this._actionUtilClass.executeAction(params, null, this, null, null).then((responseCheck) => {
            console.log("responseCheck", responseCheck);
            this.__showButton = responseCheck.result.showButton.showButton;
            console.log('showButton after assign in check', this.__showButton);
        })
    }

    showErrorToast(message) {
        console.log("Message Toast: ", message);
        const event = new ShowToastEvent({
            title: 'Erreur',
            message: message,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }

    updateTrace() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        let inputCheck = '{"subscriptionId":"' + this.subid + '"}';
        let params = {
            input: inputCheck,
            sClassName: 'inwiB2C_CallGenerateContractDealer',
            sMethodName: 'updateTraceDuplicata',
            options: {}
        };
        this._actionUtilClass.executeAction(params, null, this, null, null).then((responseUpdate) => {
            console.log("responseUpdate", responseUpdate);
        })
    }
}