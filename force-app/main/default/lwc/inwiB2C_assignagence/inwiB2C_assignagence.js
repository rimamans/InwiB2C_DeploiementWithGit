import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_assignagence.html';



    export default class inwiB2C_assignagence extends OmniscriptBaseMixin(LightningElement) {

        _list = [];

        __records;


        ALLRECORDS = [];

        __records;
        @api
        get records() {
            if(this.ALLRECORDS.length==0)
                this.ALLRECORDS=this.__records;

            return this.__records;
        }
        set records(value) {
            this.__records = value;
            console.log('__records1' + JSON.stringify(this.__records));
        }
       
    
     
    
        get list() {
            try {
                console.log('__records' + JSON.stringify(this.__records));
    
                if (this.__records) {
                    let history = JSON.parse(JSON.stringify(this.__records));
                    
                    console.log(JSON.stringify(this._properties));
                    return this._properties;
                } else {
                    return [];
                }
            } catch (error) {
                console.log('error: ' + error);
                return [];
    
            }
        }
    
        
    
    
        @track columns = [
    
            //B-0875 RMA 07/05/2021 end
           
            {
                fieldName: 'AgenceName', label: 'Agence', hideDefaultActions: true, type: "text", editable: false
            },
            {fieldName: 'CodeDistri', label: 'Code Agence', hideDefaultActions: true, type: "text", editable: false
        },
        {fieldName: 'ville', label: 'Ville', hideDefaultActions: true, type: "text", editable: false
    }
    ,
        {fieldName: 'DistriName', label: 'Distributeur', hideDefaultActions: true, type: "text", editable: false
    }
           
        ];
    
    
    
    
    
      
        
    
    
    
        searchDataTable(event){

            try {
                var searchString =event.target.value.toUpperCase();
                // var allTheRecords =   this.__records;
                 var searchResults =[];
                 var i;
             
                 console.log('searchString:: '+searchString)
                 if(searchString==''){
                     console.log('if::searchString:: '+searchString)
                     console.log('if::this.ALLRECORDS.length:: '+this.ALLRECORDS.length)
     
                     console.log('if::this.ALLRECORDS:: ')
                     console.log(this.ALLRECORDS)

                     this.__records=this.ALLRECORDS;
                 }
                 
                 else{
     
                     for(i=0; i<this.ALLRECORDS.length; i++){
                        if((this.ALLRECORDS[i].AgenceName) && (this.ALLRECORDS[i].AgenceName.toUpperCase().includes(searchString)) || 
                            (this.ALLRECORDS[i].CodeDistri) && (this.ALLRECORDS[i].CodeDistri.toUpperCase().includes(searchString)) ||
                            (this.ALLRECORDS[i].ville) && (this.ALLRECORDS[i].ville.toUpperCase().includes(searchString)) ){
                             searchResults.push(this.ALLRECORDS[i]);
                         }
                     }
                     this.__records = searchResults;
                 }   

            } catch (error) {
                console.log('error :::'+error )
            }

        }
    


        preSelectedRows = []
        lastslectedId;
        getSelectedName(event) {
            const selectedRows = event.detail.selectedRows;

            console.log('Selected Records: ');
            console.log(event.detail.selectedRows);


            console.log('Selected Records length: ');
            console.log(event.detail.selectedRows.length);


            console.log('last Selected Records: ');
            console.log(event.detail.selectedRows[event.detail.selectedRows.length-1]);

            let IdAgence = selectedRows[event.detail.selectedRows.length-1].IdAgence;

            this.omniUpdateDataJson({ "IdDelectedAgence": IdAgence });
            let my_ids = [];
            my_ids.push(selectedRows[event.detail.selectedRows.length-1].AgenceName);
            this.preSelectedRows = my_ids;
/*
           // event.detail.selectedRows = event.detail.selectedRows[event.detail.selectedRows.length-1];

            var el = this.template.querySelector('lightning-datatable');
            console.log('el.SelectedRows::');
            console.log(el.SelectedRows);

           //  this.preSelectedRows=event.detail.selectedRows[event.detail.selectedRows.length-1];
             console.log('selectedRows[event.detail.selectedRows.length-1].AgenceName::');
             console.log(selectedRows[event.detail.selectedRows.length-1].AgenceName);

             if(event.detail.selectedRows.length==2){
                this.lastslectedId=selectedRows[event.detail.selectedRows.length-1].AgenceName;
                 my_ids.push(selectedRows[event.detail.selectedRows.length-1].AgenceName);
             }else{

                this.lastslectedId=selectedRows[event.detail.selectedRows.length-1].AgenceName;

             }

             this.preSelectedRows = my_ids;*/
        }

        render() {
    
            //console.log(this.omniJsonData);
            return template;
        }
    
    
    
}