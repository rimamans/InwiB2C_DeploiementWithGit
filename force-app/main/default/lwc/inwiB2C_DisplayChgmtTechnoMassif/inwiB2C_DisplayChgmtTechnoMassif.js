import { LightningElement,api,track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from './inwiB2C_DisplayChgmtTechnoMassif.html';

export default class InwiB2C_DisplayChgmtTechnoMassif extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    __records = [];
    @api
    get records() {
        return this.__records;
    }
    set records(value) {
        this.__records = value;
        }
    lignes=[];
    @track 
    columns = [
            //{ label: 'Id Du ficher', fieldName: 'InwiB2C_UIID__c',hideDefaultActions: 'true' },
            { label: 'ND', fieldName: 'InwiB2C_Nd__c',hideDefaultActions: 'true' },
            { label: 'Adresse MAC', fieldName: 'InwiB2C_Mac__c',hideDefaultActions: 'true' },
            { label: 'Technologie source', fieldName: 'InwiB2C_Technologie_source__c',hideDefaultActions: 'true',},
            { label: 'Technlogie cible', fieldName: 'InwiB2C_Technologie_Cible__c',hideDefaultActions: 'true' },
            {label: 'Statut', fieldName: 'InwiB2C_Statut__c', hideDefaultActions: 'true',cellAttributes:{
                class:{fieldName:'statutColor'}}},
            { label: 'Erreur', fieldName: 'InwiB2C_Erreur__c' ,hideDefaultActions: 'true',cellAttributes:{
                class:{fieldName:'ErrorColor'}}}
        ];
    
    @track data; //data diplayed on table
    @track startingRecord = 1;
    @track page = 1;
    @track endingRecord = 0;
    @track totalRecordCount = 0;
    @track totalPage= 0;
    @track pageSize = 50;
    @track initialRecords;
     
    setInfo(){
        this.lignes=this.__records.map(item=>{
            let statutColor = item.InwiB2C_Statut__c == "Error" ? "slds-text-color_error":"slds-text-color_success"
            return {...item, 
                "statutColor":statutColor,
                "ErrorColor":"slds-text-color_error"
            }
        });
       this.totalRecordCount = this.lignes.length;
        this.totalPage = Math.ceil(this.totalRecordCount/this.pageSize);
        this.data = this.lignes.slice(0,this.pageSize);
        this.initialRecords = this.data;
        this.endingRecord = this.pageSize;
    }
    connectedCallback(){
        this.setInfo();
    }
    prevHandler(event){
        if(this.page > 1){
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }
    nextHandler(event){
        if(this.page < this.totalPage && this.page !== this.totalPage){
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);            
        }
    }
    displayRecordPerPage(page){
        this.startingRecord = (page - 1) * this.pageSize;
        this.endingRecord = page * this.pageSize;
        this.endingRecord = (this.endingRecord > this.totalRecordCount)?this.totalRecordCount:this.endingRecord;
        this.data = this.lignes.slice(this.startingRecord,this.endingRecord);
        this.initialRecords = this.data;
        this.startingRecord = this.startingRecord + 1;
    }

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
        if (searchKey) {
            this.data = this.initialRecords;
            if (this.lignes) {
                let searchRecords = [];
                for (let record of this.lignes) {
                    let valuesArray = Object.values(record);
                    for (let val of valuesArray) {
                        console.log('val is ' + val);
                        let strVal = String(val); 
                        if (strVal) { 
                            if (strVal.toLowerCase().includes(searchKey)) {
                                searchRecords.push(record);
                                break;
                            }
                        }
                    }
                }
                this.data = searchRecords;
            }
        } else {
            this.data = this.initialRecords;
        }
    }
    render(){
        return template;
    }
}