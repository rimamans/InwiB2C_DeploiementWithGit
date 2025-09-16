import { LightningElement, api } from 'lwc';
import pubsub from 'vlocity_cmt/pubsub';

export default class InwiAuraPubsub extends LightningElement {


    /*@api
    registerListener(eventName) {
        pubsub.registerListener(eventName, {
            data: this.handleOmniAction.bind(this),
        });
    }

    @api
    unregisterListener(eventName, callback) {
        unregisterListener(eventName, callback, this);
    }

    @api
    unregisterAllListeners() {
        unregisterAllListeners(this);
    }

    @api
    fireEvent(eventName, data) {
        fireEvent(this.pageRef, eventName, data);
    }*/
    @api
    interaction;
    @api
    ctiIteractionNumber;
    @api
    ctiSource;
    @api
    ctiEmailSource;
    @api
    ctiFacebookId;
    @api
    ctiTwitterId;
    @api
    ctiMDN;

    handleVlocityInteractionMessage(data){
        console.log(data);
        
        if (data.value && data.value.interaction){
            this.interaction = data.value.interaction;
            const valueChangeEvent = new CustomEvent("interactionChange", {
                detail: { "interaction" : this.interaction}
                });
              // Fire the custom event
            this.dispatchEvent(valueChangeEvent);
        }
       
    }

    connectedCallback() {
        pubsub.register("Notify", {
            interactionChange: this.handleVlocityInteractionMessage.bind(this),
        });

        pubsub.register("ReceiveInteractionNumber", {
            getInteractionNumber: this.handleVlocityInteractionRequestMessage.bind(this),
        });
    }

    handleVlocityInteractionRequestMessage(event){

        console.log('received message');

        /*const interaction = "12323452345234";
        const valueChangeEvent = new CustomEvent("interactionChange", {
            detail: { "interaction" : interaction}
            });


            // Fire the custom event
        this.dispatchEvent(valueChangeEvent);*/

        pubsub.fire("ReceiveInteractionNumber", "returnInteractionNumber", {
            name: "ReceiveInteractionNumber",
            value: {
                interaction: this.interaction,
                ctiIteractionNumber : this.ctiIteractionNumber,
                ctiSource: this.ctiSource,
                ctiEmailSource : this.ctiEmailSource,
                ctiFacebookId : this.ctiFacebookId,
                ctiTwitterId: this.ctiTwitterId,
                ctiMDN : this.ctiMDN
            }
        });

    }

    handleClick(event){

        console.log('publish 1');

        /*const interaction = "12323452345234";
        const valueChangeEvent = new CustomEvent("interactionChange", {
            detail: { "interaction" : interaction}
            });


            // Fire the custom event
        this.dispatchEvent(valueChangeEvent);*/

        pubsub.fire("ReceiveInteractionNumber", "returnInteractionNumber", {
            name: "ReceiveInteractionNumber",
            value: {interaction: this.interaction}
        });

    }
}