global class BOT_DeleteAllBatch implements Database.Batchable<SObject>{
	
    global Iterable<SObject> start(Database.BatchableContext bc) {
        Iterable<SObject> iterableList = (Iterable<SObject>) new BOT_customIterable();
        return iterableList;
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> lstRecords) {
        
        //To hold the list of error messages
        List<BOT_Error_Tracking_on_Mass_Delete__c> lstErrorTracking = new List<BOT_Error_Tracking_on_Mass_Delete__c>();
        BOT_Error_Tracking_on_Mass_Delete__c objErrorTracking;			//To hold an error message
		
        //To perform bulk delete operation
        Database.DeleteResult[] result = Database.delete(lstRecords, false);

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
    
    global void finish(Database.BatchableContext bc) {
        
    }
}