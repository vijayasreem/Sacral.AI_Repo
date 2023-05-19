trigger SurveyTrigger on Survey__c (after insert, after update) {
    //Create a set of surveys Ids
    Set<Id> surveyIds = new Set<Id>();
    for(Survey__c s : Trigger.new){
        surveyIds.add(s.Id);
    }
    //Query for all the active Surveys
    List<Survey__c> activeSurveys = [SELECT Id, User_Specialty__c, User_Preferences__c, User_Location__c FROM Survey__c WHERE Id IN :surveyIds AND Status__c = 'Active'];
    //Create a map of user Ids and their surveys
    Map<Id, List<Survey__c>> userSurveysMap = new Map<Id, List<Survey__c>>();
    
    //Loop through the active surveys and check if the survey matches the user criteria
    for(Survey__c s : activeSurveys){
        //Create a list of surveys for the user
        List<Survey__c> surveys = new List<Survey__c>();
        //Check if the survey matches the user criteria
        if(s.User_Specialty__c == UserInfo.getUserSpecialty() && s.User_Preferences__c == UserInfo.getUserPreferences() && s.User_Location__c == UserInfo.getUserLocation()){
            surveys.add(s);
            if(userSurveysMap.containsKey(UserInfo.getUserId())){
                surveys.addAll(userSurveysMap.get(UserInfo.getUserId()));
            }
            userSurveysMap.put(UserInfo.getUserId(), surveys);
        }
    }
    //Check if the user has any surveys
    if(userSurveysMap.containsKey(UserInfo.getUserId()) && userSurveysMap.get(UserInfo.getUserId()).size() > 0){
        //Create a list of surveys
        List<Survey__c> userSurveys = userSurveysMap.get(UserInfo.getUserId());
        //Display the surveys to the user
        //Provide a "Skip" option for the user
        //Remove the survey from the list once the user has skipped it
        //Remove the survey from the list once the user has completed it
    }
    //Download survey reports in a downloadable format
    //Query for surveys
    List<Survey__c> surveys = [SELECT Id, User_Specialty__c, User_Preferences__c, User_Location__c FROM Survey__c WHERE Id IN :surveyIds];
    //Create a list of records
    List<List<Object>> records = new List<List<Object>>();
    //Create a list of headers
    List<Object> headers = new List<Object>();
    //Add headers to the list
    headers.add('Id');
    headers.add('User_Specialty__c');
    headers.add('User_Preferences__c');
    headers.add('User_Location__c');
    //Add headers to the records
    records.add(headers);
    //Loop through the surveys and add the details to the list
    for(Survey__c s : surveys){
        List<Object> fields = new List<Object>();
        fields.add(s.Id);
        fields.add(s.User_Specialty__c);
        fields.add(s.User_Preferences__c);
        fields.add(s.User_Location__c);
        records.add(fields);
    }
    //Create a CSV file
    String csvFile = '';
    //Loop through the list and add the data to the CSV file
    for(List<Object> row : records){
        for(Object cell : row){
            csvFile += String.valueOf(cell) + ',';
        }
        csvFile += '\n';
    }
    //Create a Blob from the CSV file
    Blob csvBlob = Blob.valueOf(csvFile);
    //Call the method to download the file
    downloadSurveyReport(csvBlob);
}

public static void downloadSurveyReport(Blob reportData) {
    //Create a new attachment
    Attachment a = new Attachment();
    a.Name = 'Survey Report.csv';
    a.Body = reportData;
   