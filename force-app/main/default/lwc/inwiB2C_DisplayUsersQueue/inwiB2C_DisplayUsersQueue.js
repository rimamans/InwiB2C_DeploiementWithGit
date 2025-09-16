import { LightningElement,wire,api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';


import template from './inwiB2C_DisplayUsersQueue.html';

export default class InwiB2C_DisplayUsersQueue extends OmniscriptBaseMixin(LightningElement) {


    @track selectedUser;
    @track value ;
    @api authusers;
    @api index=0;

    @api userId;




    ChangeUserEvent(event) {
            this.selectedUser = event.detail.label;
            

            let selectedLine = this.authusers.find( x => x.value === event.detail.value );

            //console.log(JSON.stringify(selectedLine));
    
            let selectedUser = { selectedUserId : event.detail.value, 
                                 selectedUserName : selectedLine.label};
    
            this.omniUpdateDataJson(selectedUser);
            this.omniSaveState(selectedUser,true);
    
            
    }
    render() {
        if (this.index == 0){
                this.index=1;
                let selectedLine = this.authusers[0];
        
                let selectedUser = { selectedUserId : selectedLine.value, 
                                     selectedUserName : selectedLine.label};
                
                this.value = this.authusers[0].value;

                this.omniUpdateDataJson(selectedUser);
                this.omniSaveState(selectedUser,true);
        }
            return template;
    }



}