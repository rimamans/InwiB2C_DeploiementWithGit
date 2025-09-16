import { LightningElement,wire,api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';


import template from './inwiB2C_DisplauQueueForProfile.html';

export default class InwiB2C_DisplauQueueForProfile extends OmniscriptBaseMixin(LightningElement) {


    @track selectedQueue;
    @api options;
    @api index=0;

    @api userId;

    @track value ;


    ChangeQueueEvent(event) {

            this.selectedQueue = event.detail.label;
            

            let selectedLine = this.options.find( x => x.value === event.detail.value );

            //console.log(JSON.stringify(selectedLine));
    
            let SelectedQueue = { SelectedQueueId : event.detail.value, 
                                SelectedQueueName : selectedLine.label};
    
            this.omniUpdateDataJson(SelectedQueue);
            this.omniSaveState(SelectedQueue,true);
    
            
    }
    render() {
        if (this.index == 0){
                this.index=1;
                let selectedLine = this.options[0];
        
                let SelectedQueue = { SelectedQueueId : selectedLine.value, 
                                    SelectedQueueName : selectedLine.label};
                
                this.value = this.options[0].value;
        
                this.omniUpdateDataJson(SelectedQueue);
                this.omniSaveState(SelectedQueue,true);
        }

            return template;
    }



}