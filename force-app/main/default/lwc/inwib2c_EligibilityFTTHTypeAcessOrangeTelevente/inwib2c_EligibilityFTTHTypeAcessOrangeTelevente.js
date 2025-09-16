import { LightningElement, track, api } from "lwc";

import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";

export default class Inwib2c_EligibilityFTTHTypeAcessOrangeTelevente extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  vfRoot = "https://inwi-b2c--devevol--c.sandbox.vf.force.com";

  @track isSearchDone = false;
  @api hasorangeaccess  ;
  @track ND = "";
  @api ShowInputND = false ; 
  @api showMap = false;
  address = "";
  serviceAccId;
  isServiceAccIdCreated = false;
  orangeData;
  omniScriptUrl;
  inputOs;
  operatorOI;
  _actionUtil;
  statutLigne = "" ;
  nro = "" ;
  OC1 = "" ; 
  IdClient = "" ; 
  RIO= "" ; 
  TypeAcess = "" ; 
  isNDEligible = false ; 
  _ns = getNamespaceDotNotation();

  connectedCallback() {
    this._actionUtil = new OmniscriptActionCommonUtil();
     console.log('hasOrangeAccess33', this.hasorangeaccess) ;
    

    window.addEventListener("message", (event) => {
      if (event.data && event.data.name === "VFtoLWC" && event.data.payload) {
        const { latitudeC, longitudeC } = event.data.payload;
        this.latitudeC = latitudeC;
        this.longitudeC = longitudeC;
      } else if (event.data && event.data.searchCompleted) {
        this.isSearchDone = true;
      } else if (
        event.data &&
        event.data.name === "CreateServiceAccountOrange" &&
        event.data.payload
      ) {
        const {
          building,
          city,
          latitude,
          longitude,
          operatorOI,
          plateId,
          street,
          district,
          collectPointId
        } = event.data.payload;

        this.building = building;
        this.city = city;
        this.district = district;
        this.operatorOI = operatorOI;
        this.plateId = plateId;
        this.street = street;
        this.latitude = latitude;
        this.longitude = longitude;
        this.collectPointId = collectPointId;

        this.isServiceAccIdCreated = true;
        this.inputOs =
          '{"InOperatorOI":"' +
          operatorOI +
          '","InPlaque":"' +
          plateId +
          '","InNro":"' +
          collectPointId +
          '","InStreet":"' +
          street +
          '","InCity":"' +
          city +
          '","InDistrict":"' +
          district +
          '","InBuilding":"' +
          building +
          '","InLatitude":"' +
          latitude +
          '","InLongitude":"' +
          longitude +
          '","InTypePartage":"ACTIF"}';
      }
    });
    console.log('hasOrangeAccess11', this.hasorangeaccess) ; 
    
    this.handleOrangeAccessChange() ; 
  }

  get orangeOptions() {
    return [
      { label: "Oui", value: "Oui" },
      { label: "Non", value: "Non" }
    ];
  }

  handleOrangeAccessChange() {
    // this.hasOrangeAccess = event.target.value;

    if (this.hasorangeaccess == "Oui") {
      this.ShowInputND = true;
      this.ND = "";
      this.statutLigne = "active"
      this.TypeAcess = "Fibre Orange"
      this.showMap = false;
    } else {
      this.ShowInputND = false;
      this.ND = "";
      this.statutLigne = "inactive"
      this.TypeAcess = ""
      this.showMap = true;
    }
  }

  handleInputChange(event) {
    const { name, value } = event.target;
    this[name] = value;
    console.log("ND au moment de construire inputOs:", this.ND);
  }

  showMessage(t, m, type) {
    const toastEvt = new ShowToastEvent({
        title: t,
        message: m,
        variant: type
    });
    this.dispatchEvent(toastEvt);
}

convertNDTo212(nd) {
    
    return '212' + nd.substring(1);
}

//Controle sur ND qu'il va etre saisie begin
    checkNDIAM() {
      console.log('in checkND');
      this._actionUtilClass = new OmniscriptActionCommonUtil();
      let input;
  
        this.ndIAM212 = this.convertNDTo212(this.ND);
          input = '{"NumeroDeLaLigne": "' + this.ndIAM212 + '"}';
      
      const params = {
        input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_CheckNDFTTHVula",
        options: "{}"
      };
      console.log('before call checkND', JSON.stringify(params));
      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
  
          if (!response.error) {
            if (response.result.IPResult) {
              let countSub = response.result.IPResult.CountSub;
              if (countSub == '0') {

                if ( this.ND != '' && this.ND != null){ 
                  const regex = /^(05|08)[0-9]{8}$/; 

                  if (regex.test(this.ND)) {
                  console.log ('le numero NDIAM peut etre utilisé') ; 
                   if  ( this.IdClient != '' && this.IdClient != null) {
                     this.CheckEligiblite() ; 
                     } else {
                    // Y_MH MGEN3790 FTTH-Transfert à 3 
                      this.showMessage('Error', "veuillez renseigner l'identifiant client", 'error');
                     } 
                
                }else {
                  this.showMessage('Error', 'Le numéro doit commencer par 05 ou 08 et contenir exactement 10 chiffres', 'error');
              }}// Y_MH begin B-28639 end 
                else {
                  this.showMessage('Error', 'Numero de designation invalide ', 'error');
                }
              }
              else {
                this.showMessage('Error', 'Numero de designation existant', 'error');
              }
            }
            else {
              //  console.log('error');     
            }
          }
        })
        .catch(error => {
          window.console.log(error);
  
          this.isLoading = false;
        });
    }
    //Controle sur ND qu'il va etre saisie end

// apppel a la vip qui va retourner l'elegibilité begin
    CheckEligiblite() {
        
 this._actionUtilClass = new OmniscriptActionCommonUtil();
      let input;
  
      console.log('Update adress called');
      // Vérification des champs nécessaires
      
          console.log('IN CheckEligiblite .');
  
          input = '{"operateur":"oma", "ND": "' + this.ND + '" , "IdClient": "' + this.IdClient + '" , "RIO": "' + this.RIO + '"}';  // Y_MH MGEN3790 FTTH-Transfert à 3 

          const params = {
              input,
              sClassName: `${this._ns}IntegrationProcedureService`,
              sMethodName: 'inwib2c_InwiB2CEligibilitybyND',
              options: '{}',
          };

          console.log('before call CheckEligiblite', JSON.stringify(params));
  
          this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
            if (!response.error) {
                
                const collectPointId = response.result?.IPResult?.collectPointId; 
                const status = response.result?.IPResult?.status;
                const Operator = response.result?.IPResult?.oiOperator;
                //Y_MH MGEN3790 FTTH-Transfert à 3 BEGIN
                const IdLigne = response.result?.IPResult?.IdLigne; 
                 if (IdLigne != null && IdLigne != '') {
                  this.OC1 = 'ORANGE'
                  console.log("oiOperateur value" ,  Operator ) ;
                  }
                  if  (Operator == 'MARMT') {
                   this.operatorOI = 'ORANGE' ; 
                  }else {
                  this.operatorOI = Operator ; 
                   }
                 
                 this.isNDEligible = (status === "OK" && (Operator === "MARMT" || Operator === "IAM")); //Y_MH MGEN3790 FTTH-Transfert à 3
                 this.nro = collectPointId ; 

                 if (!this.isNDEligible) {
                   if (Operator == 'INWI') {
                  this.showMessage('Erreur', 'Merci de passer par FTTH propre INWI', 'error');
                   return; 
                 }else {
                  console.log("isNDLoginEligible in showmessage 1" ,  this.isNDLoginEligible ) ;
                     this.showMessage('Erreur', 'Le ND que vous avez saisie n\'est pas éligible.', 'error');
                   return; 
              } }//Y_MH MGEN3790 FTTH-Transfert à 3 END

                
                console.log('Collect Point ID:', collectPointId);
                console.log('after call CheckEligiblite', JSON.stringify(response));
                //Y_MH MGEN3790 FTTH-Transfert à 3 begin
                this.omniUpdateDataJson({ oiOperator: Operator });
                this.inputOs = '{"InOperatorOI":"' + this.operatorOI +'" ,"InNro":"' + this.nro +'" , "InTypePartage":"ACTIF" , "InNumeroDesignation":"' + this.ND +'", "InStatutLigne":"' + this.statutLigne +'", "InTypeAcess":"' + this.TypeAcess +'" , "InIdLigne":"' + this.IdLigne +'" , "InOC1":"' + this.OC1 +'"}';
                console.log ("inputos" , this.inputOs) ; 
                 //Y_MH MGEN3790 FTTH-Transfert à 3 end

                this.redirectAcquisition() ; 

                
            } else {
                this.showMessage('Erreur', 'error', 'Une erreur s’est produite lors de l’éligibilité.');
            }
        })
        .catch(error => {
            console.error('Erreur critique :', error);
            this.showMessage('Erreur', 'error', 'Erreur critique lors de l’appel à l’IP.');
        });
      
  
    }
    // apppel a la vip qui va retourner l'elegibilité end


  async executeEligibilityCheck(skipOperator) {
    let params = {
      input: JSON.stringify({
        skipOperator: skipOperator || "INWI",
        coordinates: {
          latitude: this.latitudeC,
          longitude: this.longitudeC
        }
      }),

      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_CheckEligibilityFTTHVula",
      options: {}
    };

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        const eligibilityFTTHResp = response.result.IPResult;
        const { operator } = eligibilityFTTHResp;
        this.operatorOI = operator;
        this.skipOperator = operator;

        if (eligibilityFTTHResp && Array.isArray(eligibilityFTTHResp.address)) {
          const orangeData = eligibilityFTTHResp.address.map((address) => ({
            collectPointId: address.collectPointId,
            latitude: address.coordinate.latitude,
            longitude: address.coordinate.longitude,
            building: address.building,
            district: address.district,
            street: address.street,
            city: address.city,
            title: `${address.street}`,
            operator: eligibilityFTTHResp.operator,
            plateId: address.plateId
          }));

          const iframeEligibleOrange = this.template.querySelector("iframe");
          if (iframeEligibleOrange) {
            iframeEligibleOrange.contentWindow.postMessage(
              { name: "OrangeData", orangeData },
              this.vfRoot
            );
          }
        }
      });
  }

  async checkEligibilityFTTH() {
    await this.executeEligibilityCheck("");
  }

  async restartEligibilityWithNewCentralGPS() {
    await this.executeEligibilityCheck(this.skipOperator);
  }

  redirectAcquisition() {
    this.omniApplyCallResp({
      inputOsacq: JSON.parse(this.inputOs),
      test: "test"
    });
    this.omniNextStep();
  }
}