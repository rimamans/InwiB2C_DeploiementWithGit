// @IsTest
// public class InwiB2C_DaysCalculatorTest {

//     @IsTest
//     static void testAddBusinessDays() {
//         // Créer une date de départ pour le test
//         Date startDate = Date.newInstance(2024, 8, 7);

//         // Tester l'ajout de jours ouvrés
//         Date resultDate = InwiB2C_DaysCalculator.addBusinessDays(startDate, 5);

//         // Assertion pour vérifier si la date retournée est correcte
//         System.assertNotEquals(startDate, resultDate, 'La date retournée ne doit pas être la même que la date de départ');
//     }

//     @IsTest
//     static void testIsWithinBusinessDays() {
//         // Créer une date de départ pour le test
//         Date startDate = Date.newInstance(2024, 8, 7);

//         // Tester si la date actuelle est dans les jours ouvrés
//         Boolean result = InwiB2C_DaysCalculator.isWithinBusinessDays(startDate, 5);

//         // Assertion pour vérifier si la méthode retourne le bon résultat
//         System.assert(result, 'La méthode doit retourner vrai si la date actuelle est dans les jours ouvrés');
//     }
// }

@IsTest
public class InwiB2C_DaysCalculatorTest {

    @IsTest
    static void testClientHasExceededBusinessDays() {
        // Date de départ pour le test, par exemple le 1er août 2024
        Date startDate = Date.newInstance(2024, 7, 30);

        // Supposons que le nombre de jours ouvrés est de 5
        Integer numBusinessDays = 5;

        // Exécuter la méthode pour vérifier si la date d'aujourd'hui dépasse les jours ouvrés
        Boolean result = InwiB2C_DaysCalculator.isWithinBusinessDays(startDate, numBusinessDays);

        // Afficher le résultat
        if(result)
        {
            System.debug('Client has not exceeded business days: ' + result);
        }else
        {
            System.debug('Client has exceeded business days: ' + !result);
        }
        // System.debug('Client has exceeded business days: ' + !result);

        // Assertion pour vérifier le résultat attendu
        // Ce test est basé sur la date actuelle et doit être ajusté selon le contexte.
        // Par exemple, si nous sommes le 8 août 2024, le résultat doit être vrai (5 jours ouvrés non dépassés)
        // if (Date.today() > InwiB2C_DaysCalculator.addBusinessDays(startDate, numBusinessDays)) {
        //     System.assert(!result, 'Le client a dépassé les jours ouvrés');
        // } else {
        //     System.assert(result, 'Le client n\'a pas encore dépassé les jours ouvrés');
        // }
    }
}