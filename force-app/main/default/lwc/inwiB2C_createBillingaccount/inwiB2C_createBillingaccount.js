import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { createRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwiB2C_createBillingaccount.html";

export default class inwiB2C_createBillingaccount extends OmniscriptBaseMixin(
  LightningElement
) {
  saving = false;
  isModalOpen = false;
  @api compteclientid;
  @api addressclient;
  @api Addresseid;
  _ns = getNamespaceDotNotation();

  @api p;
  @api r;

  @api v;
  @api q;
  @api pq;
  messageblacklist;
  banquename;
  _List = [];
  @track loading;
  __records;

  ALLRECORDS = [];

  nomducompte = "";

  optionadresse = "old_address";
  modeSelected = "Guichet";
  haserror = false;
  PaysName = "Maroc";
  fieldVisible;
  picklistVisible;
  VilleName;
  RegionName;
  QuartierName;
  disableButton = false;
  codepostal;
  complementaddress;
  showother = true;
  __post;
  __part1;
  __part2;
  __mod = 97;
  __int = "00";

  __key;
  __keyfinal;
  __clerib;
  __codebq;
  __records;
  __res = 0;
  __iscameleon;
  __isdisplayed;




  @api
  get records() {
    this.loading = false;

    if (this.ALLRECORDS.length == 0) this.ALLRECORDS = this.__records;

    return this.__records;
  }
  set records(value) {
    this.loading = false;

    this.__records = value;
    console.log("__records1" + JSON.stringify(this.__records));
  }

  @api
  get iscameleon() {
    return this.__iscameleon;
  }
  set iscameleon(value) {
    this.__iscameleon = value;
  }

  get options() {
    const options = [];

    // Vérifie si addressclient est défini et non vide
    if (this.addressclient && this.addressclient.trim() !== "") {
        options.push({
            label: `Adresse Client (${this.addressclient})`,
            value: "old_address",
        });
        options.push({ label: "Nouvelle adresse", value: "new_address" });
    } else {
    // options.push({ label: "Nouvelle adresse", value: "new_address" });
    }

    return options;
}




get isAddressClientValid() {
  return this.addressclient && this.addressclient.trim() !== '';
}


  handleChange1(event) {
    this.optionadresse = event.detail.value;
    if (this.optionadresse == "new_address") {
      this.fieldVisible = true;
    } else {
      this.fieldVisible = false;
    }
  }

  handleChange2(event) {
    this.modeSelected = event.detail.value;
    if (this.modeSelected == "Prélèvement automatique (RIB)") {
      this.picklistVisible = true;
    } else {
      this.picklistVisible = false;
    }
  }

  handleChangeInput(event) {
    if (event.target.name == "Codebanque") {
      this.template.querySelector(`[data-theid="NomBanque"]`).value = "";
      let obj = {
        "AlAkhdar Bank": "365",
        "Algemen Bank Marokko": "23",
        "Arab Bank": "002",
        "Attijariwafabank": "007",
        "BANCO SABADELL CASABLANCA": "070",
        "BANQUE POPULAIRE DU CENTRE SUD": "101",
        "BANQUE POPULAIRE LAAYOUNE": "143",
        "BANQUE POPULAIRE MEKNES": "145",
        "BANQUE POPULAIRE ZEGANGANE": "150",
        "Bank Al-Maghrib": "001",
        "Banque Centrale Populaire ": "140",
        "Banque Marocaine Du Commerce Et L'industrie": "13",
        "Banque Marocaine Du Commerce Exterieur": "011",
        "Banque Marocaine Pour L'afrique Et L'orient": "25",
        "Banque Nationale Pour Le Developpement Economique": "205",
        "Banque Popolaire Tanger": "164",
        "Banque Populaire - Safi - El Jadida": "117",
        "Banque Populaire De Casablanca": "178",
        "Banque Populaire De Casablanca": "190",

        "Banque Populaire De Rabat Agdal": "181",
        "Banque Populaire Marrakech Agence Tensift": "145",
        "Banque Populaire Oujda": "157",
        "Banque Populaire Roudani Fes": "127",
        "CDG CAPITAL: Agene place My Hassan": "54",
        "CFG BANK": "050",
        "Caisse Nationale De Credit Agricole": "145",
        "Centre Des Cheques Postaux": "925",
        "Citibank Maghreb": "028",
        "Credit Immobilier Et Hotelier": "230",
        "LA CAIXA": "003",
        "Banque Populaire Marrakech Agence Tensift": "145",
        "Banque Populaire Marrakech Agence Tensift": "145",
        "P.T.T": "920",
        "Paierie Regionale Du Tresor": "915",
        "Poste Rabat - Agdal": "350",
        "Recette Des Finances Ain Sebaa-Hay El Mohammadi": "900",
        "Recette Des Finances Ben Msik Sidi Othman": "917",
        "Recette Des Finances Casablanca-Anfa": "906",
        "Recette Des Finances El Fida Derb Soltan": "902",
        "Societe De Banque Et De Credit": "009",
        "Societe Generale Marocaine De Banques": "022",
        "Societe Marocaine De Depot Et De Credit": "031",
        "Trésorerie Générale du Royaume": "310",
        "UMNIA BANQUE": "960",
        "Union Bancarta Hispano Marroqui": "026",
        "Union Marocaine De Banques": "005",
        "Union Marocaine De Banques": "810"




      };
      for (let key in obj) {
        let value = obj[key];
        // console.log(key, value);
        // console.log("banquename" +value);

        if (event.target.value == value.toString()) {
          this.NomBanque = key;
          this.template.querySelector(`[data-theid="NomBanque"]`).value = key;
        }
      }
    }
    this[event.target.name] = event.target.value;
  }

  handleChangeCombo(event) {
    this.modeSelected = event.detail.value;
    if (this.modeSelected == "Prélèvement automatique (RIB)") {
      this.picklistVisible = true;
    } else {
      this.picklistVisible = false;
    }
  }

  get list() {
    this.loading = false;

    try {
      console.log("__records" + JSON.stringify(this.__records));

      if (this.__records) {
        let history = JSON.parse(JSON.stringify(this.__records));

        console.log(JSON.stringify(this._properties));
        return this._properties;
      } else {
        return [];
      }
    } catch (error) {
      console.log("error: " + error);
      return [];
    }
  }

  @track isModalOpen = false;
  checkrib() {
    console.log("this.ComptebanqueNum.", this.ComptebanqueNum);
    // this.post = parseInt(this.ComptebanqueNum.substring(0, 4));
    //this.part1 = parseInt(this.ComptebanqueNum.substring(4, 10));
    // this.part2 = parseInt(this.ComptebanqueNum.substring(10, 16));


    //this.codebq = parseFloat(this.ComptebanqueNum);
    //this.key = this.codebq % this.__mod;
    //console.log("this.key", this.key);
    //this.key = (this.key * 1000 + this.post) % this.__mod;
    //this.key = (this.key * 10000 + this.part1) % this.__mod;
    //this.key = (this.key * 1000000 + this.part1) % this.__mod;
    // this.key = (this.key * 1000000 + this.part2) % this.__mod;
    //this.key = (this.key * 100) % this.__mod;

    //this.key = parseInt(this.__mod - parseInt(this.key));
    console.log("this.int", this.__int);
    console.log("this.this.Codebanque", this.Codebanque);
    console.log("this.Codeguichet", this.Codeguichet);
    console.log("this.ComptebanqueNum", this.ComptebanqueNum);
    console.log("this.this.__mod", this.__mod);

    this.clerib = this.Codebanque +
      this.Codeguichet +
      this.ComptebanqueNum +
      this.__int;

    console.log("this.clerib ", this.clerib);
    let i = 0;
    let res = 0;
    // this.keyfinal = this.modulo( this.clerib, this.__mod);
    for (i = 0; i < this.clerib.length; i++) {
      res = (res * 10 +
        parseInt(this.clerib[i])) % 97;
      console.log("this.res" + res);

    }
    console.log("this.keyFinales0" + res);

    this.key = this.__mod - res;
    console.log("this.keyFinale" + this.key);












    console.log("this.keyFinales1" + this.keyfinal);

    // this.keyfinal= this.__mod -this.keyfinal;
    // console.log("this.keyFinales2" +this.keyfinal);
    this.keyfinal = "";
    if (this.key.toString().length == 1) {
      this.keyfinal = "0" + this.key.toString();
    }
    else {

      this.keyfinal = this.key.toString();

    }
    console.log("keyFinal" + this.keyfinal);


    return this.keyfinal == this.CleCompte.toString();

  }




  openModal() {


    console.log("this.Codebanque", this.modeSelected);
    console.log(this.Codebanque);
    console.log("this.Codebanque.length");

    console.log("clééé");
    console.log(typeof this.codepostal);
    console.log(!isNaN(parseFloat(this.codepostal)));
    console.log(!isNaN(this.codepostal - 0));

    let codePostalcondition = this.codepostal ? (!isNaN(parseFloat(this.codepostal)) && !isNaN(this.codepostal - 0)) : true;
    console.log("codePostalcondition", codePostalcondition);
    console.log("this.optionadresse == ", this.optionadresse == "new_address");
    console.log("Code = " + this.codepostal);

    //console.log(this.Codebanque.length);
    //console.log(this.Codebanque.length);
    // to open modal set isModalOpen tarck value as true
    this.haserror = false;
    if (!this.nomducompte || this.nomducompte == "") {
      this.haserror = true;
      this.errormessage = "Veuillez saisir le nom du compte";
    } else if (this.PaysName == null && this.optionadresse == "new_address") {
      this.haserror = true;
      this.errormessage = "Veuillez sélectionner un pays";
    }
    else if (this.optionadresse == "new_address" && codePostalcondition == false) {
      this.haserror = true;
      this.errormessage = "Le code postal doit  contenir que des chiffres";
    }
    else if (
      this.modeSelected == "Prélèvement automatique (RIB)" && !this.checkrib()) {
      this.haserror = true;
      this.errormessage = "RIB invalide";
    }
    else if (
      this.IntitCompte == null &&
      this.modeSelected == "Prélèvement automatique (RIB)"
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir un intitulé de compte";
    } else if (
      this.Codebanque == null &&
      this.modeSelected == "Prélèvement automatique (RIB)"
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir le code de la banque";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.Codebanque &&
      this.Codebanque.length <= 2
    ) {
      this.haserror = true;
      this.errormessage = "Code banque doit contenir que 3 chiffres";
    }
    else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.Codebanque &&
      this.Codebanque.length > 3
    ) {
      this.haserror = true;
      this.errormessage = "Code banque doit contenir que 3 chiffres";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.Codeguichet == null
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir le code guichet";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.Codeguichet &&
      this.Codeguichet.length <= 2
    ) {
      this.haserror = true;
      this.errormessage = "Code guichet doit contenir que 3 chiffres";
    }
    else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.Codeguichet &&
      this.Codeguichet.length > 3
    ) {
      this.haserror = true;
      this.errormessage = "Code guichet doit contenir que 3 chiffres";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.ComptebanqueNum == null
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir le numéro de compte";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.ComptebanqueNum &&
      this.ComptebanqueNum.length <= 15
    ) {
      this.haserror = true;
      this.errormessage = "N° de compte doit contenir que 16 chiffres";
    }
    else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.ComptebanqueNum &&
      this.ComptebanqueNum.length > 16
    ) {
      this.haserror = true;
      this.errormessage = "N° de compte doit contenir que 16 chiffres";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.CleCompte == null
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir la clé du banque";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.CleCompte &&
      this.CleCompte.length < 2
    ) {
      this.haserror = true;
      this.errormessage = "Clé Rib doit contenir que 2 chiffres";
    }
    else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.CleCompte &&
      this.CleCompte.length > 3
    ) {
      this.haserror = true;
      this.errormessage = "Clé Rib doit contenir que 2 chiffres";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.NomBanque == null
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir le nom de la banque";
    }
    //else if (
    //  this.modeSelected == "Prélèvement automatique (RIB)" &&
    //  this.Nomagence == null
    //) {
    //   this.haserror = true;
    //   this.errormessage = "Veuillez saisir le nom de l'agence";
    //}
    else if (
      this.VilleName == null &&
      this.optionadresse == "new_address" &&
      this.PaysName == "Maroc"
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez sélectionner une ville";
    } else {
      this.haserror = false;
      this.isModalOpen = true;
    }
  }
  closeModal() {
    // to close modal set isModalOpen tarck value as false
    this.modeSelected = 'Guichet';
    this.picklistVisible = false;
    this.nomducompte = '';
    this.IntitCompte = '';
    this.Codeguichet == '';
    this.ComptebanqueNum = '';
    this.Nomagence = '';
    this.Codebanque = '';
    this.CleCompte = '';
    this.NomBanque = '';
    this.isModalOpen = false;
    this.messageblacklist = "";

  }
  Previous() {
    this.omniPreviousStep();
  }

  ModePaiementPicklistvalues = [
    {
      value: "Prélèvement automatique (RIB)",
      label: "Prélèvement automatique (RIB)",
    },
    { value: "Guichet", label: "Guichet" },
  ];

  ModePaiementPicklistvaluesCameleon = [
    { value: "Guichet", label: "Guichet" },
  ];

  createAccount(event) {




    console.log("this.Codebanque", this.modeSelected);
    console.log(this.Codebanque);
    console.log("this.Codebanque.length");

    console.log("clééé");
    console.log(typeof this.codepostal);
    console.log(!isNaN(parseFloat(this.codepostal)));
    console.log(!isNaN(this.codepostal - 0));

    let codePostalcondition = this.codepostal ? (!isNaN(parseFloat(this.codepostal)) && !isNaN(this.codepostal - 0)) : true;
    console.log("codePostalcondition", codePostalcondition);
    console.log("this.optionadresse == ", this.optionadresse == "new_address");
    console.log("Code = " + this.codepostal);

    //console.log(this.Codebanque.length);
    //console.log(this.Codebanque.length);
    // to open modal set isModalOpen tarck value as true
    this.haserror = false;
    if (!this.nomducompte || this.nomducompte == "") {
      this.haserror = true;
      this.errormessage = "Veuillez saisir le nom du compte";
    } else if (this.PaysName == null && this.optionadresse == "new_address") {
      this.haserror = true;
      this.errormessage = "Veuillez sélectionner un pays";
    }
    else if (this.optionadresse == "new_address" && codePostalcondition == false) {
      this.haserror = true;
      this.errormessage = "Le code postal doit  contenir que des chiffres";
    }
    else if (
      this.modeSelected == "Prélèvement automatique (RIB)" && !this.checkrib()) {
      this.haserror = true;
      this.errormessage = "RIB invalide";
    }
    else if (
      this.IntitCompte == null &&
      this.modeSelected == "Prélèvement automatique (RIB)"
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir un intitulé de compte";
    } else if (
      this.Codebanque == null &&
      this.modeSelected == "Prélèvement automatique (RIB)"
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir le code de la banque";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.Codebanque &&
      this.Codebanque.length <= 2
    ) {
      this.haserror = true;
      this.errormessage = "Code banque doit contenir que 3 chiffres";
    }
    else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.Codebanque &&
      this.Codebanque.length > 3
    ) {
      this.haserror = true;
      this.errormessage = "Code banque doit contenir que 3 chiffres";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.Codeguichet == null
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir le code guichet";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.Codeguichet &&
      this.Codeguichet.length <= 2
    ) {
      this.haserror = true;
      this.errormessage = "Code guichet doit contenir que 3 chiffres";
    }
    else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.Codeguichet &&
      this.Codeguichet.length > 3
    ) {
      this.haserror = true;
      this.errormessage = "Code guichet doit contenir que 3 chiffres";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.ComptebanqueNum == null
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir le numéro de compte";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.ComptebanqueNum &&
      this.ComptebanqueNum.length <= 15
    ) {
      this.haserror = true;
      this.errormessage = "N° de compte doit contenir que 16 chiffres";
    }
    else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.ComptebanqueNum &&
      this.ComptebanqueNum.length > 16
    ) {
      this.haserror = true;
      this.errormessage = "N° de compte doit contenir que 16 chiffres";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.CleCompte == null
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir la clé du banque";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.CleCompte &&
      this.CleCompte.length < 2
    ) {
      this.haserror = true;
      this.errormessage = "Clé Rib doit contenir que 2 chiffres";
    }
    else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.CleCompte &&
      this.CleCompte.length > 3
    ) {
      this.haserror = true;
      this.errormessage = "Clé Rib doit contenir que 2 chiffres";
    } else if (
      this.modeSelected == "Prélèvement automatique (RIB)" &&
      this.NomBanque == null
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez saisir le nom de la banque";
    }
    //else if (
    //  this.modeSelected == "Prélèvement automatique (RIB)" &&
    //  this.Nomagence == null
    //) {
    //   this.haserror = true;
    //   this.errormessage = "Veuillez saisir le nom de l'agence";
    //}
    else if (
      this.VilleName == null &&
      this.optionadresse == "new_address" &&
      this.PaysName == "Maroc"
    ) {
      this.haserror = true;
      this.errormessage = "Veuillez sélectionner une ville";
    } else {
      this.haserror = false;
      this.saving = true;
    }

      //this.messageblacklist = "";
      this.disableButton = true;
     
      let accoutName = this.template.querySelector(`[data-theid="accoutName"]`);
      if(accoutName ==''){
        accoutName="X11"
      }
      let accoutNumber = this.template.querySelector(
        `[data-theid="accoutNumber"]`
      );
      let accountPhone = this.template.querySelector(
        `[data-theid="accountPhone"]`
      );
      let ModePaiement = this.template.querySelector(
        `[data-theid="ModePaiement"]`
      );
      if (this.modeSelected == "Prélèvement automatique (RIB)") {
        let IntitCompte = this.template.querySelector(
          `[data-theid="IntitCompte"]`
        );
        let Codebanque = this.template.querySelector(`[data-theid="Codebanque"]`);

        let ComptebanqueNum = this.template.querySelector(
          `[data-theid="ComptebanqueNum"]`
        );
        let CleCompte = this.template.querySelector(`[data-theid="CleCompte"]`);
        let NomBanque = this.template.querySelector(`[data-theid="NomBanque"]`);
        let Nomagence = this.template.querySelector(`[data-theid="Nomagence"]`);
      }

      //  console.log('accoutName.value: ' +accoutName.value);
      let Pays = this.template.querySelector(`[data-theid="Pays"]`);
      let Ville = this.template.querySelector(`[data-theid="Ville"]`);
      let idadresse = this.template.querySelector(`[data-theid="Idaddress"]`);
      console.log('this.__iscameleon222'+this.__iscameleon);
      let isCameleon = this.__iscameleon == true ? 'true' : 'false' ;
      console.log('isCameleon'+isCameleon);
console.log('this.compteclientid'+this.compteclientid);
      // Creating mapping of fields of Account with values
      var fields = {
        Name: accoutName.value,
        AccountNumber: "X11111",
        InwiB2C_Mode_de_paiement__c: ModePaiement.value,
        vlocity_cmt__Status__c: "Nouveau",
        ParentId: this.compteclientid,
        Inwib2c_Type_d_offre__c: "Postpayé",
        InwiB2C_Address__c: idadresse,

        InwiB2C_Intitul_du_compte__c: this.IntitCompte,
        InwiB2C_Num_ro_de_compte_bancaire__c: this.ComptebanqueNum,

        InwiB2C_Cle__c: this.CleCompte,
        InwiB2C_Nom_de_la_banque__c: this.NomBanque,
        InwiB2C_Nom_de_l_agence__c: this.Nomagence,
        InwiB2C_Code_banque__c: this.Codebanque,
        InwiB2C_isCameleon__c : isCameleon,
      };

      //VIP check Blacklist
      let input =
        `{
      "rib": "` +
        this.Codebanque +
        this.Codeguichet +
        this.ComptebanqueNum +
        this.CleCompte +
        `"
  }`;
      const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_Blacklist_RIB",
        options: "{}",
      };
      console.log("input rib------->");
      console.log(input);

      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          console.log("responsevip", response);
          //!response.result && !response.result.IPResult &&
          const responsevip = response.result.IPResult.isblacklist;
          if (!responsevip) {
            this.messageblacklist = "";
            let dataToSend = { ModePaiement: ModePaiement.value };

            // console.log("ligne 296 == ",indexpays, Idpays);
            // console.log("ligne 297 == ",this.PaysValues);
            console.log(
              "ligne 298 == ",
              this.v,
              this.q,
              this.pq,
              this.valuePays,
              this.VilleValues,
              this.Idpays,
              this.idVille
            );

            var fieldsbill = {
              InwiB2C_Pays__c: this.valuePays,
              inwiB2C_Ville__c: this.v,
              InwiB2C_Quartier__c: this.q,
              InwiB2C_Precision_Quartier__c: this.pq,
              //InwiB2C_Region__c: this.RegionValues,
              Name: "test",
              InwiB2C_Code_Postale__c: this.codepostal,
              InwiB2C_Rue_Complement_d_adresse__c: this.complementaddress,
            };

            dataToSend.fieldsbill = fieldsbill;
            dataToSend.fields = fields;
            dataToSend.accnumberbilling = fields.AccountNumber;

            this.omniUpdateDataJson({
              fieldsbill,
              fields,
              accnumberbilling: fields.AccountNumber
            });

            console.log("ligne 310 == ", JSON.stringify(fieldsbill));
            console.log("quartier", this.QuartierValues);
            console.log("quartieré", this.q);

            console.log("precisionquartier", this.PrecisionQuartier);
            console.log("precisionquartier", this.Pq);
            console.log("region", this.r);

            // Record details to pass to create method with api name of Object.
            var objRecordInput = { apiName: "Account", fields };
            var objRecordInputaddress = {
              apiName: "InwiB2C_Address__c",
              fieldsbill,
            };
            console.log("fieldVisible true");

            console.log("fieldVisible false");
            createRecord(objRecordInput)
              .then(response => {
                console.log(
                  "----------------Account created with Id: " + response.id
                );
                dataToSend.IdselectedAcc = response.id;
                this.omniUpdateDataJson({ IdselectedAcc: response.id });
                if (this.optionadresse == "old_address") {
                  this.saving = false;

                  if (this.__from == "changementtitulaire") {
                    dataToSend.choixadresse = "old";
                    const selectedEvent = new CustomEvent("addbillingaccount", {
                      detail: dataToSend
                    });

                    // Dispatches the event.
                    this.dispatchEvent(selectedEvent);
                  } else {
                    this.omniUpdateDataJson({
                      choixadresse: "old",
                    });
                    this.omniNextStep();
                  }

                } else {
                  createRecord(objRecordInputaddress)
                    .then(response => {
                      console.log(
                        "*****************adress created with Id: " + response.id
                      );
                      this.disableButton = false;
                      this.saving = false;
                      if (this.__from == "changementtitulaire") {
                        dataToSend.choixadresse = "new";
                        dataToSend.Idaddress = response.id;
                        const selectedEvent = new CustomEvent("addbillingaccount", {
                          detail: dataToSend
                        });
                        // Dispatches the event.
                        this.dispatchEvent(selectedEvent);

                      } else {
                        this.omniUpdateDataJson({
                          Idaddress: response.id,
                          choixadresse: "new",
                        });

                        this.omniNextStep();
                      }
                    })
                    .catch(error => {
                      console.log("Error: " + JSON.stringify(error));
                    }); /**/
                }
              })
              .catch(error => {
                console.log("Error: " + JSON.stringify(error));
              }); /**/
          } else {

            this.haserror = true;
            this.errormessage = "Attention client blacklisté";
          }
        })
        .catch(error => {
          this.saving = false;
          console.log("error");
          window.console.log(error);
        });
  
  }
  searchDataTable(event) {
    this.loading = false;

    try {
      var searchString = event.target.value.toUpperCase();
      // var allTheRecords =   this.__records;
      var searchResults = [];
      var i;

      console.log("searchString:: " + searchString);
      if (searchString == "") {
        console.log("if::searchString:: " + searchString);
        console.log("if::this.ALLRECORDS.length:: " + this.ALLRECORDS.length);

        console.log("if::this.ALLRECORDS:: ");
        console.log(this.ALLRECORDS);

        this.__records = this.ALLRECORDS;
      } else {
        for (i = 0; i < this.ALLRECORDS.length; i++) {
          if (
            (this.ALLRECORDS[i].AccountNumber &&
              this.ALLRECORDS[i].AccountNumber
                .toUpperCase()
                .includes(searchString)) ||
            (this.ALLRECORDS[i].Statut &&
              this.ALLRECORDS[i].Statut.toUpperCase().includes(searchString)) ||
            (this.ALLRECORDS[i].ModePaiement &&
              this.ALLRECORDS[i].ModePaiement
                .toUpperCase()
                .includes(searchString))
          ) {
            searchResults.push(this.ALLRECORDS[i]);
          }
        }
        this.__records = searchResults;
      }
    } catch (error) {
      console.log("error :::" + error);
    }
  }

  preSelectedRows = [];
  lastslectedId;
  getSelectedName(event) {
    this.loading = false;

    const selectedRows = event.detail.selectedRows;

    console.log("Selected Records: ");
    console.log(event.detail.selectedRows);

    console.log("Selected Records length: ");
    console.log(event.detail.selectedRows.length);

    console.log("last Selected Records: ");
    console.log(
      event.detail.selectedRows[event.detail.selectedRows.length - 1]
    );

    let IdAccountbill = selectedRows[event.detail.selectedRows.length - 1].Id;

    this.omniUpdateDataJson({ IdselectedAcc: IdAccountbill });

    let my_ids = [];
    my_ids.push(
      selectedRows[event.detail.selectedRows.length - 1].AccountNumber
    );
    this.preSelectedRows = my_ids;
    /*
           // event.detail.selectedRows = event.detail.selectedRows[event.detail.selectedRows.length-1];

            var el = this.template.querySelector('lightning-datatable');
            console.log('el.SelectedRows::');
            console.log(el.SelectedRows);

           //  this.preSelectedRows=event.detail.selectedRows[event.detail.selectedRows.length-1];
             console.log('selectedRows[event.detail.selectedRows.length-1].AgenceName::');
             console.log(selectedRows[event.detail.selectedRows.length-1].AgenceName);

             if(event.detail.selectedRows.length==2){
                this.lastslectedId=selectedRows[event.detail.selectedRows.length-1].AgenceName;
                 my_ids.push(selectedRows[event.detail.selectedRows.length-1].AgenceName);
             }else{

                this.lastslectedId=selectedRows[event.detail.selectedRows.length-1].AgenceName;

             }

             this.preSelectedRows = my_ids;*/
  }

  render() {
    console.log("Account addresse: " + this.addressclient);
    console.log("Id addresse: " + this.Addresseid);
    return template;
  }

  strName;
  strAccountNumber;
  strPhone;
  // Change Handlers.
  nameChangedHandler(event) {
    this.strName = event.target.value;
  }
  numberChangedHandler(event) {
    this.strAccountNumber = event.target.value;
  }
  phoneChangedHandler(event) {
    this.strPhone = event.target.value;
  }
  // Insert record.
  /* createAccount(){
            this.loading = true;

            // Creating mapping of fields of Account with values
            var fields = {'Name' : this.strName, 'AccountNumber' : this.strAccountNumber, 'Phone' : this.strPhone, 'ParentId':this.compteclientid};
            // Record details to pass to create method with api name of Object.
            var objRecordInput = {'apiName' : 'Account', fields};
            // LDS method to create record.
            createRecord(objRecordInput).then(response => {
                alert('Account created with Id: ' +response.id);
            }).catch(error => {
                alert('Error: ' +JSON.stringify(error));
            });
        }*/

  PaysValues = [];
  RegionValues = [];
  VilleValues = [];
  QuartierValues = [];

  isToSpecify = false;
  renderedCallback() {
    console.log("rendred callback")
  }

  connectedCallback() {
    console.log("__iscameleon"+this.__iscameleon);
if(this.__iscameleon == false){
  this.__isdisplayed = false;

  console.log('in cameleon egale false');
    this.omniUpdateDataJson({ "choix ": this.ModePaiementPicklistvalues });
}else{
  this.__isdisplayed = true;
  this.omniUpdateDataJson({ "choix ": this.ModePaiementPicklistvaluesCameleon });
  console.log('in cameleon egale true');
}
console.log('__isdisplayed'+this.__isdisplayed);
    console.log("this.p: " + this.p);
    console.log("this.r: " + this.r);
    console.log("this.v: " + this.v);
    console.log("this.q: " + this.q);
    console.log("this.pq: " + this.pq);

    if (this.PaysValues.length != 0) {
      console.log('re call r')
      let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Regions","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Country Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"Pays__c","InterfaceObjectName__c":"InwiB2C_Region__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Regions:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Regions:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Country Name":"' + this.p + '"}}';
      this.fetchPicklistValues('region', inp)
    }


    if (this.PaysValues.length == 0) {
      let inp =
        '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Pays__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}';

      this.fetchPicklistValues("pays", inp);
    }
    if (this.VilleValues.length == 0) {
      let inpputVille =
        '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}';
      this.fetchPicklistValues("ville", inpputVille);
    }

    if (this.v != null) {
      this.omniUpdateDataJson({ Quartier: this.q });

      let inp =
        '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' +
        this.v +
        '"}}';
      this.fetchPicklistValues("quartier", inp);
    }

    if (this.p != null) {
      this.omniUpdateDataJson({ Pays: this.valuePays });
    }
    if (this.v != null) {
      this.setRegionInfo(this.v);
      this.omniUpdateDataJson({ Ville: this.v });
    }
  }

  IdMaroc;
  fetchPicklistValues(picklist, input) {
    //console.log('start fetchPicklistValues')
    this._actionUtilClass = new OmniscriptActionCommonUtil();

    const params = {
      input: input,
      sClassName: "vlocity_cmt.DefaultFetchPicklistOptionsImpl",
      sMethodName: "fetchLookupOptions",
      options: "{}",
    };

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        // //console.log('response.result.options')
        // //console.log(response.result.options)
        let rs = [];
        //  //console.log('Object.keys(empty).length : '+Object.keys(response.result.options).length )

        //  //console.log('response.result.options')
        // //console.log(response.result.options)

        if (Object.keys(response.result.options).length == 0) {
          //console.log('start the empty case')
          let v = {
            label: "Aucun élément",
            value: "null",
          };
          //console.log('v : ')
          //console.log(v)

          rs.push(v);
          //console.log('end the empty case')
        } else {
          rs = response.result.options.map(element => {
            let temp = {};
            //   if (element.value == 'Maroc')
            temp["label"] = element.value;
            temp["value"] = element.name;
            return temp;
          });
        }

        if (picklist === "pays") {
          this.PaysValues = rs;
          let indexMaroc = this.PaysValues.findIndex(x => x.label === "Maroc");

          //console.log('indexMaroc: ' + indexMaroc)
          //console.log('this.PaysValues[indexMaroc]: ' + this.PaysValues[indexMaroc].value)
          this.omniUpdateDataJson({
            IdMaroc: this.PaysValues[indexMaroc].value,
          });
          if (!this.p) {
            this.omniUpdateDataJson({
              Pays: this.PaysValues[indexMaroc].value,
            });
            this.omniUpdateDataJson({ PaysName: "Maroc" });
          }

          if (this.valuePays == null)
            this.valuePays = this.PaysValues[indexMaroc].value;
          this.IdMaroc = this.PaysValues[indexMaroc].value;

          this.PaysValues.splice(
            0,
            0,
            this.PaysValues.splice(indexMaroc, 1)[0]
          );
        } else if (picklist === "region") this.RegionValues = rs;
        else if (picklist === "ville") {
          console.log("start picklist === ville  :");

          this.VilleValues = rs;
          let t = rs.sort(function (a, b) {
            var nameA = a.label.toUpperCase(); // ignore upper and lowercase
            var nameB = b.label.toUpperCase(); // ignore upper and lowercase
            if (nameA < nameB) {
              return -1;
            }
            if (nameA > nameB) {
              return 1;
            }

            // names must be equal
            return 0;
          });

          console.log("t :");
          console.log(t);
        } else if (picklist === "quartier") {
          this.QuartierValues = rs;
          // console.log('this.QuartierValues[0].value : '+ this.QuartierValues[0].value)
          if (this.QuartierValues[0].value == "null") {
            this.isToSpecify = true;
            //  this.template.querySelector(`[data-theid="PrecisionQuartier"]`).value = this.pq;
            this.template.querySelector(`[data-theid="Quartier"]`).placeholder =
              "Aucun élément à selectionner ";
          }
          if (this.QuartierValues.length != 1) {
            this.isToSpecify = false;
            this.template.querySelector(`[data-theid="Quartier"]`).placeholder =
              "sélectionnez un quartier ";
          }
        }
      })
      .catch(error => {
        console.log("error : " + error);
      });

    //console.log('end fetchPicklistValues')
  }

  ChangePrecisionQuartier(event) {
    this.pq = event.detail.value;
    this.omniUpdateDataJson({ PrecisionQuartier: event.detail.value });
  }

  ChangePays(event) {
    console.log("ChangePays");

    this.omniUpdateDataJson({ Pays: event.detail.value });

    let labelSelected = this.PaysValues.find(
      opt => opt.value === event.detail.value
    ).label;

    this.PaysName = labelSelected;

    this.omniUpdateDataJson({ PaysName: labelSelected });

    if (labelSelected == "Maroc") {
      this.showother = true;
      // this.template.querySelector(`[data-theid="Region"]`).style.display =
      //   "block";
      this.template.querySelector(`[data-theid="Ville"]`).style.display =
        "block";

      if (this.template.querySelector(`[data-theid="Quartier"]`) != null)
        this.template.querySelector(`[data-theid="Quartier"]`).style.display =
          "block";
      if (
        this.template.querySelector(`[data-theid="PrecisionQuartier"]`) != null
      )
        this.template.querySelector(
          `[data-theid="PrecisionQuartier"]`
        ).style.display =
          "block";
    } else {
      this.showother = false;
      console.log("in the else");
      this.omniUpdateDataJson({ Region: "null" });
      this.omniUpdateDataJson({ Ville: "null" });
      this.omniUpdateDataJson({ Quartier: "null" });
      this.omniUpdateDataJson({ PrecisionQuartier: "" });
      this.omniUpdateDataJson({ RegionName: "null" });
      this.omniUpdateDataJson({ CityName: "null" });

      // this.RegionValues = [];
      //  this.VilleValues = [];
      this.QuartierValues = [];

      // this.template.querySelector(`[data-theid="Region"]`).value =
      //   "sélectionnez une ville";
      this.template.querySelector(`[data-theid="Ville"]`).value = "";

      //   this.template.querySelector(`[data-theid="Region"]`).placeholder = 'sélectionnez un pays';
      this.template.querySelector(`[data-theid="Ville"]`).placeholder =
        "sélectionnez une ville";

      // this.template.querySelector(`[data-theid="Region"]`).style.display =
      //   "none";
      this.template.querySelector(`[data-theid="Ville"]`).style.display =
        "none";

      if (this.template.querySelector(`[data-theid="Quartier"]`) == null) {
        this.template.querySelector(
          `[data-theid="PrecisionQuartier"]`
        ).style.display =
          "none";
        this.template.querySelector(
          `[data-theid="PrecisionQuartier"]`
        ).value = null;
      } else {
        this.template.querySelector(`[data-theid="Quartier"]`).placeholder =
          "sélectionnez une ville";
        this.template.querySelector(`[data-theid="Quartier"]`).style.display =
          "none";
        this.template.querySelector(`[data-theid="Quartier"]`).value = null;
      }
    }

    //console.log('start changing region values')
    /*
                let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Regions","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Country Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"Pays__c","InterfaceObjectName__c":"InwiB2C_Region__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Regions:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Regions:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Country Name":"' + event.detail.value + '"}}';
        
                this.fetchPicklistValues('region', inp)
        */
    //console.log('end changing region values')
  }

  ChangeRegion(event) {
    //console.log('ChangeRegion')

    this.omniUpdateDataJson({ Region: event.detail.value });
    this.omniUpdateDataJson({ Ville: "null" });
    this.omniUpdateDataJson({ Quartier: "null" });

    this.VilleValues = [];
    this.QuartierValues = [];
    this.template.querySelector(`[data-theid="Ville"]`).placeholder =
      "sélectionnez une ville";
    this.template.querySelector(`[data-theid="Quartier"]`).placeholder =
      "sélectionnez une ville";

    //console.log('start changing Villes values')

    let inp =
      '{"MapItems":[{"DomainObjectFieldAPIName__c":"Villes","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Region Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"InwiB2C_Region__c","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Villes:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Villes:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Region Name":"' +
      event.detail.value +
      '"}}';

    this.fetchPicklistValues("ville", inp);

    //console.log('end changing Villes values')
  }

  setRegionInfo(idVille) {
    let input = '{"theId": "' + idVille + '"}';
    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_getInfoCity",
      options: input,
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        // console.log('in response :')
        //   console.log(response)

        //  //console.log(response.result.IPResult)
        if (response.error == false) {
          let CityInfo = response.result.IPResult.theCity;
          console.log("CityInfo: ");
          console.log(CityInfo);
          this.VilleName = CityInfo.CityName;
          this.RegionName = CityInfo.RegionName;

          // let regionId = response.result.IPResult.theCity.RegionName;
          //console.log('regionId: ' + regionId)
          //  console.log('response.result.IPResult.theCity: ')
          console.log(
            "data-theid:Region.value : " +
            this.template.querySelector(`[data-theid="Region"]`).value
          );
          console.log(
            "response.result.IPResult.theCity.RegionName : " +
            response.result.IPResult.theCity.RegionName
          );

          this.r = response.result.IPResult.theCity.RegionName;
          this.template.querySelector(`[data-theid="Region"]`).value =
            response.result.IPResult.theCity.RegionName;
          this.omniUpdateDataJson({
            Region: response.result.IPResult.theCity.RegionId,
          });

          this.omniUpdateDataJson({
            PaysName: response.result.IPResult.theCity.PaysName,
          });
          this.omniUpdateDataJson({
            RegionName: response.result.IPResult.theCity.RegionName,
          });
          this.omniUpdateDataJson({
            CityName: response.result.IPResult.theCity.CityName,
          });
        }
      })
      .catch(error => {
        console.log("error: " + error);
      });
  }

  ChangeVille(event) {
    //console.log('ChangeVille')
    //console.log('start changing Quartier values')

    let selectedvilleId = event.detail.value;
    console.log("selectedvilleId: " + selectedvilleId);

    this.omniUpdateDataJson({ Ville: selectedvilleId });
    this.omniUpdateDataJson({ Quartier: "null" });
    this.omniUpdateDataJson({ PrecisionQuartier: "" });
    this.omniUpdateDataJson({ RegionName: "null" });
    this.omniUpdateDataJson({ CityName: "null" });

    this.QuartierValues = [];
    //this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';

    this.setRegionInfo(selectedvilleId);
    this.v = selectedvilleId;
    console.log(this.v)

    console.log("selectedvilleId: " + selectedvilleId);
    let inp =
      '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' +
      selectedvilleId +
      '"}}';

    this.fetchPicklistValues("quartier", inp);

    //console.log('end changing Quartier values')
  }

  ChangeQuartier(event) {
    //console.log('ChangeQuartier')
    this.q = event.detail.value;
    this.omniUpdateDataJson({ Quartier: event.detail.value });

    //  //console.log('changing region values')
  }

  // ODE 03/03/2022
  __from;
  @api
  get from() {
    return this.__from;
  }
  set from(value) {
    this.__from = value;
  }

  get isFromChangementTitulaire() {
    return this.__from == "changementtitulaire";
  }

  handleCancel() {
    //Creates the event with the data.
    const selectedEvent = new CustomEvent("addnewaccount", {
      detail: {}
    });

    // Dispatches the event.
    this.dispatchEvent(selectedEvent);
  }
  gotopreviousStep() {
    this.omniPrevStep();

  }

}