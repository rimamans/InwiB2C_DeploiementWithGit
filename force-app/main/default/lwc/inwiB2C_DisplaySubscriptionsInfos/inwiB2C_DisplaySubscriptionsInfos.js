import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import template from './inwiB2C_DisplaySubscriptionsInfos.html';

export default class inwiB2C_DisplaySubscriptionsInfos extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    constructor() {
        super();
        var DateLock = '';
        var Status = 0;
       // var BlockCounter  = 0;

    }

    _actionUtilClass;
    _ns = getNamespaceDotNotation();

    @api datelock; 
    @api rechargestatus; 
    @api blockcounter;
    @api mdn;

    @api isBlocked = false;
    @api isCounter3 = false;
    
    renderedCallback() {

    }
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }



    render() {
        if (this.blockcounter == 2 || this.blockcounter == 1)
            this.isBlocked = true;
        if (this.blockcounter == 3)
        {
            this.isBlocked = false;
            this.isCounter3 = true;}

        if (this.datelock != '' && this.datelock.includes("-")){

        //Format expiration date  
        this.year        = this.datelock.toString().substring(0,4);
        this.month       = this.datelock.toString().substring(5,7);
        this.day         = this.datelock.toString().substring(8,10);
        this.hour        = this.datelock.toString().substring(11,19);
        this.datelock = this.day.concat("/", this.month,"/", this.year,"  ", this.hour);

            //this.scratchcarddatefin = new Date(this.year, this.month, this.day);
            //console.log('here   ' + this.scratchcarddatefin.substring(0,4))
            }

        return template;
    }
   

}