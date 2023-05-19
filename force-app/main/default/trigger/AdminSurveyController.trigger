trigger SurveyTrigger on Survey__c (after insert, after update, before delete) {
    //To check if the survey is active or not
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Survey__c s : Trigger.new){
            if(s.Status__c == 'Active'){
                //To set the survey state as Not Started
                s.Survey_State__c = 'Not Started';
                //To set the Start date as today's date
                s.Start_Date__c = System.today();
            }
        }
    }
    //To check if the survey is in started state
    if(Trigger.isUpdate){
        for(Survey__c s : Trigger.new){
            if(s.Survey_State__c == 'Started'){
                //To set the End date as today's date
                s.End_Date__c = System.today();
            }
        }
    }
    //To check if the survey is in Cancelled or Completed state
    if(Trigger.isDelete){
        for(Survey__c s : Trigger.old){
            //To set the Survey State as Cancelled or Completed
            s.Survey_State__c = 'Cancelled';
        }
    }
}