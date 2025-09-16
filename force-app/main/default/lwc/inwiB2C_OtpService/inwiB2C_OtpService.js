import { api, track, LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";

//import GenerateOtp from '@salesforce/apex/InwiB2C_OTP.GenerateOtp';
//import Verifie from '@salesforce/apex/InwiB2C_OTP.Verifie';
export default class InwiB2C_OtpService extends OmniscriptBaseMixin(LightningElement) {

    @api contact;
    @api recordid;
    @api isacquisition ;
    @api offertype;
    @api resiliation;
    @api orderid;
    @api email;
    @api message;
    @api userprofile;
    @api OTPOk = false;
    @api title;
    @api iconName;
    @api numeromdn;
    secret = '12345';
    countclickgenerate = 0;
    @api otp;
    @api accountid;
    @api countduplicate;
    @api countduplicateemail;
    // //Y_MH MGEN3675A-Eclipse_Offre 5G Home B2C_LotA begin
    // @api service ; 
    // //Y_MH MGEN3675A-Eclipse_Offre 5G Home B2C_LotA end 

    counter2 = 0;
    refreshCounter;
    counter = 1;
    @track loaded = false;
    @track disabled = false;
    @track verifDisabled = false;
    @track countclickVerify = 0;
    jsOTPResource;
    JsRessourceLoaded = false;


    otpsaisi;
    displayradiobutton;
    displayemail;

    sendingmode='sms';
    @track displayPhone;
    @track displayEmail;
    @track displayOTP;
    @track displayEmailError;
    @track displayPhoneError;
    @track displayPhoneDuplicateError;
    @track displayEmailDuplicateError;
    @track displayRingCounter=false;
    //03/02/2025 chb AM qualification begin */
    @api isqualification;
     //03/02/2025 chb AM qualification end */
//CHB 24/08/2023
    
   __requestresilid="";
    @api
    set requestresilid(value) {
      this.__requestresilid = value;
    }
    get requestresilid() {
      return this.__requestresilid;
    }


    __typeparcour="";
    @api
    set typeparcour(value) {
      this.__typeparcour = value;
    }
    get typeparcour() {
      return this.__typeparcour;
    }
    get showed(){
        return this.typeparcour==='Televente'; 
      }

      __canal="";
      @api
      set canal(value) {
        this.__canal = value;
      }
      get canal() {
        return this.__canal;
      }

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        // this.displayOTP= !this.isacquisition;
        
        // this.displayPhone = ((this.sendingmode=='sms')?true:false);
        // this.displayOTP = ((this.numeromdn!='' && this.numeromdn!=null && this.countduplicate == 0)?true:false);
        // this.displayPhoneError = (((this.numeromdn=='' || this.numeromdn==null ) && this.sendingmode=='sms')?true:false);
        // this.displayPhoneDuplicateError = ((this.countduplicate == 1 && this.sendingmode=='sms')?true:false);

        this.displayradiobutton = (this.isacquisition && this.offertype != 'ADSL' && this.offertype != 'FTTH');
        this.displayemail =  this.typeparcour === 'Televente' ? true : false ;

        if(this.sendingmode == 'sms'){
            
            if(this.numeromdn!='' && this.numeromdn!=null){
                /* chb 09/05/2024 B-15894 begin */
              //  if(this.countduplicate ==1){
               /* mina J 25/06/2025 B-30194 begin */
                //if(this.countduplicate >2){
                if(this.countduplicate >=5){
                        /* chb 09/05/2024 B-15894 end */
                /* mina J 25/06/2025 B-30194 end */    
                    this.displayOTP = false;
                    this.displayPhoneDuplicateError = true;
                    // this.displayPhone=true;                                
                }
                else{
                    this.displayOTP = true;  
                    this.displayPhoneDuplicateError = false;
                    this.displayPhoneError = false;
                }
                // this.displayOTP = true;
            }else{
                this.displayOTP = false;
                this.displayPhoneError = true;
            }
            this.displayPhone=true;
            this.displayEmail=false;
            this.displayEmailError = false;
            this.displayEmailDuplicateError = false;
        }
        
        console.log("this is displayPhone " + this.displayPhone);
        console.log("this is displayOTP " + this.displayOTP);
        console.log("tyearcours " + this.typeparcour);
        console.log("Show " + this.showed);
        //  console.log("service idar " + this.service);
        
        
        
/*
        console.log("MDN: " + this.contact);
        console.log("codeOtp" + this.otp);
        console.log("recordId: " + this.recordid);
        if (!this.JsRessourceLoaded) {
            const params = {
                input: '{}',
                sClassName: 'InwiB2C_OTPService',
                sMethodName: 'resourceUrlOTP',
                options: '{}',
            };

            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    if (response.result) {
                        this.jsOTPResource = JSON.parse(JSON.stringify(response.result.result));
                        loadScript(this, this.jsOTPResource).then(() => {

                            this.loaded = true;
                        });

                    }
                    else this.loaded = false;
                })
                .catch(error => {
                    window.console.log(error);
                });
        }
*/
    }
    get ringCounter() {
        return (100 / 300) * this.refreshCounter;
    }

    get ringVariant() {
        if (this.refreshCounter < 20) {
            return 'expired'
        }
        if (this.refreshCounter < 100) {
            return 'warning'
        }
        return 'base';
    }

    


    value = 'sms';        
    get options() {
        return [
            { label: 'envoi par SMS', value: 'sms' },
            { label: 'envoi par e-mail', value: 'email' },
        ];
    }
      
    get OneOptions() {
        return [
            { label: 'envoi par SMS', value: 'sms' },
        ];
    }


    // value = 'sms';  
    // get options() {
    //     let availableOptions = [
    //       { label: 'envoi par SMS', value: 'sms' },
    //     ];
      
    //     if (this.typeparcour !== 'Televente') {
    //       availableOptions.push({ label: 'envoi par e-mail', value: 'email' });
    //     }
      
    //     return availableOptions;
    //   }

    handleRadioChange(event) {
        
        console.log("this is countDuplicateEmail " + this.countduplicateemail );
        console.log("this is countDuplicate " + this.countduplicate );
        
        this.sendingmode = event.detail.value;
        if(this.sendingmode=='email'){
            
            if(this.email!='' && this.email!=null){
                if(this.countduplicateemail==1){
                    this.displayOTP = false;
                    this.displayEmailDuplicateError = true;
                    // this.displayEmail=true;                                
                }
                else{
                this.displayOTP = true;                
                    this.displayEmailDuplicateError = false;
                    // this.displayEmail=true;  
                }
                // this.displayOTP = true;                
            }else{
                this.displayOTP = false;
                this.displayEmailError = true;
            }
            this.displayEmail=true;
            this.displayPhone=false;
            this.displayPhoneError = false;
            this.displayPhoneDuplicateError = false;

        }

        if(this.sendingmode=='sms'){
            
            if(this.numeromdn!='' && this.numeromdn!=null){
                 /* chb 09/05/2024 B-15894 begin */
                //if(this.countduplicate==1){
                /* mina J 25/06/2025 B-30194 begin */
                    //if(this.countduplicate>2){
                    if(this.countduplicate>=5){
                        /* chb 09/05/2024 B-15894 end */
                     /* mina J 25/06/2025 B-30194 end */
                    this.displayOTP = false;
                    this.displayPhoneDuplicateError = true;
                    // this.displayPhone=true;                                
                }
                else{
                this.displayOTP = true;
                    this.displayPhoneDuplicateError = false;
                    // this.displayPhone=true;  
                }
                // this.displayOTP = true;
            }else{
                this.displayOTP = false;
                this.displayPhoneError = true;
            }
            this.displayPhone=true;
            this.displayEmail=false;
            this.displayEmailError = false;
            this.displayEmailDuplicateError = false;
        }
        
    }

    
    synchronizeDataOTP(){

        const params = {
            input: '{"AccountId":"' +this.accountid + '"}',
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_InwiB2C_GetInfoForOTP',
            options: '{}'
            };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log("reponse 1", response.result);
                if (response.result.error == 'OK' && response.result.IPResult ){
                    this.numeromdn = response.result.IPResult.NumeroContact;
                    this.email = response.result.IPResult.emailClient;
                    this.countduplicate = response.result.IPResult.countDuplicate;
                    this.countduplicateemail = response.result.IPResult.countDuplicateEmail;

                    if (this.numeromdn != '' && this.numeromdn != null) {
                        this.displayPhoneError = false;
                        this.displayOTP = true;
                        console.log("10" + this.displayPhoneError);
                    }
                    /* mina J 25/06/2025 B-30194 begin */
                    /*if(response.result.IPResult.countDuplicate=='0' && this.sendingmode=='sms' ){*/
                    if(response.result.IPResult.countDuplicate<'5' && this.sendingmode=='sms' ){
                       /* mina J 25/06/2025 B-30194 end */
                        this.displayPhoneDuplicateError=false;
                        this.displayOTP=true;
                    }if (response.result.IPResult.countDuplicateEmail=='0' && this.sendingmode=='email'){
                        this.displayEmailError=false;
                        this.displayOTP=true;
                    }
                    /* mina J 25/06/2025 B-30194 begin */
                    //if(response.result.IPResult.countDuplicate!='0' && this.sendingmode=='sms'){
                   
                    if(response.result.IPResult.countDuplicate>='5' && this.sendingmode=='sms'){
                         /* mina J 25/06/2025 B-30194 end */
                        this.displayPhoneDuplicateError=true;
                        this.displayOTP=false;
                    }if(response.result.IPResult.countDuplicateEmail!='0' && this.sendingmode=='email'){
                        this.displayEmailError=true;
                        this.displayOTP=false;
                    }
                     console.log("20 " + this.displayPhoneError );
                    console.log('response.result.IPResult.countDuplicate',response.result.IPResult.countDuplicate);
                }
            });
    }
   

    generateOTP() {
            
            //this.code = new jsOTP.totp().getOtp(this.secret);
            //LDA 2021-11-21
            console.log("mdn----"+this.numeromdn );
            console.log("email----"+this.email );
            console.log("mode----"+this.sendingmode );
            console.log("orderid----"+this.orderid );
            console.log("before"+this.countclickgenerate);
            console.log("requestresilid"+this.__requestresilid);
            console.log("canal"+this.__canal);
             

            const params = {
            input: '{"mdn":"' +this.numeromdn + '","mode":"'+this.sendingmode+'","email":"'+this.email+'","orderid":"'+this.orderid+'","requestresilid":"'+this.__requestresilid+'","canal":"'+this.__canal+'"}',
                sClassName: 'InwiB2C_OTP',
                sMethodName: 'GenerateOtp',
                options: '{}',
            };
            console.log("Paramètres de la requête : ", params);
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    //console.log(response.result.OTP);
                    if (response.error == false) {
                        console.log(JSON.stringify(response));
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'success',
                                message: 'Le message a bien été envoyé au client',
                                variant: 'success'
                            }),
                        );
                        this.disabled = true;
                        this.displayRingCounter = true;
                        /*if(this.countclickgenerate < 2 && 
                            (this.userprofile != 'System Administrator' 
                            || !this.userprofile.includes('SC Superviseur BO CRC Ext')
                            || !this.userprofile.includes('SC Superviseur BO CRC Int')
                            || !this.userprofile.includes('SC Agents BO réclamation N2')
                            || !this.userprofile.includes('SC Agents CRC N1 Ext')
                            || !this.userprofile.includes('SC Agents CRC Helpdesk N1 Ext')
                            || !this.userprofile.includes('SC Superviseur CRC Ext'))
                            ){
                            this.countclickgenerate ++; */                          
                        
                        var interval = setInterval(function () {
                        if (this.refreshCounter == 1) {
                            this.counter = 1;
                            this.refreshCounter = 0;
                            this.disabled = false;
                            this.displayRingCounter = false;
                            if(this.countclickgenerate==2){
                                this.disabled = true;
                            }  
                        clearInterval(interval);
                        }
                        this.refreshCounter = 300 - (this.counter++);
                        }.bind(this), 1000);
                            
                        /*}else {
                            var interval = setInterval(function () {
                                if (this.refreshCounter == 1) {
                                    this.counter = 1;
                                    this.refreshCounter = 0;
                                    this.disabled = false;
                                    this.displayRingCounter = false;
                                    clearInterval(interval);
                                }
                                    this.refreshCounter = 10 - (this.counter++);
                            }.bind(this), 1000);
                        }                            
                        
                        console.log("after"+this.countclickgenerate); */   
                    }
                    else {
                        console.log("error");
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












            /*GenerateOtp({mdn : this.contact}).then(
                response => { this.code = response;}).catch(error => {console.log('Error:'+error.body.message);});
            //console.log('Code OTP : '+this.code);
            this.sendOTP();
            console.log("code: " + this.code);
            this.disabled = true;
            var interval = setInterval(function () {
                if (this.refreshCounter == 1) {
                    this.counter = 1;
                    this.refreshCounter = 0;
                    this.disabled = false;
                    clearInterval(interval);
                }
                this.refreshCounter = 30 - (this.counter++);
            }.bind(this), 1000);*/
    
    }

    sendOTP() {

        let message = 'Cher client, afin de valider votre demande, veuillez communiquer ce  code ' + this.otp + ' à votre conseiller client inwi.';
        console.log('message ' + message);
        let input = '{"message": "Cher client, afin de valider votre demande, veuillez communiquer ce  code  ' + this.otp + ' à votre conseiller client inwi." , "contact": "' + this.numeromdn + '"}';

        const params1 = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_SendSMSOTPIdentification',
            options: '{}'
        };

        this._actionUtilClass
            .executeAction(params1, null, this, null, null)
            .then(response => {
                console.log('Success message sent successfully');
                console.log("error:" + response.error);
                if (response.error === false) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'success',
                            message: 'Le message a bien été envoyé au client',
                            variant: 'success'
                        }),
                    );

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

    verifyOTP(event) {
    console.log(this.otpsaisi);
    console.log(this.numeromdn);
       // var input = this.template.querySelector('.verify');
       const params = {
        input: '{"mdn":"' +this.numeromdn + '","codeOtp":"' +this.otpsaisi + '","email":"' +this.email + '","orderid":"'+this.orderid+'","canal":"'+this.__canal+'"}',
        sClassName: 'InwiB2C_OTP',
        sMethodName: 'Verifie',
        options: '{}',
    };
       // var otp = input.value;

       //var Votp = this.otpsaisi;

       //console.log(Votp);
       this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log(JSON.stringify(response));
                    this.OTPOk = response.result.otpOk;
                    let detailMessage = {
                        otpOK: this.OTPOk
                    }
                    const optvalidation = new CustomEvent('optvalidation', {
                        detail:detailMessage
                    });
                    // Fire the custom event
                    this.dispatchEvent(optvalidation);

                    if (response.result.otpOk == true) {
                        console.log("verif OTP OK");
                        //this.customotpvaluechange = true;
                        //console.log("2"+this.customotpvaluechange);
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'success',
                                message: 'La vérification OTP est terminée',
                                variant: 'success'
                            }),
                        );
                        this.verifDisabled = true;
                        //var list2= [];
                           let list2= {
                                "isOtpVerified":'otpOK',
                                /*chb 04/04/2024 Ano B-15306 begin */
                                "OTPId":response.result.idOTP
                                 /*chb 04/04/2024 Ano B-15306 end */
                            }
                
                        this.omniUpdateDataJson(list2);
                        this.omniSaveState(list2, true);
                    }
                    else {
                        console.log("verif OTP KO");
                        //this.customotpvaluechange = false;
                        //console.log("3"+this.customotpvaluechange);
                        console.log(JSON.stringify(response));
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: 'OTP incorrect, veuillez réessayer',
                                variant: 'error'
                            }),
                        );
                        this.countclickVerify ++;
                        console.log('le nobre de saisie'+this.countclickVerify);
                         //03/02/2025 chb AM qualification begin */
                        if(this.countclickVerify==2 && !this.isqualification || this.countclickVerify==3 && this.isqualification ){
                           //03/02/2025 chb AM qualification end */
                            this.verifDisabled = true;
                            this.disabled = true;
                        }
                    }
                })
                .catch(error => {
                    window.console.log(error);
                });


       /*

        if (Votp != undefined && Votp !== null) {
            if (this.otp !== Votp) {
                this.counter2++
                this.OTPOk = false;
                const detailParam = {
                    OTPOk: this.OTPOk
                };
                const selectedEvent = new CustomEvent("customotpvaluechange", {
                    detail: detailParam
                });
                this.dispatchEvent(selectedEvent);
                this.showMessage('Notification', 'OTP incorrect, veuillez réessayer', 'error');
            }
            else {
                this.OTPOk = true;
                const detailParam = {
                    OTPOk: this.OTPOk
                };
                const selectedEvent = new CustomEvent("customotpvaluechange", {
                    detail: detailParam
                });
                this.dispatchEvent(selectedEvent);
                this.showMessage('Notification', 'La vérification OTP est terminée.', 'success');
            }


        }*/
        if (this.counter2 >= 2) {
            this.verifDisabled = true;
        }
    }


    get showOtpButtons() {
        if (this.counter2 >= 2) {
            return false
        }
        else {
            return true
        }
    }
    showMessage(t, m, type) {
        const toastEvt = new ShowToastEvent({
            title: t,
            message: m,
            variant: type
        });
        this.dispatchEvent(toastEvt);
    };

    handleotpinput(event){
        this.otpsaisi = event.detail.value;
    }
}