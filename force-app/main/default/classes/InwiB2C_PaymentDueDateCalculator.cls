public with sharing class InwiB2C_PaymentDueDateCalculator {
    public static Date calculateDueDate(Date effectiveDate) {
        if (effectiveDate == null) {
            return null;
        }
        
        // Ajouter 30 jours
        Date dueDate = effectiveDate.addDays(30);

        // Vérification pour éviter les dates invalides (ex. : 31 février)
        Integer year = dueDate.year();
        Integer month = dueDate.month();
        Integer day = dueDate.day();
        
        // Obtenir le dernier jour valide du mois
        Integer lastDayOfMonth = Date.daysInMonth(year, month);
        
        // Ajuster la date si nécessaire
        if (day > lastDayOfMonth) {
            dueDate = Date.newInstance(year, month, lastDayOfMonth);
        }

        return dueDate;
    }
}