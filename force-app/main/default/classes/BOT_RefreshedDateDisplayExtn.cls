/*
Name            : BOT_RefreshedDateDisplayExtn
Created By      : Sreenivasulu A
Created Date    : 10-OCT-2018
Overview        : It is implemented by BusinessOne Technologies Inc.It is a controller class of BOT_RefreshedDateDisplay Visualforce page.
*/
public with sharing class BOT_RefreshedDateDisplayExtn
{
    public Date lastUpdatedDate {get;set;}	//To store the last refreshed date
    public BOT_RefreshedDateDisplayExtn()
    {
        try 
        {
            lastUpdatedDate = [SELECT Id, BOT_Refresh_Date__c FROM BOT_Data_Refresh_Date__c 
                               ORDER BY BOT_Refresh_Date__c DESC NULLS LAST LIMIT 1].BOT_Refresh_Date__c;
        }
        catch(Exception e)
        {
        	system.debug('Exception '+e.getMessage()+ ' found in class BOT_RefreshedDateDisplayExtn at line number '+e.getLineNumber());
        }        
	}
}