import { LightningElement, api,track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import template from './inwib2cretentionoffertemp.html';

export default class InwiB2C_retentionoffertemp extends  OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
   _ns = getNamespaceDotNotation();  
    @api
    _actionUtilClass;

   
   __numeromdn;
   __idrequesttoret;
   __subscriptionid;
   __alloffers;
   allrequestretention;
   __todaydate;
   __startdatecycle;
   ofrapplique;
   ofrappid;
   dateretapp;
   ofrappname;

   @api
   get alloffers (){
       return this.__alloffers;
   }
   set alloffers(value){
       this.__alloffers = value;
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
   /*@api
   get allrequestretention (){
       return this.__allrequestretention;
   }
   set allrequestretention(value){
       this.__allrequestretention = value;
   }*/
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
   connectedCallback() {
      this._actionUtilClass = new OmniscriptActionCommonUtil();
  }
  renderedCallback() {
  }

   get options() {
      return [
          { label: 'Retenu', value: 'Retenu' },
          { label: 'Non Retenu', value: 'Non Retenu' }
      ];
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
   

   handleSelectedOffer(event) {

      this.selectedOffer = { 
         "selectedOfferParcours" : event.target.dataset.parcours,
         "selectedOfferpass" : event.target.dataset.pass,
         "selectedOfferactive" : event.target.dataset.active,
         "selectedOffertypeparcours" : event.target.dataset.typeparcours,
         "selectedOfferId" : event.target.dataset.ofrid
     }
     this.omniApplyCallResp(this.selectedOffer);
   }



   handleChange(event) {
      this.statusret = event.target.value;
      console.log(this.statusret)  ; 
  }

  onsendsmsretention(){

   console.log(this.numeromdn);        
   let sender = "220";
   let numeromdn = this.numeromdn;  
   let requestId = this.idrequesttoret;
   let subscId = this.subscriptionid;
   let message;
   console.log('statusret '+this.statusret);
   if(this.statusret == 'Retenu'){
        this.message = 'Inwi vous remercie pour votre fidélité';
   }
   else if(this.statusret == 'Non Retenu'){
        this.message = 'Inwi vous remercie pour votre fidélité, prière de passer à votre boutique afin de finaliser votre demande ';
   }
   
   //let input1='{ "content":"'+this.message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+numeromdn+'"}]}';
   let input1='{ "content":"'+this.message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+numeromdn+'"}],"requestId":"'+requestId+'","subscId":"'+subscId+'"}';
  
   console.log("input"+input1);

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

  callvipupdatestatus2(){
   console.log("callvipupdatestatus"); 
   
   let idrequesttoret = this.idrequesttoret;
   let subscriptionid = this.subscriptionid;
   console.log(this.statusret);  
   let input='{"idrequesttoret":"'+idrequesttoret+'","subscriptionid":"'+subscriptionid+'","retentionstatus":"'+this.statusret+'" }';
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
               this.onsendsmsretention();
               this.omniNextStep();
                   
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
      
	}else{
		this.callvipupdatestatus2();
	}
            

   }

   gotopreviousStep() {
      this.omniPrevStep();
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


  //Apply Buton
  handleNext(){
   
   const isInputsCorrect = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
   console.log("isInputsCorrect "+isInputsCorrect);
      if (isInputsCorrect) {
         console.log("selectedOffertes ");
         //console.log("selectedOffertes "+this.selectedOffer.selectedOfferId);
         //start kab nouveau controle historique
         if(this.selectedOffer) {
            console.log("if selectedOffer");
            this.callvipRetentionOffersApplied();
         }else{
            console.log("else selectedOffe");
            this.callvipupdatestatus();
            //this.omniNextStep();
         }
      }      
 }

 //Terminer Buton
 gotoendStep(){
   const isInputsCorrectvalid = [...this.template.querySelectorAll('lightning-combobox')]
   .reduce((validSoFar, inputField) => {
       inputField.reportValidity();
       return validSoFar && inputField.checkValidity();
   }, true);
   console.log("isInputsCorrectvalid "+isInputsCorrectvalid);
   if (isInputsCorrectvalid) {
      //console.log('selectedOffer'+this.selectedOffer);
      console.log('end');
      let selectedStep = {
         "steplabel" : "EndStep"
   }        
      this.omniApplyCallResp(selectedStep);
      this.callvipupdatestatus();
      //this.omniNextStep();
   }
 }

   render() {
      return template;
   }
 }