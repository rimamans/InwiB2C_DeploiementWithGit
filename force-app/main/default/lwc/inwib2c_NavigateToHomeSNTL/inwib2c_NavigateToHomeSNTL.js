import { LightningElement, api} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwib2c_NavigateToHomeSNTL.html';

export default class Inwib2c_NavigateToHomeSNTL extends OmniscriptBaseMixin(NavigationMixin(LightningElement)){


    navigateToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }
 
    render() {
       
        return template;
    }

}