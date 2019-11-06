/*
Name            : BOT_ManageInactiveAccounts 
Created By      : Sreenivasulu A
Created Date    : 29-MAY-2019
Overview        : This class is written by BusinessOne Technologies Inc. It is used to handle the Inactive Accounts.
                  If An Account is deleted in payerback bone then we will follow the following criteria.
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
        
        //To get the Account Ids which are inactive/deleted in PBB
        //Critria is where created date not equal to today and last modifieddate not equal to today and Should be bot record and not in Person Account, IDN, ACO, Hospital.
        for(Account objAccount : [SELECT Id FROM Account WHERE createddate != TODAY AND lastModifieddate != TODAY AND BOT_Is_BOT_Data__c = TRUE 
                                  AND Account_Type__c NOT IN ('IDN','ACO','Hospital')])
        {
            setAccountIds.add(objAccount.Id);   
        }
        
        //To clear the previous data from the BOT_Inactive_Account__c custom settings object
        if(setAccountIds != null)
        {
            clearInactiveAccountData();    
        
        	//To get the Account plans which are assocaited to inactive/deleted Accounts
        	lstAccountPlans = [SELECT Account_vod__c FROM Account_Plan_vod__c WHERE Account_vod__c IN : setAccountIds];
        	if(lstAccountPlans != null && lstAccountPlans.size() > 0)
        	{
            	for(Account_Plan_vod__c objAccountPlan: lstAccountPlans)
            	{
                	//To Create the set of Account Ids which are inactive/deleted and having associated Accounts Plans
                	setAccountIdsToInactive.add(objAccountPlan.Account_vod__c);
            	}    
        	}
            
        	//To get the Calls which are assocaited to inactive/deleted Accounts
        	lstCalls = [SELECT Account_vod__c FROM Call2_vod__c WHERE Account_vod__c IN : setAccountIds];
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
            	lstAccountsToBeInactive = [SELECT BOT_Is_Active__c FROM Account WHERE Id IN : setAccountIdsToInactive];
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
            	lstAccountsToBeInactive = [SELECT Id, Name, BOT_Is_Active__c, Account_Type__c FROM Account WHERE Id IN : setAccountIdsToInactive AND BOT_Is_Active__c = FALSE];
            	createInactiveAccountsData(lstAccountsToBeInactive, 'Inactive');
        	}
        
        	if(intAccountToBeDelete > 0)
        	{
            	//To get the Accounts that are deleted in PBB and not having associated Account plans or calls
            	lstAccountToBeDelete = [SELECT Id, Name, Account_Type__c FROM Account WHERE Id NOT IN : setAccountIdsToInactive AND Id IN : setAccountIds];
            
            	//To create the Deleted Account records in BOT_Inactive_Account__c custom settings object
            	createInactiveAccountsData(lstAccountToBeDelete, 'Deleted');
            
            	try {
        			Database.delete(lstAccountToBeDelete,false);
    			}
			      	
        		catch(Exception e) {
        			System.debug('Exception '+e.getMessage()+ ' found in class BOT_ManageInactiveAccounts at line number '+e.getLineNumber());
        		}
                
                try {
                	//To get the Accounts which were fail to delete
            		lstAccountToBeDelete = [SELECT Id, Name, Account_Type__c FROM Account WHERE Id NOT IN : setAccountIdsToInactive AND Id IN : setAccountIds];
                }
                catch(Exception e) {
        			System.debug('Exception '+e.getMessage()+ ' found in class BOT_ManageInactiveAccounts at line number '+e.getLineNumber());
        		}
            
            	//Validating if any records fail to delete
            	if(lstAccountToBeDelete != Null && lstAccountToBeDelete.size() > 0)
            	{
                	//If any record fail to delete then update status in custom settings object
                	updateInactiveAccountsData(lstAccountToBeDelete, 'Error : Unable to delete this Account');
            	}
        	}
        
        	//To send An email alert to the current user with a list of Accounts that has been Inactivated/Deleted
        	if(intAccountsToBeInactive > 0 || intAccountToBeDelete > 0)
        	{
            	sendAnEmail();    
        	}
    	}
    }
    
    //To create the Inactive/Deleted Account records in BOT_Inactive_Account__c custom settings object
    public static void createInactiveAccountsData(List<Account> lstAccounts, String strStatus)
    {
        List<BOT_Inactive_Account__c> lstInactiveAccount = new List<BOT_Inactive_Account__c>();
        BOT_Inactive_Account__c objInactiveAccount;
        for(Account objAccount : lstAccounts)
        {
            objInactiveAccount = new BOT_Inactive_Account__c();
            objInactiveAccount.Name = objAccount.Name;
            //objInactiveAccount.BOT_Entity_ID__c = objAccount.BOT_Entity_ID__c;
            objInactiveAccount.BOT_Account_Type__c = objAccount.Account_Type__c;
            objInactiveAccount.BOT_Account_Status__c = strStatus;
            lstInactiveAccount.add(objInactiveAccount);
        }
        try {
        	Database.insert(lstInactiveAccount,false);
        }
        catch(Exception e) {
        	System.debug('Exception '+e.getMessage()+ ' found in class BOT_ManageInactiveAccounts at line number '+e.getLineNumber());
        }
    }
    
    //If any Account is fail to delete
    //To update the Inactive/Deleted Account records in BOT_Inactive_Account__c custom settings object
    public static void updateInactiveAccountsData(List<Account> lstAccounts, String strStatus)
    {
        List<BOT_Inactive_Account__c> lstInactiveAccount; 	//To store the Inactive Account custom settings object data
        set<String> setAccountName = new set<String>();		//To store the Account names which are fail to delete
        for(Account objAccount : lstAccounts)
		{
			if(objAccount.Name != null)
            {
                setAccountName.add(objAccount.Name);
            }
		}
        
        if(setAccountName != null)
        {
        	lstInactiveAccount = [SELECT Id, Name, BOT_Account_Status__c FROM BOT_Inactive_Account__c WHERE Name IN : setAccountName];
            for(BOT_Inactive_Account__c objInactiveAccount : lstInactiveAccount)
            {
                objInactiveAccount.BOT_Account_Status__c = strStatus;
            }
        }
		try {
        	update lstInactiveAccount;
        }
        catch(Exception e) {
        	System.debug('Exception '+e.getMessage()+ ' found in class BOT_ManageInactiveAccounts at line number '+e.getLineNumber());
        }
    }
    
    //To send an Email alert
    public static void sendAnEmail()
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String strUserName = UserInfo.getUserEmail();
        String[] toAddress = new String[] {strUserName};
        String emailBody = '<html><head><h3>Hi '+UserInfo.getName() +'</h3><style>table, th, td {border: 1px solid black; border-collapse: collapse;}' +
            'th, td {padding: 15px;}</style></head><body>' +
            '<p><h4>Please find the following details:</h4></p>' +
            '<table style="width:60%">' +
            '<tr><th>Account Name</th><th>Account Type</th><th>Status</th></tr>';
        
        //To get the list of Inactive/Deleted Accounts data from BOT_Inactive_Account__c custom settings object
        List<BOT_Inactive_Account__c> lstInactiveAccount = [SELECT Name, BOT_Account_Status__c, BOT_Account_Type__c FROM BOT_Inactive_Account__c ORDER BY BOT_Account_Status__c, Name];
        
        for(BOT_Inactive_Account__c objInactiveAccount : lstInactiveAccount)
        {
            emailBody = emailBody + '<tr><td>'+objInactiveAccount.Name+'</td>' +
                        '<td>'+ objInactiveAccount.BOT_Account_Type__c+'</td>' +
                        '<td>'+ objInactiveAccount.BOT_Account_Status__c+'</td></tr>';
        }
        emailBody = emailBody + '</table><br/><br/><h4>Thanks & Regards,<br/>BOT Support Team.</h4></body></html>';
        
        mail.setToAddresses(toAddress);
        mail.setSubject('Inactive Accounts are managed successfully');
        mail.setHtmlBody(emailBody);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    //To cleat the previous data from BOT_Inactive_Account__c custom settings object
    public static void clearInactiveAccountData() 
    {
        List<BOT_Inactive_Account__c> lstInactiveAccount = BOT_Inactive_Account__c.getAll().values();
        if(lstInactiveAccount != null)
        {
            try {
                delete lstInactiveAccount;
            }
            catch(Exception e) {
                System.debug('Exception '+e.getMessage()+ ' found in class BOT_ManageInactiveAccounts at line number '+e.getLineNumber());
            }
        }
    }
}