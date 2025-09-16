import { LightningElement, api, track ,wire} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
// import AddOperationHistory from '@salesforce/apex/InwiB2C_OperationHistory.AddOperationHistory';
import template from './inwiB2C_SubProductsDisplaySurFact.html';

const actions = [];
const columns = [
    { label: 'Sous produit IN', fieldName: 'id', sortable : true,initialWidth: 160 },
    { label: 'Description', fieldName: 'label', sortable : true ,initialWidth: 300},
    { label: 'Produit pass', fieldName: 'pass_prd',initialWidth: 140 },
    { label: 'Statut', fieldName: 'status',initialWidth: 120},
        ];
let status='OK';
let action='Activation';
let errormsg='';

export default class InwiB2C_SubProductsDisplaySurFact extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    constructor() {
        super();
        var allsubproductsnumber = 0;
        var allsubproducts  = [];
        var filtereddata= [];

        var numeromdn=0;
        this.columns = [
            { label: 'Sous produit IN', fieldName: 'id', sortable : true },
            { label: 'Description', fieldName: 'label', sortable : true },
            { label: 'Produit pass', fieldName: 'pass_prd', sortable : true},
            { label: 'Statut', fieldName: 'status', sortable : true},
            { type: 'action',maxColumnWidth : 120 ,typeAttributes: { rowActions: this.getRowActions } ,},
        ]
    }


    columns = columns;
    @api allsubproducts;
    @api allsubproductsnumber;
    @api numeromdn;
    @api canal;
    @api subid;
    @api partenaire;
    @api surfacture;
    filteredResults = [];
    sortBy;
    sortDirection='asc';
    _ns = getNamespaceDotNotation();
    _actionUtilClass;


    renderedCallback() {
    
    }
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
     
    }


    
    getRowActions(row, doneCallback) {
        const actions = [];
            if (row['status']=='Inactif') {
                actions.push({
                    'label': 'Activer',
                    'name': 'ADD'
                });

            } else {
                actions.push({
                    'label': 'Desactiver',
                    'name': 'DEL'
                });
                actions.push({
                    'label': 'Reconduire',
                    'name': 'MOD'
                });
            }

            setTimeout(() => {
                doneCallback(actions);
            }, 200);
        }

    get columns(){

        console.log(this.columns);
        console.log(JSON.stringify(this.allsubproducts));

        return JSON.parse(this.columns);


    }

 
    render() {
        console.log('filtereddata')
        console.log(this.filtereddata)
        return template;
    }
    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;

        // sort direction
        this.sortDirection = event.detail.sortDirection;
        console.log("event.detail.sortDirection : "+ event.detail.sortDirection)

        // calling sortdata function to sort the data based on direction and selected field

        console.log("event.detail.fieldName : "+ event.detail.fieldName)
        console.log("this.sortDirection : "+ this.sortDirection)
        try {
            this.sortData(event.detail.fieldName, this.sortDirection);

        } catch (error) {
                console.log(error);
        }
    }
    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.allsubproducts));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.allsubproducts = parseData;

    }
    handleactionsubproducts(event) {
            // Retrieves the name of the selected filter
        const actionName = event.detail.action.name;
        const orderItemId = event.detail.row.id;
        const orderItemName = event.detail.row.label;
        if (this.partenaire === null){
           this.partenaire='0014K00000D8muEQAR';
            }
   
        switch (actionName) {
            case 'ADD':
                
               console.log('surfacture var : ' + this.surfacture,typeof this.surfacture);
               var action="";
                if (this.surfacture == true){
                    action="ON_BILL";
                     }
                let struct={
                  "action" : action ,
                  "type" : event.detail.row.pass_prd ,
                  "mdn" : this.numeromdn,
                   "productOrderItem"  : [
                    {
                        "orderItemAction" : event.detail.action.name ,
                        "orderItemId"  : event.detail.row.id
                    }
                  ]
                };
               if( event.detail.row.pass_prd=='FUNV'){
                struct={
                    "action" : action ,
                    "type" : event.detail.row.pass_prd ,
                    "mdn" : this.numeromdn,
                       "productOrderItem"  : [
                        {
                           
                            "name":"MagicVoice",
                            "orderItemId"  : event.detail.row.id
                        }
                      ]
                    };
               }
           
              console.log(JSON.stringify(struct));
                
                const params1 = {
                    input: JSON.stringify(struct),
                    sClassName: `${this._ns}IntegrationProcedureService`,
                    sMethodName: 'Inwi_InwiB2C_SubProductsActivation',
                    options: '{}'
                };
        
                console.log('before calling rq0010' + JSON.stringify(params1));
            
                this._actionUtilClass
                    .executeAction(params1, null, this, null, null)
                    .then(response => {
                        console.log('Success api RQ0010  called');  
                        console.log(JSON.stringify(struct));
                        console.log(response);
                        if (response.result.IPResult.success === false)
                        {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Erreur',
                                // Acyl 12/08/2025 ticket tasksforce B-21724  begin
                                message: 'Les frais d\'abonnement sur facture dépassent le quota configuré dans le cycle de facturation en cours (Rx)',
                                // Acyl 12/08/2025 ticket tasksforce B-21724  end
                                variant: 'error'
                                }),
                            );
                            
                            this.status='KO';
                            this.action='Activation';
                            this.errormsg=response.result.IPResult.result.message;
                            console.log(this.errormsg);
                        }else if(response.result.IPResult.message==='SUCCESS')
                        {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'success',
                                message: 'l\'activation a été executé avec succès',
                                variant: 'success'
                                }),
                            );
                            this.status='OK';
                            this.action='Activation';
                            this.errormsg='';
                        }else{
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Une erreur est produite lors de l\'activation ',
                                variant: 'error'
                                }),
                            );
                            this.status='KO';
                            this.action='Activation';
                            this.errormsg=response.result.IPResult.result.message;
                            console.log(this.errormsg);
                        }

                        const params = {
                            input: '{}',
                            sClassName: 'InwiB2C_OperationHistory',
                            sMethodName: 'AddOperationHistory',
                            options: '{"ErrorCodeOperation":"'+this.errormsg+'","Partenaire":"'+this.partenaire+'","TypeModification":"InwiB2C_Activation","SubscriptionId":"'+this.subid+'","StatutOperation":"'+this.status+'","Canal":"'+this.canal+'","SousProduitIN":"' +orderItemId+'","Description":"' +orderItemName+'","Mdn":"'+this.numeromdn+'","TypeAction":"InwiB2C_ServicesPassetsousproduitIN" }',
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

                    })
                    .catch(error => {
                        window.console.log(error);
                    });

                break;




            case 'DEL':
                    let structdel={
                    "action" : "" ,
                      "type" : event.detail.row.pass_prd ,
                      "mdn" : this.numeromdn,
                       "productOrderItem"  : [
                        {
                            "orderItemAction" : event.detail.action.name ,
                            "orderItemId"  : event.detail.row.id
                        }
                      ]
                    };
                    const params2 = {
                        input: JSON.stringify(structdel),
                        sClassName: `${this._ns}IntegrationProcedureService`,
                        sMethodName: 'Inwi_InwiB2C_SubProductsActivation',
                        options: '{}'
                    };
            
                    console.log('before calling rq0010' + JSON.stringify(params2));
                
                    this._actionUtilClass
                        .executeAction(params2, null, this, null, null)
                        .then(response => {
                            console.log('Success api RQ0010  called');  
                            console.log(this.subid);  
                            console.log(this.canal);  
                            console.log(JSON.stringify(structdel));
                            console.log(response)  ;
                            if (response.result.IPResult.success === false)
                            {
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Une erreur est produite lors de la désactivation ',
                                    variant: 'error'
                                    }),
                                );
                                this.status='KO';
                                this.action='Desactivation';
                                this.errormsg=response.result.IPResult.result.message;
                                console.log(this.errormsg);
                
                            }else if(response.result.IPResult.message==='SUCCESS')
                            {
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'success',
                                    message: 'la désactivation a été executé avec succès',
                                    variant: 'success'
                                    }),
                                );
                                this.status='OK';
                                this.action='Desactivation';
                                this.errormsg='';
                               
                            }else{
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Une erreur est produite lors de la désactivation',
                                    variant: 'error'
                                    }),
                                );
                                this.status='KO';
                                this.action='Desactivation';
                                this.errormsg=response.result.IPResult.result.message;
                                console.log(this.errormsg);
                            }
                            const params3 = {
                                input: '{}',
                                sClassName: 'InwiB2C_OperationHistory',
                                sMethodName: 'AddOperationHistory',
                                options: '{"ErrorCodeOperation":"'+this.errormsg+'","Partenaire":"'+this.partenaire+'","TypeModification":"InwiB2C_Desactivation","SubscriptionId":"'+this.subid+'","StatutOperation":"'+this.status+'","Canal":"'+this.canal+'","SousProduitIN":"' +orderItemId+'","Description":"' +orderItemName+'","Mdn":"'+this.numeromdn+'","TypeAction":"InwiB2C_ServicesPassetsousproduitIN" }',
                            };
    
                
                            this._actionUtilClass
                                .executeAction(params3, null, this, null, null)
                                .then(response => {
                                    console.log('Success row inserted');  
                                    console.log(response)  ;
                    
                                })
                                .catch(error => {
                                    window.console.log(error);
                                });
                        })
                        .catch(error => {
                            window.console.log(error);
                        });
    
                break;





            case 'MOD':
                var newDate = new Date(); 
                var now = newDate.toISOString().replace('Z', '').replace('T', ' ');
                let structmod={
                    "action" : "" ,
                      "type" : event.detail.row.pass_prd ,
                      "mdn" : this.numeromdn,
           
                       "productOrderItem"  : [
                        {
                            "orderItemAction" : event.detail.action.name ,
                            "orderItemId"  : event.detail.row.id,
                            "ActivationDate":now ,
                        }
                      ]
                    };
                    const params4 = {
                        input: JSON.stringify(structmod),
                        sClassName: `${this._ns}IntegrationProcedureService`,
                        sMethodName: 'Inwi_InwiB2C_SubProductsActivation',
                        options: '{}'
                    };
            
                    console.log('before calling rq0010' + JSON.stringify(params4));
                
                    this._actionUtilClass
                        .executeAction(params4, null, this, null, null)
                        .then(response => {
                            console.log('Success api RQ0010  called');  
                            console.log(JSON.stringify(structmod));
                            console.log(response)  ;
                            console.log(this.subid); 
                            console.log(this.canal); 
                            if (response.result.IPResult.success === false)
                            {
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Une erreur est produite lors de la reconduction ',
                                    variant: 'error'
                                    }),
                                );
                                this.status='KO';
                                this.action='Reconduction';
                                this.errormsg=response.result.IPResult.result.message;
                                console.log(this.errormsg);
                
                            }else if(response.result.IPResult.message==='SUCCESS')
                            {
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'success',
                                    message: 'la reconduction a été executé avec succès',
                                    variant: 'success'
                                    }),
                                );
                                this.status='OK';
                                this.action='Reconduction';
                                this.errormsg='';
                               
                            }else{
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Une erreur est produite lors de la reconduction ',
                                    variant: 'error'
                                    }),
                                );
                                this.status='KO';
                                this.action='Reconduction';
                                this.errormsg=response.result.IPResult.result.message;
                                console.log(this.errormsg);
                            }

                            const params5 = {
                                input: '{}',
                                sClassName: 'InwiB2C_OperationHistory',
                                sMethodName: 'AddOperationHistory',
                                options: '{"ErrorCodeOperation":"'+this.errormsg+'","Partenaire":"'+this.partenaire+'","TypeModification":"InwiB2C_Reconduction","SubscriptionId":"'+this.subid+'","StatutOperation":"'+this.status+'","Canal":"'+this.canal+'","SousProduitIN":"' +orderItemId+'","Description":"' +orderItemName+'","Mdn":"'+this.numeromdn+'","TypeAction":"InwiB2C_ServicesPassetsousproduitIN" }',
                            };
            
                        
                            this._actionUtilClass
                                .executeAction(params5, null, this, null, null)
                                .then(response => {
                                    console.log('Success row inserted');  
                                    console.log(response)  ;
                    
                                })
                                .catch(error => {
                                    window.console.log(error);
                                });
    
                        })
                        .catch(error => {
                            window.console.log(error);
                        });
            
            
    
                 
    
                
                break;
        }
    }
 

}