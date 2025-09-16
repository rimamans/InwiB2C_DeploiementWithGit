import { LightningElement  , api , track, wire} from 'lwc';

import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getRecord } from 'lightning/uiRecordApi';

export default class InwiB2C_PromoF_F extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

  @track ffNumbers = [];
  @track startDate;
  @track endDate;
  @track allowedAdditions ;
  @track showAddButton = true;
 // @track showModifyButton = true;
  @track errorMsg;
  @track modificationFee;
  @track insufficientBalance = false;
  @track isAdding = false;
  //@track isModifying = false;

  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  @api recordId; 

  fields = ['vlocity_cmt__Subscription__c.Inwib2c_Num_ro_de_la_ligne__c'];

  record;
  error;

  @wire(getRecord, { recordId: "$recordId", fields: '$fields' })
  wiredRecord({ error, data }) {
    if (data) {
      console.log('data ', JSON.stringify(data) )
      this.record = data;
      this.error = undefined;
    } else if (error) {
      console.log('error ', JSON.stringify(error) )
      this.error = error;
      this.record = undefined;
    }
  }

   get mdn() {
    return this.record?.fields?.Inwib2c_Num_ro_de_la_ligne__c?.value;
  }  

  connectedCallback() {
    console.log('mdn ', this.mdn)
    console.log('recordid ', this.recordId)
    console.log('record ', this.record)
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.loadFFNumbers();
  }

  loadFFNumbers() {

    let input = {"mdn":this.mdn}
    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_GetNumPrefere',
      options: '{}'
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        if (response.error == false) {
          console.log(response);

          if (response?.result?.IPResult && response?.result?.IPResult?.status !== "0") {
            console.log(response?.result?.IPResult);
            this.ffNumbers = response.result.IPResult?.friendlyNumbers.map(
              (ff, index) => ({ id: index, number: ff.friendlyNumber, isEditing: false , isAdding : false })
              );
            this.allowedAdditions = response.result.IPResult?.remainingNumbers;
            this.showAddButton = this.allowedAdditions > 0;

            //this.startDate = response.result.IPResult?.startDate;
            this.endDate = this.formatTime(response.result.IPResult?.expireDate);
          }
          else{
            this.dispatchEvent(
              new ShowToastEvent({
                title: 'Erreur',
                message: response?.result?.IPResult?.message || "Une erreur est survenue. Veuillez réessayer.",
                variant: 'error'
              }),
            ); 
          }
        }
      })
      .catch(error => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Erreur',
            message: error,
            variant: 'error'
          }),
        );
        console.log('error ', error);
      });

    /* const mockResponse = {
      error: false,
      ffNumbers: [
        { id: '1', number: '212612345678', isEditing: false },
        { id: '2', number: '212612345679', isEditing: false },
        { id: '3', number: '212612345677', isEditing: false }
      ],
      startDate: '2024-11-01',
      endDate: '2024-12-31',
      allowedAdditions: 6
    };

    if (mockResponse.error) {
      this.errorMsg = 'Erreur. Veuillez réessayer.';
    } else {
      this.ffNumbers = mockResponse.ffNumbers || [];
      this.startDate = mockResponse.startDate;
      this.endDate = mockResponse.endDate;
      this.allowedAdditions = mockResponse.allowedAdditions;
      this.showAddButton = this.allowedAdditions > 0;
    } */
  }

  handleAddFFNumber() {   
    if (this.allowedAdditions > 0 && !this.isAdding) {
      this.isAdding = true
      console.log("id ", this.ffNumbers[this.ffNumbers.length - 1].id + 1)
      this.ffNumbers = [...this.ffNumbers, { id: this.ffNumbers[this.ffNumbers.length - 1].id + 1 , number: '', isEditing: false , isAdding: true }];
    }
  }

  handleSaveFFNumber(event) {
    const selectedIndex = event.target.dataset.index;
    const newFFNumber = this.ffNumbers[selectedIndex].newNumber;
    const oldFFNumber = this.ffNumbers[selectedIndex].number
    if (!this.isValidFFNumber(newFFNumber)) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Erreur',
          message: "Le numéro doit être de 12 caractères et commencer par 2126.",
          variant: 'error'
        }),
      );
      //this.errorMsg = 'Le numéro doit être de 12 caractères et commencer par 2126.';
      return;
    }
    if (this.ffNumbers.every(element => element.number !== newFFNumber) && this.mdn !== newFFNumber){
     //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      let input = { "mdn": this.mdn}
      const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: 'inwib2c_GetCostNumPrefere',
        options: '{}'
      };
      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          if (response.error == false) {
            console.log(response);

            if (response?.result?.IPResult && response?.result?.IPResult?.status !== "0") {
              console.log(response?.result?.IPResult);
              this.modificationFee = response?.result?.IPResult?.montant;
              if (!response?.result?.IPResult.sufficientBalance) {
                this.insufficientBalance = true;
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Solde insuffisant pour modifier le numéro.',
                    variant: 'error'
                  }),
                );
              } else {
                this.insufficientBalance = false;
                const confirmed = confirm(`Frais de modification : ${this.modificationFee}. Confirmez-vous la modification ?`);
                if (confirmed) {
                  
                  let input = { "mdn": this.mdn, "oldmdn": oldFFNumber , "newmdn": newFFNumber }
                  const params = {
                    input: input,
                    sClassName: `${this._ns}IntegrationProcedureService`,
                    sMethodName: 'inwib2c_ModifyNumPrefere',
                    options: '{}'
                  };
                  this._actionUtilClass
                    .executeAction(params, null, this, null, null)
                    .then(response => {
                      if (response.error == false) {
                        console.log(response);

                        if (response?.result?.IPResult && response?.result?.IPResult?.status === "OK") {
                          console.log(response?.result?.IPResult);
                          this.ffNumbers = this.ffNumbers.map((ff, index) =>
                            index == selectedIndex ? { ...ff, number: newFFNumber, isEditing: false } : ff
                          );
                        }
                        else {
                          this.dispatchEvent(
                            new ShowToastEvent({
                              title: 'Erreur',
                              message: response?.result?.IPResult?.message || "Une erreur est survenue. Veuillez réessayer.",
                              variant: 'error'
                            }),
                          );
                        }
                      }
                    })
                    .catch(error => {
                      //this.errorMsg = "Une erreur est survenue. Veuillez réessayer."
                      this.dispatchEvent(
                        new ShowToastEvent({
                          title: 'Erreur',
                          message:  error,
                          variant: 'error'
                        }),
                      );
                      console.log('error');
                      window.console.log(error);
                    });

                  }
              }
              
            }
            else {
              this.dispatchEvent(
                new ShowToastEvent({
                  title: 'Erreur',
                  message: response?.result?.IPResult?.message || "Une erreur est survenue. Veuillez réessayer.",
                  variant: 'error'
                }),
              );
            }
          }
        })
        .catch(error => {
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Erreur',
              message: error,
              variant: 'error'
            }),
          );
          console.log('error');
        });
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    }else{
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Erreur',
          message: 'Le numéro saisi est identique à celui modifié ou déjà existant parmi la liste des numéros préferés.',
          variant: 'error'
        }),
      );
      //this.errorMsg = 'Le numéro saisi est identique à celui modifié ou déjà existant parmi la liste des numéros préferés.' 
    }
  }

  handleModifyFFNumber(event) {
    const selectedIndex = event.target.dataset.index;
    this.ffNumbers[selectedIndex].isEditing = true;

  }

  handleChangeFFNumber(event){
    const selectedIndex = event.target.dataset.index;
    let newNumber = event.target.value
    this.ffNumbers[selectedIndex].newNumber = newNumber ;
  }
  
  isValidFFNumber(number) {
    return number.length === 12 && number.startsWith('2126');
  }

  handleNewFFNumber(event){
    const selectedIndex = event.target.dataset.index;
    const newFFNumber = this.ffNumbers[selectedIndex].newNumber;
    if (!this.isValidFFNumber(newFFNumber)) {
      //this.errorMsg = 'Le numéro doit être de 12 caractères et commencer par 2126.';
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Erreur',
          message: 'Le numéro doit être de 12 caractères et commencer par 2126.',
          variant: 'error'
        }),
      );
      return;
    }
    if (this.ffNumbers.every(element => element.number !== newFFNumber) && this.mdn != newFFNumber) {
      const confirmed = confirm(`Le Mdn : ${newFFNumber} sera ajouter. Confirmez-vous l'ajout ?`);
      if (confirmed) {
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        let input = { "mdn": this.mdn, "newmdn": newFFNumber }
      const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: 'inwib2c_AddNumPrefere',
        options: '{}'
      };
      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          if (response.error == false) {
            console.log(response);

            if (response?.result?.IPResult && response?.result?.IPResult?.status === "OK") {
              console.log(response?.result?.IPResult);
              this.ffNumbers = this.ffNumbers.map((ff, index) =>
                index == selectedIndex ? { ...ff, number: newFFNumber, isEditing: false, isAdding: false } : ff
              );
              this.isAdding = false
              this.allowedAdditions -= 1;
              this.showAddButton = this.allowedAdditions > 0;
              this.dispatchEvent(
                new ShowToastEvent({
                  title: 'Success',
                  message: response?.result?.IPResult?.message || "Opération effectué avec succès",
                  variant: 'success'
                }),
              );

            }
            else {
              this.dispatchEvent(
                new ShowToastEvent({
                  title: 'Erreur',
                  message: response?.result?.IPResult?.message || "Une erreur est survenue. Veuillez réessayer.",
                  variant: 'error'
                }),
              );
            }
          }
        })
        .catch(error => {
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Erreur',
              message: error,
              variant: 'error'
            }),
          );
          console.log('error');
        });

        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     }
     
    } else {
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Erreur',
          message: "Le numéro saisi est déjà existant parmi la liste des numéros préferés.",
          variant: 'error'
        }),
      );
      //this.errorMsg = 'Le numéro saisi est déjà existant parmi la liste des numéros préferés.'
    }

  }

  formatTime(dateTimeString) {

    const year = dateTimeString.substring(0, 4);
    const month = dateTimeString.substring(4, 6);
    const day = dateTimeString.substring(6, 8);
    const hours = dateTimeString.substring(8, 10);
    const minutes = dateTimeString.substring(10, 12);

    // Format the date and time as "DD/MM/YYYY HH:mm"
    const formattedDateTime = `${day}/${month}/${year} ${hours}:${minutes}`;

    console.log(formattedDateTime);
    return formattedDateTime
  }

  closeError() {
    this.errorMsg = '';
  }
}