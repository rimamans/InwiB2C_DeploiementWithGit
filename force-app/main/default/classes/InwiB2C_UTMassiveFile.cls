global with sharing class InwiB2C_UTMassiveFile implements vlocity_cmt.VlocityOpenInterface {
    
    public Boolean InvokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {   
        Boolean result = true;
        try {
            if (methodName == 'ReadFile') {
                output.put('Retour', ReadFile(input));
            }
        } catch (Exception e) {
            System.debug('MDNFileHandler:invokeMethod -> exception: ' + e);
            result = false;
        }
        return result;
    }

    private Map<String, Object> ReadFile(Map<String, Object> input) {
        Boolean error = false;
        String msg;
        Map<String, Integer> headerMap = new Map<String, Integer>();
        Id contentDocumentId = (Id) input.get('contentDocumentId');
        String fileName = (String) input.get('fileName');
        Map<String, Object> output = new Map<String, Object>();
        List<Object> demandes = new List<Object>();
        Integer size;

        if (contentDocumentId != null) {
            ContentVersion contentVersionObj = [SELECT Id, Title, VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId LIMIT 1];
            
            if (contentVersionObj.VersionData != null) {
                // Récupérer l'InputStream à partir du Blob
                Blob fileBlob = contentVersionObj.VersionData;
                String fileContent = fileBlob.toString();
                List<String> recordsList = new List<String>();
                Integer sizeCount = 0;

                // Lire le fichier en morceaux, ligne par ligne, sans utiliser split() directement
                List<Integer> newlineIndexes = new List<Integer>();
                for (Integer i = 0; i < fileContent.length(); i++) {
                    if (fileContent.substring(i, i + 1) == '\n') {
                        newlineIndexes.add(i);
                    }
                }

                // Découpe du contenu selon les retours à la ligne
                for (Integer i = 0; i < newlineIndexes.size(); i++) {
                    Integer startIndex = (i == 0) ? 0 : newlineIndexes[i - 1] + 1;
                    Integer endIndex = newlineIndexes[i];
                    String line = fileContent.substring(startIndex, endIndex).trim();
                    recordsList.add(line);
                    sizeCount++;
                }

                // Ajouter la dernière ligne si nécessaire
                if (sizeCount == 0 || fileContent.endsWith('\n') == false) {
                    recordsList.add(fileContent.substring(newlineIndexes.get(newlineIndexes.size() - 1) + 1).trim());
                    sizeCount++;
                }

                // Mettre à jour la taille
                size = sizeCount - 1;
                
                if (size == -1 || size == 0 || size == 1 || String.isBlank(fileContent)) {
                error = true;
                msg = 'Le fichier ne contient aucune ligne.';
            } else if (size > 10000) {
                error = true;
                msg = 'Le fichier dépasse 10000 lignes.';
            } else if (!recordsList[0].contains('Segment') || 
            !recordsList[0].contains('Distributeur') || 
            !recordsList[0].contains('Type') ||
            !recordsList[0].contains('Nom') || 
            !recordsList[0].contains('Prénom') || 
            !recordsList[0].contains('Piece identite') || 
            !recordsList[0].contains('Type piece identite') || 
            !recordsList[0].contains('Code') || 
            !recordsList[0].contains('Num de contact 1') || 
            !recordsList[0].contains('Num de contact 2') || 
            !recordsList[0].contains('Adresse mail') || 
            !recordsList[0].contains('Région') || 
            !recordsList[0].contains('Adresse') || 
            !recordsList[0].contains('Précision Quartier') || 
            !recordsList[0].contains('Ville/Douar') || 
            !recordsList[0].contains('Flag Rural ou Urbain') || 
            !recordsList[0].contains('Canal (RTM/Classique)') || 
            !recordsList[0].contains('Longitude') || 
            !recordsList[0].contains('Latitude')||
             !recordsList[0].contains('Vendeur') ||
               !recordsList[0].contains('Sous-Région(RVR)')  ) {
                error = true;
                msg = 'Merci d\'ajouter l\'en-tête suivant : ' +
                       'Segment;Distributeur;Type;Nom;Prénom;Piece identite;Type piece identite;Code;Num de contact 1;Num de contact 2;Adresse mail;Région;Adresse;Précision Quartier;Ville/Douar;Flag Rural ou Urbain;Canal (RTM/Classique);Latitude;Longitude;Vendeur;Sous-Région(RVR)'; 
            } else {
                // Traitement des en-têtes
                List<String> header = recordsList[0].split(';');
for (Integer j = 0; j < header.size(); j++) {
    header[j] = header[j].trim(); // Nettoyer les espaces autour de l'en-tête
    headerMap.put(header[j], j);
}}

                // Insertion du fichier
                InwiB2C_Update_AM_File__c file = new InwiB2C_Update_AM_File__c(InwiB2C_Statut__c = 'In Progress', Name = fileName, InwiB2C_UIID_c__c = contentDocumentId);
                insert file;

                List<Chargement_de_fichierAM_en_masse__c> listChargement = new List<Chargement_de_fichierAM_en_masse__c>();

                for (Integer i = 1; i < recordsList.size(); i++) {
                    System.debug('Ligne : ' + recordsList[i]);
                    List<String> donnee = recordsList[i].split(';');
                    
                      // Vérification des champs vides pour les champs obligatoires
    List<String> requiredFields = new List<String>{
        'Segment',
        'Type',
        'Nom',
        'Prénom',
        'Num de contact 1',
        'Région',
        'Adresse',
        'Précision Quartier',
        'Ville/Douar',
        'Flag Rural ou Urbain',
        'Longitude',
        'Latitude',
        'Sous-Région(RVR)'
    };
                    
    for (String fieldName : requiredFields) {
        Integer index = headerMap.get(fieldName);
        System.debug('Checking field: ' + fieldName + ' at index: ' + index);
        if (index == null || String.isBlank(donnee[index])) {
            error = true;
            msg = fieldName + ' est manquant dans la ligne ' + i;
            break;
        }
    }
     //acyl 16/01/2025 begin */
              // Vérification des numéros de contact 1 et 2
              if (!String.isBlank(donnee[headerMap.get('Num de contact 1')])) {
                String numContact1 = donnee[headerMap.get('Num de contact 1')].trim();
                // Validation des numéros de contact (doivent commencer par 212 et être suivis de 9 chiffres)
                if (!Pattern.matches('^212\\d{9}$', numContact1)) {
                    error = true;
                    msg = 'Le numéro de contact 1 dans la ligne ' + (i + 1) + ' n\'est pas valide. Il doit commencer par 212 et être suivi de 9 chiffres.';
                    break;
                }
            }
        
            if (!String.isBlank(donnee[headerMap.get('Num de contact 2')])) {
                String numContact2 = donnee[headerMap.get('Num de contact 2')].trim();
                // Validation des numéros de contact (doivent commencer par 212 et être suivis de 9 chiffres)
                if (!Pattern.matches('^212\\d{9}$', numContact2)) {
                    error = true;
                    msg = 'Le numéro de contact 2 dans la ligne ' + (i + 1) + ' n\'est pas valide. Il doit commencer par 212 et être suivi de 9 chiffres.';
                    break;
                }
            }      //acyl 16/01/2025 end */           
// Vérification de la région
                       String region = donnee[headerMap.get('Région')].trim().toUpperCase();
                       if (region != 'Centre' && region != 'EST' && region != 'CA' && region != 'RN' && region != 'G.Sud' && region != 'CS') {
                           error = true;
                           msg = 'La région ' + region + ' n\'est pas autorisée. Seules les régions Centre,EST,CA,RN,G.Sud,CS sont autorisées.';
                           break;
                       }
   
                       if (error) {
                           break;
                       }
                    // Conversion des champs numériques
                    Decimal longitude = 0;
                    Decimal latitude = 0;
                    Integer partenaireNumContact1 = 0;
                    Integer partenaireNumContact2 = 0;
                    Integer codeDealer = 0;
                
                    // Tenter de convertir les champs numériques
                    try {
                        longitude = Decimal.valueOf(donnee[headerMap.get('Longitude')]);
                    } catch (Exception e) {
                        longitude = null; 
                    }
                
                    try {
                        latitude = Decimal.valueOf(donnee[headerMap.get('Latitude')]);
                    } catch (Exception e) {
                        latitude = null; 
                    }
                
                    try {
                        codeDealer = Integer.valueOf(donnee[headerMap.get('Code')]);
                    } catch (Exception e) {
                        codeDealer = null; 
                    }
                
                    // Création de l'enregistrement pour l'objet Chargement_de_fichierAM_en_masse__c
                    Chargement_de_fichierAM_en_masse__c record = new Chargement_de_fichierAM_en_masse__c(
                        Inwib2c_Segment_Dealer_c__c = donnee[headerMap.get('Segment')],
                        ParentId__c = donnee[headerMap.get('Distributeur')],
                        InwiB2C_Typehandler__c = donnee[headerMap.get('Type')],
                        LastName__c = donnee[headerMap.get('Nom')],
                        FirstName__c = donnee[headerMap.get('Prénom')],
                        InwiB2C_CIN__c = donnee[headerMap.get('Piece identite')],
                        InwiB2C_Type_CIN_c__c = donnee[headerMap.get('Type piece identite')],
                        InwiB2C_Code_Dealer__c = codeDealer,  // Champ numérique converti
                        PartenaireNumContact1__c = donnee[headerMap.get('Num de contact 1')],  // Champ numérique converti
                        Partenaire_Num_Contact2__c = donnee[headerMap.get('Num de contact 2')],  // Champ numérique converti
                        inwib2c_AdresseMail__c = donnee[headerMap.get('Adresse mail')],
                        InwiB2C_Region__c = donnee[headerMap.get('Région')],
                        InwiB2C_Address__c = donnee[headerMap.get('Adresse')],
                        InwiB2C_Quartier__c = donnee[headerMap.get('Précision Quartier')],
                        inwib2c_Ville__c = donnee[headerMap.get('Ville/Douar')],
                        InwiB2C_Flag_Rural_Urbain__c = donnee[headerMap.get('Flag Rural ou Urbain')],
                        InwiB2C_Canal__c = donnee[headerMap.get('Canal (RTM/Classique)')],
                        inwib2c_Geolocalisation_Longitude__c = longitude,  // Champ numérique converti
                        inwib2c_Geolocalisation_Latitude__c = latitude,  // Champ numérique converti
                        InwiB2C_Vendeur__c = donnee[headerMap.get('Vendeur')],
                        InwiB2C_SousRegion__c = donnee[headerMap.get('Sous-Région(RVR)')],
                        InwiB2C_Statut__c = 'Waiting',  // Statut par défaut
                        InwiB2C_UIID__c = contentDocumentId,  // ID du document
                        InwiB2C_Erreur__c = ''  // Erreur vide par défaut
                    );
                    System.debug('Prepared record for insertion: ' + record); // Log the prepared record
                
                    // Ajouter l'enregistrement à la liste pour insertion ultérieure
                    listChargement.add(record);
                }
                System.debug('Inserting ' + listChargement.size() + ' records into Chargement_de_fichierAM_en_masse__c');
                // Insertion des enregistrements
                insert listChargement;
                output.put('demandes', listChargement);
            }}

        output.put('error', error);
        if (error) {
            output.put('Message', msg);
        } else {
            // Récupérer les enregistrements de Chargement_de_fichierAM_en_masse__c avec tous les champs nécessaires
            List<Chargement_de_fichierAM_en_masse__c> CTRecords = [
                SELECT 
                    Id, ParentId__c,
                    Inwib2c_Segment_Dealer_c__c,
                    InwiB2C_Typehandler__c,
                    LastName__c, 
                    FirstName__c,
                    InwiB2C_CIN__c,
                    InwiB2C_Type_CIN_c__c,
                    InwiB2C_Code_Dealer__c,
                    PartenaireNumContact1__c,
                    Partenaire_Num_Contact2__c,
                    inwib2c_AdresseMail__c,
                    InwiB2C_Region__c,
                    InwiB2C_Address__c,
                    InwiB2C_Quartier__c,
                    inwiB2C_Ville__c,
                    inwib2c_Geolocalisation_Longitude__c,
                    inwib2c_Geolocalisation_Latitude__c,
                    InwiB2C_Vendeur__c, InwiB2C_Canal__c, InwiB2C_SousRegion__c, InwiB2C_Flag_Rural_Urbain__c
                FROM Chargement_de_fichierAM_en_masse__c 
                WHERE InwiB2C_UIID__c = :contentDocumentId 
                ORDER BY CreatedDate DESC 
                LIMIT 50
            ];
            System.debug('Records retrieved from Chargement_de_fichierAM_en_masse__c: ' + CTRecords); // Log the retrieved records

            // Créer la liste des demandes à envoyer
            for (Chargement_de_fichierAM_en_masse__c record : CTRecords) {
                Map<String, String> demande = new Map<String, String>();
                demande.put('RecordId', record.Id);
                demande.put('Segment_Dealer', record.Inwib2c_Segment_Dealer_c__c);
                demande.put('ParentId', record.ParentId__c);
                demande.put('Typehandler', record.InwiB2C_Typehandler__c);
                demande.put('LastName', record.LastName__c);
                demande.put('FirstName', record.FirstName__c);
                demande.put('CIN', record.InwiB2C_CIN__c);
                demande.put('Type_CIN', record.InwiB2C_Type_CIN_c__c);

                // Conversion des champs numériques en String
                demande.put('Code_Dealer', String.valueOf(record.InwiB2C_Code_Dealer__c));
                demande.put('PartenaireNumContact1', String.valueOf(record.PartenaireNumContact1__c));
                demande.put('Partenaire_Num_Contact2', String.valueOf(record.Partenaire_Num_Contact2__c));

                // Vérifiez si ces champs ne sont pas null avant de les convertir en String
                demande.put('AdresseMail', record.inwib2c_AdresseMail__c);
                demande.put('Region', record.InwiB2C_Region__c);
                demande.put('Address', record.InwiB2C_Address__c);
                demande.put('Précision Quartier', record.InwiB2C_Quartier__c);
                demande.put('Ville/Douar', record.inwiB2C_Ville__c);
                demande.put('Flag Rural ou Urbain', record.InwiB2C_Flag_Rural_Urbain__c);
                demande.put('Canal (RTM/Classique)', record.InwiB2C_Canal__c);
                demande.put('Vendeur', record.InwiB2C_Vendeur__c);
                demande.put('Sous-Région(RVR)', record.InwiB2C_SousRegion__c);
                // Convertir les coordonnées géographiques (Decimal) en String
                demande.put('Longitude', String.valueOf(record.inwib2c_Geolocalisation_Longitude__c));
                demande.put('Latitude', String.valueOf(record.inwib2c_Geolocalisation_Latitude__c));

                // Ajouter la demande à la liste
                demandes.add(demande);
            }
           
            // Créer un événement pour envoyer les données à l'EventBus
            InwiB2C_Controle_fileAM__e CTEvent = new InwiB2C_Controle_fileAM__e(
                InwiB2C_documentId__c = contentDocumentId,
                InwiB2C_demandesList__c = JSON.serialize(demandes),
                InwiB2C_fileSize__c = size,
                InwiB2C_Counter__c = 0
            );

            // Publier l'événement
            EventBus.publish(CTEvent);
            
        }

        return output; 
    }
}