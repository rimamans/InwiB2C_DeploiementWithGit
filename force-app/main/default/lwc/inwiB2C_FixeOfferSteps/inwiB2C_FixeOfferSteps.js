import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from "./inwiB2C_FixeOfferSteps.html";

export default class InwiB2C_FixeOfferSteps extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    parentSteps =[];
    __steps = [];
    stepOk=true;
    @api
    get steps() {
        return this.__steps;
    }

    set steps(value) {
        this.__steps = value;
    }
    render() {
        return template;
    }
    manageSteps(){
        if(this.__steps){
        let stepsTmp = JSON.parse(JSON.stringify(this.__steps));
        stepsTmp.forEach(function(step) {
            //set parent step status
            if(step.statut == 'Active'){
                step.isActive = true;
                step.class = 'slds-progress__item slds-is-active';
                if(step.showSubSteps == 'true')
                    step.expand=true;
                //get subSteps 
                if(step.showSubSteps == 'true'){
                step.subSteps.forEach(function(substep) {
                    if(substep.statut == 'Active'){
                        substep.isActive = true;
                        substep.class = 'slds-progress__item slds-is-active';
                    }
                    else if (substep.statut == 'Complete'){
                        substep.isComplete = true;
                        substep.class = 'slds-progress__item slds-is-completed';
                    }
                    else if (substep.statut == 'NotActive'){
                        substep.isNotActive = true;
                        substep.class = 'slds-progress__item';
                    }
                    else if(substep.statut == 'Error'){
                        substep.isError = true;
                        substep.class = 'slds-progress__item slds-has-error';
                    }
                });
            }
            }
            else if (step.statut == 'Complete'){
                step.isComplete = true;
                step.expand=false;
                step.class = ' slds-progress__item slds-is-completed';
            }
            else if (step.statut == 'NotActive'){
                step.isNotActive = true;
                step.expand=false;
                step.class = 'slds-progress__item';
            }
            else if(step.statut == 'Error'){
                step.isError = true;
                step.expand=false;
                step.class = 'slds-progress__item slds-has-error';
            }
            
            step.seeMore=false;
          });
          this.parentSteps=stepsTmp;
        }
        else{
            this.stepOk=false;
        }
          }

    
    showSubSteps(event){
        let subSteps = JSON.parse(JSON.stringify(this.parentSteps));
        const stepCode = event.currentTarget.dataset.id
        let objIndex = subSteps.findIndex((obj => obj.code === stepCode));
        if(subSteps[objIndex].seeMore==false)
            subSteps[objIndex].seeMore=true;
        else
            subSteps[objIndex].seeMore=false;
        this.parentSteps=subSteps;

    }
    connectedCallback(){
        this.manageSteps();
    }

    
    }