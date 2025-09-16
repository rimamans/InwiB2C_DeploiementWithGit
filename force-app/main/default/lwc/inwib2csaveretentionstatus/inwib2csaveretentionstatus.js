import { LightningElement, api, track ,wire} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';



export default class InwiB2C_saveretentionstatus extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    _ns = getNamespaceDotNotation();  
    resiliation = true;
    @api profilecom;
    @api demandecanal;
    @track displaydossiercomplet;
    @track StatusRet;
    @api
    _actionUtilClass;
    @api iscasspecial;
    @api isdemenagement;
    @api checkqueueappelsortant;
    @api vardatesignature;
    @track motifretention;
   __numeromdn;
   __idrequesttoret;
   __subscriptionid;
   __statusretenu;
   retenuFlag =false;
   __OTPOk=false;
   dossiercomplet;
   @track displayNext=false;
   @track displaydossiercomp;
   __message; 
    @api offertype;
  @api ownerid;
    @api
    get message (){
        return this.__message;
    }
    set message(value){
        this.__message = value;
    }
   @api
   
   get OTPOk (){
       return this.__OTPOk;
   }
   set OTPOk(value){
       this.__OTPOk = value;
   }
   
   @api
   
   get statusretenu (){
       return this.statusret;
   }
   set statusretenu(value){
       this.statusret = value;
   }
   
   get displayNext(){
    return ((this.OTPOk && this.statusretenu == 'Retenu')|| !this.statusretenu == 'Retenu');
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
   qualification;
   @api qualificationvar;
   varDate;
   X;
   connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.qualification=this.qualificationvar;
    console.log("Cas spécial callback: "+this.iscasspecial);
    console.log("resiliation"+this.resiliation);
    console.log("subs"+this.subscriptionid);
    console.log("mdn"+this.numeromdn);
    console.log("displayNext"+this.displayNext);
    console.log("otp"+this.OTPOk);
    console.log("motifretention"+this.motifretention);
    if(this.offertype=='Postpaye'){
        this.varDate=30 + this.vardatesignature;
        this.X='dans '+this.varDate+' jours';
    }else if (this.offertype=='idar duo'){
        this.varDate=45 + this.vardatesignature;
        this.X='dans'+ this.varDate+' jours';
    }else if (this.offertype=='ADSL' || this.offertype=='FTTH' ){
        if(this.iscasspecial != true && this.isdemenagement!=true){
            this.varDate=45 + this.vardatesignature;
            this.X='dans'+ this.varDate+' jours';
        }else if (this.qualification=='Conforme'){
            this.X="aujourd'hui";
        }else{
            this.varDate=45+this.vardatesignature;
            this.X='dans'+this.varDate+' jours';
        }
    }
}
getotpfromchild(event){

    this.__OTPOk = event.detail.otpOK;
    console.log("otpok"+this.__OTPOk);
    if(this.__OTPOk==true){
        this.displayNext=true;
    }
    
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

get Qualification() {
    return [
        { label: 'Conforme', value: 'Conforme' },
        { label: 'Non Conforme', value: 'Non Conforme' }
    ];
}

/*handlecustomotpvaluechange(event){

    event.stopPropagation();
    console.log('in handlecustomotpvaluechange');

    console.log(JSON.stringify(event.detail));
    
    this.OTPOk =  event.detail.OTPOk;
    this.displayNext =  event.detail.OTPOk;
    console.log('hanldeOTPValue this.OTPOk'+this.OTPOk);
    
}*/
handleChangemotif(event) {
       
   this.motifretention = event.target.value;
    }
handleChange(event) {
    this.statusret = event.target.value;
    console.log("statut",this.statusret);
    this.displayNext =false;
    console.log("Cas spécial: "+this.iscasspecial);
    if(this.iscasspecial==true)
    {
        this.displayNext =true;
    }
    if(this.statusret == "Retenu")
    {
        console.log('this.statusret',this.statusret);
        //this.displayNext =true;
        this.retenuFlag =true;
        this.displaydossiercomp = false;
        this.displaydossiercomplet = false;
        this.displayqualification = false;
        //this.profilecom =false;
        //this.demandecanal;
        this.qualification='';
        this.dossiercomplet='';
    }
    if(this.statusret != "Retenu"){
        this.dossiercomplet='Oui';
        if(this.demandecanal == true ){
          
            this.displaydossiercomp = true;
        }
        this.retenuFlag =false;
        this.displayNext =true;
        //this.profilecom =true;
    }
    console.log('this.retenuFlag',this.retenuFlag);

}

handleChangedossier(event){
    this.dossiercomplet = event.detail.value;
        if(this.dossiercomplet == 'Non'){
            this.displaydossiercomplet = true;
            this.displayqualification = false;
           // this.statutresil == 'En cours';
            //this.statutretention == 'Non Retenu';
            //this.messagesms == ' Inwi vous remercie pour votre fidélité, prière de passer à votre boutique afin de finaliser votre demande';
            //this.Updatedemanderesiliation();
            
        }else {
            this.motifretention='';
            this.qualification='Conforme';
            this.displaydossiercomplet = false;
            if((this.iscasspecial==true || this.isdemenagement==true) && this.checkqueueappelsortant=='UserQueueSortant'){
            this.displayqualification = true;
        }

           // this.statutresil == 'En attente de résiliation';
           // this.statutretention == 'Non Retenu';
            //this.messagesms == 'Cher client(e), votre ligne sera résiliée dans'+ X +'jours';
            //this.Updatedemanderesiliation();
        }
}

handleChangequalification(event){
    this.qualification = event.detail.value;
}

onsendsmsretention(){
    console.log('statusret '+this.statusret);
    
    if(this.statusret == 'Retenu'){
         this.message = 'Inwi vous remercie pour votre fidélité';
    }
    else if(this.statusret == 'Non Retenu'){
        if(this.dossiercomplet == 'Non'){
            // CHB 26/08/2023 Ano 10738
           // this.message = 'Cher client nous vous informons que votre demande de résiliation n’a pas été traitée en raison de l’absence de signature sur le formulaire. Veuillez contacter votre chargé de clientèle.';
           this.message = 'Cher client nous vous informons que le dossier de votre demande de résiliation est incomplet, veuillez contacter votre chargé de clientèle.';
        }else if(this.demandecanal==false ){
            this.dossiercomplet='Non';
            //ANO 10989 14/09/2023
            //this.message = 'Cher client nous vous informons que le dossier de votre demande de résiliation est incomplet, veuillez contacter votre chargé de clientèle.';
            this.message='Inwi vous remercie pour votre fidélité, prière de passer à votre boutique afin de finaliser votre demande.'
        }
        else {
            this.message = 'Cher client(e), votre ligne sera résiliée '+this.X+'';
        }
    }
    
    //let input1='{ "content":"'+this.message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+numeromdn+'"}]}';
    let input1='{ "content":"'+this.message+'", "sender": {"phoneNumber":"220"}, "receiver": [{"phoneNumber":"'+this.numeromdn+'"}],"requestId":"'+this.idrequesttoret+'","subscId":"'+this.subscriptionid+'"}';
       
    console.log("input"+input1) ;
 
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
                let data = {
                    "dossiercompletvar" : this.dossiercomplet,
                    "qualificationvar" : this.qualification,
                    "statutretentionvar":this.statusret
                   // "steplabel" : "EndStep"
                }   
                this.omniApplyCallResp(data);
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
      
   
   callvipupdatestatus(){
    if(this.motifretention=='nundefined'){
        this.motifretention='';
    }
  
    console.log("callvipupdatestatus"); 
    
    console.log(this.statusret);  
    let input='{"ownerid":"'+this.ownerid+'","idrequesttoret":"'+this.idrequesttoret+'","subscriptionid":"'+this.subscriptionid+'","retentionstatus":"'+this.statusret+'","dossiercomplet":"'+this.dossiercomplet+'","motifretention":"'+this.motifretention+'" }';
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
 
    savestep(){ 
        console.log("savestep") ;
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        if (isInputsCorrect) {
         //perform success logic
         this.callvipupdatestatus();
        }
    /*    if(this.iscasspecial==false)
        {
            console.log('iscasspecial egale false');
            this.omniNextStep(); 
        } */
       
      /*  let qualificationvar = {
            "qualificationvar" : this.qualification
        }   
        console.log("Value dossier complet : "+qualificationvar);
        this.omniApplyCallResp(qualificationvar);*/
      }

      gotopreviousStep() {
        this.omniPrevStep();
        
    }
    //call
    
}