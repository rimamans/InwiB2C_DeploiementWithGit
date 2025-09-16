import { LightningElement, track } from 'lwc';

export default class InwiCGC_Test2 extends LightningElement {
    @track Show = false;

    Open(){
        this.Show = true;
    }
}