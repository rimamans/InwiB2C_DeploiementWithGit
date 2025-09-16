import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from './inwiB2C_ManageRetour.html';

export default class inwiB2C_ManageRetour extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @track selectedLabel;
    @track fieldVisible = false;
    value;  
    @track idrec; // pour recuperer Id de la ligne selectionner pour modifier le statut
    @api poscode;// une valeur qui permet de stocker le code de l'agenge de materiel reconditionnee ok pour le passer dans os apres a la VIP Unloack article pour liberer le materiel 
    list = [];// une liste qui permet de stocker IdRecord et le statut de retour une fois ils sont modifier dans OmniScript
    listliberermateriel= [];// liste qui permet de stocker le code article le numero de serie et code agenge de materiel qui est Reconditionnee OK  pour pouvoir les passer apres comme inputs a la VIP UnloackArticle 
    visibilityArray = [];//  un tableau qui permet de stocker le statut de la CHECKBOX en selectionnant ou  deselectionner la checkbox 
    serialnumber;// Var qui permet de stocker le numero de serie de materiel qui est reconditionne Ok 
    codearticle;// Var qui permet de stocker le code article de materiel qui est reconditionne Ok 
    posid;
    @api distcode;
    listlibereSAP= [];
    __record2;// input qu'on recupere depuis le getter et on le passe depuis le setter a l' OS 
   @api profil;// input qu on as recuperer depuis OS qui permet de faire la condition dans htmml si USERPROFIL est different de Inwi POS
    __selectedItem;
    haschoose=false;
    checkboxVal = true;
    __typepos;
    listenvoyerasntl= [];

    @api
    get record2() {
        return this.__record2;          // function get qui permet de recuperer la data de L'OS
    } 
        // function set permet de passer la data a l'OS une fois on as fais des modification dedans                           
    set record2(value) {
        this.__record2 = value;
    }

    @api
    get typepos()  {
        return this.__typepos; 
    }

    set typepos(value) {
        this.__typepos = value;
    }
    handleSelectedAccounts(event){      // function qui permet de gerer le statut de checkbox et le statut de statut de retour une fois on as cliquer sur la case a cocher 
        //lightning-combobox

        this.value=event.target.dataset.idline; 
                                            // une fois cliquer sur checkbox la valeur et idrec stock id de la ligne selectionnee
        this.idrec = event.target.dataset.idline;

 // permet de modifier le status de la check box une fois en click dessus en basculant de checker ou deselectionne la case 
        this.visibilityArray = this.visibilityArray.map(item=>{
            if (item.id===this.value){
                return ({
                    id:item.id,
                    status:!item.status,
                    value: item.value
                })
            }
            return item;
        })

        console.table(this.visibilityArray)
        //declare une var qui stock la data des lignes selectionnee 
        const selectedelement = this.__record2.find(element => element.Id === this.idrec);
        //Parcourir la picklist et faire la condition s'est l'element est checker et que son statut est reconditionne OK ou A Envoyer A SNTL alors griser le statut de retours 
        this.template.querySelectorAll('lightning-combobox').forEach(item=>{
            const element = this.visibilityArray.find(el => el.id === item.dataset.idacc)

            if(element.id===item.dataset.idacc && element.status===event.target.checked && this.value===item.dataset.idacc ){
               
                if(selectedelement.InwiB2C_Statut_de_retour__c!='Reconditionnee_OK'&&selectedelement.InwiB2C_Statut_de_retour__c!='A_envoyer_a_SNTL')
                item.disabled=!element.status
        
        
            }
            
        })

        // console.log('handleSelectedSubscription : ' + event.target.dataset.idline);
        // console.log('this.event.target.checked : '+ event.target.checked);
         

 
      
       

    }
 
    handleChange(event){

        this.selectedLabel = event.target.options.find(options => options.value === event.detail.value).value;
        this.idrecmodif = event.target.dataset.idacc;
        //recuperer l'ancienne valeur depuis la data
        const found = this.__record2.find(element => element.Id === this.idrecmodif);
  
        console.log('exvalue:'+found.InwiB2C_Statut_de_retour__c);



        this.visibilityArray=this.visibilityArray.map(item=>{
            if (item.id===this.idrecmodif){
                return ({
                    id:item.id,
                    status:item.status,
                    value:this.selectedLabel
                })
            }
            return item;
        });

        
        const newData = this.__record2.map(item => (item.Id === this.idrecmodif) ? ({
            ...item,
            InwiB2C_Statut_de_retour__c: this.selectedLabel
        }) : item );

        this.__record2 = newData;
        

        let gestionResult={"IdRecord":this.idrecmodif,"InputStatut":this.selectedLabel};
        this.list.push(gestionResult);
        var list2= [];
            list2= {
                "list": this.list
            }


        this.omniUpdateDataJson(list2);
        this.omniSaveState(list2, true);

        console.log('this. selected label'+ this.selectedLabel);

        if(this.selectedLabel==='Reconditionnee_OK' && found.InwiB2C_Statut_de_retour__c!='Reconditionnee_OK'){



                this.serialnumber= event.target.dataset.serialnumber;
                this.codearticle=  event.target.dataset.codearticle;
                let listliberermateriel= {
                        "serialNumber": this.serialnumber,
                        "code": this.codearticle,
                        "vendor":this.poscode,
                        "handlingAction":'RETOUR',
                        "distributorCode":this.distcode
                        // "Id":this.idrecmodif,
                        // "quantity": 1, 
                        // "customerInfo":'Infoclient'
                    }
                
                this.listliberermateriel.push(listliberermateriel);  
 
            var listlibress= [];
            listlibress= {
                "handset": this.listliberermateriel
            }
            this.omniUpdateDataJson(listlibress);
            this.omniSaveState(listlibress, true);
            console.log('listlibress');
            console.log(listlibress);

       if(this.__typepos==='inwib2c_OS'){
            let listlibereSAP= {
                "serialNumber": this.serialnumber,
                "code": this.codearticle,
                "vendor":this.poscode,
                 "Id":this.idrecmodif,
                 "quantity": 1, 
                 "customerInfo":'Infoclient'
            }
            this.listlibereSAP.push(listlibereSAP);  
            var listlibreSAP= [];
            listlibreSAP= {
                "handsetSAP": this.listlibereSAP
            }
        } else{
            let listlibereSAP= {
                "serialNumber": this.serialnumber,
                "code": this.codearticle,
                "vendor":this.distcode,
                 "Id":this.idrecmodif,
                 "quantity": 1, 
                 "customerInfo":'Infoclient'
            }
            this.listlibereSAP.push(listlibereSAP);  
            var listlibreSAP= [];
            listlibreSAP= {
                "handsetSAP": this.listlibereSAP
            }

         } 
         console.log('typeOs' +this.__typepos);
           
            this.omniUpdateDataJson(listlibreSAP);
            this.omniSaveState(listlibreSAP, true);
            console.log('listlibreSAP');
            console.log(listlibreSAP);


        }


        if(this.selectedLabel==='A_envoyer_a_SNTL'){
           
        let listenvoyerasntl={"IdRecord":this.idrecmodif,"InputStatut":this.selectedLabel};
        this.listenvoyerasntl.push(listenvoyerasntl);
        var listSNTL= [];
            listSNTL= {
                "listSNTL": this.listenvoyerasntl
            }


        this.omniUpdateDataJson(listSNTL);
        this.omniSaveState(listSNTL, true);

        console.log('La liste A Envoyer a SNTL:'+ this.listSNTL);


        }
        

       

    }


    gotonextStep() {
        this.omniNextStep();
    }

    gotopreviousStep() {
        this.omniPrevStep();

    }
    navigateToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }

    renderedCallback(){
        if(this.visibilityArray.length==0){
            this.__record2.map(item=>{
                this.visibilityArray.push({id:item.Id, status:false,value:undefined});
            })

            this.template.querySelectorAll('lightning-combobox').forEach(item=>{
                item.disabled = true;
            });

            this.template.querySelectorAll('input').forEach(item=>{
                if(item.dataset.statut=='Reconditionnee_OK' || item.dataset.statut=='A_envoyer_a_SNTL')
                    item.disabled = true;
            });

            
        }
    }

    connectedCallback() {   
        // une fct qui s'execute des le chargement des donnees(le lancement de parcours)
        console.log('this.records');
        console.log(this.records);
        this.ischecked=false;
        


    }

   
    // les option de la picklist
    get options() {
        return [
            { label: 'Reconditionnée OK', value: 'Reconditionnee_OK' },
       
            { label: 'A envoyer a SNTL', value: 'A_envoyer_a_SNTL' },
       
          
           
        ];
    }
    render() {
       
        return template;
    }
}