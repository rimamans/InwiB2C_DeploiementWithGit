import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_ShowMapFTTHPropre extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    _ns = getNamespaceDotNotation();
    
    __latitude; 
    @api 
    get latitude() {
        return this.__latitude
    }
    set latitude(val) {
        this.__latitude = val;
    }

    __longitude;
    @api 
    get longitude() {
        return this.__longitude
    }
    set longitude(val) {
        this.__longitude = val;
    }

    __showMap = false;
    __mapUrl = '';

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log("latitude : ", this.__latitude);
        console.log("longitude : ", this.__longitude);
        // console.log("showMap : ", this.__showMap)
        this.__mapUrl = 'https://www.google.com/maps' + 
            '?q=' + this.__latitude +
            ',' + this.__longitude;

    }

    // showMapWithGpsCoordinates() {
    //     this.__mapUrl = 'https://www.google.com/maps' + 
    //         '?q=' + this.__latitude +
    //         ',' + this.__longitude;
    //     this.__showMap = true
    //     console.log("url : ", mapUrl);
    // }

    // hideMapWithGpsCoordinates() {
    //     this.__showMap = false;
    // }

}