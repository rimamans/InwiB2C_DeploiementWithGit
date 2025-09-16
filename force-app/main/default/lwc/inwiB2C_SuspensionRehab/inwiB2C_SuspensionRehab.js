import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_SuspensionRehab extends OmniscriptBaseMixin(LightningElement) {


    __item;
    __suspentionType;
    __suspentionTypeLabel
    __Motif;
    __MotifLabel;
    /**Fraude 05/07/24 Ila Start */
    __allowsusproaming;
    __passfraude;
    /**Fraude 05/07/24 Ila End */
    __appelEntrantAttributeCategoriesId;
    __appelEntrantProductAttributesId;

    __appelSortantAttributeCategoriesId;
    __appelSortantProductAttributesId;
    
        
    __restDataAttributeCategoriesId;
    __restDataProductAttributesId;

    __offreName;

    __isNext = false;
    __userProfile;
    __segmentOffer;
    __productOffer;
    @track optionsMotif = [];
    @track verifDisabled = true;


    /**Fraude 05/07/24 Ila Start */
    @api
    set allowsusproaming(value){
        this.__allowsusproaming = value;
    }
    get allowsusproaming(){
        return this.__allowsusproaming;
    }
    @api 
    set passfraude(value){
        this.__passfraude= value;
    }
    get passfraude (){
        return this.__passfraude;

    }
    /**Fraude 05/07/24 Ila End */ 
    @api 
    set item(value){
        this.__item = {...value};
    }
    get item (){
        return this.__item;

    }
    get Motif (){
        return this.__Motif;

    }
    @api
    set userProfile (value){

        this.__userProfile = value;

    }
    get userProfile (){
        return this.__userProfile;
    }
    @api
    set segmentOffer (value){

        this.__segmentOffer = value;

    }
    get segmentOffer (){
        return this.__segmentOffer;
    }
    @api
    set productoffer(value){

        this.__productOffer = value;

    }
    get productoffer (){
        return this.__productOffer;
    }
    


    connectedCallback(){   
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.__offreName= this.item.ProductCode;
        console.log('productofferSusp '+this.__productOffer);
        console.log('this.__passfraude '+this.__passfraude);

      
    }
    get disableSoumettre(){
        return this.Motif == null;
    }


    get suspentionType(){

        let attributeCategories = this.__item.attributeCategories;


        if (attributeCategories.records){

            attributeCategories.records.forEach ((attributeCategory, index1) => {
                //console.log("index1:" + index1)

                let productAttributes = attributeCategory.productAttributes.records;

                if (productAttributes) {

                    productAttributes.forEach((productAttribute, index2) => {
                        //console.log("index2:" + index2)

                        //console.log(productAttribute.code);

                        if (productAttribute.code.includes("INWIB2C_ATT_RT_APPELS_ENRTANT")){
                            
                            this.__appelEntrantAttributeCategoriesId = index1;
                            this.__appelEntrantProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_APPELS_SORTANT'){
                            
                            this.__appelSortantAttributeCategoriesId = index1;
                            this.__appelSortantProductAttributesId = index2;
                        }

                        if (productAttribute.code.includes("INWIB2C_ATT_RT_RESTDATA")) {
                            this.__restDataAttributeCategoriesId = index1;
                            this.__restDataProductAttributesId = index2;
                        }
 
 

                    });
                }else {
                    return 'NORMAL';
                }
             });

             //console.log(this.__mdnAttributeCategoriesId + ' ' + this.__mdnProductAttributesId);

        }
        return this.__suspentionType;
    }

    set suspentionType(value){

        this.__suspentionType = value;
    }


    get options(){

        if(this.__productOffer == "Data"){
            if(this.__offreName.includes("INWIB2C_OFFERING_PACK_INTERNET_DEPANNAGE") || this.__offreName.includes("INWIB2C_OFFERING_FORMULE1_199DH") || this.__offreName.includes("INWIB2C_OFFERING_FORMULE2_249DH") || this.__offreName.includes("INWIB2C_OFFERING_FORMULE3_349DH") || this.__offreName.includes("INWIB2C_OFFERING_FORFAIT_30GO199DH") || this.__offreName.includes("INWIB2C_OFFERING_FORFAIT_15GO99DH") || this.__offreName.includes("INWIB2C_OFFERING_FORFAIT_60GO399DH") || this.__offreName.includes("INWIB2C_OFFERING_FORFAIT_6GO49DH") || this.__offreName.includes("INWIB2C_OFFERING_FORFAIT_20GO149DH") || (this.__userProfile.includes("POS") && this.__segmentOffer == "InwiB2C_Postpaye"  && !this.__offreName.includes("INWIB2C_OFFERING_CAM") ) || (this.__userProfile.includes("Fraude Int") && this.__segmentOffer == "InwiB2C_Postpaye" ))
            return [
                { label: 'Total', value: 'C' }
            ];
        }
        else {
            /**Fraude 05/07/24 Ila Start */
            //if( this.__offreName.includes("INWIB2C_OFFERING_FTTH200MG3MOIS_449DH") || this.__offreName.includes("INWIB2C_OFFERING_FTTH") || this.__offreName.includes("INWIB2C_OFFERING_FORMULE1_199DH") || this.__offreName.includes("INWIB2C_OFFERING_FORMULE2_249DH") || this.__offreName.includes("INWIB2C_OFFERING_FORMULE3_349DH") || this.__offreName.includes("INWIB2C_OFFERING_HOME_HuaweiB310S4G20GO") || this.__offreName.includes("INWIB2C_OFFERING_HOME_BOXZTE4G20G") || this.__offreName.includes("INWIB2C_OFFERING_HOME_PACKMODEM4G10Go") || this.__offreName.includes("INWIB2C_OFFERING_HOME_PACKMYWIFI4G10Go") || this.__offreName.includes("INWIB2C_OFFERING_HOME_SIM4G5Go") || (this.__userProfile.includes("POS") && this.__segmentOffer == "InwiB2C_Postpaye" && !this.__offreName.includes("INWIB2C_OFFERING_CAM") ) || (this.__userProfile.includes("Fraude Int") && this.__segmentOffer == "InwiB2C_Postpaye" ))
            if( this.__offreName.includes("INWIB2C_OFFERING_FTTH200MG3MOIS_449DH") || this.__offreName.includes("INWIB2C_OFFERING_FTTH") || this.__offreName.includes("INWIB2C_OFFERING_FORMULE1_199DH") || this.__offreName.includes("INWIB2C_OFFERING_FORMULE2_249DH") || this.__offreName.includes("INWIB2C_OFFERING_FORMULE3_349DH") || this.__offreName.includes("INWIB2C_OFFERING_HOME_HuaweiB310S4G20GO") || this.__offreName.includes("INWIB2C_OFFERING_HOME_BOXZTE4G20G") || this.__offreName.includes("INWIB2C_OFFERING_HOME_PACKMODEM4G10Go") || this.__offreName.includes("INWIB2C_OFFERING_HOME_PACKMYWIFI4G10Go") || this.__offreName.includes("INWIB2C_OFFERING_HOME_SIM4G5Go") || (this.__userProfile.includes("POS") && this.__segmentOffer == "InwiB2C_Postpaye" && !this.__offreName.includes("INWIB2C_OFFERING_CAM") ) || (this.__userProfile.includes("Fraude Int") && this.__passfraude == "true" ))
            /**Fraude 05/07/24 Ila Start */
                return [
                { label: 'Total', value: 'C' }
            ];
            else if((this.__userProfile.includes("Recouv") || this.__userProfile.includes("recouvrement")) && this.__segmentOffer == "InwiB2C_Postpaye" ) 
                return[   
                    { label: 'Appels sortants', value: 'A' },
                    { label: 'Total', value: 'C' }
                ];
            else{
                /**Fraude 05/07/24 Ila Start */
                if(this.__userProfile.includes("Fraude Int")){
                    if(this.__allowsusproaming=="true"){
                        return [
                            { label: 'Appels sortants', value: 'A' },
                            { label: 'Appels entrants', value: 'D' },
                            { label: 'International', value: 'B' },
                            { label: 'Roaming DATA', value: 'E' },
                            { label: 'Total', value: 'C' }
                            ];
                    }
                    else{
                        return [
                            { label: 'Appels sortants', value: 'A' },
                            { label: 'Appels entrants', value: 'D' },
                            { label: 'International', value: 'B' },
                            { label: 'Total', value: 'C' }
                            ];
                    }
                }
                else
                /**Fraude 05/07/24 Ila End */
                    return [
                        { label: 'Appels sortants', value: 'A' },
                        { label: 'International', value: 'B' },
                        { label: 'Total', value: 'C' }
                        ];
            }
        }
    }
    
    
   /* get optionsMotif(){
        return [
            { label: 'Fraude', value: 'FR' },
            { label: 'Perte / Vol', value: 'PV' }
        ];

    }*/

    handleChangeDropDown(event) {
        console.log('drop dow value');
        this.__suspentionType = event.detail.value;
        this.__suspentionTypeLabel = event.target.options.find(opt => opt.value === event.detail.value).label;
        let dependValues = [];

        if(this.__suspentionType) {

         
            if(this.__userProfile.includes("Fraude Int")) {
                dependValues = [{ label: 'Fraude', value: 'FR' },
                                /**Fraude 05/07/24 Ila Start */
                                //{ label: 'Perte / Vol', value: 'PV' },
                                /**Fraude 05/07/24 Ila End */
                                { label: 'Préserver', value: 'PR' },
                                { label: 'Usage Indu', value: 'UI' },
                                /**Fraude 05/07/24 Ila Start */
                                { label: 'Usage indu PSP', value: 'UIP' },
                                { label: 'Préserver PSP', value: 'PP' },
                                { label: 'Usage indu PREP', value: 'UIPREP' },
                                { label: 'Préserver PREP', value: 'PPREP' }
                                /**Fraude 05/07/24 Ila End */
                            ];
            }
            else if((this.__userProfile.includes("Recouv") || this.__userProfile.includes("recouvrement")) && this.__segmentOffer == "InwiB2C_Postpaye" ) {
                    if(this.__suspentionType =='A'){
                        dependValues = [{ label: 'Manque de paiement', value: 'MP' },                    
                        { label: 'Restriction-recouvrement', value: 'RR' }];
                    }
                    else  if(this.__suspentionType == 'C'){
                        dependValues = [{ label: 'Manque de paiement', value: 'MP' }																				                
                        // ,{ label: 'Suspension-recouvrement', value: 'SR' }
             								];}
                
                }
                else{
                    dependValues = [
                        { label: 'Perte / Vol', value: 'PV' }];
                }
           /* if(this.__suspentionType === 'A') {
                dependValues = [{ label: 'Non-paiement', value: 'NP'},
                                { label: 'Fraude', value: 'FR' },
                                { label: 'Perte / Vol', value: 'PV' }];
            }
            else{
                dependValues = [{ label: 'Fraude', value: 'FR' },
                                { label: 'Perte / Vol', value: 'PV' }];
            }*/
            this.optionsMotif = dependValues;

        }


    }

    handleChangeDropDownMotif(event) {
        this.__Motif = event.target.value;
        this.__MotifLabel = event.target.options.find(opt => opt.value === event.detail.value).label;
        this.verifDisabled = false;
    }

    handleSave (event){

        let appelEntrant = null;
        let appelSortant = null;
        let restriction =  null;
        /**Fraude 05/07/24 Ila Start */
        let roamingData = null;
        /**Fraude 05/07/24 Ila End */

        switch (this.__suspentionType) {
            case 'A': 
                appelSortant = 'Bloqué';
                break;

            case 'B': 
                appelSortant = 'International Bloqué';
                break;
            case 'C':
                appelSortant = 'Bloqué';
                appelEntrant = 'Bloqué';
                restriction = 'Bloqué';
                break;
            /**Fraude 05/07/24 Ila Start */
            case 'D':
                appelEntrant = 'Bloqué';
                break;
            case 'E':
                roamingData = 'VS';
            /**Fraude 05/07/24 Ila End */
        }

        if (appelEntrant){
            if (this.__appelEntrantAttributeCategoriesId >= 0 && this.__appelEntrantProductAttributesId >= 0) {


                let localItem = JSON.parse(JSON.stringify(this.__item));
    
                localItem.attributeCategories.records[this.__appelEntrantAttributeCategoriesId].productAttributes.records[this.__appelEntrantProductAttributesId].userValues = appelEntrant;
    
                this.__item = JSON.parse(JSON.stringify(localItem));
    
            }
        }

        if (appelSortant){
            if (this.__appelSortantAttributeCategoriesId >= 0 && this.__appelSortantProductAttributesId >= 0) {


                let localItem = JSON.parse(JSON.stringify(this.__item));
    
                localItem.attributeCategories.records[this.__appelSortantAttributeCategoriesId].productAttributes.records[this.__appelSortantProductAttributesId].userValues = appelSortant;
    
                this.__item = JSON.parse(JSON.stringify(localItem));
    
            }
        }

        
        if (restriction && (this.__productOffer === 'ADSL' || this.__productOffer === 'FTTH')) {
 
            if (this.__restDataAttributeCategoriesId >= 0 && this.__restDataProductAttributesId >= 0) {

               let localItem = JSON.parse(JSON.stringify(this.__item));

               localItem.attributeCategories.records[this.__restDataAttributeCategoriesId].productAttributes.records[this.__restDataProductAttributesId].userValues = restriction;
        
                this.__item = JSON.parse(JSON.stringify(localItem));

         }
      }
        this.__isNext =true;

        this.updateOrder();


     
        
        
           
        
            
    }

    updateOrder(){

        // Save Type + Motif values
        const options = {};
        console.log("this.__suspentionTypeLabel"+this.__suspentionTypeLabel);
        console.log("this.__MotifLabel"+this.__MotifLabel);
        const params = {
            input: '{"Id":"'+ this.__item.OrderId.value +'","Type":"'+ this.__suspentionTypeLabel +'","Motif":"'+this.__MotifLabel+'","OrderType":"inwiB2C_Modification","SMOType":"inwiB2C_Suspension","Status":"inwiB2C_EnCours"  }',
            sClassName: 'vlocity_cmt.IntegrationProcedureService',
            sMethodName: 'Inwi_InwiB2C_PostSuspRehabData',
            options: JSON.stringify(options),
           

        };
        console.log("params: ",JSON.parse(JSON.stringify(params)));
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                window.console.log(response);
                 //Creates the event with the data.
                const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                    detail: this.__item
                });
        
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
               // this.goToNext();

            })
            .then(() =>{ 
                this.goToNext();
            })
            .catch(error => {
                window.console.log(error, 'error');
            });

    }

    goToNext(){

        //Creates the event with the data.
        const detailParam = {
            item: this.__item,
            nextStep: this.__isNext
        };


            const selectedEvent = new CustomEvent("customitemattribvaluechangewithnext", {
              detail : detailParam
            });
    
        // Dispatches the event.
            this.dispatchEvent(selectedEvent);     

    }




}