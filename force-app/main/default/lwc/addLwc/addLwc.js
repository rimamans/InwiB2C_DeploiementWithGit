import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class AddLwc extends NavigationMixin(LightningElement){
    @api objectType;
    @api recordId;


    handleClick(){
        console.log(' add instruction');
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.objectType,
                actionName: 'new'
            }
        });
    }



    viewall(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordRelationshipPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Account',
                relationshipApiName: 'InwiB2C_Relation_Affaire__r',
                actionName: 'view'
            },
        });

    }
}