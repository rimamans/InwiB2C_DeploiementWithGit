import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_BalanceDisplay.html';

export default class InwiB2C_BalanceDisplay  extends OmniscriptBaseMixin(LightningElement) {

    @api records;

    @track columns =[

        {fieldName: 'id', label: 'Id Balance', hideDefaultActions: true , initialWidth: 170,editable: false},
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
        {fieldName: 'endDateTime', label: 'Date fin', hideDefaultActions: true,initialWidth: 200, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit", 
            second: "2-digit"
        }, editable: false},
        {label: 'Usages', type: "button", initialWidth: 120, typeAttributes: { label: "Usages", name: "usages", title: 'Cliquer ici pour le détail des usages', disabled: { fieldName: 'isUsageBlanc'}}},
        {fieldName: 'familyName', label: 'Famille', hideDefaultActions: true , initialWidth: 170, editable: false}
         ];
    
    @track usageData = [];
    @track usageColumns = [
        {fieldName: 'name', label: 'Nom', hideDefaultActions: true},
        {fieldName: 'value', label: 'Valeur', hideDefaultActions: true},
        {fieldName: 'unit', label: 'Unité', hideDefaultActions: true},
        {fieldName: 'type', label: 'Type', hideDefaultActions: true}
        ];


    render() {

        //console.log(this.omniJsonData);
        return template;
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        
        this.usageData = row.usages;

        this.openmodal();

        

        
    }

    @track openUsageDetail = false;
    openmodal() {
            this.openUsageDetail = true
        }
    closeModal() {
            this.openUsageDetail = false
        } 

    handleBlur(evt) {
        this.omniUpdateDataJson(evt.target.value);
    }

}