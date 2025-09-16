import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import template from './inwiB2C_DemandeResiliationLWC.html';
export default class inwiB2C_DemandeResiliationLWC extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    __allrequests;
    _ns = getNamespaceDotNotation();
    @api
    _actionUtilClass;
    @api userprofil;
    @api subscriptionid;
    @api accountid;
    @api numeroligne;
    @api typeoffre;
    @api partenaire;
    RetentionStatus;
    NameOfNewRequest;
    IdOfNewRequest;
    disabledF=false;
    isftthadsl=false;
    @api labelstepcancel;
    @api labelstepresil;
    @api labelsteprestitution;
    @api labelstepretention;
    @api checkrequestencours;
    @api showbuttonsuivant;
    @api showformulaire;
    displayCreateButton=false;
    showButtonTerminer=false;
    @api
    get allrequests (){
        return this.__allrequests;
    }
    set allrequests(value){
        this.__allrequests = value;
    }
    type;
    motif;
    eligibiliteCasSpecial=false;
    flagRequestEnCours=false;
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('userprofil: ',this.userprofil);
        if(this.userprofil==='Inwi POS'){
            this.RetentionStatus='En cours'
        }else{
            this.RetentionStatus='Contact CRC'
           // this.displayCreateButton!=this.labelstepretention;
           if(this.showbuttonsuivant==true){//affichage de bouton terminer CRC pr Statut de retention En cours
           // this.labelstepretention=!this.showbuttonsuivant; 
            this.showbuttonsuivant=false;
            this.checkrequestencours=false;
            this.flagRequestEnCours=true;
           }
        }
        if(this.flagRequestEnCours==false && this.checkrequestencours==false && (this.typeoffre=='ADSL' || this.typeoffre=='FTTH')){
            this.isftthadsl=true;
            this.labelstepcancel=false;
        } if(this.typeoffre!='ADSL' && this.typeoffre!='FTTH'){
            this.displayCreateButton=!this.checkrequestencours;
        }
       // this.displayCreateButton=this.checkrequestencours;
        if(this.flagRequestEnCours==true || this.checkrequestencours==true){
            console.log('in isftthadsl egale false');
           this.displayCreateButton=false;
        }if((this.showbuttonsuivant==false || this.userprofil==false ) && this.displayCreateButton==false && !this.isftthadsl ){
           if(this.showformulaire==false){
            this.showButtonTerminer = true;
           } 
        }
        if(this.labelstepretention ==true){
            this.showButtonTerminer=false;
        }
        if(this.labelstepresil==true){
            this.showbuttonsuivant=false;
            this.showButtonTerminer=false;
        }
           
        console.log('showformulaire',this.showformulaire);
        console.log('displayCreateButton',this.displayCreateButton);
         console.log('labelstepretention',this.labelstepretention);
         console.log('showbuttonsuivant',this.showbuttonsuivant);
         console.log('checkrequestencours',this.checkrequestencours);
         console.log('flagRequestEnCours',this.flagRequestEnCours);
         console.log('labelstepcancel',this.labelstepcancel);
         console.log('labelsteprestitution',this.labelsteprestitution);
         console.log('labelstepresil',this.labelstepresil);
    }
    handleTypeChange(event){
        this.type = event.target.value;
        console.log("Type :"+this.type);
        this.displayCreateButton = false;
        this.eligibiliteCasSpecial = false;
        this.motif='';
        if( this.type!=null && this.type!= "undefined" && this.type!=""){
            
            if(this.type=="Cas spécial"){
                this.eligibiliteCasSpecial = true;
               // this.displayButtonCreateDemande = false;
            }else{
               // this.eligibiliteCasSpecial = false;
                this.displayCreateButton=true;
                
            }
        }
    }

    handleMotifChange(event){
        this.displayCreateButton=false;
        this.motif = event.target.value;
        if(this.motif!=null && this.motif!= "undefined" && this.Motif!=""){
            this.displayCreateButton=true;
            //this.labelstepcancel=!this.displayCreateButton;
        }
        
     }
    createnewrequest() {
        console.log('in createnewrequest');
        let input;
        if(this.isftthadsl==true){
             input = '{"motif":"'+this.motif+'","type":"'+this.type+'","SubscriptionId":"' + this.subscriptionid + '","AccountId":"' + this.accountid + '","NumeroLigne":"' + this.numeroligne + '","RetentionStatus":"'+ this.RetentionStatus+'","TypeOffre":"'+this.typeoffre+'","profile":"'+this.userprofil+'","partenaire":"'+this.partenaire+'"}';
        }else{
             input = '{ "SubscriptionId":"' + this.subscriptionid + '","AccountId":"' + this.accountid + '","NumeroLigne":"' + this.numeroligne + '","RetentionStatus":"'+ this.RetentionStatus+'","TypeOffre":"'+this.typeoffre+'","profile":"'+this.userprofil+'","partenaire":"'+this.partenaire+'"}';
        }
        console.log(("input " + input));
        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_InwiB2C_VIPCreateResilRequestV2',
            options: '{}',
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {

                console.log((response));
                console.log('response.result'+response.result);
                this.NameOfNewRequest = response.result.IPResult.NameNewRequest;

               // if (response.result.IPResult.NameNewRequest != '' && response.result.IPResult.NameNewRequest != 'undefined') {
                    if (!response.error) {
                        console.log("NameRequest " + response.result.IPResult.NameNewRequest);
                        this.IdOfNewRequest= response.result.IPResult.IdNewRequestId;
                       // this.onsendsms();
                        this.disabledF=true;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'success',
                                message: ' La demande de résiliation ' + this.NameOfNewRequest + ' est initiée',
                                variant: 'success'
                            }),
                        );
                       
                        this.omniNavigateTo("DataRaptorExtractAllResiliationRequest");
                  //  }
                } else {
                    console.log(response);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la création de la demande de résiliation',
                            variant: 'error'
                        }),
                    );
                }


            })
    }
    onsendsms() {
        let body = '{ "content":"Inwi vous remercie pour votre visite, prière de contacter le 220.", "sender": {"phoneNumber":"220"}, "receiver": [{"phoneNumber":"' + this.numeroligne + '"}],"requestId":"' + this.IdOfNewRequest + '","subscId":"' + this.subscriptionid + '"}';
        console.log(JSON.parse(JSON.stringify(body)));

        const params1 = {
           // input: JSON.parse(JSON.stringify(body)),
           input:body,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwib2c_InwiB2C_SendSMS_Resil',
            options: '{}'
        };


        this._actionUtilClass
            .executeAction(params1, null, this, null, null)
            .then(response => {
                console.log('Success message sent successfully');
                console.log(response);
                if (response.error === false) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'success',
                            message: 'Le message a bien été envoyé au client',
                            variant: 'success'
                        }),
                    );
                    
                    //this.omniNavigateTo("DataRaptorExtractAllResiliationRequest");
                

                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Une erreur est produite lors de la transmission du message',
                            variant: 'error'
                        }),
                    );

                }
               
            })
            .catch(error => {
                window.console.log(error);
            });
           

    }
    gotopreviousStep() {
       // if (this.isfromsubscription == true) {
           /* let selectedStep = {
                "steplabel": "PrevStep"
            }
            this.omniApplyCallResp(selectedStep);*/
            omnipreviousStep();
    //    }
    }
        gotonextStep() {
            let selectedStep = {
                "steplabel": "EndStep"
            }
            this.omniApplyCallResp(selectedStep);
            this.omniNextStep();
        }
        gotocancelStep() {

            let selectedStep = {
                "steplabel": "CancelStep"
            }
            this.omniApplyCallResp(selectedStep);
            this.omniNextStep();
        }
        gotoresilStep() {

            let selectedStep = {
                "steplabel": "ResilStep"
            }
    
            this.omniApplyCallResp(selectedStep);
            this.omniNextStep();
        }
        gotNextStep() {

            let selectedStep = {
                "steplabel": "NextStep"
            }
    
            this.omniApplyCallResp(selectedStep);
            this.omniNextStep();
        }
        gotorestitutionStep(event) {
            console.log("handle gotorestitutionStep");
            event.stopPropagation();
    
            try {
                this[NavigationMixin.GenerateUrl]({
                    type: 'comm__namedPage',// standard__component
                    attributes: {
                        //componentName: 'vlocity_cmt__vlocityLWCOmniWrapper',
                        pageName:'lwcos'
                    },
                    state: {
                        c__target: 'c:inwib2cRestitutionEnglish',//c:inwib2cRestitutionEnglish
                        c__layout: 'lightning', // or 'newport'
                        c__tabIcon: 'custom:custom18',
                        c__tabLabel: 'Restitution Matériel',
                        c__ContextId: this.subscriptionid ,
                        c__Motifinput:'InwiB2C_Demandederésiliation'         
                    }
                }) .then(generatedUrl => {
                    //this.omniUpdateDataJson({ "MotifRestitution" : "Demande client"});
                    //console.log("motifff"+this.omniUpdateDataJson());
                    console.log(generatedUrl)
                    window.open(generatedUrl);
                });
            } catch (error) {
                console.log(error)
            }
    
        }
    
        gotoretentionStep() {
    
            let selectedStep = {
                "steplabel": "RetentionStep"
            }
            this.omniApplyCallResp(selectedStep);
            this.omniNextStep();
        }
    
    
}