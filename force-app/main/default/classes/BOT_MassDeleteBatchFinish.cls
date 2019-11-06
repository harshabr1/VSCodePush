/*
Name			: BOT_MassDeleteBatchFinish 
Created By		: Sreenivasulu A
Created Date	: 22-JAN-2019
Overview		: This class is written by BusinessOne Technologies Inc. This Batch class invoke when Mass DeleteBatch is fail to process all records.
We are calling this batch class from the finish method of BOT_MassDeleteBatch.
*/
global class BOT_MassDeleteBatchFinish implements Database.Batchable<sObject>
{
    global String queryString;				//To store the query string
    global Boolean blnIsDeleteAll;			//It indcates the user performed the Delete All or Delete a specified object.
    global String strSObjectLabel;			//To store the label name of the object
    
    global BOT_MassDeleteBatchFinish(String query, Boolean isDeleteAll, String objectLabel)
    {
        queryString = query;
        blnIsDeleteAll = isDeleteAll;
        strSObjectLabel = objectLabel;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(queryString);   
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> lstRecords)
    {
        //To delete the records
        Database.DeleteResult[] result = Database.delete(lstRecords, false);

        //To hold the list of error messages
        List<BOT_Error_Tracking_on_Mass_Delete__c> lstErrorTracking = new List<BOT_Error_Tracking_on_Mass_Delete__c>();
        BOT_Error_Tracking_on_Mass_Delete__c objErrorTracking;			//To hold an error message
		
        //Iterating the result
        for(Database.DeleteResult res : result)
        {
       		//If status is not success then create error record and insert it into BOT_Error_Tracking_on_Mass_Delete__c object
            if(!res.isSuccess())
            {
				for(Database.Error err : res.getErrors())
                {
                	objErrorTracking = new BOT_Error_Tracking_on_Mass_Delete__c();
                    objErrorTracking.Name = res.getId();
                    objErrorTracking.BOT_Error_Message__c = err.getMessage();
                    lstErrorTracking.add(objErrorTracking);
                }
            }
        }
        
        if(lstErrorTracking != Null && lstErrorTracking.size() > 0)
        {
            Database.insert(lstErrorTracking,false);
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        Integer intErrorRecordCount = 0;	//To store the error reocrd count

        List<SObject> lstRecords = Database.query(queryString);
		if(lstRecords != null)
        {
            intErrorRecordCount = lstRecords.size(); 
        }
		
        //If the user try to delete the data from all objects
        if(blnIsDeleteAll == true)
        {
            //To update the current object details on BOT_Maintenance_page_data custom settings object.
            BOT_MassDeleteEmailAlert.updateObjectDetails(strSObjectLabel, intErrorRecordCount);
            
            //To update the Detail object details after deletion of its Master parent
            if(strSObjectLabel == 'Benefit Design')
            {
            	intErrorRecordCount = [SELECT count() FROM Benefit_Design_Line_vod__c WHERE BOT_Is_BOT_Data__c = true];
                BOT_MassDeleteEmailAlert.updateObjectDetails('Benefit Design Line', intErrorRecordCount);    
                
                intErrorRecordCount = [SELECT Count() FROM BOT_Product_Formulary_JO__c];
                BOT_MassDeleteEmailAlert.updateObjectDetails('Plan-Product Formulary JO', intErrorRecordCount);
            }
            
            //To get the batch job status from BOT_Maintenance_page_data custom settings object.
            Integer intRecordCount = [SELECT count() FROM BOT_Maintenance_Page_Data__c WHERE BOT_Status__c = 'In Progress'];
            
            //If the status is completed
            if(intRecordCount == 0)
            {
                //Query the AsyncApexJob object to retrieve the current job's information.
   				AsyncApexJob apexJob = [SELECT CreatedBy.Email, CreatedBy.Name FROM AsyncApexJob WHERE Id =: BC.getJobId()];
        	
                //Send an email to the Apex job's submitter notifying of job completion.
                BOT_MassDeleteEmailAlert.deleteAllEmailAlert(apexJob.CreatedBy.Email, apexJob.CreatedBy.Name);
            }
        }
    }
}