import { LightningElement, api, wire } from 'lwc';

import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";


const columns = [
    {
        label: "Name", fieldName: "asset_link", type: "url",
        typeAttributes: {
            label: {
                fieldName: "name",
            },
            target: "_blank",
        },
    },
    { label: 'Date de création', fieldName: 'date' },
];




export default class OmnistudioSampleComponent extends OmniscriptBaseMixin(LightningElement) {

    tableData = [];
    columns = columns;

    @api
    set list(value) {
        console.log('value', JSON.stringify(value))

        this.tableData = value && value.map(item => {
            let asset_link = `/lightning/r/Asset/${item.AssetId}/view`;
            return { ...item, asset_link }
        });
    }

    get list() {
        return this.tableData;
    }


    // connectedCallback(){
    //     const jsonData = JSON.parse(JSON.stringify(this.omniJsonData));
    //     this.tableData = jsonData.oppData;
    // }


}