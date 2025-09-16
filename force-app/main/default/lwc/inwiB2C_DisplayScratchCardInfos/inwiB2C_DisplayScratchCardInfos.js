import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import template from './inwiB2C_DisplayScratchCardInfos.html';

export default class InwiB2C_DisplayScratchCardInfos extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {


    @api scratchcardstatus; 
    @api scratchcardamount; 
    @api scratchcarddatedebut;
    @api scratchcarddatefin; 
    @api scratchcardmdn; 
    @api scratchcardpincodestatus;
    @api scratchcardactivationdate; 
    @api errorcode;
    @api pincode;
    @api serialnumber;
    @api operationreason;

    @api isBlocked = false;
    @api isRechargeHidden = false;
    @api isDebloqued = false;
    @api blockcounter;
    @api UnblockedSuccess = false;
    @api UnblockedSError = false;
    @api mdn;
    @api subsid;
    @api canal;
    @api partenaire;
    year;
    month;
    day;

    _actionUtilClass;
    _ns = getNamespaceDotNotation();

    
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('test', this.operationreason);
    }
    
    render() {

        if (this.scratchcarddatefin != '' && !this.scratchcarddatefin.includes("-")){
            
        this.year        = this.scratchcarddatefin.substring(0,4);
        this.month       = this.scratchcarddatefin.substring(4,6);
        this.day         = this.scratchcarddatefin.substring(6,8);
        this.scratchcarddatefin = this.day.concat("-", this.month,"-", this.year);
        //this.scratchcarddatefin = new Date(this.year, this.month, this.day);
        //console.log('here   ' + this.scratchcarddatefin.substring(0,4))
        }

        
        if (this.scratchcarddatedebut != '' && !this.scratchcarddatedebut.includes("-")){
            
            this.year        = this.scratchcarddatedebut.substring(0,4);
            this.month       = this.scratchcarddatedebut.substring(4,6);
            this.day         = this.scratchcarddatedebut.substring(6,8);
            this.scratchcarddatedebut = this.day.concat("-", this.month,"-", this.year);
            //console.log('here   ' + this.scratchcarddatefin.substring(0,4))
            }

        if (this.scratchcardactivationdate != '' && !this.scratchcardactivationdate.includes("-")){
        
            this.year        = this.scratchcardactivationdate.substring(0,4);
            this.month       = this.scratchcardactivationdate.substring(4,6);
            this.day         = this.scratchcardactivationdate.substring(6,8);
            this.scratchcardactivationdate = this.day.concat("-", this.month,"-", this.year);
            //console.log('here   ' + this.scratchcarddatefin.substring(0,4))
            }

       
        if (this.scratchcardstatus == '0')
        {/*
            const params = {
                input: '{}',
                sClassName: 'InwiB2C_OperationHistory',
                sMethodName: 'AddOperationHistory',
                options: '{"SubscriptionId":"'+this.subsid+'","Canal":"'+this.canal+'", "Partenaire": "'+this.partenaire+'",  "TypeModification": "inwiB2C_VerificationScratchCard", "TypeAction": "inwiB2C_ScratchCard", "StatutOperation": "OK", "SubActionOperation": "Vérification Scratch Card", "ActionOperation": "Problème de la Scratch Card","Mdn":"'+this.mdn+'"  }',
                 };
        
                this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log('Success row inserted');  
                    console.log(response)  ;
    
                })
                .catch(error => {
                    window.console.log(error);
                }); */
            this.scratchcardstatus = 'UNUSED';
        }
        if (this.scratchcardstatus == 1 || this.errorcode == '3005')
        {  /*
            const params = {
            input: '{}',
            sClassName: 'InwiB2C_OperationHistory',
            sMethodName: 'AddOperationHistory',
            options: '{"SubscriptionId":"'+this.subsid+'","Canal":"'+this.canal+'", "Partenaire": "'+this.partenaire+'",  "TypeModification": "inwiB2C_VerificationScratchCard", "TypeAction": "inwiB2C_ScratchCard", "StatutOperation": "KO", "SubActionOperation": "Vérification Scratch Card", "ActionOperation": "Problème de la Scratch Card","ErrorCode":"Carte déjà utilisée","Mdn":"'+this.mdn+'"  }',
             };
    
            this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log('Success row inserted');  
                console.log(response)  ;

            })
            .catch(error => {
                window.console.log(error);
            }); */
            this.scratchcardstatus = 'ACTIVE';
        }
        if (this.scratchcardstatus == 3 || (this.scratchcardstatus == '' && this.errorcode != '3005'))
        {/*
            const params = {
                input: '{}',
                sClassName: 'InwiB2C_OperationHistory',
                sMethodName: 'AddOperationHistory',
                options: '{"SubscriptionId":"'+this.subsid+'","Canal":"'+this.canal+'", "Partenaire": "'+this.partenaire+'",  "TypeModification": "inwiB2C_VerificationScratchCard", "TypeAction": "inwiB2C_ScratchCard", "StatutOperation": "KO", "SubActionOperation": "Vérification Scratch Card", "ActionOperation": "Problème de la Scratch Card","ErrorCode":"Carte introuvable","Mdn":"'+this.mdn+'"  }',
                 };
        
                this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log('Success row inserted');  
                    console.log(response)  ;
    
                })
                .catch(error => {
                    window.console.log(error);
                }); */
            this.scratchcardstatus = 'NOT EXIST';
        }
        if (this.scratchcardstatus == 4)
            this.scratchcardstatus = 'BLOQUED';
        if (this.scratchcardstatus == 5)
            this.scratchcardstatus = 'INVALID';
        if (this.scratchcardstatus == 6 )
                this.scratchcardstatus = 'LOCK PERMANENTLY';  
                            
             
       

        if (this.blockcounter == 3 && this.scratchcardstatus == 'UNUSED' ){
            this.isBlocked = true;
            //this.isHidden(false);
        }
                
        return template;
    }

    get isHidden(){

        if(this.scratchcardstatus != "UNUSED")
            return false;
        else if (this.blockcounter != 3)
            return true;
            else if (this.isDebloqued == true)
                return true;

        return false;        
   }
   
   handleNext (event){
    this.omniNextStep();
   }

   UnblockRecharge(event) {
    
    console.log('in UnblockRecharge');

    let input = '{"id":"1234567890",  "mdn":"' + this.mdn+ '","rechargeStatus":"UNBLOCK" , "accountType":"2000", "newExpireTime":"20230415235959" }';

    console.log('input : ' + input);

    const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: 'Inwi_InwiB2C_UnlockRecharge',
        options: '{}',
    };

    console.log('before call apex1' + JSON.stringify(params));

    this._actionUtilClass
    .executeAction(params, null, this, null, null)
    .then(response => {
        if (response.error == false) {

            if (response.result.IPResult.actionStatus == 'DONE') {
                console.log(response);    
                   this.UnblockedSuccess = true;
                   this.UnblockedError = false;
                   this.isDebloqued = true;

                   const params = {
                    input: '{}',
                    sClassName: 'InwiB2C_OperationHistory',
                    sMethodName: 'AddOperationHistory',
                    options: '{"SubscriptionId":"'+this.subsid+'","Canal":"'+this.canal+'", "serialNumber":"'+this.serialnumber+'", "pinCode":"'+this.pincode+'",this. "Partenaire": "'+this.partenaire+'",  "TypeModification": "inwiB2C_DeblocageMethodeRecharge", "TypeAction": "inwiB2C_DeblocageMethodeRecharge","CompteurRecharge": "3", "StatutOperation": "OK", "SubActionOperation": "Déblocage méthode de recharge", "ActionOperation": "Déblocage méthode de recharge","Mdn":"'+this.mdn+'"  }',
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
                 }
            else if (response.result.IPResult.actionStatus == 'FAILED') {
                this.UnblockedError = true;
                this.UnblockedSuccess = false;

                const params = {
                    input: '{}',
                    sClassName: 'InwiB2C_OperationHistory',
                    sMethodName: 'AddOperationHistory',
                    options: '{"SubscriptionId":"'+this.subsid+'","Canal":"'+this.canal+'", "serialNumber":"'+this.serialnumber+'", "pinCode":"'+this.pincode+'", "Partenaire": "'+this.partenaire+'", "TypeModification": "inwiB2C_DeblocageMethodeRecharge", "TypeAction": "inwiB2C_DeblocageMethodeRecharge", "CompteurRecharge": "3", "StatutOperation": "KO", "SubActionOperation": "Déblocage méthode de recharge", "ActionOperation": "Déblocage méthode de recharge","Mdn":"'+this.mdn+'"  }',
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

            }
            }
    })
    .catch(error => {
        console.log('error');
        this.UnblockedError = true;
        window.console.log(error);
    });



}

}