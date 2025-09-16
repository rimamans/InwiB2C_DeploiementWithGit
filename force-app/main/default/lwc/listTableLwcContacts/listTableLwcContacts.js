import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { BaseState } from "vlocity_cmt/baseState";
import template from "./listTableLwcContacts.html"

export default class ListTableLwc extends NavigationMixin(BaseState(LightningElement)) {

    @track mapOfValues=[];
    @track page = 1;
    @track pages = [];
    @api recordId;
    
    perpage = 2;
    set_size = 2;
    @track numberOfPages=1;
    sortedDirection = 'asc';
    sortedColumn;

    render(){
        return template;
    }

    renderedCallback(){
        this.renderButtons();
    }

    connectedCallback(){ 
        this.initMapOfValues();
        this.setPages(this.mapOfValues);
        if(this.mapOfValues.length>0)
        this.numberOfPages = Math.ceil(this.mapOfValues.length/this.perpage);
        else 
        this.numberOfPages=1; 
    }

    handleKeyUp(event){
        this.initMapOfValues();
        var listFields = this.state.fields;
        var filtredMAp =  this.mapOfValues.filter(function(elem) {
            var result = false;
            listFields.forEach(
                field => {
                    if(elem[field.name.split("'")[1]] && elem[field.name.split("'")[1]].includes(event.target.value)){
                        result = true;
                    }
                }
            );
            return  result;
        });

        this.mapOfValues = filtredMAp;
        this.setPages(this.mapOfValues);
        this.page = 1;
    }

    handleSelectElement(event){
        this.mapOfValues.forEach(
            element => {
                if(element.Id == event.detail.idElem){
                    element.selected = event.detail.selected;
                }else{
                    element.selected = false;
                }
            }
        );
    }

    initMapOfValues(){
        this.mapOfValues=[];
        this.obj.list.forEach(
            element => {
                var newElement = JSON.parse(JSON.stringify(element));
                this.mapOfValues.push(newElement);
            }
        );
    }

    searchOnBlur(event){
        if(!event.target.value || event.target.value.trim() == ""){
            this.initMapOfValues();
            this.setPages(this.mapOfValues);
            this.page = 1;
        }
    }

    changePerpage(event){
        if(event.target.value){
            this.perpage = event.target.value;
            this.setPages(this.mapOfValues);
            this.page = 1;
        }
    }

    /*************** Pagination methods  **************/

    renderButtons(){
        this.template.querySelectorAll('lightning-button').forEach((but)=>{
            but.disabled = this.page===parseInt(but.dataset.id,10)?true:false;
        });
    }
    onNext(){
        ++this.page;
    }

    onPrev(){
        --this.page;
    }

    onPageClick(event){
        this.page = parseInt(event.target.dataset.id,10);
        
    }

    pageData(){
        let page = this.page;
        let perpage = this.perpage;
        let startIndex = (page*perpage) - perpage;
        let endIndex = (page*perpage);
        return this.mapOfValues.slice(startIndex,endIndex);
    }

    setPages(data){
        this.pages = [];
        let numberOfPages = Math.ceil(data.length / this.perpage);
        for (let index = 1; index <= numberOfPages; index++) {
            this.pages.push(index);
        }
    }

    handleDownClick(event){
        var actionElement = this.template.querySelector('c-list-action-lwc');
        var targetElement = event.target;
        
        this.mapOfValues.forEach(
            element => {
                if(targetElement === undefined || !targetElement || targetElement.tagName != actionElement.tagName){
                    element.selected = false;
                }
            }
        )
    }

    get hasPrev(){
        return this.page > 1;
    }
    
    get hasNext(){
        return this.page < this.pages.length;
    }  

    get currentPageData(){
        return this.pageData();
    }

    get pagesList(){
        let mid = Math.floor(this.set_size/2) + 1 ;
        if(this.page > mid){
            return this.pages.slice(this.page-mid, this.page+mid-1);
        } 
        return this.pages.slice(0,this.set_size);
    }


    // Sort Methods

    sort(e) {
        if(this.sortedColumn === e.currentTarget.dataset.id){
            this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
        }else{
            this.sortedDirection = 'asc';
        }        
        var reverse = this.sortedDirection === 'asc' ? 1 : -1;
        let table = this.mapOfValues;
        table.sort((a,b) => {
            var param1 = (a[e.currentTarget.dataset.id.split("'")[1]]) ? a[e.currentTarget.dataset.id.split("'")[1]] : '';
            var param2 = (b[e.currentTarget.dataset.id.split("'")[1]]) ? b[e.currentTarget.dataset.id.split("'")[1]] : '';

            if(!isNaN(Date.parse(param1)) && !isNaN(Date.parse(param2))){
                param1 = param1.split('/').reverse().join('');
                param2 = param2.split('/').reverse().join('');
            }
            return param1 > param2 ? 1 * reverse : -1 * reverse; 
            
        });
        this.sortedColumn = e.currentTarget.dataset.id;        
        this.mapOfValues = table;

        if(e.currentTarget.dataset.id){
            let existingIcon = this.template.querySelectorAll('th.slds-is-sortable');
            existingIcon.forEach(
                element => {
                    element.classList.remove('slds-is-sorted','slds-is-sorted_desc','slds-is-sorted_asc');
                }
            );

            if(this.sortedDirection === 'asc'){
                e.currentTarget.classList.add('slds-is-sorted','slds-is-sorted_asc');
            }
            if(this.sortedDirection === 'desc'){
                e.currentTarget.classList.add('slds-is-sorted','slds-is-sorted_desc');
            }
        }
    }  
    viewContacts(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Account',
                actionName: 'view'
            },
        });

    }
}