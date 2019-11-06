/*
Name            : BOT_ManageInactiveAccData 
Created By      : Sreenivasulu A
Created Date    : 20-SEP-2019
Overview        : This class is written by BusinessOne Technologies Inc. 
                  1. It is used to Insert/Update/Delete the Inactive/Deleted Account records in custom settings object.
                  2. To send an email alert on completion of Managing Inactive Account records.
*/
public class BOT_ManageInactiveAccData {
    //To create the Inactive/Deleted Account records in BOT_Inactive_Account__c custom settings object
    public static void createInactiveAccountsData(List<Account> lstAccounts, String strStatus)
    {
        List<BOT_Inactive_Account__c> lstInactiveAccount = new List<BOT_Inactive_Account__c>();
        BOT_Inactive_Account__c objInactiveAccount;
        for(Account objAccount : lstAccounts)
        {
            objInactiveAccount = new BOT_Inactive_Account__c();
            objInactiveAccount.Name = objAccount.Name;
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
        List<BOT_Inactive_Account__c> lstInactiveAccount;   //To store the Inactive Account custom settings object data
        set<String> setAccountName = new set<String>();     //To store the Account names which are fail to delete
        for(Account objAccount : lstAccounts)
        {
            if(objAccount.Name != null)
            {
                setAccountName.add(objAccount.Name);
            }
        }
        
        if(setAccountName != null)
        {
            lstInactiveAccount = [SELECT Id, Name, BOT_Account_Status__c FROM BOT_Inactive_Account__c 
                                  WHERE Name IN : setAccountName LIMIT 10000];
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
        String[] toAddress = new String[] {UserInfo.getUserEmail()};
        String emailBody = '<html><head><h3>Hi '+ UserInfo.getName() +
                           ',</h3><style>table, th, td {border: 1px solid black; border-collapse: collapse;}' +
                           'th, td {padding: 15px;}</style></head><body>' +
                           '<p><h4>Please find the following details:</h4></p>' +
                           '<table style="width:60%">' +
                           '<tr><th>Account Name</th><th>Account Type</th><th>Status</th></tr>';
        
        //To get the list of Inactive/Deleted Accounts data from BOT_Inactive_Account__c custom settings object
        List<BOT_Inactive_Account__c> lstInactiveAccount = [SELECT Name, BOT_Account_Status__c, BOT_Account_Type__c 
                                                            FROM BOT_Inactive_Account__c ORDER BY BOT_Account_Status__c, Name 
                                                            LIMIT 10000];
        
        for(BOT_Inactive_Account__c objInactiveAccount : lstInactiveAccount)
        {
            emailBody = emailBody + '<tr><td>'+objInactiveAccount.Name+'</td>' +
                        '<td>'+ objInactiveAccount.BOT_Account_Type__c+'</td>' +
                        '<td>'+ objInactiveAccount.BOT_Account_Status__c+'</td></tr>';
        }
        emailBody = emailBody + '</table><br/><br/><h4>Thanks & Regards,<br/>BOT Support Team.</h4></body></html>';
        
        mail.setToAddresses(toAddress);
        mail.setSubject('Inactive Accounts are managed successfully - ' + UserInfo.getUserName().substringAfterLast('.'));
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