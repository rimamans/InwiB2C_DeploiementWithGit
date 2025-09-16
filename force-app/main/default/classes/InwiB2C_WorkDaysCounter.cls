global class InwiB2C_WorkDaysCounter { 

    public static Integer countTotalDaysForWorkingDays(DateTime inputDateTime) {
        Set<Date> holidays = getHolidays(inputDateTime.date());
        DateTime endDateTime = DateTime.now(); 
        Integer totalHours = 0;
        DateTime currentDateTime = inputDateTime;

        while (currentDateTime.date() <= endDateTime.date()) {
            if (isWorkingDay(currentDateTime.date(), holidays)) {
                if (currentDateTime.date() == endDateTime.date()) {
                    totalHours += endDateTime.hour() - currentDateTime.hour();
                } else {
                    totalHours += 24;
                }
            }
            currentDateTime = currentDateTime.addDays(1).addHours(-currentDateTime.hour());
        }

        return totalHours;
    }

    private static Set<Date> getHolidays(Date inputDate) {
        Set<Date> holidays = new Set<Date>();
        Date todayDate = Date.today();
        for (InwiB2C_Holidays__c holiday : [SELECT inwib2c_date__c FROM InwiB2C_Holidays__c WHERE inwib2c_date__c >= :inputDate AND inwib2c_date__c <= :todayDate]) {
            holidays.add(holiday.inwib2c_date__c);
        }
        return holidays;
    }

    private static Boolean isWorkingDay(Date inputDate, Set<Date> holidays) {
        DateTime dateTimeE = DateTime.newInstance(inputDate.year(), inputDate.month(), inputDate.day());
        Integer dayOfWeek = Integer.valueOf(dateTimeE.format('u'));
        Boolean isWeekend = (dayOfWeek == 6 || dayOfWeek == 7);
        Boolean isHoliday = holidays.contains(inputDate);

        return !isWeekend && !isHoliday;
    }
}