/*
Name            : BOT_ManageInactiveAccounts 
Created By      : Sreenivasulu A
Created Date    : 29-MAY-2019
Overview        : This class is written by BusinessOne Technologies Inc. It is used to handle the Inactive Accounts and Child Accounts.
If An Account is deleted in payerback bone then we use the following criteria to make the Account as Inactive/Delete.
1. If the Account is having associated Account plans or calls then make it inactive.
2. If the Account don't have any associated Account plans or calls then delete it.
*/
public class BOT_ManageInactiveAccounts 
{
    @InvocableMethod
    public static void manageInactiveAccounts()
    {
        List<Account_Plan_vod__c> lstAccountPlans;          //To store Account plans which are associated to inactive/delated Accounts 
        List<Call2_vod__c> lstCalls;                        //To store Calls which are associated to inactive/deleted Accounts
        Set<ID> setAccountIds = new Set<ID>();              //To store the Account Ids which are inactive/deleted in PBB
        Set<ID> setAccountIdsToInactive = new Set<ID>();    //To store the Account Ids that are inactive/deleted in PBB and having associated Account plans or calls
        List<Account> lstAccountToBeDelete;                 //To store the list of Accounts which are required to delete
        List<Account> lstAccountsToBeInactive;              //To store the list of Accounts which are required to inactive
        
        //To get latest refresh date from the Data refresh date object
        Date refreshDate = [SELECT BOT_Refresh_Date__c FROM BOT_Data_Refresh_Date__c ORDER BY BOT_Refresh_Date__c DESC LIMIT 1].BOT_Refresh_Date__c;
        
        //To get the Account Ids which are inactive/deleted in PBB
        for(Account objAccount : [SELECT Id FROM Account WHERE BOT_Is_BOT_Data__c = TRUE 
                                  AND Account_Type__c NOT IN ('IDN','ACO','Hospital') 
                                  AND (BOT_Refresh_Date__c <: refreshDate OR BOT_Refresh_Date__c = NULL) LIMIT 50000])
        {
            setAccountIds.add(objAccount.Id);   
        }
        
        //To clear the previous data from the BOT_Inactive_Account__c custom settings object
        if(setAccountIds != null)
        {
            BOT_ManageInactiveAccData.clearInactiveAccountData();   
            
            //To get the Account plans which are assocaited to inactive/deleted Accounts
            lstAccountPlans = [SELECT Account_vod__c FROM Account_Plan_vod__c WHERE Account_vod__c IN : setAccountIds LIMIT 50000];
            if(lstAccountPlans != null && lstAccountPlans.size() > 0)
            {
                for(Account_Plan_vod__c objAccountPlan: lstAccountPlans)
                {
                    //To Create the set of Account Ids which are inactive/deleted and having associated Accounts Plans
                    setAccountIdsToInactive.add(objAccountPlan.Account_vod__c);
                }    
            }
            
            //To get the Calls which are assocaited to inactive/deleted Accounts
            lstCalls = [SELECT Account_vod__c FROM Call2_vod__c WHERE Account_vod__c IN : setAccountIds LIMIT 50000];
            if(lstCalls != null && lstCalls.size() > 0)
            {            
                for(Call2_vod__c objCall: lstCalls)
                {
                    //To Add the set of Account Ids which are inactive/deleted and having associated Calls
                    setAccountIdsToInactive.add(objCall.Account_vod__c);
                }
            }
            
            //To get the count of inactive in PBB and having associated Account plans or calls
            Integer intAccountsToBeInactive = [SELECT count() FROM Account WHERE Id IN : setAccountIdsToInactive];
            
            //To get the count of are inactive in PBB and not having associated Account plans or calls
            Integer intAccountToBeDelete = [SELECT count() FROM Account WHERE Id NOT IN : setAccountIdsToInactive AND Id IN : setAccountIds];
            
            if(intAccountsToBeInactive > 0)
            {
                //To get the Accounts that are inactive in PBB and having associated Account plans or calls
                lstAccountsToBeInactive = [SELECT BOT_Is_Active__c FROM Account WHERE Id IN : setAccountIdsToInactive LIMIT 10000];
                for(Account objAccount : lstAccountsToBeInactive)
                {
                    objAccount.BOT_Is_Active__c = false;
                }
                
                try {
                    Database.update(lstAccountsToBeInactive,false);
                }
                catch(Exception e) {
                    System.debug('Exception '+e.getMessage()+ ' found in class BOT_ManageInactiveAccounts at line number '+e.getLineNumber());
                }
                
                //To create the Inactive Account records in BOT_Inactive_Account__c custom settings object
                lstAccountsToBeInactive = [SELECT Id, Name, BOT_Is_Active__c, Account_Type__c FROM Account 
                                           WHERE Id IN : setAccountIdsToInactive AND BOT_Is_Active__c = FALSE LIMIT 10000];
                BOT_ManageInactiveAccData.createInactiveAccountsData(lstAccountsToBeInactive, 'Inactive');
            }
            
            if(intAccountToBeDelete > 0)
            {
                //To get the Accounts that are deleted in PBB and not having associated Account plans or calls
                lstAccountToBeDelete = [SELECT Id, Name, Account_Type__c FROM Account 
                                        WHERE Id NOT IN : setAccountIdsToInactive AND Id IN : setAccountIds LIMIT 10000];
                
                //To create the Deleted Account records in BOT_Inactive_Account__c custom settings object
                BOT_ManageInactiveAccData.createInactiveAccountsData(lstAccountToBeDelete, 'Deleted');
                
                try {
                    Database.delete(lstAccountToBeDelete,false);
                }
                
                catch(Exception e) {
                    System.debug('Exception '+e.getMessage()+ ' found in class BOT_ManageInactiveAccounts at line number '+e.getLineNumber());
                }
                
                try {
                    //To get the Accounts which were fail to delete
                    lstAccountToBeDelete = [SELECT Id, Name, Account_Type__c FROM Account 
                                            WHERE Id NOT IN : setAccountIdsToInactive AND Id IN : setAccountIds LIMIT 10000];
                }
                catch(Exception e) {
                    System.debug('Exception '+e.getMessage()+ ' found in class BOT_ManageInactiveAccounts at line number '+e.getLineNumber());
                }
                
                //Validating if any records fail to delete
                if(lstAccountToBeDelete != Null && lstAccountToBeDelete.size() > 0)
                {
                    //If any record fail to delete then update status in custom settings object
                    BOT_ManageInactiveAccData.updateInactiveAccountsData(lstAccountToBeDelete, 'Error : Unable to delete this Account');
                }
            }
            
            //To send An email alert to the current user with a list of Accounts that has been Inactivated/Deleted
            if(intAccountsToBeInactive > 0 || intAccountToBeDelete > 0)
            {
                BOT_ManageInactiveAccData.sendAnEmail();    
            }
        }
    }
}