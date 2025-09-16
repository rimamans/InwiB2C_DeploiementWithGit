import { LightningElement, track } from "lwc";

import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";

export default class inwib2c_EligibilitTyFTTHTpeAcessIAM extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  @track hasIAMAccess = "";
  @track ND = "";
  @track Login = "";
  @track ShowInputND = false;
  showMap = false;

  @track proVilleOptions = [];
  @track quartierOptions = [];
  @track voieOptions = [];
  @track searchProvince = "";
  @track searchQuartier = "";
  @track searchVoie = "";
  @track latitudeGPS = "";
  @track longitudeGPS = "";
  @track showProvinceOptions = false;
  @track showVoieOptions = false;
  @track showOptions = false;
  @track filteredProvinceVilleOptions = [];
  @track filteredQuartiersOptions = [];
  @track filteredVoieOptions = [];
  @track quartierLoading = true;
  @track voieLoading = true;
  @track NumVoieLoading = true;
  @track isSearchDone = false;

  codeProvince;
  valueProvince;
  numeroVoieValue = "";

  selectedProVille = "";
  selectedQuartier = "";
  selectedCommuneCode = "";
  selectedQuartierLabel = "";
  selectedVoie = "";
  selectedNumeroVoie = "";

  serviceAccId;
  isServiceAccIdCreated = false;
  isNDLoginEligible = false ; 
  omniScriptUrl;
  inputOs;
  operatorOI;
  _actionUtil;

  statutLigne = "";
  nro = "";
  TypeAcess = "";
  OC1 = "" ; 
  IdClient = "" ; 
  RIO= "" ; 

  _ns = getNamespaceDotNotation();

  connectedCallback() {
    this.hasIAMAccess = false;
    this._actionUtil = new OmniscriptActionCommonUtil();
    this.loadProvinces();
    window.addEventListener("scroll", this.handleScroll, true);
    window.addEventListener("message", this.handleMessage.bind(this));
  }

  disconnectedCallback() {
    window.removeEventListener("scroll", this.handleScroll, true);
  }

  handleScroll = () => {
    this.showProvinceOptions = false;
    this.showOptions = false;
    this.showVoieOptions = false;
  };

  handleMessage(event) {
    const data = event.data;

    if (data && data.name === "GPS" && data.payload) {
      const { latitudeC, longitudeC } = data.payload;
      this.latitudeC = latitudeC;
      this.longitudeC = longitudeC;

      if (this.isSearchDone) {
        this.latitudeGPS = this.latitudeC;
        this.longitudeGPS = this.longitudeC;
      }
    } else if (data && data.searchCompleted) {
      this.isSearchDone = true;
      this.latitudeGPS = this.latitudeC;
      this.longitudeGPS = this.longitudeC;
    }
  }

  get iamOptions() {
    return [
      { label: "Oui", value: "Oui" },
      { label: "Non", value: "Non" }
    ];
  }

  handleIAMAccessChange(event) {
    this.hasIAMAccess = event.target.value;

    if (this.hasIAMAccess == "Oui") {
      this.ShowInputND = true;
      this.ND = "";
      this.Login = "";
      this.statutLigne = "active";
      this.TypeAcess = "Fibre IAM";
      this.showMap = false;
      console.log('this.hasIAMAccess 1', this.hasIAMAccess) ;
    } else {
      this.ShowInputND = false;
      this.ND = "";
      this.Login = "";
      this.statutLigne = "inactive";
      this.TypeAcess = "";
      this.showMap = true;
       console.log('this.hasIAMAccess 2', this.hasIAMAccess) ;
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
    return "212" + nd.substring(1);
  }

  //Controle sur ND qu'il va etre saisie begin
 async checkNDIAM() {
  console.log("in checkND");
  this._actionUtilClass = new OmniscriptActionCommonUtil();
  this.ndIAM212 = this.convertNDTo212(this.ND);
  const input = `{"NumeroDeLaLigne": "${this.ndIAM212}"}`;

  const params = {
    input,
    sClassName: `${this._ns}IntegrationProcedureService`,
    sMethodName: "inwib2c_CheckNDFTTHVula",
    options: "{}"
  };

  console.log("before call checkND", JSON.stringify(params));

  try {
    const response = await this._actionUtilClass.executeAction(params, null, this, null, null);

    if (!response.error && response.result.IPResult) {
      const countSub = response.result.IPResult.CountSub;

      if (countSub == "0") {
        if (this.ND && /^(05|08)[0-9]{8}$/.test(this.ND)) {
          console.log("Le numéro NDIAM peut être utilisé");
          return true; 
        } else {
          await this.showMessage("Erreur", "Le numéro doit commencer par 05 ou 08 et contenir exactement 10 chiffres", "error");
          return false;
        }
      } else {
        await this.showMessage("Erreur", "Numéro de désignation existant", "error");
        return false;
      }
    } else {
      await this.showMessage("Erreur", "Réponse invalide de l'API checkND", "error");
      return false;
    }
  } catch (error) {
    console.error("Erreur lors de checkNDIAM:", error);
    await this.showMessage("Erreur", "Erreur critique lors de la vérification du ND", "error");
    return false;
  }
}
  //Controle sur ND qu'il va etre saisie end

  // apppel a la vip qui va retourner l'elegibilité begin
 async CheckEligiblite() {
  this._actionUtilClass = new OmniscriptActionCommonUtil();
  let input;

  console.log("Update address called");
  console.log("IN CheckEligiblite.");
  console.log(" this.IdClient",  this.IdClient);

  // Validation des champs ND et Login
  if ((this.ND === '' || this.ND == null) && (this.Login === '' || this.Login == null)) {
    await this.showMessage('Erreur', 'Veuillez renseigner le ND ou le Login !', 'error');
    return;
  }

  if ((this.ND !== '' && this.ND != null) && (this.Login !== '' && this.Login != null)) {
    await this.showMessage('Erreur', 'Veuillez ne renseigner que le ND ou que le Login, pas les deux !', 'error');
    return;
  }
   if  ( this.IdClient == ''  || this.IdClient == null) {
      await this.showMessage('Error', "veuillez renseigner l'identifiant client", 'error');
      return ;
    }

  // Construction de l'input selon le champ rempli
  if (this.ND !== '' && this.ND != null) {
    const isNDValid = await this.checkNDIAM();
    if (!isNDValid) {
      return; 
    }
    input = `{"operateur":"iam", "ND":"${this.ND}", "IdClient":"${this.IdClient}" , "RIO":"${this.RIO}" }`; // Y_MH MGEN3790 FTTH-Transfert à 3
  } else if (this.Login !== '' && this.Login != null) {
    input = `{"operateur":"iam", "ND":"${this.Login}", "IdClient":"${this.IdClient}" , "RIO":"${this.RIO}"}`;
  }

  const params = {
    input,
    sClassName: `${this._ns}IntegrationProcedureService`,
    sMethodName: "inwib2c_InwiB2CEligibilitybyND",
    options: "{}"
  };

  console.log("before call CheckEligiblite", JSON.stringify(params));

  try {
    const response = await this._actionUtilClass.executeAction(params, null, this, null, null);

    if (!response.error) {
      const collectPointId = response.result?.IPResult?.collectPointId;
      const status = response.result?.IPResult?.status;
      const Operator = response.result?.IPResult?.oiOperator;
      //Y_MH MGEN3790 FTTH-Transfert à 3 BEGIN
      const IdLigne = response.result?.IPResult?.IdLigne; 
      if (IdLigne != null && IdLigne != '') {
        this.OC1 = 'IAM'
      }
      if  (Operator == 'MARMT') {
        this.operatorOI = 'ORANGE' ; 
      }else {
        this.operatorOI = Operator ; 
      }
       //Y_MH MGEN3790 FTTH-Transfert à 3 END
      this.nro = collectPointId;
      this.isNDLoginEligible = (status === "OK" && (Operator === "IAM" || Operator === "MARMT")); //Y_MH MGEN3790 FTTH-Transfert à 3 

      if (!this.isNDLoginEligible) {
         if (Operator == 'INWI') {
                  this.showMessage('Erreur', 'Merci de passer par FTTH propre INWI', 'error');
                   return; 
                }else {
          console.log("isNDLoginEligible in showmessage 1" ,  this.isNDLoginEligible ) ;
             this.showMessage('Erreur', 'Le ND ou Login que vous avez saisie n\'est pas éligible.', 'error');
             return; 
      } }
      console.log("Collect Point ID:", collectPointId);
      console.log("after call CheckEligiblite", JSON.stringify(response));
      this.omniUpdateDataJson({ oiOperator: this.operatorOI });  //Y_MH MGEN3790 FTTH-Transfert à 3

      this.inputOs = JSON.stringify({

        InOperatorOI: this.operatorOI ,
        InNro: this.nro,
        InTypePartage: "ACTIF",
        InNumeroDesignation: this.ND,
        InLogin: this.Login,
        InStatutLigne: this.statutLigne,
        InTypeAcess: this.TypeAcess ,
         //Y_MH MGEN3790 FTTH-Transfert à 3 begin
        InIdLigne: this.IdLigne , 
        InOC1: this.OC1 
        //Y_MH MGEN3790 FTTH-Transfert à 3 end 
      });

      console.log("inputOs", this.inputOs);

      this.redirectAcquisition();
    } else {
      await this.showMessage('Erreur', 'Une erreur s’est produite lors de l’éligibilité.', 'error');
    }
  } catch (error) {
    console.error("Erreur critique :", error);
    await this.showMessage('Erreur', 'Erreur critique lors de l’appel à l’IP.', 'error');
  }
}
  // apppel a la vip qui va retourner l'elegibilité end

  loadProvinces() {
    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "PROVINCES"
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: {}
    };

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        this.proVilleOptions = response.result.IPResult.results.map(
          (proville) => ({
            label: proville.libelle,
            value: String(proville.code)
          })
        );
      });
  }

  showProvinceOptionsHandler() {
    this.showProvinceOptions = true;
    this.filteredProvinceVilleOptions = [...this.proVilleOptions];
  }

  InitSearchProvince(event) {
    this.searchProvince = event.target.value.toLowerCase();
    this.filteredProvinceVilleOptions = this.searchProvince
      ? this.proVilleOptions.filter((option) =>
          option.label.toLowerCase().includes(this.searchProvince)
        )
      : [];
  }

  ProvinceOptionSelect(event) {
    const selectedValue = event.target.dataset.value;
    const selectedOption = this.proVilleOptions.find(
      (option) => option.value === selectedValue
    );

    if (selectedOption) {
      this.selectedProVille = selectedOption.value;
      this.searchProvince = selectedOption.label;
      this.selectedProVille = selectedOption.value;
      this.valueProvince = selectedOption.label;
      this.loadQuartier();
    } else {
      console.warn("Aucune province sélectionnée !");
    }

    this.showProvinceOptions = false;
  }

  loadQuartier() {
    this.quartierLoading = true;
    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "QUARTIERS",
        codeProvince: this.selectedProVille,
        codeCommune: "",
        codeQuartier: "",
        codeVoie: ""
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: {}
    };

    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        const results = response?.result?.IPResult?.results;

        if (!Array.isArray(results)) {
          console.warn("Données quartiers invalides :", results);
          this.quartierOptions = [];
          this.filteredQuartiersOptions = [];
          return;
        }

        this.quartierOptions = results.map((quartier) => {
          const [codeQuartier, communeCode] = quartier.code.split(":");
          return {
            label: quartier.libelle,
            value: `${codeQuartier}:${communeCode}`,
            communeCode: communeCode
          };
        });
        this.quartierLoading = false;
      })
      .catch((error) => {
        console.error("Erreur lors de la récupération des quartiers:", error);
      });
  }

  showQuartierOptionsHandler() {
    this.showOptions = true;
    this.filteredQuartiersOptions = [...this.quartierOptions];
  }

  InitSearchQuartier(event) {
    this.searchQuartier = event.target.value.toLowerCase();

    if (!Array.isArray(this.quartierOptions)) {
      console.warn("quartierOptions non disponible");
      this.filteredQuartiersOptions = [];
      this.showOptions = false;
      return;
    }

    this.filteredQuartiersOptions = this.searchQuartier
      ? this.quartierOptions.filter((option) =>
          option.label.toLowerCase().includes(this.searchQuartier)
        )
      : [];

    this.showOptions = this.filteredQuartiersOptions.length > 0;
  }

  QuartierOptionSelect(event) {
    const selectedCode = event.target.dataset.value;
    const selectedOption = this.quartierOptions.find(
      (option) => option.value === selectedCode
    );

    if (selectedOption) {
      const [quartierCode, communeCode] = selectedCode.split(":");
      this.selectedQuartier = quartierCode;
      this.selectedCommuneCode = communeCode;

      this.searchQuartier = selectedOption.label;
      this.selectedQuartierLabel = selectedOption.label;

      this.loadVoies();
      this.showOptions = false;
    } else {
      console.log(
        "Aucune correspondance trouvée pour le quartier sélectionné."
      );
    }
  }

  loadVoies() {
    this.voieLoading = true;
    let quartierCode = this.selectedQuartier.split(":")[0];

    let params = {
      input: JSON.stringify({
        keyword: "",
        search: "VOIES",
        codeProvince: this.selectedProVille,
        codeCommune: this.selectedCommuneCode,
        codeQuartier: quartierCode,
        codeVoie: ""
      }),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
      options: {}
    };
    this._actionUtil
      .executeAction(params, null, this, null, null)
      .then((response) => {
        this.voieOptions = response.result.IPResult.results.map((voie) => ({
          label: voie.libelle,
          value: voie.code
        }));
        this.voieLoading = false;
      });
  }

  showVoieOptionsHandler() {
    this.showVoieOptions = true;
    this.filteredVoieOptions = [...this.voieOptions];
  }

  InitSearchVoie(event) {
    this.searchVoie = event.target.value.toLowerCase();
    this.filteredVoieOptions = this.searchVoie
      ? this.voieOptions.filter((option) =>
          option.label.toLowerCase().includes(this.searchVoie)
        )
      : [];
    this.showVoieOptions = this.filteredVoieOptions.length > 0;
  }

  VoieOptionSelect(event) {
    const selectedValue = event.target.dataset.value;
    const selectedOption = this.voieOptions.find(
      (option) => option.value === selectedValue
    );

    if (selectedOption) {
      this.selectedVoie = selectedOption.value;
      this.searchVoie = selectedOption.label;
    }

    this.showVoieOptions = false;
    this.NumVoieLoading = false;
  }

  handleNumVoieChange(event) {
    this.numeroVoieValue = event.target.value;
    this.selectedNumeroVoie = this.numeroVoieValue;
  }

  // async executeEligibilityCheck() {
  //   // if (
  //   //   !this.selectedProVille ||
  //   //   !this.selectedQuartier ||
  //   //   !this.selectedNumeroVoie ||
  //   //   !this.selectedVoie
  //   // ) {
  //   //   alert("Veuillez renseigner tous les champs !");
  //   //   return;
  //   // }
  //   let params = {
  //     input: JSON.stringify({
  //       latitude: this.latitudeC,
  //       longitude: this.longitudeC
  //     }),
  //     sClassName: `${this._ns}IntegrationProcedureService`,
  //     sMethodName: "inwib2c_InwiB2C_EligibilityIAMbyGPS",
  //     options: {}
  //   };

  //   console.log("Coordonnes gps to send as params :", params.input);

  //   this._actionUtil
  //     .executeAction(params, null, this, null, null)
  //     .then((response) => {
  //       const eligibilityFTTHResp = response.result.IPResult;
  //       console.log("response of the new gps vip", eligibilityFTTHResp);
  //       const { status, nro } = eligibilityFTTHResp;

  //       // Affectation de isServiceAccIdCreated selon le status
  //        this.isServiceAccIdCreated = (status === "OK");
  //        console.log("isServiceAccIdCreated" ,  this.isServiceAccIdCreated  ) ;

  //        if (!this.isServiceAccIdCreated) {
  //         console.log("isServiceAccIdCreated in showmessage 11" ,  this.isServiceAccIdCreated  ) ;
  //            this.showMessage('Erreur', 'Le client n\'est pas éligible à la FTTH.', 'error');
  //         return; 
  //          } else if (this.isServiceAccIdCreated) {
  //             this.showMessage('Succès', 'Le logement du client est éligible. Merci de renseigner le détail de l\'adresse.', 'success');
  //          }

  //       const DRProvince =
  //         this.proVilleOptions.find(
  //           (option) => option.value === this.selectedProVille
  //         )?.label || "";
  //       const DRVoie =
  //         this.voieOptions.find((option) => option.value === this.selectedVoie)
  //           ?.label || "";
  //       const DRNumVoie = this.selectedNumeroVoie;

  //       const provinceCode = this.selectedProVille;
  //       const provinceValue = DRProvince;
  //       const quartierCode = this.selectedQuartier;
  //       const quartierValue = this.selectedQuartierLabel;
  //       const voieCode = this.selectedVoie;
  //       const voieValue = DRVoie;
  //       const numVoieValue = DRNumVoie;
  //       const numVoieCode = numVoieValue;
  //       const communeCode = this.selectedCommuneCode;
  //       const noeud = nro;
  //       const statut = status;
  //       const latitudeF = this.latitudeGPS;
  //       const longitudeF = this.longitudeGPS;
  //       const operator = "IAM";

  //       this.inputOs =
  //         '{"InNro":"' +
  //         noeud +
  //         '","InStatutPlaque":"' +
  //         statut +
  //         '","InProvince":"' +
  //         provinceValue +
  //         '","InOperatorOI":"' +
  //         operator +
  //         '","InProvinceCode":"' +
  //         provinceCode +
  //         '","InQuartier":"' +
  //         quartierValue +
  //         '","InQuartierCode":"' +
  //         quartierCode +
  //         '","InCommuneCode":"' +
  //         communeCode +
  //         '","InVoie":"' +
  //         voieValue +
  //         '","InVoieCode":"' +
  //         voieCode +
  //         '","InNumeroVoie":"' +
  //         numVoieValue +
  //         '","InNumVoieCode":"' +
  //         numVoieCode +
  //         '","InLatitude":"' +
  //         latitudeF +
  //         '","InLongitude":"' +
  //         longitudeF +
  //         '","InTypePartage":"ACTIF"}';
  //     });
      
  // }
  async executeEligibilityCheck() {
  let params = {
    input: JSON.stringify({
      latitude: this.latitudeC,
      longitude: this.longitudeC
    }),
    sClassName: `${this._ns}IntegrationProcedureService`,
    sMethodName: "inwib2c_InwiB2C_EligibilityIAMbyGPS",
    options: {}
  };

  const response = await this._actionUtil.executeAction(params, null, this, null, null);
  const eligibilityFTTHResp = response.result.IPResult;

  this.isServiceAccIdCreated = (eligibilityFTTHResp.status === "OK");
  this.nro = eligibilityFTTHResp.nro; 
  this.statutLigne = eligibilityFTTHResp.status;

  if (this.isServiceAccIdCreated) {
    this.showMessage('Succès', 'Le logement est éligible. Merci de renseigner l’adresse.', 'success');
  } else {
    this.showMessage('Erreur', 'Non éligible à la FTTH.', 'error');
  }
}

generateInputOS() {
  const DRProvince = this.proVilleOptions.find(
    (option) => option.value === this.selectedProVille
  )?.label || "";

  const DRVoie = this.voieOptions.find(
    (option) => option.value === this.selectedVoie
  )?.label || "";

  const DRNumVoie = this.selectedNumeroVoie;

  this.inputOs = JSON.stringify({
    InNro: this.nro,
    InStatutPlaque: this.statutLigne,
    InProvince: DRProvince,
    InOperatorOI: "IAM",
    InProvinceCode: this.selectedProVille,
    InQuartier: this.selectedQuartierLabel,
    InQuartierCode: this.selectedQuartier,
    InCommuneCode: this.selectedCommuneCode,
    InVoie: DRVoie,
    InVoieCode: this.selectedVoie,
    InNumeroVoie: DRNumVoie,
    InNumVoieCode: DRNumVoie,
    InLatitude: this.latitudeGPS,
    InLongitude: this.longitudeGPS,
    InTypePartage:"ACTIF"

  });

  console.log("inputOS FINAL:", this.inputOs);
}


  async checkEligibilityFTTH() {
    await this.executeEligibilityCheck("");
  }

  async restartEligibilityWithNewCentralGPS() {
    await this.executeEligibilityCheck("");
  }

  redirectAcquisition() {
    if(this.showMap) {
      if (
      !this.selectedProVille ||
      !this.selectedQuartier ||
      !this.selectedNumeroVoie ||
      !this.selectedVoie
    ) {
      alert("Veuillez renseigner tous les champs !");
      return;
    } 
    this.generateInputOS () ;

    } 
      
    
    

    this.omniApplyCallResp({
      inputOsacq: JSON.parse(this.inputOs),
      test: "test"
    });
    console.log("inputOs éligiité 1", this.inputOs);
    this.omniNextStep();
  }

  get isCommuneDisabled() {
    return !this.selectedQuartier;
  }

  handleNumVoieChange(event) {
    this.numeroVoieValue = event.target.value;
    this.selectedNumeroVoie = this.numeroVoieValue;
  }
}