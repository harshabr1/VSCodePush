/*
Name            : BOT_TheraClassTrigger
Created By      : Sreenivasulu A
Created Date    : 25-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is used to populate the related SFDC Account ID 
				  by comparing the BOT Specialty Provider ID (Entity ID) filed.
*/
trigger BOT_TheraClassTrigger on BOT_Thera_Class__c (before insert) 
{
    if(trigger.isBefore && trigger.isInsert)
    {
        Set<Integer> setSpecialtyProviderIds = new Set<Integer>();                  //To store BOT Specialty Provider Ids
        List<BOT_Thera_Class__c> lstTheraClass = new List<BOT_Thera_Class__c>();    //to store a list of Thera class records
        
        for(BOT_Thera_Class__c objTheraClass : trigger.new)
        {
            //Validating the required field value
            if(objTheraClass.BOT_Specialty_Provider_ID__c != null)
            {
                //Creating a set of BOT Specialty Provider Ids
                setSpecialtyProviderIds.add(Integer.valueOf(objTheraClass.BOT_Specialty_Provider_ID__c));
                //Creating a list of valid Specialty Provider records
                lstTheraClass.add(objTheraClass);
            }
            else
            {
                objTheraClass.addError('Specialty provider Id field is mandatory to save the record');
            }
        }
        
        //Calling a handler class method when the list is having at least 1 record.
        if(lstTheraClass.size() > 0)
        {
            BOT_TheraClassTriggerHandler.populateSpecialtyProviderIds(lstTheraClass, setSpecialtyProviderIds); 
        }
    }
}