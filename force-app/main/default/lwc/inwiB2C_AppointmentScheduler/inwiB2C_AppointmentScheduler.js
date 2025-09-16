import { LightningElement, track , api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_AppointmentScheduler extends OmniscriptBaseMixin(LightningElement) {
 
  @track groupedSlots = [];
  @track startDisplayDate;
  @track currentPage = 1;
  @track isloading = true;
  selectedDate = null;
  selectedSlot = null;
  selectedSlotid = null;
  prevSelectedSlotElement = null;
  fetchMore = true;
  
  total;

  _actionUtilClass;
  _ns = getNamespaceDotNotation();

  @api orderid= '';
  @api canal = '';
  @api avecporta = '';
  @api iscreate = false;
  @api ismodif = false;
  @api offer = '';
  @api motif_report = '';
  @api plaque;
  @api wonumber='';


  @api daysPerPage = 5;

  @track prevFetchedSlots = {};
  @track prevFetchedSlotsday = new Map();


  __disableSave;

  @api
  set disableSave(value) {

    this.__disableSave = value;

  }
  get disableSave() {
    return !(this.selectedSlot && this.selectedDate);
  }

  getAvailableSlots() {
    let data =
    {
      '1': [
        { slot: 'am', day: '2024-03-19' },
        { slot: 'pm', day: '2024-03-19' },
        { slot: 'am', day: '2024-03-20' },
        { slot: 'pm', day: '2024-03-20' },
        { slot: 'am', day: '2024-03-21' },
        { slot: 'pm', day: '2024-03-21' },
        { slot: 'am', day: '2024-03-22' },
        { slot: 'pm', day: '2024-03-22' },
        { slot: 'am', day: '2024-03-23' },
        { slot: 'pm', day: '2024-03-23' }
      ]
      ,

      '2': [
        { slot: 'am', day: '2024-03-24' },
        { slot: 'pm', day: '2024-03-24' },
        { slot: 'am', day: '2024-03-25' },
        { slot: 'pm', day: '2024-03-25' },
        { slot: 'am', day: '2024-03-26' },
        { slot: 'pm', day: '2024-03-26' },
        { slot: 'am', day: '2024-03-27' },
        { slot: 'pm', day: '2024-03-27' },
        { slot: 'am', day: '2024-03-28' },
        { slot: 'pm', day: '2024-03-28' }
      ]
      ,

      '3': [
        { slot: 'am', day: '2024-03-29' },
        { slot: 'pm', day: '2024-03-29' },
        { slot: 'am', day: '2024-03-30' },
        { slot: 'pm', day: '2024-03-30' }
      ]
    };
    return data[this.currentPage];
  }

  
  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.fetchMetadataDayPerPage();
    this.fetchSlotsFromAPI();
    console.log("canal ", this.canal , 
    "\nporta", this.avecporta,
      "\nmotfi_report", this.motif_report, 
      "\noffer", this.offer , 
      "\norderid", this.orderid, 
      "\niscreate", this.iscreate,
      "\nismodif", this.ismodif,
      "\nplaque", this.plaque
      )
  }

  fetchSlotsFromAPI(isNext=false) {

   

    
    if (this.prevFetchedSlots[this.currentPage]) {

      this.groupedSlots = this.prevFetchedSlots[this.currentPage];
      return;
    }else if (this.fetchMore === false) {
      this.currentPage--;
      return;
    }
    //const slots = this.getAvailableSlots();
    //const slots = this.fetchRDV();
    this.determineStartDate();
    this.fetchRDV()
      .then((result) => {    
        console.log(`thenCatch result => ${result}.`);
        let slots = result;
        console.log(isNext, slots);
        this.displaySlots(slots);
        this.isloading = false;
      })
      .catch((error) => {
        this.isloading = false;
        console.log(`thenCatch error => ${error}.`);
        if (isNext) {
          this.currentPage--;
          return;
        }      
      })
    
  }

  determineStartDate(slots=[]) {

    console.log("canal", this.canal)
    const today = new Date(); // Get today's date
    const startDate = new Date(today); // Start with today's date

    // Add days based on user's conditions
    /* if (this.canal === 'Point de vente' || this.canal === 'inwiB2C_D2D' || this.ismodif === true) {
      startDate.setDate(today.getDate() + 1); // J+1
    } else if (this.canal === 'MyInwi') {
      startDate.setDate(today.getDate() + 2); // J+2
    } else if (this.canal === 'inwiB2C_Televente') {
      startDate.setDate(today.getDate() + 3); // J+3
    } else startDate.setDate(today.getDate() + 1);

    if (this.avecporta) {
      startDate.setDate(today.getDate() + 7); // J+7 if avecporta is true
    } */

    // Set the startDisplayDate to the determined startDate
    this.startDisplayDate = startDate.toISOString().split('T')[0];

    /*
    const firstAvailableDate = slots.find(slot => slot.day === this.startDisplayDate);
    if (!firstAvailableDate) {
  
      const nextAvailableDate = slots.find(slot => new Date(slot.day) > startDate);
      if (nextAvailableDate) {
        this.startDisplayDate = nextAvailableDate.day;
      }
    }
   */
    console.log("startdate", this.startDisplayDate)
  }

  displaySlots(slots) {
 
    const startIndex = (this.currentPage - 1) * this.daysPerPage;
    const endIndex = startIndex + this.daysPerPage;

    const slicedDates = this.groupSlotsByDay(slots)

    console.log('slicedDates', slicedDates)
    console.log('startIndex  ', startIndex, ' endIndex ' , endIndex)


    const slicedData = slicedDates.slice(startIndex, endIndex);
    if (slicedData?.length > 0){
      this.groupedSlots = slicedDates.slice(startIndex, endIndex);
      this.prevFetchedSlots[this.currentPage] = this.groupedSlots;
    }
    else {
      this.currentPage--;
      this.fetchMore = false;
    }
        
      console.log('this.prevFetchedSlots[this.currentPage]', this.prevFetchedSlots[this.currentPage])
    
  }

  handleNextButtonClick() {
      this.currentPage++;
      this.fetchSlotsFromAPI(true);
  }

  handlePrevButtonClick() {
    if (this.currentPage > 1) {
      this.currentPage--;    
      //this.displaySlots();
    }

    this.groupedSlots = this.prevFetchedSlots[this.currentPage];
  }

  handleSlotClick(event) {

    console.log('event')
    console.log(event.target.tagName)
    console.log(event.target.classList)
    //event.stopImmediatePropagation();
    //event.stopPropagation();
   // event.preventDefault();

    if(event.target.tagName === 'P'){
      return;
    }

    if (this.prevSelectedSlotElement) {
      this.prevSelectedSlotElement.classList.remove('selected');
    }

    this.prevSelectedSlotElement = event.currentTarget;

    event.target.classList.add('selected');

    this.selectedSlot = event.currentTarget.dataset.slot;
    this.selectedSlotid = event.currentTarget.dataset.slotid;
    this.selectedDate = event.currentTarget.dataset.date;
 
  }

  getSlotLabel(slot) {
    return (
      slot === 'am' ?
        { "slotLabel": 'Matin (09h à 14h)', 'slotHour': "09h à 14h", "slotName": "Matin" } :
        { "slotLabel": 'Après-midi (14h à 20h)', 'slotHour': "14h à 20h", "slotName": "Après-midi" }
    );
  }

  getDayOfWeekInFrench(dateString) {
    const daysInFrench = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
    const date = new Date(dateString);
    const dayIndex = date.getDay();
    return daysInFrench[dayIndex];
  }

  formatDate(dateString) {
    const date = new Date(dateString);
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
  }

  generateRandomId = () => {
    return Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1);
  }

  groupSlotsByDay(slots) {
    const groupedSlots = [];
    const groupedByDate = this.prevFetchedSlotsday;


    slots.forEach((slot) => {
      const date = slot.day;
      if (!groupedByDate.has(date)) {
        groupedByDate.set(date, []);
      }
      if (groupedByDate.get(date).every(e => e?.slot != slot?.slot)) groupedByDate.get(date).push({ ...this.getSlotLabel(slot.slot), "slot": slot.slot, "id": this.generateRandomId(), "day": slot.day, "class": "dateSlot active" });
    });

    console.log('groupedByDate', groupedByDate)
    groupedByDate.forEach((slots, date) => {
      if (slots.every(e => e?.slot != 'am')) slots.unshift(
        { ...this.getSlotLabel('am'), "slot": 'am', "id": this.generateRandomId(), "day": date, "class": "dateSlot inactive" });
      if (slots.every(e => e?.slot != 'pm')) slots.push(
        { ...this.getSlotLabel('pm'), "slot": 'pm', "id": this.generateRandomId(), "day": date, "class": "dateSlot inactive" });
      groupedSlots.push({ date, slots, "formatDate": this.formatDate(date), "dayOfWeek": this.getDayOfWeekInFrench(date) });
    });

    console.log('groupedSlots',groupedSlots)

    this.prevFetchedSlotsday = groupedByDate;
    return groupedSlots;
  }


  CreateRDV() {
    this.isloading = true;
    const params = {
      input: '{"Canal":"' + this.canal + '","isCreate":"' + this.iscreate + '","isModif":"' + this.ismodif + '","slot":"' + this.selectedSlot + '","day":"' + this.selectedDate + '","portability":"' + this.avecporta + '","offer":"' + this.offer + '","MotifReport":"' + this.motif_report + '","plaque":"'+this.plaque+'","OrderId":"' + this.orderid+'","WONumber":"' + this.wonumber+ '"}',
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_CreateRDVFTTH',
      options: '{}',
    };
    console.log('input ',params.input);

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then((response) => {
        this.isloading = false;
        console.log(response.result?.IPResult);
        if (response.result?.IPResult && response.result?.IPResult?.success !== false) {
          this.__disableSave = false;
          console.log('Toto Amine brm');
          this.omniUpdateDataJson(response.result?.IPResult);
          this.omniSaveState(response.result?.IPResult, true);
          this.omniNextStep();
          console.log('Status changed successfully');
        } else {
          console.error('Error changing status: ', response.result?.IPResult);
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Erreur',
              message: 'Error lors de la reservation du rendez-vous',
              variant: 'error'
            }),
          );
        }
      })
      .catch((error) => {
        this.isloading = false;
        console.error('An unexpected error occurred: ', error);
      });
  }


  async fetchRDV() {
    this.isloading = true;
    const params = {
      input: `{"offset":"${this.currentPage}","portability":"${this.avecporta}", "motif_report":"${this.motif_report}" ,"limit":"${2*(this.daysPerPage * this.daysPerPage)}","startdate":"${this.startDisplayDate}","canal":"${this.canal}","plaque":"${this.plaque}"}`,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_searchTimeSlot',
      options: '{}',
    };
       console.log('inputApisearchSlot', params.input);
    const fetchresult = new Promise((resolve, reject) => {
      //resolve('success!');
      //reject('failed!');
    
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log(response.result?.IPResult);
        if (response.result?.IPResult && response.result?.IPResult && response.result?.IPResult?.success !== "KO" && response.result?.IPResult?.success !== false) {      
          console.log('Status changed successfully');
         resolve(response.result?.IPResult?.appoitmentDetails || []);
        } else {
          console.error('Error changing status: ', response);
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Erreur',
              message: 'Error lors de la recuperation des date :' + response?.result?.IPResult?.message,
              variant: 'error'
            }),
          );
          reject([]);
        }
      })
      .catch((error) => {
        this.isloading=false;
        console.error('An unexpected error occurred: ', error);
        reject([]);
      });
    })
    // this.isloading = false;
    return fetchresult;
  }


  fetchMetadataDayPerPage() {
    this.isloading = true;
    const params = {
      input: '{}',
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_GetMetadataRDVFTTH',
      options: '{}',
    };
      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then((response) => {
          console.log(response.result?.IPResult);
          if (response.result?.IPResult && response.result?.IPResult?.daysPerPage) {
            console.log('daysPerPage', response.result?.IPResult?.daysPerPage);
            
            this.daysPerPage = Number.parseInt(response.result?.IPResult?.daysPerPage);
            this.isloading = false;
          } else {
            console.error('Error fetching metadata: ', response);
            /* this.dispatchEvent(
              new ShowToastEvent({
                title: 'Erreur',
                message: 'Error lors de la recuperation des date :' + response?.result?.IPResult?.message,
                variant: 'error'
              }),
            ); */
          }
        })
        .catch((error) => {
          this.isloading = false;
          console.error('An unexpected error occurred: ', error);

        });
    // this.isloading = false;
 
  }


  handleNextStep(){
    this.CreateRDV();
  }
  handlePreviousStep(){
    this.omniPrevStep();
  }
}