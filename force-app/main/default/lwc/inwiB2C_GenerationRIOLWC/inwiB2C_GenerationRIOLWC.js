import { LightningElement, api, track, wire } from 'lwc';
import { BaseState } from "vlocity_cmt/baseState";
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import template from "./inwiB2C_GenerationRIOLWC.html"


export default class InwiB2C_GenerationRIOLWC extends BaseState(LightningElement) {
    @track __infoLoaded = false;
    @track mdn;
    @track RIO;
    @track errorRIO;
    @track showButton = false;



    render() {
        return template;
    }

    renderedCallback() {

    }

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        if ([
            "System Administrator",
            "Administrateur système",
            "Fraude Int_Ph3",
            "SC Agent VIP Int_Ph3",
            "SC Agents BO Eshop_Televente N2 Int_Ph3",
            "SC Agents BO réclamation N2_Ph3",
            "SC Agents CRC Helpdesk N1 Ext_Ph3",
            "SC Agents CRC N1 Ext_Ph3",
            "SC Agents CRC Outbound N1 Ext_Ph3",
            "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3",
            "SC Formation Int_Ph3",
            "SC Superviseur BO CRC Ext_Ph3",
            "SC Superviseur BO CRC Int_Ph3",
            "SPOC Portabilité_Ph3",
            "Support N3 SI_Ph3",
            "Support N3 SI_Ph3 V2"].some(profile => this.obj?.userProfile?.toLowerCase() === profile?.toLowerCase())) {
            this.showButton = true
            }


    }

    /*initMapOfValues(){
        this.mapOfValues=[];
        this.obj.forEach(
            element => {
                var newElement = JSON.parse(JSON.stringify(element));
                this.mapOfValues.push(newElement);
            }
        );
    }*/

    GenerateRIO(event) {
        console.log('OK');
        console.log(JSON.stringify(this.obj))
        const options = {};
        let methodeName;
        let error ="";
        let status ="";
        if (this.obj.managedInSF)
            methodeName = 'inwib2c_inwiB2C_generateRIOFromInfo_2';
        else
            methodeName = 'inwib2c_inwiB2C_generateRIO_2';

        if ([
            "System Administrator",
            "Administrateur système",
            "Fraude Int_Ph3",
            "SC Agent VIP Int_Ph3",
            "SC Agents BO Eshop_Televente N2 Int_Ph3",
            "SC Agents BO réclamation N2_Ph3",
            "SC Agents CRC Helpdesk N1 Ext_Ph3",
            "SC Agents CRC N1 Ext_Ph3",
            "SC Agents CRC Outbound N1 Ext_Ph3",
            "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3",
            "SC Formation Int_Ph3",
            "SC Superviseur BO CRC Ext_Ph3",
            "SC Superviseur BO CRC Int_Ph3",
            "SPOC Portabilité_Ph3",
            "Support N3 SI_Ph3",
            "Support N3 SI_Ph3 V2"].every(profile => this.obj?.userProfile?.toLowerCase() !== profile?.toLowerCase()) ){
            this.RIO ="Votre profile n'est pas autorisé à envoyer le code RIO";
            error = "Profile non autorisé à envoyer le code RIO"
            status = "KO"
            this.__infoLoaded = true;

        }

        else if (!this.obj?.num && ["FTTH", "ADSL", "idar", "Home"].some(offre => this.obj?.offreType.includes(offre))){
            this.RIO = 'Aucun numéro de contact sur cette fiche client. Merci de le renseigner et réessayer une autre fois';
            error = "N° de contact inexistant sur la fiche client"
            status = "KO"
            this.__infoLoaded = true;
        } else if (this.obj.isIdentified !== true) {
            error = "Ligne non identifiée"
            status = "KO"
            
        }
           
         else if (this.obj.status === 'InwiB2C_Expired'){
            error = "Ligne résiliée"
            status = "KO"

         }

            const params = {
                input: '{ "rioList": [{"sendSMS": "Y" , "mdn":"' + this.obj?.mdn + '","status": "' + status + '","subId": "' + this.obj?.subId + '","error":"' + error + '" }] , "contactClient":"' + this.obj?.num +'"}',
                sClassName: 'vlocity_cmt.IntegrationProcedureService',
                sMethodName: methodeName,
                options: JSON.stringify(options),


            };
            console.log("params: ", JSON.parse(JSON.stringify(params)));
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    window.console.log(response);
                    if (response.result.IPResult.success != false) {
                        this.__infoLoaded = true;
                        response.result.IPResult.rioList.forEach(ele => {
                            // this.RIO=ele.rio;
                            //IF(this.RIO != null && this.RIO != undefined && this.RIO != '' )
                            //this.RIO='Cette ligne n’est pas identifiée';
                            //  this.errorRIO= ele.rioErrorDesc;
                            console.log('Status:' + ele.rioStatus);
                            console.log('CodeRIO:' + ele.rio);
                            console.log('isIdentified' + this.obj.isIdentified);
                            if(this.obj.status != 'InwiB2C_Expired'){
                            if (this.obj.isIdentified == true) {
                                if (ele.rioStatus === '1')
                                    //this.RIO = ele.rio;
                                    this.RIO = 'Le code est envoyé';
                                else
                                    this.RIO = ele.rioErrorDesc;
                            } else 
                                this.RIO = 'Cette ligne n’est pas identifiée';
                        }else this.RIO = 'Cette ligne est résiliée';
                            
                        });
                    }
                    else
                        this.__infoLoaded = false;

                })
                .catch(error => {
                    window.console.log(error, 'error');
                });
        
    }
}