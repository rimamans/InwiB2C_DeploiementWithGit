import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_addCommentCase.html';

export default class InwiB2C_addCommentCase extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    constructor() {
        super();
        var textareaText = "";
    }
     isActive = true;

    @api selcaseid; 

    renderedCallback() {
    }



    navigateToRecordPage(sObject, recordId) {

        console.log('navigateToRecordPage executed');
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });

        console.log('navigateToRecordPage end') ;

    }

    previous() {
        this.omniPrevStep();
    }

    goToRecord() {
        console.log('goToRecord executed') ;
        this.navigateToRecordPage('Case', this.selcaseid.CasesDisplay.IdSelectedCase);
        console.log('goToRecord end') ;

    }

    handleTextareaUpdate(event) {
        if(event.target.value == '') this.isActive= true;
        else this.isActive= false;

        this.textareaText = event.target.value;
    }

    handleAddComment(event) {
        console.log('handleRowAction executed') ;
        let addComm = {
            "add": {
                "body" : this.textareaText,    
                "isPub":false,
                "IdParent":this.selcaseid.CasesDisplay.IdSelectedCase
                }
          };

        this.omniUpdateDataJson(addComm);
        this.omniSaveState(addComm,true);
        this.omniNextStep();

        console.log('handleRowAction end');
    }

    render() {
        return template;
    }

}