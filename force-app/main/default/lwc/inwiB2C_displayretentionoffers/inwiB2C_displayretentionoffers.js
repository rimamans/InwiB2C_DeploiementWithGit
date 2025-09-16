import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import template from './inwiB2C_displayretentionoffers.html';


export default class InwiB2C_RetetionDisplayOffer extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    //@track value = "";
   // @api options;
    
    _ns = getNamespaceDotNotation();
    
    @api
    _actionUtilClass;
    //starthistorique
     //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
     @track isModalOpen = false;
     @api resiliation;
     @api profilecom;
     @api dossiercompletcond;
     @track displaydossiercomplet;
     @track disabled=false;
     @api ownerid;
     //@track verifDisabled=true;
     selectedOffer = null;
    __anciennete;
    __offre;
    __typeprofil;
    __numeromdn;
    __idrequesttoret;
    __subscriptionid;
    __todaydate;
    __startdatecycle;
    alloffers;
    numberofoffers;
    existnontextoffers = false; 
    allrequestretention;
    alloffersexist;
    __alltextoffers;
    __allnontextoffers;
    __retenuFlag=false;
    showapply = false;
    __OTPOk;
    //message; 
    checkFTTHADSLEligibilite = false;
    checkIdarEligibilite = false;
    checkMobileEligibilite = false;
    @api qualificationvar;
    @api vardatesignature;
    varDate;
    /*get customotpvaluechange (){
        return this.__customotpvaluechange;
    }
    set customotpvaluechange(value){
        this.__customotpvaluechange = value;
    }*/
/*
    @api
    get message (){
        return this.__message;
    }
    set message(value){
        this.__message = value;
    }*/
@api demandecanal;
    @api
    get anciennete (){
        return this.__anciennete;
    }
    set anciennete(value){
        this.__anciennete = value;
    }
    
    
    get OTPOk (){
        return this.__OTPOk;
    }
    set OTPOk(value){
        this.__OTPOk = value;
    }
    @api
    get retenuFlag (){
        return this.__retenuFlag;
    }
    set retenuFlag(value){
        this.__retenuFlag = value;
    }
    @api
    get typeprofil (){
        return this.__typeprofil;
    }
    set typeprofil(value){
        this.__typeprofil = value;
    }
    @api
    get offre (){
        return this.__offre;
    }
    set offre(value){
        this.__offre = value;
    }
    @api
    get subscriptionid (){
        return this.__subscriptionid;
    }
    set subscriptionid(value){
        this.__subscriptionid = value;
    }
    @api
    get idrequesttoret (){
        return this.__idrequesttoret;
    }
    set idrequesttoret(value){
        this.__idrequesttoret = value;
    }
    @api
    get numeromdn (){
        return this.__numeromdn;
    }
    set numeromdn(value){
        this.__numeromdn = value;
    }
    @api
    get startdatecycle (){
        return this.__startdatecycle;
    }
    set startdatecycle(value){
        this.__startdatecycle = value;
    }
    @api
    get todaydate (){
        return this.__todaydate;
    }
    set todaydate(value){
        this.__todaydate = value;
    }
    X;
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        //this.showapply;
        // FTTH et ADSL
        if(this.typeprofil=="FTTH" || this.typeprofil=="ADSL"){
            this.checkFTTHADSLEligibilite = true;
        }
        // Idar duo
        if(this.typeprofil=="idar duo"){
            this.checkIdarEligibilite = true;
        }
        // Mobile
        if(this.typeprofil!="FTTH" && this.typeprofil!="ADSL" && this.typeprofil!="idar duo"){
            this.checkMobileEligibilite = true;
        }
        if(this.typeprofil=='Postpaye'){
            this.varDate=30 + this.vardatesignature;
            this.X='dans '+this.varDate+' jours';
        }else if (this.typeprofil=='idar duo'){
            this.varDate=45 + this.vardatesignature;
        this.X='dans'+ this.varDate+' jours';
        }else if (this.typeprofil=='ADSL' || this.typeprofil=='FTTH' ){
            if(this.isdemenagement!=true){
                this.varDate=45 + this.vardatesignature;
                this.X='dans'+ this.varDate+' jours';
            }else if (this.qualificationvar=='Conforme'){
                this.X="aujourd'hui";
            }
        }
    }
    renderedCallback() {
    }
    get alltextoffers() {
        var resultstextoffers = [];    
  
        if(this.alloffers.length > 1){
           for (let i = 0; i < this.alloffers.length; i++) {
              if (this.alloffers && this.alloffers[i].AllOffers.TypeParcours == "TEXT") {
                 resultstextoffers.push(this.alloffers[i].AllOffers);
                 this.existnontextoffers =true;
              }
           }
        }      
       else{ 
           if (this.alloffers && this.alloffers.AllOffers.TypeParcours == "TEXT") {
              resultstextoffers.push(this.alloffers.AllOffers);
              this.existnontextoffers =true;
           }                  
        }
  
        console.log("resultstextoffers" + resultstextoffers[0]);
        return resultstextoffers;
    }
    
    set alltextoffers(value) {
        this.__alltextoffers = value;
        console.log("seeeet");
     }
     get allnontextoffers() {
        var resultsnontextoffers = [];
        if(this.alloffers.length > 1){
           for (let i = 0; i < this.alloffers.length; i++) {
              if (this.alloffers && this.alloffers[i].AllOffers.TypeParcours != "TEXT") {
                 resultsnontextoffers.push(this.alloffers[i].AllOffers);
              }
           }
        }      
        else{
  
           if (this.alloffers && this.alloffers.AllOffers.TypeParcours != "TEXT") {
              resultsnontextoffers.push(this.alloffers.AllOffers);
           }                 
        }
        
        return resultsnontextoffers;
     }
  
     set allnontextoffers(value) {
        this.__allnontextoffers = value;
     }
     
     //
    //modal historique
    openModal() {
        // to open modal set isModalOpen tarck value as true
        
        let subscriptionid = this.subscriptionid;
        let startdatecycle = this.startdatecycle;
        let todaydate = this.todaydate;
       
        this.Ipinput = '{ "SubscriptionId":"'+subscriptionid+'","startdatecycle":"'+startdatecycle+'","todaydate":"'+todaydate+'"}';
        console.log(("Ipinput "+this.Ipinput));
        const params = {
            input: this.Ipinput,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_InwiB2C_GetRetentionOffersApplied',
            options: '{}',
        };
   
       this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {

                console.log((response));
                if (response.error == false) {              
                    if (response.result) {                       
                        console.log(response);
                        this.allrequestretention = response.result.IPResult.Request;
                        this.isModalOpen = true;              
                    }
                }else {
                    console.log(response);
                    /*this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la création de la demande de résiliation',
                        variant: 'error'
                        }),
                    );*/
                }
            })
    }

    closeModal() {
        this.isModalOpen = false;
    }

    handleDemandeResilView(event) {
        // Navigate to Demande Resil record page
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.value,
                objectApiName: 'InwiB2C_Demande_de_resiliation__c',
                actionName: 'view',
            },
        });
    }
    //endhistorique

    handleCategoryChange(event){
        //consolelogpourl'affichage
        this.category = event.target.value;
        this.selectedOffer = null;
        this.showapply = false;
     }

     handleMotifChange(event){
        // console.log("MotifChange"+this.OTPOk);
        this.motif = event.target.value;
        this.selectedOffer = null;
        this.showapply = false;
        
        let input = '{"Anciennete":"'+this.anciennete+'","offre":"'+this.offre+'","typeProfil":"'+this.typeprofil+'","Category":"'+this.category+'","MotifResil":"'+this.motif+'" }';
        console.log('input'+input);
        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_GetRetentionOffer',
            options: '{}',
        };
       
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                if (response.error == false) {              
                    if (response.result) {           
                        
                            this.alloffers = response.result.IPResult;
                            this.alloffersexist = true;
                            
                            //this.selectedOffer ={};
                            console.log(("this.alloffers"+this.alloffers));               
                        }
                        //console.log(("1234"+response));
                }else {
                    console.log("response1"+response);
                    console.log('Erreur lors de la récupération de la liste des offres de rétention');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la récupération de la liste des offres de rétention',
                            variant: 'error'
                            }),
                        );
                }
    
          })
            .catch(error => {
                 window.console.log(error);
            });
    }
    get options() {
        return [
            { label: 'Retenu', value: 'Retenu' },
            { label: 'Non Retenu', value: 'Non Retenu' }
        ];
    }

    get optionsdossier() {
        return [
            { label: 'Oui', value: 'Oui' },
            { label: 'Non', value: 'Non' }
        ];
    }
   
    
    onsendsmsretention(){
        let ContentMessage ;
        if(this.statusret == 'Retenu'){
            ContentMessage = 'Inwi vous remercie pour votre fidélité';
        }
        else if(this.statusret == 'Non Retenu'){
            if(this.dossiercomplet == 'Non'){
               // ContentMessage = 'Cher client nous vous informons que votre demande de résiliation n’a pas été traitée en raison de l’absence de signature sur le formulaire. Veuillez contacter votre chargé de clientèle.';
               ContentMessage = 'Cher client nous vous informons que le dossier de votre demande de résiliation est incomplet, veuillez contacter votre chargé de clientèle.';
            }else if(this.demandecanal==false ){
                this.dossiercomplet='Non';
                //ANO 10989 14/09/2023
                //this.message = 'Cher client nous vous informons que le dossier de votre demande de résiliation est incomplet, veuillez contacter votre chargé de clientèle.';
                ContentMessage='Inwi vous remercie pour votre fidélité, prière de passer à votre boutique afin de finaliser votre demande.'
            }else{
                ContentMessage = 'Cher client(e), votre ligne sera résiliée '+this.X+'';
            }/*else{
                ContentMessage = 'Inwi vous remercie pour votre fidélité, prière de passer à votre boutique afin de finaliser votre demande ';
            }*/
        }
        
        //let input1='{ "content":"'+this.message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+receiver+'"}]}';
        let input1='{ "content":"'+ContentMessage+'", "sender": {"phoneNumber":"220"}, "receiver": [{"phoneNumber":"'+this.numeromdn+'"}],"requestId":"'+this.idrequesttoret+'","subscId":"'+this.subscriptionid+'"}';
       
        console.log(input1) ;
     
        const params1 = {
            input: input1,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwib2c_InwiB2C_SendSMS_Resil',
            options: '{}'
        };
     
         this._actionUtilClass
            .executeAction(params1, null, this, null, null)
            .then(response => {
                 console.log('Success message sent successfully');  
                 console.log(response) ;
                 if (response.error===false)
                 {
                    this.dispatchEvent(
                        new ShowToastEvent({
                         title: 'success',
                        message: 'Le message a bien été envoyé au client',
                        variant: 'success'
                        }),
                    );
                    this.omniNextStep();    
                  }else{
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

    /*callvipupdatestatus(){
        let idrequesttoret = this.idrequesttoret;
        let subscriptionid = this.subscriptionid;
        //let retentionstatus = this.value;
       // console.log(this.statusret);  
        let input='{"idrequesttoret":"'+idrequesttoret+'","subscriptionid":"'+subscriptionid+'","retentionstatus":"'+this.statusret+'"  }';
        console.log(input) ;
     
        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwib2c_InwiB2C-VIP-UpdateRetentionStatus',
            options: '{}'
        };
     
         this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                 console.log('Request cancelled successfully');  
                 console.log(response) ;
                 if (response.error===false)
                 {
                    this.onsendsmsretention(); 
                        
                  }else{
                     this.dispatchEvent(
                         new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Une erreur est produite ',
                            variant: 'error'
                             }),
                    );
                  }
                            
                 })
                .catch(error => {
                     window.console.log(error);
                    });
     
                  
     
        }*/
    handleSelectedOffer(event) {
        // console.log("selectedOffer"+this.OTPOk);
       this.selectedOffer = { 
            "selectedOfferParcours" : event.target.dataset.parcours,
            "selectedOfferpass" : event.target.dataset.pass,
            "selectedOfferactive" : event.target.dataset.active,
            "selectedOffertypeparcours" : event.target.dataset.typeparcours,
            "selectedOfferId" : event.target.dataset.ofrid
        }
        // console.log("this.selectedOffer"+ this.selectedOffer);
        // if(this.statusret == "Retenu" && this.selectedOffer )
        // {
        //     this.showapply = true;
        // }  
        //     //if(this.typeprofil=="idar duo")
        //     //this.showapply=false;
        // else
        //    {
        //     this.showapply = false;
        // } 
        this.omniApplyCallResp(this.selectedOffer);
    }

    handleChange(event) {
        // console.log("handleChange"+this.OTPOk);
        this.statusret = event.target.value;
        this.showapply = false;
        
        this.retenuFlag= false;
        if(this.statusret == "Retenu")
        { 
            this.retenuFlag= true;
            //this.profilecom =false;
        }
        else{
            this.retenuFlag =false;
            this.dossiercompletcond=true;
            //this.profilecom =true;
        }
        //if( this.selectedOffer && this.OTPOk)
        
            //this.showapply = true;
        
                          
        // }
        if(this.statusret == "Retenu" && this.selectedOffer && this.OTPOk)
        {
            
            this.showapply = true;
        }  
            //if(this.typeprofil=="idar duo")
            //this.showapply=false;
        else
           {
            
            this.showapply = false;
        } 
     
    }  
 
    handleChangedossier(event){
        this.dossiercomplet = event.detail.value;
            if(this.dossiercomplet == 'Non'){
                this.displaydossiercomplet = true;
                this.statutresil == 'En cours';
                this.statutretention == 'Non Retenu';
                //this.messagesms == ' Inwi vous remercie pour votre fidélité, prière de passer à votre boutique afin de finaliser votre demande';
                //this.Updatedemanderesiliation();
                
            }else{
                this.displaydossiercomplet = false;
                this.statutresil == 'En attente de résiliation';
                this.statutretention == 'Non Retenu';
                //this.messagesms == 'Cher client(e), votre ligne sera résiliée dans'+ X +'jours';
                //this.Updatedemanderesiliation();
            }
    }
 
    callvipupdatestatus2(){
            console.log("callvipupdatestatus2"); 
         
            let idrequesttoret = this.idrequesttoret;
            let subscriptionid = this.subscriptionid;
            console.log(this.statusret);  
            let input='{"ownerid":"'+this.ownerid+'","idrequesttoret":"'+idrequesttoret+'","subscriptionid":"'+subscriptionid+'","retentionstatus":"'+this.statusret+'" }';
            console.log(input) ;
         
            const params = {
                input: input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'Inwib2c_InwiB2C-VIP-UpdateRetentionStatus',
                options: '{}'
            };
            console.log("callvipupdatestatus params"); 
             this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                     console.log('Request cancelled successfully');  
                     console.log(response) ;
                     if (response.error===false)
                     {
                        console.log('in reponse.error ===false');
                        this.onsendsmsretention();
                      
                            
                      }else{
                        console.log('in reponse.error ===true');
                         this.dispatchEvent(
                             new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Une erreur est produite ',
                                variant: 'error'
                                 }),
                        );
                      }
                                
                     })
                    .catch(error => {
                         window.console.log(error);
                        });
                    
         
            }
            
           callvipupdatestatus(){
            
             if(this.selectedOffer && this.selectedOffer.selectedOffertypeparcours == 'PASS'){
                 let selectedSubscriptionMDN = this.numeromdn; 
              
               let selectedOfferpass = this.selectedOffer.selectedOfferpass;
               let inputpass='{"selectedSubscriptionMDN":"'+selectedSubscriptionMDN+'","selectedOfferpass":"'+selectedOfferpass+'"}';
               console.log(inputpass);
               const paramspass = {
                  input: inputpass,
                  sClassName: `${this._ns}IntegrationProcedureService`,
                  sMethodName: 'inwib2c_InwiB2C_ActivePassRet',
                  options: '{}'
              };
              this._actionUtilClass
                .executeAction(paramspass, null, this, null, null)
                .then(response => {
                     console.log('VIP Pass');  
                     console.log(response) ;
                     if (response.result.IPResult.message==='SUCCESS')
                     {
                        this.dispatchEvent(
                           new ShowToastEvent({
                           title: 'success',
                           message: 'l\'activation a été executé avec succès',
                           variant: 'success'
                           }),
                       );
                        
                            this.callvipupdatestatus2();
                           
                            
                      }else{
                        this.dispatchEvent(
                            new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Une erreur est produite lors de l\'activation ',
                            variant: 'error'
                            }),
                        );
                    }
                                
                  })
                    .catch(error => {
                         window.console.log(error);
                        });
               
             }
             else{
               //B-5218 SAS 04/08/2022 Begin
               console.log('Sara --> 0 -- this.showapply'+this.showapply);
                if(this.showapply){                                    
                     this.omniApplyCallResp({statusret:this.statusret} );
                     this.omniNextStep();
        
                }else{
                    this.callvipupdatestatus2();
                 }
                this.omniApplyCallResp({statusret:this.statusret} );
               
                
                //B-5218 SAS 04/08/2022 End  
             }
             
                    
         
            }
    callvipgetcycleret(){
            //ofrapplique;
            console.log("callvipgetcycleret ");
            for (let k = 0; k < this.allrequestretention.length; k++) {
               if (this.allrequestretention && this.allrequestretention[k].OFRID && this.allrequestretention[k].OFRID == this.selectedOffer.selectedOfferId) {
                  console.log("if OfrID "+this.allrequestretention[k].OFRID);
                  this.ofrapplique = true;
                  this.ofrappid = this.allrequestretention[k].OFRID;
                  this.dateretapp = this.allrequestretention[k].dateapplied;
                  this.ofrappname = this.allrequestretention[k].offerapplied;
                  console.log(" if applique "+this.ofrapplique);
                  break;
                  //return;
               }else{
                  this.ofrapplique = false;
                  console.log("selectedOffertes else ");       
               }
            }
         
            if(this.ofrapplique){
               console.log(" if applique 2 "+this.ofrapplique);
               //start if       
               let ofrid = this.ofrappid;
               let dateret = this.dateretapp;
               let inputvip='{"OFRID":"'+ofrid+'","dateret":"'+dateret+'"}';
               console.log(inputvip) ;          
               const paramsvip = {
                     input: inputvip,
                     sClassName: `${this._ns}IntegrationProcedureService`,
                     sMethodName: 'Inwib2c_InwiB2C_GetCycleOffreRetention',
                     options: '{}'
                  };
               
                  this._actionUtilClass
                  .executeAction(paramsvip, null, this, null, null)
                  .then(response => {
                     if (response.error===false)
                     {
                        if (response.result) {                       
                           console.log("response cycle"+response); 
                           console.log("response2 "+response.result.IPResult.checkresult);
                           if(response.result.IPResult.checkresult == true) {
                             console.log("if check true");
                             //this.callvipupdatestatus();
                             console.log("dispatchEvent "+this.ofrappname);
                             console.log("dateret "+dateret);
                              this.dispatchEvent(
                                 new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Cette ligne a déjà bénéficiée d’une offre de rétention "'+this.ofrappname+'" le "'+dateret+'"',
                                    variant: 'error'
                                       }),
                              );
                              //this.checkhistoryret = false;
                              let checkretstep = {
                                 "checkhistoryret" : "false"
                             }  
                              //console.log("checkhistoryret "+this.checkhistoryret);
                              this.omniApplyCallResp(checkretstep);
                              
                              //return;
                           }else{
                              console.log("if check false");
                              //this.checkhistoryret = true;                            
                              //console.log("checkhistoryret "+this.checkhistoryret);
                              let checkretstep = {
                                 "checkhistoryret" : "true"
                             } 
                              this.omniApplyCallResp(checkretstep);
                              this.callvipupdatestatus();
                              //this.omniNextStep();
                              
                           }     
                        }    
                        }else{
                           this.dispatchEvent(
                                 new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Une erreur est produite ',
                                    variant: 'error'
                                       }),
                              );
                        }                                
                     })
                     .catch(error => {
                           window.console.log(error);
                        });
                        
                  //end  if      
            }else{
               let checkretstep = {
                  "checkhistoryret" : "true"
              } 
               this.omniApplyCallResp(checkretstep);
               this.callvipupdatestatus();
               //this.omniNextStep();
            }
            /*this.callvipupdatestatus();
            this.omniNextStep();*/ 
           }
         
    callvipRetentionOffersApplied() {
            console.log("callvipRetentionOffersApplied ");
            let subscriptionid = this.subscriptionid;
            let startdatecycle = this.startdatecycle;
            let todaydate = this.todaydate;
           
            this.Ipinput = '{ "SubscriptionId":"'+subscriptionid+'","startdatecycle":"'+startdatecycle+'","todaydate":"'+todaydate+'"}';
            console.log(("Ipinput "+this.Ipinput));
            const params = {
                input: this.Ipinput,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'inwib2c_InwiB2C_GetRetentionOffersApplied',
                options: '{}',
            };
         
           this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
         
                    console.log((response));
                    if (response.error == false) {              
                        if (response.result) {                       
                            console.log(response);
                            this.allrequestretention = response.result.IPResult.Request;
                            if (this.allrequestretention){
                              console.log("selectedallrequestretentionOffer "+this.allrequestretention);                 
                              this.callvipgetcycleret();  
                            }
                            else{
                              let checkretstep = {
                                 "checkhistoryret" : "true"
                             } 
                              this.omniApplyCallResp(checkretstep);
                            
                              this.callvipupdatestatus();
                              //this.omniNextStep();
                            }
                                          
                            
                        }
                    }else {
                        console.log(response);
                        this.dispatchEvent(
                            new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Une erreur est produite ',
                            variant: 'error'
                            }),
                        );
                    }
                })
                
               
           }     

    gotopreviousStep() {
        this.omniPrevStep();
    }
    
    gotonextStep(event){
        console.log("terminer");
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
            let detailMessage = {
                combobox: this.isInputsCorrect
            }
            const comboboxcondition = new CustomEvent('comboboxcondition', {
                detail:detailMessage
            });
            // Fire the custom event
            this.dispatchEvent(comboboxcondition);
        if (isInputsCorrect) {
         //perform success logic
            //let selectedStep = {
           // "steplabel" : "EndStep"
           // }        
           // this.omniApplyCallResp(selectedStep);
            this.callvipupdatestatus();
            this.omniNextStep();
        }      
  }


 //Apply Buton
    handleNext(){
         console.log("apliquer offre");
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-combobox')]
                .reduce((validSoFar, inputField) => {
                    inputField.reportValidity();
                    return validSoFar && inputField.checkValidity();
                }, true);
        console.log("isInputsCorrect "+isInputsCorrect);
        if (isInputsCorrect) {
            console.log("selectedOffertes ");
            
            if(this.selectedOffer) {
                console.log("if selectedOffer");
                this.callvipRetentionOffersApplied();
            }
            else{
                console.log("else selectedOffe");
                this.callvipupdatestatus();
                //this.omniNextStep();
            }

        }      
        console.log('my status retention',this.statusret);
        this.omniApplyCallResp({statusret:this.statusret} );
    }


    render() {
        return template;
    }
     getotpfromchild(event){
    // event.stopPropagation();
    let detail = event.detail;
    console.log('detail event : ' + JSON.stringify(detail));
    this.__OTPOk =  detail.otpOK;
    console.log("otpok"+this.__OTPOk);
    if(this.statusret == "Retenu" && this.selectedOffer){
    this.showapply =  detail.otpOK;
    //this.showapply = true;
    }else 
    this.showapply = false;
    //this.verifDisabled = true;
    //this.verifDisabled = detail.otpOK;
    console.log("showapply"+this.showapply)
    
    }

    
 
}