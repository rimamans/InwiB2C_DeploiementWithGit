import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import template from "./inwib2c_Transfert_Solde_Paiement.html";


export default class Inwib2c_Transfert_Solde_Paiement extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {
    //
    __saving = false;
    message = "";
    montant = 0;
    dataBancs = {
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

    // API

    __accountnumber;
    @api
    get accountnumber() {
        return this.__accountnumber;
    }
    set accountnumber(value) {
        this.__accountnumber = value;
    }

    __address;
    @api
    get address() {
        return this.__address;
    }
    set address(value) {
        this.__address = value;
    }

    __userprofile;
    @api
    get userprofile() {
        return this.__userprofile;
    }
    set userprofile(value) {
        this.__userprofile = value;
    }

    __accountid;
    @api
    get accountid() {
        return this.__accountid;
    }
    set accountid(value) {
        this.__accountid = value;
    }

    __cin;
    @api
    get cin() {
        return this.__cin;
    }
    set cin(value) {
        this.__cin = value;
    }
    __nom;
    @api
    get nom() {
        return this.__nom;
    }
    set nom(value) {
        this.__nom = value;
    }

    __prenom;
    @api
    get prenom() {
        return this.__prenom;
    }
    set prenom(value) {
        this.__prenom = value;
    }

    __pos;
    @api
    get pos() {
        return this.__pos;
    }
    set pos(value) {
        this.__pos = value;
    }

    __districode;
    @api
    get districode() {
        return this.__districode;
    }
    set districode(value) {
        this.__districode = value;
    }

    handleChange(evt) {
        console.log(evt.target.name, evt.target.value);
        this[evt.target.name] = evt.target.value;
        if (evt.target.name == "codeBanque") {
            this.nomBanque = "";
            for (let key in this.dataBancs) {
                let value = this.dataBancs[key];
                if (evt.target.value == value.toString()) {
                    this.nomBanque = key;
                }
            }

        }
    }
    // Combo Mode de paiement
    selectedModePaiement = 'espece';

    get modesPaiement() {
        return [
            { label: 'Espéce', value: 'espece' },
            { label: 'TPE', value: 'tpe' },
            { label: 'Virement', value: 'virement' },
            { label: 'Chéque', value: 'cheque' },
            { label: 'Vignette', value: 'vignette' },
        ];
    }

    handleSelectModePaiement(event) {
        this.selectedModePaiement = event.detail.value;
    }

    // Paiement espece
    get isEspece() {
        return this.selectedModePaiement == "espece"
    }

    // Paiement TPE
    referencePaiement = "";
    get isTpe() {
        return this.selectedModePaiement == "tpe"
    }


    // Paiement Vignette
    dateBon;
    datevaliditeBon;
    get isVignette() {
        return this.selectedModePaiement == "vignette"
    }

    // Virement Or cheque
    codeBanque = "";
    codeAgence = "";
    numeroCompte = "";
    cle = "";
    nomBanque = "";
    get isVirementOrCheque() {
        return this.selectedModePaiement == "virement" || this.selectedModePaiement == "cheque"
    }

    get isVirement() {
        return this.selectedModePaiement == "virement"
    }

    get isCheque() {
        return this.selectedModePaiement == "cheque"
    }

    // Show validate button
    handleCheckAttribute(value, type) {
        switch (type) {
            case "text":
                return value && value != "";
            case "number":
                return value && value != "" && parseFloat(value) > 0;
            case "date":
                return value && new Date(value) instanceof Date;
            default:
                break;
        }

    }

    //
    checkrib() {
        this.clerib = this.codeBanque +
            this.codeAgence +
            this.numeroCompte +
            "00";
        let i = 0;
        let res = 0;
        for (i = 0; i < this.cle.length; i++) {
            res = (res * 10 + parseInt(this.cle[i])) % 97;
            console.log("this.res" + res);
        }
        console.log("this.keyFinales0" + res);
        this.key = 97 - res;
        console.log("this.keyFinale" + this.key);
        this.keyfinal = "";
        if (this.key.toString().length == 1) {
            this.keyfinal = "0" + this.key.toString();
        } else this.keyfinal = this.key.toString();
        return this.keyfinal == this.cle.toString();
    }

    // Validate
    handleValidate() {
        this.message = "";
        switch (this.selectedModePaiement) {
            case "espece":
                if (!this.handleCheckAttribute(this.montant, "number")) {
                    this.message = "veuillez saisir le montant";
                    break;
                } else this.handleGoToNextStep("CS");
                break;
            case "tpe":
                if (!this.handleCheckAttribute(this.montant, "number")) {
                    this.message = "veuillez saisir le montant";
                    break;
                } else if (!this.handleCheckAttribute(this.referencePaiement, "text")) {
                    this.message = "veuillez saisir la référence de paiement";
                    break;
                } else this.handleGoToNextStep("atm");
                break;
            case "vignette":
                if (!this.handleCheckAttribute(this.montant, "number")) {
                    this.message = "veuillez saisir le montant";
                    break;
                } else if (!this.handleCheckAttribute(this.referencePaiement, "text")) {
                    this.message = "veuillez saisir le numéro de bon";
                    break;
                } else if (!this.handleCheckAttribute(this.dateBon, "date")) {
                    this.message = "veuillez saisir la date du bon";
                    break;
                } else if (!this.handleCheckAttribute(this.datevaliditeBon, "date")) {
                    this.message = "veuillez saisir la date du validité";
                    break;
                } else if (new Date(this.dateBon).getTime() > new Date(this.datevaliditeBon).getTime()) {
                    this.message = "La date de validité doit être supérieure à la date du bon";
                    break;
                } else this.handleGoToNextStep("bnk");
                break;
            case "virement":
                if (!this.handleCheckAttribute(this.codeBanque, "text")) {
                    this.message = "veuillez saisir le code de la banque";
                    break;
                } else if (!this.handleCheckAttribute(this.codeAgence, "text")) {
                    this.message = "veuillez saisir le code de l'agence";
                    break;
                } else if (!this.handleCheckAttribute(this.numeroCompte, "text")) {
                    this.message = "veuillez saisir le numéro de compte";
                    break;
                } else if (!this.handleCheckAttribute(this.cle, "text")) {
                    this.message = "veuillez saisir la clé";
                    break;
                } else if (!this.handleCheckAttribute(this.nomBanque, "text")) {
                    this.message = "Le code de la banque est incorrecte";
                    break;
                } else if (!this.handleCheckAttribute(this.montant, "number")) {
                    this.message = "veuillez saisir le montant";
                    break;
                } else if (!this.handleCheckAttribute(this.referencePaiement, "text")) {
                    this.message = "veuillez saisir le numéro de virement";
                    break;
                } else if (!this.handleCheckAttribute(this.dateBon, "date")) {
                    this.message = "veuillez saisir la date du virement";
                    break;
                } else if (new Date(this.dateBon).getTime() > new Date().getTime()) {
                    this.message = "La date du virement est incorrecte";
                    break;
                } else this.handleGoToNextStep("vir");
                break;
            case "cheque":
                if (!this.handleCheckAttribute(this.codeBanque, "text")) {
                    this.message = "veuillez saisir le code de la banque";
                    break;
                } else if (!this.handleCheckAttribute(this.codeAgence, "text")) {
                    this.message = "veuillez saisir le code de l'agence";
                    break;
                } else if (!this.handleCheckAttribute(this.numeroCompte, "text")) {
                    this.message = "veuillez saisir le numéro de compte";
                    break;
                } else if (!this.handleCheckAttribute(this.cle, "text")) {
                    this.message = "veuillez saisir la clé";
                    break;
                } else if (!this.handleCheckAttribute(this.nomBanque, "text")) {
                    this.message = "Le code de la banque est incorrecte";
                    break;
                } else if (!this.handleCheckAttribute(this.montant, "number")) {
                    this.message = "veuillez saisir le montant";
                    break;
                } else if (!this.handleCheckAttribute(this.referencePaiement, "text")) {
                    this.message = "veuillez saisir le numéro de chéque";
                    break;
                } else if (!this.handleCheckAttribute(this.dateBon, "date")) {
                    this.message = "veuillez saisir la date du chéque";
                    break;
                } else if (new Date(this.dateBon).getTime() > new Date().getTime()) {
                    this.message = "La date du chéque est incorrecte";
                    break;
                } else this.handleGoToNextStep("BC");
                break;
            default:
                break;
        }
    }

    handleGoToNextStep(type) {
        console.log("go to next step");
        this.__saving = true;
        const paymentref = type == "CS" ? "-" : this.referencePaiement;
        const input = `{
            "mode": "`+ type + `",
            "billingAccountID": "`+ this.__accountid + `",
            "bankCode": "`+ this.codeBanque + `",
            "bankCity": "`+ this.codeAgence + `",
            "bankAccount": "`+ this.numeroCompte + `",
            "bankKey": "`+ this.cle + `",
            "bankCheckDueDate": "`+ this.dateBon + `",
            "bankCheckID": "`+ this.referencePaiement + `",
            "freeAmount": "`+ this.montant + `",
            "paymentref": "`+ paymentref + `",
            "nom": "`+ this.__nom + `",
            "prenom": "`+ this.__prenom + `",
            "accountnumber":  "`+ this.__accountnumber + `",
            "pos": "`+ this.pos + `"
        }`;

        console.log(input)

        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "inwib2c_inwiB2C_Create_payement_FreeAmount",
            options: "{}",
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log("paiement response");
                console.log(JSON.stringify(response));
                this.__saving = false;
                // link 
                let url = this.__userprofile == "Inwi POS" ? "../apex/inwiB2C_Recu_Paiement_Lettrage?Nom=" : "/apex/inwiB2C_Recu_Paiement_Lettrage?Nom=";
                let payment = "Espéce";
                [
                    { label: 'Espéce', value: 'espece' },
                    { label: 'TPE', value: 'tpe' },
                    { label: 'Virement', value: 'virement' },
                    { label: 'Chéque', value: 'cheque' },
                    { label: 'Vignette', value: 'vignette' },
                ].map(item => {
                    if (item.value === this.selectedModePaiement) {
                        payment = item.label;
                    }
                });

                // url = url + this.__nom + `&Prenom=` + this.__prenom + `&CIN= &Pays= &Ville= &Quartier=` + this.__address +
                //     `&CodePointDeVente=` + this.districode + `&BillingAccount=` + this.__accountnumber + `&ModeDePaiement=` + payment + `&TotalAmount=` + this.montant + `&CodeAgent=` + this.pos + `&ReferenceDePaiement= &NumeroDeTransaction= `

                // let myData = {
                //     montant_paiement: this.montant,
                //     url
                // };
                // this.omniApplyCallResp(myData);
                // this.omniNextStep();
                if (response.error == false) {
                    if (response.result && response.result.IPResult && response.result.IPResult.status == "1") {
                        let ReferenceDePaiement = "";
                        const paymentData = response.result.IPResult.createPaymentInvoice ? response.result.IPResult.createPaymentInvoice.payment ? response.result.IPResult.createPaymentInvoice.payment : [] : [];
                        if (paymentData.length > 0) {
                            ReferenceDePaiement = paymentData[0].registerReference;
                        }
                        console.log("paymentData");
                        console.log(paymentData);
                        console.log(ReferenceDePaiement);
                        url = url + this.__nom + `&Prenom=` + this.__prenom + `&CIN=` + this.__cin + `&Pays= &Ville= &Quartier=` + this.__address +
                            `&CodePointDeVente=` + this.districode + `&BillingAccount=` + this.__accountnumber + `&ModeDePaiement=` + payment + `&TotalAmount=` + this.montant + `&CodeAgent=` + this.pos + `&ReferenceDePaiement=` + ReferenceDePaiement + `&NumeroDeTransaction= ` + ReferenceDePaiement;
                        let myData = {
                            montant_paiement: this.montant,
                            paiement_mode_paiement: payment,
                            paiement_reference_paiement: ReferenceDePaiement,
                            paiement_cin: this.__cin,
                            url

                        };
                        this.omniApplyCallResp(myData);
                        this.omniNextStep();
                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: response.result.IPResult.result.message,
                                variant: 'error'
                            }),
                        );
                    }

                } else {
                    if (response.result && response.result.IPResult && !response.result.IPResult.success) {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: response.result.IPResult.result ? response.result.IPResult.result.message : response.result.IPResult.error,
                                variant: 'error'
                            }),
                        );
                    } else {
                        let myData = {
                            montant_paiement: this.montant
                        };
                        this.omniApplyCallResp(myData);
                        this.omniNextStep();
                    }
                }
            })
            .catch(error => {
                console.log("showVars_error:: " + error);
            });
    }

    handleBack(evt) {
        if (evt) {
            this.omniPrevStep();
        }
    }

    //
    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }

    render() {
        return template;
    }
}