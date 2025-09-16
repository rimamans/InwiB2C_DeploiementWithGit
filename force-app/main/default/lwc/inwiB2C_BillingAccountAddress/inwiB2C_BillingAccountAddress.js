import { LightningElement, api, track } from 'lwc';
  import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
  import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
  import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

  import template from './inwiB2C_BillingAccountAddress.html';

  export default class InwiB2C_BillingAccountAddress extends OmniscriptBaseMixin(LightningElement) {
   
    @track r ;
    @track v ;
    @track q ;
  PaysValues = [];
  valuePays = [];
  pq=[];
  RegionValues = [];
  VilleValues = [];
  QuartierValues = [];
  isToSpecify = false;
  showother = true;
  _ns = getNamespaceDotNotation();
  __pays;
  __ville;
  __quartier;
  __postalcode;
  __complementaddresse;
  __region;
  __pquartier;
  __actionType;
  __accountId;
 
  @api
  set pays (value){
      this.__pays = value;

  }
  get pays (){
      
      return this.__pays;
  }

  @api
  set ville (value){
      this.__ville = value;

  }
  get ville (){
      return this.__ville;
  }

  @api
  set quartier (value){
      this.__quartier = value;

  }
  get quartier (){
      return this.__quartier ;
  }

  @api
  set region (value){
      this.__region = value;

  }
  get region (){
      return this.__region;
  }

  @api
  set pquartier (value){
      this.__pquartier = value;

  }
  get pquartier (){
      return this.__pquartier;
  }
  

  @api
  set postalcode (value){
      this.__postalcode = value;

  }
  get postalcode (){
      return this.__postalcode;
  }
  

  @api
  set complementaddresse (value){
      this.__complementaddresse = value;

  }
  get complementaddresse (){
      return this.__complementaddresse;
  }
  connectedCallback() {
    // console.log("input1" +this.pays)
    this.omniUpdateDataJson({ "r": this.r });

    this.r=this.region;
    this.v=this.ville;
    this.q=this.quartier;
    this.pq=this.pquartier;
    this.codepostal=this.postalcode;
    this.complementaddress=this.complementaddresse;

    this.omniUpdateDataJson({ "CityName": this.ville });
    this.omniUpdateDataJson({ "Quartier": this.quartier });
    this.omniUpdateDataJson({ "RegionName": this.region });
    this.omniUpdateDataJson({ "CodePostale": this.postalcode });
    this.omniUpdateDataJson({ "complementaddress": this.complementaddresse });

      if (this.PaysValues.length == 0) {
      
        

          let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Pays__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'

          this.fetchPicklistValues('pays', inp)


      }
    
      this.valuePays = this.PaysValues.find(x => x.label === this.pays);
     // this.r = this.VilleValues.find(x => x.label === this.region);
     this.v = this.VilleValues.find(x => x.label === this.ville);
           console.log("RegionValues" +this.r);
    /*    if (this.RegionValues.length == 0) {
          //  console.log("test12 " +this.v)
  
            let inputregion ='{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Region__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}';
            
            this.fetchPicklistValues('region', inputregion)
        }*/
      if (this.VilleValues.length == 0) {
        //  console.log("test12 " +this.v)

          let inputVille = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'
          this.fetchPicklistValues('ville', inputVille);
      }
    if (this.QuartierValues.length == 0) {
   let inputVille = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'

  this.fetchPicklistValues('quartier', inputVille);
  this.isToSpecify = false;

    }
  
    
  }
  setRegionInfo(idVille) {
    let input = '{"theId": "' + idVille + '"}';
    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_getInfoCity",
      options: input,
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
      
        if (response.error == false) {
        
          
          this.r = response.result.IPResult.theCity.RegionName;
         
      
          this.template.querySelector(`[data-theid="Region"]`).value =
            response.result.IPResult.theCity.RegionName;
          this.omniUpdateDataJson({
            RegionId: response.result.IPResult.theCity.RegionId,
          });

          this.omniUpdateDataJson({
            PaysName: response.result.IPResult.theCity.PaysName,
          });
          this.omniUpdateDataJson({
            RegionName: response.result.IPResult.theCity.RegionName,
          });
          this.omniUpdateDataJson({
            CityName: response.result.IPResult.theCity.CityName,
          });
          this.omniUpdateDataJson({
            QuartierName: response.result.IPResult.theCity.QuartierName,
          });
        }
      })
      .catch(error => {
        console.log("error: " + error);
      });
    }
   
      ChangePays(event) {
       
          this.omniUpdateDataJson({ "Pays": event.detail.value });
          this.omniUpdateDataJson({ "IdVille": this.ville });
          this.omniUpdateDataJson({ "IdRegionP": this.region });
          let labelSelected = this.valuePays.find(opt => opt.value === event.detail.value).label;
          this.omniUpdateDataJson({ "CodePostale":this.codepostal });
          this.omniUpdateDataJson({ "complementaddress":this.complementaddress });
         


          





     
          this.omniUpdateDataJson({ "PaysName":labelSelected });



          if (labelSelected == 'Maroc') {
            this.omniUpdateDataJson({ "CodePostale":this.codepostal });
            this.omniUpdateDataJson({ "complementaddress":this.complementaddress });
           
              this.showother = true;
              this.template.querySelector(`[data-theid="Region"]`).style.display = "block"
              this.template.querySelector(`[data-theid="Ville"]`).style.display = "block"

              if(this.template.querySelector(`[data-theid="Quartier"]`)!=null)
                  this.template.querySelector(`[data-theid="Quartier"]`).style.display = "block"
              if(this.template.querySelector(`[data-theid="PrecisionQuartier"]`)!=null)
                  this.template.querySelector(`[data-theid="PrecisionQuartier"]`).style.display = "block"

          } else {

             
              this.omniUpdateDataJson({ "Region": "null" });
              this.omniUpdateDataJson({ "Ville": "null" });
              this.omniUpdateDataJson({ "Quartier": "null" });
              this.omniUpdateDataJson({ "PrecisionQuartier": "" });
              this.omniUpdateDataJson({ "RegionName": "null"  });
              this.omniUpdateDataJson({ "CityName": "null"  });

              this.QuartierValues = [];

              this.template.querySelector(`[data-theid="Region"]`).value = 'sélectionnez une region';
              this.template.querySelector(`[data-theid="Ville"]`).value = '';

              this.template.querySelector(`[data-theid="Ville"]`).placeholder = 'sélectionnez une ville';         
              
              this.template.querySelector(`[data-theid="Region"]`).style.display = "none"
              this.template.querySelector(`[data-theid="Ville"]`).style.display = "none"
              

              if(this.template.querySelector(`[data-theid="Quartier"]`)==null){
                  this.template.querySelector(`[data-theid="PrecisionQuartier"]`).style.display = "none"
                  this.template.querySelector(`[data-theid="PrecisionQuartier"]`).value = null;

              }else{
                  this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une quartier';
                  this.template.querySelector(`[data-theid="Quartier"]`).style.display = "none"
                  this.template.querySelector(`[data-theid="Quartier"]`).value = null;
              }


          }

     
      }


      ChangeRegion(event) {
   
      
        this.omniUpdateDataJson({ 'RegionId': event.detail.value });
        this.omniUpdateDataJson({ Ville: "null" });
        this.omniUpdateDataJson({ Quartier: "null" });
    
        this.VilleValues = [];
        this.QuartierValues = [];
        this.template.querySelector(`[data-theid="Ville"]`).placeholder =
          "sélectionnez une ville";
        this.template.querySelector(`[data-theid="Quartier"]`).placeholder =
          "sélectionnez une ville";
    
     
    
        let inp =
          '{"MapItems":[{"DomainObjectFieldAPIName__c":"Villes","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Region Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"InwiB2C_Region__c","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Villes:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Villes:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Region Name":"' +
          event.detail.value +
          '"}}';
    
        this.fetchPicklistValues("ville", inp);
      
      }
      ChangeVille(event) {
      
          this.omniUpdateDataJson({ "IdVille": this.v });
          this.omniUpdateDataJson({ "Quartier": "null" });
          this.omniUpdateDataJson({ "PrecisionQuartier": "" });
          this.omniUpdateDataJson({ "RegionName": "null"  });
          this.omniUpdateDataJson({ "CityName": "null"  });
         
        
          this.omniUpdateDataJson({ "Ville": event.detail.value });
          let selectedvilleId = event.detail.value;
        
          this.QuartierValues = [];
           this.setRegionInfo(selectedvilleId);
       
          this.v = selectedvilleId;
         
      
        
          let inp =
            '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' +
            selectedvilleId +
            '"}}';
    
          this.fetchPicklistValues("quartier", inp);
     
      }

      
       
      ChangeQuartier(event) {
        //  console.log('ChangeQuartier')

          this.omniUpdateDataJson({ "Quartier": event.detail.value });
          let selectedQuartierId = event.detail.value;
          this.omniUpdateDataJson({ "Quartier": selectedQuartierId });
          //  //console.log('changing region values')
      }
      ChangePrecisionQuartier(event) {
          this.omniUpdateDataJson({ "PrecisionQuartier": event.detail.value });
      }
      handleChangeInput(event) {
          
          this[event.target.name] = event.target.value;
          this.omniUpdateDataJson({ "CodePostale":this.codepostal });
          this.omniUpdateDataJson({ "complementaddress":this.complementaddress });
        }
      fetchPicklistValues(picklist, input) {

        
          this._actionUtilClass = new OmniscriptActionCommonUtil();

          const params = {
              input: input,
              sClassName: 'vlocity_cmt.DefaultFetchPicklistOptionsImpl',
              sMethodName: 'fetchLookupOptions',
              options: '{}',
          };

          this._actionUtilClass
              .executeAction(params, null, this, null, null)
              .then(response => {
                
                  let rs = [];
                
                  if (Object.keys(response.result.options).length == 0) {
                      let v = {
                        label: "Aucun élément",
                        value: "null",
                      };
                    

                      rs.push(v);
                  

                  }
                  else {
                      rs = response.result.options.map((element) => {
                          let temp = {}
                          temp['label'] = element.value;
                          temp['value'] = element.name;
                          return temp;
                      });
                  }

                  if (picklist === 'pays') {

                 
                      this.PaysValues = rs;
                 

                      let indexMaroc = this.PaysValues.findIndex(x => x.label === this.pays);

                     this.omniUpdateDataJson({ "IdMaroc": this.PaysValues[indexMaroc].value });
                      this.omniUpdateDataJson({ "IdVille": this.v });
                      if(!this.p) {
                          this.omniUpdateDataJson({ "Pays": this.PaysValues[indexMaroc].value });
                          this.omniUpdateDataJson({ "PaysName":'Maroc' });
                          this.omniUpdateDataJson({ "IdVille": this.v });
                          this.omniUpdateDataJson({ "IdRegion": this.RegionName });

                      }

        
                      if (this.valuePays == null)
                          this.valuePays = this.PaysValues[indexMaroc].value;
                      this.IdMaroc = this.PaysValues[indexMaroc].value;

                      this.PaysValues.splice(0, 0, this.PaysValues.splice(indexMaroc, 1)[0]);


                  }
                 else if (picklist === 'Region') {  
                  this.RegionValues = rs; 
               //   this.r = this.RegionValues.find(x => x.label === this.region).value;
                   
                  this.omniUpdateDataJson({ "regioniddd": this.r });
                         
                }
                  else if (picklist === 'ville') {       
                    this.VilleValues =rs;
                    let t =  rs.sort(function(a, b) {
                          var nameA = a.label.toUpperCase(); // ignore upper and lowercase
                          var nameB = b.label.toUpperCase(); // ignore upper and lowercase
                          if (nameA < nameB) {
                            return -1;
                          }
                          if (nameA > nameB) {
                            return 1;
                          }
                        
                          // names must be equal
                          return 0;
                        });

                     

                        this.v = this.VilleValues.find(x => x.label === this.ville).value;
            
                        this.omniUpdateDataJson({ "villeidd": this.v });
                      
                  }
                  
                  else if (picklist === 'quartier') {

                  // this.q=this.quartier;
             //     this.QuartierValues = rs;
                  //   console.log('QuartierValues 22'+this.QuartierValues);
                  //   console.log('quartier q'+this.quartier);
 
                  //   this.q = this.QuartierValues.find(x => x.label === this.quartier).value;
                   //  console.log('QuartierValues q'+this.q);
                       this.QuartierValues = rs;
                   //    console.log('QuartierValues 22'+this.QuartierValues);
 
                       if(this.QuartierValues[0].value =='null'){
                           this.isToSpecify = true;
                           this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'Aucun élément à selectionner ';
                           this.omniUpdateDataJson({ "Quartier": "null" });
                          
                       }
                       if(this.QuartierValues.length !=1 ){
                           this.isToSpecify = false;
                           this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez un quartier ';
                       }
                     //  this.q = this.QuartierValues.find(x => x.label === this.quartier).value;
                    //   console.log('QuartierValues q'+this.q);
                       this.omniUpdateDataJson({ "quariteridd": this.q });
                   }
 

                 

              })
              .catch(error => {
                  console.log('error : ' + error);
              });


      }
  


      value = 'inProgress';

      get options() {
          let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Pays__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'

          this.fetchPicklistValues('pays', inp)
          return inp;
        //  return [
            //  { label: 'New', value: 'new' },
            // { label: 'In Progress', value: 'inProgress' },
              //{ label: 'Finished', value: 'finished' },
        // ];
      }

      handleChange(event) {
          this.value = event.detail.value;
         
           
      }

  }