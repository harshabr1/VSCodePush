/*
Name            : BOT_SpecialtyProviderJoTrigger
Created By      : Sreenivasulu A
Created Date    : 06-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc.It is used to populate the SFDC Entity ID and SFDC Specialty provider ID
				  by comparing BOT Entity ID.
*/

trigger BOT_SpecialtyProviderJoTrigger on BOT_Specialty_Provider_JO__c (before insert) 
{
    if(trigger.isBefore && trigger.isInsert)
    {
        Set<Integer> setAccountIds = new Set<Integer>();			//To store BOT Entity ID's
        List<BOT_Specialty_Provider_JO__c> lstSpecialtyProviderJO = new List<BOT_Specialty_Provider_JO__c>();	//To store a list of junction object records
        
        for(BOT_Specialty_Provider_JO__c objSpecilatyProviderJo : trigger.new)
        {
       		//Validating the required field values 
            if(objSpecilatyProviderJo.BOT_Entity_ID__c != null && objSpecilatyProviderJo.BOT_Specialty_Provider_ID__c != null)
            {
            	//Creating a set of BOT Entity Ids and Specialty provider IDs
                setAccountIds.add(Integer.valueOf(objSpecilatyProviderJo.BOT_Entity_ID__c));
            	setAccountIds.add(Integer.valueOf(objSpecilatyProviderJo.BOT_Specialty_Provider_ID__c));
                //Creating a list of valid records
                lstSpecialtyProviderJO.add(objSpecilatyProviderJo);
            }
            else
            {
            	objSpecilatyProviderJo.addError('Entity Id and Specialty provider ID fields are mandatory to save the record');
            }
        }
        
        //Calling a handler class method when the list is having at least 1 record.
        if(lstSpecialtyProviderJO.size() > 0)
        {
        	BOT_SpecialtyProviderJoTriggerHandler.populateAccountAndSpecialtyProviderIds(lstSpecialtyProviderJO, setAccountIds);       
        }
    }   
}