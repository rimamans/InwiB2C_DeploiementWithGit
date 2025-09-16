public class InwiB2C_DaysCalculator {
    public static Date addBusinessDays(Date startDate, Integer numBusinessDays) {
        Date currentDate = startDate;//6/8/2024
        Integer addedDays = 0;

        Set<Date> holidays = new Set<Date>();
        for (InwiB2C_Holidays__c holiday : [SELECT inwib2c_date__c FROM InwiB2C_Holidays__c]) {
            holidays.add(holiday.inwib2c_date__c);
        }

        while (addedDays < numBusinessDays) {//5  start date = 1
            currentDate = currentDate.addDays(1);
            if (isWorkingDay(currentDate, holidays)) {
                addedDays++;
            }
        }
        return currentDate;
    }
    // elle va me renvoyer le deadline ou le client pourra effectuer le statut satisfait ou remboursé

    public static Boolean isWithinBusinessDays(Date startDate, Integer numBusinessDays) {
        Date endDate = addBusinessDays(startDate, numBusinessDays);
        return Date.today() <= endDate;
    }

    private static Boolean isWorkingDay(Date inputDate, Set<Date> holidays) {
        DateTime dateTimeE = DateTime.newInstance(inputDate.year(), inputDate.month(), inputDate.day());
        Integer dayOfWeek = Integer.valueOf(dateTimeE.format('u'));
        Boolean isWeekend = (dayOfWeek == 6 || dayOfWeek == 7);
        Boolean isHoliday = holidays.contains(inputDate);

        return !isWeekend && !isHoliday;
    }
}