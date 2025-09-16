public with sharing class SystemFacade {

        @TestVisible
        private static Boolean isFuture = false;
    
       @TestVisible
        private static Boolean isBatch = false;

        public static Boolean isFuture() {
            return (Test.isRunningTest()) ? isFuture : System.isFuture();
        }
    
        public static Boolean isBatch() {
            return (Test.isRunningTest()) ? isBatch : System.isBatch();
        }
}