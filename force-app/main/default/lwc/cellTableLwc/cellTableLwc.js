import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CellTableLwc extends NavigationMixin(LightningElement){
    
    @api field;
    @api index;
    @api element;
    @api viewDetails;
    @api objectType;
    @api islistTableNiv = false;

    isLink;

    url;

    renderedCallback() {
        
        if(this.index === 0 && this.viewDetails)
            this.isLink = true;
        else{
            this.isLink = false;
        }    
        console.log('<<<<<< is link ',this.isLink);
        this.pageRef = {
            type: 'standard__recordPage',
            attributes: {
                recordId: this.element.Id,
                objectApiName: this.objectType,
                actionName: 'view'
            }
        };
        this[NavigationMixin.GenerateUrl](this.pageRef)
            .then(url => this.url = url);
    }

    handleClick(evt){
        // Stop the event's default behavior.
        // Stop the event from bubbling up in the DOM.
        evt.preventDefault();
        evt.stopPropagation();
        // Navigate to the Account Home page.
        this[NavigationMixin.Navigate](this.pageRef);
    }
}