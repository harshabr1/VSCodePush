/*
Name            : BOT_PharmacyServicesTrigger
Created By      : Sreenivasulu A
Created Date    : 07-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is used to populate the SFDC Account ID by comparing BOT Entity ID.
				  It also creates junction object records (Account to PBM linking) on child account object.
*/

trigger BOT_PharmacyServicesTrigger on BOT_Pharmacy_Service__c (before insert) 
{
    if(trigger.isInsert)
    {
        //To populate the SFDC Entity ID by comparing BOT Entity ID.
        if(trigger.isBefore)
        {
    		Set<Integer> setBOTAccountIds = new Set<Integer>();		//To store the BOT Entity IDs
       		List<BOT_Pharmacy_Service__c> lstPharmacyServices = new List<BOT_Pharmacy_Service__c>();	//To store the list of pharmacy service records
        
    		//Creating the set of BOT entity Ids and PBM Ids
    		for(BOT_Pharmacy_Service__c objPharmacyService : trigger.new)
    		{
    			//To validate required Entity ID filed
    			//To create a set of BOT Entity IDs where Entity ID is not null
                if(objPharmacyService.BOT_Entity_ID__c != Null)
        		{
        			setBOTAccountIds.add(Integer.valueOf(objPharmacyService.BOT_Entity_ID__c));
                	lstPharmacyServices.add(objPharmacyService);
            	}
            	else
            	{
                	objPharmacyService.addError('Entity Id field is mandatory to save the record');
            	}
            	
                //To create a set of BOT PBM IDs where PBM ID is not null
                if(objPharmacyService.BOT_PBM_ID__c != Null)
            	{
            		setBOTAccountIds.add(Integer.valueOf(objPharmacyService.BOT_PBM_ID__c));
				}
			}
        
        	//Calling a handler class method when the list is having at least 1 record.
       	 	if(lstPharmacyServices.size() > 0)
        	{
        		BOT_PharmacyServicesTriggerHandler.populateAccountAndPbmIds(lstPharmacyServices, setBOTAccountIds);     
        	}
        }
    }
}