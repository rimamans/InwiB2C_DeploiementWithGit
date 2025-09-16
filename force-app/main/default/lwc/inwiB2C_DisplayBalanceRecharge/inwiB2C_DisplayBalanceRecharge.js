import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_DisplayBalanceRecharge.html';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';


export default class InwiB2C_DisplayBalanceRecharge  extends OmniscriptBaseMixin(LightningElement) {

    @api records;
    @api mdn;
    @api subsid;
    @api canal;
    @api partenaire;
    @track selectedBalance;
    @track BalanceId;
    @track BalanceAmount;
    @track BalanceName;
    @track BalanceLabel;
    @track LastExpirationDate;
    @api ValidityDateValue= '';
    @api index=0;
    @track preSelectedRows = [];

    _actionUtilClass;
    _ns = getNamespaceDotNotation();

    @api ChangeDateSuccess = false;
    @api ChangeDateError = false;

    @track columns =[
        {fieldName: 'id', label: 'Id Balance', hideDefaultActions: true , initialWidth: 100,editable: false},
        {fieldName: 'name', label: 'Libellé', hideDefaultActions: true , initialWidth: 200,editable: false},
        {fieldName: 'value', label: 'Balance', hideDefaultActions: true,initialWidth: 100, editable: false, typeAttributes: {
            minimumFractionDigits: "2"
        }},
        {fieldName: 'unit', label: 'Unité', hideDefaultActions: true,initialWidth: 80, editable: false},
        {fieldName: 'startDateTime', label: 'Date début', hideDefaultActions: true,initialWidth: 200, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit", 
            second: "2-digit"
        }, editable: false},
        {fieldName: 'endDateTime', label: 'Date fin', hideDefaultActions: true,initialWidth: 420, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit", 
            second: "2-digit"
        }, editable: false}
         ];

    render() {
        //console.log(this.omniJsonData);
        return template;
    }

    handleBlur(evt) {
        this.omniUpdateDataJson(evt.target.value);
    }

    connectedCallback() {
        if (this.index == 0){
            this.index=1;
            
            if(this.records != null){
            let my_ids = [];
            my_ids.push(this.records[0].id);
            this.preSelectedRows = my_ids;

            console.log('preSelectedRows:' + this.preSelectedRows );
            let selectedBalance = { SelectedBalanceId : this.records[0].id, 
                        selectedBalanceAmount : this.records[0].value};
            let BalanceLabel = { BalanceLabelName : this.records[0].id, 
                                BalanceLabelValue : this.records[0].name};
                

            this.omniUpdateDataJson(BalanceLabel);
            this.omniSaveState(BalanceLabel,true);

            this.omniUpdateDataJson(selectedBalance);
            this.omniSaveState(selectedBalance,true);

            this.BalanceId = this.records[0].id;
            this.BalanceAmount = this.records[0].value;
            this.BalanceName = this.records[0].name;
            this.LastExpirationDate = this.records[0].endDateTime.substring(0,10);
    }

}
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }

    getSelectedBalance(event) {
        const selectedRows = event.detail.selectedRows;
        /*if(selectedRows.length>1)
        {
            var el = this.template.querySelector('lightning-datatable');
            console.log ('Old length of the table :' + selectedRows.length );
            selectedRows=el.selectedRows.slice(1);
            event.preventDefault();
            console.log ('New length of the table :' + selectedRows.length );
            return;
        }*/
        //for (let i = 0; i < selectedRows.length; i++){
            //alert("You selected: " + selectedRows[i].name);
    
            let selectedBalance = { SelectedBalanceId : selectedRows[0].id, 
                            selectedBalanceAmount : selectedRows[0].value};
            let BalanceLabel = { BalanceLabelName : selectedRows[0].id, 
                                BalanceLabelValue : selectedRows[0].name};
                   
    
            this.omniUpdateDataJson(BalanceLabel);
            this.omniSaveState(BalanceLabel,true);

            this.omniUpdateDataJson(selectedBalance);
            this.omniSaveState(selectedBalance,true);

            this.BalanceId = selectedRows[0].id;
            this.BalanceAmount = selectedRows[0].value;
            this.BalanceName = selectedRows[0].name;
            this.LastExpirationDate = this.records[0].endDateTime.substring(0,10);
            
            
       //}
}

handleValidityDateChange(event){
    
    this.ValidityDateValue = event.target.value;
    console.log( ' ValidityDate : ' + this.ValidityDateValue);
}

ChangeBalanceDate(event){

    let input = '{"mdn":"' + this.mdn+ '", "BalanceId":"' + this.BalanceId+ '", "ValidityDate":"' + this.ValidityDateValue + '" }';

    console.log('input : ' + input);

    const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: 'inwib2c_InwiB2C_IP_ChangeBalanceExpirationDate',
        options: '{}',
    };

    console.log('before call apex1' + JSON.stringify(params));

    this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
            if (response.error == false) {
                console.log(response.result);
                if (response.result.IPResult.CSOperationResultInfo.isOK == '1') {

                        this.ChangeDateError = false;
                        this.ChangeDateSuccess = true;

                        const params = {
                            input: '{}',
                            sClassName: 'InwiB2C_OperationHistory',
                            sMethodName: 'AddOperationHistory',
                            options: '{"SubscriptionId":"'+this.subsid+'","Canal":"'+this.canal+'","LibelleBalance":"'+this.BalanceName+'", "NewExpirationDate":"'+this.ValidityDateValue+'","LastExpirationDate":"'+this.LastExpirationDate+'", "Partenaire": "'+this.partenaire+'",   "TypeModification": "inwiB2C_ModificationDateExpiration", "TypeAction": "inwiB2C_RechargeManuelle", "StatutOperation": "OK", "SubActionOperation": "Modification Date d\'expiration", "ActionOperation": "Recharge manuelle","Mdn":"'+this.mdn+'"  }',
                        };
                   
                        this._actionUtilClass
                            .executeAction(params, null, this, null, null)
                            .then(response => {
                                console.log('Success row inserted');  
                                console.log(response)  ;
                
                            })
                            .catch(error => {
                                window.console.log(error);
                            });


                     }
                     else
                     {
                        this.ChangeDateError = true;
                        this.ChangeDateSuccess = false;

                        
                        const params = {
                            input: '{}',
                            sClassName: 'InwiB2C_OperationHistory',
                            sMethodName: 'AddOperationHistory',
                            options: '{"SubscriptionId":"'+this.subsid+'","Canal":"'+this.canal+'","LibelleBalance":"'+this.BalanceName+'", "NewExpirationDate":"'+this.ValidityDateValue+'","LastExpirationDate":"'+this.LastExpirationDate+'", "Partenaire": "'+this.partenaire+'",  "TypeModification": "inwiB2C_ModificationDateExpiration", "TypeAction": "inwiB2C_RechargeManuelle", "Commentaire": "Erreur technique", "StatutOperation": "KO", "SubActionOperation": "Modification Date d\'expiration", "ActionOperation": "Recharge manuelle","ErrorCodeOperation":"'+response.result.IPResult.CSOperationResultInfo.errorMessage+'","Mdn":"'+this.mdn+'"  }',
                        };
                   
                        this._actionUtilClass
                            .executeAction(params, null, this, null, null)
                            .then(response => {
                                console.log('Success row inserted');  
                                console.log(response)  ;
                
                            })
                            .catch(error => {
                                window.console.log(error);
                            });
                     }
                }
        })
        .catch(error => {
            console.log('error');
            this.ChangeDateError = true;
            this.ChangeDateSuccess = false;
            window.console.log(error);
        });

}
}