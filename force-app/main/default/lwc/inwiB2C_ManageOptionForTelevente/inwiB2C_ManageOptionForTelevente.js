import { LightningElement, api,track } from "lwc";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import template from './inwiB2C_ManageOptionForTelevente.html';

export default class inwiB2C_ManageOptionForTelevente extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    isLoading = false;
    ButtonCheckDisabled = false;
    isParametred = true;
    __itemsValidationErrors = [];
    errorList = [];
    displayedConfig = '';
    ErroredAttributes = [];
    optionsToParam = [];
    _ns = getNamespaceDotNotation();
    _actionUtilClass;
    dataParentErrors = [];
    // Var to check eligibilite NAFIDA et Collaborateur => Djamel OUAMER
    @api profilsvisibleoption ;
  
    __isnonvisibleoptionfree ;
    @api
    set  isnonvisibleoptionfree(value) {
  
      this.__isnonvisibleoptionfree = value;
  
    }
    get isnonvisibleoptionfree() {
      return this.__isnonvisibleoptionfree;
    } 
  
  // CH_Y MC_MGEN3610-SFVLB2C_FTTH VULA TELEVENTE begin
  __operateur ; 

  @api
  set  operateur(value) {

    this.__operateur = value;

  }
  get operateur () {
    return this.__operateur ;
  }  

  __isftthvula ; 

  @api
  set  isftthvula(value) {

    this.__isftthvula = value;

  }
  get isftthvula () {
    return this.__isftthvula ;
  }  
// CH_Y MC_MGEN3610-SFVLB2C_FTTH VULA TELEVENTE end
v
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

    __profileuser ;
    @api
    set  profileuser(value) {
  
      this.__profileuser = value;
  
    }
    get profileuser() {
      return this.__profileuser;
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
    // 
  
    __vlccart;
    @api
    set vlccart(value) {
      this.__vlccart = value;
    }
    get vlccart() {
      return this.__vlccart;
    }
  
   
  
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
  
    __typeparcour="";
    @api
    set typeparcour(value) {
      this.__typeparcour = value;
    }
    get typeparcour() {
      return this.__typeparcour;
    }
 
    __selectedmodel=false;
    @api 
    set selectedmodel(value) {
      this.__selectedmodel = value;
    }
    get selectedmodel() {
      return this.__selectedmodel;
    }

    __modelivraison="";
    @api
    get modelivraison() {
      return this.__modelivraison;
    }
    set modelivraison(value) {
      this.__modelivraison = value;
    }
    __nameagencelivraison="";
      @api
      set nameagencelivraison(value) {
        this.__nameagencelivraison = value;
      }
      get nameagencelivraison() {
        return this.__nameagencelivraison;
      }
      __codeagencelivraison="";
      @api
      set codeagencelivraison(value) {
        this.__codeagencelivraison = value;
      }
      get codeagencelivraison() {
        return this.__codeagencelivraison;
      }
      __displayconfigurationanderror=true;
      @api
       set displayconfigurationanderror(value) {
       this.__displayconfigurationanderror = value ;
     }
       get displayconfigurationanderror() {
      return this.__displayconfigurationanderror;
     }
     
    @api
     set  provider(value) {
   
       this.__provider = value;
   
     }
     get provider() {
       return this.__provider;
     }  
  
      
    @api
    set  displayimeiftth(value) {
      this.__displayimeiftth = value;
  
    }
    get displayimeiftth() {
      return this.__displayimeiftth;
    }  

    __typecanal; 
    @api
    set  typecanal(value){
      this.__typecanal = {...value};
    }
    get typecanal(){
      return this.__typecanal;
    }
    
    @api
    set disabledinputimei(value) {
      this.__disabledinputimei = value;
  }
    get disabledinputimei() {
       return this.__disabledinputimei;
    }

    __haspermissionsetlastmile;
    @api
    set haspermissionsetlastmile(value){
      this.__haspermissionsetlastmile = value;
    }
   get haspermissionsetlastmile(){
    return this.__haspermissionsetlastmile;
   }
   
   __isagencevalidationbocrcd2d;
   @api
   set isagencevalidationbocrcd2d(value){
     this.__isagencevalidationbocrcd2d = value;
    }

   get isagencevalidationbocrcd2d(){
   return this.__isagencevalidationbocrcd2d;
   }

  __checkisorderwithporta = false;
   @api
   set checkisorderwithporta(value){
     this.__checkisorderwithporta = value;
    }

   get checkisorderwithporta(){
   return this.__checkisorderwithporta;
   }

   __offertype;
   @api
   set offertype(value){
     this.__offertype = value;
    }

   get offertype(){
   return this.__offertype;
   }
   // B-31963 M_DJ 28/08/2025 begin
   __statutligne
   @api
   get statutligne() {
    return this.__statutligne
   }
   set statutligne(value) {
    this.__statutligne = value
   }
   // B-31963 M_DJ 28/08/2025 end



    get ShowButton(){
      return this.modelivraison==="Domicile" && this.typeparcour === "Televente" && this.haspermissionsetlastmile == true
    }

    handleCustomValidateCodeArticle(event) {
      this.displayconfigue = event.detail.displayconfigurationanderror;
      if(this.__typeparcour ==="RepriseD2D"){
        this.displayconfigurationanderror = this.displayconfigue ;
      }else{
        this.displayconfigurationanderror = this.ErroredAttributes.length > 1;
      }
      
      console.log('Display Configuration and Error:', this.displayconfigue);

      this.setErroredAttributes() 
   }

   mdnProvisoireSelected= false;
   handleMdnProvisoireSelected(event) {
    this.mdnProvisoireSelected = event.detail.mdnProvisoireSelected;
   }

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
      console.log("modelivraison: " + this.__modelivraison.length);
      console.log("typeparcour : " + this.__typeparcour.length);
      console.log("checkisorderwithporta : " + this.__checkisorderwithporta);
      console.log("offertype : " + this.__offertype);
  
  
      if( this.displayconfigurationanderror == true && this.checkisorderwithporta == false){
        return this.ErroredAttributes.length > 0 || this.dataParentErrors.length > 0;
     // H-M : Dans le cas d'une commande portée D2D de l'offre FTTH, on désactive le bouton "Suivant" si le MDN provisoire n'est pas généré.
       }else if(this.checkisorderwithporta == true && this.typeparcour ==="RepriseD2D" && this.offertype =='FTTH' && this.statutligne !== 'Ligne Active'){
        console.log('mdnProvisoireSelected manage option:', this.mdnProvisoireSelected);
         return !this.mdnProvisoireSelected;
      }
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
      this._actionUtilClass = new OmniscriptActionCommonUtil();
      this.setErroredAttributes();
      console.log("typeparcourManagetelevnet" + this.__typeparcour );
      console.log('displayconfigurationanderror'+this.displayconfigurationanderror);
      console.log('EshopAttributes'+this.eshopattributes);
      console.log('type de parcours est :' +this.__typeparcour);
      console.log('paiement :' +this.__paiement);
      console.log("modelivraison",this.__modelivraison);
      console.log("nameagencelivraison",this.__nameagencelivraison);   
      console.log("haspermissionsetlastmile",this.__haspermissionsetlastmile);   

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
        // const params = {
        //   input: '{"cartId":"' + this.vlccart.records[0].OrderId.value + '","price":"false","validate":false}',
        //   sClassName: "vlocity_cmt.CpqAppHandler",
        //   sMethodName: "getCarts",
        //   options: "{}",
        // };
        const cartId = this.__vlccart.records[0].OrderId.value;
        const itemId = this.__vlccart.records[0].Id.value;
      const inputParams = {
        cartId: cartId,
        id: itemId,
        price: false,
        validate: false,
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
            this.ErroredAttributes = [];
            response.result.messages.map(element => {
              console.log('setErroredAttributes message:: ' + element);
              console.log('setErroredAttributes element.code:: ' + element.code);
              console.log('setErroredAttributes element.message:: ' + element.message);

            // H-M : On ignore l'erreur "SIM" uniquement dans le cas où la livraison est à domicile (lastMile Televente)
              const messageText = element.message;
              const isSimError = messageText === "Required attribute missing for SIM.";
              const isToIgnoreSimError = isSimError && this.modelivraison === "Domicile" &&this.haspermissionsetlastmile == true;
              if (element.code == 204 && this.displayconfigurationanderror==true && !isToIgnoreSimError){
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
  
    // Y_MH begin Eclipse_Offre 5G
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
  
      if (typeof (item.lineItems) != "undefined")
        item.lineItems.records.map(lineItem => {
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
            console.log ("ineItem.Name " , lineItem.Name ) ;
                returnedNode.children.push(this.handleNode(lineItem));
            }else {

            }
              }
            
        });
  
  
      if (typeof (item.childProducts) != "undefined")
        item.childProducts.records.map(childProduct => {
          console.log("childProduct--->", JSON.stringify(childProduct))
          //chb 28/08/2024 B-19136
          if (childProduct.ProductCode.value !== "INWIB2C_PRODLIBRE_REC" && childProduct.ProductCode.value !== "INWIB2C_FOB2C_OFFERING_BOOST2J"
            && childProduct.ProductCode.value !== "INWIB2C_FOB2C_OFFERING_BOOST7J") {
            if (!childProduct.Product2.vlocity_cmt__SellingEndDate__c ||
              childProduct.Product2.vlocity_cmt__SellingEndDate__c === null ||
              (childProduct.Product2.vlocity_cmt__SellingEndDate__c &&
                new Date() <= new Date(childProduct.Product2.vlocity_cmt__SellingEndDate__c))){

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
              // returnedNode.children.push(this.handleNode(childProduct));
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
        'INWIB2C_OFFERING_USERCTRLSR',
        'INWIB2C_MOB02_OFFRING_MB',
        'INWIB2C_MOB02_OFFRING_APN4G',
        'INWIB2C_MOB02_OFFRING_PLAFOND',
        'INWIB2C_MOB02_OFFRING_SERVICE4G',
        'INWIB2C_OFFRING_CALLWAIT',
        'INWIB2C_OFFRING_CONFERENCE',
        'INWIB2C_OFFRING_DOUBLECOM',
        'INWIB2C_DEG01_OFFERING_DSLB2CFREE4',
        'INWIB2C_DEG01_OFFERING_DSLB2CFREE5',
        'INWIB2C_OFFERING_VMSCFWNR',
        'INWIB2C_OPB2C_OFFERING_CONTROLPARENTAL',
        'INWIB2C_OPB2C_OFFRING_SERVICE4G',
        'INWIB2C_OPB2C_OFFRING_APN4G',
        'INWIB2C_OPB2C_OFFRING_MB',
        'INWIB2C_MOB02_OFFERING_GRAT_ON_NET',
        'INWIB2C_FOB2C_OFFERING_FOB2CFREE4',
        'INWIB2C_FOB2C_OFFERING_FOB2CFREE5'
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

      return (item.maxQuantity == 1 && item.minQuantity == 1 && item.defaultQuantity == 1) ? true : false;
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
      // Récupération de l'option ID
      const optionId = e.target.dataset.optionid;
      console.log('Option ID:', optionId);
  
      
      const index = e.target.dataset.index;
      console.log('Index:', index);

    // Initialisation de la variable nameAtIndex
    let nameAtIndex;

    // Vérification de l'existence des données et récupération du nom à l'index spécifié
    const lineItemsRecords = this.__vlccart?.records?.[0]?.lineItems?.records;

    if (lineItemsRecords && index >= 0 && index < lineItemsRecords.length) {
        nameAtIndex = lineItemsRecords[index].Name;
        console.log('Name at index fils:', nameAtIndex);
    } else {
        console.error('Invalid vlccart structure, missing data, or index out of bounds');
    }
     
      let allowClick = false;

      if (this.modelivraison === "Domicile" && this.typeparcour === "Televente" && nameAtIndex === 'SIM' && this.haspermissionsetlastmile == true) {
         // Ne pas afficher l'action après le clic si les conditions sont remplies
          allowClick = false;
          e.preventDefault();
          return false;
      } else if (this.modelivraison !== "Domicile" && this.typeparcour === "Televente" && nameAtIndex === 'SIM') {
         // Afficher l'action après le clic si les conditions sont remplies
          allowClick = true;
      } else {
          // Autoriser le clic pour d'autres cas
          allowClick = true;
      }

      if (allowClick) {
          this.displayConfiguration(optionId);
      }
  }
  
  
  
  //   handleClick(e) {
  //     // Afficher l'élément cliqué pour le débogage
  //     console.log('Clicked element:', e.target);
  
  //     // Trouver l'élément le plus proche avec les attributs de données
  //     let targetElement = e.target;
  
  //     // Si l'utilisateur clique sur un élément 'a', récupérez le 'label' parent
  //     if (targetElement.tagName === 'A') {
  //         targetElement = targetElement.closest('label');
  //     }
  
  //     // Si l'utilisateur clique sur une icône ou un autre élément, récupérez le 'label' parent
  //     if (!targetElement && e.target.tagName === 'LIGHTNING-ICON') {
  //         targetElement = e.target.closest('label');
  //     }
  
  //     // Si un élément pertinent est trouvé
  //     if (targetElement) {
  //         const optionId = targetElement.dataset.optionid;
  //         const optionType = targetElement.dataset.optiontype;
  
  //         // Loguer pour le débogage
  //         console.log('Found element:', targetElement);
  //         console.log('Option ID:', optionId);
  //         console.log('Option Type:', optionType);
  
  //         // Vérifiez si c'est un élément spécifique comme "SIM"
  //         if (optionType === "SIM") {
  //             console.log("SIM option clicked");
  //             // Ajouter votre logique spécifique pour "SIM"
  //         } else if (optionType === "Numéro de Téléphone") {
  //             console.log("Numéro de Téléphone option clicked");
  //             // Ajouter votre logique spécifique pour "Numéro de Téléphone"
  //         }
  
  //         // Passer l'optionId à la méthode displayConfiguration
  //         this.displayConfiguration(optionId);
  //     } else {
  //         console.log('No relevant element found or data attributes missing.');
  //     }
  // }
  
  
  
  
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
            const itemId = this.__vlccart.records[0].Id.value;
            console.log('brm' +itemId);
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
                this.getCartItem(row.actions.addtocart.remote.params.cartId,itemId);
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
                const itemId = this.__vlccart.records[0].Id.value;
                this.getCartItem(row.actions.addtocart.remote.params.cartId,itemId);

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
     
  
    get isTelevent(){
      let enabled; 
    if (this.typeparcour === 'Televente' && this.televenteprofil==true) {
      enabled = true;
  } else {
    enabled = false;
  }
  console.log('Valeur de isTelevent :', enabled);
          return enabled;
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
          this.getCartItem(orderId,itemId)

        })
        .catch(error => {
          this.isLoading = false;
          this.displayConfiguration(this.displayedConfig);
          console.error('updateItemAttribute_call_putCartsItems_error ' + error);
        });
    }

 

    handleItemAttributesWithoutImei(event) {
  
      this.isLoading = true;
      let updatedItem = event.detail.item;
      let updatedItemAttribute = event.detail.attributeItem;
      let itemId = updatedItem.Id.value;
      let oldItems = JSON.parse(JSON.stringify(this.vlccart));
      let oldItemsRecords = oldItems.records;
      let changedItemsRecords = oldItemsRecords.map(function (itemOccur) {
        if (itemOccur.Id.value === itemId) return updatedItem;
        else return itemOccur;
      });
      oldItems.records = changedItemsRecords;
      this.vlccart = JSON.parse(JSON.stringify(oldItems));
      this.updateItemAttributeWithoutImei(updatedItemAttribute);
    }

    updateItemAttributeWithoutImei(updatedItemAttribute) {
      this.isLoading = true;
      let items = {};
      items.records = [];
      items.records.push(updatedItemAttribute);

  
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
           this.getCartItemWithoutImei(orderId,itemId)

        })
        .catch(error => {
          this.isLoading = false;
           this.displayConfiguration(this.displayedConfig);
          console.error('updateItemAttribute_call_putCartsItems_error ' + error);
        });
    }
  
    getCartItemWithoutImei(cartId, itemId) {
      const inputParams = {
          cartId: cartId,
          id: itemId,
          price: false,
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
                  let saveObj = {
                      "vlcCart": JSON.parse(JSON.stringify(response.result))
                  }
                 // this.updateOngoing = false;
                  this.omniApplyCallResp(saveObj);
                  this.dispatchEvent(
                      new ShowToastEvent({
                          title: 'Success',
                          message: 'Mise à jour réussie',
                          variant: 'success'
                      }),
                  );
              } else {
                //  this.updateOngoing = false;
                  this.dispatchEvent(
                      new ShowToastEvent({
                          title: 'Erreur',
                          message: 'Erreur lors de la mise à jour',
                          variant: 'error'
                      }),
                  );
              }
              this.isLoading = false;
              console.log("isLoading mis à false");
          })
          .catch(error => {
              console.error('getCartItem_error' + error);
          });
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
    
    // ADDED BY SBOUT 11/25/2024 START
    // handleRIOCodeInvalid(event) {
    //   console.log('Received RIO code invalid event:', event.detail.message);
    //   this.isStepForwardEnabled = true;
    // }

    // handleRIOCodeValid(event) {
    //     console.log('Received RIO code valid event:', event.detail.message);
    //     this.isStepForwardEnabled = false;
    // }
    // // ADDED BY SBOUT 11/25/2024 END

    // handlecustomitemattribvaluechangewithnext(event) {
    //   let nextStep = event.detail.nextStep;
    //   if (nextStep) {
    //     this.omniNextStep();
    //   }
    // }
  


    
    getCartItem(cartId, itemId) {
      const inputParams = {
        cartId: cartId,
        id: itemId,
        price: false,
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
            let saveObj = {
              "vlcCart": JSON.parse(JSON.stringify(response.result))
            }
            console.log(" Amine Brm Televente");
            //this.updateOngoing = false;
            this.omniApplyCallResp(saveObj);
            this.dispatchEvent(
              new ShowToastEvent({
                title: 'Success',
                message: 'Success',
                variant: 'success'
              }),
            );
          } else {
            //this.updateOngoing = false;
            this.dispatchEvent(
              new ShowToastEvent({
                title: 'Erreur',
                message: 'Erreur lors de la mise à jour',
                variant: 'error'
              }),
            );
          }
          this.setErroredAttributes();
        this.isLoading = false;
        this.displayConfiguration(this.displayedConfig);
        })
        .catch(error => {
          this.isLoading = false;
          this.displayConfiguration(this.displayedConfig);
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




    CheckArticleCodeAvailabilityInSAP() {
      console.log('This is the current item:', this.__item);

      
      // Vérifiez si __item et records sont bien définis
      if (this.__vlccart && this.__vlccart.records && this.__vlccart.records.length > 0) {
        let input = '{"orderId": "'+ this.__vlccart.records[0].OrderId.value+'"}';

        console.log('Input code Article SAP:', input);
  
          const params = {
              input: input,
              sClassName: `${this._ns}IntegrationProcedureService`,
              sMethodName: 'Inwi_InwiB2C_CheckArticleCodeAvailabilitySAP', 
              options: '{}',
          };
  
          this._actionUtilClass
          .executeAction(params, null, this, null, null)
          .then(response => {
              console.log('Response from SAP:', response);
  
          // const articles = response.result.IPResult.articles;
          // const hasAvailableQuantity = articles.some(article => article.isAvailable === true));

              const articles = response.result.IPResult.articles;
              console.log('Articles:', articles);
              const allAvailableQuantity = articles.every(article => article.isAvailable === true);
  
              if (response.error === false) {
                  if (allAvailableQuantity) {
                      this.dispatchEvent(
                          new ShowToastEvent({
                              title: 'Succès',
                              message: 'Tous les codes articles sont disponibles Sur SAP',
                              variant: 'success'
                          })
                      );
                      this.omniNextStep();
                  } else {
                      this.dispatchEvent(
                          new ShowToastEvent({
                              title: 'Erreur',
                              message: 'Les codes articles ne sont pas disponibles Sur SAP',
                              variant: 'error'
                          })
                      );
                  }
              } else {
                  this.dispatchEvent(
                      new ShowToastEvent({
                          title: 'Erreur',
                          message: 'Une erreur s\'est produite lors de la vérification des codes articles sur SAP',
                          variant: 'error'
                      })
                  );
              }
          })
          .catch(error => {
              console.error('Error during SAP check:', error);
          });
      } else {
          console.error('Invalid item structure:', this.__item);
      }
  }
  


}