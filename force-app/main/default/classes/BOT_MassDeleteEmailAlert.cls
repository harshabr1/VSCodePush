/*
Name            : BOT_MassDeleteEmailAlert 
Created By      : Sreenivasulu A
Created Date    : 10-MAY-2019
Overview        : This class is written by BusinessOne Technologies Inc. It is used to create an email of Mass delete page status.
*/
public class BOT_MassDeleteEmailAlert 
{
    //To clear the previos data from the BOT_Maintenance_page_data custom settings object.
    public static void clearMaintenancePageData() 
    {
        List<BOT_Maintenance_Page_Data__c> lstMaintenancePageData = BOT_Maintenance_Page_Data__c.getAll().values();
        if(lstMaintenancePageData != null)
        {
            try {
                delete lstMaintenancePageData;
            }
            catch(Exception e) {
                system.debug('Exception '+e.getMessage()+ ' found in class BOT_MassDeleteCtrl at line number '+e.getLineNumber());
            }
        }
    }
    
    //To insert a record on BOT_Maintenance_page_data custom settings object.
    public static void insertObjectDetails(String strObjectLabel, Integer intRecordCount)
    {
        BOT_Maintenance_Page_Data__c objMaintenancePageData = new BOT_Maintenance_Page_Data__c();
        objMaintenancePageData.Name = strObjectLabel;
        objMaintenancePageData.BOT_Total_Records__c = intRecordCount;
        objMaintenancePageData.BOT_Status__c = 'In Progress';
        
        try {
            insert objMaintenancePageData;
        }
        catch(Exception e) {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_MassDeleteCtrl at line number '+e.getLineNumber());
        }
    }
    
    //To update a record on BOT_Maintenance_page_data custom settings object.
    public static void updateObjectDetails(String strObjectLabel, Integer intErrorRecordCount)
    {
        BOT_Maintenance_Page_Data__c objMaintenancePageData = BOT_Maintenance_Page_Data__c.getValues(strObjectLabel);
        objMaintenancePageData.BOT_No_of_Success_Records__c = objMaintenancePageData.BOT_Total_Records__c - intErrorRecordCount;
        objMaintenancePageData.BOT_No_of_Errors__c = intErrorRecordCount;
        objMaintenancePageData.BOT_Status__c = 'Completed';
        
        try {
            //To update the object name and total records into a custom settings object.
            update objMaintenancePageData;
        }
        catch(Exception e) {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_MassDeleteBatch at line number '+e.getLineNumber());
        }
    }
    
    //When user try to delete all objects data
    //Send an email to the Apex job's submitter notifying of job completion.
    public static void deleteAllEmailAlert(String strUserEmail, String strUserName)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[] {strUserEmail};
            
            String emailBody = '<html><head><h3>Hi '+strUserName+'</h3><style>table, th, td {border: 1px solid black; border-collapse: collapse;}' +
            'th, td {padding: 15px;}</style></head><body>' +
            '<p><h4>Please find the following details:</h4></p>' +
            '<table style="width:60%">' +
            '<tr><th>Object Name</th><th>Total Records Processed</th><th>No of Success</th><th>No of Errors</th></tr>';
        
        for(BOT_Maintenance_Page_Data__c objMaintenancePageData : [SELECT Id, Name, BOT_Total_Records__c, BOT_No_of_Success_Records__c, BOT_No_of_Errors__c FROM BOT_Maintenance_Page_Data__c ORDER BY Name])
        {
            emailBody = emailBody + '<tr><td>'+objMaintenancePageData.Name+'</td>' +
                '<td>'+ Integer.valueOf(objMaintenancePageData.BOT_Total_Records__c)+'</td>' +
                '<td>'+ Integer.valueOf(objMaintenancePageData.BOT_No_of_Success_Records__c)+'</td>' +
                '<td>'+ Integer.valueOf(objMaintenancePageData.BOT_No_of_Errors__c)+'</td></tr>';
        }
        emailBody = emailBody + '</table><br/><br/><h4>Thanks & Regards,<br/>BOT Support Team.</h4></body></html>';
        
        mail.setToAddresses(toAddress);
        mail.setSubject('Data Deletion process is completed');
        mail.setHtmlBody(emailBody);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    //When user try to delete all a specified object data
    //Send an email to the Apex job's submitter notifying of job completion.
    public static void deleteSpecifiedEmailAlert(String strUserEmail, String strUserName, String strSObjectLabel, Integer intRecordCount, Integer intErrorRecordCount)
    {
        Integer intSuccessRecordCount = intRecordCount - intErrorRecordCount;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[] {strUserEmail};
            
            String emailBody = '<html><head><h3>Hi '+strUserName+'</h3><style>table, th, td {border: 1px solid black; border-collapse: collapse;}' +
            'th, td {padding: 15px;}</style></head><body>' +
            '<p><h4>Please find the following details:</h4></p>' +
            '<table style="width:60%">' +
            '<tr><th>Object Name</th><th>Total Records Processed</th><th>No of Success</th><th>No of Errors</th></tr>' +
            '<tr><td>'+strSObjectLabel+'</td><td>'+intRecordCount+'</td><td>'+intSuccessRecordCount+'</td>' +
            '<td>'+intErrorRecordCount+'</td></tr></table><br/><br/><h4>Thanks & Regards,<br/>BOT Support Team.</h4></body></html>';
        
        mail.setToAddresses(toAddress);
        mail.setSubject(strSObjectLabel + ' object data is deleted Successfully');
        mail.setHtmlBody(emailBody);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}