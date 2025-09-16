import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { NavigationMixin } from 'lightning/navigation';

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";


export default class InwiB2C_DownloadCSVFile extends OmniscriptBaseMixin(LightningElement) {

    @api eligiblesrecordsnumber;
    @api noneligiblesrecordsnumber;
    @api noneligiblesrecords;
    @api eligiblesrecords;
    @api action;
    @api origine;
    @api motif;
    @api documentid;
    //@track result;
    // @track data = [];
    _ns = getNamespaceDotNotation();
    _actionUtil;

    connectedCallback() {
        this._actionUtil = new OmniscriptActionCommonUtil();
        console.log('Data: ' + JSON.stringify(this.eligiblesrecords));
        console.log('action/origine' + this.action + ' / ' + this.origine + ' / ' + this.motif);

    }
    downloadCSVFileTraite() {
        console.log('eligiblesrecords' + this.eligiblesrecords);
        let rowEnd = '\n';
        let csvString = '';
        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
        this.eligiblesrecords.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
            });
        });

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);

        // splitting using ','
        csvString += rowData.join(',');
        csvString += rowEnd;

        // main for loop to get the data based on key value
        for (let i = 0; i < this.eligiblesrecords.length; i++) {
            let colValue = 0;

            // validating keys in data
            for (let key in rowData) {
                if (rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    console.log('key:' + key);
                    
                    let rowKey = rowData[key];
                    // add , after every value except the first.
                    if (colValue > 0) {
                        csvString += ',';
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = this.eligiblesrecords[i][rowKey] === undefined ? '' : this.eligiblesrecords[i][rowKey];
                    csvString += '"' + value + '"';
                    colValue++;
                    console.log('csvString:' + csvString);
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        downloadElement.href = 'data:decimal/vnd.ms-excel,' + encodeURIComponent(csvString);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = 'MDN_Managed.csv';
        // click() Javascript function to download CSV file
        downloadElement.click();
    }
    downloadCSVFileRejet() {
        console.log('noneligiblesrecords' + this.noneligiblesrecords);
        let rowEnd = '\n';
        let csvString = '';
        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
        this.noneligiblesrecords.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
            });
        });

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);

        // splitting using ','
        csvString += rowData.join(',');
        csvString += rowEnd;

        // main for loop to get the data based on key value
        for (let i = 0; i < this.noneligiblesrecords.length; i++) {
            let colValue = 0;

            // validating keys in data
            for (let key in rowData) {
                if (rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    console.log('key:' + key);
                    
                    let rowKey = rowData[key];
                    // add , after every value except the first.
                    if (colValue > 0) {
                        csvString += ',';
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = this.noneligiblesrecords[i][rowKey] === undefined ? '' : this.noneligiblesrecords[i][rowKey];
                    csvString += '"' + value + '"';
                    colValue++;
                    console.log('csvString:' + csvString);
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        downloadElement.href = 'data:decimal/vnd.ms-excel,' + encodeURIComponent(csvString);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = 'MDN_NoManaged.csv';
        // click() Javascript function to download CSV file
        downloadElement.click();
    }
    handleCancel() {

        if (this.noneligiblesrecords || this.eligiblesrecords) {
            const input = { "documentid": this.documentid };
            const options = {};
            const params = {
                input: JSON.stringify(input),
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_inwiB2C_UpdateAllRecordsStatusToCacelled",
                options: JSON.stringify(options),
            };
            this._actionUtil
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log(response);
                    //let dataResponse = response.result && response.result.IPResult && response.result.IPResult.accounts ? response.result.IPResult.accounts : [];
                    
                })
                .catch(error => {
                    console.log("error");
                    window.console.log(error);
                });
                this.omniApplyCallResp({ 'operation': 'Annulation' });
                this.omniNextStep();
            
        }
    }
    handleNext() {
        console.log('Dataaa: ' + this.eligiblesrecords);
    if(this.action != 'RESIL' && this.action != 'RESILD' ){
        if (this.eligiblesrecords) {
            // Cancel No managed SF Subscription
            // this.omniNextStep();
            console.log('action/origine:'+this.action);
            for (let i = 0; i < this.eligiblesrecords.length; i += 2) {

                console.log('eligiblesrecords' + this.eligiblesrecords);
                const chunk = this.eligiblesrecords.slice(i, i + 2);
                console.log('chunk:' + chunk);
                let MdnList = [];
                chunk.map(item => {
                    MdnList.push({ mdn: item.mdn });
                })
                let data = { "data": MdnList, "action": this.action, "origine": this.origine,"motif": this.motif };
                console.log('chunk' + JSON.stringify(data));
                let input = { "mdnList": data };
                const params = {
                    input: input,
                    sClassName: 'inwiB2C_CreateTraitementMassif',
                    sMethodName: 'applyTraitment',
                    options: '{}',
                };
                this._actionUtil
                    .executeAction(params, null, this, null, null)
                    .then(response => {
                       let result = response.result.result.status;
                       
                       if (result == '1') {
           
                           this.omniApplyCallResp({ 'operation': 'soumissionok' });
           
                       }else {
                           this.omniApplyCallResp({ 'operation': 'soumissionko' });
                       }
           
                       this.omniNextStep();
                    })
                    .catch(error => {
                        console.log("error");
                        window.console.log(error);
                    });

            }
            
        }
    }else{
        this.omniApplyCallResp({ 'operation': 'resilok' });
        this.omniNextStep();
    }
    }
}