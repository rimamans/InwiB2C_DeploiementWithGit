@isTest
public class InwiB2C_UTMassiveFileTest {

    @isTest(SeeAllData=false)
    public static void testReadFileValid() {
        // Arrange
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'Valid test description';
        cv.PathOnClient ='test_file_valid.csv';
        cv.Title = 'test file valid';
        String csvString = 'Segment;Type;Nom;Prénom;Piece identite;Type piece identite;Code;Num de contact 1;Num de contact 2;Adresse mail;Région;Adresse;Quartier;Ville;Longitude;Latitude\n' +
                           'Segment1;Type1;Doe;John;123456;Passport;Code1;1234567890;0987654321;john.doe@example.com;Region1;Address1;Quarter1;City1;12.3456;78.9012\n' +
                           'Segment2;Type2;Smith;Jane;654321;IDCard;Code2;9876543210;1234567890;jane.smith@example.com;Region2;Address2;Quarter2;City2;23.4567;89.0123';
        cv.versiondata = Blob.valueOf(csvString);
        insert cv;

        // Act
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        inputMap.put('contentDocumentId', cv.ContentDocumentId);
        inputMap.put('fileName', cv.Title);
        
        Test.startTest();
        Boolean result = new InwiB2C_UTMassiveFile().InvokeMethod('ReadFile', inputMap, outputMap, new Map<String, Object>());
        Test.stopTest();

        // Assert
        System.assert(result, 'The file should be processed successfully');
        System.assert(outputMap.containsKey('demandes'), 'The output should contain demandes');
        List<Object> demandes = (List<Object>) outputMap.get('demandes');
        System.assertEquals(demandes.size(), 2, 'There should be two records inserted');
    }

    @isTest(SeeAllData=false)
    public static void testReadFileMissingHeader() {
        // Arrange
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'Invalid test description';
        cv.PathOnClient ='test_file_missing_header.csv';
        cv.Title = 'test file missing header';
        String csvString = 'Segment;Type;Nom;Prénom;Piece identite;Type piece identite;Code;Num de contact 1;Num de contact 2;Adresse mail;Région;Adresse;Quartier;Ville;Longitude;Latitude\n' +
                           'Segment1;Type1;Doe;John;123456;Passport;Code1;1234567890;0987654321;john.doe@example.com;Region1;Address1;Quarter1;City1;12.3456;78.9012';
        cv.versiondata = Blob.valueOf(csvString);
        insert cv;

        // Act
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        inputMap.put('contentDocumentId', cv.ContentDocumentId);
        inputMap.put('fileName', cv.Title);

        Test.startTest();
        Boolean result = new InwiB2C_UTMassiveFile().InvokeMethod('ReadFile', inputMap, outputMap, new Map<String, Object>());
        Test.stopTest();

        // Assert
        System.assert(!result, 'The file should not be processed successfully due to missing headers');
        System.assert(outputMap.containsKey('Message'), 'The output should contain an error message');
        String errorMessage = (String) outputMap.get('Message');
        System.assert(errorMessage.contains('Merci d\'ajouter l\'en-tête suivant'), 'The error message should indicate missing headers');
    }

    @isTest(SeeAllData=false)
    public static void testReadFileWithTooManyRows() {
        // Arrange
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'File with too many rows';
        cv.PathOnClient ='test_file_too_many_rows.csv';
        cv.Title = 'test file too many rows';
        String csvString = 'Segment;Type;Nom;Prénom;Piece identite;Type piece identite;Code;Num de contact 1;Num de contact 2;Adresse mail;Région;Adresse;Quartier;Ville;Longitude;Latitude\n';
        for (Integer i = 0; i < 10001; i++) {
            csvString += 'Segment' + i + ';Type' + i + ';Nom' + i + ';Prénom' + i + ';Piece' + i + ';Type' + i + ';Code' + i + ';NumContact1' + i + ';NumContact2' + i + ';Email' + i + ';Region' + i + ';Address' + i + ';Quarter' + i + ';City' + i + ';Longitude' + i + ';Latitude' + i + '\n';
        }
        cv.versiondata = Blob.valueOf(csvString);
        insert cv;

        // Act
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        inputMap.put('contentDocumentId', cv.ContentDocumentId);
        inputMap.put('fileName', cv.Title);

        Test.startTest();
        Boolean result = new InwiB2C_UTMassiveFile().InvokeMethod('ReadFile', inputMap, outputMap, new Map<String, Object>());
        Test.stopTest();

        // Assert
        System.assert(!result, 'The file should not be processed successfully due to too many rows');
        System.assert(outputMap.containsKey('Message'), 'The output should contain an error message');
        String errorMessage = (String) outputMap.get('Message');
        System.assert(errorMessage.contains('Le fichier dépasse 10000 lignes'), 'The error message should indicate the file has too many rows');
    }

    @isTest(SeeAllData=false)
    public static void testReadFileWithInvalidData() {
        // Arrange
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'File with invalid data';
        cv.PathOnClient ='test_file_invalid_data.csv';
        cv.Title = 'test file invalid data';
        String csvString = 'Segment;Type;Nom;Prénom;Piece identite;Type piece identite;Code;Num de contact 1;Num de contact 2;Adresse mail;Région;Adresse;Quartier;Ville;Longitude;Latitude\n' +
                           'Segment1;Type1;Doe;John;;Passport;Code1;1234567890;0987654321;john.doe@example.com;Region1;Address1;Quarter1;City1;;78.9012';
        cv.versiondata = Blob.valueOf(csvString);
        insert cv;

        // Act
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        inputMap.put('contentDocumentId', cv.ContentDocumentId);
        inputMap.put('fileName', cv.Title);

        Test.startTest();
        Boolean result = new InwiB2C_UTMassiveFile().InvokeMethod('ReadFile', inputMap, outputMap, new Map<String, Object>());
        Test.stopTest();

        // Assert
        System.assert(!result, 'The file should not be processed successfully due to invalid data');
        System.assert(outputMap.containsKey('Message'), 'The output should contain an error message');
        String errorMessage = (String) outputMap.get('Message');
        System.assert(errorMessage.contains('Un des paramètres est manquant'), 'The error message should indicate missing data');
    }

}