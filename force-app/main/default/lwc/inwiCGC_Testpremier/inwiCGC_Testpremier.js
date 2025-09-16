import { LightningElement, track} from 'lwc';

export default class InwiCGC_Testpremier extends LightningElement {
    @track show = false;

    Open(){
        this.show = true;
    }

    Close(){
        this.show = false;
    }
}