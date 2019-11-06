/*
Name            : BOT_AccountTrigger
Created By      : Sreenivasulu A
Created Date    : 05-SEP-2018
Overview        : This trigger is written by BusinessOne Technologies Inc. It is used to update Record type Ids by the Account type (channel) and
update the salesforce parent Ids for the affiliated plans.                 
*/
trigger BOT_AccountTrigger on Account (before insert, before update) 
{
    if(trigger.isBefore)
    {
        List<Account> lstAccounts = new List<Account>();        	//To store the list of Accounts where Entity Id and Account type not Null
        List<Account> lstAffiliateAccounts = new List<Account>();	//To store the list of Accounts where Entity Id and Account type not Null
        Set<Integer> setEntityParentIds = new Set<Integer>();		//To store the BOT parent Entity ID's
        
        if(trigger.isInsert)
        {
            for(Account objAccount : trigger.new)
            {
                //To verify record belongs to BOT or not
                if(objAccount.BOT_Is_BOT_Data__c == true)
                {
                    //Validating the required field value 
                    if(String.isNotBlank(objAccount.Account_Type__c))
                    {
                        if(objAccount.BOT_Entity_ID__c != null || objAccount.BOT_Person_ID__c != null)
                        {
                            //Creating the list of valid Account records
                            lstAccounts.add(objAccount);
                        }
                        
                        //Validating the Account is affiliate or not
                        if(objAccount.BOT_Parent_Entity_ID__c != null)
                        {
                            //Creating a set of parent entity Ids
                            setEntityParentIds.add(Integer.valueOf(objAccount.BOT_Parent_Entity_ID__c));
                            //Creating the list of valid affiliate Account records
                            lstAffiliateAccounts.add(objAccount);
                        }
                    }
                    else
                    {
                        objAccount.addError('Account type field is mandatory for BOT records');
                    }
                }
            }
        }
        
        if(trigger.isUpdate)
        {
            Integer intRecordsCount = trigger.old.size();
            for(Integer i = 0; i < intRecordsCount; i++)
            {
                //To verify record belongs to BOT or not
                if(trigger.new[i].BOT_Is_BOT_Data__c == true)
                {
                    //Validating the required field value 
                    if(String.isNotBlank(trigger.new[i].Account_Type__c))
                    {
                        if(trigger.old[i].Account_Type__c != trigger.new[i].Account_Type__c)
                        {
                            //Creating the list of Account records where Account type is updated
                            lstAccounts.add(trigger.new[i]);    
                        }
                    }
                    else
                    {
                        trigger.new[i].addError('Account type field is mandatory for BOT records');
                    }
                    if(trigger.old[i].BOT_Parent_Entity_ID__c != trigger.new[i].BOT_Parent_Entity_ID__c)
                    {
                        //Creating a set of parent entity Ids where Parent Entity Id is updated
                        setEntityParentIds.add(Integer.valueOf(trigger.new[i].BOT_Parent_Entity_ID__c));
                        //Creating the list of valid affiliate Account records where Parent Entity Id is updated
                        lstAffiliateAccounts.add(trigger.new[i]);    
                    }
                }
            }
        }
        
        //Calling a handler class method when the list is having at least 1 record.
        //To update the RecordtypeId
        if(lstAccounts.size() > 0 && lstAccounts != null)
        {
            BOT_AccountTriggerHandler.updateRecordtypeID(lstAccounts);   
        }
        
        //To populate the SFDC parent ID
        if(lstAffiliateAccounts.size() > 0 && lstAffiliateAccounts != null)
        {
            BOT_AccountTriggerHandler.updateParentID(lstAffiliateAccounts, setEntityParentIds);   
        }
    }
}