import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
export default class InwiB2C_RehabilitationComponent extends OmniscriptBaseMixin(LightningElement)  {


    __item;
    __suspentionType;
    __suspentionTypeLabel
    __Motif;
    __MotifLabel;
    __productOffer; 
    
    __appelEntrantAttributeCategoriesId;
    __appelEntrantProductAttributesId;

    __appelSortantAttributeCategoriesId;
    __appelSortantProductAttributesId;

            
    __restDataAttributeCategoriesId;
    __restDataProductAttributesId; 

    /**Fraude 05/07/24 Ila Start */ 
    __allowrehabappintern;
    __allowrehabroaming;
    __userProfile;
    rehabType='A';
    rehabTypeLabel='Réhabilitation';
    editFraude=true;
    /**Fraude 05/07/24 Ila End*/ 

    __isNext = false;


    @api
    set productoffer(value){

        this.__productOffer = value;

    }
    get productoffer (){
        return this.__productOffer;
    }


    @api
    set item(value){
        this.__item = {...value};
    }
    get item (){
        return this.__item;

    }
     /**Fraude 05/07/24 Ila Start */ 
    @api 
    set allowrehabappintern(value){
        this.__allowrehabappintern= value;
    }
    get allowrehabappintern (){
        return this.__allowrehabappintern;

    }
    @api 
    set allowrehabroaming(value){
        this.__allowrehabroaming= value;
    }
    get allowrehabroaming (){
        return this.__allowrehabroaming;

    }
    @api
    set userProfile(value) {

        this.__userProfile = value;

    }
    get userProfile() {
        return this.__userProfile;
    }
     /**Fraude 05/07/24 Ila End */ 
    connectedCallback(){   
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        let suspentionType = this.suspentionType;
    }

    /**Fraude 05/07/24 Ila Start */ 
    get options(){
        let typeReheb=[
            { label: 'Réhabilitation', value: 'A' },
            { label: 'Réhabilitation des appels internationaux', value: 'B' },
            { label: 'Réhabilitation Roaming Data', value: 'C' }
        ];
        if(this.__userProfile.includes("Fraude Int")){
            this.editFraude=false;
            for (var i=typeReheb.length-1; i>=0; i--) {
                if((this.__allowrehabappintern=="false" && typeReheb[i].value == "B") || (this.__allowrehabroaming=="false" && typeReheb[i].value == "C"))
                    typeReheb.splice(i, 1);
            }
            return typeReheb;

        }
        else{
            return typeReheb.filter(item => {return item.value=='A'});
        }

    }

    handleChangeDropDown(event){
        this.rehabType = event.detail.value;
        this.rehabTypeLabel = event.target.options.find(opt => opt.value === event.detail.value).label;
    }
    /**Fraude 05/07/24 Ila End */ 

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



    handleSave (event){

        /**Fraude 05/07/24 Ila Start */
        /*
        let appelEntrant ='Autorisé';
        let appelSortant ='Autorisé';
        let restriction =  'Autorisé';
        */
        console.log('rehabType ',this.rehabType);
        console.log('rehabTypeLabel ',this.rehabTypeLabel);

        let appelEntrant =null;
        let appelSortant =null;
        let restriction =  null;
        switch(this.rehabType){
            case 'A':
                appelSortant = 'Autorisé';
                appelEntrant = 'Autorisé';
                restriction = 'Autorisé';
                break;
            case 'B':
                appelSortant = 'Autorisé';
                break;

        }
        /**Fraude 05/07/24 Ila End */

        console.log('__appelEntrantAttributeCategoriesId : ' + this.__appelEntrantAttributeCategoriesId + ' __appelEntrantProductAttributesId : ' + this.__appelEntrantProductAttributesId);
        console.log('__appelSortantAttributeCategoriesId : ' + this.__appelSortantAttributeCategoriesId + ' __appelSortantProductAttributesId : ' + this.__appelSortantProductAttributesId);
        

        let localItem = JSON.parse(JSON.stringify(this.__item));

            /**Fraude 05/07/24 Ila Start */
            //if (this.__appelEntrantAttributeCategoriesId >= 0 && this.__appelEntrantProductAttributesId >= 0) {
                if (appelEntrant && this.__appelEntrantAttributeCategoriesId >= 0 && this.__appelEntrantProductAttributesId >= 0) {
            /**Fraude 05/07/24 Ila End */
                
    
                localItem.attributeCategories.records[this.__appelEntrantAttributeCategoriesId].productAttributes.records[this.__appelEntrantProductAttributesId].userValues = appelEntrant;
    
                
    
            }
            /**Fraude 05/07/24 Ila Start */
            //if (this.__appelSortantAttributeCategoriesId >= 0 && this.__appelSortantProductAttributesId >= 0) {
            if (appelSortant && this.__appelSortantAttributeCategoriesId >= 0 && this.__appelSortantProductAttributesId >= 0) {
            /**Fraude 05/07/24 Ila End */

                localItem.attributeCategories.records[this.__appelSortantAttributeCategoriesId].productAttributes.records[this.__appelSortantProductAttributesId].userValues = appelSortant;
 
            }
         /**Fraude 05/07/24 Ila Start */
            //if ( this.__productOffer === 'ADSL' || this.__productOffer === 'FTTH') {
            if (restriction && (this.__productOffer === 'ADSL' || this.__productOffer === 'FTTH')) {
        /**Fraude 05/07/24 Ila End */
 
                if (this.__restDataAttributeCategoriesId >= 0 && this.__restDataProductAttributesId >= 0) {
    
                   localItem.attributeCategories.records[this.__restDataAttributeCategoriesId].productAttributes.records[this.__restDataProductAttributesId].userValues = restriction;
            
    
             }
          }  



        console.log(localItem);
        
        this.__item = JSON.parse(JSON.stringify(localItem));
        this.__isNext =true;

        this.updateOrder(); 

          
        
    }

    updateOrder(){

        // Save Type + Motif values
        const options = {};
        const params = {
            input: '{"Id":"'+ this.__item.OrderId.value +'","TypeRehab":"'+this.rehabTypeLabel+'","OrderType":"inwiB2C_Modification","SMOType":"inwiB2C_Rehabilitation","Status":"inwiB2C_Activation"  }',
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
                //this.goToNext();

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
            nextStep: false
        };


            const selectedEvent = new CustomEvent("customitemattribvaluechangewithnext", {
              detail : detailParam
            });
    
        // Dispatches the event.
            this.dispatchEvent(selectedEvent);     

    }




}