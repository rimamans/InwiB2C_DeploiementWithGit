/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class InwiB2C_Schedule_SDPRequestBatchJob  implements Schedulable {

        public void execute(SchedulableContext context) {
            InwB2C_SDPRequestBatchJob batch = new InwB2C_SDPRequestBatchJob();
            Database.executeBatch(batch);
        }
      
    }