import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_CasesDisplay.html';

export default class InwiB2C_CasesDisplay extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    constructor() {
        super();
        var numberofcases = 0;
        var opencases = [];
    }

    @api numberofcases; 
    @api opencases;         

    renderedCallback() {
    }





    navigateToRecordPage(sObject, recordId) {

        console.log('navigateToRecordPage executed');
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });

        console.log('navigateToRecordPage end') ;

    }


    openCaseSelection(event) {
        console.log('start openCaseSelection ') ;

        var  idsel = event.target.dataset.idsel; 
        
        console.log('idsel: '+idsel) ;
        this.navigateToRecordPage('Case', idsel) 


        console.log('end openCaseSelection ') ;

    }


    handleCaseSelection(event) {
        console.log('handleRowAction executed') ;

        var  idsel = event.target.dataset.idsel;       
        var  recap = event.target.dataset.recap;       
        var  categ = event.target.dataset.categ;       
        var  numligne = event.target.dataset.numligne;       
        var  credate = event.target.dataset.credate;       
        var  stat = event.target.dataset.stat;       



        console.log('idsel : '+idsel);
        console.log('Recapitulatif : '+recap);
        console.log('categ : '+categ);
        console.log('numligne : '+numligne);
        console.log('credate : '+credate);
        console.log('stat : '+stat);
        
        if (typeof idsel === 'undefined') idsel='';
        if (typeof recap === 'undefined')recap='';
        if (typeof categ === 'undefined') categ='';
        if (typeof numligne === 'undefined') numligne='';
        if (typeof credate === 'undefined') credate='';
        if (typeof stat === 'undefined') idsel='';


        let selectedCase = {
            "IdSelectedCase" : idsel,
            "Recapitulatif" : recap,
            "Categorie" : categ,
            "NumLigne" : numligne,
            "CreactedDate" : credate,
            "Status" : stat
        }

        console.log('selectedCase : ');
        console.log(selectedCase);

        this.omniUpdateDataJson(selectedCase);
        this.omniSaveState(selectedCase,true);
        this.omniNextStep();
/*
*/
    //    this.navigateToRecordPage('Case', selectedCaseLigne.IdCase);

        console.log('handleRowAction end');
    }

    render() {
        return template;
    }
    //#region ***************** RESIZABLE COLUMNS *************************************/
    handlemouseup(e) {
        this._tableThColumn = undefined;
        this._tableThInnerDiv = undefined;
        this._pageX = undefined;
        this._tableThWidth = undefined;
    }
 
    handlemousedown(e) {
        if (!this._initWidths) {
            this._initWidths = [];
            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            tableThs.forEach(th => {
                this._initWidths.push(th.style.width);
            });
        }
 
        this._tableThColumn = e.target.parentElement;
        this._tableThInnerDiv = e.target.parentElement;
        while (this._tableThColumn.tagName !== "TH") {
            this._tableThColumn = this._tableThColumn.parentNode;
        }
        while (!this._tableThInnerDiv.className.includes("slds-cell-fixed")) {
            this._tableThInnerDiv = this._tableThInnerDiv.parentNode;
        }
        console.log("handlemousedown this._tableThColumn.tagName => ", this._tableThColumn.tagName);
        this._pageX = e.pageX;
 
        this._padding = this.paddingDiff(this._tableThColumn);
 
        this._tableThWidth = this._tableThColumn.offsetWidth - this._padding;
        console.log("handlemousedown this._tableThColumn.tagName => ", this._tableThColumn.tagName);
    }
 
    handlemousemove(e) {
        console.log("mousemove this._tableThColumn => ", this._tableThColumn);
        if (this._tableThColumn && this._tableThColumn.tagName === "TH") {
            this._diffX = e.pageX - this._pageX;
 
            this.template.querySelector("table").style.width = (this.template.querySelector("table") - (this._diffX)) + 'px';
 
            this._tableThColumn.style.width = (this._tableThWidth + this._diffX) + 'px';
            this._tableThInnerDiv.style.width = this._tableThColumn.style.width;
 
            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            let tableBodyRows = this.template.querySelectorAll("table tbody tr");
            let tableBodyTds = this.template.querySelectorAll("table tbody .dv-dynamic-width");
            tableBodyRows.forEach(row => {
                let rowTds = row.querySelectorAll(".dv-dynamic-width");
                rowTds.forEach((td, ind) => {
                    rowTds[ind].style.width = tableThs[ind].style.width;
                });
            });
        }
    }
 
    handledblclickresizable() {
        let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
        let tableBodyRows = this.template.querySelectorAll("table tbody tr");
        tableThs.forEach((th, ind) => {
            th.style.width = this._initWidths[ind];
            th.querySelector(".slds-cell-fixed").style.width = this._initWidths[ind];
        });
        tableBodyRows.forEach(row => {
            let rowTds = row.querySelectorAll(".dv-dynamic-width");
            rowTds.forEach((td, ind) => {
                rowTds[ind].style.width = this._initWidths[ind];
            });
        });
    }
 
    paddingDiff(col) {
 
        if (this.getStyleVal(col, 'box-sizing') === 'border-box') {
            return 0;
        }
 
        this._padLeft = this.getStyleVal(col, 'padding-left');
        this._padRight = this.getStyleVal(col, 'padding-right');
        return (parseInt(this._padLeft, 10) + parseInt(this._padRight, 10));
 
    }
 
    getStyleVal(elm, css) {
        return (window.getComputedStyle(elm, null).getPropertyValue(css))
    }
 
}