/*
Name			: BOT_MassDeleteBatch 
Created By		: Sreenivasulu A
Created Date	: 11-JAN-2019
Overview		: This class is written by BusinessOne Technologies Inc. It performs delete operation from a specified object/All objects.
*/
global class BOT_MassDeleteBatch implements Database.Batchable<sobject>, Database.Stateful
{
	global String queryString;				//To store the query string
    global Boolean blnIsDeleteAll;			//It indcates the user performed the Delete All or Delete a specified object.
    global Integer intRecordCount;			//To store total records count
    global String strSObjectLabel;			//To store the label name of the object
    
    //Constructor
    global BOT_MassDeleteBatch(String query, Boolean DeleteAll, Integer recordCount, String objectLabel)
    {
        //Copying query string
        queryString = query;
        blnIsDeleteAll = DeleteAll;
        intRecordCount = recordCount;
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
        
        //To get the records which are fail to delete
        List<SObject> lstRecords = Database.query(queryString);
		
        if(lstRecords != null)
        {
            intErrorRecordCount = lstRecords.size(); 
        }
        
        //Verifying how many records present in the DB. 
        if(intErrorRecordCount != 0)
        {
            //If record count morethan 0 then call anoter batch to delete remaining records.
            BOT_MassDeleteBatchFinish clsMassDeleteFinish = new BOT_MassDeleteBatchFinish(queryString, blnIsDeleteAll, strSObjectLabel);
            Database.executeBatch(clsMassDeleteFinish, 100);
        }
		
        //If the user try to delete the data from a specified object
       	else if(blnIsDeleteAll == false)
        {
            //Query the AsyncApexJob object to retrieve the current job's information.
            AsyncApexJob apexJob = [SELECT CreatedBy.Email, CreatedBy.Name FROM AsyncApexJob WHERE Id =: BC.getJobId()];
        	
            //Send an email to the Apex job's submitter notifying of job completion.
            BOT_MassDeleteEmailAlert.deleteSpecifiedEmailAlert(apexJob.CreatedBy.Email, apexJob.CreatedBy.Name, strSObjectLabel, intRecordCount, intErrorRecordCount);
		}
        
        //If the user try to delete the data from all objects
        else if(blnIsDeleteAll == true)
        {
        	//To update the current object details on BOT_Maintenance_page_data custom settings object.
            BOT_MassDeleteEmailAlert.updateObjectDetails(strSObjectLabel, intErrorRecordCount);
            
            //Benefit Design Line and Plan-Product Formulary JO objects are having Master-Detail relationship with Benefit design object
            //Deletion of Benefit design record will also delete the related child object records
            //To update the Detail object details after deletion of its Master parent
            if(strSObjectLabel == 'Benefit Design')
            {
            	intErrorRecordCount = [SELECT count() FROM Benefit_Design_Line_vod__c WHERE BOT_Is_BOT_Data__c = true];
                BOT_MassDeleteEmailAlert.updateObjectDetails('Benefit Design Line', intErrorRecordCount);    
                
                intErrorRecordCount = [SELECT Count() FROM BOT_Product_Formulary_JO__c];
                BOT_MassDeleteEmailAlert.updateObjectDetails('Plan-Product Formulary JO', intErrorRecordCount);
                
                //Plan-Product Formulary JO object is a juntion object between Benefit Design and Plan Product
                //There might be a change to get 'Unable to lock the record error' when both the parent objects are trying to delete the same child
                //To avoid that Plan product records are processing after completion of Benefit design deletion process.
                intErrorRecordCount = [SELECT Count() FROM BOT_Plan_Product__c];
                BOT_MassDeleteBatch clsMassDeleteBatch = new BOT_MassDeleteBatch('SELECT Id FROM BOT_Plan_Product__c', blnIsDeleteAll, intErrorRecordCount, 'Plan Product');
        		Database.executeBatch(clsMassDeleteBatch);
            }
                        
            //To get the batch job status from BOT_Maintenance_page_data custom settings object.
            intRecordCount = [SELECT count() FROM BOT_Maintenance_Page_Data__c WHERE BOT_Status__c = 'In Progress'];
            
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