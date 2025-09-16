/** 
 * Sujet: MGEN3727B Besoin Identification MDM_TRE_Data_Reporting_V1.0
 * author : khaoula kanboua
 * last modify by : Khaoula kanboua  19/06/2025
 
*/
import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

// Composant LWC pour vérifier l'existence d'une souscription et d'un contrat
export default class VerifySubscriptionLwc extends OmniscriptBaseMixin(LightningElement) {
    @track mdn = '';
    @track status = '';
    @track message = '';
    @track contractId = '';
    @track contractStatut = '';
    @track subId = '';

    _actionUtil; 
    __businessreference; 

    @api
    get businessreference() {
        return this.__businessreference;
    }
    set businessreference(value) {
        this.__businessreference = value;
    }

    connectedCallback() {
        this._actionUtil = new OmniscriptActionCommonUtil();
    }

    //Permet de gèrer la saisie du mdn
    handleInputChange(event) {
        const inputElement = event.target;
        const inputValue = inputElement.value;

        this.mdn = inputValue;

        // Vérification de mdn 
        if (inputValue.length !== 12 || isNaN(inputValue) || !inputValue.startsWith("212")) {
            inputElement.setCustomValidity("Le numéro doit contenir exactement 12 chiffres et commencer par 212.");
        } else {
            inputElement.setCustomValidity("");
        }

        inputElement.reportValidity();
    }

    // méthode pour vérification du mdn
    handleVerify() {
        const mdnInput = this.template.querySelector('lightning-input');

        //Validation de champ mdn
        if (!mdnInput.checkValidity()) {
            mdnInput.reportValidity();
            this.dispatchEvent(new ShowToastEvent({
                title: 'Numéro invalide',
                message: 'Le numéro doit contenir exactement 12 chiffres et commencer par 212.',
                variant: 'error',
                mode: 'dismissable'
            }));
            return;
        }

        const mdn = this.mdn;

        
        if (!mdn) {
            this.status = 'ERROR';
            this.message = 'Le numéro de téléphone est vide.';
            return;
        }

        // Appeler la classe Apex
        const params = {
            input: JSON.stringify({ mdn: this.mdn, reference: this.__businessreference }),
            sClassName: 'InwiB2C_TraitementRejetIdentificationMRE',
            sMethodName: 'verifyResiliatedSubscription',
            options: '{}'
        };

        
        this._actionUtil.executeAction(params, null, this, null, null)
            .then(response => {
                console.log('Réponse complète Apex:', response);
                const res = response?.result?.result;

                
                if (res?.status === 'ERROR') {
                    let msg = res.message || 'Erreur inconnue.';
                    let title = 'Erreur';

                    // Le cas ou aucune souscription ni contrat trouvés
                    if (msg.includes('Aucune souscription ni contrat')) {
                        title = 'Erreur';
                    }

                    this.dispatchEvent(new ShowToastEvent({
                        title: title,
                        message: msg,
                        variant: 'error'
                    }));
                    return;
                }

                // Le cas ou tous est bon
                if (res?.status === 'OK') {
                    if (res?.contractId && res?.contractStatut) {
                        // Souscription et contrat trouvés
                        this.contractId = res.contractId;
                        this.contractStatut = res.contractStatut;
                        this.FromResiliatedSub = res.FromResiliatedSub ;
                        this.omniApplyCallResp({
                            contractId: res.contractId,
                        });
                        this.omniNextStep();
                    } else if (res?.acc){
                        this.acc = res.acc;
                        this.FromResiliatedSub = res.FromResiliatedSub ;

                          this.omniApplyCallResp({
                            acc: res.acc,
                        });
                        this.omniNextStep();
                    }
                    else {
                        // Souscription trouvée mais aucun contrat associé
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Erreur',
                            message: res.message || 'Aucun contrat associé à la souscription.',
                            variant: 'error'
                        }));
                    }
                } else {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Réponse inattendue du serveur.',
                        variant: 'error'
                    }));
                }
            })
            .catch(error => {
                // Permet de gérer les errors de apex
                this.status = 'ERROR';
                this.message = 'Erreur : ' + JSON.stringify(error);
                console.error('Erreur Apex:', error);

                this.dispatchEvent(new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Une erreur est survenue lors de la vérification.',
                    variant: 'error'
                }));
            });
    }
}