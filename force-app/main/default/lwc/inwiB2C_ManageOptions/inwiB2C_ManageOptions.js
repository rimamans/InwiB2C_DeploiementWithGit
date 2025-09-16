import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import template from './inwiB2C_ManageOptions.html';


export default class InwiB2C_ManageOptions extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
  
  @track isLoading = false;
  isParametred = true;
  __itemsValidationErrors = [];
  __itemsRioInfo = [];
  errorList = [];
  displayedConfig = '';
  ErroredAttributes = [];
  optionsToParam = [];
  _ns = getNamespaceDotNotation();
  _actionUtilClass;
  dataParentErrors = [];
  // Var to check eligibilite NAFIDA et Collaborateur => Djamel OUAMER
  @api profilsvisibleoption ;
  //@track isStepForwardEnabled = false;

  __isnonvisibleoptionfree ;
  @api
  set  isnonvisibleoptionfree(value) {

    this.__isnonvisibleoptionfree = value;

  }
  get isnonvisibleoptionfree() {
    return this.__isnonvisibleoptionfree;
  } 

  __profileuser ;
  __provider;
  __isfar;

  // Y_MH begin Operateur
  __operateur ; 

  @api
  set  operateur(value) {

    this.__operateur = value;

  }
  get operateur () {
    return this.__operateur ;
  }  
// Y_MH end



  @api
  set  profileuser(value) {

    this.__profileuser = value;

  }
  get profileuser() {
    return this.__profileuser;
  }  
  @api
  set  provider(value) {

    this.__provider = value;

  }
  get provider() {
    return this.__provider;
  }  
  @api
  set  isfar(value) {

    this.__isfar = value;

  }
  get isfar() {
    return this.__isfar;
  }  

  __username;
  @api
  set username(value) {
    this.__username = value;
  }
  get username() {
    return this.__username;
  }
  __accountid;
  @api
  set accountid(value) {
    this.__accountid = value;
  }
  get accountid() {
    return this.__accountid;
  }
  __cin;
  @api
  set cin(value) {
    this.__cin = value;
  }
  get cin() {
    return this.__cin;
  }

  __typepos;
  @api
  set typepos(value) {
    this.__typepos = value;
  }
  get typepos() {
    return this.__typepos;
  }

  __typecanal; 
    @api
    set  typecanal(value){
      this.__typecanal = {...value};
    }
    get typecanal(){
      return this.__typecanal;
    }
    
  //CHB 28/11/2023 DGSN DGPC begin */
  __permissiondgsndgpc;
  @api
  set permissiondgsndgpc(value) {
    this.__permissiondgsndgpc = value;
  }
  get permissiondgsndgpc() {
    return this.__permissiondgsndgpc;
  }

  /* ILA 19/01/2024 PUPPILLES DGPC Start */
  __permissionpuppilesdgpc
  @api
  set permissionpuppilesdgpc(value){
    this.__permissionpuppilesdgpc = value;
  }
  get permissionpuppilesdgpc(){
    return this.__permissionpuppilesdgpc;
  }
  /* ILA 19/01/2024 PUPPILLES DGPC End */
  //CHB 28/11/2023 DGSN DGPC end */
  __vlccart;
  @api
  set vlccart(value) {
    this.__vlccart = value;
  }
  get vlccart() {
    return this.__vlccart;
  }
    /* ILA 11/03/2025 B-26743 Start */
  __withvolte
  @api
  set withvolte(value){
    this.__withvolte=value
  }
  get withvolte(){
    return this.__withvolte;
  }
  /* ILA 11/03/2025 B-26743 End */
/* CH-Y 29/04/2024 Migration PrePostBackOffice begin*/
__iswakil=false;
@api
set iswakil(value){
  this.__iswakil= value;
  console.log("manageoption is wakil",this.__iswakil);
}
get iswakil(){
  console.log("manageoption is wakil",this.__iswakil);
  return this.__iswakil;
}

// Y_MH begin Eclipse_Offre 5G
  __showservice ; 

   @api
  set showservice(value) {
    this.__showservice = value;
    console.log ('ShowService5G  manage options ' , this.__showservice ) ; 
  }
  
  get showservice () {
    console.log ('ShowService5G  manage options ' , this.__showservice ) ;
    return this.__showservice ;   
  }  
// Y_MH end Eclipse_Offre 5G

/* CH-Y 29/04/2024 Migration PrePostBackOffice end*/

  
/* chb 29/04/2024 Campus postpayee begin*/
@api
set checkcampus(value){
  this.__checkcampus= value;
}
get checkcampus(){
  return this.__checkcampus;
}
/* chb 29/04/2024 Campus postpayee end */
  // __product;
  // @api
  // set product(value) {
  //   this.__product = {...value};
  // }
  // get product() {
  //   return this.__product;
  // }

  __actionType = 'ACQ';
  @api
  set actionType(value) {
    this.__actionType = value ? value : 'ACQ';
  }
  get actionType() {
    return this.__actionType;
  }

  __userProfile = '';
  @api
  set userProfile(value) {

    this.__userProfile = value;

  }
  get userProfile() {
    return this.__userProfile;
  }

  __displayconfigurationanderror=true;
  @api
   set displayconfigurationanderror(value) {
   this.__displayconfigurationanderror = value ;
 }
   get displayconfigurationanderror() {
  return this.__displayconfigurationanderror;
 }

  __typeparcour="";
  @api
  set typeparcour(value) {
    this.__typeparcour = value;
  }
  get typeparcour() {
    return this.__typeparcour;
  }
  /* Collaborateur OCP ILA 13/11/24 Start */
  __isocpallowed
  @api
  set isocpallowed(value) {
    this.__isocpallowed = value;
  }
  get isocpallowed() {
    return this.__isocpallowed;
  }
/* Collaborateur OCP ILA 13/11/24  End */


/*R-SL 03/09/2025 MGEN3688-B2C Vente Wafacash_v1.5 start*/
 __iswafacash;
      @api
     set iswafacash(value) {
    this.__iswafacash = value;
    console.log("wwafacash", this.__iswafacash)
  }
  get iswafacash() {
      return this.__iswafacash;

  }


/*R-SL 03/09/2025 MGEN3688-B2C Vente Wafacash_v1.5 end*/
  get offreData() {
    if (typeof (this.vlccart.records) != "undefined") {
      console.log('Vlccart:', this.vlccart.records);
      return {
        message: this.hasAttributes(this.vlccart.records[0]),
        theItem: this.vlccart.records[0],
        product: this.vlccart.records[0].Product2,
        offreName: this.vlccart.records[0].Name,
        offreId: this.vlccart.records[0].Id.value,
        offreStatus: this.getStatus(this.vlccart.records[0]),
        isRemovable: this.isRemovable(this.vlccart.records[0]),
        isOptional: this.isOptional(this.vlccart.records[0]),
        hasRequiredAttributes: this.hasRequiredAttributes(this.vlccart.records[0]),
        isVisible: this.isVisible(this.vlccart.records[0]),
        IsvisibleOptionFree : this.IsvisibleOptionFree(this.vlccart.records[0])
      };
    }
    this.setErroredAttributes();
  }

  get isStepForwardEnabled() {
    console.log("isStepForwardEnabled start new")
    console.log("isStepForwardEnabled return: " + this.ErroredAttributes.length);
    //chb ano B-22875 10/12/2024 begin */
    if(this.displayconfigurationanderror == true && this.typeparcour=='RepriseD2D' || this.typeparcour!='RepriseD2D' ){
        return this.ErroredAttributes.length > 0 || this.dataParentErrors.length > 0;
    } 
     //chb ano B-22875 10/12/2024 end */
  }

  __StructuredOffre = [];
  get StructuredOffre() {
    console.log('Start_StructuredOffre_');
    let toReturn = [];
    if (typeof (this.vlccart.records) != "undefined") {
      try {
        toReturn = this.handleNode(this.vlccart.records[0]);
      } catch (error) {
        console.error("optionsToDisplay_error" + error)
      }
    }
    toReturn.children.map(element => {
      element.children = [...new Map(element.children.slice(0).reverse().map(item => [item['value'], item])).values()];
      return element;
    });
    this.__StructuredOffre = toReturn;
    return toReturn;
  }

  // Handle Parent errors
  get isParentHasErrors() {
    return this.dataParentErrors.length > 0;
  }

  handleChangeDetail(e) {
    console.log("handleChangeDetail.........")
    try {
      console.log(JSON.stringify(e.target.dataset))
      this.displayConfiguration(e.target.dataset.optionid);
      // this.isLoading = true;


      // let contexted_optionId = e.target.dataset.optionid;

      // let index = e.target.dataset.index;
      // let childindex = e.target.dataset.childindex;
      // let ParentRow;
      // let row;
      // if (typeof childindex === 'undefined') {
      //   ParentRow = this.vlccart.records[0];
      //   row = this.StructuredOffre.children[index].theitem;
      // } else {
      //   ParentRow = this.StructuredOffre.children[index].theitem;
      //   row = this.StructuredOffre.children[index].children[childindex].theitem;
      // }

    } catch (error) {
      this.isLoading = false;
      this.displayConfiguration(this.displayedConfig);
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Erreur",
          message: "Erreur lors de la mise à jour",
          variant: "error",
        })
      );
      console.error('interaction_catalog_error_handleChange:: ' + error);
    }
  }

  handleChangeLigneType(event) {
    let detail = event.detail;
    let updatedItem = event.detail.item;
    this.dataParentErrors = detail;


    console.log(" detail", detail)
    console.log(" let updatedItem = event.detail.item;", updatedItem)
    console.log("handleChangeSavingLigneType", event.detail);
  }

  connectedCallback() {
    console.log("this.far"+this.__isfar)
    console.log("iswakilManageOptions", this.__iswakil)
    console.log ('ShowService5G  manage options ' , this.__showservice ) ;
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.setErroredAttributes();
    
  }


  renderedCallback() {
    if (this.displayedConfig == '')
      this.displayedConfig = this.vlccart.records[0].Id.value;
    this.displayConfiguration(this.displayedConfig);
  }

  get loaded() {
    return true
  }

  setErroredAttributes() {
    console.log('setErroredAttributes start');
    try {
      const params = {
        input: '{"cartId":"' + this.vlccart.records[0].OrderId.value + '","price":"false","validate":false}',
        sClassName: "vlocity_cmt.CpqAppHandler",
        sMethodName: "getCarts",
        options: "{}",
      };

      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          this.ErroredAttributes = [];
          response.result.messages.map(element => {
            console.log('setErroredAttributes message:: ' + element);
            console.log('setErroredAttributes element.code:: ' + element.code);
            console.log('setErroredAttributes element.message:: ' + element.message);
            if (element.code == 204) {
              this.ErroredAttributes.push({ "ProductId": element.messageId.slice(0, 18), "message": element.message });
            }
          });
          this.StructuredOffre;
          console.log('setErroredAttributes this.ErroredAttributes:: ' + JSON.stringify(this.ErroredAttributes));
        }).catch(error => {
          console.error('setErroredAttributes_error:: ' + error);
        });
    } catch (error) {
    }
  }

  handleNode(item) {
    let returnedNode = {
      theitem: item,
      label: item.Product2.Name,
      value: item.Product2.Id,
      children: [],
      message: this.hasAttributes(item),
      isRemovable: this.isRemovable(item),
      isOptional: this.isOptional(item),
      hasRequiredAttributes: this.hasRequiredAttributes(item),
      isVisible: this.isVisible(item),

    };
// Y_MH begin Eclipse_Offre 5G
    if (typeof (item.lineItems) != "undefined")
      item.lineItems.records.map(lineItem => {

           console.log("lineItem--->", JSON.stringify(lineItem)) ; 
        if (!lineItem.Product2.vlocity_cmt__SellingEndDate__c ||
          lineItem.Product2.vlocity_cmt__SellingEndDate__c === null ||
          (lineItem.Product2.vlocity_cmt__SellingEndDate__c &&
            new Date() <= new Date(lineItem.Product2.vlocity_cmt__SellingEndDate__c))) {

      if (lineItem.Name != "Service 5G"  )  {
          returnedNode.children.push(this.handleNode(lineItem));
           
            } 
          console.log ("lineItem.Name " , lineItem.Name ) ;
          console.log ("this.ShowService5G " , this.__showservice ) ;
          if (lineItem.Name == "Service 5G" && this.__showservice  )  {
            console.log ("ineItem.Name into condition " , lineItem.Name ) ;
                returnedNode.children.push(this.handleNode(lineItem));
            }else {

            }
          }
          
      });


    if (typeof (item.childProducts) != "undefined")
      item.childProducts.records.map(childProduct => {
        console.log("childProduct--->", JSON.stringify(childProduct))
        /*R-SL 03/09/2025 MGEN3688-B2C Vente Wafacash_v1.5 start*/
        if (this.iswafacash && childProduct.Name.value === "Terminal" && (this.vlccart.records[0].Product2.vlocity_cmt__Type__c === "idar duo" || this.vlccart.records[0].Product2.vlocity_cmt__Type__c === "Prepaye" || this.vlccart.records[0].Product2.vlocity_cmt__Type__c === "Postpaye") ) {
        return;
      }
        console.log("CHILD PRODUCT ===>", this.vlccart.records[0].Product2.vlocity_cmt__Type__c);
      /*R-SL 03/09/2025 MGEN3688-B2C Vente Wafacash_v1.5 end*/
        if (childProduct.ProductCode.value !== "INWIB2C_PRODLIBRE_REC") {
          if (!childProduct.Product2.vlocity_cmt__SellingEndDate__c ||
            childProduct.Product2.vlocity_cmt__SellingEndDate__c === null ||
            (childProduct.Product2.vlocity_cmt__SellingEndDate__c &&
              new Date() <= new Date(childProduct.Product2.vlocity_cmt__SellingEndDate__c))) {
                 console.log ("childProduct.Name out " , childProduct.Name.value ) ;
              if (childProduct.Name.value != "Service 5G"  )  {
                  returnedNode.children.push(this.handleNode(childProduct));
                  console.log ("childProduct.Name IN 1 " , childProduct.Name.value) ;
              }
              if (childProduct.Name.value == "Service 5G" && this.__showservice  ) {
                  returnedNode.children.push(this.handleNode(childProduct));
                  console.log ("childProduct.Name IN 2 " , childProduct.Name.value ) ;

              }else {

            }
              

              }
            
        }

      });

    return returnedNode;
  }
  // Y_MH end Eclipse_Offre 5G



  hasAttributes(item) {
    if (item.attributeCategories && item.attributeCategories.records) {
      let toDisplay = false;
      item.attributeCategories.records.forEach(attributeCategory => {
        attributeCategory.productAttributes.records.forEach(attribute => {

          toDisplay = toDisplay || !attribute.hidden;
        });
      });
      return toDisplay;

    } 
      return false;
    

  }


  // IsvisibleOptionFree(item){
  //   if(this.userProfil === 'moh'){
  //     return  item.Product2.ProductCode ==='INWIB2C_MOB02_OFFERING_OIM10' 
  //     || item.Product2.ProductCode === 'INWIB2C_MOB02_OFFERING_OIM11'
  //     || item.Product2.ProductCode === 'INWIB2C_MOB02_OFFERING_OIM12' 
  //     || item.Product2.ProductCode === 'INWIB2C_MOB02_OFFERING_OIM13' 
  //     || item.Product2.ProductCode === 'INWIB2C_MOB02_OFFERING_OIM14'
  //     || item.Product2.ProductCode === 'INWIB2C_MOB02_OFFERING_OIM15'? true :false;
  //   }
  //      return false;
       
  // }
  IsvisibleOptionFree(item) {
    const allowedCodes = ['INWIB2C_MOB02_OFFERING_OIM10', 'INWIB2C_MOB02_OFFERING_OIM11', 'INWIB2C_MOB02_OFFERING_OIM12', 'INWIB2C_MOB02_OFFERING_OIM13', 'INWIB2C_MOB02_OFFERING_OIM14', 'INWIB2C_MOB02_OFFERING_OIM15'];
    console.log('inwiB2C_NonVisibleAcq__c :',this.__isnonvisibleoptionfree);
    console.log('UserProfile :', this.profileuser);
    console.log('profilsVisibleOption :', this.profilsvisibleoption);
  
    if (this.__isnonvisibleoptionfree === true || (this.profilsvisibleoption && this.profilsvisibleoption.some(obj => obj.ProfilsVisibleOption.includes(this.profileuser)))) {
      return allowedCodes.includes(item.Product2.ProductCode);
    }
  
    return false;
  }
  isVisible(item) {
    const allowedProductCodes = [
      'INWIB2C_MOB02_OFFERING_OIM10',
      'INWIB2C_MOB02_OFFERING_OIM11',
      'INWIB2C_MOB02_OFFERING_OIM12',
      'INWIB2C_MOB02_OFFERING_OIM13',
      'INWIB2C_MOB02_OFFERING_OIM14',
      'INWIB2C_MOB02_OFFERING_OIM15',
      'INWIB2C_OFFERING_SHAHID',
      'INWIB2C_DEG01_OFFERING_DSLB2CIPF',
      'INWIB2C_PRODLIBRE_RECFTTH',
      'INWIB2C_FOB2C_OFFERING_FOB2CIPF',
       /**Boost FTTH 13/05/24 ILA Start */
      'INWIB2C_FOB2C_OFFERING_BOOST2J',
      'INWIB2C_FOB2C_OFFERING_BOOST7J',
      /**Boost FTTH 13/05/24 ILA End */
      /**MGEN3770 13/08/25 K-KA Start */
      'INWIB2C_FOB2C_OFFERING_BOOST2002J',
      'INWIB2C_FOB2C_OFFERING_BOOST2007J',
      /**MGEN3770 13/08/25 K-KA End */
      'INWIB2C_OFFERING_USERCTRLSR'

    ];
    const isVisibleOptionFree = this.IsvisibleOptionFree(item);
    console.log('isVisibleOptionFree:', isVisibleOptionFree);
    
    return allowedProductCodes.includes(item.Product2.ProductCode) || 
      item.Product2.INWIB2C_visibilit_options__c === 'caché' ||
      (this.__actionType === 'CHOPTION' && item.Product2.Name === 'Terminal') ?
      (isVisibleOptionFree ? true : false) : true;
  }

  isRemovable(item) {
    return (typeof item.actions.deleteitem === 'undefined') ? false : true;
  }


  isOptional(item) {
      /* ILA 11/03/2025 B-26743 Start */
      return (item.Product2.Name === 'Volte' && this.__withvolte) || (item.maxQuantity == 1 && item.minQuantity == 1 && item.defaultQuantity == 1) ? true : false;
      //return (item.maxQuantity == 1 && item.minQuantity == 1 && item.defaultQuantity == 1) ? true : false;
      /* ILA 11/03/2025 B-26743 End */
  }

  // eslint-disable-next-line consistent-return
  hasRequiredAttributes(item) {
    try {
      let itemId = item.Id.value;
      if (this.ErroredAttributes.length == 0) return false;
      let toRetrun = false;

      this.ErroredAttributes.map(error => {
        if (error.ProductId == itemId) {
          toRetrun = true;
        }
      });
      return toRetrun;
    } catch (error) {
      console.error('HRA-hasRequiredAttributes_error:: ' + error);
    }
  }

  displayConfiguration(id_section) {
    try {
      this.template.querySelector(`[data-theid="${this.offreData.offreId}"]`).style.display = "none";
      this.template.querySelector(`[data-optionid="${this.offreData.offreId}"]`).style.fontWeight = "normal";
    } catch (error) {
      console.error('error_displayConfiguration_try1:: ' + error);
    }
    this.StructuredOffre.children.map(opt => {
      try {
        this.template.querySelector(`[data-theid="${opt.value}"]`).style.display = "none";
        this.template.querySelector(`[data-optionid="${opt.value}"]`).style.fontWeight = "normal";

      } catch (error) {
        console.error('error_displayConfiguration_try2:: ' + error);
      }

      opt.children.map(child => {
        try {
          this.template.querySelector(`[data-theid="${child.value}"]`).style.display = "none";
          this.template.querySelector(`[data-optionid="${child.value}"]`).style.fontWeight = "normal";

        } catch (error) {
          console.error('error_displayConfiguration_try3:: ' + error);
        }
      });

    });

    try {
      this.template.querySelector(`[data-theid="${id_section}"]`).style.display = "inline";
      this.template.querySelector(`[data-optionid="${id_section}"]`).style.fontWeight = "bold";
      this.displayedConfig = (this.displayedConfig == '') ? this.vlccart.records[0].Id.value : id_section;

    } catch (error) {
      console.error('error_displayConfiguration_try4:: ' + error);
    }

  }

  handleClick(e) {
    this.displayConfiguration(e.target.dataset.optionid);
  }

  handleChange(e) {
    try {

      this.displayConfiguration(e.target.dataset.optionid);
      this.isLoading = true;


      let contexted_optionId = e.target.dataset.optionid;

      let index = e.target.dataset.index;
      let childindex = e.target.dataset.childindex;
      let ParentRow;
      let row;
      if (typeof childindex === 'undefined') {
        ParentRow = this.vlccart.records[0];
        row = this.StructuredOffre.children[index].theitem;
      } else {
        ParentRow = this.StructuredOffre.children[index].theitem;
        row = this.StructuredOffre.children[index].children[childindex].theitem;
      }

      if (e.target.checked) {
        try {
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Info',
              message: 'Ajout de ' + row.Product2.Name + ' en cours',
              variant: 'Info'
            }),
          );

          let partentRecord = JSON.parse(JSON.stringify(ParentRow));
          delete partentRecord.lineItems;
          let addParams = JSON.parse(JSON.stringify(row.actions.addtocart.remote.params));

          addParams.items[0].parentRecord = {};
          addParams.items[0].parentRecord.records = [];
          addParams.items[0].parentRecord.records.push(partentRecord);
          const params2 = {
            input: JSON.stringify(addParams),
            sClassName: "vlocity_cmt.CpqAppHandler",
            sMethodName: "postCartsItems",
            options: "{}",
          };
          this._actionUtilClass
            .executeAction(params2, null, this, null, null)
            .then(response => {
              this.getCart(row.actions.addtocart.remote.params.cartId);
            }).catch(error => {
              console.error('executeAction_adding_error:: ' + error);
            });
        } catch (error) {
          console.error('adding_error:: ' + error);
        }
      } else {
        try {
          if(row.Name=='Terminal'){

        
            console.log('row.'+row.Id.value);
          
            let input1 = { "orderitemid": row.Id.value };
            const params1 = {
              input: JSON.stringify(input1),
              sClassName: `${this._ns}IntegrationProcedureService`,
              sMethodName: 'inwib2c_UnlockIfNeeded',
              options: '{}'
          };
  
          console.log('before calling inwib2c_UnlockIfNeeded' + JSON.stringify(params1));
      
          this._actionUtilClass
              .executeAction(params1, null, this, null, null)
              .then(response => {
                  console.log('Success api inwib2c_UnlockIfNeeded  called');  
           
                  console.log(response);
             
                          this.dispatchEvent(
                          new ShowToastEvent({
                          title: 'Erreur',
                          message: 'La ressource a été libérée ',
                          variant: 'success'
                          }),
                      );

                  }).catch(error => {
                  });
          
                }
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Info',
              message: 'Suppression de ' + row.Name + ' en cours',
              variant: 'Info'
            }),
          );
          const params = {
            input: JSON.stringify(row.actions.deleteitem.remote.params),
            sClassName: "vlocity_cmt.CpqAppHandler",
            sMethodName: "deleteCartsItems",
            options: "{}",
          };
          this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
              console.log('row.Name'+row.Name);
              console.log('row'+row);
              this.getCart(row.actions.deleteitem.remote.params.cartId);
              if(row.Name=='Terminal'){

        
              console.log('row.'+row.Id.value);
            
              let input1 = { "orderitemid": row.Id.value };
              const params1 = {
                input: JSON.stringify(input1),
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'inwib2c_UnlockIfNeeded',
                options: '{}'
            };
    
            console.log('before calling inwib2c_UnlockIfNeeded' + JSON.stringify(params1));
        
            this._actionUtilClass
                .executeAction(params1, null, this, null, null)
                .then(response => {
                    console.log('Success api inwib2c_UnlockIfNeeded  called');  
             
                    console.log(response);
               
                            this.dispatchEvent(
                            new ShowToastEvent({
                            title: 'Erreur',
                            message: 'La ressource a été libérée ',
                            variant: 'success'
                            }),
                        );

                    }).catch(error => {
                    });
            
                  }
            }).catch(error => {
            });
          
        } catch (error) {
          console.error('removing_error:: ' + error);
        }
      }
    } catch (error) {
      this.isLoading = false;
      this.displayConfiguration(this.displayedConfig);
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Erreur",
          message: "Erreur lors de la mise à jour",
          variant: "error",
        })
      );
      console.error('interaction_catalog_error_handleChange:: ' + error);
    }
  }

  getCart(cartId) {
    const inputParams = {
      cartId: cartId,
      //methodName: "getCartsItems",
      fields: "vlocity_cmt__BillingAccountId__c,vlocity_cmt__ServiceAccountId__c,Quantity,vlocity_cmt__RecurringTotal__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__RecurringManualDiscount__c,vlocity_cmt__ProvisioningStatus__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__OneTimeCharge__c,ListPrice,vlocity_cmt__ParentItemId__c,vlocity_cmt__BillingAccountId__r.Name,vlocity_cmt__ServiceAccountId__r.Name,vlocity_cmt__PremisesId__r.Name,vlocity_cmt__InCartQuantityMap__c,vlocity_cmt__EffectiveQuantity__c,Product2.INWIB2C_visibilit_options__c,Product2.vlocity_cmt__SpecificationType__c,Product2.Name,Product2.vlocity_cmt__SellingEndDate__c,vlocity_cmt__Product2Id__r.Family,Product2.InwiB2C_Type_offre__c,Product2.vlocity_cmt__Type__c",
      validate: true,
      price: false
    };

    const params = {
      input: JSON.stringify(inputParams),
      sClassName: "vlocity_cmt.CpqAppHandler",
      sMethodName: "getCartsItems",

      options: "{}",
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log("******* JSON.stringify(response.result) *******");
        console.log(JSON.stringify(response.result));
        if (response.error) {
          this.__vlccart = JSON.parse(JSON.stringify(response.result));
          let saveObj = {
            "vlcCart": JSON.parse(JSON.stringify(response.result))
          }
          this.omniApplyCallResp(saveObj);
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Success",
              message: "Success",
              variant: "success",
            })
          );
        } else {
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Erreur",
              message: "Erreur lors de la mise à jour",
              variant: "error",
            })
          );
        }
        this.setErroredAttributes();
        this.isLoading = false;
        this.displayConfiguration(this.displayedConfig);
      })
      .catch(error => {
        this.isLoading = false;
        this.displayConfiguration(this.displayedConfig);
        console.error('executeAction_error_getCart:: ' + error);
      });
  }

  isIdExist(array, id) {
    array.map(i => {
      if (i == id) return true;
    });
    return false
  }

  getStatus(item) {
    if (item.action) {
      if (item.action == "Disconnect") {
        if (item.itemType == "lineItem") {
          return "Supprimé";
        } else {
          return "Disponible";
        }
      } else if (item.action == "Existing") {
        if (item.minQuantity == 0 && item.Product2.vlocity_cmt__SpecificationType__c !== "Offer") {
          return "Existant";
        } else {
          return "Obligatoire";

        }
      } else if (item.action == "Add") {
        return "Ajouté";
      }
    } else {
      return "Disponible";
    }
  }

  gotonextStep() {
    this.omniNextStep();
  }

  gotopreviousStep() {
    this.omniPrevStep();

  }

  hanldeItemAttributesValueChange(event) {

    this.isLoading = true;
    let updatedItem = event.detail.item;
    let updatedItemAttributes = event.detail.attributeItem;
    let itemId = updatedItem.Id.value;
    let oldItems = JSON.parse(JSON.stringify(this.vlccart));
    let oldItemsRecords = oldItems.records;
    let changedItemsRecords = oldItemsRecords.map(function (itemOccur) {
      if (itemOccur.Id.value === itemId) return updatedItem;
      else return itemOccur;
    });
    oldItems.records = changedItemsRecords;
    this.vlccart = JSON.parse(JSON.stringify(oldItems));
    this.updateItemAttribute(updatedItemAttributes);
  }

  updateItemAttribute(updatedItemAttributes) {
    this.isLoading = true;
    let items = {};
    items.records = [];
    items.records.push(updatedItemAttributes);

    this.updateOngoing = true;

    const orderId = this.__vlccart.records[0].OrderId.value;
    const itemId = this.__vlccart.records[0].Id.value;

    const inputParams = {
      cartId: orderId,
      items: items,
      price: true,
      validate: true,
      includeAttachment: false,
      pagesize: 20,
      hierarchy: -1,
      methodName: "putCartsItems"

    }
    const params = {
      input: JSON.stringify(inputParams),
      sClassName: 'vlocity_cmt.CpqAppHandler',
      sMethodName: 'putCartsItems',
      options: '{}',
    };

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        this.getCart(orderId);
      })
      .catch(error => {
        this.isLoading = false;
        this.displayConfiguration(this.displayedConfig);
        console.error('updateItemAttribute_call_putCartsItems_error ' + error);
      });
  }

  _updateItemAttribute(updatedItemAttributes) {
    const orderId = this.__vlccart.records[0].OrderId.value;
    this.isLoading = true;
    this.getCart(orderId);
  }


  handleitemattributesvalidationerror(event) {
    event.stopPropagation();
    this.ErroredAttributes;
    let itemsValidationErrors = event.detail;

    itemsValidationErrors.forEach(itemValidationErrors => {
      let eventItem = itemValidationErrors.item;
      let validationErrors = itemValidationErrors.validationErrors;

      let index = this.__itemsValidationErrors.findIndex(itemValidation => {
        return itemValidation.item == eventItem;
      });

      if (index >= 0) {
        this.__itemsValidationErrors[index] = {
          item: eventItem,
          validationErrors: validationErrors
        };

      } else {
        this.__itemsValidationErrors.push({
          item: eventItem,
          validationErrors: validationErrors
        })
      }
    });

    this.errorList = [];
  }

  // handleRIOCodeInvalid(event) {
  //     console.log('Received RIO code invalid event:', event.detail.message);
  //     this.isStepForwardEnabled = true;
  // }

  // handleRIOCodeValid(event) {
  //     console.log('Received RIO code valid event:', event.detail.message);
  //     this.isStepForwardEnabled = false;
  // }


  handleitemattributesrioinfo(event) {
      event.stopPropagation();
      const rioInfo = event.detail.RIOInfo;

      console.log('Received RIOInfo:', rioInfo);

      if (rioInfo === false) {
          this.isStepForwardEnabled = true;
          console.log('Step forward disabled:', this.isStepForwardEnabled);
      } else {
          this.isStepForwardEnabled = false;
          console.log('Step forward enabled:', this.isStepForwardEnabled);
      }
  }



  handlecustomitemattribvaluechangewithnext(event) {
    let nextStep = event.detail.nextStep;
    if (nextStep) {
      this.omniNextStep();
    }
  }

  getCartItem(cartId, itemId) {
    const inputParams = {
      cartId: cartId,
      id: itemId,
      price: true,
      validate: true,
      includeAttachment: false,
      pagesize: 20,
      hierarchy: -1,
      methodName: "getCartsItemsById"

    }


    const params = {
      input: JSON.stringify(inputParams),
      sClassName: 'vlocity_cmt.CpqAppHandler',
      sMethodName: 'getCartsItemsById',
      options: '{}',
    };

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        if (response.error) {
          this.__vlccart = JSON.parse(JSON.stringify(response.result));
          this.updateOngoing = false;
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Success 18 03',
              message: 'Success',
              variant: 'success'
            }),
          );
        } else {
          this.updateOngoing = false;
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Erreur',
              message: 'Erreur lors de la mise à jour',
              variant: 'error'
            }),
          );
        }
      })
      .catch(error => {
        console.error('getCartItem_error' + error);
      });
  }

  stepForward() {
    try {
      let oldItems = JSON.parse(JSON.stringify(this.__vlccart));
      delete oldItems.records[0].messages;
      delete oldItems.records[0].actions;
      let reponse = {
        records: oldItems.records
      }
      this.omniUpdateDataJson(reponse);
      this.omniSaveState(reponse, true);
      this.omniNextStep();
    } catch (error) {
      console.error('handleSave_error' + error);
    }
  }

  // *** ODE 10/02/2022

  // Display attribute without select or deselect option
  handleView(e) {
    console.log("handleviex")
    this.displayConfiguration(e.target.dataset.optionid);
  }

  render() {
    return template;
  }

}