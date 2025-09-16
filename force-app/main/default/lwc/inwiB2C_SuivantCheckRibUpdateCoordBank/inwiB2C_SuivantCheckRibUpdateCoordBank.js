import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { createRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwiB2C_SuivantCheckRibUpdateCoordBank.html";

export default class inwiB2C_SuivantCheckRibUpdateCoordBank extends OmniscriptBaseMixin(
  LightningElement
) {
  code;
  __codebank;
  __key;
  codebq;
  __nombanque;
  @api
  get codebank() {
    return this.__codebank;
  }
  set codebank(value) {
    this.__codebank = value;
  }
  @api
  get nombanque() {
    return this.__nombanque;
  }
  set nombanque(value) {
    this.__nombanque = value;
  }

  handleChangeInput(event) {
    console.log("Codebanqueee" + this.codebank)
    console.log("nombanque" + this.nombanque)
    if (event.target.name == "codebank") {

      this.template.querySelector(`[data-theid="nombanque"]`).value = "";
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
        "Union Marocaine De Banques": "005"
      };
      for (let key in obj) {
        let value = obj[key];
        // console.log(key, value);
        // console.log("banquename" +value);

        if (event.target.value == value.toString()) {
          this.nombanque = key;
          this.template.querySelector(`[data-theid="nombanque"]`).value = key;
        }
      }
    }
    this[event.target.name] = event.target.value;

    this.omniUpdateDataJson({ "codebanqueLWC": this.codebank });
    this.omniUpdateDataJson({ "nombanqueLWC": this.nombanque });
 

  }

  __labelstep;
  @api
  get labelstep() {
    return this.__labelstep;
  }
  set labelstep(value) {
    this.__labelstep = value;
  }
  __comptebanquenum;
  __modeselected;
  __key;
  haserror = false;
  messageblacklist;
  errormessage = '';
  __post;
  __part1;
  __part2;
  __mod = 97;
  __keyfinal;
  __codebq;
  __code;
  __clecompte;
  __codebanque;
  __codeguichet;
  __nomagence;
  __int ="00";
  __res=0;
  __clerib;
  _ns = getNamespaceDotNotation();
  @api
  get comptebanquenum() {

    return this.__comptebanquenum;
  }
  set comptebanquenum(value) {
    this.__comptebanquenum = value;
  }

  @api
  get modeselected() {

    return this.__modeselected;
  }
  set modeselected(value) {
    this.__modeselected = value;
  }

  get checkmode() {
    return this.__modeselected == "Prélèvement automatique (RIB)"
  }
  @api
  get clecompte() {

    return this.__clecompte;
  }
  set clecompte(value) {
    this.__clecompte = value;
  }


  @api
  get codebanque() {

    return this.__codebanque;
  }
  set codebanque(value) {
    this.__codebanque = value;
  }


  @api
  get codeguichet() {

    return this.__codeguichet;
  }
  set codeguichet(value) {
    this.__codeguichet = value;
  }
  @api
  get nomagence() {

    return this.__nomagence;
  }
  set nomagence(value) {
    this.__nomagence = value;
  }


  checkblacklistclient() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();

    let input =
      `{
    "rib": "` +
      this.codebank +
      this.codeguichet +
      this.comptebanquenum +
      this.clecompte +
      `"
     }`;

    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_Blacklist_RIB",
      options: "{}",
    };
    console.log("VIP");
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log("response VIP 250", response);
        //!response.result && !response.result.IPResult &&
        console.log("response.result.Ipresult" + response.result.IPResult.isblacklist);

        const responsevip = response.result.IPResult.isblacklist;
        console.log("responsevip" + response.result.IPResult.isblacklist);


        console.log("responsevip" + responsevip);

        return response.result.IPResult.isblacklist;
      })

      .catch(error => {
        console.log("error");
        window.console.log(error);
      });
  }



  checkrib() {
    console.log("this.comptebanquenum.", this.comptebanquenum);
  //  console.log("this.clecompte.", this.clecompte);

   /* this.post = parseInt(this.comptebanquenum.substring(0, 4));
    this.part1 = parseInt(this.comptebanquenum.substring(4, 10));
    this.part2 = parseInt(this.comptebanquenum.substring(10, 16));

    console.log("this.key1", this.key);
    this.key = parseInt(this.key);
    console.log("this.cons", this.key);

    this.codebq = parseFloat(this.comptebanquenum);
    this.key = this.codebq % this.__mod;
    console.log("this.key", this.key);
    this.key = (this.key * 1000 + this.post) % this.__mod;
    this.key = (this.key * 10000 + this.part1) % this.__mod;
    this.key = (this.key * 1000000 + this.part1) % this.__mod;
    this.key = (this.key * 1000000 + this.part2) % this.__mod;
    this.key = (this.key * 100) % this.__mod;

   // this.key = parseInt(this.__mod - parseInt(this.key));*/
   console.log("this.int", this.__int);
   console.log("this.this.Codebanque", this.codebank);
   console.log("this.Codeguichet", this.codeguichet);
   console.log("this.ComptebanqueNum", this.comptebanquenum);
   console.log("this.this.__mod", this.__mod);
   console.log("this.clecompte", this.clecompte);

 this.clerib= this.codebank +
 this.codeguichet +
 this.comptebanquenum +
  this.__int ;

  console.log("this.clerib ", this.clerib);
  let i = 0;
  let res = 0;
   // this.keyfinal = this.modulo( this.clerib, this.__mod);
   for ( i=0; i<this.clerib.length ; i++)
   {
     res = (res*10+
       parseInt(this.clerib[i])) % 97;
       console.log("this.res" +res);

   }
     console.log("this.keyFinales0" +res);

  this.key =this.__mod-res;
  console.log("this.keyFinale" +this.key);
  console.log("this.keyFinales1" +this.keyfinal);
    console.log("this.key ", this.key);
    this.keyfinal = "";
    if (this.key.toString().length == 1) {
      this.keyfinal = "0" + this.key.toString();
    }
    else {

      this.keyfinal = this.key.toString();

    }
    console.log("keyFinal" + this.key.toString());
    return this.keyfinal == this.clecompte.toString();
  }

  gotonextStep() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    console.log(" this.checkrib(): " + this.checkrib());
    console.log(" Blacklistingresponsevip(): " + this.checkblacklistclient());
    this.omniUpdateDataJson({ "codeguichetLWC": this.codeguichet });
    this.omniUpdateDataJson({ "numdecompteLWC": this.comptebanquenum });
    this.omniUpdateDataJson({ "cleLWC": this.clecompte });
    this.omniUpdateDataJson({ "nomagenceLWC": this.nomagence });
    if (!this.checkrib()) {
      this.haserror = true;
      this.errormessage = "RIB invalide";

    } else {
      let input =
        `{
    "rib": "` +
        this.codebank +
        this.codeguichet +
        this.comptebanquenum +
        this.clecompte +
        `"
     }`;

      const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_Blacklist_RIB",
        options: "{}",
      };
      console.log("VIP");
      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          console.log("response VIP 294", response);
          const responsevip = response.result.IPResult.isblacklist;
          console.log("responsevip" + responsevip);
          if (responsevip) {
            this.haserror = true;
            this.errormessage = "RIB Blacklisté";
          } else {
            console.log("rib valide" + this.modeselected);
            this.haserror = false;
            this.errormessage = "";
            this.omniNextStep();
          }
        })
        .catch(error => {
          console.log("error");
          window.console.log(error);
        });
    }
  }
  
  nextStep() {
    console.log("mode de paiement")

    this.haserror = false;
    this.omniNextStep();
  }

  prevStep() {
    

    this.haserror = false;
    this.omniPrevStep();
  }


  render() {
    return template;
  }
  connectedCallback() { }


}