import { LightningElement,api,track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from './inwiB2C_DisplayChargementSMOMassif.html';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class inwiB2C_DisplayChargementSMOMassif  extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    
    _actionUtilClass;
    lignes=[];
    @track 
    columns = [
            { label: 'Id du document', fieldName: 'UUID',hideDefaultActions: 'true' },
           // { label: 'Type de chargement', fieldName: 'Type de chargement',hideDefaultActions: 'true' },
            { label: 'Action', fieldName: 'Action',hideDefaultActions: 'true' },
            { label: 'Motif', fieldName: 'Motif',hideDefaultActions: 'true' },
            { label: 'Origine', fieldName: 'Origin',hideDefaultActions: 'true' },
            { label: 'MDN', fieldName: 'MDN', hideDefaultActions: true }
        ];
      
    @track data; //data diplayed on table
    @track startingRecord = 1;
    @track page = 1;
    @track endingRecord = 0;
    @track totalRecordCount = 0;
    @track totalPage= 0;
    @track pageSize = 50;
    @track initialRecords;
    @api documentid;
    @api typechargement;
    selectSub=false;
    @track selectedRows = [];
    @api action;
    norwos=true;
    getListInfo(){
            let input ={"selectedFile": this.documentid,"typechargement":this.typechargement,"action":this.action};
            console.log('Input: ',input);
            const varsMethodName =this.action=='edit' || this.typechargement === 'Chargement par Compte de facturation'?'getListByDocumentIdCF':'getListByDocumentId';
            const params = {
                input: JSON.stringify(input),
                sClassName: 'MDNFileHandler',
                sMethodName: varsMethodName,
                options: '{}',
            };
            this._actionUtilClass.executeAction(params, null, this, null, null).then(response => {
                console.log('response',response);
                if (response.result.List) {
                    this.data= JSON.parse(JSON.stringify(response.result.List));
                    if(this.data.length !== 0){
                        this.norwos=false;
                    } else{
                        this.norwos=true;
                    }  
                    this.setInfo();
                }
                else
                    this.norwos=true;
                    this.showMessage('Erreur','une erreur est survenue,merci de réessayer plus tard','error');
                    
            }
            ).catch(error => {
                console.log('error');
                window.console.log('lignesNOK: ',error);
      });
    }
    
    setInfo(){
        this.lignes=this.data.map(item=>{
            let statutColor = item.Statut == "Erreur" || item.Statut == "FAILED"  ? "slds-text-color_error":"slds-text-color_success"
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
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        if (this.typechargement === 'inwiB2C_CHCF' || this.typechargement === 'Chargement par Compte de facturation' ) {
            this.columns.push({ label: 'Compte de Facturation', fieldName: 'CompteFacturation', hideDefaultActions: true });
            this.columns.push({ label: 'Subscription', fieldName: 'Subscription', hideDefaultActions: true });
            this.columns.push({ label: 'Statut Souscription', fieldName: 'StatutSub', hideDefaultActions: true });
            this.columns.push({ label: 'Offre', fieldName: 'Offre', hideDefaultActions: true });   
            this.columns.push({ label: 'Date d\'activation', fieldName: 'DateActivationSub', hideDefaultActions: true });   
            this.columns.push({label: 'Statut', fieldName: 'Statut', hideDefaultActions: 'true',cellAttributes:{
                class:{fieldName:'statutColor'}}});
                this.columns.push({ label: 'Erreur', fieldName: 'Erreur',hideDefaultActions: 'true',cellAttributes:{
                class:{fieldName:'statutColor'}}});
            this.selectSub=false;
        }
        if(this.typechargement ==='Chargement par MDN'){
           
            this.columns.push({label: 'Statut', fieldName: 'Statut', hideDefaultActions: 'true',cellAttributes:{
                class:{fieldName:'statutColor'}}});
                this.columns.push({ label: 'Erreur', fieldName: 'Erreur',hideDefaultActions: 'true',cellAttributes:{
                class:{fieldName:'statutColor'}}});
        }
        console.log('edit:::',this.action);
        console.log('this.typechargement:::',this.typechargement);
        if(this.action=='edit'){
           /* this.columns.push({ label: 'Compte de Facturation', fieldName: 'CompteFacturation', hideDefaultActions: true });
            this.columns.push({ label: 'Subscription', fieldName: 'Subscription', hideDefaultActions: true });
            this.columns.push({ label: 'Statut Souscription', fieldName: 'StatutSub', hideDefaultActions: true });
            this.columns.push({ label: 'Date Activation', fieldName: 'DateActivationSub', hideDefaultActions: true });
          this.columns.push({label: 'Statut', fieldName: 'Statut', hideDefaultActions: 'true',cellAttributes:{
                class:{fieldName:'statutColor'}}});
                this.columns.push({ label: 'Erreur', fieldName: 'Erreur',hideDefaultActions: 'true',cellAttributes:{
                class:{fieldName:'statutColor'}}});*/
            this.selectSub=true;
        } 
        
        this.getListInfo();
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
        console.log('searchKey' + searchKey);
        console.log('this.lignes',this.lignes);
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
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log(`Action: ${actionName}, Row Data:`, JSON.stringify(row));

        if (actionName === 'select') {
            this.omniUpdateDataJson({ selectedSubscription: row });
            this.omniSaveState({ selectedSubscription: row }, true);
        }
    }

    handleRowSelection(event) {
        this.selectedRows = event.detail.selectedRows.map(row => row.IdTreatment);
        console.log('Selected Treatment Row IDs:', JSON.stringify(this.selectedRows));

        this.omniApplyCallResp({ selectedRows: this.selectedRows });
    }
    
    handlePublishButtonClick() {
        if (this.selectedRows.length === 0) {
            this.showToast('Warning', 'Please select at least one row.', 'warning');
            return;
        }

       // this.isLoading = true;
        const params = {
            input: JSON.stringify({ selectedRowIds: this.selectedRows, contentDocumentId: this.documentid }),
            sClassName: 'MDNFileHandler',
            sMethodName: 'processSelectedRows',
            options: '{}',
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then((response) => {
                //this.isLoading = false;
                this.showToast('Success', 'Selected rows processed successfully.', 'success');
                console.log('Process Response: ', JSON.stringify(response));
                this.omniApplyCallResp({ 'operation':'soumissionok' });
                this.omniNextStep();
            })
            .catch((error) => {
                this.isLoading = false;
                console.error('Error processing selected rows: ', JSON.stringify(error));
                this.showToast('Error', 'An error occurred while processing the rows.', 'error');
            });
    }
    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            })
        );
    }
   
}