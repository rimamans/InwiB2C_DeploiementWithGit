import { LightningElement, api,track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class InwiB2C_TpePayment extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    __amount;
    __posid;
    __orderid;
    __tpeautho;
    __ecrDateTime;
    __paymenttype;
    __ecrStan;
    
    tpeList = [{
        "terminal_id": "Manuel",  
        "cardType": "",
        "bankName": ""

    }]
    ;

    //<!--   B-32051 Meryem Yahya -->
    cardOptions = [
    { label: 'Local', value: 'Local' },
    { label: 'Internationale', value: 'Internationale' }
    ];

    //<!--   B-32051 Meryem Yahya -->

    @track cardType = '';
    @track bankName = '';

        
    duplicateList =[];

    selectedTPE;

    paymentId;

    __transactionNumber;

    updateOngoing = false;
    
    tpeSelected= false;
    initDone = false;
    checkDone = false;
    duplicateStep=false;
    @track __isModalOpenDuplicate = false;
    @track isConform = false;

    @api
    get isModalOpenDuplicate (){
        return this.__isModalOpenDuplicate;
    }
    set isModalOpenDuplicate(value){
        this.__isModalOpenDuplicate = value;
    }
    @api
    get amount (){
        return this.__amount;
    }
    set amount(value){
        this.__amount = value;
    }
    @api
    get paymenttype (){
        return this.__paymenttype;
    }
    set paymenttype(value){
        this.__paymenttype = value;
    }

    @api
    get posid(){
        return this.__posid;
    }
    set posid(value){
        this.__posid = value;
    }

    @api
    get orderid(){
        return this.__orderid;
    }
    set orderid(value){
        this.__orderid = value;
    }

    @api
    get tpeautho(){
        return this.__tpeautho;
    }
    set tpeautho(value){
        this.__tpeautho = value;
    }

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('this.tpeautho  '+this.tpeautho);

        if (this.tpeautho)
        {
            console.log('TPE AUTH : '+ this.tpeautho);
            this.getPosTPE();
        }
    }

    get tpeColumns(){

        
        /*return [
            { label: 'Identifiant Terminal TPE', hideDefaultActions: true, fieldName: 'terminal_id',initialWidth: 150 },
            { label: 'Index Terminal', hideDefaultActions: true, fieldName: 'terminal_index'}
        ];*/

        return [
            { label: 'Identifiant Terminal TPE', hideDefaultActions: true, fieldName: 'terminal_id'}
        ];
        

    }

    initializePayment() {
        // Include cardType and bankName in your API call payload
        const payload = {
            terminalId: this.selectedTPE.terminal_id,
            transactionNumber: this.transactionNumber,
            cardType: this.cardType,
            bankName: this.bankName
        };
        // Make API call
    }

    getPosTPE(){
        let input = '{"posId": "' + this.posid+  '"}';
        // let input = '{"posId": "CPD01"}';

        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_inwiB2C_getPosTPE',
            options: '{}',
        };

        console.log('before call inwib2c_inwiB2C_GetModelWithPrice' + params);
        
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                if (response.error == false) {
                    //console.log(response);

                    // if (response.result && response.result.IPResult.result) {
                    //     console.log('AmineBrm'+response.result.IPResult);
                    //     console.log(JSON.stringify(response.result.IPResult.result));
                    //     JSON.parse(JSON.stringify(response.result.IPResult.result));
                    //    let res=response.result.IPResult.result;
                    //     console.log('res' +res);

                    //     this.tpeList = this.tpeList.concat(response.result.IPResult.result);
                    // }

                    if (response.result && response.result.IPResult && response.result?.IPResult?.success !== false ) {
                        
                        this.tpeList = this.tpeList.concat(response.result.IPResult);
                    }
                }else {
                    console.log('Erreur lors de la récupération de la liste des TPE');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la récupération de la liste des TPE',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });
    }

    handleChangeTPE(event) {
        event.stopPropagation();
        const selectedRows = event.detail.selectedRows;

        if (selectedRows.length > 0){
            this.selectedTPE = selectedRows[0];
            this.tpeSelected = true;

            console.log(this.selectedTPE);
        }
    }

    initializePayment(event){
        event.stopPropagation();

        this.updateOngoing = true;

        this.paymentId = this.uuidv4();

        let input = '{"input":{ "action": "INIT", "it_vendor_id": "'+ this.selectedTPE.vendor_id +'", "outlet_id": "'+ this.selectedTPE.outlet_id +'", "terminal_id": "'+ this.selectedTPE.terminal_id + '", "ecr_number": "1", "amount": "' + this.amount + '", "currency": "504", "pay_kind": "0", "additonal_field_01": "'+ this.orderid +'", "additonal_field_02": "'+ this.paymenttype +'", "additonal_field_03": "true" }}';

        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_inwiB2C_pCardPayment',
            options: '{}',
        };

        console.log('before call inwiB2C_pCardPayment INIT' + params);
        
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                
                this.updateOngoing = false;
                console.log((response));
                if (response.error == false) {
                    console.log(response);
                    if (response.result && response.result.IPResult) {
                        

                        if (response.result.IPResult.response_code && response.result.IPResult.response_code == "OK"){
                            this.initDone = true;
                            //this.transactionNumber=response.result.IPResult.trx_uid;
                        }else {

                            console.log('Erreur lors de l\'initialisation du paiement');

                            if(response.result.IPResult.result){

                                if(response.result.IPResult.result.code=='API-001' && response.result.IPResult.result.message== 'Paiement dupliqué.'){
                                    this.initDone = true;
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                        title: response.result.IPResult.result.message,
                                        message:  'Paiement déjà initié, veuillez vérifier le paiement.',
                                        variant: 'warning'
                                        }),
                                    );
                                }
                                else{
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                        title: 'Erreur, ' + response.result.IPResult.result.code,
                                        message: 'Erreur lors de l\'initialisation du paiement, ' + response.result.IPResult.result.message,
                                        variant: 'error'
                                        }),
                                    );
                                }
                            }else{
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Erreur lors de l\'initialisation du paiement, veuillez réessayer.',
                                    variant: 'error'
                                    }),
                                );

                            }

                        

                        }
                        
                    }
                }else {
                    
                    console.log('Erreur lors de l\'initialisation du paiement');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de l\'initialisation du paiement, veuillez réessayer.',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });
    }

    checkPayment(event){
        event.stopPropagation();

        this.updateOngoing = true;

        let input = '{"input":{ "action": "CHECK", "it_vendor_id": "'+ this.selectedTPE.vendor_id +'", "outlet_id": "'+ this.selectedTPE.outlet_id +'", "terminal_id": "'+ this.selectedTPE.terminal_id + '", "ecr_number": "1", "amount": "' + this.amount + '", "currency": "504", "pay_kind": "0", "additonal_field_01": "'+ this.orderid +'", "additonal_field_02": "'+ this.paymenttype +'", "additonal_field_03": "true" }}';

        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_inwiB2C_pCardPayment',
            options: '{}',
        };

        console.log('before call inwiB2C_pCardPayment CHECK' + params);
        
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                this.updateOngoing = false;

                if (response.error == false) {
                    console.log(response);

                    if (response.result && response.result.IPResult) {

                        if (response.result.IPResult.response_code && response.result.IPResult.response_code == "OK"){
                            this.checkDone = true;
                            this.transactionNumber=response.result.IPResult.trx_uid;
                            if(this.paymenttype == 'total')
                              this.omniApplyCallResp({transactionCode:this.transactionNumber});
                            else
                             this.omniApplyCallResp({transactionCodeCaution:this.transactionNumber});

                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Succès',
                                message: 'Le paiement a bien été effectué',
                                variant: 'succes'
                                }),
                            );
                           
                        }else {

                            ////////////////////////pour test suivant///////////////c/inwiB2C_DisplayItem
                         
                            console.log('Erreur lors de la verification du paiement');

                            if(response.result.IPResult){
                                if (response.result.IPResult.response_code && response.result.IPResult.response_code == "KO_CWD") {
                                    this.duplicateStep = true;
                                    
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                        title: 'Erreur, ' + response.result.IPResult.result.code,
                                        message: 'Merci de vérifier la conformité de l’opération avec le reçu édité sur le TPE.',
                                        variant: 'error'
                                        }),
                                    );
    
                                }

                                else {
                                    if (response.result.IPResult.response_code && response.result.IPResult.response_code == "FUNC_KO"){
                                         this.initDone = false;

                                    }
                                }
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur, ' + response.result.IPResult.result.code,
                                    message: 'Erreur lors de la vérification du paiement, ' + response.result.IPResult.result.message,
                                    variant: 'error'
                                    }),
                                );

                            }else{
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Erreur lors de la vérification du paiement, veuillez réessayer.',
                                    variant: 'error'
                                    }),
                                );

                            }

                        

                        }
                    }
                }else {
                    console.log('Erreur lors de la vérification du paiement');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la vérification du paiement',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
          
                window.console.log(error);
            });
    }

    uuidv4() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
          var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
          return v.toString(16);
        });
      }

    get displayInitPayment(){
        return this.tpeSelected && !this.initDone && (!this.selectedTPE || (this.selectedTPE && this.selectedTPE.terminal_id != 'Manuel'));
    }

    get displayCheckäyment(){
        return this.initDone && !this.checkDone;
    }
    get displayDuplicate(){
        return this.duplicateStep;
    }
    get displayPrevious(){
        return !this.initDone;
    }
    get disabledTransactionNumber(){
        return !(this.selectedTPE && this.selectedTPE.terminal_id == 'Manuel');
    }
    get DisplayFields(){
        return (this.selectedTPE && this.selectedTPE.terminal_id == 'Manuel');
    }
   
    get displayNext(){
        return (this.checkDone || (this.selectedTPE && this.selectedTPE.terminal_id == 'Manuel'));
    }

    get disableSave(){
        return !(this.transactionNumber != '' && this.transactionNumber != null);

    }
    get transactionNumber(){
        return this.__transactionNumber;
    }
    set transactionNumber(value){
        this.__transactionNumber=value;
        
        }

        

    hanldle__transactionNumber(event) {
        
           
            this.transactionNumber = event.detail.value;
     }
     gotopreviousStep(){
        this.omniPrevStep();
    }

    handleCardTypeChange(event) {
        this.cardType = event.detail.value;
        
    }

    handleBankNameChange(event) {
        this.bankName = event.detail.value;
        
    }

    next(event){
        if(this.paymenttype == 'total'){  
             let reponse = {
                transactionCode : this.transactionNumber,
                cardType: this.cardType,
                bankName: this.bankName,
                terminalId : this.selectedTPE.terminal_id
            }
            this.omniUpdateDataJson(reponse); //return val en data json
            this.omniSaveState(reponse,true);
        }else 
        {
            let reponse = {
                transactionCodeCaution : this.transactionNumber,
                cardType: this.cardType,
                bankName: this.bankName,
                terminalId : this.selectedTPE.terminal_id
            }
            this.omniUpdateDataJson(reponse);
            this.omniSaveState(reponse,true)

        }
        if(this.paymenttype == 'total')
           this.omniApplyCallResp({transactionCode:this.transactionNumber});
        else
            this.omniApplyCallResp({transactionCodeCaution:this.transactionNumber});

        this.omniApplyCallResp({PaymentReference:this.selectedTPE.terminal_id});
        this.omniApplyCallResp({ cardType: this.cardType });
        this.omniApplyCallResp({ bankName: this.bankName });
  
        this.omniNextStep();



    }

    @api checkValidity() { 
        console.log('in check validity');
        

        if (this.disableSave) {

            console.log('erreur next');

            if (this.tpeSelected){

                this.dispatchEvent(
                    new ShowToastEvent({
                    title: 'Erreur',
                    message: 'la référence de paiement est obligatoire.',
                    variant: 'error'
                    }),
                );

            }
            
            return false;
        } else {
            if(this.paymenttype == 'total'){
                this.omniApplyCallResp({transactionNumber:this.transactionNumber});
                this.omniApplyCallResp({PaymentReference:this.selectedTPE.terminal_id});
            }else{
                this.omniApplyCallResp({transactionCodeCaution:this.transactionNumber});
                this.omniApplyCallResp({PaymentReference:this.selectedTPE.terminal_id});
            }
    
            //this.omniNextStep();
            return true

        }

    }
    duplicateReceipt(event){
        event.stopPropagation();

        this.updateOngoing = true;

        let input = '{"input":{ "it_vendor_id": "'+ this.selectedTPE.vendor_id +'", "outlet_id": "'+ this.selectedTPE.outlet_id +'","ecr_date_time": "'+ this.__ecrDateTime +'", "terminal_id": "'+ this.selectedTPE.terminal_id + '", "ecr_number": "1", "additonal_field_01": "'+ this.orderid +'", "additonal_field_02": "'+ this.paymenttype +'" }}';

        console.log('input duplicate ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_inwiB2C_pCardDuplicate',
            //sMethodName: 'inwib2c_inwiB2C_pCardDuplicatebouchon',
            options: '{}',
        };

        console.log('before call inwiB2C_pCardDuplicate ' + params);
        
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                this.updateOngoing = false;
                if (response.error == false) {
                    console.log(response);
                    if (response.result && response.result.IPResult) {
                        if (response.result.IPResult.response_code && response.result.IPResult.response_code == "OK"){
                           console.log('response.result.IPResult  Duplicata'+ JSON.stringify(response.result.IPResult));
                           this.isModalOpenDuplicate = true;
                           this.duplicateStep=false;
                           console.log(' this.isModalOpenDuplicate   ', this.isModalOpenDuplicate);
                           this.__ecrStan=response.result.IPResult.paymentResponse.ecr_stan;
                           this.__ecrDateTime= response.result.IPResult.ecr_date_time;
                            

                        }else {

                            console.log('Erreur lors du duplicate du paiement '+response.result.IPResult.response_code);
                            if (response.result.IPResult.response_code && response.result.IPResult.response_code == "TECH_KO"){
                                this.initDone=true;
                                this.checkDone=false;
                                this.duplicateStep=false;
     
                             }else {
                                if (response.result.IPResult.response_code && response.result.IPResult.response_code == "FUNC_KO"){
                                    this.initDone=false;
                                    this.checkDone=false;
                                    this.duplicateStep=false;
                                    this.notconformHandle();

                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                        title: 'Erreur, ' + response.result.IPResult.result.code,
                                        message:  'Paiement init non présent sur BD.',
                                        variant: 'error'
                                        }),
                                    );
    
                                 }

                             }

                            /*if(response.result.IPResult.result){

                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur, ' + response.result.IPResult.result.code,
                                    message:  'Paiement init non présent sur BD'+response.result.IPResult.result.message,
                                    variant: 'error'
                                    }),
                                );

                            }else{
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Erreur lors de la demande d\'édition du duplicata du reçu de paiement sur le TPE, veuillez réessayer.',
                                    variant: 'error'
                                    }),
                                );

                            }*/

                        

                        }
                    }
                }else {
                    console.log('Erreur lors de la demande d\'édition du duplicata du reçu de paiement sur le TPE');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la demande d\'édition du duplicata du reçu de paiement sur le TPE',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });
    }
    conformHandle(event){
      //  this.updateOngoing = true;

        let input = '{"input":{ "action": "CONFORM", "it_vendor_id": "'+ this.selectedTPE.vendor_id +'", "outlet_id": "'+ this.selectedTPE.outlet_id +'", "terminal_id": "'+ this.selectedTPE.terminal_id + '", "ecr_number": "1", "amount": "' + this.amount + '", "currency": "504", "pay_kind": "0", "additonal_field_01": "'+ this.orderid +'", "additonal_field_02": "'+ this.paymenttype +'", "additonal_field_03": "true" }}';

        console.log('input  conform: ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_inwiB2C_pCardPayment',
            options: '{}',
        };

        console.log('before call Conform ' + params);
        
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                //this.updateOngoing = false;
                if (response.error == false) {
                    console.log(response);

                    if (response.result && response.result.IPResult) {
                        if (response.result.IPResult.response_code && response.result.IPResult.response_code == "OK"){
                       
                            this.checkDone = true;
                            this.transactionNumber=response.result.IPResult.trx_uid;
                            this.isModalOpenDuplicate=false;
                            if(this.paymenttype == 'total')
                                this.omniApplyCallResp({transactionCode:this.transactionNumber});
                            else
                                this.omniApplyCallResp({transactionCodeCaution:this.transactionNumber});
                      
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Succès',
                                message: 'Le paiement a bien été effectué',
                                variant: 'succes'
                                }),
                            );

                        }else{
                            console.log('Erreur lors la confirmation de paiement en TPE');
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Erreur lors la confirmation de paiement en TPE',
                                variant: 'error'
                                }),
                            );

                        }
                    }
                }else {
                    console.log('Erreur lors la confirmation de paiement en TPE');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors la confirmation de paiement en TPE',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });
    }
    notconformHandle(event){
        //this.updateOngoing = true;

       
        let input = '{"input":{ "action": "NOT_CONFORM", "it_vendor_id": "'+ this.selectedTPE.vendor_id +'", "outlet_id": "'+ this.selectedTPE.outlet_id +'", "terminal_id": "'+ this.selectedTPE.terminal_id + '", "ecr_number": "1", "amount": "' + this.amount + '", "currency": "504", "pay_kind": "0", "additonal_field_01": "'+ this.orderid +'", "additonal_field_02": "'+ this.paymenttype +'", "additonal_field_03": "true" }}';

        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_inwiB2C_pCardPayment',
            options: '{}',
        };

        console.log('before call NotConform ' + params);
        
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
               // this.updateOngoing = false;
                if (response.error == false) {
                    console.log(response);                    
                    if (response.result && response.result.IPResult) {
                        if (response.result.IPResult.response_code && (response.result.IPResult.response_code == "OK" || response.result.IPResult.response_code == "FUNC_KO")){
                       
                            this.checkDone = false;
                            this.initDone = false;
                            this.isModalOpenDuplicate=false;

                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Warning',
                                message: 'Le processus de paiement ou d’annulation doit commencer dès le début.',
                                variant: 'warning'
                                }),
                            );

                        }else{
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Erreur lors le refus de paiement en TPE',
                                variant: 'error'
                                }),
                            );

                        }
                    }
                }else {
                    console.log('Erreur lors le refus de paiement en TPE');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors le refus de paiement en TPE',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {

                window.console.log(error);
            });
    }
    closeModal(event){
        this.isModalOpenDuplicate=false;
    }
}