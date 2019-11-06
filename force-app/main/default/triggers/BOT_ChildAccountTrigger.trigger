/*
Name            : BOT_ChildAccountTrigger
Created By      : Sreenivasulu A
Created Date    : 05-DEC-2018
Overview        : This trigger is written by BusinessOne Technologies Inc. 
                  1. It is used to pull the SFDC Account Id and SFDC Person Account ID (Contact ID)
                  from Account object and update in child Account object.
                  2. Also populates the External Id Veeva field
                
*/
trigger BOT_ChildAccountTrigger on Child_Account_vod__c (before insert) 
{
    List<Child_Account_vod__c> lstChildAccount = new List<Child_Account_vod__c>();          //To store a list of Child Accounts where affiliate Account is Business Account(MCO)
    List<Child_Account_vod__c> lstPersonChildAccount = new List<Child_Account_vod__c>();    //To store a list of Child Accounts where affiliate Account is Person Account
    Set<Integer> setEntityIds = new Set<Integer>();                                         //To store unique BOT Account Ids where Parent and Affiliates are PBM/MCO
    Set<Integer> setParentAccountIds = new Set<Integer>();                                  //To store unique BOT Account Ids where Affiliate is BOT Person Account
    Set<Integer> setAffiliatePersonIds = new Set<Integer>();                                //To store unique BOT Person Account Ids
    
    for(Child_Account_vod__c objChildAccount : Trigger.new)
    {
        //Validating the Parent Account ID
        if(objChildAccount.BOT_Parent_Account_ID__c != null)
        {
            //If the BOT Affiliate Account Id not null then Child Account is a MCO
            if(objChildAccount.BOT_Affiliate_Account_ID__c != null)
            {
                //Creating a list of valid Child Account(MCO) records
                lstChildAccount.add(objChildAccount);
                setEntityIds.add(Integer.valueOf(objChildAccount.BOT_Parent_Account_ID__c));
                setEntityIds.add(Integer.valueOf(objChildAccount.BOT_Affiliate_Account_ID__c));
            }
            
            //If the BOT Person Id not null then Child Account is a Person Account
            if(objChildAccount.BOT_Person_ID__c != null)
            {
                //Creating a list of valid Child Account(MCO) records
                lstPersonChildAccount.add(objChildAccount);
                setParentAccountIds.add(Integer.valueOf(objChildAccount.BOT_Parent_Account_ID__c));
                setAffiliatePersonIds.add(Integer.valueOf(objChildAccount.BOT_Person_ID__c));
            }
        }
    }
    
    //Calling helper class method where list have atleast one record
    if(lstChildAccount.size() > 0 && lstChildAccount != null)
    {
        BOT_ChildAccountTriggerHandler.updateParentAndAffiliateIds(lstChildAccount, setEntityIds);  
    }
    
    if(lstPersonChildAccount.size() > 0 && lstPersonChildAccount != null)
    {
        BOT_ChildAccountTriggerHandler.updateParentAndPersonIds(lstPersonChildAccount, setParentAccountIds, setAffiliatePersonIds);  
    }    
}