import { LightningElement } from 'lwc';

export default class InwiB2C_ChildPaginator extends LightningElement {
    handlePrevious(event){
        this.dispatchEvent(new CustomEvent('previous'));
    }
    handleNext(event){
        this.dispatchEvent(new CustomEvent('next'));
    }
}