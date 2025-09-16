global with sharing class Inwib2c_SendAttachementPdfProvider implements vlocity_cmt.VlocityOpenInterface{ 


    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        Boolean result = true;

        
        try{

            if (methodName.equals('send_pdfProvider')){
                send_pdfProvider(inputMap, outMap, options);

             

            } 

        } catch (Exception e){

            result = false;

        }

        return result;
    }

   
        public static String formatPrice(Decimal n) {
            Integer nInteger = n.intValue();
    
            if (n == nInteger) {
                return nInteger + '.00';
            } else {
                return String.valueOf(n);
            }
        }
    
        
    
    
        
    public static void send_pdfProvider(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
         System.debug(JSON.serialize(inputMap));
         String Email = (String) inputMap.get('email');
        String Inputpdf = (String) inputMap.get('pdf');
        String mandatpdf = (String) inputMap.get('mandat');
        String fmspaiementpdf = (String) inputMap.get('fmsPaiement');
        String paiementTerminalpdf = (String) inputMap.get('paiementTerminal');
        String recuPaiementpdf = (String) inputMap.get('recuPaiement');
        String simulationfacturepdf = (String) inputMap.get('simulationfacture');
        String bonlivraisonpdf = (String) inputMap.get('bonlivraison');
        String bonlivgarantiepdf = (String) inputMap.get('bonlivgarantie');
        String mandatdegrouagepdf = (String) inputMap.get('mandatdegrouage');
        String adslmandatportabilitepdf = (String) inputMap.get('adslmandatportabilite');
        String statutdegroupage = (String) inputMap.get('statutdegroupage');
        String orderId = (String) inputMap.get('orderid');
        String orderItem = (String) inputMap.get('orderitemid');
        Integer fmsesh = (Integer) inputMap.get('fms');
        Integer fmdesh = (Integer) inputMap.get('fmd');
        String offertype =(String) inputMap.get('typeforfais'); 
        Integer price = (Integer) inputMap.get('prix');
        Integer totalallfrais = (Integer) inputMap.get('totalfrais');
        Boolean codetransactioneshop= (Boolean) inputMap.get('codetransaction');
        string itembillingcycle;
        String startday;
        String firstphrase;
        String SecondPhrase;
        String numFacture;
        String nomDocument;
        Double valueFmSD;
        String numCf='';
        
        
        // Simulation1erFacture
        Map<String, Object> ListSimulation = new  Map<String, Object>() ;
        List<Map<String, Object>> simulationList = new List<Map<String, Object>>();
        Map<String, Object> simulationData = new Map<String, Object>();
       //
       //FactureFmsFmd
       Map<String, Object> ListFmsFmd = new  Map<String, Object>() ;
       List<Map<String, Object>> fraisList = new List<Map<String, Object>>();
       Map<String, Object> fraisData = new Map<String, Object>();
        

        // 
        String procedureName = 'inwib2c_inwib2c_invoice_simulation';
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();

        // String orderId = '8013M000001zj8WQAQ'; 
        DateTime dt = DateTime.now();
        String dateTimeStr = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        System.debug('>>>>' + dateTimeStr);
        System.debug('OrderId: ' + orderId);
        System.debug('OrderITEM: ' + orderItem);
        System.debug('EshopFMD: ' + fmdesh);
       

        ipInput.put('orderid', orderId);
        ipInput.put('orderitemid', orderItem);
        ipInput.put('activation_date',dateTimeStr );
        ipInput.put('fms',fmsesh );
                    // "prix_forfait": ` + item.vlocity_cmt__RecurringCharge__c.value + `,
                    
                    
 if(!Test.isRunningTest()){
        ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_inwib2c_invoice_simulation', ipInput, ipOptions);
 }else{
   
     ipOutput.put('TypeDoc', 'No');
     ipOutput.put('TypeContratDoc','Postpayé');
     ipOutput.put('TypeDeMigration','');
     ipOutput.put('TypeOffe','Forfait 1H + 11Go');
     ipOutput.put('IsProrate', 'Oui');
     ipOutput.put('address', 'Maatkas TiziOuzou');
     ipOutput.put('clientname', 'Bouremma Amine1');
     ipOutput.put('fms', 49.0 ); 
     ipOutput.put('gamme', 'Forfait in sans engagement'); 
     ipOutput.put('Code_de_transaction_FMS', '1234567899');
     ipOutput.put('Code_de_transaction_FMD', '');  
     ipOutput.put('activation_date', '12/05/2023 02:00:00');
     ipOutput.put('billing_cycle', 18); 
    
 }
        System.debug('IP Output: ' + ipOutput);
        System.debug(JSON.serialize(ipOutput));
        // for (Map.Entry<String, Object> entry : ipOutput.entrySet()) { 
            String typecontrat = (String) ipOutput.get('TypeContratDoc');
            String typemigration = (String) ipOutput.get('TypeDeMigration');
            String name = (String) ipOutput.get('clientname');
            String offre = (String) ipOutput.get('TypeOffe');
            Integer billingcycle = (Integer) ipOutput.get('billing_cycle');
             Integer properiode = (Integer) ipOutput.get('prorata_period');
            Decimal properamount = (Decimal) ipOutput.get('prorata_period_amount');
            Decimal prixforfais = (Decimal) ipOutput.get('prix_forfait');
            Decimal firstinvoice = (Decimal) ipOutput.get('fstinvoice_amount');
            String dateactivation = (String) ipOutput.get('activation_date');
            String typedocument = (String) ipOutput.get('TypeDoc');
            String numerocptfac = (String) ipOutput.get('num_cf'); 
            String gamme = (String) ipOutput.get('gamme');
            String adresse = (String) ipOutput.get('address');  
            String pays = (String) ipOutput.get('pays');  
            String ville = (String) ipOutput.get('ville');  
            String region = (String) ipOutput.get('region'); 
            String numLigne = (String) ipOutput.get('numligne'); 
            String codetraFMD = (String) ipOutput.get('Code_de_transaction_FMD'); 
            String codetraFMS = (String) ipOutput.get('Code_de_transaction_FMS');  
            Double FMS = (Double) ipOutput.get('fms'); 
               

            if (numerocptfac!=null) {
                numCf= +numerocptfac;
                
            }
            // Datetime dtd = new Datetime(dateactivation);
            // String dateTimeStrd = dtd.format('yyyy/MM/dd');
           
           
           String  datedactivation = dateactivation.substring(0, 10);
           String billing = String.valueOf(billingcycle.format());
           Integer  result = billing.length();
          
            if (result==1) {
             itembillingcycle='0'+billing;
             firstphrase='Votre cycle de facturation démarre le' +billingcycle+'er de chaque mois.';
             SecondPhrase='et prend fin le dernier jour du mois';
                
            }
            else {
                itembillingcycle= + billing;
                firstphrase='Votre cycle de facturation démarre le' +billingcycle+'de chaque mois.';
                SecondPhrase='et prend fin le' +billingcycle+'du mois suivant';

                
            }
           if (billingcycle==1) {
            startday='20';
           }
           else {
            startday='7';
            
           }

           System.debug('startday: ' + startday);
           System.debug('FirstPhrase: ' + firstphrase);
           System.debug('SecondPhrase: ' + SecondPhrase);


// Extract date and time components from the string
List<String> dateAndTime = dateactivation.split(' ');
List<String> dateComponents = dateAndTime[0].split('/');
List<String> timeComponents = dateAndTime[1].split(':');

// Construct the DateTime object
Integer day = Integer.valueOf(dateComponents[0]);
Integer month = Integer.valueOf(dateComponents[1]);
Integer year = Integer.valueOf(dateComponents[2]);
Integer hour = Integer.valueOf(timeComponents[0]);
Integer minute = Integer.valueOf(timeComponents[1]);
Integer second = Integer.valueOf(timeComponents[2]);

// Set the new day using the billing cycle value
day = billingCycle;

DateTime activationDateTime = DateTime.newInstance(year, month, day, hour, minute, second);

// Add a month to the activation date
DateTime newDateTime = activationDateTime.addMonths(1);
DateTime newDateTimesecondbill = activationDateTime.addMonths(2);


// Convert the new date back to the desired string format
String newDateActivation = newDateTime.format('dd/MM/yyyy');
String newDateActivationSecondBill = newDateTimesecondbill.format('dd/MM/yyyy');



// Output the new date
System.debug('New Activation Date: ' + newDateActivation);
System.debug('Date de 2eme Cycle: ' + newDateActivationSecondBill);


            System.debug( 'Result is ' + result );
            System.debug( 'ItemBillingcycle ' + itembillingcycle );
            System.debug('PRORATA ' + billing);
            // System.debug('PRORATA ' + datefirstdaycycle);
              
            System.debug('la 1ere cle est: ' + typecontrat);
            System.debug('la 2ere cle est: ' + properamount);
            System.debug('la date d"activation: ' + datedactivation);
            System.debug('type contrat est: ' + typecontrat);
            System.debug('type document est: ' + typedocument);

            ListSimulation.put('clientname', name);
            ListSimulation.put('offer', offre);
            ListSimulation.put('periodfactureedd', datedactivation);
            ListSimulation.put('TypeContrat', typecontrat);
            ListSimulation.put('TypeDeMigration', typemigration);
            ListSimulation.put('activationdate', datedactivation);
            ListSimulation.put('days', properiode);
            ListSimulation.put('priceprorata', properamount);
            ListSimulation.put('pricefirstmonth', prixforfais);
            ListSimulation.put('total', firstinvoice);
            ListSimulation.put('periodfactureedf', newDateActivationSecondBill);
            ListSimulation.put('secondbill', newDateActivationSecondBill);
            ListSimulation.put('firstdaycycle', newDateActivation);
            ListSimulation.put('startday', startday);
            ListSimulation.put('firstPhrase', firstphrase);
            ListSimulation.put('secondPhrase', SecondPhrase);
            System.debug('la liste de simulation  est: ' + ListSimulation);
            
            
            // simulationList.add(simulationData);
            simulationList.add(new Map<String, Object>(ListSimulation));
            // Map<String, Object> simulationData = new Map<String, Object>();
            // simulationData.put('data',  simulationList);
         String simulationListJSON = JSON.serialize(simulationList);
         System.debug('The simulation list is: ' + simulationListJSON);

        // }
        simulationData.put('data', simulationList);
        String simulationListJSONdata = JSON.serialize(simulationData);
        System.debug('The simulation list 2 is: ' + simulationListJSONdata);


        System.debug('inputPDF :----'+Inputpdf);
        System.debug('mandatPDF :----'+mandatpdf);
        System.debug('recupaiementTerminal: ' +paiementTerminalpdf );

        // System.debug('SIMULATION1erePDF :----'+simulationfacturepdf);
        // string orderId = (String) inputMap.get('orderid');
        // String attName = 'facture.pdf';
     
     
// URL-encode the JSON and construct the URL
// String encodedJSON = EncodingUtil.urlEncode(simulationListJSON, 'UTF-8');
// String url = '/apex/inwib2c_first_bill?input=' + encodedJSON;


// Construct the URL with encoded JSON
String encodedJSON = '';
try {
    encodedJSON = EncodingUtil.urlEncode(simulationListJSONdata, 'UTF-8');
} catch (Exception e) {
    // Handle encoding exception
    System.debug('Encoding error: ' + e.getMessage());
    // Perform error handling or return an error response
    return;
}
String url = '/apex/inwib2c_first_bill?input=' +encodedJSON; //simulationListJSONdata;

System.debug('URL de la Simulation 1ere facture' +url);
// String url ='/apex/inwib2c_first_bill?input=' + EncodingUtil.urlEncode('{data:[' + simulationListJSON + ']}', 'UTF-8');

// String encodedJSON = EncodingUtil.urlEncode('{data:[' + simulationListJSON + ']}', 'UTF-8');
// String baseUrl = '/apex/inwib2c_first_bill?input=';
// String url = baseUrl + encodedJSON;
//generer la facture frais

if (FMS>0) {
    numFacture='FMS' +codetraFMS;
    valueFmSD= +FMS;
    
}
else {
    numFacture='FMD' +codetraFMD;
    valueFmSD= +fmdesh;
}
if (fmdesh>0) {
    nomDocument='Facture Frais.pdf';
    
}
else {
    nomDocument='Facture FMS.pdf';
}

System.debug('La Valeur de valueFmSD est :' +valueFmSD);
System.debug('Le Nom de Document est :' +nomDocument);
// Convert the Double value to Decimal
Decimal fmsdDecimal = Decimal.valueOf(valueFmSD);

Decimal difference = valueFmSD - (valueFmSD / 1.2);
Decimal multipliedValue = valueFmSD * Decimal.valueOf(1);

    
            // Call the formatPrice() method from MyApexClass
            String formattedPrice = Inwib2c_SendAttachementPdfProvider.formatPrice(fmsdDecimal.divide(1.2, 2));
            String formattedPricefm = Inwib2c_SendAttachementPdfProvider.formatPrice(difference.setScale(2));
            String formattedPricemultiple = Inwib2c_SendAttachementPdfProvider.formatPrice(multipliedValue);

           
            System.debug('Formatted Price: ' + formattedPrice);
           
            System.debug('Formatted Price 2: ' + formattedPricefm);
            System.debug('Formatted Price 3: ' + formattedPricemultiple);
ListFmsFmd.put('TypeDoc', typedocument);
ListFmsFmd.put('TypeContrat', typecontrat);
ListFmsFmd.put('clientname', name);  
ListFmsFmd.put('offer', offre);
ListFmsFmd.put('address', adresse);
ListFmsFmd.put('region', region);
ListFmsFmd.put('ville', ville);
ListFmsFmd.put('pays', pays);
ListFmsFmd.put('gamme', gamme);
ListFmsFmd.put('activationdate', datedactivation);
ListFmsFmd.put('numfacture',  numFacture);
ListFmsFmd.put('numligne', numLigne);
ListFmsFmd.put('num_cf', numCf); //numerocptfac//
ListFmsFmd.put('totalttc', formattedPricemultiple);
ListFmsFmd.put('timbre', '0.00');
ListFmsFmd.put('tva', formattedPricefm);
ListFmsFmd.put('avancepaiement', formattedPricemultiple);

System.debug('la liste de Facture Frais est: ' + ListFmsFmd);
      
fraisList.add(new Map<String, Object>(ListFmsFmd));
String fmsfmdListJSON = JSON.serialize(fraisList);
System.debug('The Facturefraislist is: ' + fmsfmdListJSON );
fraisData.put('data', fraisList);
String fmsfmdListJSONdata = JSON.serialize(fraisData);
System.debug('The Facturefraislist 2 is: ' + fmsfmdListJSONdata);

// Construct the URL with encoded JSON
String encodedJSONFMSFMD = '';
try {
    encodedJSONFMSFMD = EncodingUtil.urlEncode(fmsfmdListJSONdata, 'UTF-8');
} catch (Exception e) {
    // Handle encoding exception
    System.debug('Encoding error: ' + e.getMessage());
    // Perform error handling or return an error response
    return;
}
String urlFmsFmd = '/apex/inwib2c_fms_bill?input=' +fmsfmdListJSONdata; 

System.debug('URL de la Facture Frais' +urlFmsFmd);



         PageReference pdf = new PageReference(Inputpdf);
         PageReference pdfmandat = new PageReference(mandatpdf);
         PageReference pdfFms = new PageReference(fmspaiementpdf);
         PageReference pdfTerminal = new PageReference(paiementTerminalpdf);
         PageReference pdfRecuPaiement = new PageReference(recuPaiementpdf);
         PageReference pdffacture = new PageReference(url);
         PageReference pdffmsfmd = new PageReference(urlFmsFmd);
         PageReference pdfbonLivraison = new PageReference(bonlivraisonpdf);
         PageReference pdfbonlivgarantie = new PageReference(bonlivgarantiepdf);
         PageReference pdfmandatdegrouage = new PageReference(mandatdegrouagepdf);
         PageReference pdfadslmandatportabilite = new PageReference(adslmandatportabilitepdf);
         
        //  pdf.add(Inputpdf);
        //  pdf.add(mandatpdf);
        // pdf.getparameters().put('orderId', this.pdfOrder.OrderId);
        //PageReference pdf;
        //pdf.getparameters().put('orderId', this.pdfOrder.Id);
        Blob attbody;
        Blob attbodymandat;
        Blob attbodyfms;
        Blob attbodyterminal;
        Blob attbodyrecupaiement;
        Blob attbodysimulation;
        Blob attbodyfacturefrais;
        Blob attbodybonliv;
        Blob attbodybongarantie;
        Blob attbodymandatdegroupage;
        Blob attbodyadslportabilite;
        
       
        Messaging.EmailFileAttachment fileatt = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment fileattmandat = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment fileattfms = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment fileatterminal = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment fileattrecu = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment fileattsim = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment fileattfacturefrais = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment fileattbon = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment fileattgarantiebon = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment fileattmandatdegroupage = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment fileattportabiliteadsl = new Messaging.EmailFileAttachment();
        List<Messaging.SingleEmailMessage> listmails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mails = new Messaging.SingleEmailMessage(); 
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
       

       
       
		//  pdf.setredirect(true);
        System.debug('La Page PDF est' +pdf);
        System.debug('Envoyez a:----');
        System.debug('AMINE BRM' +Email);
        System.debug('le PDF Facture est' +pdffacture);
        System.debug('le PDF FactureFrais est' +pdffmsfmd); 
        System.debug('recupaiementTerminal2: ' +pdfRecuPaiement );
      
        
		// if(!Test.IsRunningTest()){
		// 	attbody = pdf.getContent();
		//     fileatt.setFileName('Contrat.pdf');
		// 	fileatt.setBody(attbody);
		// 	fileAttachments.add(fileatt);
		// }
        // fileatt.setContentType('application/pdf');
        // fileatt.body = EncodingUtil.base64Decode(attbody);
            // attbody = pdf.getContent();
            //attbodyfms = pdfFms.getContentAsPDF();

            try {
                // returns page as a PDF
                attbody = pdf.getContent();
                  attbodymandat = pdfmandat.getContentAsPDF();
                  //attbodyfms = pdfFms.getContentAsPDF();
                  if (price > 0) {
                    attbodyterminal = pdfTerminal.getContentAsPDF();
                }
                 //attbodyterminal = pdfTerminal.getContentAsPDF();
                 //attbodyrecupaiement = pdfRecuPaiement.getContentAsPDF();
                attbodysimulation = pdffacture.getContentAsPDF();
              attbodyfacturefrais = pdffmsfmd.getContentAsPDF();
                //attbody = pdf.getContentAsPDF();
                attbodybonliv = pdfbonLivraison.getContentAsPDF();
                attbodybongarantie = pdfbonlivgarantie.getContentAsPDF();
                attbodymandatdegroupage = pdfmandatdegrouage.getContentAsPDF();
                attbodyadslportabilite = pdfadslmandatportabilite.getContentAsPDF();
            } catch (Exception e) {
                attbody = Blob.valueOf('data');
                  attbodymandat = Blob.valueOf('data');
                  //attbodyfms = Blob.valueOf('data');
                  if (price > 0) {
                    attbodyterminal = Blob.valueOf('data');
                }
                  //attbodyterminal = Blob.valueOf('data');
                  //attbodyrecupaiement = Blob.valueOf('data');
                  attbodysimulation = Blob.valueOf('data');
                  attbodyfacturefrais = Blob.valueOf('data');
                  attbodybonliv = Blob.valueOf('data');
                  attbodybongarantie = Blob.valueOf('data');
                  attbodymandatdegroupage = Blob.valueOf('data');
                  attbodyadslportabilite = Blob.valueOf('data');

            }
               
           
            System.debug('Le BODY PDF est' +pdf);
            System.debug(JSON.serialize(attbody) );
            // try {
            //     // returns page as a PDF
            //     attbodymandat = pdfmandat.getContent();
            //     //attbody = pdf.getContentAsPDF();
            // } catch (Exception e) {
            //     attbody = Blob.valueOf('data');
            // }

    
            //genere bon de Livraison
            if (offertype!='FTTH'&&offertype!='ADSL') {
                
            
            fileattbon.setFileName('Bon de Livraison.pdf');

             fileattbon.setBody(attbodybonliv);
             fileattbon.setContentType('application/pdf');
             fileAttachments.add(fileattbon);
            }
            //Generer Contrat
		    fileatt.setFileName('Contrat.pdf');
            fileatt.setBody(attbody);
            fileatt.setContentType('application/pdf');
            fileAttachments.add(fileatt);

             //Generer 1ere Facture

            if (offertype!='Mobile Prépayé') {
                
            fileattsim.setFileName('SimulationPremiereFacture.pdf');
            fileattsim.setBody(attbodysimulation); 
            fileattsim.setContentType('application/pdf');
            fileAttachments.add(fileattsim);
        }
        //generer bonLivraisonGarantie
        if (offertype=='ADSL') {
            
       
            fileattgarantiebon.setFileName('Bon de livraison et de garantie.pdf');
            fileattgarantiebon.setBody(attbodybongarantie); 
            fileattgarantiebon.setContentType('application/pdf');
            fileAttachments.add(fileattgarantiebon);
       
        //generer mandat de degrouage
       
        fileattmandatdegroupage.setFileName('Mandat de dégroupage.pdf');
        fileattmandatdegroupage.setBody(attbodymandatdegroupage); 
        fileattmandatdegroupage.setContentType('application/pdf');
        fileAttachments.add(fileattmandatdegroupage);
         }
        //  generer mandatPortabiliteADSL
        if (offertype=='ADSL'&&statutdegroupage=='inwiB2C_Inactive') {
            fileattportabiliteadsl.setFileName('Mandat de portabilité ADSL.pdf');
            fileattportabiliteadsl.setBody(attbodyadslportabilite); 
            fileattportabiliteadsl.setContentType('application/pdf');
            fileAttachments.add(fileattportabiliteadsl);
          }
        
        //generer Une facture frais

        if (offertype=='Mobile Postpayé'&& codetransactioneshop==true) {
                
            fileattfacturefrais.setFileName(nomDocument);
            fileattfacturefrais.setBody(attbodyfacturefrais);
            fileattfacturefrais.setContentType('application/pdf');
             fileAttachments.add(fileattfacturefrais);
            }

            if (offertype=='Mobile Postpayé'&& price>0 && codetransactioneshop==true) {
                
           
             //Genere Terminal
             fileatterminal.setFileName('Paiement Terminal.pdf');
              fileatterminal.setBody(attbodyterminal);
              fileatterminal.setContentType('application/pdf');
              fileAttachments.add(fileatterminal);
            }
           
              
           
       
       if (offertype=='Mobile Prépayé') {
        //Generer RecuPaiement
    //    fileattrecu.setFileName('Recu de Paiement.pdf');
    //    fileattrecu.setContentType('application/pdf');
	// 	fileattrecu.setBody(attbodyrecupaiement);
    //     fileAttachments.add(fileattrecu);

  
    
    //     //Generer factureFMS
    //     fileattfms.setFileName('Paiement FMS.pdf');
    //     fileattfms.setContentType('application/pdf');
    //     fileattfms.setBody(attbodyfms);  
    //    fileAttachments.add(fileattfms);


    //      //Generer Mandat

    //      fileattmandat.setFileName('Mandat.pdf');
    //      fileattmandat.setContentType('application/pdf');
    //     fileattmandat.setBody(attbodymandat);
    //      fileAttachments.add(fileattmandat);
        }
            
              
            System.debug('FilesAttachements' +fileatt);
		    
             
            
            
             
            
            System.debug('DocumentsAttachement' +fileAttachments);
        string body = 'Amine brm';
        String subject = 'Pieces Jointes';
        System.debug('AdressePrestataire1');
       
        String[] mail = new String[]{ Email };
        System.debug('AdressePrestataire' +mail);
       
        //htmlbody = 'Livraison eshop a Domicile';
        
        mails.setSubject(subject);
        mails.setToAddresses(mail);
        //mails.setHtmlBody(htmlbody);
        mails.setPlainTextBody(body);
        mails.setFileAttachments(fileAttachments);
		listmails.add(mails);  
        Messaging.sendEmail(listmails);
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mails });
		//return null;
          
        
        outMap.put('InfoPrestataire',mails);
    }
}