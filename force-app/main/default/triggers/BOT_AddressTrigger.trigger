/*
Name            : BOT_AddressTrigger
Created By      : Sreenivasulu A
Created Date    : 06-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc.It is used to populate the SFDC Account ID, SFDC Person ID by comparing BOT Entity ID, BOT Person ID.
				  It also updates the Record type Id.

Modified By     :Harsha BR
Modified date   :14-SEP-2018
Reason          :Added comments and modified the code to follow the salesforce standard best practices.
*/
trigger BOT_AddressTrigger on Address_vod__c (before insert) 
{
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
	if(p.Id != UserInfo.getProfileId())
    {
    	return;    
    }
   	
    else if(trigger.isBefore && trigger.isInsert)
    {
        List<Address_vod__c> lstAccountAddress = new List<Address_vod__c>();	//To store a list of Address records associated to Plans
        List<Address_vod__c> lstPersonAddress = new List<Address_vod__c>();		//To store a list of Address records associated to Key Persons
        Set<Integer> setAccountIds = new Set<Integer>();                		//To store unique BOT Entity Ids
        Set<Integer> setPersonIds = new Set<Integer>();                			//To store unique BOT Person Ids
        
        for(Address_vod__c objAddress : trigger.new)
        {
            //Validating the BOT Entity ID field value 
            if(objAddress.BOT_Entity_ID__c != null)
            {
                //Creating the set of Person Ids
                setAccountIds.add(Integer.valueOf(objAddress.BOT_Entity_ID__c));
                //Creating the list of valid Account Address records
                lstAccountAddress.add(objAddress);
            }
            
            //Validating the BOT Person ID field value 
            if(objAddress.BOT_Person_ID__c != null)
            {
                //Creating the set of Person Ids
                setPersonIds.add(Integer.valueOf(objAddress.BOT_Person_ID__c));
                //Creating the list of valid Person Address records
                lstPersonAddress.add(objAddress);
            }
        }
        
        //Calling a handler class method when the list is having at least 1 record.
        //To populate the SFDC Account ID on 
        if(lstAccountAddress.size() > 0)
        {
            BOT_AddressTriggerHandler.populateAccountId(lstAccountAddress, setAccountIds);  
        }
        
        if(lstPersonAddress.size() > 0)
        {
            BOT_AddressTriggerHandler.populatePersonId(lstPersonAddress, setPersonIds);  
        }
    }
}