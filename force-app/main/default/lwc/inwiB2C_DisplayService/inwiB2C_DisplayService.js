import { LightningElement, api, track,wire} from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_DisplayService.html";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class inwiB2C_DisplayService   extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {
//@api recordid;
stepAd=false;
idadress;
step=false;
datainfo;
city;
__data2 = [];
__dataSortName=[];

visibilityArray = [];
dataPlaqueResult=[];//CHB B-10015 ano 21/06/2023 
search='';
eligible=false;
nodataplaque=true;
    loading=false;
    __hasError = false;
    _ns = getNamespaceDotNotation();
    __data = [];
    __dataEligible=[];
    __datplaque = [];
    _actionUtilClass;
    __showAddAccount = false;
    idrec='';
    value;
    selectedrec;
    message='Non eligible';
    @api
    get accountid() {
        return this.__accountid;
    }
    set accountid(value) {
        this.__accountid = value;
    }
    
    connectedCallback() {
				this.valuestatus = this.options[0].value;
      console.log('accountid',this.accountid);
        this._actionUtilClass = new OmniscriptActionCommonUtil();
           
        let input ='{"AccountId": "'+this.accountid+'"}';
        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "inwib2c_InwiB2C_GetRecordServiceAccount",
            options: "{}"
        };
        this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
            console.log('response1',response);
            if (!response.error) {
                console.log("response.result.IPResult.listservice",response.result.IPResult.listservice);
               this.datainfo=false;
               
                 if (response.result.IPResult && response.result.IPResult.listservice) {
                    this.datainfo=true;
                    this.__showAddAccount = false;
                    let dataResult = response.result.IPResult.listservice;
                    let data = [];
                    dataResult.map((item, index) => {
                        console.log(dataResult.length == 1);
                        item.index = index;
                        item.checked = dataResult.length == 1;
                        data.push(item);
                    })
                    this.__data = data;
										this.__data2 = data;
										this.__data = this.__data2.filter(item => item.Eligibilite == 'Oui' );
                    console.log("data",this.__data);
                    if(this.__data==null){
                        console.log("vide pas de data");
                    }
                } 
                
                else {
                    this.__data = [];
                    this.__showAddAccount = true;
                }
            }
        })
        .catch(error => {
            window.console.log(error);
        });
}


handleSelectedAccounts(event){
  //lightning-combobox
this.eligible=false;
  this.value=event.target.dataset.value;
  this.idrec = event.target.dataset.idline;
  this.loading=true;
  this.city=event.target.dataset.city;
  console.log("element");
  this.omniUpdateDataJson({ "AccountIdService": this.idrec });
  this.__dataplaque=[];
 console.log("Idrec" +this.idrec);



/* this.template.querySelectorAll('lightning-combobox').forEach(item=>{
  const element = this.visibilityArray.find(el => el.index === item.dataset.Id)

  console.log("element");
  console.log(value);
  console.log(item);
  console.log(this.visibilityArray)
 })*/
}
/*
appelAPI(){
  this._actionUtilClass = new OmniscriptActionCommonUtil();
           
  let input ='{"AccountId": "'+this.idrec+'"}';
  const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_Check_FO_Eligibilite",
      options: "{}"
  };
  this._actionUtilClass
  .executeAction(params, null, this, null, null)
  .then(response => {
      console.log('responseEligi',response.result.IPResult.CheckEligibilite);
this.step=false;
this.stepAd=false;
      if (!response.error) {
        console.log('Eligible data ',response.result.IPResult.CheckEligibilite);   
            
          if (response.result.IPResult.CheckEligibilite=="Eligibile") {
             // this.__showAddAccount = false;
            // this.message='Eligible';
             this.eligible=true;
             this.loading=false;
          //   this.dispatchEvent(selectedEvent); 
         /* const selectedEvent = new CustomEvent("eligible", {
            detail : detailParam
          });
        this.dispatchEvent(selectedEvent);*/
           /*
            let dataResult = response.result.IPResult.serviceQualification;
             console.log('response service ',dataResult);
              let dataEligible = [];
              dataResult.map((itemE, index) => {
                  console.log(dataResult.length == 1);
                  itemE.index = index;
                  console.log('index ',index);
                  itemE.checked = dataResult.length == 1;
                  dataEligible.push(itemE);
              })
              this.__dataEligible = dataEligible;
             // this.appelAPIPlaque();
              this.showMessage('Succès', 'Eligible.', 'success');
           
          } else {
           
            this.showMessage('Erreur', 'Non Eligible', 'error');
           
          }
      }
  })
  .catch(error => {
      window.console.log(error);
  });
}*/
handleChangeSearch(event){
  this.search=event.target.value;
  console.log("search",this.search);
  this.__dataplaque=this.dataPlaqueResult;
  if(this.search!='' || this.search!=null){
      this.__dataplaque=this.__dataplaque.filter(element => element.name.includes(event.target.value.toUpperCase()) );
  }
  
}
appelAPIPlaque(){
  //this.eligible=true;
  this._actionUtilClass = new OmniscriptActionCommonUtil();
  this.loading=false;
  let input ='{"city" :"'+this.city+'" }';
 
  console.log('input: '+input);
  const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
    sMethodName: "inwib2c_Get_Plaque_NRAApigee",
      options: "{}"
  };
  this._actionUtilClass
  .executeAction(params, null, this, null, null)
  .then(response => {
    console.log('responseplaque',response);
            if (!response.error && response.result.IPResult && response.result.IPResult.input ) {
                //if (response.result.IPResult && response.result.IPResult.input ) {
                 
                    //this.__showAddAccount = false;
                    let dataResultplaque = response.result.IPResult.input;
                    let dataplaque = [];
                    dataResultplaque.map((item, index) => {
                        console.log(dataResultplaque.length == 1);
                        item.index = index;
                        item.checked = dataResultplaque.length == 1;
                        dataplaque.push(item);

                    })
                   this.__dataplaque = dataplaque;
                   this.dataPlaqueResult= this.__dataplaque;
                    this.__datplaque.sort(function (a, b) {
                      if (a.name < b.name) {
                        return -1;
                      }
                      if (a.name > b.name) {
                        return 1;
                      }
                      return 0;
                    });
									
                    console.log("data",this.__dataplaque);
                    this.nodataplaque=false;
                    this.eligible=true;
               // } 
            }else {
              this.__dataplaque = [];
              console.log('else');
              //this.__showAddAccount = true;
              this.showMessage('Erreur', 'Site non éligible, aucune plaque n\'est retournée.', 'error');
              this.eligible=true;
              //this.nodataplaque=true;
          }
        })
  .catch(error => {
      window.console.log(error);
  });
}

get options() {
    return [
        { label: 'Oui', value: 'true' },
        { label: 'Non', value: 'false' },
        
    ];
}

handleChangestatus(event) {
    this.value = event.detail.value;
   console.log("type",typeof this.value);
		if (this.value ==='true'){
         this.__data = this.__data2.filter(item => item.Eligibilite == 'Oui' );
		}else{
				this.__data = this.__data2.filter(item => item.Eligibilite == 'Non' );
	

		}

		console.log("data",this.__data);

}

handleSelectPlaque(event){
  console.log('city: ' + event.target.dataset.city);
        console.log('referredtype: ' + event.target.dataset.referredtype);
        console.log('name: ' + event.target.dataset.name);
        console.log('vendor: ' + event.target.dataset.vendor);
  this.idadress = event.target.dataset.idline;
  console.log('adressId: ' + this.idadress);
  this.stepAd=true;
  let selectedInfo = { 
    "city" : event.target.dataset.city,
    "referredtype" : event.target.dataset.referredtype,
    "name" : event.target.dataset.name,
   "vendor" : event.target.dataset.vendor,
    "statut": event.target.dataset.statut
}
this.step=true;
this.omniUpdateDataJson(selectedInfo);
this.omniSaveState(selectedInfo,true);
}
handleSelectAdress(event){
 
  this.idadress = event.target.dataset.idline;
  console.log('adressId: ' + this.idadress);
  let selectedInfoAdressSite = { 
    "idAdress" :event.target.dataset.idline,
    "city" : event.target.dataset.city,
    "region" : event.target.dataset.region,
    "sroid" : event.target.dataset.sroid,
    "nroid" : event.target.dataset.nroid
}
this.omniUpdateDataJson(selectedInfoAdressSite);
this.omniSaveState(selectedInfoAdressSite,true);
this.stepAd=true;

}


next(event) {
    //console.log('ChangeQuartier')
   

    this.omniNextStep();

    }
    
    //  //console.log('changing region values')
  /*
  gotopreviousStep() {
    this.omniPrevStep();

  }
  selectItem(event) {
    let Id = event.target.name;
    let status = event.target.status;
    if (status) {
        let data = [...this.__data];
        data.map(item => {
            item.checked = false;
            return item
        });
        this.__data = data;
    } else {
        let data = [...this.__data];
        data.map(item => {
            if (Id == item.index) {
                item.checked = true;
            } else {
                item.checked = false;
            }
            return item
        });
        this.__data = data;
        console.log(data)
    }

}
SaveAndNext(evt) {
    console.log("save")
    let selected = this.__data.filter(item => {
        return item.checked;
    });

    if (selected.length > 0) {
        this.__hasError = false;
        this.saving = true;
        const selectedAccount = selected[0];

        this.omniApplyCallResp({ selectedConsumerAccount: selectedAccount });
        this.omniNextStep();


     
    } else {
        this.__hasError = true;
    }
}



  render() {
    //console.log(this.omniJsonData);
    return template;
  }

  strName;
  strAccountNumber;
  strPhone;
  // Change Handlers.
/*
  gotopreviousStep() {
    this.omniPrevStep();

  }*/
  showMessage(t, m, type) {
    const toastEvt = new ShowToastEvent({
        title: t,
        message: m,
        variant: type
    });
    this.dispatchEvent(toastEvt);
};
handleCancel(event){ 
  this.omniUpdateDataJson({ "annuler":true});
  this.omniNextStep();}

  sortRecs( event ) {

    let colName = event.target.name;
    console.log( 'Column Name is '+ colName );
  }

}